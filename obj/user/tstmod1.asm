
obj/user/tstmod1:     file format elf32-i386


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
  800031:	e8 22 06 00 00       	call   800658 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 c4 80             	add    $0xffffff80,%esp
	int envID = sys_getenvid();
  800040:	e8 30 20 00 00       	call   802075 <sys_getenvid>
  800045:	89 45 ec             	mov    %eax,-0x14(%ebp)
	rsttst();
  800048:	e8 d3 23 00 00       	call   802420 <rsttst>
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  80004d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800050:	89 d0                	mov    %edx,%eax
  800052:	c1 e0 03             	shl    $0x3,%eax
  800055:	01 d0                	add    %edx,%eax
  800057:	01 c0                	add    %eax,%eax
  800059:	01 d0                	add    %edx,%eax
  80005b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800062:	01 d0                	add    %edx,%eax
  800064:	c1 e0 03             	shl    $0x3,%eax
  800067:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	int Mega = 1024*1024;
  80006f:	c7 45 e4 00 00 10 00 	movl   $0x100000,-0x1c(%ebp)
	int kilo = 1024;
  800076:	c7 45 e0 00 04 00 00 	movl   $0x400,-0x20(%ebp)
	void* ptr_allocations[20] = {0};
  80007d:	8d 55 84             	lea    -0x7c(%ebp),%edx
  800080:	b9 14 00 00 00       	mov    $0x14,%ecx
  800085:	b8 00 00 00 00       	mov    $0x0,%eax
  80008a:	89 d7                	mov    %edx,%edi
  80008c:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80008e:	e8 94 20 00 00       	call   802127 <sys_calculate_free_frames>
  800093:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  800096:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800099:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80009c:	83 ec 0c             	sub    $0xc,%esp
  80009f:	50                   	push   %eax
  8000a0:	e8 b2 14 00 00       	call   801557 <malloc>
  8000a5:	83 c4 10             	add    $0x10,%esp
  8000a8:	89 45 84             	mov    %eax,-0x7c(%ebp)
		tst((uint32) ptr_allocations[0], USER_HEAP_START,USER_HEAP_START + PAGE_SIZE, 'b', 0);
  8000ab:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	6a 00                	push   $0x0
  8000b3:	6a 62                	push   $0x62
  8000b5:	68 00 10 00 80       	push   $0x80001000
  8000ba:	68 00 00 00 80       	push   $0x80000000
  8000bf:	50                   	push   %eax
  8000c0:	e8 75 23 00 00       	call   80243a <tst>
  8000c5:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 256+1 ,0, 'e', 0);
  8000c8:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8000cb:	e8 57 20 00 00       	call   802127 <sys_calculate_free_frames>
  8000d0:	29 c3                	sub    %eax,%ebx
  8000d2:	89 d8                	mov    %ebx,%eax
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	6a 00                	push   $0x0
  8000d9:	6a 65                	push   $0x65
  8000db:	6a 00                	push   $0x0
  8000dd:	68 01 01 00 00       	push   $0x101
  8000e2:	50                   	push   %eax
  8000e3:	e8 52 23 00 00       	call   80243a <tst>
  8000e8:	83 c4 20             	add    $0x20,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000eb:	e8 37 20 00 00       	call   802127 <sys_calculate_free_frames>
  8000f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  8000f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f6:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8000f9:	83 ec 0c             	sub    $0xc,%esp
  8000fc:	50                   	push   %eax
  8000fd:	e8 55 14 00 00       	call   801557 <malloc>
  800102:	83 c4 10             	add    $0x10,%esp
  800105:	89 45 88             	mov    %eax,-0x78(%ebp)
		tst((uint32) ptr_allocations[1], USER_HEAP_START + 1*Mega,USER_HEAP_START + 1*Mega + PAGE_SIZE, 'b', 0);
  800108:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80010b:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  800111:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800114:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  80011a:	8b 45 88             	mov    -0x78(%ebp),%eax
  80011d:	83 ec 0c             	sub    $0xc,%esp
  800120:	6a 00                	push   $0x0
  800122:	6a 62                	push   $0x62
  800124:	51                   	push   %ecx
  800125:	52                   	push   %edx
  800126:	50                   	push   %eax
  800127:	e8 0e 23 00 00       	call   80243a <tst>
  80012c:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 256 ,0, 'e', 0);
  80012f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800132:	e8 f0 1f 00 00       	call   802127 <sys_calculate_free_frames>
  800137:	29 c3                	sub    %eax,%ebx
  800139:	89 d8                	mov    %ebx,%eax
  80013b:	83 ec 0c             	sub    $0xc,%esp
  80013e:	6a 00                	push   $0x0
  800140:	6a 65                	push   $0x65
  800142:	6a 00                	push   $0x0
  800144:	68 00 01 00 00       	push   $0x100
  800149:	50                   	push   %eax
  80014a:	e8 eb 22 00 00       	call   80243a <tst>
  80014f:	83 c4 20             	add    $0x20,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800152:	e8 d0 1f 00 00       	call   802127 <sys_calculate_free_frames>
  800157:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  80015a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80015d:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800160:	83 ec 0c             	sub    $0xc,%esp
  800163:	50                   	push   %eax
  800164:	e8 ee 13 00 00       	call   801557 <malloc>
  800169:	83 c4 10             	add    $0x10,%esp
  80016c:	89 45 8c             	mov    %eax,-0x74(%ebp)
		tst((uint32) ptr_allocations[2], USER_HEAP_START + 2*Mega,USER_HEAP_START + 2*Mega + PAGE_SIZE, 'b', 0);
  80016f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800172:	01 c0                	add    %eax,%eax
  800174:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  80017a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80017d:	01 c0                	add    %eax,%eax
  80017f:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800185:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	6a 00                	push   $0x0
  80018d:	6a 62                	push   $0x62
  80018f:	51                   	push   %ecx
  800190:	52                   	push   %edx
  800191:	50                   	push   %eax
  800192:	e8 a3 22 00 00       	call   80243a <tst>
  800197:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 256 ,0, 'e', 0);
  80019a:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80019d:	e8 85 1f 00 00       	call   802127 <sys_calculate_free_frames>
  8001a2:	29 c3                	sub    %eax,%ebx
  8001a4:	89 d8                	mov    %ebx,%eax
  8001a6:	83 ec 0c             	sub    $0xc,%esp
  8001a9:	6a 00                	push   $0x0
  8001ab:	6a 65                	push   $0x65
  8001ad:	6a 00                	push   $0x0
  8001af:	68 00 01 00 00       	push   $0x100
  8001b4:	50                   	push   %eax
  8001b5:	e8 80 22 00 00       	call   80243a <tst>
  8001ba:	83 c4 20             	add    $0x20,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8001bd:	e8 65 1f 00 00       	call   802127 <sys_calculate_free_frames>
  8001c2:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  8001c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001c8:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001cb:	83 ec 0c             	sub    $0xc,%esp
  8001ce:	50                   	push   %eax
  8001cf:	e8 83 13 00 00       	call   801557 <malloc>
  8001d4:	83 c4 10             	add    $0x10,%esp
  8001d7:	89 45 90             	mov    %eax,-0x70(%ebp)
		tst((uint32) ptr_allocations[3], USER_HEAP_START + 3*Mega,USER_HEAP_START + 3*Mega + PAGE_SIZE, 'b', 0);
  8001da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001dd:	89 c2                	mov    %eax,%edx
  8001df:	01 d2                	add    %edx,%edx
  8001e1:	01 d0                	add    %edx,%eax
  8001e3:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8001e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ec:	89 c2                	mov    %eax,%edx
  8001ee:	01 d2                	add    %edx,%edx
  8001f0:	01 d0                	add    %edx,%eax
  8001f2:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8001f8:	8b 45 90             	mov    -0x70(%ebp),%eax
  8001fb:	83 ec 0c             	sub    $0xc,%esp
  8001fe:	6a 00                	push   $0x0
  800200:	6a 62                	push   $0x62
  800202:	51                   	push   %ecx
  800203:	52                   	push   %edx
  800204:	50                   	push   %eax
  800205:	e8 30 22 00 00       	call   80243a <tst>
  80020a:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 256 ,0, 'e', 0);
  80020d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800210:	e8 12 1f 00 00       	call   802127 <sys_calculate_free_frames>
  800215:	29 c3                	sub    %eax,%ebx
  800217:	89 d8                	mov    %ebx,%eax
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	6a 00                	push   $0x0
  80021e:	6a 65                	push   $0x65
  800220:	6a 00                	push   $0x0
  800222:	68 00 01 00 00       	push   $0x100
  800227:	50                   	push   %eax
  800228:	e8 0d 22 00 00       	call   80243a <tst>
  80022d:	83 c4 20             	add    $0x20,%esp

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800230:	e8 f2 1e 00 00       	call   802127 <sys_calculate_free_frames>
  800235:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  800238:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80023b:	01 c0                	add    %eax,%eax
  80023d:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800240:	83 ec 0c             	sub    $0xc,%esp
  800243:	50                   	push   %eax
  800244:	e8 0e 13 00 00       	call   801557 <malloc>
  800249:	83 c4 10             	add    $0x10,%esp
  80024c:	89 45 94             	mov    %eax,-0x6c(%ebp)
		tst((uint32) ptr_allocations[4], USER_HEAP_START + 4*Mega,USER_HEAP_START + 4*Mega + PAGE_SIZE, 'b', 0);
  80024f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800252:	c1 e0 02             	shl    $0x2,%eax
  800255:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  80025b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80025e:	c1 e0 02             	shl    $0x2,%eax
  800261:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800267:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	6a 00                	push   $0x0
  80026f:	6a 62                	push   $0x62
  800271:	51                   	push   %ecx
  800272:	52                   	push   %edx
  800273:	50                   	push   %eax
  800274:	e8 c1 21 00 00       	call   80243a <tst>
  800279:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 512+1 ,0, 'e', 0);
  80027c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80027f:	e8 a3 1e 00 00       	call   802127 <sys_calculate_free_frames>
  800284:	29 c3                	sub    %eax,%ebx
  800286:	89 d8                	mov    %ebx,%eax
  800288:	83 ec 0c             	sub    $0xc,%esp
  80028b:	6a 00                	push   $0x0
  80028d:	6a 65                	push   $0x65
  80028f:	6a 00                	push   $0x0
  800291:	68 01 02 00 00       	push   $0x201
  800296:	50                   	push   %eax
  800297:	e8 9e 21 00 00       	call   80243a <tst>
  80029c:	83 c4 20             	add    $0x20,%esp

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  80029f:	e8 83 1e 00 00       	call   802127 <sys_calculate_free_frames>
  8002a4:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  8002a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002aa:	01 c0                	add    %eax,%eax
  8002ac:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002af:	83 ec 0c             	sub    $0xc,%esp
  8002b2:	50                   	push   %eax
  8002b3:	e8 9f 12 00 00       	call   801557 <malloc>
  8002b8:	83 c4 10             	add    $0x10,%esp
  8002bb:	89 45 98             	mov    %eax,-0x68(%ebp)
		tst((uint32) ptr_allocations[5], USER_HEAP_START + 6*Mega,USER_HEAP_START + 6*Mega + PAGE_SIZE, 'b', 0);
  8002be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002c1:	89 d0                	mov    %edx,%eax
  8002c3:	01 c0                	add    %eax,%eax
  8002c5:	01 d0                	add    %edx,%eax
  8002c7:	01 c0                	add    %eax,%eax
  8002c9:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8002cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002d2:	89 d0                	mov    %edx,%eax
  8002d4:	01 c0                	add    %eax,%eax
  8002d6:	01 d0                	add    %edx,%eax
  8002d8:	01 c0                	add    %eax,%eax
  8002da:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8002e0:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002e3:	83 ec 0c             	sub    $0xc,%esp
  8002e6:	6a 00                	push   $0x0
  8002e8:	6a 62                	push   $0x62
  8002ea:	51                   	push   %ecx
  8002eb:	52                   	push   %edx
  8002ec:	50                   	push   %eax
  8002ed:	e8 48 21 00 00       	call   80243a <tst>
  8002f2:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 512 ,0, 'e', 0);
  8002f5:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8002f8:	e8 2a 1e 00 00       	call   802127 <sys_calculate_free_frames>
  8002fd:	29 c3                	sub    %eax,%ebx
  8002ff:	89 d8                	mov    %ebx,%eax
  800301:	83 ec 0c             	sub    $0xc,%esp
  800304:	6a 00                	push   $0x0
  800306:	6a 65                	push   $0x65
  800308:	6a 00                	push   $0x0
  80030a:	68 00 02 00 00       	push   $0x200
  80030f:	50                   	push   %eax
  800310:	e8 25 21 00 00       	call   80243a <tst>
  800315:	83 c4 20             	add    $0x20,%esp

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800318:	e8 0a 1e 00 00       	call   802127 <sys_calculate_free_frames>
  80031d:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  800320:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800323:	89 c2                	mov    %eax,%edx
  800325:	01 d2                	add    %edx,%edx
  800327:	01 d0                	add    %edx,%eax
  800329:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80032c:	83 ec 0c             	sub    $0xc,%esp
  80032f:	50                   	push   %eax
  800330:	e8 22 12 00 00       	call   801557 <malloc>
  800335:	83 c4 10             	add    $0x10,%esp
  800338:	89 45 9c             	mov    %eax,-0x64(%ebp)
		tst((uint32) ptr_allocations[6], USER_HEAP_START + 8*Mega,USER_HEAP_START + 8*Mega + PAGE_SIZE, 'b', 0);
  80033b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80033e:	c1 e0 03             	shl    $0x3,%eax
  800341:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  800347:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80034a:	c1 e0 03             	shl    $0x3,%eax
  80034d:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800353:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800356:	83 ec 0c             	sub    $0xc,%esp
  800359:	6a 00                	push   $0x0
  80035b:	6a 62                	push   $0x62
  80035d:	51                   	push   %ecx
  80035e:	52                   	push   %edx
  80035f:	50                   	push   %eax
  800360:	e8 d5 20 00 00       	call   80243a <tst>
  800365:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 768+1 ,0, 'e', 0);
  800368:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80036b:	e8 b7 1d 00 00       	call   802127 <sys_calculate_free_frames>
  800370:	29 c3                	sub    %eax,%ebx
  800372:	89 d8                	mov    %ebx,%eax
  800374:	83 ec 0c             	sub    $0xc,%esp
  800377:	6a 00                	push   $0x0
  800379:	6a 65                	push   $0x65
  80037b:	6a 00                	push   $0x0
  80037d:	68 01 03 00 00       	push   $0x301
  800382:	50                   	push   %eax
  800383:	e8 b2 20 00 00       	call   80243a <tst>
  800388:	83 c4 20             	add    $0x20,%esp

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80038b:	e8 97 1d 00 00       	call   802127 <sys_calculate_free_frames>
  800390:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  800393:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800396:	89 c2                	mov    %eax,%edx
  800398:	01 d2                	add    %edx,%edx
  80039a:	01 d0                	add    %edx,%eax
  80039c:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80039f:	83 ec 0c             	sub    $0xc,%esp
  8003a2:	50                   	push   %eax
  8003a3:	e8 af 11 00 00       	call   801557 <malloc>
  8003a8:	83 c4 10             	add    $0x10,%esp
  8003ab:	89 45 a0             	mov    %eax,-0x60(%ebp)
		tst((uint32) ptr_allocations[7], USER_HEAP_START + 11*Mega,USER_HEAP_START + 11*Mega + PAGE_SIZE, 'b', 0);
  8003ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003b1:	89 d0                	mov    %edx,%eax
  8003b3:	c1 e0 02             	shl    $0x2,%eax
  8003b6:	01 d0                	add    %edx,%eax
  8003b8:	01 c0                	add    %eax,%eax
  8003ba:	01 d0                	add    %edx,%eax
  8003bc:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8003c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003c5:	89 d0                	mov    %edx,%eax
  8003c7:	c1 e0 02             	shl    $0x2,%eax
  8003ca:	01 d0                	add    %edx,%eax
  8003cc:	01 c0                	add    %eax,%eax
  8003ce:	01 d0                	add    %edx,%eax
  8003d0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8003d6:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8003d9:	83 ec 0c             	sub    $0xc,%esp
  8003dc:	6a 00                	push   $0x0
  8003de:	6a 62                	push   $0x62
  8003e0:	51                   	push   %ecx
  8003e1:	52                   	push   %edx
  8003e2:	50                   	push   %eax
  8003e3:	e8 52 20 00 00       	call   80243a <tst>
  8003e8:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 768+1 ,0, 'e', 0);
  8003eb:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8003ee:	e8 34 1d 00 00       	call   802127 <sys_calculate_free_frames>
  8003f3:	29 c3                	sub    %eax,%ebx
  8003f5:	89 d8                	mov    %ebx,%eax
  8003f7:	83 ec 0c             	sub    $0xc,%esp
  8003fa:	6a 00                	push   $0x0
  8003fc:	6a 65                	push   $0x65
  8003fe:	6a 00                	push   $0x0
  800400:	68 01 03 00 00       	push   $0x301
  800405:	50                   	push   %eax
  800406:	e8 2f 20 00 00       	call   80243a <tst>
  80040b:	83 c4 20             	add    $0x20,%esp
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80040e:	e8 14 1d 00 00       	call   802127 <sys_calculate_free_frames>
  800413:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[1]);
  800416:	8b 45 88             	mov    -0x78(%ebp),%eax
  800419:	83 ec 0c             	sub    $0xc,%esp
  80041c:	50                   	push   %eax
  80041d:	e8 d7 1a 00 00       	call   801ef9 <free>
  800422:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 256,0, 'e', 0);
  800425:	e8 fd 1c 00 00       	call   802127 <sys_calculate_free_frames>
  80042a:	89 c2                	mov    %eax,%edx
  80042c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80042f:	29 c2                	sub    %eax,%edx
  800431:	89 d0                	mov    %edx,%eax
  800433:	83 ec 0c             	sub    $0xc,%esp
  800436:	6a 00                	push   $0x0
  800438:	6a 65                	push   $0x65
  80043a:	6a 00                	push   $0x0
  80043c:	68 00 01 00 00       	push   $0x100
  800441:	50                   	push   %eax
  800442:	e8 f3 1f 00 00       	call   80243a <tst>
  800447:	83 c4 20             	add    $0x20,%esp

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80044a:	e8 d8 1c 00 00       	call   802127 <sys_calculate_free_frames>
  80044f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[4]);
  800452:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800455:	83 ec 0c             	sub    $0xc,%esp
  800458:	50                   	push   %eax
  800459:	e8 9b 1a 00 00       	call   801ef9 <free>
  80045e:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 512,0, 'e', 0);
  800461:	e8 c1 1c 00 00       	call   802127 <sys_calculate_free_frames>
  800466:	89 c2                	mov    %eax,%edx
  800468:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80046b:	29 c2                	sub    %eax,%edx
  80046d:	89 d0                	mov    %edx,%eax
  80046f:	83 ec 0c             	sub    $0xc,%esp
  800472:	6a 00                	push   $0x0
  800474:	6a 65                	push   $0x65
  800476:	6a 00                	push   $0x0
  800478:	68 00 02 00 00       	push   $0x200
  80047d:	50                   	push   %eax
  80047e:	e8 b7 1f 00 00       	call   80243a <tst>
  800483:	83 c4 20             	add    $0x20,%esp

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800486:	e8 9c 1c 00 00       	call   802127 <sys_calculate_free_frames>
  80048b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[6]);
  80048e:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800491:	83 ec 0c             	sub    $0xc,%esp
  800494:	50                   	push   %eax
  800495:	e8 5f 1a 00 00       	call   801ef9 <free>
  80049a:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 768,0, 'e', 0);
  80049d:	e8 85 1c 00 00       	call   802127 <sys_calculate_free_frames>
  8004a2:	89 c2                	mov    %eax,%edx
  8004a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004a7:	29 c2                	sub    %eax,%edx
  8004a9:	89 d0                	mov    %edx,%eax
  8004ab:	83 ec 0c             	sub    $0xc,%esp
  8004ae:	6a 00                	push   $0x0
  8004b0:	6a 65                	push   $0x65
  8004b2:	6a 00                	push   $0x0
  8004b4:	68 00 03 00 00       	push   $0x300
  8004b9:	50                   	push   %eax
  8004ba:	e8 7b 1f 00 00       	call   80243a <tst>
  8004bf:	83 c4 20             	add    $0x20,%esp
	}
	int cnt = 0;
  8004c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	//[3] Allocate again [test first fit]
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8004c9:	e8 59 1c 00 00       	call   802127 <sys_calculate_free_frames>
  8004ce:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[8] = malloc(512*kilo - kilo);
  8004d1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004d4:	89 d0                	mov    %edx,%eax
  8004d6:	c1 e0 09             	shl    $0x9,%eax
  8004d9:	29 d0                	sub    %edx,%eax
  8004db:	83 ec 0c             	sub    $0xc,%esp
  8004de:	50                   	push   %eax
  8004df:	e8 73 10 00 00       	call   801557 <malloc>
  8004e4:	83 c4 10             	add    $0x10,%esp
  8004e7:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		tst((uint32) ptr_allocations[8], USER_HEAP_START + 1*Mega,USER_HEAP_START + 1*Mega + PAGE_SIZE, 'b', 0);
  8004ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004ed:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8004f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004f6:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8004fc:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004ff:	83 ec 0c             	sub    $0xc,%esp
  800502:	6a 00                	push   $0x0
  800504:	6a 62                	push   $0x62
  800506:	51                   	push   %ecx
  800507:	52                   	push   %edx
  800508:	50                   	push   %eax
  800509:	e8 2c 1f 00 00       	call   80243a <tst>
  80050e:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 128 ,0, 'e', 0);
  800511:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800514:	e8 0e 1c 00 00       	call   802127 <sys_calculate_free_frames>
  800519:	29 c3                	sub    %eax,%ebx
  80051b:	89 d8                	mov    %ebx,%eax
  80051d:	83 ec 0c             	sub    $0xc,%esp
  800520:	6a 00                	push   $0x0
  800522:	6a 65                	push   $0x65
  800524:	6a 00                	push   $0x0
  800526:	68 80 00 00 00       	push   $0x80
  80052b:	50                   	push   %eax
  80052c:	e8 09 1f 00 00       	call   80243a <tst>
  800531:	83 c4 20             	add    $0x20,%esp

		//Expand it
		freeFrames = sys_calculate_free_frames() ;
  800534:	e8 ee 1b 00 00       	call   802127 <sys_calculate_free_frames>
  800539:	89 45 dc             	mov    %eax,-0x24(%ebp)
		realloc(ptr_allocations[8], 512*kilo + 256*kilo - kilo);
  80053c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80053f:	89 d0                	mov    %edx,%eax
  800541:	01 c0                	add    %eax,%eax
  800543:	01 d0                	add    %edx,%eax
  800545:	c1 e0 08             	shl    $0x8,%eax
  800548:	29 d0                	sub    %edx,%eax
  80054a:	89 c2                	mov    %eax,%edx
  80054c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80054f:	83 ec 08             	sub    $0x8,%esp
  800552:	52                   	push   %edx
  800553:	50                   	push   %eax
  800554:	e8 83 1a 00 00       	call   801fdc <realloc>
  800559:	83 c4 10             	add    $0x10,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 64 ,0, 'e', 0);
  80055c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80055f:	e8 c3 1b 00 00       	call   802127 <sys_calculate_free_frames>
  800564:	29 c3                	sub    %eax,%ebx
  800566:	89 d8                	mov    %ebx,%eax
  800568:	83 ec 0c             	sub    $0xc,%esp
  80056b:	6a 00                	push   $0x0
  80056d:	6a 65                	push   $0x65
  80056f:	6a 00                	push   $0x0
  800571:	6a 40                	push   $0x40
  800573:	50                   	push   %eax
  800574:	e8 c1 1e 00 00       	call   80243a <tst>
  800579:	83 c4 20             	add    $0x20,%esp

		int *intArr = (int*) ptr_allocations[8];
  80057c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80057f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int lastIndexOfInt = ((512+256)*kilo)/sizeof(int) - 1;
  800582:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800585:	89 d0                	mov    %edx,%eax
  800587:	01 c0                	add    %eax,%eax
  800589:	01 d0                	add    %edx,%eax
  80058b:	c1 e0 08             	shl    $0x8,%eax
  80058e:	c1 e8 02             	shr    $0x2,%eax
  800591:	48                   	dec    %eax
  800592:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		int i = 0;
  800595:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for (i=0; i < lastIndexOfInt ; i++)
  80059c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005a3:	eb 1a                	jmp    8005bf <_main+0x587>
		{
			cnt++;
  8005a5:	ff 45 f4             	incl   -0xc(%ebp)
			intArr[i] = i ;
  8005a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005b2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005b5:	01 c2                	add    %eax,%edx
  8005b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ba:	89 02                	mov    %eax,(%edx)

		int *intArr = (int*) ptr_allocations[8];
		int lastIndexOfInt = ((512+256)*kilo)/sizeof(int) - 1;

		int i = 0;
		for (i=0; i < lastIndexOfInt ; i++)
  8005bc:	ff 45 f0             	incl   -0x10(%ebp)
  8005bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005c2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8005c5:	7c de                	jl     8005a5 <_main+0x56d>
		{
			cnt++;
			intArr[i] = i ;
		}

		for (i=0; i < lastIndexOfInt ; i++)
  8005c7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005ce:	eb 2a                	jmp    8005fa <_main+0x5c2>
		{
			tst(intArr[i], i,0, 'e', 0);
  8005d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8005d6:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
  8005dd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005e0:	01 ca                	add    %ecx,%edx
  8005e2:	8b 12                	mov    (%edx),%edx
  8005e4:	83 ec 0c             	sub    $0xc,%esp
  8005e7:	6a 00                	push   $0x0
  8005e9:	6a 65                	push   $0x65
  8005eb:	6a 00                	push   $0x0
  8005ed:	50                   	push   %eax
  8005ee:	52                   	push   %edx
  8005ef:	e8 46 1e 00 00       	call   80243a <tst>
  8005f4:	83 c4 20             	add    $0x20,%esp
		{
			cnt++;
			intArr[i] = i ;
		}

		for (i=0; i < lastIndexOfInt ; i++)
  8005f7:	ff 45 f0             	incl   -0x10(%ebp)
  8005fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005fd:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800600:	7c ce                	jl     8005d0 <_main+0x598>
		{
			tst(intArr[i], i,0, 'e', 0);
		}

		freeFrames = sys_calculate_free_frames() ;
  800602:	e8 20 1b 00 00       	call   802127 <sys_calculate_free_frames>
  800607:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[8]);
  80060a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80060d:	83 ec 0c             	sub    $0xc,%esp
  800610:	50                   	push   %eax
  800611:	e8 e3 18 00 00       	call   801ef9 <free>
  800616:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 192 ,0, 'e', 0);
  800619:	e8 09 1b 00 00       	call   802127 <sys_calculate_free_frames>
  80061e:	89 c2                	mov    %eax,%edx
  800620:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800623:	29 c2                	sub    %eax,%edx
  800625:	89 d0                	mov    %edx,%eax
  800627:	83 ec 0c             	sub    $0xc,%esp
  80062a:	6a 00                	push   $0x0
  80062c:	6a 65                	push   $0x65
  80062e:	6a 00                	push   $0x0
  800630:	68 c0 00 00 00       	push   $0xc0
  800635:	50                   	push   %eax
  800636:	e8 ff 1d 00 00       	call   80243a <tst>
  80063b:	83 c4 20             	add    $0x20,%esp
	}


	chktst(23 + cnt);
  80063e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800641:	83 c0 17             	add    $0x17,%eax
  800644:	83 ec 0c             	sub    $0xc,%esp
  800647:	50                   	push   %eax
  800648:	e8 18 1e 00 00       	call   802465 <chktst>
  80064d:	83 c4 10             	add    $0x10,%esp

	return;
  800650:	90                   	nop
}
  800651:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800654:	5b                   	pop    %ebx
  800655:	5f                   	pop    %edi
  800656:	5d                   	pop    %ebp
  800657:	c3                   	ret    

00800658 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800658:	55                   	push   %ebp
  800659:	89 e5                	mov    %esp,%ebp
  80065b:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80065e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800662:	7e 0a                	jle    80066e <libmain+0x16>
		binaryname = argv[0];
  800664:	8b 45 0c             	mov    0xc(%ebp),%eax
  800667:	8b 00                	mov    (%eax),%eax
  800669:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80066e:	83 ec 08             	sub    $0x8,%esp
  800671:	ff 75 0c             	pushl  0xc(%ebp)
  800674:	ff 75 08             	pushl  0x8(%ebp)
  800677:	e8 bc f9 ff ff       	call   800038 <_main>
  80067c:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  80067f:	e8 f1 19 00 00       	call   802075 <sys_getenvid>
  800684:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  800687:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80068a:	89 d0                	mov    %edx,%eax
  80068c:	c1 e0 03             	shl    $0x3,%eax
  80068f:	01 d0                	add    %edx,%eax
  800691:	01 c0                	add    %eax,%eax
  800693:	01 d0                	add    %edx,%eax
  800695:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069c:	01 d0                	add    %edx,%eax
  80069e:	c1 e0 03             	shl    $0x3,%eax
  8006a1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006a6:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  8006a9:	e8 15 1b 00 00       	call   8021c3 <sys_disable_interrupt>
		cprintf("**************************************\n");
  8006ae:	83 ec 0c             	sub    $0xc,%esp
  8006b1:	68 58 28 80 00       	push   $0x802858
  8006b6:	e8 19 01 00 00       	call   8007d4 <cprintf>
  8006bb:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  8006be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006c1:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  8006c7:	83 ec 08             	sub    $0x8,%esp
  8006ca:	50                   	push   %eax
  8006cb:	68 80 28 80 00       	push   $0x802880
  8006d0:	e8 ff 00 00 00       	call   8007d4 <cprintf>
  8006d5:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8006d8:	83 ec 0c             	sub    $0xc,%esp
  8006db:	68 58 28 80 00       	push   $0x802858
  8006e0:	e8 ef 00 00 00       	call   8007d4 <cprintf>
  8006e5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006e8:	e8 f0 1a 00 00       	call   8021dd <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006ed:	e8 19 00 00 00       	call   80070b <exit>
}
  8006f2:	90                   	nop
  8006f3:	c9                   	leave  
  8006f4:	c3                   	ret    

008006f5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006f5:	55                   	push   %ebp
  8006f6:	89 e5                	mov    %esp,%ebp
  8006f8:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8006fb:	83 ec 0c             	sub    $0xc,%esp
  8006fe:	6a 00                	push   $0x0
  800700:	e8 55 19 00 00       	call   80205a <sys_env_destroy>
  800705:	83 c4 10             	add    $0x10,%esp
}
  800708:	90                   	nop
  800709:	c9                   	leave  
  80070a:	c3                   	ret    

0080070b <exit>:

void
exit(void)
{
  80070b:	55                   	push   %ebp
  80070c:	89 e5                	mov    %esp,%ebp
  80070e:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800711:	e8 78 19 00 00       	call   80208e <sys_env_exit>
}
  800716:	90                   	nop
  800717:	c9                   	leave  
  800718:	c3                   	ret    

00800719 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800719:	55                   	push   %ebp
  80071a:	89 e5                	mov    %esp,%ebp
  80071c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80071f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800722:	8b 00                	mov    (%eax),%eax
  800724:	8d 48 01             	lea    0x1(%eax),%ecx
  800727:	8b 55 0c             	mov    0xc(%ebp),%edx
  80072a:	89 0a                	mov    %ecx,(%edx)
  80072c:	8b 55 08             	mov    0x8(%ebp),%edx
  80072f:	88 d1                	mov    %dl,%cl
  800731:	8b 55 0c             	mov    0xc(%ebp),%edx
  800734:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800738:	8b 45 0c             	mov    0xc(%ebp),%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800742:	75 23                	jne    800767 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  800744:	8b 45 0c             	mov    0xc(%ebp),%eax
  800747:	8b 00                	mov    (%eax),%eax
  800749:	89 c2                	mov    %eax,%edx
  80074b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80074e:	83 c0 08             	add    $0x8,%eax
  800751:	83 ec 08             	sub    $0x8,%esp
  800754:	52                   	push   %edx
  800755:	50                   	push   %eax
  800756:	e8 c9 18 00 00       	call   802024 <sys_cputs>
  80075b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80075e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800761:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800767:	8b 45 0c             	mov    0xc(%ebp),%eax
  80076a:	8b 40 04             	mov    0x4(%eax),%eax
  80076d:	8d 50 01             	lea    0x1(%eax),%edx
  800770:	8b 45 0c             	mov    0xc(%ebp),%eax
  800773:	89 50 04             	mov    %edx,0x4(%eax)
}
  800776:	90                   	nop
  800777:	c9                   	leave  
  800778:	c3                   	ret    

00800779 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800779:	55                   	push   %ebp
  80077a:	89 e5                	mov    %esp,%ebp
  80077c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800782:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800789:	00 00 00 
	b.cnt = 0;
  80078c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800793:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800796:	ff 75 0c             	pushl  0xc(%ebp)
  800799:	ff 75 08             	pushl  0x8(%ebp)
  80079c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007a2:	50                   	push   %eax
  8007a3:	68 19 07 80 00       	push   $0x800719
  8007a8:	e8 fa 01 00 00       	call   8009a7 <vprintfmt>
  8007ad:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  8007b0:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	50                   	push   %eax
  8007ba:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007c0:	83 c0 08             	add    $0x8,%eax
  8007c3:	50                   	push   %eax
  8007c4:	e8 5b 18 00 00       	call   802024 <sys_cputs>
  8007c9:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  8007cc:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007d2:	c9                   	leave  
  8007d3:	c3                   	ret    

008007d4 <cprintf>:

int cprintf(const char *fmt, ...) {
  8007d4:	55                   	push   %ebp
  8007d5:	89 e5                	mov    %esp,%ebp
  8007d7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007da:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	83 ec 08             	sub    $0x8,%esp
  8007e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e9:	50                   	push   %eax
  8007ea:	e8 8a ff ff ff       	call   800779 <vcprintf>
  8007ef:	83 c4 10             	add    $0x10,%esp
  8007f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007f8:	c9                   	leave  
  8007f9:	c3                   	ret    

008007fa <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007fa:	55                   	push   %ebp
  8007fb:	89 e5                	mov    %esp,%ebp
  8007fd:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800800:	e8 be 19 00 00       	call   8021c3 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800805:	8d 45 0c             	lea    0xc(%ebp),%eax
  800808:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80080b:	8b 45 08             	mov    0x8(%ebp),%eax
  80080e:	83 ec 08             	sub    $0x8,%esp
  800811:	ff 75 f4             	pushl  -0xc(%ebp)
  800814:	50                   	push   %eax
  800815:	e8 5f ff ff ff       	call   800779 <vcprintf>
  80081a:	83 c4 10             	add    $0x10,%esp
  80081d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800820:	e8 b8 19 00 00       	call   8021dd <sys_enable_interrupt>
	return cnt;
  800825:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800828:	c9                   	leave  
  800829:	c3                   	ret    

0080082a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80082a:	55                   	push   %ebp
  80082b:	89 e5                	mov    %esp,%ebp
  80082d:	53                   	push   %ebx
  80082e:	83 ec 14             	sub    $0x14,%esp
  800831:	8b 45 10             	mov    0x10(%ebp),%eax
  800834:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800837:	8b 45 14             	mov    0x14(%ebp),%eax
  80083a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80083d:	8b 45 18             	mov    0x18(%ebp),%eax
  800840:	ba 00 00 00 00       	mov    $0x0,%edx
  800845:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800848:	77 55                	ja     80089f <printnum+0x75>
  80084a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80084d:	72 05                	jb     800854 <printnum+0x2a>
  80084f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800852:	77 4b                	ja     80089f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800854:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800857:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80085a:	8b 45 18             	mov    0x18(%ebp),%eax
  80085d:	ba 00 00 00 00       	mov    $0x0,%edx
  800862:	52                   	push   %edx
  800863:	50                   	push   %eax
  800864:	ff 75 f4             	pushl  -0xc(%ebp)
  800867:	ff 75 f0             	pushl  -0x10(%ebp)
  80086a:	e8 61 1d 00 00       	call   8025d0 <__udivdi3>
  80086f:	83 c4 10             	add    $0x10,%esp
  800872:	83 ec 04             	sub    $0x4,%esp
  800875:	ff 75 20             	pushl  0x20(%ebp)
  800878:	53                   	push   %ebx
  800879:	ff 75 18             	pushl  0x18(%ebp)
  80087c:	52                   	push   %edx
  80087d:	50                   	push   %eax
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	ff 75 08             	pushl  0x8(%ebp)
  800884:	e8 a1 ff ff ff       	call   80082a <printnum>
  800889:	83 c4 20             	add    $0x20,%esp
  80088c:	eb 1a                	jmp    8008a8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80088e:	83 ec 08             	sub    $0x8,%esp
  800891:	ff 75 0c             	pushl  0xc(%ebp)
  800894:	ff 75 20             	pushl  0x20(%ebp)
  800897:	8b 45 08             	mov    0x8(%ebp),%eax
  80089a:	ff d0                	call   *%eax
  80089c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80089f:	ff 4d 1c             	decl   0x1c(%ebp)
  8008a2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008a6:	7f e6                	jg     80088e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008a8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008ab:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008b6:	53                   	push   %ebx
  8008b7:	51                   	push   %ecx
  8008b8:	52                   	push   %edx
  8008b9:	50                   	push   %eax
  8008ba:	e8 21 1e 00 00       	call   8026e0 <__umoddi3>
  8008bf:	83 c4 10             	add    $0x10,%esp
  8008c2:	05 b4 2a 80 00       	add    $0x802ab4,%eax
  8008c7:	8a 00                	mov    (%eax),%al
  8008c9:	0f be c0             	movsbl %al,%eax
  8008cc:	83 ec 08             	sub    $0x8,%esp
  8008cf:	ff 75 0c             	pushl  0xc(%ebp)
  8008d2:	50                   	push   %eax
  8008d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d6:	ff d0                	call   *%eax
  8008d8:	83 c4 10             	add    $0x10,%esp
}
  8008db:	90                   	nop
  8008dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008df:	c9                   	leave  
  8008e0:	c3                   	ret    

008008e1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008e1:	55                   	push   %ebp
  8008e2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008e4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008e8:	7e 1c                	jle    800906 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ed:	8b 00                	mov    (%eax),%eax
  8008ef:	8d 50 08             	lea    0x8(%eax),%edx
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	89 10                	mov    %edx,(%eax)
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	8b 00                	mov    (%eax),%eax
  8008fc:	83 e8 08             	sub    $0x8,%eax
  8008ff:	8b 50 04             	mov    0x4(%eax),%edx
  800902:	8b 00                	mov    (%eax),%eax
  800904:	eb 40                	jmp    800946 <getuint+0x65>
	else if (lflag)
  800906:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80090a:	74 1e                	je     80092a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80090c:	8b 45 08             	mov    0x8(%ebp),%eax
  80090f:	8b 00                	mov    (%eax),%eax
  800911:	8d 50 04             	lea    0x4(%eax),%edx
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	89 10                	mov    %edx,(%eax)
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	8b 00                	mov    (%eax),%eax
  80091e:	83 e8 04             	sub    $0x4,%eax
  800921:	8b 00                	mov    (%eax),%eax
  800923:	ba 00 00 00 00       	mov    $0x0,%edx
  800928:	eb 1c                	jmp    800946 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	8b 00                	mov    (%eax),%eax
  80092f:	8d 50 04             	lea    0x4(%eax),%edx
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	89 10                	mov    %edx,(%eax)
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	8b 00                	mov    (%eax),%eax
  80093c:	83 e8 04             	sub    $0x4,%eax
  80093f:	8b 00                	mov    (%eax),%eax
  800941:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800946:	5d                   	pop    %ebp
  800947:	c3                   	ret    

00800948 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800948:	55                   	push   %ebp
  800949:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80094b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80094f:	7e 1c                	jle    80096d <getint+0x25>
		return va_arg(*ap, long long);
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	8b 00                	mov    (%eax),%eax
  800956:	8d 50 08             	lea    0x8(%eax),%edx
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	89 10                	mov    %edx,(%eax)
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	8b 00                	mov    (%eax),%eax
  800963:	83 e8 08             	sub    $0x8,%eax
  800966:	8b 50 04             	mov    0x4(%eax),%edx
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	eb 38                	jmp    8009a5 <getint+0x5d>
	else if (lflag)
  80096d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800971:	74 1a                	je     80098d <getint+0x45>
		return va_arg(*ap, long);
  800973:	8b 45 08             	mov    0x8(%ebp),%eax
  800976:	8b 00                	mov    (%eax),%eax
  800978:	8d 50 04             	lea    0x4(%eax),%edx
  80097b:	8b 45 08             	mov    0x8(%ebp),%eax
  80097e:	89 10                	mov    %edx,(%eax)
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	8b 00                	mov    (%eax),%eax
  800985:	83 e8 04             	sub    $0x4,%eax
  800988:	8b 00                	mov    (%eax),%eax
  80098a:	99                   	cltd   
  80098b:	eb 18                	jmp    8009a5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	8b 00                	mov    (%eax),%eax
  800992:	8d 50 04             	lea    0x4(%eax),%edx
  800995:	8b 45 08             	mov    0x8(%ebp),%eax
  800998:	89 10                	mov    %edx,(%eax)
  80099a:	8b 45 08             	mov    0x8(%ebp),%eax
  80099d:	8b 00                	mov    (%eax),%eax
  80099f:	83 e8 04             	sub    $0x4,%eax
  8009a2:	8b 00                	mov    (%eax),%eax
  8009a4:	99                   	cltd   
}
  8009a5:	5d                   	pop    %ebp
  8009a6:	c3                   	ret    

008009a7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009a7:	55                   	push   %ebp
  8009a8:	89 e5                	mov    %esp,%ebp
  8009aa:	56                   	push   %esi
  8009ab:	53                   	push   %ebx
  8009ac:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009af:	eb 17                	jmp    8009c8 <vprintfmt+0x21>
			if (ch == '\0')
  8009b1:	85 db                	test   %ebx,%ebx
  8009b3:	0f 84 af 03 00 00    	je     800d68 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8009b9:	83 ec 08             	sub    $0x8,%esp
  8009bc:	ff 75 0c             	pushl  0xc(%ebp)
  8009bf:	53                   	push   %ebx
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	ff d0                	call   *%eax
  8009c5:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009cb:	8d 50 01             	lea    0x1(%eax),%edx
  8009ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8009d1:	8a 00                	mov    (%eax),%al
  8009d3:	0f b6 d8             	movzbl %al,%ebx
  8009d6:	83 fb 25             	cmp    $0x25,%ebx
  8009d9:	75 d6                	jne    8009b1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009db:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009df:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009e6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009ed:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009f4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fe:	8d 50 01             	lea    0x1(%eax),%edx
  800a01:	89 55 10             	mov    %edx,0x10(%ebp)
  800a04:	8a 00                	mov    (%eax),%al
  800a06:	0f b6 d8             	movzbl %al,%ebx
  800a09:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a0c:	83 f8 55             	cmp    $0x55,%eax
  800a0f:	0f 87 2b 03 00 00    	ja     800d40 <vprintfmt+0x399>
  800a15:	8b 04 85 d8 2a 80 00 	mov    0x802ad8(,%eax,4),%eax
  800a1c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a1e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a22:	eb d7                	jmp    8009fb <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a24:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a28:	eb d1                	jmp    8009fb <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a2a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a31:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a34:	89 d0                	mov    %edx,%eax
  800a36:	c1 e0 02             	shl    $0x2,%eax
  800a39:	01 d0                	add    %edx,%eax
  800a3b:	01 c0                	add    %eax,%eax
  800a3d:	01 d8                	add    %ebx,%eax
  800a3f:	83 e8 30             	sub    $0x30,%eax
  800a42:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a45:	8b 45 10             	mov    0x10(%ebp),%eax
  800a48:	8a 00                	mov    (%eax),%al
  800a4a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a4d:	83 fb 2f             	cmp    $0x2f,%ebx
  800a50:	7e 3e                	jle    800a90 <vprintfmt+0xe9>
  800a52:	83 fb 39             	cmp    $0x39,%ebx
  800a55:	7f 39                	jg     800a90 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a57:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a5a:	eb d5                	jmp    800a31 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5f:	83 c0 04             	add    $0x4,%eax
  800a62:	89 45 14             	mov    %eax,0x14(%ebp)
  800a65:	8b 45 14             	mov    0x14(%ebp),%eax
  800a68:	83 e8 04             	sub    $0x4,%eax
  800a6b:	8b 00                	mov    (%eax),%eax
  800a6d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a70:	eb 1f                	jmp    800a91 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a72:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a76:	79 83                	jns    8009fb <vprintfmt+0x54>
				width = 0;
  800a78:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a7f:	e9 77 ff ff ff       	jmp    8009fb <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a84:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a8b:	e9 6b ff ff ff       	jmp    8009fb <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a90:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a91:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a95:	0f 89 60 ff ff ff    	jns    8009fb <vprintfmt+0x54>
				width = precision, precision = -1;
  800a9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800aa1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800aa8:	e9 4e ff ff ff       	jmp    8009fb <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800aad:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ab0:	e9 46 ff ff ff       	jmp    8009fb <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ab5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab8:	83 c0 04             	add    $0x4,%eax
  800abb:	89 45 14             	mov    %eax,0x14(%ebp)
  800abe:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac1:	83 e8 04             	sub    $0x4,%eax
  800ac4:	8b 00                	mov    (%eax),%eax
  800ac6:	83 ec 08             	sub    $0x8,%esp
  800ac9:	ff 75 0c             	pushl  0xc(%ebp)
  800acc:	50                   	push   %eax
  800acd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad0:	ff d0                	call   *%eax
  800ad2:	83 c4 10             	add    $0x10,%esp
			break;
  800ad5:	e9 89 02 00 00       	jmp    800d63 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ada:	8b 45 14             	mov    0x14(%ebp),%eax
  800add:	83 c0 04             	add    $0x4,%eax
  800ae0:	89 45 14             	mov    %eax,0x14(%ebp)
  800ae3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae6:	83 e8 04             	sub    $0x4,%eax
  800ae9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800aeb:	85 db                	test   %ebx,%ebx
  800aed:	79 02                	jns    800af1 <vprintfmt+0x14a>
				err = -err;
  800aef:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800af1:	83 fb 64             	cmp    $0x64,%ebx
  800af4:	7f 0b                	jg     800b01 <vprintfmt+0x15a>
  800af6:	8b 34 9d 20 29 80 00 	mov    0x802920(,%ebx,4),%esi
  800afd:	85 f6                	test   %esi,%esi
  800aff:	75 19                	jne    800b1a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b01:	53                   	push   %ebx
  800b02:	68 c5 2a 80 00       	push   $0x802ac5
  800b07:	ff 75 0c             	pushl  0xc(%ebp)
  800b0a:	ff 75 08             	pushl  0x8(%ebp)
  800b0d:	e8 5e 02 00 00       	call   800d70 <printfmt>
  800b12:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b15:	e9 49 02 00 00       	jmp    800d63 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b1a:	56                   	push   %esi
  800b1b:	68 ce 2a 80 00       	push   $0x802ace
  800b20:	ff 75 0c             	pushl  0xc(%ebp)
  800b23:	ff 75 08             	pushl  0x8(%ebp)
  800b26:	e8 45 02 00 00       	call   800d70 <printfmt>
  800b2b:	83 c4 10             	add    $0x10,%esp
			break;
  800b2e:	e9 30 02 00 00       	jmp    800d63 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b33:	8b 45 14             	mov    0x14(%ebp),%eax
  800b36:	83 c0 04             	add    $0x4,%eax
  800b39:	89 45 14             	mov    %eax,0x14(%ebp)
  800b3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3f:	83 e8 04             	sub    $0x4,%eax
  800b42:	8b 30                	mov    (%eax),%esi
  800b44:	85 f6                	test   %esi,%esi
  800b46:	75 05                	jne    800b4d <vprintfmt+0x1a6>
				p = "(null)";
  800b48:	be d1 2a 80 00       	mov    $0x802ad1,%esi
			if (width > 0 && padc != '-')
  800b4d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b51:	7e 6d                	jle    800bc0 <vprintfmt+0x219>
  800b53:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b57:	74 67                	je     800bc0 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b5c:	83 ec 08             	sub    $0x8,%esp
  800b5f:	50                   	push   %eax
  800b60:	56                   	push   %esi
  800b61:	e8 0c 03 00 00       	call   800e72 <strnlen>
  800b66:	83 c4 10             	add    $0x10,%esp
  800b69:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b6c:	eb 16                	jmp    800b84 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b6e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b72:	83 ec 08             	sub    $0x8,%esp
  800b75:	ff 75 0c             	pushl  0xc(%ebp)
  800b78:	50                   	push   %eax
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	ff d0                	call   *%eax
  800b7e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b81:	ff 4d e4             	decl   -0x1c(%ebp)
  800b84:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b88:	7f e4                	jg     800b6e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b8a:	eb 34                	jmp    800bc0 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b8c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b90:	74 1c                	je     800bae <vprintfmt+0x207>
  800b92:	83 fb 1f             	cmp    $0x1f,%ebx
  800b95:	7e 05                	jle    800b9c <vprintfmt+0x1f5>
  800b97:	83 fb 7e             	cmp    $0x7e,%ebx
  800b9a:	7e 12                	jle    800bae <vprintfmt+0x207>
					putch('?', putdat);
  800b9c:	83 ec 08             	sub    $0x8,%esp
  800b9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ba2:	6a 3f                	push   $0x3f
  800ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba7:	ff d0                	call   *%eax
  800ba9:	83 c4 10             	add    $0x10,%esp
  800bac:	eb 0f                	jmp    800bbd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800bae:	83 ec 08             	sub    $0x8,%esp
  800bb1:	ff 75 0c             	pushl  0xc(%ebp)
  800bb4:	53                   	push   %ebx
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	ff d0                	call   *%eax
  800bba:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bbd:	ff 4d e4             	decl   -0x1c(%ebp)
  800bc0:	89 f0                	mov    %esi,%eax
  800bc2:	8d 70 01             	lea    0x1(%eax),%esi
  800bc5:	8a 00                	mov    (%eax),%al
  800bc7:	0f be d8             	movsbl %al,%ebx
  800bca:	85 db                	test   %ebx,%ebx
  800bcc:	74 24                	je     800bf2 <vprintfmt+0x24b>
  800bce:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bd2:	78 b8                	js     800b8c <vprintfmt+0x1e5>
  800bd4:	ff 4d e0             	decl   -0x20(%ebp)
  800bd7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bdb:	79 af                	jns    800b8c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bdd:	eb 13                	jmp    800bf2 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bdf:	83 ec 08             	sub    $0x8,%esp
  800be2:	ff 75 0c             	pushl  0xc(%ebp)
  800be5:	6a 20                	push   $0x20
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	ff d0                	call   *%eax
  800bec:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bef:	ff 4d e4             	decl   -0x1c(%ebp)
  800bf2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bf6:	7f e7                	jg     800bdf <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bf8:	e9 66 01 00 00       	jmp    800d63 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bfd:	83 ec 08             	sub    $0x8,%esp
  800c00:	ff 75 e8             	pushl  -0x18(%ebp)
  800c03:	8d 45 14             	lea    0x14(%ebp),%eax
  800c06:	50                   	push   %eax
  800c07:	e8 3c fd ff ff       	call   800948 <getint>
  800c0c:	83 c4 10             	add    $0x10,%esp
  800c0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c12:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c1b:	85 d2                	test   %edx,%edx
  800c1d:	79 23                	jns    800c42 <vprintfmt+0x29b>
				putch('-', putdat);
  800c1f:	83 ec 08             	sub    $0x8,%esp
  800c22:	ff 75 0c             	pushl  0xc(%ebp)
  800c25:	6a 2d                	push   $0x2d
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	ff d0                	call   *%eax
  800c2c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c35:	f7 d8                	neg    %eax
  800c37:	83 d2 00             	adc    $0x0,%edx
  800c3a:	f7 da                	neg    %edx
  800c3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c42:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c49:	e9 bc 00 00 00       	jmp    800d0a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c4e:	83 ec 08             	sub    $0x8,%esp
  800c51:	ff 75 e8             	pushl  -0x18(%ebp)
  800c54:	8d 45 14             	lea    0x14(%ebp),%eax
  800c57:	50                   	push   %eax
  800c58:	e8 84 fc ff ff       	call   8008e1 <getuint>
  800c5d:	83 c4 10             	add    $0x10,%esp
  800c60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c63:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c66:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c6d:	e9 98 00 00 00       	jmp    800d0a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c72:	83 ec 08             	sub    $0x8,%esp
  800c75:	ff 75 0c             	pushl  0xc(%ebp)
  800c78:	6a 58                	push   $0x58
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	ff d0                	call   *%eax
  800c7f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c82:	83 ec 08             	sub    $0x8,%esp
  800c85:	ff 75 0c             	pushl  0xc(%ebp)
  800c88:	6a 58                	push   $0x58
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	ff d0                	call   *%eax
  800c8f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c92:	83 ec 08             	sub    $0x8,%esp
  800c95:	ff 75 0c             	pushl  0xc(%ebp)
  800c98:	6a 58                	push   $0x58
  800c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9d:	ff d0                	call   *%eax
  800c9f:	83 c4 10             	add    $0x10,%esp
			break;
  800ca2:	e9 bc 00 00 00       	jmp    800d63 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ca7:	83 ec 08             	sub    $0x8,%esp
  800caa:	ff 75 0c             	pushl  0xc(%ebp)
  800cad:	6a 30                	push   $0x30
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	ff d0                	call   *%eax
  800cb4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800cb7:	83 ec 08             	sub    $0x8,%esp
  800cba:	ff 75 0c             	pushl  0xc(%ebp)
  800cbd:	6a 78                	push   $0x78
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc2:	ff d0                	call   *%eax
  800cc4:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cc7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cca:	83 c0 04             	add    $0x4,%eax
  800ccd:	89 45 14             	mov    %eax,0x14(%ebp)
  800cd0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd3:	83 e8 04             	sub    $0x4,%eax
  800cd6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cdb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ce2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ce9:	eb 1f                	jmp    800d0a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ceb:	83 ec 08             	sub    $0x8,%esp
  800cee:	ff 75 e8             	pushl  -0x18(%ebp)
  800cf1:	8d 45 14             	lea    0x14(%ebp),%eax
  800cf4:	50                   	push   %eax
  800cf5:	e8 e7 fb ff ff       	call   8008e1 <getuint>
  800cfa:	83 c4 10             	add    $0x10,%esp
  800cfd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d00:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d03:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d0a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d11:	83 ec 04             	sub    $0x4,%esp
  800d14:	52                   	push   %edx
  800d15:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d18:	50                   	push   %eax
  800d19:	ff 75 f4             	pushl  -0xc(%ebp)
  800d1c:	ff 75 f0             	pushl  -0x10(%ebp)
  800d1f:	ff 75 0c             	pushl  0xc(%ebp)
  800d22:	ff 75 08             	pushl  0x8(%ebp)
  800d25:	e8 00 fb ff ff       	call   80082a <printnum>
  800d2a:	83 c4 20             	add    $0x20,%esp
			break;
  800d2d:	eb 34                	jmp    800d63 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d2f:	83 ec 08             	sub    $0x8,%esp
  800d32:	ff 75 0c             	pushl  0xc(%ebp)
  800d35:	53                   	push   %ebx
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	ff d0                	call   *%eax
  800d3b:	83 c4 10             	add    $0x10,%esp
			break;
  800d3e:	eb 23                	jmp    800d63 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d40:	83 ec 08             	sub    $0x8,%esp
  800d43:	ff 75 0c             	pushl  0xc(%ebp)
  800d46:	6a 25                	push   $0x25
  800d48:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4b:	ff d0                	call   *%eax
  800d4d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d50:	ff 4d 10             	decl   0x10(%ebp)
  800d53:	eb 03                	jmp    800d58 <vprintfmt+0x3b1>
  800d55:	ff 4d 10             	decl   0x10(%ebp)
  800d58:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5b:	48                   	dec    %eax
  800d5c:	8a 00                	mov    (%eax),%al
  800d5e:	3c 25                	cmp    $0x25,%al
  800d60:	75 f3                	jne    800d55 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d62:	90                   	nop
		}
	}
  800d63:	e9 47 fc ff ff       	jmp    8009af <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d68:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d69:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d6c:	5b                   	pop    %ebx
  800d6d:	5e                   	pop    %esi
  800d6e:	5d                   	pop    %ebp
  800d6f:	c3                   	ret    

00800d70 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d76:	8d 45 10             	lea    0x10(%ebp),%eax
  800d79:	83 c0 04             	add    $0x4,%eax
  800d7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d82:	ff 75 f4             	pushl  -0xc(%ebp)
  800d85:	50                   	push   %eax
  800d86:	ff 75 0c             	pushl  0xc(%ebp)
  800d89:	ff 75 08             	pushl  0x8(%ebp)
  800d8c:	e8 16 fc ff ff       	call   8009a7 <vprintfmt>
  800d91:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d94:	90                   	nop
  800d95:	c9                   	leave  
  800d96:	c3                   	ret    

00800d97 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9d:	8b 40 08             	mov    0x8(%eax),%eax
  800da0:	8d 50 01             	lea    0x1(%eax),%edx
  800da3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800da9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dac:	8b 10                	mov    (%eax),%edx
  800dae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db1:	8b 40 04             	mov    0x4(%eax),%eax
  800db4:	39 c2                	cmp    %eax,%edx
  800db6:	73 12                	jae    800dca <sprintputch+0x33>
		*b->buf++ = ch;
  800db8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbb:	8b 00                	mov    (%eax),%eax
  800dbd:	8d 48 01             	lea    0x1(%eax),%ecx
  800dc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc3:	89 0a                	mov    %ecx,(%edx)
  800dc5:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc8:	88 10                	mov    %dl,(%eax)
}
  800dca:	90                   	nop
  800dcb:	5d                   	pop    %ebp
  800dcc:	c3                   	ret    

00800dcd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dcd:	55                   	push   %ebp
  800dce:	89 e5                	mov    %esp,%ebp
  800dd0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  800de2:	01 d0                	add    %edx,%eax
  800de4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800de7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800df2:	74 06                	je     800dfa <vsnprintf+0x2d>
  800df4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800df8:	7f 07                	jg     800e01 <vsnprintf+0x34>
		return -E_INVAL;
  800dfa:	b8 03 00 00 00       	mov    $0x3,%eax
  800dff:	eb 20                	jmp    800e21 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e01:	ff 75 14             	pushl  0x14(%ebp)
  800e04:	ff 75 10             	pushl  0x10(%ebp)
  800e07:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e0a:	50                   	push   %eax
  800e0b:	68 97 0d 80 00       	push   $0x800d97
  800e10:	e8 92 fb ff ff       	call   8009a7 <vprintfmt>
  800e15:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e1b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e21:	c9                   	leave  
  800e22:	c3                   	ret    

00800e23 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e23:	55                   	push   %ebp
  800e24:	89 e5                	mov    %esp,%ebp
  800e26:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e29:	8d 45 10             	lea    0x10(%ebp),%eax
  800e2c:	83 c0 04             	add    $0x4,%eax
  800e2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e32:	8b 45 10             	mov    0x10(%ebp),%eax
  800e35:	ff 75 f4             	pushl  -0xc(%ebp)
  800e38:	50                   	push   %eax
  800e39:	ff 75 0c             	pushl  0xc(%ebp)
  800e3c:	ff 75 08             	pushl  0x8(%ebp)
  800e3f:	e8 89 ff ff ff       	call   800dcd <vsnprintf>
  800e44:	83 c4 10             	add    $0x10,%esp
  800e47:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e4d:	c9                   	leave  
  800e4e:	c3                   	ret    

00800e4f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e55:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e5c:	eb 06                	jmp    800e64 <strlen+0x15>
		n++;
  800e5e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e61:	ff 45 08             	incl   0x8(%ebp)
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
  800e67:	8a 00                	mov    (%eax),%al
  800e69:	84 c0                	test   %al,%al
  800e6b:	75 f1                	jne    800e5e <strlen+0xf>
		n++;
	return n;
  800e6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e70:	c9                   	leave  
  800e71:	c3                   	ret    

00800e72 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e72:	55                   	push   %ebp
  800e73:	89 e5                	mov    %esp,%ebp
  800e75:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e78:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e7f:	eb 09                	jmp    800e8a <strnlen+0x18>
		n++;
  800e81:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e84:	ff 45 08             	incl   0x8(%ebp)
  800e87:	ff 4d 0c             	decl   0xc(%ebp)
  800e8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e8e:	74 09                	je     800e99 <strnlen+0x27>
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
  800e93:	8a 00                	mov    (%eax),%al
  800e95:	84 c0                	test   %al,%al
  800e97:	75 e8                	jne    800e81 <strnlen+0xf>
		n++;
	return n;
  800e99:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e9c:	c9                   	leave  
  800e9d:	c3                   	ret    

00800e9e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e9e:	55                   	push   %ebp
  800e9f:	89 e5                	mov    %esp,%ebp
  800ea1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800eaa:	90                   	nop
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	8d 50 01             	lea    0x1(%eax),%edx
  800eb1:	89 55 08             	mov    %edx,0x8(%ebp)
  800eb4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eba:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ebd:	8a 12                	mov    (%edx),%dl
  800ebf:	88 10                	mov    %dl,(%eax)
  800ec1:	8a 00                	mov    (%eax),%al
  800ec3:	84 c0                	test   %al,%al
  800ec5:	75 e4                	jne    800eab <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ec7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eca:	c9                   	leave  
  800ecb:	c3                   	ret    

00800ecc <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ed8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800edf:	eb 1f                	jmp    800f00 <strncpy+0x34>
		*dst++ = *src;
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	8d 50 01             	lea    0x1(%eax),%edx
  800ee7:	89 55 08             	mov    %edx,0x8(%ebp)
  800eea:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eed:	8a 12                	mov    (%edx),%dl
  800eef:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ef1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef4:	8a 00                	mov    (%eax),%al
  800ef6:	84 c0                	test   %al,%al
  800ef8:	74 03                	je     800efd <strncpy+0x31>
			src++;
  800efa:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800efd:	ff 45 fc             	incl   -0x4(%ebp)
  800f00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f03:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f06:	72 d9                	jb     800ee1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f08:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f0b:	c9                   	leave  
  800f0c:	c3                   	ret    

00800f0d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f19:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f1d:	74 30                	je     800f4f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f1f:	eb 16                	jmp    800f37 <strlcpy+0x2a>
			*dst++ = *src++;
  800f21:	8b 45 08             	mov    0x8(%ebp),%eax
  800f24:	8d 50 01             	lea    0x1(%eax),%edx
  800f27:	89 55 08             	mov    %edx,0x8(%ebp)
  800f2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f2d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f30:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f33:	8a 12                	mov    (%edx),%dl
  800f35:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f37:	ff 4d 10             	decl   0x10(%ebp)
  800f3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3e:	74 09                	je     800f49 <strlcpy+0x3c>
  800f40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f43:	8a 00                	mov    (%eax),%al
  800f45:	84 c0                	test   %al,%al
  800f47:	75 d8                	jne    800f21 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f55:	29 c2                	sub    %eax,%edx
  800f57:	89 d0                	mov    %edx,%eax
}
  800f59:	c9                   	leave  
  800f5a:	c3                   	ret    

00800f5b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f5b:	55                   	push   %ebp
  800f5c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f5e:	eb 06                	jmp    800f66 <strcmp+0xb>
		p++, q++;
  800f60:	ff 45 08             	incl   0x8(%ebp)
  800f63:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
  800f69:	8a 00                	mov    (%eax),%al
  800f6b:	84 c0                	test   %al,%al
  800f6d:	74 0e                	je     800f7d <strcmp+0x22>
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	8a 10                	mov    (%eax),%dl
  800f74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f77:	8a 00                	mov    (%eax),%al
  800f79:	38 c2                	cmp    %al,%dl
  800f7b:	74 e3                	je     800f60 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	8a 00                	mov    (%eax),%al
  800f82:	0f b6 d0             	movzbl %al,%edx
  800f85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	0f b6 c0             	movzbl %al,%eax
  800f8d:	29 c2                	sub    %eax,%edx
  800f8f:	89 d0                	mov    %edx,%eax
}
  800f91:	5d                   	pop    %ebp
  800f92:	c3                   	ret    

00800f93 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f93:	55                   	push   %ebp
  800f94:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f96:	eb 09                	jmp    800fa1 <strncmp+0xe>
		n--, p++, q++;
  800f98:	ff 4d 10             	decl   0x10(%ebp)
  800f9b:	ff 45 08             	incl   0x8(%ebp)
  800f9e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fa1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa5:	74 17                	je     800fbe <strncmp+0x2b>
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	8a 00                	mov    (%eax),%al
  800fac:	84 c0                	test   %al,%al
  800fae:	74 0e                	je     800fbe <strncmp+0x2b>
  800fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb3:	8a 10                	mov    (%eax),%dl
  800fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	38 c2                	cmp    %al,%dl
  800fbc:	74 da                	je     800f98 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fbe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc2:	75 07                	jne    800fcb <strncmp+0x38>
		return 0;
  800fc4:	b8 00 00 00 00       	mov    $0x0,%eax
  800fc9:	eb 14                	jmp    800fdf <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fce:	8a 00                	mov    (%eax),%al
  800fd0:	0f b6 d0             	movzbl %al,%edx
  800fd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd6:	8a 00                	mov    (%eax),%al
  800fd8:	0f b6 c0             	movzbl %al,%eax
  800fdb:	29 c2                	sub    %eax,%edx
  800fdd:	89 d0                	mov    %edx,%eax
}
  800fdf:	5d                   	pop    %ebp
  800fe0:	c3                   	ret    

00800fe1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fe1:	55                   	push   %ebp
  800fe2:	89 e5                	mov    %esp,%ebp
  800fe4:	83 ec 04             	sub    $0x4,%esp
  800fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fea:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fed:	eb 12                	jmp    801001 <strchr+0x20>
		if (*s == c)
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ff7:	75 05                	jne    800ffe <strchr+0x1d>
			return (char *) s;
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	eb 11                	jmp    80100f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ffe:	ff 45 08             	incl   0x8(%ebp)
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
  801004:	8a 00                	mov    (%eax),%al
  801006:	84 c0                	test   %al,%al
  801008:	75 e5                	jne    800fef <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80100a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80100f:	c9                   	leave  
  801010:	c3                   	ret    

00801011 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801011:	55                   	push   %ebp
  801012:	89 e5                	mov    %esp,%ebp
  801014:	83 ec 04             	sub    $0x4,%esp
  801017:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80101d:	eb 0d                	jmp    80102c <strfind+0x1b>
		if (*s == c)
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	8a 00                	mov    (%eax),%al
  801024:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801027:	74 0e                	je     801037 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801029:	ff 45 08             	incl   0x8(%ebp)
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	8a 00                	mov    (%eax),%al
  801031:	84 c0                	test   %al,%al
  801033:	75 ea                	jne    80101f <strfind+0xe>
  801035:	eb 01                	jmp    801038 <strfind+0x27>
		if (*s == c)
			break;
  801037:	90                   	nop
	return (char *) s;
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80103b:	c9                   	leave  
  80103c:	c3                   	ret    

0080103d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80103d:	55                   	push   %ebp
  80103e:	89 e5                	mov    %esp,%ebp
  801040:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801049:	8b 45 10             	mov    0x10(%ebp),%eax
  80104c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80104f:	eb 0e                	jmp    80105f <memset+0x22>
		*p++ = c;
  801051:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801054:	8d 50 01             	lea    0x1(%eax),%edx
  801057:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80105a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80105d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80105f:	ff 4d f8             	decl   -0x8(%ebp)
  801062:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801066:	79 e9                	jns    801051 <memset+0x14>
		*p++ = c;

	return v;
  801068:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80106b:	c9                   	leave  
  80106c:	c3                   	ret    

0080106d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80106d:	55                   	push   %ebp
  80106e:	89 e5                	mov    %esp,%ebp
  801070:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801073:	8b 45 0c             	mov    0xc(%ebp),%eax
  801076:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80107f:	eb 16                	jmp    801097 <memcpy+0x2a>
		*d++ = *s++;
  801081:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801084:	8d 50 01             	lea    0x1(%eax),%edx
  801087:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80108a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80108d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801090:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801093:	8a 12                	mov    (%edx),%dl
  801095:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801097:	8b 45 10             	mov    0x10(%ebp),%eax
  80109a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80109d:	89 55 10             	mov    %edx,0x10(%ebp)
  8010a0:	85 c0                	test   %eax,%eax
  8010a2:	75 dd                	jne    801081 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a7:	c9                   	leave  
  8010a8:	c3                   	ret    

008010a9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010a9:	55                   	push   %ebp
  8010aa:	89 e5                	mov    %esp,%ebp
  8010ac:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  8010af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010be:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010c1:	73 50                	jae    801113 <memmove+0x6a>
  8010c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c9:	01 d0                	add    %edx,%eax
  8010cb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010ce:	76 43                	jbe    801113 <memmove+0x6a>
		s += n;
  8010d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010dc:	eb 10                	jmp    8010ee <memmove+0x45>
			*--d = *--s;
  8010de:	ff 4d f8             	decl   -0x8(%ebp)
  8010e1:	ff 4d fc             	decl   -0x4(%ebp)
  8010e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e7:	8a 10                	mov    (%eax),%dl
  8010e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ec:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f4:	89 55 10             	mov    %edx,0x10(%ebp)
  8010f7:	85 c0                	test   %eax,%eax
  8010f9:	75 e3                	jne    8010de <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010fb:	eb 23                	jmp    801120 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801100:	8d 50 01             	lea    0x1(%eax),%edx
  801103:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801106:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801109:	8d 4a 01             	lea    0x1(%edx),%ecx
  80110c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80110f:	8a 12                	mov    (%edx),%dl
  801111:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801113:	8b 45 10             	mov    0x10(%ebp),%eax
  801116:	8d 50 ff             	lea    -0x1(%eax),%edx
  801119:	89 55 10             	mov    %edx,0x10(%ebp)
  80111c:	85 c0                	test   %eax,%eax
  80111e:	75 dd                	jne    8010fd <memmove+0x54>
			*d++ = *s++;

	return dst;
  801120:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801123:	c9                   	leave  
  801124:	c3                   	ret    

00801125 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801125:	55                   	push   %ebp
  801126:	89 e5                	mov    %esp,%ebp
  801128:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801131:	8b 45 0c             	mov    0xc(%ebp),%eax
  801134:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801137:	eb 2a                	jmp    801163 <memcmp+0x3e>
		if (*s1 != *s2)
  801139:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80113c:	8a 10                	mov    (%eax),%dl
  80113e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801141:	8a 00                	mov    (%eax),%al
  801143:	38 c2                	cmp    %al,%dl
  801145:	74 16                	je     80115d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801147:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80114a:	8a 00                	mov    (%eax),%al
  80114c:	0f b6 d0             	movzbl %al,%edx
  80114f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801152:	8a 00                	mov    (%eax),%al
  801154:	0f b6 c0             	movzbl %al,%eax
  801157:	29 c2                	sub    %eax,%edx
  801159:	89 d0                	mov    %edx,%eax
  80115b:	eb 18                	jmp    801175 <memcmp+0x50>
		s1++, s2++;
  80115d:	ff 45 fc             	incl   -0x4(%ebp)
  801160:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801163:	8b 45 10             	mov    0x10(%ebp),%eax
  801166:	8d 50 ff             	lea    -0x1(%eax),%edx
  801169:	89 55 10             	mov    %edx,0x10(%ebp)
  80116c:	85 c0                	test   %eax,%eax
  80116e:	75 c9                	jne    801139 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801170:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801175:	c9                   	leave  
  801176:	c3                   	ret    

00801177 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801177:	55                   	push   %ebp
  801178:	89 e5                	mov    %esp,%ebp
  80117a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80117d:	8b 55 08             	mov    0x8(%ebp),%edx
  801180:	8b 45 10             	mov    0x10(%ebp),%eax
  801183:	01 d0                	add    %edx,%eax
  801185:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801188:	eb 15                	jmp    80119f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	0f b6 d0             	movzbl %al,%edx
  801192:	8b 45 0c             	mov    0xc(%ebp),%eax
  801195:	0f b6 c0             	movzbl %al,%eax
  801198:	39 c2                	cmp    %eax,%edx
  80119a:	74 0d                	je     8011a9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80119c:	ff 45 08             	incl   0x8(%ebp)
  80119f:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011a5:	72 e3                	jb     80118a <memfind+0x13>
  8011a7:	eb 01                	jmp    8011aa <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011a9:	90                   	nop
	return (void *) s;
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011ad:	c9                   	leave  
  8011ae:	c3                   	ret    

008011af <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011af:	55                   	push   %ebp
  8011b0:	89 e5                	mov    %esp,%ebp
  8011b2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011c3:	eb 03                	jmp    8011c8 <strtol+0x19>
		s++;
  8011c5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cb:	8a 00                	mov    (%eax),%al
  8011cd:	3c 20                	cmp    $0x20,%al
  8011cf:	74 f4                	je     8011c5 <strtol+0x16>
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	8a 00                	mov    (%eax),%al
  8011d6:	3c 09                	cmp    $0x9,%al
  8011d8:	74 eb                	je     8011c5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011da:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dd:	8a 00                	mov    (%eax),%al
  8011df:	3c 2b                	cmp    $0x2b,%al
  8011e1:	75 05                	jne    8011e8 <strtol+0x39>
		s++;
  8011e3:	ff 45 08             	incl   0x8(%ebp)
  8011e6:	eb 13                	jmp    8011fb <strtol+0x4c>
	else if (*s == '-')
  8011e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011eb:	8a 00                	mov    (%eax),%al
  8011ed:	3c 2d                	cmp    $0x2d,%al
  8011ef:	75 0a                	jne    8011fb <strtol+0x4c>
		s++, neg = 1;
  8011f1:	ff 45 08             	incl   0x8(%ebp)
  8011f4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011fb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011ff:	74 06                	je     801207 <strtol+0x58>
  801201:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801205:	75 20                	jne    801227 <strtol+0x78>
  801207:	8b 45 08             	mov    0x8(%ebp),%eax
  80120a:	8a 00                	mov    (%eax),%al
  80120c:	3c 30                	cmp    $0x30,%al
  80120e:	75 17                	jne    801227 <strtol+0x78>
  801210:	8b 45 08             	mov    0x8(%ebp),%eax
  801213:	40                   	inc    %eax
  801214:	8a 00                	mov    (%eax),%al
  801216:	3c 78                	cmp    $0x78,%al
  801218:	75 0d                	jne    801227 <strtol+0x78>
		s += 2, base = 16;
  80121a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80121e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801225:	eb 28                	jmp    80124f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801227:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80122b:	75 15                	jne    801242 <strtol+0x93>
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	8a 00                	mov    (%eax),%al
  801232:	3c 30                	cmp    $0x30,%al
  801234:	75 0c                	jne    801242 <strtol+0x93>
		s++, base = 8;
  801236:	ff 45 08             	incl   0x8(%ebp)
  801239:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801240:	eb 0d                	jmp    80124f <strtol+0xa0>
	else if (base == 0)
  801242:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801246:	75 07                	jne    80124f <strtol+0xa0>
		base = 10;
  801248:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	8a 00                	mov    (%eax),%al
  801254:	3c 2f                	cmp    $0x2f,%al
  801256:	7e 19                	jle    801271 <strtol+0xc2>
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	8a 00                	mov    (%eax),%al
  80125d:	3c 39                	cmp    $0x39,%al
  80125f:	7f 10                	jg     801271 <strtol+0xc2>
			dig = *s - '0';
  801261:	8b 45 08             	mov    0x8(%ebp),%eax
  801264:	8a 00                	mov    (%eax),%al
  801266:	0f be c0             	movsbl %al,%eax
  801269:	83 e8 30             	sub    $0x30,%eax
  80126c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80126f:	eb 42                	jmp    8012b3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	8a 00                	mov    (%eax),%al
  801276:	3c 60                	cmp    $0x60,%al
  801278:	7e 19                	jle    801293 <strtol+0xe4>
  80127a:	8b 45 08             	mov    0x8(%ebp),%eax
  80127d:	8a 00                	mov    (%eax),%al
  80127f:	3c 7a                	cmp    $0x7a,%al
  801281:	7f 10                	jg     801293 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	0f be c0             	movsbl %al,%eax
  80128b:	83 e8 57             	sub    $0x57,%eax
  80128e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801291:	eb 20                	jmp    8012b3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801293:	8b 45 08             	mov    0x8(%ebp),%eax
  801296:	8a 00                	mov    (%eax),%al
  801298:	3c 40                	cmp    $0x40,%al
  80129a:	7e 39                	jle    8012d5 <strtol+0x126>
  80129c:	8b 45 08             	mov    0x8(%ebp),%eax
  80129f:	8a 00                	mov    (%eax),%al
  8012a1:	3c 5a                	cmp    $0x5a,%al
  8012a3:	7f 30                	jg     8012d5 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	8a 00                	mov    (%eax),%al
  8012aa:	0f be c0             	movsbl %al,%eax
  8012ad:	83 e8 37             	sub    $0x37,%eax
  8012b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012b9:	7d 19                	jge    8012d4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012bb:	ff 45 08             	incl   0x8(%ebp)
  8012be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012c5:	89 c2                	mov    %eax,%edx
  8012c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ca:	01 d0                	add    %edx,%eax
  8012cc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012cf:	e9 7b ff ff ff       	jmp    80124f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012d4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012d9:	74 08                	je     8012e3 <strtol+0x134>
		*endptr = (char *) s;
  8012db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012de:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012e7:	74 07                	je     8012f0 <strtol+0x141>
  8012e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ec:	f7 d8                	neg    %eax
  8012ee:	eb 03                	jmp    8012f3 <strtol+0x144>
  8012f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012f3:	c9                   	leave  
  8012f4:	c3                   	ret    

008012f5 <ltostr>:

void
ltostr(long value, char *str)
{
  8012f5:	55                   	push   %ebp
  8012f6:	89 e5                	mov    %esp,%ebp
  8012f8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801302:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801309:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80130d:	79 13                	jns    801322 <ltostr+0x2d>
	{
		neg = 1;
  80130f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801316:	8b 45 0c             	mov    0xc(%ebp),%eax
  801319:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80131c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80131f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80132a:	99                   	cltd   
  80132b:	f7 f9                	idiv   %ecx
  80132d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801330:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801333:	8d 50 01             	lea    0x1(%eax),%edx
  801336:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801339:	89 c2                	mov    %eax,%edx
  80133b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133e:	01 d0                	add    %edx,%eax
  801340:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801343:	83 c2 30             	add    $0x30,%edx
  801346:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801348:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80134b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801350:	f7 e9                	imul   %ecx
  801352:	c1 fa 02             	sar    $0x2,%edx
  801355:	89 c8                	mov    %ecx,%eax
  801357:	c1 f8 1f             	sar    $0x1f,%eax
  80135a:	29 c2                	sub    %eax,%edx
  80135c:	89 d0                	mov    %edx,%eax
  80135e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801361:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801364:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801369:	f7 e9                	imul   %ecx
  80136b:	c1 fa 02             	sar    $0x2,%edx
  80136e:	89 c8                	mov    %ecx,%eax
  801370:	c1 f8 1f             	sar    $0x1f,%eax
  801373:	29 c2                	sub    %eax,%edx
  801375:	89 d0                	mov    %edx,%eax
  801377:	c1 e0 02             	shl    $0x2,%eax
  80137a:	01 d0                	add    %edx,%eax
  80137c:	01 c0                	add    %eax,%eax
  80137e:	29 c1                	sub    %eax,%ecx
  801380:	89 ca                	mov    %ecx,%edx
  801382:	85 d2                	test   %edx,%edx
  801384:	75 9c                	jne    801322 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801386:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80138d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801390:	48                   	dec    %eax
  801391:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801394:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801398:	74 3d                	je     8013d7 <ltostr+0xe2>
		start = 1 ;
  80139a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013a1:	eb 34                	jmp    8013d7 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8013a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a9:	01 d0                	add    %edx,%eax
  8013ab:	8a 00                	mov    (%eax),%al
  8013ad:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b6:	01 c2                	add    %eax,%edx
  8013b8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013be:	01 c8                	add    %ecx,%eax
  8013c0:	8a 00                	mov    (%eax),%al
  8013c2:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ca:	01 c2                	add    %eax,%edx
  8013cc:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013cf:	88 02                	mov    %al,(%edx)
		start++ ;
  8013d1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013d4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013da:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013dd:	7c c4                	jl     8013a3 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013df:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e5:	01 d0                	add    %edx,%eax
  8013e7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013ea:	90                   	nop
  8013eb:	c9                   	leave  
  8013ec:	c3                   	ret    

008013ed <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
  8013f0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013f3:	ff 75 08             	pushl  0x8(%ebp)
  8013f6:	e8 54 fa ff ff       	call   800e4f <strlen>
  8013fb:	83 c4 04             	add    $0x4,%esp
  8013fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801401:	ff 75 0c             	pushl  0xc(%ebp)
  801404:	e8 46 fa ff ff       	call   800e4f <strlen>
  801409:	83 c4 04             	add    $0x4,%esp
  80140c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80140f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801416:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80141d:	eb 17                	jmp    801436 <strcconcat+0x49>
		final[s] = str1[s] ;
  80141f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801422:	8b 45 10             	mov    0x10(%ebp),%eax
  801425:	01 c2                	add    %eax,%edx
  801427:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80142a:	8b 45 08             	mov    0x8(%ebp),%eax
  80142d:	01 c8                	add    %ecx,%eax
  80142f:	8a 00                	mov    (%eax),%al
  801431:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801433:	ff 45 fc             	incl   -0x4(%ebp)
  801436:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801439:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80143c:	7c e1                	jl     80141f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80143e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801445:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80144c:	eb 1f                	jmp    80146d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80144e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801451:	8d 50 01             	lea    0x1(%eax),%edx
  801454:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801457:	89 c2                	mov    %eax,%edx
  801459:	8b 45 10             	mov    0x10(%ebp),%eax
  80145c:	01 c2                	add    %eax,%edx
  80145e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801461:	8b 45 0c             	mov    0xc(%ebp),%eax
  801464:	01 c8                	add    %ecx,%eax
  801466:	8a 00                	mov    (%eax),%al
  801468:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80146a:	ff 45 f8             	incl   -0x8(%ebp)
  80146d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801470:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801473:	7c d9                	jl     80144e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801475:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801478:	8b 45 10             	mov    0x10(%ebp),%eax
  80147b:	01 d0                	add    %edx,%eax
  80147d:	c6 00 00             	movb   $0x0,(%eax)
}
  801480:	90                   	nop
  801481:	c9                   	leave  
  801482:	c3                   	ret    

00801483 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801486:	8b 45 14             	mov    0x14(%ebp),%eax
  801489:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80148f:	8b 45 14             	mov    0x14(%ebp),%eax
  801492:	8b 00                	mov    (%eax),%eax
  801494:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80149b:	8b 45 10             	mov    0x10(%ebp),%eax
  80149e:	01 d0                	add    %edx,%eax
  8014a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014a6:	eb 0c                	jmp    8014b4 <strsplit+0x31>
			*string++ = 0;
  8014a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ab:	8d 50 01             	lea    0x1(%eax),%edx
  8014ae:	89 55 08             	mov    %edx,0x8(%ebp)
  8014b1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b7:	8a 00                	mov    (%eax),%al
  8014b9:	84 c0                	test   %al,%al
  8014bb:	74 18                	je     8014d5 <strsplit+0x52>
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	8a 00                	mov    (%eax),%al
  8014c2:	0f be c0             	movsbl %al,%eax
  8014c5:	50                   	push   %eax
  8014c6:	ff 75 0c             	pushl  0xc(%ebp)
  8014c9:	e8 13 fb ff ff       	call   800fe1 <strchr>
  8014ce:	83 c4 08             	add    $0x8,%esp
  8014d1:	85 c0                	test   %eax,%eax
  8014d3:	75 d3                	jne    8014a8 <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  8014d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d8:	8a 00                	mov    (%eax),%al
  8014da:	84 c0                	test   %al,%al
  8014dc:	74 5a                	je     801538 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  8014de:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e1:	8b 00                	mov    (%eax),%eax
  8014e3:	83 f8 0f             	cmp    $0xf,%eax
  8014e6:	75 07                	jne    8014ef <strsplit+0x6c>
		{
			return 0;
  8014e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ed:	eb 66                	jmp    801555 <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f2:	8b 00                	mov    (%eax),%eax
  8014f4:	8d 48 01             	lea    0x1(%eax),%ecx
  8014f7:	8b 55 14             	mov    0x14(%ebp),%edx
  8014fa:	89 0a                	mov    %ecx,(%edx)
  8014fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801503:	8b 45 10             	mov    0x10(%ebp),%eax
  801506:	01 c2                	add    %eax,%edx
  801508:	8b 45 08             	mov    0x8(%ebp),%eax
  80150b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80150d:	eb 03                	jmp    801512 <strsplit+0x8f>
			string++;
  80150f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801512:	8b 45 08             	mov    0x8(%ebp),%eax
  801515:	8a 00                	mov    (%eax),%al
  801517:	84 c0                	test   %al,%al
  801519:	74 8b                	je     8014a6 <strsplit+0x23>
  80151b:	8b 45 08             	mov    0x8(%ebp),%eax
  80151e:	8a 00                	mov    (%eax),%al
  801520:	0f be c0             	movsbl %al,%eax
  801523:	50                   	push   %eax
  801524:	ff 75 0c             	pushl  0xc(%ebp)
  801527:	e8 b5 fa ff ff       	call   800fe1 <strchr>
  80152c:	83 c4 08             	add    $0x8,%esp
  80152f:	85 c0                	test   %eax,%eax
  801531:	74 dc                	je     80150f <strsplit+0x8c>
			string++;
	}
  801533:	e9 6e ff ff ff       	jmp    8014a6 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801538:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801539:	8b 45 14             	mov    0x14(%ebp),%eax
  80153c:	8b 00                	mov    (%eax),%eax
  80153e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801545:	8b 45 10             	mov    0x10(%ebp),%eax
  801548:	01 d0                	add    %edx,%eax
  80154a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801550:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801555:	c9                   	leave  
  801556:	c3                   	ret    

00801557 <malloc>:
int cnt_mem = 0;
int heap_mem[size_uhmem] = { 0 };
struct hmem heap_size[size_uhmem] = { 0 };
int check = 0;

void* malloc(uint32 size) {
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
  80155a:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyNEXTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	//NEXT FIT
	if (sys_isUHeapPlacementStrategyNEXTFIT()) {
  801560:	e8 7d 0f 00 00       	call   8024e2 <sys_isUHeapPlacementStrategyNEXTFIT>
  801565:	85 c0                	test   %eax,%eax
  801567:	0f 84 6f 03 00 00    	je     8018dc <malloc+0x385>
		size = ROUNDUP(size, PAGE_SIZE);
  80156d:	c7 45 84 00 10 00 00 	movl   $0x1000,-0x7c(%ebp)
  801574:	8b 55 08             	mov    0x8(%ebp),%edx
  801577:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80157a:	01 d0                	add    %edx,%eax
  80157c:	48                   	dec    %eax
  80157d:	89 45 80             	mov    %eax,-0x80(%ebp)
  801580:	8b 45 80             	mov    -0x80(%ebp),%eax
  801583:	ba 00 00 00 00       	mov    $0x0,%edx
  801588:	f7 75 84             	divl   -0x7c(%ebp)
  80158b:	8b 45 80             	mov    -0x80(%ebp),%eax
  80158e:	29 d0                	sub    %edx,%eax
  801590:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801593:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801597:	74 09                	je     8015a2 <malloc+0x4b>
  801599:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8015a0:	76 0a                	jbe    8015ac <malloc+0x55>
			return NULL;
  8015a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a7:	e9 4b 09 00 00       	jmp    801ef7 <malloc+0x9a0>
		}
		// first we can allocate by " Strategy Continues "
		if (ptr_uheap + size <= (uint32) USER_HEAP_MAX && !check) {
  8015ac:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b5:	01 d0                	add    %edx,%eax
  8015b7:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8015bc:	0f 87 a2 00 00 00    	ja     801664 <malloc+0x10d>
  8015c2:	a1 40 30 98 00       	mov    0x983040,%eax
  8015c7:	85 c0                	test   %eax,%eax
  8015c9:	0f 85 95 00 00 00    	jne    801664 <malloc+0x10d>

			void* ret = (void *) ptr_uheap;
  8015cf:	a1 04 30 80 00       	mov    0x803004,%eax
  8015d4:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			sys_allocateMem(ptr_uheap, size);
  8015da:	a1 04 30 80 00       	mov    0x803004,%eax
  8015df:	83 ec 08             	sub    $0x8,%esp
  8015e2:	ff 75 08             	pushl  0x8(%ebp)
  8015e5:	50                   	push   %eax
  8015e6:	e8 a3 0b 00 00       	call   80218e <sys_allocateMem>
  8015eb:	83 c4 10             	add    $0x10,%esp

			heap_size[cnt_mem].size = size;
  8015ee:	a1 20 30 80 00       	mov    0x803020,%eax
  8015f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8015f6:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8015fd:	a1 20 30 80 00       	mov    0x803020,%eax
  801602:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801608:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
			cnt_mem++;
  80160f:	a1 20 30 80 00       	mov    0x803020,%eax
  801614:	40                   	inc    %eax
  801615:	a3 20 30 80 00       	mov    %eax,0x803020
			int i = 0;
  80161a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  801621:	eb 2e                	jmp    801651 <malloc+0xfa>
			{

				heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801623:	a1 04 30 80 00       	mov    0x803004,%eax
  801628:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] = 1;
  80162d:	c1 e8 0c             	shr    $0xc,%eax
  801630:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801637:	01 00 00 00 

				ptr_uheap += (uint32) PAGE_SIZE;
  80163b:	a1 04 30 80 00       	mov    0x803004,%eax
  801640:	05 00 10 00 00       	add    $0x1000,%eax
  801645:	a3 04 30 80 00       	mov    %eax,0x803004
			heap_size[cnt_mem].size = size;
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
			cnt_mem++;
			int i = 0;
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  80164a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801654:	3b 45 08             	cmp    0x8(%ebp),%eax
  801657:	72 ca                	jb     801623 <malloc+0xcc>
						/ (uint32) PAGE_SIZE)] = 1;

				ptr_uheap += (uint32) PAGE_SIZE;
			}

			return ret;
  801659:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80165f:	e9 93 08 00 00       	jmp    801ef7 <malloc+0x9a0>

		} else {
			// second we can allocate by " Strategy NEXTFIT "
			void* temp_end = NULL;
  801664:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

			int check_start = 0;
  80166b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			// check first that we used " Strategy Continues " before and not do it again and turn to NEXTFIT
			if (!check) {
  801672:	a1 40 30 98 00       	mov    0x983040,%eax
  801677:	85 c0                	test   %eax,%eax
  801679:	75 1d                	jne    801698 <malloc+0x141>
				ptr_uheap = (uint32) USER_HEAP_START;
  80167b:	c7 05 04 30 80 00 00 	movl   $0x80000000,0x803004
  801682:	00 00 80 
				check = 1;
  801685:	c7 05 40 30 98 00 01 	movl   $0x1,0x983040
  80168c:	00 00 00 
				check_start = 1;// to dont use second loop CZ ptr_uheap start from USER_HEAP_START
  80168f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  801696:	eb 08                	jmp    8016a0 <malloc+0x149>
			} else {
				temp_end = (void*) ptr_uheap;
  801698:	a1 04 30 80 00       	mov    0x803004,%eax
  80169d:	89 45 f0             	mov    %eax,-0x10(%ebp)

			}

			uint32 sz = 0;
  8016a0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
			int f = 0;
  8016a7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			uint32 ptr = ptr_uheap;
  8016ae:	a1 04 30 80 00       	mov    0x803004,%eax
  8016b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  8016b6:	eb 4d                	jmp    801705 <malloc+0x1ae>
				if (sz == size) {
  8016b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016bb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8016be:	75 09                	jne    8016c9 <malloc+0x172>
					f = 1;
  8016c0:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  8016c7:	eb 45                	jmp    80170e <malloc+0x1b7>
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  8016c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016cc:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] == 0) {
  8016d1:	c1 e8 0c             	shr    $0xc,%eax
			while (ptr < (uint32) USER_HEAP_MAX) {
				if (sz == size) {
					f = 1;
					break;
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  8016d4:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  8016db:	85 c0                	test   %eax,%eax
  8016dd:	75 10                	jne    8016ef <malloc+0x198>
						/ (uint32) PAGE_SIZE)] == 0) {

					sz += PAGE_SIZE;
  8016df:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
					ptr += PAGE_SIZE;
  8016e6:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  8016ed:	eb 16                	jmp    801705 <malloc+0x1ae>
				} else {
					sz = 0;
  8016ef:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
					ptr += PAGE_SIZE;
  8016f6:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
					ptr_uheap = ptr;
  8016fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801700:	a3 04 30 80 00       	mov    %eax,0x803004

			uint32 sz = 0;
			int f = 0;
			uint32 ptr = ptr_uheap;
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  801705:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  80170c:	76 aa                	jbe    8016b8 <malloc+0x161>
					ptr_uheap = ptr;
				}

			}

			if (f) {
  80170e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801712:	0f 84 95 00 00 00    	je     8017ad <malloc+0x256>

				void* ret = (void *) ptr_uheap;
  801718:	a1 04 30 80 00       	mov    0x803004,%eax
  80171d:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

				sys_allocateMem(ptr_uheap, size);
  801723:	a1 04 30 80 00       	mov    0x803004,%eax
  801728:	83 ec 08             	sub    $0x8,%esp
  80172b:	ff 75 08             	pushl  0x8(%ebp)
  80172e:	50                   	push   %eax
  80172f:	e8 5a 0a 00 00       	call   80218e <sys_allocateMem>
  801734:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  801737:	a1 20 30 80 00       	mov    0x803020,%eax
  80173c:	8b 55 08             	mov    0x8(%ebp),%edx
  80173f:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801746:	a1 20 30 80 00       	mov    0x803020,%eax
  80174b:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801751:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
				cnt_mem++;
  801758:	a1 20 30 80 00       	mov    0x803020,%eax
  80175d:	40                   	inc    %eax
  80175e:	a3 20 30 80 00       	mov    %eax,0x803020
				int i = 0;
  801763:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  80176a:	eb 2e                	jmp    80179a <malloc+0x243>
				{

					heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  80176c:	a1 04 30 80 00       	mov    0x803004,%eax
  801771:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  801776:	c1 e8 0c             	shr    $0xc,%eax
  801779:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801780:	01 00 00 00 

					ptr_uheap += (uint32) PAGE_SIZE;
  801784:	a1 04 30 80 00       	mov    0x803004,%eax
  801789:	05 00 10 00 00       	add    $0x1000,%eax
  80178e:	a3 04 30 80 00       	mov    %eax,0x803004
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
				cnt_mem++;
				int i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801793:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  80179a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80179d:	3b 45 08             	cmp    0x8(%ebp),%eax
  8017a0:	72 ca                	jb     80176c <malloc+0x215>
							/ (uint32) PAGE_SIZE)] = 1;

					ptr_uheap += (uint32) PAGE_SIZE;
				}

				return ret;
  8017a2:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8017a8:	e9 4a 07 00 00       	jmp    801ef7 <malloc+0x9a0>

			} else {

				if (check_start) {
  8017ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017b1:	74 0a                	je     8017bd <malloc+0x266>

					return NULL;
  8017b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b8:	e9 3a 07 00 00       	jmp    801ef7 <malloc+0x9a0>
				}

//////////////back loop////////////////

				uint32 sz = 0;
  8017bd:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
				int f = 0;
  8017c4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				uint32 ptr = USER_HEAP_START;
  8017cb:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
				ptr_uheap = USER_HEAP_START;
  8017d2:	c7 05 04 30 80 00 00 	movl   $0x80000000,0x803004
  8017d9:	00 00 80 
				while (ptr < (uint32) temp_end) {
  8017dc:	eb 4d                	jmp    80182b <malloc+0x2d4>
					if (sz == size) {
  8017de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8017e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8017e4:	75 09                	jne    8017ef <malloc+0x298>
						f = 1;
  8017e6:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
						break;
  8017ed:	eb 44                	jmp    801833 <malloc+0x2dc>
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  8017ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8017f2:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] == 0) {
  8017f7:	c1 e8 0c             	shr    $0xc,%eax
				while (ptr < (uint32) temp_end) {
					if (sz == size) {
						f = 1;
						break;
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  8017fa:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  801801:	85 c0                	test   %eax,%eax
  801803:	75 10                	jne    801815 <malloc+0x2be>
							/ (uint32) PAGE_SIZE)] == 0) {

						sz += PAGE_SIZE;
  801805:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
						ptr += PAGE_SIZE;
  80180c:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
  801813:	eb 16                	jmp    80182b <malloc+0x2d4>
					} else {
						sz = 0;
  801815:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
						ptr += PAGE_SIZE;
  80181c:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
						ptr_uheap = ptr;
  801823:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801826:	a3 04 30 80 00       	mov    %eax,0x803004

				uint32 sz = 0;
				int f = 0;
				uint32 ptr = USER_HEAP_START;
				ptr_uheap = USER_HEAP_START;
				while (ptr < (uint32) temp_end) {
  80182b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182e:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801831:	72 ab                	jb     8017de <malloc+0x287>
						ptr_uheap = ptr;
					}

				}

				if (f) {
  801833:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801837:	0f 84 95 00 00 00    	je     8018d2 <malloc+0x37b>

					void* ret = (void *) ptr_uheap;
  80183d:	a1 04 30 80 00       	mov    0x803004,%eax
  801842:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

					sys_allocateMem(ptr_uheap, size);
  801848:	a1 04 30 80 00       	mov    0x803004,%eax
  80184d:	83 ec 08             	sub    $0x8,%esp
  801850:	ff 75 08             	pushl  0x8(%ebp)
  801853:	50                   	push   %eax
  801854:	e8 35 09 00 00       	call   80218e <sys_allocateMem>
  801859:	83 c4 10             	add    $0x10,%esp

					heap_size[cnt_mem].size = size;
  80185c:	a1 20 30 80 00       	mov    0x803020,%eax
  801861:	8b 55 08             	mov    0x8(%ebp),%edx
  801864:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
  80186b:	a1 20 30 80 00       	mov    0x803020,%eax
  801870:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801876:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
					cnt_mem++;
  80187d:	a1 20 30 80 00       	mov    0x803020,%eax
  801882:	40                   	inc    %eax
  801883:	a3 20 30 80 00       	mov    %eax,0x803020
					int i = 0;
  801888:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

					for (; i < size; i += PAGE_SIZE)
  80188f:	eb 2e                	jmp    8018bf <malloc+0x368>
					{

						heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801891:	a1 04 30 80 00       	mov    0x803004,%eax
  801896:	05 00 00 00 80       	add    $0x80000000,%eax
								/ (uint32) PAGE_SIZE)] = 1;
  80189b:	c1 e8 0c             	shr    $0xc,%eax
  80189e:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  8018a5:	01 00 00 00 

						ptr_uheap += (uint32) PAGE_SIZE;
  8018a9:	a1 04 30 80 00       	mov    0x803004,%eax
  8018ae:	05 00 10 00 00       	add    $0x1000,%eax
  8018b3:	a3 04 30 80 00       	mov    %eax,0x803004
					heap_size[cnt_mem].size = size;
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
					cnt_mem++;
					int i = 0;

					for (; i < size; i += PAGE_SIZE)
  8018b8:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  8018bf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018c2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8018c5:	72 ca                	jb     801891 <malloc+0x33a>
								/ (uint32) PAGE_SIZE)] = 1;

						ptr_uheap += (uint32) PAGE_SIZE;
					}

					return ret;
  8018c7:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8018cd:	e9 25 06 00 00       	jmp    801ef7 <malloc+0x9a0>

				} else {

					return NULL;
  8018d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d7:	e9 1b 06 00 00       	jmp    801ef7 <malloc+0x9a0>

		}

	}

	else if (sys_isUHeapPlacementStrategyBESTFIT()) {
  8018dc:	e8 d0 0b 00 00       	call   8024b1 <sys_isUHeapPlacementStrategyBESTFIT>
  8018e1:	85 c0                	test   %eax,%eax
  8018e3:	0f 84 ba 01 00 00    	je     801aa3 <malloc+0x54c>

		size = ROUNDUP(size, PAGE_SIZE);
  8018e9:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  8018f0:	10 00 00 
  8018f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8018f6:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8018fc:	01 d0                	add    %edx,%eax
  8018fe:	48                   	dec    %eax
  8018ff:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  801905:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  80190b:	ba 00 00 00 00       	mov    $0x0,%edx
  801910:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  801916:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  80191c:	29 d0                	sub    %edx,%eax
  80191e:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801921:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801925:	74 09                	je     801930 <malloc+0x3d9>
  801927:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80192e:	76 0a                	jbe    80193a <malloc+0x3e3>
			return NULL;
  801930:	b8 00 00 00 00       	mov    $0x0,%eax
  801935:	e9 bd 05 00 00       	jmp    801ef7 <malloc+0x9a0>
		}
		uint32 ptr = (uint32) USER_HEAP_START;
  80193a:	c7 45 c8 00 00 00 80 	movl   $0x80000000,-0x38(%ebp)
		uint32 temp = 0;
  801941:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		uint32 min_sz = size_uhmem + 1;
  801948:	c7 45 c0 01 00 02 00 	movl   $0x20001,-0x40(%ebp)
		uint32 count = 0;
  80194f:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
		int i = 0;
  801956:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  80195d:	8b 45 08             	mov    0x8(%ebp),%eax
  801960:	c1 e8 0c             	shr    $0xc,%eax
  801963:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801969:	e9 80 00 00 00       	jmp    8019ee <malloc+0x497>

			if (heap_mem[i] == 0) {
  80196e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801971:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  801978:	85 c0                	test   %eax,%eax
  80197a:	75 0c                	jne    801988 <malloc+0x431>

				count++;
  80197c:	ff 45 bc             	incl   -0x44(%ebp)
				ptr += PAGE_SIZE;
  80197f:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801986:	eb 2d                	jmp    8019b5 <malloc+0x45e>
			} else {
				if (num_p <= count && min_sz > count) {
  801988:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80198e:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801991:	77 14                	ja     8019a7 <malloc+0x450>
  801993:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801996:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801999:	76 0c                	jbe    8019a7 <malloc+0x450>

					min_sz = count;
  80199b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80199e:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  8019a1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8019a4:	89 45 c4             	mov    %eax,-0x3c(%ebp)

				}
				count = 0;
  8019a7:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
				ptr += PAGE_SIZE;
  8019ae:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
			}

			if (i == size_uhmem - 1) {
  8019b5:	81 7d b8 ff ff 01 00 	cmpl   $0x1ffff,-0x48(%ebp)
  8019bc:	75 2d                	jne    8019eb <malloc+0x494>

				if (num_p <= count && min_sz > count) {
  8019be:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  8019c4:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  8019c7:	77 22                	ja     8019eb <malloc+0x494>
  8019c9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8019cc:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  8019cf:	76 1a                	jbe    8019eb <malloc+0x494>

					min_sz = count;
  8019d1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8019d4:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  8019d7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8019da:	89 45 c4             	mov    %eax,-0x3c(%ebp)
					count = 0;
  8019dd:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
					ptr += PAGE_SIZE;
  8019e4:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  8019eb:	ff 45 b8             	incl   -0x48(%ebp)
  8019ee:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8019f1:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  8019f6:	0f 86 72 ff ff ff    	jbe    80196e <malloc+0x417>

			}

		}

		if (num_p > min_sz || temp == 0) {
  8019fc:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801a02:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  801a05:	77 06                	ja     801a0d <malloc+0x4b6>
  801a07:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801a0b:	75 0a                	jne    801a17 <malloc+0x4c0>
			return NULL;
  801a0d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a12:	e9 e0 04 00 00       	jmp    801ef7 <malloc+0x9a0>

		}

		temp = temp - (PAGE_SIZE * min_sz);
  801a17:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801a1a:	c1 e0 0c             	shl    $0xc,%eax
  801a1d:	29 45 c4             	sub    %eax,-0x3c(%ebp)
		void* ret = (void*) temp;
  801a20:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801a23:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)

		sys_allocateMem(temp, size);
  801a29:	83 ec 08             	sub    $0x8,%esp
  801a2c:	ff 75 08             	pushl  0x8(%ebp)
  801a2f:	ff 75 c4             	pushl  -0x3c(%ebp)
  801a32:	e8 57 07 00 00       	call   80218e <sys_allocateMem>
  801a37:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801a3a:	a1 20 30 80 00       	mov    0x803020,%eax
  801a3f:	8b 55 08             	mov    0x8(%ebp),%edx
  801a42:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801a49:	a1 20 30 80 00       	mov    0x803020,%eax
  801a4e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801a51:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
		cnt_mem++;
  801a58:	a1 20 30 80 00       	mov    0x803020,%eax
  801a5d:	40                   	inc    %eax
  801a5e:	a3 20 30 80 00       	mov    %eax,0x803020
		i = 0;
  801a63:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801a6a:	eb 24                	jmp    801a90 <malloc+0x539>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801a6c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801a6f:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801a74:	c1 e8 0c             	shr    $0xc,%eax
  801a77:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801a7e:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801a82:	81 45 c4 00 10 00 00 	addl   $0x1000,-0x3c(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801a89:	81 45 b8 00 10 00 00 	addl   $0x1000,-0x48(%ebp)
  801a90:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801a93:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a96:	72 d4                	jb     801a6c <malloc+0x515>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801a98:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801a9e:	e9 54 04 00 00       	jmp    801ef7 <malloc+0x9a0>

	} else if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801aa3:	e8 d8 09 00 00       	call   802480 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801aa8:	85 c0                	test   %eax,%eax
  801aaa:	0f 84 88 01 00 00    	je     801c38 <malloc+0x6e1>

		size = ROUNDUP(size, PAGE_SIZE);
  801ab0:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  801ab7:	10 00 00 
  801aba:	8b 55 08             	mov    0x8(%ebp),%edx
  801abd:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  801ac3:	01 d0                	add    %edx,%eax
  801ac5:	48                   	dec    %eax
  801ac6:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  801acc:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801ad2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ad7:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  801add:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801ae3:	29 d0                	sub    %edx,%eax
  801ae5:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801ae8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801aec:	74 09                	je     801af7 <malloc+0x5a0>
  801aee:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801af5:	76 0a                	jbe    801b01 <malloc+0x5aa>
			return NULL;
  801af7:	b8 00 00 00 00       	mov    $0x0,%eax
  801afc:	e9 f6 03 00 00       	jmp    801ef7 <malloc+0x9a0>
		}

		uint32 ptr = (uint32) USER_HEAP_START;
  801b01:	c7 45 b4 00 00 00 80 	movl   $0x80000000,-0x4c(%ebp)
		uint32 temp = 0;
  801b08:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
		uint32 found = 0;
  801b0f:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		uint32 count = 0;
  801b16:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
		int i = 0;
  801b1d:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801b24:	8b 45 08             	mov    0x8(%ebp),%eax
  801b27:	c1 e8 0c             	shr    $0xc,%eax
  801b2a:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

		for (; i < size_uhmem; i++) {
  801b30:	eb 5a                	jmp    801b8c <malloc+0x635>

			if (heap_mem[i] == 0) {
  801b32:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801b35:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  801b3c:	85 c0                	test   %eax,%eax
  801b3e:	75 0c                	jne    801b4c <malloc+0x5f5>

				count++;
  801b40:	ff 45 a8             	incl   -0x58(%ebp)
				ptr += PAGE_SIZE;
  801b43:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
  801b4a:	eb 22                	jmp    801b6e <malloc+0x617>
			} else {
				if (num_p <= count) {
  801b4c:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801b52:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801b55:	77 09                	ja     801b60 <malloc+0x609>

					found = 1;
  801b57:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)

					break;
  801b5e:	eb 36                	jmp    801b96 <malloc+0x63f>
				}
				count = 0;
  801b60:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
				ptr += PAGE_SIZE;
  801b67:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
			}

			if (i == size_uhmem - 1) {
  801b6e:	81 7d a4 ff ff 01 00 	cmpl   $0x1ffff,-0x5c(%ebp)
  801b75:	75 12                	jne    801b89 <malloc+0x632>

				if (num_p <= count) {
  801b77:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801b7d:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801b80:	77 07                	ja     801b89 <malloc+0x632>

					found = 1;
  801b82:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
		uint32 found = 0;
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		for (; i < size_uhmem; i++) {
  801b89:	ff 45 a4             	incl   -0x5c(%ebp)
  801b8c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801b8f:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801b94:	76 9c                	jbe    801b32 <malloc+0x5db>

			}

		}

		if (!found) {
  801b96:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  801b9a:	75 0a                	jne    801ba6 <malloc+0x64f>
			return NULL;
  801b9c:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba1:	e9 51 03 00 00       	jmp    801ef7 <malloc+0x9a0>

		}

		temp = ptr;
  801ba6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801ba9:	89 45 b0             	mov    %eax,-0x50(%ebp)
		temp = temp - (PAGE_SIZE * count);
  801bac:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801baf:	c1 e0 0c             	shl    $0xc,%eax
  801bb2:	29 45 b0             	sub    %eax,-0x50(%ebp)
		void* ret = (void*) temp;
  801bb5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801bb8:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)

		sys_allocateMem(temp, size);
  801bbe:	83 ec 08             	sub    $0x8,%esp
  801bc1:	ff 75 08             	pushl  0x8(%ebp)
  801bc4:	ff 75 b0             	pushl  -0x50(%ebp)
  801bc7:	e8 c2 05 00 00       	call   80218e <sys_allocateMem>
  801bcc:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801bcf:	a1 20 30 80 00       	mov    0x803020,%eax
  801bd4:	8b 55 08             	mov    0x8(%ebp),%edx
  801bd7:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801bde:	a1 20 30 80 00       	mov    0x803020,%eax
  801be3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801be6:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
		cnt_mem++;
  801bed:	a1 20 30 80 00       	mov    0x803020,%eax
  801bf2:	40                   	inc    %eax
  801bf3:	a3 20 30 80 00       	mov    %eax,0x803020
		i = 0;
  801bf8:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801bff:	eb 24                	jmp    801c25 <malloc+0x6ce>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801c01:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801c04:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801c09:	c1 e8 0c             	shr    $0xc,%eax
  801c0c:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801c13:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801c17:	81 45 b0 00 10 00 00 	addl   $0x1000,-0x50(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801c1e:	81 45 a4 00 10 00 00 	addl   $0x1000,-0x5c(%ebp)
  801c25:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801c28:	3b 45 08             	cmp    0x8(%ebp),%eax
  801c2b:	72 d4                	jb     801c01 <malloc+0x6aa>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801c2d:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  801c33:	e9 bf 02 00 00       	jmp    801ef7 <malloc+0x9a0>

	}
	else if(sys_isUHeapPlacementStrategyWORSTFIT())
  801c38:	e8 d6 08 00 00       	call   802513 <sys_isUHeapPlacementStrategyWORSTFIT>
  801c3d:	85 c0                	test   %eax,%eax
  801c3f:	0f 84 ba 01 00 00    	je     801dff <malloc+0x8a8>
	{
		size = ROUNDUP(size, PAGE_SIZE);
  801c45:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  801c4c:	10 00 00 
  801c4f:	8b 55 08             	mov    0x8(%ebp),%edx
  801c52:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  801c58:	01 d0                	add    %edx,%eax
  801c5a:	48                   	dec    %eax
  801c5b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  801c61:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  801c67:	ba 00 00 00 00       	mov    $0x0,%edx
  801c6c:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  801c72:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  801c78:	29 d0                	sub    %edx,%eax
  801c7a:	89 45 08             	mov    %eax,0x8(%ebp)

				if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801c7d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c81:	74 09                	je     801c8c <malloc+0x735>
  801c83:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801c8a:	76 0a                	jbe    801c96 <malloc+0x73f>
					return NULL;
  801c8c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c91:	e9 61 02 00 00       	jmp    801ef7 <malloc+0x9a0>
				}
				uint32 ptr = (uint32) USER_HEAP_START;
  801c96:	c7 45 a0 00 00 00 80 	movl   $0x80000000,-0x60(%ebp)
				uint32 temp = 0;
  801c9d:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
				uint32 max_sz = -1;
  801ca4:	c7 45 98 ff ff ff ff 	movl   $0xffffffff,-0x68(%ebp)
				uint32 count = 0;
  801cab:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
				int i = 0;
  801cb2:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				uint32 num_p = size / PAGE_SIZE;
  801cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbc:	c1 e8 0c             	shr    $0xc,%eax
  801cbf:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  801cc5:	e9 80 00 00 00       	jmp    801d4a <malloc+0x7f3>

					if (heap_mem[i] == 0) {
  801cca:	8b 45 90             	mov    -0x70(%ebp),%eax
  801ccd:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  801cd4:	85 c0                	test   %eax,%eax
  801cd6:	75 0c                	jne    801ce4 <malloc+0x78d>

						count++;
  801cd8:	ff 45 94             	incl   -0x6c(%ebp)
						ptr += PAGE_SIZE;
  801cdb:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
  801ce2:	eb 2d                	jmp    801d11 <malloc+0x7ba>
					} else {
						if (num_p <= count && max_sz < count) {
  801ce4:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801cea:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801ced:	77 14                	ja     801d03 <malloc+0x7ac>
  801cef:	8b 45 98             	mov    -0x68(%ebp),%eax
  801cf2:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801cf5:	73 0c                	jae    801d03 <malloc+0x7ac>

							max_sz = count;
  801cf7:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801cfa:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  801cfd:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801d00:	89 45 9c             	mov    %eax,-0x64(%ebp)

						}
						count = 0;
  801d03:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
						ptr += PAGE_SIZE;
  801d0a:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
					}

					if (i == size_uhmem - 1) {
  801d11:	81 7d 90 ff ff 01 00 	cmpl   $0x1ffff,-0x70(%ebp)
  801d18:	75 2d                	jne    801d47 <malloc+0x7f0>

						if (num_p <= count && max_sz > count) {
  801d1a:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801d20:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801d23:	77 22                	ja     801d47 <malloc+0x7f0>
  801d25:	8b 45 98             	mov    -0x68(%ebp),%eax
  801d28:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801d2b:	76 1a                	jbe    801d47 <malloc+0x7f0>

							max_sz = count;
  801d2d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801d30:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  801d33:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801d36:	89 45 9c             	mov    %eax,-0x64(%ebp)
							count = 0;
  801d39:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
							ptr += PAGE_SIZE;
  801d40:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
				uint32 count = 0;
				int i = 0;
				uint32 num_p = size / PAGE_SIZE;

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  801d47:	ff 45 90             	incl   -0x70(%ebp)
  801d4a:	8b 45 90             	mov    -0x70(%ebp),%eax
  801d4d:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801d52:	0f 86 72 ff ff ff    	jbe    801cca <malloc+0x773>

					}

				}

				if (num_p > max_sz || temp == 0) {
  801d58:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801d5e:	3b 45 98             	cmp    -0x68(%ebp),%eax
  801d61:	77 06                	ja     801d69 <malloc+0x812>
  801d63:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  801d67:	75 0a                	jne    801d73 <malloc+0x81c>
					return NULL;
  801d69:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6e:	e9 84 01 00 00       	jmp    801ef7 <malloc+0x9a0>

				}

				temp = temp - (PAGE_SIZE * max_sz);
  801d73:	8b 45 98             	mov    -0x68(%ebp),%eax
  801d76:	c1 e0 0c             	shl    $0xc,%eax
  801d79:	29 45 9c             	sub    %eax,-0x64(%ebp)
				void* ret = (void*) temp;
  801d7c:	8b 45 9c             	mov    -0x64(%ebp),%eax
  801d7f:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

				sys_allocateMem(temp, size);
  801d85:	83 ec 08             	sub    $0x8,%esp
  801d88:	ff 75 08             	pushl  0x8(%ebp)
  801d8b:	ff 75 9c             	pushl  -0x64(%ebp)
  801d8e:	e8 fb 03 00 00       	call   80218e <sys_allocateMem>
  801d93:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  801d96:	a1 20 30 80 00       	mov    0x803020,%eax
  801d9b:	8b 55 08             	mov    0x8(%ebp),%edx
  801d9e:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) temp;
  801da5:	a1 20 30 80 00       	mov    0x803020,%eax
  801daa:	8b 55 9c             	mov    -0x64(%ebp),%edx
  801dad:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
				cnt_mem++;
  801db4:	a1 20 30 80 00       	mov    0x803020,%eax
  801db9:	40                   	inc    %eax
  801dba:	a3 20 30 80 00       	mov    %eax,0x803020
				i = 0;
  801dbf:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801dc6:	eb 24                	jmp    801dec <malloc+0x895>
				{

					heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801dc8:	8b 45 9c             	mov    -0x64(%ebp),%eax
  801dcb:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  801dd0:	c1 e8 0c             	shr    $0xc,%eax
  801dd3:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801dda:	01 00 00 00 

					temp += (uint32) PAGE_SIZE;
  801dde:	81 45 9c 00 10 00 00 	addl   $0x1000,-0x64(%ebp)
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) temp;
				cnt_mem++;
				i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801de5:	81 45 90 00 10 00 00 	addl   $0x1000,-0x70(%ebp)
  801dec:	8b 45 90             	mov    -0x70(%ebp),%eax
  801def:	3b 45 08             	cmp    0x8(%ebp),%eax
  801df2:	72 d4                	jb     801dc8 <malloc+0x871>

					temp += (uint32) PAGE_SIZE;
				}

				//cprintf("\n size = %d.........vir= %d  \n",num_p,((uint32) ret-USER_HEAP_START)/PAGE_SIZE);
				return ret;
  801df4:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  801dfa:	e9 f8 00 00 00       	jmp    801ef7 <malloc+0x9a0>

	}
// this is to make malloc is work
	void* ret = NULL;
  801dff:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
	size = ROUNDUP(size, PAGE_SIZE);
  801e06:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  801e0d:	10 00 00 
  801e10:	8b 55 08             	mov    0x8(%ebp),%edx
  801e13:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  801e19:	01 d0                	add    %edx,%eax
  801e1b:	48                   	dec    %eax
  801e1c:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  801e22:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  801e28:	ba 00 00 00 00       	mov    $0x0,%edx
  801e2d:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  801e33:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  801e39:	29 d0                	sub    %edx,%eax
  801e3b:	89 45 08             	mov    %eax,0x8(%ebp)

	if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801e3e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e42:	74 09                	je     801e4d <malloc+0x8f6>
  801e44:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801e4b:	76 0a                	jbe    801e57 <malloc+0x900>
		return NULL;
  801e4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e52:	e9 a0 00 00 00       	jmp    801ef7 <malloc+0x9a0>
	}

	if (ptr_uheap + size <= (uint32) USER_HEAP_MAX) {
  801e57:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e60:	01 d0                	add    %edx,%eax
  801e62:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801e67:	0f 87 87 00 00 00    	ja     801ef4 <malloc+0x99d>

		ret = (void *) ptr_uheap;
  801e6d:	a1 04 30 80 00       	mov    0x803004,%eax
  801e72:	89 45 8c             	mov    %eax,-0x74(%ebp)
		sys_allocateMem(ptr_uheap, size);
  801e75:	a1 04 30 80 00       	mov    0x803004,%eax
  801e7a:	83 ec 08             	sub    $0x8,%esp
  801e7d:	ff 75 08             	pushl  0x8(%ebp)
  801e80:	50                   	push   %eax
  801e81:	e8 08 03 00 00       	call   80218e <sys_allocateMem>
  801e86:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801e89:	a1 20 30 80 00       	mov    0x803020,%eax
  801e8e:	8b 55 08             	mov    0x8(%ebp),%edx
  801e91:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801e98:	a1 20 30 80 00       	mov    0x803020,%eax
  801e9d:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801ea3:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
		cnt_mem++;
  801eaa:	a1 20 30 80 00       	mov    0x803020,%eax
  801eaf:	40                   	inc    %eax
  801eb0:	a3 20 30 80 00       	mov    %eax,0x803020
		int i = 0;
  801eb5:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)

		for (; i < size; i += PAGE_SIZE)
  801ebc:	eb 2e                	jmp    801eec <malloc+0x995>
		{

			heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801ebe:	a1 04 30 80 00       	mov    0x803004,%eax
  801ec3:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801ec8:	c1 e8 0c             	shr    $0xc,%eax
  801ecb:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801ed2:	01 00 00 00 

			ptr_uheap += (uint32) PAGE_SIZE;
  801ed6:	a1 04 30 80 00       	mov    0x803004,%eax
  801edb:	05 00 10 00 00       	add    $0x1000,%eax
  801ee0:	a3 04 30 80 00       	mov    %eax,0x803004
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
		cnt_mem++;
		int i = 0;

		for (; i < size; i += PAGE_SIZE)
  801ee5:	81 45 88 00 10 00 00 	addl   $0x1000,-0x78(%ebp)
  801eec:	8b 45 88             	mov    -0x78(%ebp),%eax
  801eef:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ef2:	72 ca                	jb     801ebe <malloc+0x967>
					/ (uint32) PAGE_SIZE)] = 1;

			ptr_uheap += (uint32) PAGE_SIZE;
		}
	}
	return ret;
  801ef4:	8b 45 8c             	mov    -0x74(%ebp),%eax

	//TODO: [PROJECT 2016 - BONUS2] Apply FIRST FIT and WORST FIT policies

//return 0;

}
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <free>:
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address) {
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
  801efc:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
  801eff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; inx < cnt_mem; inx++) {
  801f06:	e9 c1 00 00 00       	jmp    801fcc <free+0xd3>
		if (heap_size[inx].vir == virtual_address) {
  801f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0e:	8b 04 c5 40 30 88 00 	mov    0x883040(,%eax,8),%eax
  801f15:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f18:	0f 85 ab 00 00 00    	jne    801fc9 <free+0xd0>

			if (heap_size[inx].size == 0) {
  801f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f21:	8b 04 c5 44 30 88 00 	mov    0x883044(,%eax,8),%eax
  801f28:	85 c0                	test   %eax,%eax
  801f2a:	75 21                	jne    801f4d <free+0x54>
				heap_size[inx].size = 0;
  801f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2f:	c7 04 c5 44 30 88 00 	movl   $0x0,0x883044(,%eax,8)
  801f36:	00 00 00 00 
				heap_size[inx].vir = NULL;
  801f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3d:	c7 04 c5 40 30 88 00 	movl   $0x0,0x883040(,%eax,8)
  801f44:	00 00 00 00 
				return;
  801f48:	e9 8d 00 00 00       	jmp    801fda <free+0xe1>

			}

			sys_freeMem((uint32) virtual_address, heap_size[inx].size);
  801f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f50:	8b 14 c5 44 30 88 00 	mov    0x883044(,%eax,8),%edx
  801f57:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5a:	83 ec 08             	sub    $0x8,%esp
  801f5d:	52                   	push   %edx
  801f5e:	50                   	push   %eax
  801f5f:	e8 0e 02 00 00       	call   802172 <sys_freeMem>
  801f64:	83 c4 10             	add    $0x10,%esp

			int i = 0;
  801f67:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
  801f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f71:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  801f74:	eb 24                	jmp    801f9a <free+0xa1>
			{
				heap_mem[(int) (((uint32) va - USER_HEAP_START) / PAGE_SIZE)] =
  801f76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f79:	05 00 00 00 80       	add    $0x80000000,%eax
  801f7e:	c1 e8 0c             	shr    $0xc,%eax
  801f81:	c7 04 85 40 30 80 00 	movl   $0x0,0x803040(,%eax,4)
  801f88:	00 00 00 00 
						0;

				va += PAGE_SIZE;
  801f8c:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
			sys_freeMem((uint32) virtual_address, heap_size[inx].size);

			int i = 0;
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  801f93:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9d:	8b 14 c5 44 30 88 00 	mov    0x883044(,%eax,8),%edx
  801fa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa7:	39 c2                	cmp    %eax,%edx
  801fa9:	77 cb                	ja     801f76 <free+0x7d>

				va += PAGE_SIZE;

			}

			heap_size[inx].size = 0;
  801fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fae:	c7 04 c5 44 30 88 00 	movl   $0x0,0x883044(,%eax,8)
  801fb5:	00 00 00 00 
			heap_size[inx].vir = NULL;
  801fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbc:	c7 04 c5 40 30 88 00 	movl   $0x0,0x883040(,%eax,8)
  801fc3:	00 00 00 00 
			break;
  801fc7:	eb 11                	jmp    801fda <free+0xe1>
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
	for (; inx < cnt_mem; inx++) {
  801fc9:	ff 45 f4             	incl   -0xc(%ebp)
  801fcc:	a1 20 30 80 00       	mov    0x803020,%eax
  801fd1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801fd4:	0f 8c 31 ff ff ff    	jl     801f0b <free+0x12>
	}

	//get the size of the given allocation using its address
	//you need to call sys_freeMem()

}
  801fda:	c9                   	leave  
  801fdb:	c3                   	ret    

00801fdc <realloc>:
//  Hint: you may need to use the sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size) {
  801fdc:	55                   	push   %ebp
  801fdd:	89 e5                	mov    %esp,%ebp
  801fdf:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2016 - BONUS4] realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801fe2:	83 ec 04             	sub    $0x4,%esp
  801fe5:	68 30 2c 80 00       	push   $0x802c30
  801fea:	68 1c 02 00 00       	push   $0x21c
  801fef:	68 56 2c 80 00       	push   $0x802c56
  801ff4:	e8 66 05 00 00       	call   80255f <_panic>

00801ff9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
  801ffc:	57                   	push   %edi
  801ffd:	56                   	push   %esi
  801ffe:	53                   	push   %ebx
  801fff:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802002:	8b 45 08             	mov    0x8(%ebp),%eax
  802005:	8b 55 0c             	mov    0xc(%ebp),%edx
  802008:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80200b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80200e:	8b 7d 18             	mov    0x18(%ebp),%edi
  802011:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802014:	cd 30                	int    $0x30
  802016:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802019:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80201c:	83 c4 10             	add    $0x10,%esp
  80201f:	5b                   	pop    %ebx
  802020:	5e                   	pop    %esi
  802021:	5f                   	pop    %edi
  802022:	5d                   	pop    %ebp
  802023:	c3                   	ret    

00802024 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  802027:	8b 45 08             	mov    0x8(%ebp),%eax
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	ff 75 0c             	pushl  0xc(%ebp)
  802033:	50                   	push   %eax
  802034:	6a 00                	push   $0x0
  802036:	e8 be ff ff ff       	call   801ff9 <syscall>
  80203b:	83 c4 18             	add    $0x18,%esp
}
  80203e:	90                   	nop
  80203f:	c9                   	leave  
  802040:	c3                   	ret    

00802041 <sys_cgetc>:

int
sys_cgetc(void)
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 01                	push   $0x1
  802050:	e8 a4 ff ff ff       	call   801ff9 <syscall>
  802055:	83 c4 18             	add    $0x18,%esp
}
  802058:	c9                   	leave  
  802059:	c3                   	ret    

0080205a <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80205d:	8b 45 08             	mov    0x8(%ebp),%eax
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	50                   	push   %eax
  802069:	6a 03                	push   $0x3
  80206b:	e8 89 ff ff ff       	call   801ff9 <syscall>
  802070:	83 c4 18             	add    $0x18,%esp
}
  802073:	c9                   	leave  
  802074:	c3                   	ret    

00802075 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	6a 02                	push   $0x2
  802084:	e8 70 ff ff ff       	call   801ff9 <syscall>
  802089:	83 c4 18             	add    $0x18,%esp
}
  80208c:	c9                   	leave  
  80208d:	c3                   	ret    

0080208e <sys_env_exit>:

void sys_env_exit(void)
{
  80208e:	55                   	push   %ebp
  80208f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	6a 04                	push   $0x4
  80209d:	e8 57 ff ff ff       	call   801ff9 <syscall>
  8020a2:	83 c4 18             	add    $0x18,%esp
}
  8020a5:	90                   	nop
  8020a6:	c9                   	leave  
  8020a7:	c3                   	ret    

008020a8 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 00                	push   $0x0
  8020b7:	52                   	push   %edx
  8020b8:	50                   	push   %eax
  8020b9:	6a 05                	push   $0x5
  8020bb:	e8 39 ff ff ff       	call   801ff9 <syscall>
  8020c0:	83 c4 18             	add    $0x18,%esp
}
  8020c3:	c9                   	leave  
  8020c4:	c3                   	ret    

008020c5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
  8020c8:	56                   	push   %esi
  8020c9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020ca:	8b 75 18             	mov    0x18(%ebp),%esi
  8020cd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d9:	56                   	push   %esi
  8020da:	53                   	push   %ebx
  8020db:	51                   	push   %ecx
  8020dc:	52                   	push   %edx
  8020dd:	50                   	push   %eax
  8020de:	6a 06                	push   $0x6
  8020e0:	e8 14 ff ff ff       	call   801ff9 <syscall>
  8020e5:	83 c4 18             	add    $0x18,%esp
}
  8020e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020eb:	5b                   	pop    %ebx
  8020ec:	5e                   	pop    %esi
  8020ed:	5d                   	pop    %ebp
  8020ee:	c3                   	ret    

008020ef <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8020f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	52                   	push   %edx
  8020ff:	50                   	push   %eax
  802100:	6a 07                	push   $0x7
  802102:	e8 f2 fe ff ff       	call   801ff9 <syscall>
  802107:	83 c4 18             	add    $0x18,%esp
}
  80210a:	c9                   	leave  
  80210b:	c3                   	ret    

0080210c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80210c:	55                   	push   %ebp
  80210d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	ff 75 0c             	pushl  0xc(%ebp)
  802118:	ff 75 08             	pushl  0x8(%ebp)
  80211b:	6a 08                	push   $0x8
  80211d:	e8 d7 fe ff ff       	call   801ff9 <syscall>
  802122:	83 c4 18             	add    $0x18,%esp
}
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	6a 09                	push   $0x9
  802136:	e8 be fe ff ff       	call   801ff9 <syscall>
  80213b:	83 c4 18             	add    $0x18,%esp
}
  80213e:	c9                   	leave  
  80213f:	c3                   	ret    

00802140 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 0a                	push   $0xa
  80214f:	e8 a5 fe ff ff       	call   801ff9 <syscall>
  802154:	83 c4 18             	add    $0x18,%esp
}
  802157:	c9                   	leave  
  802158:	c3                   	ret    

00802159 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802159:	55                   	push   %ebp
  80215a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	6a 00                	push   $0x0
  802166:	6a 0b                	push   $0xb
  802168:	e8 8c fe ff ff       	call   801ff9 <syscall>
  80216d:	83 c4 18             	add    $0x18,%esp
}
  802170:	c9                   	leave  
  802171:	c3                   	ret    

00802172 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  802172:	55                   	push   %ebp
  802173:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  802175:	6a 00                	push   $0x0
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	ff 75 0c             	pushl  0xc(%ebp)
  80217e:	ff 75 08             	pushl  0x8(%ebp)
  802181:	6a 0d                	push   $0xd
  802183:	e8 71 fe ff ff       	call   801ff9 <syscall>
  802188:	83 c4 18             	add    $0x18,%esp
	return;
  80218b:	90                   	nop
}
  80218c:	c9                   	leave  
  80218d:	c3                   	ret    

0080218e <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  802191:	6a 00                	push   $0x0
  802193:	6a 00                	push   $0x0
  802195:	6a 00                	push   $0x0
  802197:	ff 75 0c             	pushl  0xc(%ebp)
  80219a:	ff 75 08             	pushl  0x8(%ebp)
  80219d:	6a 0e                	push   $0xe
  80219f:	e8 55 fe ff ff       	call   801ff9 <syscall>
  8021a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8021a7:	90                   	nop
}
  8021a8:	c9                   	leave  
  8021a9:	c3                   	ret    

008021aa <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8021aa:	55                   	push   %ebp
  8021ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 00                	push   $0x0
  8021b7:	6a 0c                	push   $0xc
  8021b9:	e8 3b fe ff ff       	call   801ff9 <syscall>
  8021be:	83 c4 18             	add    $0x18,%esp
}
  8021c1:	c9                   	leave  
  8021c2:	c3                   	ret    

008021c3 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8021c3:	55                   	push   %ebp
  8021c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8021c6:	6a 00                	push   $0x0
  8021c8:	6a 00                	push   $0x0
  8021ca:	6a 00                	push   $0x0
  8021cc:	6a 00                	push   $0x0
  8021ce:	6a 00                	push   $0x0
  8021d0:	6a 10                	push   $0x10
  8021d2:	e8 22 fe ff ff       	call   801ff9 <syscall>
  8021d7:	83 c4 18             	add    $0x18,%esp
}
  8021da:	90                   	nop
  8021db:	c9                   	leave  
  8021dc:	c3                   	ret    

008021dd <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8021dd:	55                   	push   %ebp
  8021de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 11                	push   $0x11
  8021ec:	e8 08 fe ff ff       	call   801ff9 <syscall>
  8021f1:	83 c4 18             	add    $0x18,%esp
}
  8021f4:	90                   	nop
  8021f5:	c9                   	leave  
  8021f6:	c3                   	ret    

008021f7 <sys_cputc>:


void
sys_cputc(const char c)
{
  8021f7:	55                   	push   %ebp
  8021f8:	89 e5                	mov    %esp,%ebp
  8021fa:	83 ec 04             	sub    $0x4,%esp
  8021fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802200:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802203:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 00                	push   $0x0
  80220f:	50                   	push   %eax
  802210:	6a 12                	push   $0x12
  802212:	e8 e2 fd ff ff       	call   801ff9 <syscall>
  802217:	83 c4 18             	add    $0x18,%esp
}
  80221a:	90                   	nop
  80221b:	c9                   	leave  
  80221c:	c3                   	ret    

0080221d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80221d:	55                   	push   %ebp
  80221e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	6a 13                	push   $0x13
  80222c:	e8 c8 fd ff ff       	call   801ff9 <syscall>
  802231:	83 c4 18             	add    $0x18,%esp
}
  802234:	90                   	nop
  802235:	c9                   	leave  
  802236:	c3                   	ret    

00802237 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802237:	55                   	push   %ebp
  802238:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80223a:	8b 45 08             	mov    0x8(%ebp),%eax
  80223d:	6a 00                	push   $0x0
  80223f:	6a 00                	push   $0x0
  802241:	6a 00                	push   $0x0
  802243:	ff 75 0c             	pushl  0xc(%ebp)
  802246:	50                   	push   %eax
  802247:	6a 14                	push   $0x14
  802249:	e8 ab fd ff ff       	call   801ff9 <syscall>
  80224e:	83 c4 18             	add    $0x18,%esp
}
  802251:	c9                   	leave  
  802252:	c3                   	ret    

00802253 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  802253:	55                   	push   %ebp
  802254:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  802256:	8b 45 08             	mov    0x8(%ebp),%eax
  802259:	6a 00                	push   $0x0
  80225b:	6a 00                	push   $0x0
  80225d:	6a 00                	push   $0x0
  80225f:	6a 00                	push   $0x0
  802261:	50                   	push   %eax
  802262:	6a 17                	push   $0x17
  802264:	e8 90 fd ff ff       	call   801ff9 <syscall>
  802269:	83 c4 18             	add    $0x18,%esp
}
  80226c:	c9                   	leave  
  80226d:	c3                   	ret    

0080226e <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  80226e:	55                   	push   %ebp
  80226f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  802271:	8b 45 08             	mov    0x8(%ebp),%eax
  802274:	6a 00                	push   $0x0
  802276:	6a 00                	push   $0x0
  802278:	6a 00                	push   $0x0
  80227a:	6a 00                	push   $0x0
  80227c:	50                   	push   %eax
  80227d:	6a 15                	push   $0x15
  80227f:	e8 75 fd ff ff       	call   801ff9 <syscall>
  802284:	83 c4 18             	add    $0x18,%esp
}
  802287:	90                   	nop
  802288:	c9                   	leave  
  802289:	c3                   	ret    

0080228a <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  80228a:	55                   	push   %ebp
  80228b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  80228d:	8b 45 08             	mov    0x8(%ebp),%eax
  802290:	6a 00                	push   $0x0
  802292:	6a 00                	push   $0x0
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	50                   	push   %eax
  802299:	6a 16                	push   $0x16
  80229b:	e8 59 fd ff ff       	call   801ff9 <syscall>
  8022a0:	83 c4 18             	add    $0x18,%esp
}
  8022a3:	90                   	nop
  8022a4:	c9                   	leave  
  8022a5:	c3                   	ret    

008022a6 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
  8022a9:	83 ec 04             	sub    $0x4,%esp
  8022ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8022af:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  8022b2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8022b5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8022b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bc:	6a 00                	push   $0x0
  8022be:	51                   	push   %ecx
  8022bf:	52                   	push   %edx
  8022c0:	ff 75 0c             	pushl  0xc(%ebp)
  8022c3:	50                   	push   %eax
  8022c4:	6a 18                	push   $0x18
  8022c6:	e8 2e fd ff ff       	call   801ff9 <syscall>
  8022cb:	83 c4 18             	add    $0x18,%esp
}
  8022ce:	c9                   	leave  
  8022cf:	c3                   	ret    

008022d0 <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  8022d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	52                   	push   %edx
  8022e0:	50                   	push   %eax
  8022e1:	6a 19                	push   $0x19
  8022e3:	e8 11 fd ff ff       	call   801ff9 <syscall>
  8022e8:	83 c4 18             	add    $0x18,%esp
}
  8022eb:	c9                   	leave  
  8022ec:	c3                   	ret    

008022ed <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  8022ed:	55                   	push   %ebp
  8022ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  8022f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f3:	6a 00                	push   $0x0
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 00                	push   $0x0
  8022f9:	6a 00                	push   $0x0
  8022fb:	50                   	push   %eax
  8022fc:	6a 1a                	push   $0x1a
  8022fe:	e8 f6 fc ff ff       	call   801ff9 <syscall>
  802303:	83 c4 18             	add    $0x18,%esp
}
  802306:	c9                   	leave  
  802307:	c3                   	ret    

00802308 <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  802308:	55                   	push   %ebp
  802309:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  80230b:	6a 00                	push   $0x0
  80230d:	6a 00                	push   $0x0
  80230f:	6a 00                	push   $0x0
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	6a 1b                	push   $0x1b
  802317:	e8 dd fc ff ff       	call   801ff9 <syscall>
  80231c:	83 c4 18             	add    $0x18,%esp
}
  80231f:	c9                   	leave  
  802320:	c3                   	ret    

00802321 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802321:	55                   	push   %ebp
  802322:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802324:	6a 00                	push   $0x0
  802326:	6a 00                	push   $0x0
  802328:	6a 00                	push   $0x0
  80232a:	6a 00                	push   $0x0
  80232c:	6a 00                	push   $0x0
  80232e:	6a 1c                	push   $0x1c
  802330:	e8 c4 fc ff ff       	call   801ff9 <syscall>
  802335:	83 c4 18             	add    $0x18,%esp
}
  802338:	c9                   	leave  
  802339:	c3                   	ret    

0080233a <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  80233a:	55                   	push   %ebp
  80233b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  80233d:	8b 45 08             	mov    0x8(%ebp),%eax
  802340:	6a 00                	push   $0x0
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	ff 75 0c             	pushl  0xc(%ebp)
  802349:	50                   	push   %eax
  80234a:	6a 1d                	push   $0x1d
  80234c:	e8 a8 fc ff ff       	call   801ff9 <syscall>
  802351:	83 c4 18             	add    $0x18,%esp
}
  802354:	c9                   	leave  
  802355:	c3                   	ret    

00802356 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802356:	55                   	push   %ebp
  802357:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802359:	8b 45 08             	mov    0x8(%ebp),%eax
  80235c:	6a 00                	push   $0x0
  80235e:	6a 00                	push   $0x0
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	50                   	push   %eax
  802365:	6a 1e                	push   $0x1e
  802367:	e8 8d fc ff ff       	call   801ff9 <syscall>
  80236c:	83 c4 18             	add    $0x18,%esp
}
  80236f:	90                   	nop
  802370:	c9                   	leave  
  802371:	c3                   	ret    

00802372 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  802372:	55                   	push   %ebp
  802373:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  802375:	8b 45 08             	mov    0x8(%ebp),%eax
  802378:	6a 00                	push   $0x0
  80237a:	6a 00                	push   $0x0
  80237c:	6a 00                	push   $0x0
  80237e:	6a 00                	push   $0x0
  802380:	50                   	push   %eax
  802381:	6a 1f                	push   $0x1f
  802383:	e8 71 fc ff ff       	call   801ff9 <syscall>
  802388:	83 c4 18             	add    $0x18,%esp
}
  80238b:	90                   	nop
  80238c:	c9                   	leave  
  80238d:	c3                   	ret    

0080238e <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  80238e:	55                   	push   %ebp
  80238f:	89 e5                	mov    %esp,%ebp
  802391:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802394:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802397:	8d 50 04             	lea    0x4(%eax),%edx
  80239a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	52                   	push   %edx
  8023a4:	50                   	push   %eax
  8023a5:	6a 20                	push   $0x20
  8023a7:	e8 4d fc ff ff       	call   801ff9 <syscall>
  8023ac:	83 c4 18             	add    $0x18,%esp
	return result;
  8023af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8023b8:	89 01                	mov    %eax,(%ecx)
  8023ba:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8023bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c0:	c9                   	leave  
  8023c1:	c2 04 00             	ret    $0x4

008023c4 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8023c4:	55                   	push   %ebp
  8023c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 00                	push   $0x0
  8023cb:	ff 75 10             	pushl  0x10(%ebp)
  8023ce:	ff 75 0c             	pushl  0xc(%ebp)
  8023d1:	ff 75 08             	pushl  0x8(%ebp)
  8023d4:	6a 0f                	push   $0xf
  8023d6:	e8 1e fc ff ff       	call   801ff9 <syscall>
  8023db:	83 c4 18             	add    $0x18,%esp
	return ;
  8023de:	90                   	nop
}
  8023df:	c9                   	leave  
  8023e0:	c3                   	ret    

008023e1 <sys_rcr2>:
uint32 sys_rcr2()
{
  8023e1:	55                   	push   %ebp
  8023e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 00                	push   $0x0
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 21                	push   $0x21
  8023f0:	e8 04 fc ff ff       	call   801ff9 <syscall>
  8023f5:	83 c4 18             	add    $0x18,%esp
}
  8023f8:	c9                   	leave  
  8023f9:	c3                   	ret    

008023fa <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8023fa:	55                   	push   %ebp
  8023fb:	89 e5                	mov    %esp,%ebp
  8023fd:	83 ec 04             	sub    $0x4,%esp
  802400:	8b 45 08             	mov    0x8(%ebp),%eax
  802403:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802406:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	6a 00                	push   $0x0
  802410:	6a 00                	push   $0x0
  802412:	50                   	push   %eax
  802413:	6a 22                	push   $0x22
  802415:	e8 df fb ff ff       	call   801ff9 <syscall>
  80241a:	83 c4 18             	add    $0x18,%esp
	return ;
  80241d:	90                   	nop
}
  80241e:	c9                   	leave  
  80241f:	c3                   	ret    

00802420 <rsttst>:
void rsttst()
{
  802420:	55                   	push   %ebp
  802421:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802423:	6a 00                	push   $0x0
  802425:	6a 00                	push   $0x0
  802427:	6a 00                	push   $0x0
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	6a 24                	push   $0x24
  80242f:	e8 c5 fb ff ff       	call   801ff9 <syscall>
  802434:	83 c4 18             	add    $0x18,%esp
	return ;
  802437:	90                   	nop
}
  802438:	c9                   	leave  
  802439:	c3                   	ret    

0080243a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80243a:	55                   	push   %ebp
  80243b:	89 e5                	mov    %esp,%ebp
  80243d:	83 ec 04             	sub    $0x4,%esp
  802440:	8b 45 14             	mov    0x14(%ebp),%eax
  802443:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802446:	8b 55 18             	mov    0x18(%ebp),%edx
  802449:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80244d:	52                   	push   %edx
  80244e:	50                   	push   %eax
  80244f:	ff 75 10             	pushl  0x10(%ebp)
  802452:	ff 75 0c             	pushl  0xc(%ebp)
  802455:	ff 75 08             	pushl  0x8(%ebp)
  802458:	6a 23                	push   $0x23
  80245a:	e8 9a fb ff ff       	call   801ff9 <syscall>
  80245f:	83 c4 18             	add    $0x18,%esp
	return ;
  802462:	90                   	nop
}
  802463:	c9                   	leave  
  802464:	c3                   	ret    

00802465 <chktst>:
void chktst(uint32 n)
{
  802465:	55                   	push   %ebp
  802466:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	6a 00                	push   $0x0
  80246e:	6a 00                	push   $0x0
  802470:	ff 75 08             	pushl  0x8(%ebp)
  802473:	6a 25                	push   $0x25
  802475:	e8 7f fb ff ff       	call   801ff9 <syscall>
  80247a:	83 c4 18             	add    $0x18,%esp
	return ;
  80247d:	90                   	nop
}
  80247e:	c9                   	leave  
  80247f:	c3                   	ret    

00802480 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802480:	55                   	push   %ebp
  802481:	89 e5                	mov    %esp,%ebp
  802483:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	6a 00                	push   $0x0
  80248c:	6a 00                	push   $0x0
  80248e:	6a 00                	push   $0x0
  802490:	6a 26                	push   $0x26
  802492:	e8 62 fb ff ff       	call   801ff9 <syscall>
  802497:	83 c4 18             	add    $0x18,%esp
  80249a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80249d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8024a1:	75 07                	jne    8024aa <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8024a3:	b8 01 00 00 00       	mov    $0x1,%eax
  8024a8:	eb 05                	jmp    8024af <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8024aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024af:	c9                   	leave  
  8024b0:	c3                   	ret    

008024b1 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8024b1:	55                   	push   %ebp
  8024b2:	89 e5                	mov    %esp,%ebp
  8024b4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 00                	push   $0x0
  8024c1:	6a 26                	push   $0x26
  8024c3:	e8 31 fb ff ff       	call   801ff9 <syscall>
  8024c8:	83 c4 18             	add    $0x18,%esp
  8024cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8024ce:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8024d2:	75 07                	jne    8024db <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8024d4:	b8 01 00 00 00       	mov    $0x1,%eax
  8024d9:	eb 05                	jmp    8024e0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8024db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024e0:	c9                   	leave  
  8024e1:	c3                   	ret    

008024e2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8024e2:	55                   	push   %ebp
  8024e3:	89 e5                	mov    %esp,%ebp
  8024e5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024e8:	6a 00                	push   $0x0
  8024ea:	6a 00                	push   $0x0
  8024ec:	6a 00                	push   $0x0
  8024ee:	6a 00                	push   $0x0
  8024f0:	6a 00                	push   $0x0
  8024f2:	6a 26                	push   $0x26
  8024f4:	e8 00 fb ff ff       	call   801ff9 <syscall>
  8024f9:	83 c4 18             	add    $0x18,%esp
  8024fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8024ff:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802503:	75 07                	jne    80250c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802505:	b8 01 00 00 00       	mov    $0x1,%eax
  80250a:	eb 05                	jmp    802511 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80250c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802511:	c9                   	leave  
  802512:	c3                   	ret    

00802513 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802513:	55                   	push   %ebp
  802514:	89 e5                	mov    %esp,%ebp
  802516:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802519:	6a 00                	push   $0x0
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	6a 00                	push   $0x0
  802521:	6a 00                	push   $0x0
  802523:	6a 26                	push   $0x26
  802525:	e8 cf fa ff ff       	call   801ff9 <syscall>
  80252a:	83 c4 18             	add    $0x18,%esp
  80252d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802530:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802534:	75 07                	jne    80253d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802536:	b8 01 00 00 00       	mov    $0x1,%eax
  80253b:	eb 05                	jmp    802542 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80253d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802542:	c9                   	leave  
  802543:	c3                   	ret    

00802544 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802544:	55                   	push   %ebp
  802545:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802547:	6a 00                	push   $0x0
  802549:	6a 00                	push   $0x0
  80254b:	6a 00                	push   $0x0
  80254d:	6a 00                	push   $0x0
  80254f:	ff 75 08             	pushl  0x8(%ebp)
  802552:	6a 27                	push   $0x27
  802554:	e8 a0 fa ff ff       	call   801ff9 <syscall>
  802559:	83 c4 18             	add    $0x18,%esp
	return ;
  80255c:	90                   	nop
}
  80255d:	c9                   	leave  
  80255e:	c3                   	ret    

0080255f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80255f:	55                   	push   %ebp
  802560:	89 e5                	mov    %esp,%ebp
  802562:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  802565:	8d 45 10             	lea    0x10(%ebp),%eax
  802568:	83 c0 04             	add    $0x4,%eax
  80256b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  80256e:	a1 50 30 98 00       	mov    0x983050,%eax
  802573:	85 c0                	test   %eax,%eax
  802575:	74 16                	je     80258d <_panic+0x2e>
		cprintf("%s: ", argv0);
  802577:	a1 50 30 98 00       	mov    0x983050,%eax
  80257c:	83 ec 08             	sub    $0x8,%esp
  80257f:	50                   	push   %eax
  802580:	68 62 2c 80 00       	push   $0x802c62
  802585:	e8 4a e2 ff ff       	call   8007d4 <cprintf>
  80258a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80258d:	a1 00 30 80 00       	mov    0x803000,%eax
  802592:	ff 75 0c             	pushl  0xc(%ebp)
  802595:	ff 75 08             	pushl  0x8(%ebp)
  802598:	50                   	push   %eax
  802599:	68 67 2c 80 00       	push   $0x802c67
  80259e:	e8 31 e2 ff ff       	call   8007d4 <cprintf>
  8025a3:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8025a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8025a9:	83 ec 08             	sub    $0x8,%esp
  8025ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8025af:	50                   	push   %eax
  8025b0:	e8 c4 e1 ff ff       	call   800779 <vcprintf>
  8025b5:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  8025b8:	83 ec 0c             	sub    $0xc,%esp
  8025bb:	68 83 2c 80 00       	push   $0x802c83
  8025c0:	e8 0f e2 ff ff       	call   8007d4 <cprintf>
  8025c5:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8025c8:	e8 3e e1 ff ff       	call   80070b <exit>

	// should not return here
	while (1) ;
  8025cd:	eb fe                	jmp    8025cd <_panic+0x6e>
  8025cf:	90                   	nop

008025d0 <__udivdi3>:
  8025d0:	55                   	push   %ebp
  8025d1:	57                   	push   %edi
  8025d2:	56                   	push   %esi
  8025d3:	53                   	push   %ebx
  8025d4:	83 ec 1c             	sub    $0x1c,%esp
  8025d7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8025db:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8025df:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8025e3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8025e7:	89 ca                	mov    %ecx,%edx
  8025e9:	89 f8                	mov    %edi,%eax
  8025eb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8025ef:	85 f6                	test   %esi,%esi
  8025f1:	75 2d                	jne    802620 <__udivdi3+0x50>
  8025f3:	39 cf                	cmp    %ecx,%edi
  8025f5:	77 65                	ja     80265c <__udivdi3+0x8c>
  8025f7:	89 fd                	mov    %edi,%ebp
  8025f9:	85 ff                	test   %edi,%edi
  8025fb:	75 0b                	jne    802608 <__udivdi3+0x38>
  8025fd:	b8 01 00 00 00       	mov    $0x1,%eax
  802602:	31 d2                	xor    %edx,%edx
  802604:	f7 f7                	div    %edi
  802606:	89 c5                	mov    %eax,%ebp
  802608:	31 d2                	xor    %edx,%edx
  80260a:	89 c8                	mov    %ecx,%eax
  80260c:	f7 f5                	div    %ebp
  80260e:	89 c1                	mov    %eax,%ecx
  802610:	89 d8                	mov    %ebx,%eax
  802612:	f7 f5                	div    %ebp
  802614:	89 cf                	mov    %ecx,%edi
  802616:	89 fa                	mov    %edi,%edx
  802618:	83 c4 1c             	add    $0x1c,%esp
  80261b:	5b                   	pop    %ebx
  80261c:	5e                   	pop    %esi
  80261d:	5f                   	pop    %edi
  80261e:	5d                   	pop    %ebp
  80261f:	c3                   	ret    
  802620:	39 ce                	cmp    %ecx,%esi
  802622:	77 28                	ja     80264c <__udivdi3+0x7c>
  802624:	0f bd fe             	bsr    %esi,%edi
  802627:	83 f7 1f             	xor    $0x1f,%edi
  80262a:	75 40                	jne    80266c <__udivdi3+0x9c>
  80262c:	39 ce                	cmp    %ecx,%esi
  80262e:	72 0a                	jb     80263a <__udivdi3+0x6a>
  802630:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802634:	0f 87 9e 00 00 00    	ja     8026d8 <__udivdi3+0x108>
  80263a:	b8 01 00 00 00       	mov    $0x1,%eax
  80263f:	89 fa                	mov    %edi,%edx
  802641:	83 c4 1c             	add    $0x1c,%esp
  802644:	5b                   	pop    %ebx
  802645:	5e                   	pop    %esi
  802646:	5f                   	pop    %edi
  802647:	5d                   	pop    %ebp
  802648:	c3                   	ret    
  802649:	8d 76 00             	lea    0x0(%esi),%esi
  80264c:	31 ff                	xor    %edi,%edi
  80264e:	31 c0                	xor    %eax,%eax
  802650:	89 fa                	mov    %edi,%edx
  802652:	83 c4 1c             	add    $0x1c,%esp
  802655:	5b                   	pop    %ebx
  802656:	5e                   	pop    %esi
  802657:	5f                   	pop    %edi
  802658:	5d                   	pop    %ebp
  802659:	c3                   	ret    
  80265a:	66 90                	xchg   %ax,%ax
  80265c:	89 d8                	mov    %ebx,%eax
  80265e:	f7 f7                	div    %edi
  802660:	31 ff                	xor    %edi,%edi
  802662:	89 fa                	mov    %edi,%edx
  802664:	83 c4 1c             	add    $0x1c,%esp
  802667:	5b                   	pop    %ebx
  802668:	5e                   	pop    %esi
  802669:	5f                   	pop    %edi
  80266a:	5d                   	pop    %ebp
  80266b:	c3                   	ret    
  80266c:	bd 20 00 00 00       	mov    $0x20,%ebp
  802671:	89 eb                	mov    %ebp,%ebx
  802673:	29 fb                	sub    %edi,%ebx
  802675:	89 f9                	mov    %edi,%ecx
  802677:	d3 e6                	shl    %cl,%esi
  802679:	89 c5                	mov    %eax,%ebp
  80267b:	88 d9                	mov    %bl,%cl
  80267d:	d3 ed                	shr    %cl,%ebp
  80267f:	89 e9                	mov    %ebp,%ecx
  802681:	09 f1                	or     %esi,%ecx
  802683:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802687:	89 f9                	mov    %edi,%ecx
  802689:	d3 e0                	shl    %cl,%eax
  80268b:	89 c5                	mov    %eax,%ebp
  80268d:	89 d6                	mov    %edx,%esi
  80268f:	88 d9                	mov    %bl,%cl
  802691:	d3 ee                	shr    %cl,%esi
  802693:	89 f9                	mov    %edi,%ecx
  802695:	d3 e2                	shl    %cl,%edx
  802697:	8b 44 24 08          	mov    0x8(%esp),%eax
  80269b:	88 d9                	mov    %bl,%cl
  80269d:	d3 e8                	shr    %cl,%eax
  80269f:	09 c2                	or     %eax,%edx
  8026a1:	89 d0                	mov    %edx,%eax
  8026a3:	89 f2                	mov    %esi,%edx
  8026a5:	f7 74 24 0c          	divl   0xc(%esp)
  8026a9:	89 d6                	mov    %edx,%esi
  8026ab:	89 c3                	mov    %eax,%ebx
  8026ad:	f7 e5                	mul    %ebp
  8026af:	39 d6                	cmp    %edx,%esi
  8026b1:	72 19                	jb     8026cc <__udivdi3+0xfc>
  8026b3:	74 0b                	je     8026c0 <__udivdi3+0xf0>
  8026b5:	89 d8                	mov    %ebx,%eax
  8026b7:	31 ff                	xor    %edi,%edi
  8026b9:	e9 58 ff ff ff       	jmp    802616 <__udivdi3+0x46>
  8026be:	66 90                	xchg   %ax,%ax
  8026c0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8026c4:	89 f9                	mov    %edi,%ecx
  8026c6:	d3 e2                	shl    %cl,%edx
  8026c8:	39 c2                	cmp    %eax,%edx
  8026ca:	73 e9                	jae    8026b5 <__udivdi3+0xe5>
  8026cc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8026cf:	31 ff                	xor    %edi,%edi
  8026d1:	e9 40 ff ff ff       	jmp    802616 <__udivdi3+0x46>
  8026d6:	66 90                	xchg   %ax,%ax
  8026d8:	31 c0                	xor    %eax,%eax
  8026da:	e9 37 ff ff ff       	jmp    802616 <__udivdi3+0x46>
  8026df:	90                   	nop

008026e0 <__umoddi3>:
  8026e0:	55                   	push   %ebp
  8026e1:	57                   	push   %edi
  8026e2:	56                   	push   %esi
  8026e3:	53                   	push   %ebx
  8026e4:	83 ec 1c             	sub    $0x1c,%esp
  8026e7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8026eb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8026ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8026f3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8026f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8026fb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026ff:	89 f3                	mov    %esi,%ebx
  802701:	89 fa                	mov    %edi,%edx
  802703:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802707:	89 34 24             	mov    %esi,(%esp)
  80270a:	85 c0                	test   %eax,%eax
  80270c:	75 1a                	jne    802728 <__umoddi3+0x48>
  80270e:	39 f7                	cmp    %esi,%edi
  802710:	0f 86 a2 00 00 00    	jbe    8027b8 <__umoddi3+0xd8>
  802716:	89 c8                	mov    %ecx,%eax
  802718:	89 f2                	mov    %esi,%edx
  80271a:	f7 f7                	div    %edi
  80271c:	89 d0                	mov    %edx,%eax
  80271e:	31 d2                	xor    %edx,%edx
  802720:	83 c4 1c             	add    $0x1c,%esp
  802723:	5b                   	pop    %ebx
  802724:	5e                   	pop    %esi
  802725:	5f                   	pop    %edi
  802726:	5d                   	pop    %ebp
  802727:	c3                   	ret    
  802728:	39 f0                	cmp    %esi,%eax
  80272a:	0f 87 ac 00 00 00    	ja     8027dc <__umoddi3+0xfc>
  802730:	0f bd e8             	bsr    %eax,%ebp
  802733:	83 f5 1f             	xor    $0x1f,%ebp
  802736:	0f 84 ac 00 00 00    	je     8027e8 <__umoddi3+0x108>
  80273c:	bf 20 00 00 00       	mov    $0x20,%edi
  802741:	29 ef                	sub    %ebp,%edi
  802743:	89 fe                	mov    %edi,%esi
  802745:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802749:	89 e9                	mov    %ebp,%ecx
  80274b:	d3 e0                	shl    %cl,%eax
  80274d:	89 d7                	mov    %edx,%edi
  80274f:	89 f1                	mov    %esi,%ecx
  802751:	d3 ef                	shr    %cl,%edi
  802753:	09 c7                	or     %eax,%edi
  802755:	89 e9                	mov    %ebp,%ecx
  802757:	d3 e2                	shl    %cl,%edx
  802759:	89 14 24             	mov    %edx,(%esp)
  80275c:	89 d8                	mov    %ebx,%eax
  80275e:	d3 e0                	shl    %cl,%eax
  802760:	89 c2                	mov    %eax,%edx
  802762:	8b 44 24 08          	mov    0x8(%esp),%eax
  802766:	d3 e0                	shl    %cl,%eax
  802768:	89 44 24 04          	mov    %eax,0x4(%esp)
  80276c:	8b 44 24 08          	mov    0x8(%esp),%eax
  802770:	89 f1                	mov    %esi,%ecx
  802772:	d3 e8                	shr    %cl,%eax
  802774:	09 d0                	or     %edx,%eax
  802776:	d3 eb                	shr    %cl,%ebx
  802778:	89 da                	mov    %ebx,%edx
  80277a:	f7 f7                	div    %edi
  80277c:	89 d3                	mov    %edx,%ebx
  80277e:	f7 24 24             	mull   (%esp)
  802781:	89 c6                	mov    %eax,%esi
  802783:	89 d1                	mov    %edx,%ecx
  802785:	39 d3                	cmp    %edx,%ebx
  802787:	0f 82 87 00 00 00    	jb     802814 <__umoddi3+0x134>
  80278d:	0f 84 91 00 00 00    	je     802824 <__umoddi3+0x144>
  802793:	8b 54 24 04          	mov    0x4(%esp),%edx
  802797:	29 f2                	sub    %esi,%edx
  802799:	19 cb                	sbb    %ecx,%ebx
  80279b:	89 d8                	mov    %ebx,%eax
  80279d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8027a1:	d3 e0                	shl    %cl,%eax
  8027a3:	89 e9                	mov    %ebp,%ecx
  8027a5:	d3 ea                	shr    %cl,%edx
  8027a7:	09 d0                	or     %edx,%eax
  8027a9:	89 e9                	mov    %ebp,%ecx
  8027ab:	d3 eb                	shr    %cl,%ebx
  8027ad:	89 da                	mov    %ebx,%edx
  8027af:	83 c4 1c             	add    $0x1c,%esp
  8027b2:	5b                   	pop    %ebx
  8027b3:	5e                   	pop    %esi
  8027b4:	5f                   	pop    %edi
  8027b5:	5d                   	pop    %ebp
  8027b6:	c3                   	ret    
  8027b7:	90                   	nop
  8027b8:	89 fd                	mov    %edi,%ebp
  8027ba:	85 ff                	test   %edi,%edi
  8027bc:	75 0b                	jne    8027c9 <__umoddi3+0xe9>
  8027be:	b8 01 00 00 00       	mov    $0x1,%eax
  8027c3:	31 d2                	xor    %edx,%edx
  8027c5:	f7 f7                	div    %edi
  8027c7:	89 c5                	mov    %eax,%ebp
  8027c9:	89 f0                	mov    %esi,%eax
  8027cb:	31 d2                	xor    %edx,%edx
  8027cd:	f7 f5                	div    %ebp
  8027cf:	89 c8                	mov    %ecx,%eax
  8027d1:	f7 f5                	div    %ebp
  8027d3:	89 d0                	mov    %edx,%eax
  8027d5:	e9 44 ff ff ff       	jmp    80271e <__umoddi3+0x3e>
  8027da:	66 90                	xchg   %ax,%ax
  8027dc:	89 c8                	mov    %ecx,%eax
  8027de:	89 f2                	mov    %esi,%edx
  8027e0:	83 c4 1c             	add    $0x1c,%esp
  8027e3:	5b                   	pop    %ebx
  8027e4:	5e                   	pop    %esi
  8027e5:	5f                   	pop    %edi
  8027e6:	5d                   	pop    %ebp
  8027e7:	c3                   	ret    
  8027e8:	3b 04 24             	cmp    (%esp),%eax
  8027eb:	72 06                	jb     8027f3 <__umoddi3+0x113>
  8027ed:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8027f1:	77 0f                	ja     802802 <__umoddi3+0x122>
  8027f3:	89 f2                	mov    %esi,%edx
  8027f5:	29 f9                	sub    %edi,%ecx
  8027f7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8027fb:	89 14 24             	mov    %edx,(%esp)
  8027fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802802:	8b 44 24 04          	mov    0x4(%esp),%eax
  802806:	8b 14 24             	mov    (%esp),%edx
  802809:	83 c4 1c             	add    $0x1c,%esp
  80280c:	5b                   	pop    %ebx
  80280d:	5e                   	pop    %esi
  80280e:	5f                   	pop    %edi
  80280f:	5d                   	pop    %ebp
  802810:	c3                   	ret    
  802811:	8d 76 00             	lea    0x0(%esi),%esi
  802814:	2b 04 24             	sub    (%esp),%eax
  802817:	19 fa                	sbb    %edi,%edx
  802819:	89 d1                	mov    %edx,%ecx
  80281b:	89 c6                	mov    %eax,%esi
  80281d:	e9 71 ff ff ff       	jmp    802793 <__umoddi3+0xb3>
  802822:	66 90                	xchg   %ax,%ax
  802824:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802828:	72 ea                	jb     802814 <__umoddi3+0x134>
  80282a:	89 d9                	mov    %ebx,%ecx
  80282c:	e9 62 ff ff ff       	jmp    802793 <__umoddi3+0xb3>
