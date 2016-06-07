
obj/user/tst_freeRAM_2:     file format elf32-i386


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
  800031:	e8 8b 05 00 00       	call   8005c1 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	char a;
	short b;
	int c;
};
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec c0 00 00 00    	sub    $0xc0,%esp
	int envID = sys_getenvid();
  800043:	e8 06 20 00 00       	call   80204e <sys_getenvid>
  800048:	89 45 f4             	mov    %eax,-0xc(%ebp)

	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  80004b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80004e:	89 d0                	mov    %edx,%eax
  800050:	c1 e0 03             	shl    $0x3,%eax
  800053:	01 d0                	add    %edx,%eax
  800055:	01 c0                	add    %eax,%eax
  800057:	01 d0                	add    %edx,%eax
  800059:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800060:	01 d0                	add    %edx,%eax
  800062:	c1 e0 03             	shl    $0x3,%eax
  800065:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int Mega = 1024*1024;
  80006d:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  800074:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	char minByte = 1<<7;
  80007b:	c6 45 e7 80          	movb   $0x80,-0x19(%ebp)
	char maxByte = 0x7F;
  80007f:	c6 45 e6 7f          	movb   $0x7f,-0x1a(%ebp)
	short minShort = 1<<15 ;
  800083:	66 c7 45 e4 00 80    	movw   $0x8000,-0x1c(%ebp)
	short maxShort = 0x7FFF;
  800089:	66 c7 45 e2 ff 7f    	movw   $0x7fff,-0x1e(%ebp)
	int minInt = 1<<31 ;
  80008f:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
	int maxInt = 0x7FFFFFFF;
  800096:	c7 45 d8 ff ff ff 7f 	movl   $0x7fffffff,-0x28(%ebp)

	void* ptr_allocations[20] = {0};
  80009d:	8d 95 44 ff ff ff    	lea    -0xbc(%ebp),%edx
  8000a3:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ad:	89 d7                	mov    %edx,%edi
  8000af:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//Load "fib" & "fos_helloWorld" programs into RAM
		cprintf("Loading Fib & fos_helloWorld programs into RAM...");
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	68 40 28 80 00       	push   $0x802840
  8000b9:	e8 ef 06 00 00       	call   8007ad <cprintf>
  8000be:	83 c4 10             	add    $0x10,%esp
		int32 envIdFib = sys_create_env("fib", (myEnv->page_WS_max_size));
  8000c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c4:	8b 40 74             	mov    0x74(%eax),%eax
  8000c7:	83 ec 08             	sub    $0x8,%esp
  8000ca:	50                   	push   %eax
  8000cb:	68 72 28 80 00       	push   $0x802872
  8000d0:	e8 3e 22 00 00       	call   802313 <sys_create_env>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  8000db:	e8 20 20 00 00       	call   802100 <sys_calculate_free_frames>
  8000e0:	89 45 d0             	mov    %eax,-0x30(%ebp)
		int32 envIdHelloWorld = sys_create_env("fos_helloWorld", (myEnv->page_WS_max_size));
  8000e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000e6:	8b 40 74             	mov    0x74(%eax),%eax
  8000e9:	83 ec 08             	sub    $0x8,%esp
  8000ec:	50                   	push   %eax
  8000ed:	68 76 28 80 00       	push   $0x802876
  8000f2:	e8 1c 22 00 00       	call   802313 <sys_create_env>
  8000f7:	83 c4 10             	add    $0x10,%esp
  8000fa:	89 45 cc             	mov    %eax,-0x34(%ebp)
		int helloWorldFrames = freeFrames - sys_calculate_free_frames() ;
  8000fd:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800100:	e8 fb 1f 00 00       	call   802100 <sys_calculate_free_frames>
  800105:	29 c3                	sub    %eax,%ebx
  800107:	89 d8                	mov    %ebx,%eax
  800109:	89 45 c8             	mov    %eax,-0x38(%ebp)
		env_sleep(2000);
  80010c:	83 ec 0c             	sub    $0xc,%esp
  80010f:	68 d0 07 00 00       	push   $0x7d0
  800114:	e8 1f 24 00 00       	call   802538 <env_sleep>
  800119:	83 c4 10             	add    $0x10,%esp
		cprintf("[DONE]\n\n");
  80011c:	83 ec 0c             	sub    $0xc,%esp
  80011f:	68 85 28 80 00       	push   $0x802885
  800124:	e8 84 06 00 00       	call   8007ad <cprintf>
  800129:	83 c4 10             	add    $0x10,%esp

		//Load and run "fos_add"
		cprintf("Loading fos_add program into RAM...");
  80012c:	83 ec 0c             	sub    $0xc,%esp
  80012f:	68 90 28 80 00       	push   $0x802890
  800134:	e8 74 06 00 00       	call   8007ad <cprintf>
  800139:	83 c4 10             	add    $0x10,%esp
		int32 envIdFOSAdd= sys_create_env("fos_add", (myEnv->page_WS_max_size));
  80013c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80013f:	8b 40 74             	mov    0x74(%eax),%eax
  800142:	83 ec 08             	sub    $0x8,%esp
  800145:	50                   	push   %eax
  800146:	68 b4 28 80 00       	push   $0x8028b4
  80014b:	e8 c3 21 00 00       	call   802313 <sys_create_env>
  800150:	83 c4 10             	add    $0x10,%esp
  800153:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		env_sleep(2000);
  800156:	83 ec 0c             	sub    $0xc,%esp
  800159:	68 d0 07 00 00       	push   $0x7d0
  80015e:	e8 d5 23 00 00       	call   802538 <env_sleep>
  800163:	83 c4 10             	add    $0x10,%esp
		cprintf("[DONE]\n\n");
  800166:	83 ec 0c             	sub    $0xc,%esp
  800169:	68 85 28 80 00       	push   $0x802885
  80016e:	e8 3a 06 00 00       	call   8007ad <cprintf>
  800173:	83 c4 10             	add    $0x10,%esp
		cprintf("running fos_add program...\n\n");
  800176:	83 ec 0c             	sub    $0xc,%esp
  800179:	68 bc 28 80 00       	push   $0x8028bc
  80017e:	e8 2a 06 00 00       	call   8007ad <cprintf>
  800183:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdFOSAdd);
  800186:	83 ec 0c             	sub    $0xc,%esp
  800189:	ff 75 c4             	pushl  -0x3c(%ebp)
  80018c:	e8 9e 21 00 00       	call   80232f <sys_run_env>
  800191:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  800194:	83 ec 0c             	sub    $0xc,%esp
  800197:	68 d9 28 80 00       	push   $0x8028d9
  80019c:	e8 0c 06 00 00       	call   8007ad <cprintf>
  8001a1:	83 c4 10             	add    $0x10,%esp
		env_sleep(5000);
  8001a4:	83 ec 0c             	sub    $0xc,%esp
  8001a7:	68 88 13 00 00       	push   $0x1388
  8001ac:	e8 87 23 00 00       	call   802538 <env_sleep>
  8001b1:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8001b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001b7:	01 c0                	add    %eax,%eax
  8001b9:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8001bc:	83 ec 0c             	sub    $0xc,%esp
  8001bf:	50                   	push   %eax
  8001c0:	e8 6b 13 00 00       	call   801530 <malloc>
  8001c5:	83 c4 10             	add    $0x10,%esp
  8001c8:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
		char *byteArr = (char *) ptr_allocations[0];
  8001ce:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  8001d4:	89 45 c0             	mov    %eax,-0x40(%ebp)
		int lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  8001d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001da:	01 c0                	add    %eax,%eax
  8001dc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8001df:	48                   	dec    %eax
  8001e0:	89 45 bc             	mov    %eax,-0x44(%ebp)
		byteArr[0] = minByte ;
  8001e3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8001e6:	8a 55 e7             	mov    -0x19(%ebp),%dl
  8001e9:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  8001eb:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8001ee:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8001f1:	01 c2                	add    %eax,%edx
  8001f3:	8a 45 e6             	mov    -0x1a(%ebp),%al
  8001f6:	88 02                	mov    %al,(%edx)

		//Allocate another 2 MB
		ptr_allocations[1] = malloc(2*Mega-kilo);
  8001f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001fb:	01 c0                	add    %eax,%eax
  8001fd:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800200:	83 ec 0c             	sub    $0xc,%esp
  800203:	50                   	push   %eax
  800204:	e8 27 13 00 00       	call   801530 <malloc>
  800209:	83 c4 10             	add    $0x10,%esp
  80020c:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
		short *shortArr = (short *) ptr_allocations[1];
  800212:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800218:	89 45 b8             	mov    %eax,-0x48(%ebp)
		int lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  80021b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80021e:	01 c0                	add    %eax,%eax
  800220:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800223:	d1 e8                	shr    %eax
  800225:	48                   	dec    %eax
  800226:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		shortArr[0] = minShort;
  800229:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80022c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80022f:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800232:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800235:	01 c0                	add    %eax,%eax
  800237:	89 c2                	mov    %eax,%edx
  800239:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80023c:	01 c2                	add    %eax,%edx
  80023e:	66 8b 45 e2          	mov    -0x1e(%ebp),%ax
  800242:	66 89 02             	mov    %ax,(%edx)

		//Allocate all remaining RAM (Here: it requires to free some RAM by removing exited program (fos_add))
		freeFrames = sys_calculate_free_frames() ;
  800245:	e8 b6 1e 00 00       	call   802100 <sys_calculate_free_frames>
  80024a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		ptr_allocations[2] = malloc(freeFrames*PAGE_SIZE);
  80024d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800250:	c1 e0 0c             	shl    $0xc,%eax
  800253:	83 ec 0c             	sub    $0xc,%esp
  800256:	50                   	push   %eax
  800257:	e8 d4 12 00 00       	call   801530 <malloc>
  80025c:	83 c4 10             	add    $0x10,%esp
  80025f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
		int *intArr = (int *) ptr_allocations[2];
  800265:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  80026b:	89 45 b0             	mov    %eax,-0x50(%ebp)
		int lastIndexOfInt = (freeFrames*PAGE_SIZE)/sizeof(int) - 1;
  80026e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800271:	c1 e0 0c             	shl    $0xc,%eax
  800274:	c1 e8 02             	shr    $0x2,%eax
  800277:	48                   	dec    %eax
  800278:	89 45 ac             	mov    %eax,-0x54(%ebp)
		intArr[0] = minInt;
  80027b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80027e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800281:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  800283:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800286:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80028d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800290:	01 c2                	add    %eax,%edx
  800292:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800295:	89 02                	mov    %eax,(%edx)

		//Allocate 7 KB after freeing some RAM
		ptr_allocations[3] = malloc(7*kilo);
  800297:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80029a:	89 d0                	mov    %edx,%eax
  80029c:	01 c0                	add    %eax,%eax
  80029e:	01 d0                	add    %edx,%eax
  8002a0:	01 c0                	add    %eax,%eax
  8002a2:	01 d0                	add    %edx,%eax
  8002a4:	83 ec 0c             	sub    $0xc,%esp
  8002a7:	50                   	push   %eax
  8002a8:	e8 83 12 00 00       	call   801530 <malloc>
  8002ad:	83 c4 10             	add    $0x10,%esp
  8002b0:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
		struct MyStruct *structArr = (struct MyStruct *) ptr_allocations[3];
  8002b6:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  8002bc:	89 45 a8             	mov    %eax,-0x58(%ebp)
		int lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  8002bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002c2:	89 d0                	mov    %edx,%eax
  8002c4:	01 c0                	add    %eax,%eax
  8002c6:	01 d0                	add    %edx,%eax
  8002c8:	01 c0                	add    %eax,%eax
  8002ca:	01 d0                	add    %edx,%eax
  8002cc:	c1 e8 03             	shr    $0x3,%eax
  8002cf:	48                   	dec    %eax
  8002d0:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  8002d3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8002d6:	8a 55 e7             	mov    -0x19(%ebp),%dl
  8002d9:	88 10                	mov    %dl,(%eax)
  8002db:	8b 55 a8             	mov    -0x58(%ebp),%edx
  8002de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002e1:	66 89 42 02          	mov    %ax,0x2(%edx)
  8002e5:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8002e8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8002eb:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  8002ee:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8002f1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002f8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8002fb:	01 c2                	add    %eax,%edx
  8002fd:	8a 45 e6             	mov    -0x1a(%ebp),%al
  800300:	88 02                	mov    %al,(%edx)
  800302:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800305:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80030c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80030f:	01 c2                	add    %eax,%edx
  800311:	66 8b 45 e2          	mov    -0x1e(%ebp),%ax
  800315:	66 89 42 02          	mov    %ax,0x2(%edx)
  800319:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80031c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800323:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800326:	01 c2                	add    %eax,%edx
  800328:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80032b:	89 42 04             	mov    %eax,0x4(%edx)

		cprintf("running fos_helloWorld program...\n\n");
  80032e:	83 ec 0c             	sub    $0xc,%esp
  800331:	68 f0 28 80 00       	push   $0x8028f0
  800336:	e8 72 04 00 00       	call   8007ad <cprintf>
  80033b:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdHelloWorld);
  80033e:	83 ec 0c             	sub    $0xc,%esp
  800341:	ff 75 cc             	pushl  -0x34(%ebp)
  800344:	e8 e6 1f 00 00       	call   80232f <sys_run_env>
  800349:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  80034c:	83 ec 0c             	sub    $0xc,%esp
  80034f:	68 d9 28 80 00       	push   $0x8028d9
  800354:	e8 54 04 00 00       	call   8007ad <cprintf>
  800359:	83 c4 10             	add    $0x10,%esp
		env_sleep(5000);
  80035c:	83 ec 0c             	sub    $0xc,%esp
  80035f:	68 88 13 00 00       	push   $0x1388
  800364:	e8 cf 21 00 00       	call   802538 <env_sleep>
  800369:	83 c4 10             	add    $0x10,%esp

		//Allocate the remaining RAM + extra RAM by the size of helloWorld program (Here: it requires to free some RAM by removing exited & loaded program(s) (fos_helloWorld & fib))
		freeFrames = sys_calculate_free_frames() ;
  80036c:	e8 8f 1d 00 00       	call   802100 <sys_calculate_free_frames>
  800371:	89 45 d0             	mov    %eax,-0x30(%ebp)
		ptr_allocations[4] = malloc((freeFrames + helloWorldFrames)*PAGE_SIZE);
  800374:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800377:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80037a:	01 d0                	add    %edx,%eax
  80037c:	c1 e0 0c             	shl    $0xc,%eax
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	50                   	push   %eax
  800383:	e8 a8 11 00 00       	call   801530 <malloc>
  800388:	83 c4 10             	add    $0x10,%esp
  80038b:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
		int *intArr2 = (int *) ptr_allocations[4];
  800391:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800397:	89 45 a0             	mov    %eax,-0x60(%ebp)
		int lastIndexOfInt2 = ((freeFrames + helloWorldFrames)*PAGE_SIZE)/sizeof(int) - 1;
  80039a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80039d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8003a0:	01 d0                	add    %edx,%eax
  8003a2:	c1 e0 0c             	shl    $0xc,%eax
  8003a5:	c1 e8 02             	shr    $0x2,%eax
  8003a8:	48                   	dec    %eax
  8003a9:	89 45 9c             	mov    %eax,-0x64(%ebp)
		intArr2[0] = minInt;
  8003ac:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8003af:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8003b2:	89 10                	mov    %edx,(%eax)
		intArr2[lastIndexOfInt2] = maxInt;
  8003b4:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8003b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003be:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8003c1:	01 c2                	add    %eax,%edx
  8003c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003c6:	89 02                	mov    %eax,(%edx)

		//Allocate 8 B after freeing the RAM
		ptr_allocations[5] = malloc(8);
  8003c8:	83 ec 0c             	sub    $0xc,%esp
  8003cb:	6a 08                	push   $0x8
  8003cd:	e8 5e 11 00 00       	call   801530 <malloc>
  8003d2:	83 c4 10             	add    $0x10,%esp
  8003d5:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
		int *intArr3 = (int *) ptr_allocations[5];
  8003db:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8003e1:	89 45 98             	mov    %eax,-0x68(%ebp)
		int lastIndexOfInt3 = 8/sizeof(int) - 1;
  8003e4:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
		intArr3[0] = minInt;
  8003eb:	8b 45 98             	mov    -0x68(%ebp),%eax
  8003ee:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8003f1:	89 10                	mov    %edx,(%eax)
		intArr3[lastIndexOfInt3] = maxInt;
  8003f3:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8003f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003fd:	8b 45 98             	mov    -0x68(%ebp),%eax
  800400:	01 c2                	add    %eax,%edx
  800402:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800405:	89 02                	mov    %eax,(%edx)

		//Check that the values are successfully stored
		if (byteArr[0] 	!= minByte 	|| byteArr[lastIndexOfByte] 	!= maxByte) panic("Wrong allocation: stored values are wrongly changed!");
  800407:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80040a:	8a 00                	mov    (%eax),%al
  80040c:	3a 45 e7             	cmp    -0x19(%ebp),%al
  80040f:	75 0f                	jne    800420 <_main+0x3e8>
  800411:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800414:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800417:	01 d0                	add    %edx,%eax
  800419:	8a 00                	mov    (%eax),%al
  80041b:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  80041e:	74 14                	je     800434 <_main+0x3fc>
  800420:	83 ec 04             	sub    $0x4,%esp
  800423:	68 14 29 80 00       	push   $0x802914
  800428:	6a 62                	push   $0x62
  80042a:	68 49 29 80 00       	push   $0x802949
  80042f:	e8 4e 02 00 00       	call   800682 <_panic>
		if (shortArr[0] != minShort || shortArr[lastIndexOfShort] 	!= maxShort) panic("Wrong allocation: stored values are wrongly changed!");
  800434:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800437:	66 8b 00             	mov    (%eax),%ax
  80043a:	66 3b 45 e4          	cmp    -0x1c(%ebp),%ax
  80043e:	75 15                	jne    800455 <_main+0x41d>
  800440:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800443:	01 c0                	add    %eax,%eax
  800445:	89 c2                	mov    %eax,%edx
  800447:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80044a:	01 d0                	add    %edx,%eax
  80044c:	66 8b 00             	mov    (%eax),%ax
  80044f:	66 3b 45 e2          	cmp    -0x1e(%ebp),%ax
  800453:	74 14                	je     800469 <_main+0x431>
  800455:	83 ec 04             	sub    $0x4,%esp
  800458:	68 14 29 80 00       	push   $0x802914
  80045d:	6a 63                	push   $0x63
  80045f:	68 49 29 80 00       	push   $0x802949
  800464:	e8 19 02 00 00       	call   800682 <_panic>
		if (intArr[0] 	!= minInt 	|| intArr[lastIndexOfInt] 		!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  800469:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80046c:	8b 00                	mov    (%eax),%eax
  80046e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800471:	75 16                	jne    800489 <_main+0x451>
  800473:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800476:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80047d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800480:	01 d0                	add    %edx,%eax
  800482:	8b 00                	mov    (%eax),%eax
  800484:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800487:	74 14                	je     80049d <_main+0x465>
  800489:	83 ec 04             	sub    $0x4,%esp
  80048c:	68 14 29 80 00       	push   $0x802914
  800491:	6a 64                	push   $0x64
  800493:	68 49 29 80 00       	push   $0x802949
  800498:	e8 e5 01 00 00       	call   800682 <_panic>
		if (intArr2[0] 	!= minInt 	|| intArr2[lastIndexOfInt2] 	!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  80049d:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8004a0:	8b 00                	mov    (%eax),%eax
  8004a2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8004a5:	75 16                	jne    8004bd <_main+0x485>
  8004a7:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8004aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b1:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8004b4:	01 d0                	add    %edx,%eax
  8004b6:	8b 00                	mov    (%eax),%eax
  8004b8:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8004bb:	74 14                	je     8004d1 <_main+0x499>
  8004bd:	83 ec 04             	sub    $0x4,%esp
  8004c0:	68 14 29 80 00       	push   $0x802914
  8004c5:	6a 65                	push   $0x65
  8004c7:	68 49 29 80 00       	push   $0x802949
  8004cc:	e8 b1 01 00 00       	call   800682 <_panic>
		if (intArr3[0] 	!= minInt 	|| intArr3[lastIndexOfInt3] 	!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  8004d1:	8b 45 98             	mov    -0x68(%ebp),%eax
  8004d4:	8b 00                	mov    (%eax),%eax
  8004d6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8004d9:	75 16                	jne    8004f1 <_main+0x4b9>
  8004db:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8004de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004e5:	8b 45 98             	mov    -0x68(%ebp),%eax
  8004e8:	01 d0                	add    %edx,%eax
  8004ea:	8b 00                	mov    (%eax),%eax
  8004ec:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8004ef:	74 14                	je     800505 <_main+0x4cd>
  8004f1:	83 ec 04             	sub    $0x4,%esp
  8004f4:	68 14 29 80 00       	push   $0x802914
  8004f9:	6a 66                	push   $0x66
  8004fb:	68 49 29 80 00       	push   $0x802949
  800500:	e8 7d 01 00 00       	call   800682 <_panic>

		if (structArr[0].a != minByte 	|| structArr[lastIndexOfStruct].a != maxByte) 	panic("Wrong allocation: stored values are wrongly changed!");
  800505:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800508:	8a 00                	mov    (%eax),%al
  80050a:	3a 45 e7             	cmp    -0x19(%ebp),%al
  80050d:	75 16                	jne    800525 <_main+0x4ed>
  80050f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800512:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800519:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80051c:	01 d0                	add    %edx,%eax
  80051e:	8a 00                	mov    (%eax),%al
  800520:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  800523:	74 14                	je     800539 <_main+0x501>
  800525:	83 ec 04             	sub    $0x4,%esp
  800528:	68 14 29 80 00       	push   $0x802914
  80052d:	6a 68                	push   $0x68
  80052f:	68 49 29 80 00       	push   $0x802949
  800534:	e8 49 01 00 00       	call   800682 <_panic>
		if (structArr[0].b != minShort 	|| structArr[lastIndexOfStruct].b != maxShort) 	panic("Wrong allocation: stored values are wrongly changed!");
  800539:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80053c:	66 8b 40 02          	mov    0x2(%eax),%ax
  800540:	66 3b 45 e4          	cmp    -0x1c(%ebp),%ax
  800544:	75 19                	jne    80055f <_main+0x527>
  800546:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800549:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800550:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800553:	01 d0                	add    %edx,%eax
  800555:	66 8b 40 02          	mov    0x2(%eax),%ax
  800559:	66 3b 45 e2          	cmp    -0x1e(%ebp),%ax
  80055d:	74 14                	je     800573 <_main+0x53b>
  80055f:	83 ec 04             	sub    $0x4,%esp
  800562:	68 14 29 80 00       	push   $0x802914
  800567:	6a 69                	push   $0x69
  800569:	68 49 29 80 00       	push   $0x802949
  80056e:	e8 0f 01 00 00       	call   800682 <_panic>
		if (structArr[0].c != minInt 	|| structArr[lastIndexOfStruct].c != maxInt) 	panic("Wrong allocation: stored values are wrongly changed!");
  800573:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800576:	8b 40 04             	mov    0x4(%eax),%eax
  800579:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80057c:	75 17                	jne    800595 <_main+0x55d>
  80057e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800581:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800588:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80058b:	01 d0                	add    %edx,%eax
  80058d:	8b 40 04             	mov    0x4(%eax),%eax
  800590:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800593:	74 14                	je     8005a9 <_main+0x571>
  800595:	83 ec 04             	sub    $0x4,%esp
  800598:	68 14 29 80 00       	push   $0x802914
  80059d:	6a 6a                	push   $0x6a
  80059f:	68 49 29 80 00       	push   $0x802949
  8005a4:	e8 d9 00 00 00       	call   800682 <_panic>


	}

	cprintf("Congratulations!! test freeRAM (1) completed successfully.\n");
  8005a9:	83 ec 0c             	sub    $0xc,%esp
  8005ac:	68 60 29 80 00       	push   $0x802960
  8005b1:	e8 f7 01 00 00       	call   8007ad <cprintf>
  8005b6:	83 c4 10             	add    $0x10,%esp

	return;
  8005b9:	90                   	nop
}
  8005ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8005bd:	5b                   	pop    %ebx
  8005be:	5f                   	pop    %edi
  8005bf:	5d                   	pop    %ebp
  8005c0:	c3                   	ret    

008005c1 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005c1:	55                   	push   %ebp
  8005c2:	89 e5                	mov    %esp,%ebp
  8005c4:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005cb:	7e 0a                	jle    8005d7 <libmain+0x16>
		binaryname = argv[0];
  8005cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8005d7:	83 ec 08             	sub    $0x8,%esp
  8005da:	ff 75 0c             	pushl  0xc(%ebp)
  8005dd:	ff 75 08             	pushl  0x8(%ebp)
  8005e0:	e8 53 fa ff ff       	call   800038 <_main>
  8005e5:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8005e8:	e8 61 1a 00 00       	call   80204e <sys_getenvid>
  8005ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  8005f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005f3:	89 d0                	mov    %edx,%eax
  8005f5:	c1 e0 03             	shl    $0x3,%eax
  8005f8:	01 d0                	add    %edx,%eax
  8005fa:	01 c0                	add    %eax,%eax
  8005fc:	01 d0                	add    %edx,%eax
  8005fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800605:	01 d0                	add    %edx,%eax
  800607:	c1 e0 03             	shl    $0x3,%eax
  80060a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80060f:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  800612:	e8 85 1b 00 00       	call   80219c <sys_disable_interrupt>
		cprintf("**************************************\n");
  800617:	83 ec 0c             	sub    $0xc,%esp
  80061a:	68 b4 29 80 00       	push   $0x8029b4
  80061f:	e8 89 01 00 00       	call   8007ad <cprintf>
  800624:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  800627:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80062a:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  800630:	83 ec 08             	sub    $0x8,%esp
  800633:	50                   	push   %eax
  800634:	68 dc 29 80 00       	push   $0x8029dc
  800639:	e8 6f 01 00 00       	call   8007ad <cprintf>
  80063e:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800641:	83 ec 0c             	sub    $0xc,%esp
  800644:	68 b4 29 80 00       	push   $0x8029b4
  800649:	e8 5f 01 00 00       	call   8007ad <cprintf>
  80064e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800651:	e8 60 1b 00 00       	call   8021b6 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800656:	e8 19 00 00 00       	call   800674 <exit>
}
  80065b:	90                   	nop
  80065c:	c9                   	leave  
  80065d:	c3                   	ret    

0080065e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80065e:	55                   	push   %ebp
  80065f:	89 e5                	mov    %esp,%ebp
  800661:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800664:	83 ec 0c             	sub    $0xc,%esp
  800667:	6a 00                	push   $0x0
  800669:	e8 c5 19 00 00       	call   802033 <sys_env_destroy>
  80066e:	83 c4 10             	add    $0x10,%esp
}
  800671:	90                   	nop
  800672:	c9                   	leave  
  800673:	c3                   	ret    

00800674 <exit>:

void
exit(void)
{
  800674:	55                   	push   %ebp
  800675:	89 e5                	mov    %esp,%ebp
  800677:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80067a:	e8 e8 19 00 00       	call   802067 <sys_env_exit>
}
  80067f:	90                   	nop
  800680:	c9                   	leave  
  800681:	c3                   	ret    

00800682 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800682:	55                   	push   %ebp
  800683:	89 e5                	mov    %esp,%ebp
  800685:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800688:	8d 45 10             	lea    0x10(%ebp),%eax
  80068b:	83 c0 04             	add    $0x4,%eax
  80068e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  800691:	a1 50 30 98 00       	mov    0x983050,%eax
  800696:	85 c0                	test   %eax,%eax
  800698:	74 16                	je     8006b0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80069a:	a1 50 30 98 00       	mov    0x983050,%eax
  80069f:	83 ec 08             	sub    $0x8,%esp
  8006a2:	50                   	push   %eax
  8006a3:	68 f5 29 80 00       	push   $0x8029f5
  8006a8:	e8 00 01 00 00       	call   8007ad <cprintf>
  8006ad:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006b0:	a1 00 30 80 00       	mov    0x803000,%eax
  8006b5:	ff 75 0c             	pushl  0xc(%ebp)
  8006b8:	ff 75 08             	pushl  0x8(%ebp)
  8006bb:	50                   	push   %eax
  8006bc:	68 fa 29 80 00       	push   $0x8029fa
  8006c1:	e8 e7 00 00 00       	call   8007ad <cprintf>
  8006c6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8006c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8006cc:	83 ec 08             	sub    $0x8,%esp
  8006cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8006d2:	50                   	push   %eax
  8006d3:	e8 7a 00 00 00       	call   800752 <vcprintf>
  8006d8:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  8006db:	83 ec 0c             	sub    $0xc,%esp
  8006de:	68 16 2a 80 00       	push   $0x802a16
  8006e3:	e8 c5 00 00 00       	call   8007ad <cprintf>
  8006e8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8006eb:	e8 84 ff ff ff       	call   800674 <exit>

	// should not return here
	while (1) ;
  8006f0:	eb fe                	jmp    8006f0 <_panic+0x6e>

008006f2 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8006f2:	55                   	push   %ebp
  8006f3:	89 e5                	mov    %esp,%ebp
  8006f5:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006fb:	8b 00                	mov    (%eax),%eax
  8006fd:	8d 48 01             	lea    0x1(%eax),%ecx
  800700:	8b 55 0c             	mov    0xc(%ebp),%edx
  800703:	89 0a                	mov    %ecx,(%edx)
  800705:	8b 55 08             	mov    0x8(%ebp),%edx
  800708:	88 d1                	mov    %dl,%cl
  80070a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80070d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800711:	8b 45 0c             	mov    0xc(%ebp),%eax
  800714:	8b 00                	mov    (%eax),%eax
  800716:	3d ff 00 00 00       	cmp    $0xff,%eax
  80071b:	75 23                	jne    800740 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  80071d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800720:	8b 00                	mov    (%eax),%eax
  800722:	89 c2                	mov    %eax,%edx
  800724:	8b 45 0c             	mov    0xc(%ebp),%eax
  800727:	83 c0 08             	add    $0x8,%eax
  80072a:	83 ec 08             	sub    $0x8,%esp
  80072d:	52                   	push   %edx
  80072e:	50                   	push   %eax
  80072f:	e8 c9 18 00 00       	call   801ffd <sys_cputs>
  800734:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800737:	8b 45 0c             	mov    0xc(%ebp),%eax
  80073a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800740:	8b 45 0c             	mov    0xc(%ebp),%eax
  800743:	8b 40 04             	mov    0x4(%eax),%eax
  800746:	8d 50 01             	lea    0x1(%eax),%edx
  800749:	8b 45 0c             	mov    0xc(%ebp),%eax
  80074c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80074f:	90                   	nop
  800750:	c9                   	leave  
  800751:	c3                   	ret    

00800752 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800752:	55                   	push   %ebp
  800753:	89 e5                	mov    %esp,%ebp
  800755:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80075b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800762:	00 00 00 
	b.cnt = 0;
  800765:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80076c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80076f:	ff 75 0c             	pushl  0xc(%ebp)
  800772:	ff 75 08             	pushl  0x8(%ebp)
  800775:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80077b:	50                   	push   %eax
  80077c:	68 f2 06 80 00       	push   $0x8006f2
  800781:	e8 fa 01 00 00       	call   800980 <vprintfmt>
  800786:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  800789:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80078f:	83 ec 08             	sub    $0x8,%esp
  800792:	50                   	push   %eax
  800793:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800799:	83 c0 08             	add    $0x8,%eax
  80079c:	50                   	push   %eax
  80079d:	e8 5b 18 00 00       	call   801ffd <sys_cputs>
  8007a2:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  8007a5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007ab:	c9                   	leave  
  8007ac:	c3                   	ret    

008007ad <cprintf>:

int cprintf(const char *fmt, ...) {
  8007ad:	55                   	push   %ebp
  8007ae:	89 e5                	mov    %esp,%ebp
  8007b0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007b3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bc:	83 ec 08             	sub    $0x8,%esp
  8007bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c2:	50                   	push   %eax
  8007c3:	e8 8a ff ff ff       	call   800752 <vcprintf>
  8007c8:	83 c4 10             	add    $0x10,%esp
  8007cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007d1:	c9                   	leave  
  8007d2:	c3                   	ret    

008007d3 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007d3:	55                   	push   %ebp
  8007d4:	89 e5                	mov    %esp,%ebp
  8007d6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007d9:	e8 be 19 00 00       	call   80219c <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007de:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e7:	83 ec 08             	sub    $0x8,%esp
  8007ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ed:	50                   	push   %eax
  8007ee:	e8 5f ff ff ff       	call   800752 <vcprintf>
  8007f3:	83 c4 10             	add    $0x10,%esp
  8007f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007f9:	e8 b8 19 00 00       	call   8021b6 <sys_enable_interrupt>
	return cnt;
  8007fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800801:	c9                   	leave  
  800802:	c3                   	ret    

00800803 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800803:	55                   	push   %ebp
  800804:	89 e5                	mov    %esp,%ebp
  800806:	53                   	push   %ebx
  800807:	83 ec 14             	sub    $0x14,%esp
  80080a:	8b 45 10             	mov    0x10(%ebp),%eax
  80080d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800810:	8b 45 14             	mov    0x14(%ebp),%eax
  800813:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800816:	8b 45 18             	mov    0x18(%ebp),%eax
  800819:	ba 00 00 00 00       	mov    $0x0,%edx
  80081e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800821:	77 55                	ja     800878 <printnum+0x75>
  800823:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800826:	72 05                	jb     80082d <printnum+0x2a>
  800828:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80082b:	77 4b                	ja     800878 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80082d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800830:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800833:	8b 45 18             	mov    0x18(%ebp),%eax
  800836:	ba 00 00 00 00       	mov    $0x0,%edx
  80083b:	52                   	push   %edx
  80083c:	50                   	push   %eax
  80083d:	ff 75 f4             	pushl  -0xc(%ebp)
  800840:	ff 75 f0             	pushl  -0x10(%ebp)
  800843:	e8 88 1d 00 00       	call   8025d0 <__udivdi3>
  800848:	83 c4 10             	add    $0x10,%esp
  80084b:	83 ec 04             	sub    $0x4,%esp
  80084e:	ff 75 20             	pushl  0x20(%ebp)
  800851:	53                   	push   %ebx
  800852:	ff 75 18             	pushl  0x18(%ebp)
  800855:	52                   	push   %edx
  800856:	50                   	push   %eax
  800857:	ff 75 0c             	pushl  0xc(%ebp)
  80085a:	ff 75 08             	pushl  0x8(%ebp)
  80085d:	e8 a1 ff ff ff       	call   800803 <printnum>
  800862:	83 c4 20             	add    $0x20,%esp
  800865:	eb 1a                	jmp    800881 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800867:	83 ec 08             	sub    $0x8,%esp
  80086a:	ff 75 0c             	pushl  0xc(%ebp)
  80086d:	ff 75 20             	pushl  0x20(%ebp)
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	ff d0                	call   *%eax
  800875:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800878:	ff 4d 1c             	decl   0x1c(%ebp)
  80087b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80087f:	7f e6                	jg     800867 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800881:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800884:	bb 00 00 00 00       	mov    $0x0,%ebx
  800889:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80088c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80088f:	53                   	push   %ebx
  800890:	51                   	push   %ecx
  800891:	52                   	push   %edx
  800892:	50                   	push   %eax
  800893:	e8 48 1e 00 00       	call   8026e0 <__umoddi3>
  800898:	83 c4 10             	add    $0x10,%esp
  80089b:	05 34 2c 80 00       	add    $0x802c34,%eax
  8008a0:	8a 00                	mov    (%eax),%al
  8008a2:	0f be c0             	movsbl %al,%eax
  8008a5:	83 ec 08             	sub    $0x8,%esp
  8008a8:	ff 75 0c             	pushl  0xc(%ebp)
  8008ab:	50                   	push   %eax
  8008ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8008af:	ff d0                	call   *%eax
  8008b1:	83 c4 10             	add    $0x10,%esp
}
  8008b4:	90                   	nop
  8008b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b8:	c9                   	leave  
  8008b9:	c3                   	ret    

008008ba <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008ba:	55                   	push   %ebp
  8008bb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008bd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008c1:	7e 1c                	jle    8008df <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	8b 00                	mov    (%eax),%eax
  8008c8:	8d 50 08             	lea    0x8(%eax),%edx
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	89 10                	mov    %edx,(%eax)
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	8b 00                	mov    (%eax),%eax
  8008d5:	83 e8 08             	sub    $0x8,%eax
  8008d8:	8b 50 04             	mov    0x4(%eax),%edx
  8008db:	8b 00                	mov    (%eax),%eax
  8008dd:	eb 40                	jmp    80091f <getuint+0x65>
	else if (lflag)
  8008df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e3:	74 1e                	je     800903 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	8b 00                	mov    (%eax),%eax
  8008ea:	8d 50 04             	lea    0x4(%eax),%edx
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	89 10                	mov    %edx,(%eax)
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	83 e8 04             	sub    $0x4,%eax
  8008fa:	8b 00                	mov    (%eax),%eax
  8008fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800901:	eb 1c                	jmp    80091f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800903:	8b 45 08             	mov    0x8(%ebp),%eax
  800906:	8b 00                	mov    (%eax),%eax
  800908:	8d 50 04             	lea    0x4(%eax),%edx
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	89 10                	mov    %edx,(%eax)
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	8b 00                	mov    (%eax),%eax
  800915:	83 e8 04             	sub    $0x4,%eax
  800918:	8b 00                	mov    (%eax),%eax
  80091a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80091f:	5d                   	pop    %ebp
  800920:	c3                   	ret    

00800921 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800921:	55                   	push   %ebp
  800922:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800924:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800928:	7e 1c                	jle    800946 <getint+0x25>
		return va_arg(*ap, long long);
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	8b 00                	mov    (%eax),%eax
  80092f:	8d 50 08             	lea    0x8(%eax),%edx
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	89 10                	mov    %edx,(%eax)
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	8b 00                	mov    (%eax),%eax
  80093c:	83 e8 08             	sub    $0x8,%eax
  80093f:	8b 50 04             	mov    0x4(%eax),%edx
  800942:	8b 00                	mov    (%eax),%eax
  800944:	eb 38                	jmp    80097e <getint+0x5d>
	else if (lflag)
  800946:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80094a:	74 1a                	je     800966 <getint+0x45>
		return va_arg(*ap, long);
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	8b 00                	mov    (%eax),%eax
  800951:	8d 50 04             	lea    0x4(%eax),%edx
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	89 10                	mov    %edx,(%eax)
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	8b 00                	mov    (%eax),%eax
  80095e:	83 e8 04             	sub    $0x4,%eax
  800961:	8b 00                	mov    (%eax),%eax
  800963:	99                   	cltd   
  800964:	eb 18                	jmp    80097e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	8d 50 04             	lea    0x4(%eax),%edx
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	89 10                	mov    %edx,(%eax)
  800973:	8b 45 08             	mov    0x8(%ebp),%eax
  800976:	8b 00                	mov    (%eax),%eax
  800978:	83 e8 04             	sub    $0x4,%eax
  80097b:	8b 00                	mov    (%eax),%eax
  80097d:	99                   	cltd   
}
  80097e:	5d                   	pop    %ebp
  80097f:	c3                   	ret    

00800980 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	56                   	push   %esi
  800984:	53                   	push   %ebx
  800985:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800988:	eb 17                	jmp    8009a1 <vprintfmt+0x21>
			if (ch == '\0')
  80098a:	85 db                	test   %ebx,%ebx
  80098c:	0f 84 af 03 00 00    	je     800d41 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800992:	83 ec 08             	sub    $0x8,%esp
  800995:	ff 75 0c             	pushl  0xc(%ebp)
  800998:	53                   	push   %ebx
  800999:	8b 45 08             	mov    0x8(%ebp),%eax
  80099c:	ff d0                	call   *%eax
  80099e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a4:	8d 50 01             	lea    0x1(%eax),%edx
  8009a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8009aa:	8a 00                	mov    (%eax),%al
  8009ac:	0f b6 d8             	movzbl %al,%ebx
  8009af:	83 fb 25             	cmp    $0x25,%ebx
  8009b2:	75 d6                	jne    80098a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009b4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009b8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009bf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009cd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d7:	8d 50 01             	lea    0x1(%eax),%edx
  8009da:	89 55 10             	mov    %edx,0x10(%ebp)
  8009dd:	8a 00                	mov    (%eax),%al
  8009df:	0f b6 d8             	movzbl %al,%ebx
  8009e2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009e5:	83 f8 55             	cmp    $0x55,%eax
  8009e8:	0f 87 2b 03 00 00    	ja     800d19 <vprintfmt+0x399>
  8009ee:	8b 04 85 58 2c 80 00 	mov    0x802c58(,%eax,4),%eax
  8009f5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009f7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009fb:	eb d7                	jmp    8009d4 <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009fd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a01:	eb d1                	jmp    8009d4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a03:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a0d:	89 d0                	mov    %edx,%eax
  800a0f:	c1 e0 02             	shl    $0x2,%eax
  800a12:	01 d0                	add    %edx,%eax
  800a14:	01 c0                	add    %eax,%eax
  800a16:	01 d8                	add    %ebx,%eax
  800a18:	83 e8 30             	sub    $0x30,%eax
  800a1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a21:	8a 00                	mov    (%eax),%al
  800a23:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a26:	83 fb 2f             	cmp    $0x2f,%ebx
  800a29:	7e 3e                	jle    800a69 <vprintfmt+0xe9>
  800a2b:	83 fb 39             	cmp    $0x39,%ebx
  800a2e:	7f 39                	jg     800a69 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a30:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a33:	eb d5                	jmp    800a0a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a35:	8b 45 14             	mov    0x14(%ebp),%eax
  800a38:	83 c0 04             	add    $0x4,%eax
  800a3b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	83 e8 04             	sub    $0x4,%eax
  800a44:	8b 00                	mov    (%eax),%eax
  800a46:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a49:	eb 1f                	jmp    800a6a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a4b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4f:	79 83                	jns    8009d4 <vprintfmt+0x54>
				width = 0;
  800a51:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a58:	e9 77 ff ff ff       	jmp    8009d4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a5d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a64:	e9 6b ff ff ff       	jmp    8009d4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a69:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6e:	0f 89 60 ff ff ff    	jns    8009d4 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a7a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a81:	e9 4e ff ff ff       	jmp    8009d4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a86:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a89:	e9 46 ff ff ff       	jmp    8009d4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a91:	83 c0 04             	add    $0x4,%eax
  800a94:	89 45 14             	mov    %eax,0x14(%ebp)
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 e8 04             	sub    $0x4,%eax
  800a9d:	8b 00                	mov    (%eax),%eax
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	ff 75 0c             	pushl  0xc(%ebp)
  800aa5:	50                   	push   %eax
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
			break;
  800aae:	e9 89 02 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab6:	83 c0 04             	add    $0x4,%eax
  800ab9:	89 45 14             	mov    %eax,0x14(%ebp)
  800abc:	8b 45 14             	mov    0x14(%ebp),%eax
  800abf:	83 e8 04             	sub    $0x4,%eax
  800ac2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ac4:	85 db                	test   %ebx,%ebx
  800ac6:	79 02                	jns    800aca <vprintfmt+0x14a>
				err = -err;
  800ac8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800aca:	83 fb 64             	cmp    $0x64,%ebx
  800acd:	7f 0b                	jg     800ada <vprintfmt+0x15a>
  800acf:	8b 34 9d a0 2a 80 00 	mov    0x802aa0(,%ebx,4),%esi
  800ad6:	85 f6                	test   %esi,%esi
  800ad8:	75 19                	jne    800af3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ada:	53                   	push   %ebx
  800adb:	68 45 2c 80 00       	push   $0x802c45
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	ff 75 08             	pushl  0x8(%ebp)
  800ae6:	e8 5e 02 00 00       	call   800d49 <printfmt>
  800aeb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aee:	e9 49 02 00 00       	jmp    800d3c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800af3:	56                   	push   %esi
  800af4:	68 4e 2c 80 00       	push   $0x802c4e
  800af9:	ff 75 0c             	pushl  0xc(%ebp)
  800afc:	ff 75 08             	pushl  0x8(%ebp)
  800aff:	e8 45 02 00 00       	call   800d49 <printfmt>
  800b04:	83 c4 10             	add    $0x10,%esp
			break;
  800b07:	e9 30 02 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0f:	83 c0 04             	add    $0x4,%eax
  800b12:	89 45 14             	mov    %eax,0x14(%ebp)
  800b15:	8b 45 14             	mov    0x14(%ebp),%eax
  800b18:	83 e8 04             	sub    $0x4,%eax
  800b1b:	8b 30                	mov    (%eax),%esi
  800b1d:	85 f6                	test   %esi,%esi
  800b1f:	75 05                	jne    800b26 <vprintfmt+0x1a6>
				p = "(null)";
  800b21:	be 51 2c 80 00       	mov    $0x802c51,%esi
			if (width > 0 && padc != '-')
  800b26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2a:	7e 6d                	jle    800b99 <vprintfmt+0x219>
  800b2c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b30:	74 67                	je     800b99 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b35:	83 ec 08             	sub    $0x8,%esp
  800b38:	50                   	push   %eax
  800b39:	56                   	push   %esi
  800b3a:	e8 0c 03 00 00       	call   800e4b <strnlen>
  800b3f:	83 c4 10             	add    $0x10,%esp
  800b42:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b45:	eb 16                	jmp    800b5d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b47:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b4b:	83 ec 08             	sub    $0x8,%esp
  800b4e:	ff 75 0c             	pushl  0xc(%ebp)
  800b51:	50                   	push   %eax
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	ff d0                	call   *%eax
  800b57:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b5a:	ff 4d e4             	decl   -0x1c(%ebp)
  800b5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b61:	7f e4                	jg     800b47 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b63:	eb 34                	jmp    800b99 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b65:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b69:	74 1c                	je     800b87 <vprintfmt+0x207>
  800b6b:	83 fb 1f             	cmp    $0x1f,%ebx
  800b6e:	7e 05                	jle    800b75 <vprintfmt+0x1f5>
  800b70:	83 fb 7e             	cmp    $0x7e,%ebx
  800b73:	7e 12                	jle    800b87 <vprintfmt+0x207>
					putch('?', putdat);
  800b75:	83 ec 08             	sub    $0x8,%esp
  800b78:	ff 75 0c             	pushl  0xc(%ebp)
  800b7b:	6a 3f                	push   $0x3f
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	ff d0                	call   *%eax
  800b82:	83 c4 10             	add    $0x10,%esp
  800b85:	eb 0f                	jmp    800b96 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b87:	83 ec 08             	sub    $0x8,%esp
  800b8a:	ff 75 0c             	pushl  0xc(%ebp)
  800b8d:	53                   	push   %ebx
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	ff d0                	call   *%eax
  800b93:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b96:	ff 4d e4             	decl   -0x1c(%ebp)
  800b99:	89 f0                	mov    %esi,%eax
  800b9b:	8d 70 01             	lea    0x1(%eax),%esi
  800b9e:	8a 00                	mov    (%eax),%al
  800ba0:	0f be d8             	movsbl %al,%ebx
  800ba3:	85 db                	test   %ebx,%ebx
  800ba5:	74 24                	je     800bcb <vprintfmt+0x24b>
  800ba7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bab:	78 b8                	js     800b65 <vprintfmt+0x1e5>
  800bad:	ff 4d e0             	decl   -0x20(%ebp)
  800bb0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bb4:	79 af                	jns    800b65 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb6:	eb 13                	jmp    800bcb <vprintfmt+0x24b>
				putch(' ', putdat);
  800bb8:	83 ec 08             	sub    $0x8,%esp
  800bbb:	ff 75 0c             	pushl  0xc(%ebp)
  800bbe:	6a 20                	push   $0x20
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	ff d0                	call   *%eax
  800bc5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc8:	ff 4d e4             	decl   -0x1c(%ebp)
  800bcb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bcf:	7f e7                	jg     800bb8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bd1:	e9 66 01 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bd6:	83 ec 08             	sub    $0x8,%esp
  800bd9:	ff 75 e8             	pushl  -0x18(%ebp)
  800bdc:	8d 45 14             	lea    0x14(%ebp),%eax
  800bdf:	50                   	push   %eax
  800be0:	e8 3c fd ff ff       	call   800921 <getint>
  800be5:	83 c4 10             	add    $0x10,%esp
  800be8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800beb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf4:	85 d2                	test   %edx,%edx
  800bf6:	79 23                	jns    800c1b <vprintfmt+0x29b>
				putch('-', putdat);
  800bf8:	83 ec 08             	sub    $0x8,%esp
  800bfb:	ff 75 0c             	pushl  0xc(%ebp)
  800bfe:	6a 2d                	push   $0x2d
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	ff d0                	call   *%eax
  800c05:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c0e:	f7 d8                	neg    %eax
  800c10:	83 d2 00             	adc    $0x0,%edx
  800c13:	f7 da                	neg    %edx
  800c15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c18:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c1b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c22:	e9 bc 00 00 00       	jmp    800ce3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c27:	83 ec 08             	sub    $0x8,%esp
  800c2a:	ff 75 e8             	pushl  -0x18(%ebp)
  800c2d:	8d 45 14             	lea    0x14(%ebp),%eax
  800c30:	50                   	push   %eax
  800c31:	e8 84 fc ff ff       	call   8008ba <getuint>
  800c36:	83 c4 10             	add    $0x10,%esp
  800c39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c3f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c46:	e9 98 00 00 00       	jmp    800ce3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c4b:	83 ec 08             	sub    $0x8,%esp
  800c4e:	ff 75 0c             	pushl  0xc(%ebp)
  800c51:	6a 58                	push   $0x58
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
  800c56:	ff d0                	call   *%eax
  800c58:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	ff 75 0c             	pushl  0xc(%ebp)
  800c61:	6a 58                	push   $0x58
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	ff d0                	call   *%eax
  800c68:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c6b:	83 ec 08             	sub    $0x8,%esp
  800c6e:	ff 75 0c             	pushl  0xc(%ebp)
  800c71:	6a 58                	push   $0x58
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	ff d0                	call   *%eax
  800c78:	83 c4 10             	add    $0x10,%esp
			break;
  800c7b:	e9 bc 00 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c80:	83 ec 08             	sub    $0x8,%esp
  800c83:	ff 75 0c             	pushl  0xc(%ebp)
  800c86:	6a 30                	push   $0x30
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8b:	ff d0                	call   *%eax
  800c8d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c90:	83 ec 08             	sub    $0x8,%esp
  800c93:	ff 75 0c             	pushl  0xc(%ebp)
  800c96:	6a 78                	push   $0x78
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	ff d0                	call   *%eax
  800c9d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ca0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca3:	83 c0 04             	add    $0x4,%eax
  800ca6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cac:	83 e8 04             	sub    $0x4,%eax
  800caf:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cbb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cc2:	eb 1f                	jmp    800ce3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cc4:	83 ec 08             	sub    $0x8,%esp
  800cc7:	ff 75 e8             	pushl  -0x18(%ebp)
  800cca:	8d 45 14             	lea    0x14(%ebp),%eax
  800ccd:	50                   	push   %eax
  800cce:	e8 e7 fb ff ff       	call   8008ba <getuint>
  800cd3:	83 c4 10             	add    $0x10,%esp
  800cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cdc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ce3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ce7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cea:	83 ec 04             	sub    $0x4,%esp
  800ced:	52                   	push   %edx
  800cee:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cf1:	50                   	push   %eax
  800cf2:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf5:	ff 75 f0             	pushl  -0x10(%ebp)
  800cf8:	ff 75 0c             	pushl  0xc(%ebp)
  800cfb:	ff 75 08             	pushl  0x8(%ebp)
  800cfe:	e8 00 fb ff ff       	call   800803 <printnum>
  800d03:	83 c4 20             	add    $0x20,%esp
			break;
  800d06:	eb 34                	jmp    800d3c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d08:	83 ec 08             	sub    $0x8,%esp
  800d0b:	ff 75 0c             	pushl  0xc(%ebp)
  800d0e:	53                   	push   %ebx
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	ff d0                	call   *%eax
  800d14:	83 c4 10             	add    $0x10,%esp
			break;
  800d17:	eb 23                	jmp    800d3c <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d19:	83 ec 08             	sub    $0x8,%esp
  800d1c:	ff 75 0c             	pushl  0xc(%ebp)
  800d1f:	6a 25                	push   $0x25
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	ff d0                	call   *%eax
  800d26:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d29:	ff 4d 10             	decl   0x10(%ebp)
  800d2c:	eb 03                	jmp    800d31 <vprintfmt+0x3b1>
  800d2e:	ff 4d 10             	decl   0x10(%ebp)
  800d31:	8b 45 10             	mov    0x10(%ebp),%eax
  800d34:	48                   	dec    %eax
  800d35:	8a 00                	mov    (%eax),%al
  800d37:	3c 25                	cmp    $0x25,%al
  800d39:	75 f3                	jne    800d2e <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d3b:	90                   	nop
		}
	}
  800d3c:	e9 47 fc ff ff       	jmp    800988 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d41:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d42:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d45:	5b                   	pop    %ebx
  800d46:	5e                   	pop    %esi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    

00800d49 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d4f:	8d 45 10             	lea    0x10(%ebp),%eax
  800d52:	83 c0 04             	add    $0x4,%eax
  800d55:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d58:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5b:	ff 75 f4             	pushl  -0xc(%ebp)
  800d5e:	50                   	push   %eax
  800d5f:	ff 75 0c             	pushl  0xc(%ebp)
  800d62:	ff 75 08             	pushl  0x8(%ebp)
  800d65:	e8 16 fc ff ff       	call   800980 <vprintfmt>
  800d6a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d6d:	90                   	nop
  800d6e:	c9                   	leave  
  800d6f:	c3                   	ret    

00800d70 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d76:	8b 40 08             	mov    0x8(%eax),%eax
  800d79:	8d 50 01             	lea    0x1(%eax),%edx
  800d7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d85:	8b 10                	mov    (%eax),%edx
  800d87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8a:	8b 40 04             	mov    0x4(%eax),%eax
  800d8d:	39 c2                	cmp    %eax,%edx
  800d8f:	73 12                	jae    800da3 <sprintputch+0x33>
		*b->buf++ = ch;
  800d91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d94:	8b 00                	mov    (%eax),%eax
  800d96:	8d 48 01             	lea    0x1(%eax),%ecx
  800d99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9c:	89 0a                	mov    %ecx,(%edx)
  800d9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800da1:	88 10                	mov    %dl,(%eax)
}
  800da3:	90                   	nop
  800da4:	5d                   	pop    %ebp
  800da5:	c3                   	ret    

00800da6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800db2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	01 d0                	add    %edx,%eax
  800dbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dc7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dcb:	74 06                	je     800dd3 <vsnprintf+0x2d>
  800dcd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd1:	7f 07                	jg     800dda <vsnprintf+0x34>
		return -E_INVAL;
  800dd3:	b8 03 00 00 00       	mov    $0x3,%eax
  800dd8:	eb 20                	jmp    800dfa <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dda:	ff 75 14             	pushl  0x14(%ebp)
  800ddd:	ff 75 10             	pushl  0x10(%ebp)
  800de0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800de3:	50                   	push   %eax
  800de4:	68 70 0d 80 00       	push   $0x800d70
  800de9:	e8 92 fb ff ff       	call   800980 <vprintfmt>
  800dee:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800df1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800df4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dfa:	c9                   	leave  
  800dfb:	c3                   	ret    

00800dfc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e02:	8d 45 10             	lea    0x10(%ebp),%eax
  800e05:	83 c0 04             	add    $0x4,%eax
  800e08:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0e:	ff 75 f4             	pushl  -0xc(%ebp)
  800e11:	50                   	push   %eax
  800e12:	ff 75 0c             	pushl  0xc(%ebp)
  800e15:	ff 75 08             	pushl  0x8(%ebp)
  800e18:	e8 89 ff ff ff       	call   800da6 <vsnprintf>
  800e1d:	83 c4 10             	add    $0x10,%esp
  800e20:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e23:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e26:	c9                   	leave  
  800e27:	c3                   	ret    

00800e28 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e35:	eb 06                	jmp    800e3d <strlen+0x15>
		n++;
  800e37:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e3a:	ff 45 08             	incl   0x8(%ebp)
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	8a 00                	mov    (%eax),%al
  800e42:	84 c0                	test   %al,%al
  800e44:	75 f1                	jne    800e37 <strlen+0xf>
		n++;
	return n;
  800e46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e49:	c9                   	leave  
  800e4a:	c3                   	ret    

00800e4b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e58:	eb 09                	jmp    800e63 <strnlen+0x18>
		n++;
  800e5a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e5d:	ff 45 08             	incl   0x8(%ebp)
  800e60:	ff 4d 0c             	decl   0xc(%ebp)
  800e63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e67:	74 09                	je     800e72 <strnlen+0x27>
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	8a 00                	mov    (%eax),%al
  800e6e:	84 c0                	test   %al,%al
  800e70:	75 e8                	jne    800e5a <strnlen+0xf>
		n++;
	return n;
  800e72:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e75:	c9                   	leave  
  800e76:	c3                   	ret    

00800e77 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e83:	90                   	nop
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	8d 50 01             	lea    0x1(%eax),%edx
  800e8a:	89 55 08             	mov    %edx,0x8(%ebp)
  800e8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e90:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e93:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e96:	8a 12                	mov    (%edx),%dl
  800e98:	88 10                	mov    %dl,(%eax)
  800e9a:	8a 00                	mov    (%eax),%al
  800e9c:	84 c0                	test   %al,%al
  800e9e:	75 e4                	jne    800e84 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ea0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ea3:	c9                   	leave  
  800ea4:	c3                   	ret    

00800ea5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800eb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb8:	eb 1f                	jmp    800ed9 <strncpy+0x34>
		*dst++ = *src;
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	8d 50 01             	lea    0x1(%eax),%edx
  800ec0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ec3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec6:	8a 12                	mov    (%edx),%dl
  800ec8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	8a 00                	mov    (%eax),%al
  800ecf:	84 c0                	test   %al,%al
  800ed1:	74 03                	je     800ed6 <strncpy+0x31>
			src++;
  800ed3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ed6:	ff 45 fc             	incl   -0x4(%ebp)
  800ed9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800edc:	3b 45 10             	cmp    0x10(%ebp),%eax
  800edf:	72 d9                	jb     800eba <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ee1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ee4:	c9                   	leave  
  800ee5:	c3                   	ret    

00800ee6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ef2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef6:	74 30                	je     800f28 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ef8:	eb 16                	jmp    800f10 <strlcpy+0x2a>
			*dst++ = *src++;
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8d 50 01             	lea    0x1(%eax),%edx
  800f00:	89 55 08             	mov    %edx,0x8(%ebp)
  800f03:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f06:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f09:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f0c:	8a 12                	mov    (%edx),%dl
  800f0e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f10:	ff 4d 10             	decl   0x10(%ebp)
  800f13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f17:	74 09                	je     800f22 <strlcpy+0x3c>
  800f19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1c:	8a 00                	mov    (%eax),%al
  800f1e:	84 c0                	test   %al,%al
  800f20:	75 d8                	jne    800efa <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
  800f25:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f28:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2e:	29 c2                	sub    %eax,%edx
  800f30:	89 d0                	mov    %edx,%eax
}
  800f32:	c9                   	leave  
  800f33:	c3                   	ret    

00800f34 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f37:	eb 06                	jmp    800f3f <strcmp+0xb>
		p++, q++;
  800f39:	ff 45 08             	incl   0x8(%ebp)
  800f3c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	84 c0                	test   %al,%al
  800f46:	74 0e                	je     800f56 <strcmp+0x22>
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8a 10                	mov    (%eax),%dl
  800f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f50:	8a 00                	mov    (%eax),%al
  800f52:	38 c2                	cmp    %al,%dl
  800f54:	74 e3                	je     800f39 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	0f b6 d0             	movzbl %al,%edx
  800f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	0f b6 c0             	movzbl %al,%eax
  800f66:	29 c2                	sub    %eax,%edx
  800f68:	89 d0                	mov    %edx,%eax
}
  800f6a:	5d                   	pop    %ebp
  800f6b:	c3                   	ret    

00800f6c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f6f:	eb 09                	jmp    800f7a <strncmp+0xe>
		n--, p++, q++;
  800f71:	ff 4d 10             	decl   0x10(%ebp)
  800f74:	ff 45 08             	incl   0x8(%ebp)
  800f77:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7e:	74 17                	je     800f97 <strncmp+0x2b>
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	84 c0                	test   %al,%al
  800f87:	74 0e                	je     800f97 <strncmp+0x2b>
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	8a 10                	mov    (%eax),%dl
  800f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f91:	8a 00                	mov    (%eax),%al
  800f93:	38 c2                	cmp    %al,%dl
  800f95:	74 da                	je     800f71 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9b:	75 07                	jne    800fa4 <strncmp+0x38>
		return 0;
  800f9d:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa2:	eb 14                	jmp    800fb8 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	0f b6 d0             	movzbl %al,%edx
  800fac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	0f b6 c0             	movzbl %al,%eax
  800fb4:	29 c2                	sub    %eax,%edx
  800fb6:	89 d0                	mov    %edx,%eax
}
  800fb8:	5d                   	pop    %ebp
  800fb9:	c3                   	ret    

00800fba <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fba:	55                   	push   %ebp
  800fbb:	89 e5                	mov    %esp,%ebp
  800fbd:	83 ec 04             	sub    $0x4,%esp
  800fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fc6:	eb 12                	jmp    800fda <strchr+0x20>
		if (*s == c)
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	8a 00                	mov    (%eax),%al
  800fcd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fd0:	75 05                	jne    800fd7 <strchr+0x1d>
			return (char *) s;
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	eb 11                	jmp    800fe8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fd7:	ff 45 08             	incl   0x8(%ebp)
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	84 c0                	test   %al,%al
  800fe1:	75 e5                	jne    800fc8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fe3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fe8:	c9                   	leave  
  800fe9:	c3                   	ret    

00800fea <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	83 ec 04             	sub    $0x4,%esp
  800ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ff6:	eb 0d                	jmp    801005 <strfind+0x1b>
		if (*s == c)
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	8a 00                	mov    (%eax),%al
  800ffd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801000:	74 0e                	je     801010 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801002:	ff 45 08             	incl   0x8(%ebp)
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	84 c0                	test   %al,%al
  80100c:	75 ea                	jne    800ff8 <strfind+0xe>
  80100e:	eb 01                	jmp    801011 <strfind+0x27>
		if (*s == c)
			break;
  801010:	90                   	nop
	return (char *) s;
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801014:	c9                   	leave  
  801015:	c3                   	ret    

00801016 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801022:	8b 45 10             	mov    0x10(%ebp),%eax
  801025:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801028:	eb 0e                	jmp    801038 <memset+0x22>
		*p++ = c;
  80102a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102d:	8d 50 01             	lea    0x1(%eax),%edx
  801030:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801033:	8b 55 0c             	mov    0xc(%ebp),%edx
  801036:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801038:	ff 4d f8             	decl   -0x8(%ebp)
  80103b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80103f:	79 e9                	jns    80102a <memset+0x14>
		*p++ = c;

	return v;
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801044:	c9                   	leave  
  801045:	c3                   	ret    

00801046 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801046:	55                   	push   %ebp
  801047:	89 e5                	mov    %esp,%ebp
  801049:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80104c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
  801055:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801058:	eb 16                	jmp    801070 <memcpy+0x2a>
		*d++ = *s++;
  80105a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105d:	8d 50 01             	lea    0x1(%eax),%edx
  801060:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801063:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801066:	8d 4a 01             	lea    0x1(%edx),%ecx
  801069:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80106c:	8a 12                	mov    (%edx),%dl
  80106e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801070:	8b 45 10             	mov    0x10(%ebp),%eax
  801073:	8d 50 ff             	lea    -0x1(%eax),%edx
  801076:	89 55 10             	mov    %edx,0x10(%ebp)
  801079:	85 c0                	test   %eax,%eax
  80107b:	75 dd                	jne    80105a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801080:	c9                   	leave  
  801081:	c3                   	ret    

00801082 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  801088:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80108e:	8b 45 08             	mov    0x8(%ebp),%eax
  801091:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801094:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801097:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80109a:	73 50                	jae    8010ec <memmove+0x6a>
  80109c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80109f:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a2:	01 d0                	add    %edx,%eax
  8010a4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010a7:	76 43                	jbe    8010ec <memmove+0x6a>
		s += n;
  8010a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ac:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010af:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010b5:	eb 10                	jmp    8010c7 <memmove+0x45>
			*--d = *--s;
  8010b7:	ff 4d f8             	decl   -0x8(%ebp)
  8010ba:	ff 4d fc             	decl   -0x4(%ebp)
  8010bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c0:	8a 10                	mov    (%eax),%dl
  8010c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ca:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010cd:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d0:	85 c0                	test   %eax,%eax
  8010d2:	75 e3                	jne    8010b7 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010d4:	eb 23                	jmp    8010f9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d9:	8d 50 01             	lea    0x1(%eax),%edx
  8010dc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010df:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010e2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010e5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010e8:	8a 12                	mov    (%edx),%dl
  8010ea:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f2:	89 55 10             	mov    %edx,0x10(%ebp)
  8010f5:	85 c0                	test   %eax,%eax
  8010f7:	75 dd                	jne    8010d6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010fc:	c9                   	leave  
  8010fd:	c3                   	ret    

008010fe <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010fe:	55                   	push   %ebp
  8010ff:	89 e5                	mov    %esp,%ebp
  801101:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80110a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801110:	eb 2a                	jmp    80113c <memcmp+0x3e>
		if (*s1 != *s2)
  801112:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801115:	8a 10                	mov    (%eax),%dl
  801117:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	38 c2                	cmp    %al,%dl
  80111e:	74 16                	je     801136 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801120:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801123:	8a 00                	mov    (%eax),%al
  801125:	0f b6 d0             	movzbl %al,%edx
  801128:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112b:	8a 00                	mov    (%eax),%al
  80112d:	0f b6 c0             	movzbl %al,%eax
  801130:	29 c2                	sub    %eax,%edx
  801132:	89 d0                	mov    %edx,%eax
  801134:	eb 18                	jmp    80114e <memcmp+0x50>
		s1++, s2++;
  801136:	ff 45 fc             	incl   -0x4(%ebp)
  801139:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80113c:	8b 45 10             	mov    0x10(%ebp),%eax
  80113f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801142:	89 55 10             	mov    %edx,0x10(%ebp)
  801145:	85 c0                	test   %eax,%eax
  801147:	75 c9                	jne    801112 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801149:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80114e:	c9                   	leave  
  80114f:	c3                   	ret    

00801150 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
  801153:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801156:	8b 55 08             	mov    0x8(%ebp),%edx
  801159:	8b 45 10             	mov    0x10(%ebp),%eax
  80115c:	01 d0                	add    %edx,%eax
  80115e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801161:	eb 15                	jmp    801178 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	8a 00                	mov    (%eax),%al
  801168:	0f b6 d0             	movzbl %al,%edx
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	0f b6 c0             	movzbl %al,%eax
  801171:	39 c2                	cmp    %eax,%edx
  801173:	74 0d                	je     801182 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801175:	ff 45 08             	incl   0x8(%ebp)
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80117e:	72 e3                	jb     801163 <memfind+0x13>
  801180:	eb 01                	jmp    801183 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801182:	90                   	nop
	return (void *) s;
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801186:	c9                   	leave  
  801187:	c3                   	ret    

00801188 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
  80118b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80118e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801195:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80119c:	eb 03                	jmp    8011a1 <strtol+0x19>
		s++;
  80119e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	8a 00                	mov    (%eax),%al
  8011a6:	3c 20                	cmp    $0x20,%al
  8011a8:	74 f4                	je     80119e <strtol+0x16>
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	8a 00                	mov    (%eax),%al
  8011af:	3c 09                	cmp    $0x9,%al
  8011b1:	74 eb                	je     80119e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	3c 2b                	cmp    $0x2b,%al
  8011ba:	75 05                	jne    8011c1 <strtol+0x39>
		s++;
  8011bc:	ff 45 08             	incl   0x8(%ebp)
  8011bf:	eb 13                	jmp    8011d4 <strtol+0x4c>
	else if (*s == '-')
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	3c 2d                	cmp    $0x2d,%al
  8011c8:	75 0a                	jne    8011d4 <strtol+0x4c>
		s++, neg = 1;
  8011ca:	ff 45 08             	incl   0x8(%ebp)
  8011cd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d8:	74 06                	je     8011e0 <strtol+0x58>
  8011da:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011de:	75 20                	jne    801200 <strtol+0x78>
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	8a 00                	mov    (%eax),%al
  8011e5:	3c 30                	cmp    $0x30,%al
  8011e7:	75 17                	jne    801200 <strtol+0x78>
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	40                   	inc    %eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 78                	cmp    $0x78,%al
  8011f1:	75 0d                	jne    801200 <strtol+0x78>
		s += 2, base = 16;
  8011f3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011f7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011fe:	eb 28                	jmp    801228 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801200:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801204:	75 15                	jne    80121b <strtol+0x93>
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	3c 30                	cmp    $0x30,%al
  80120d:	75 0c                	jne    80121b <strtol+0x93>
		s++, base = 8;
  80120f:	ff 45 08             	incl   0x8(%ebp)
  801212:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801219:	eb 0d                	jmp    801228 <strtol+0xa0>
	else if (base == 0)
  80121b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80121f:	75 07                	jne    801228 <strtol+0xa0>
		base = 10;
  801221:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	3c 2f                	cmp    $0x2f,%al
  80122f:	7e 19                	jle    80124a <strtol+0xc2>
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	3c 39                	cmp    $0x39,%al
  801238:	7f 10                	jg     80124a <strtol+0xc2>
			dig = *s - '0';
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
  80123d:	8a 00                	mov    (%eax),%al
  80123f:	0f be c0             	movsbl %al,%eax
  801242:	83 e8 30             	sub    $0x30,%eax
  801245:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801248:	eb 42                	jmp    80128c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	8a 00                	mov    (%eax),%al
  80124f:	3c 60                	cmp    $0x60,%al
  801251:	7e 19                	jle    80126c <strtol+0xe4>
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
  801256:	8a 00                	mov    (%eax),%al
  801258:	3c 7a                	cmp    $0x7a,%al
  80125a:	7f 10                	jg     80126c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	8a 00                	mov    (%eax),%al
  801261:	0f be c0             	movsbl %al,%eax
  801264:	83 e8 57             	sub    $0x57,%eax
  801267:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80126a:	eb 20                	jmp    80128c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	3c 40                	cmp    $0x40,%al
  801273:	7e 39                	jle    8012ae <strtol+0x126>
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	3c 5a                	cmp    $0x5a,%al
  80127c:	7f 30                	jg     8012ae <strtol+0x126>
			dig = *s - 'A' + 10;
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	8a 00                	mov    (%eax),%al
  801283:	0f be c0             	movsbl %al,%eax
  801286:	83 e8 37             	sub    $0x37,%eax
  801289:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80128c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80128f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801292:	7d 19                	jge    8012ad <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801294:	ff 45 08             	incl   0x8(%ebp)
  801297:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80129a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80129e:	89 c2                	mov    %eax,%edx
  8012a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a3:	01 d0                	add    %edx,%eax
  8012a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012a8:	e9 7b ff ff ff       	jmp    801228 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012ad:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012b2:	74 08                	je     8012bc <strtol+0x134>
		*endptr = (char *) s;
  8012b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ba:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012c0:	74 07                	je     8012c9 <strtol+0x141>
  8012c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c5:	f7 d8                	neg    %eax
  8012c7:	eb 03                	jmp    8012cc <strtol+0x144>
  8012c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    

008012ce <ltostr>:

void
ltostr(long value, char *str)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e6:	79 13                	jns    8012fb <ltostr+0x2d>
	{
		neg = 1;
  8012e8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012f5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012f8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801303:	99                   	cltd   
  801304:	f7 f9                	idiv   %ecx
  801306:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801309:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80130c:	8d 50 01             	lea    0x1(%eax),%edx
  80130f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801312:	89 c2                	mov    %eax,%edx
  801314:	8b 45 0c             	mov    0xc(%ebp),%eax
  801317:	01 d0                	add    %edx,%eax
  801319:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80131c:	83 c2 30             	add    $0x30,%edx
  80131f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801321:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801324:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801329:	f7 e9                	imul   %ecx
  80132b:	c1 fa 02             	sar    $0x2,%edx
  80132e:	89 c8                	mov    %ecx,%eax
  801330:	c1 f8 1f             	sar    $0x1f,%eax
  801333:	29 c2                	sub    %eax,%edx
  801335:	89 d0                	mov    %edx,%eax
  801337:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80133a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80133d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801342:	f7 e9                	imul   %ecx
  801344:	c1 fa 02             	sar    $0x2,%edx
  801347:	89 c8                	mov    %ecx,%eax
  801349:	c1 f8 1f             	sar    $0x1f,%eax
  80134c:	29 c2                	sub    %eax,%edx
  80134e:	89 d0                	mov    %edx,%eax
  801350:	c1 e0 02             	shl    $0x2,%eax
  801353:	01 d0                	add    %edx,%eax
  801355:	01 c0                	add    %eax,%eax
  801357:	29 c1                	sub    %eax,%ecx
  801359:	89 ca                	mov    %ecx,%edx
  80135b:	85 d2                	test   %edx,%edx
  80135d:	75 9c                	jne    8012fb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80135f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801366:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801369:	48                   	dec    %eax
  80136a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80136d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801371:	74 3d                	je     8013b0 <ltostr+0xe2>
		start = 1 ;
  801373:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80137a:	eb 34                	jmp    8013b0 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80137c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80137f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801382:	01 d0                	add    %edx,%eax
  801384:	8a 00                	mov    (%eax),%al
  801386:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801389:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80138c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138f:	01 c2                	add    %eax,%edx
  801391:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801394:	8b 45 0c             	mov    0xc(%ebp),%eax
  801397:	01 c8                	add    %ecx,%eax
  801399:	8a 00                	mov    (%eax),%al
  80139b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80139d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a3:	01 c2                	add    %eax,%edx
  8013a5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013a8:	88 02                	mov    %al,(%edx)
		start++ ;
  8013aa:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013ad:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013b3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013b6:	7c c4                	jl     80137c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013b8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013be:	01 d0                	add    %edx,%eax
  8013c0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013c3:	90                   	nop
  8013c4:	c9                   	leave  
  8013c5:	c3                   	ret    

008013c6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
  8013c9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013cc:	ff 75 08             	pushl  0x8(%ebp)
  8013cf:	e8 54 fa ff ff       	call   800e28 <strlen>
  8013d4:	83 c4 04             	add    $0x4,%esp
  8013d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013da:	ff 75 0c             	pushl  0xc(%ebp)
  8013dd:	e8 46 fa ff ff       	call   800e28 <strlen>
  8013e2:	83 c4 04             	add    $0x4,%esp
  8013e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013f6:	eb 17                	jmp    80140f <strcconcat+0x49>
		final[s] = str1[s] ;
  8013f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	01 c2                	add    %eax,%edx
  801400:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	01 c8                	add    %ecx,%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80140c:	ff 45 fc             	incl   -0x4(%ebp)
  80140f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801412:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801415:	7c e1                	jl     8013f8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801417:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80141e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801425:	eb 1f                	jmp    801446 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801427:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80142a:	8d 50 01             	lea    0x1(%eax),%edx
  80142d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801430:	89 c2                	mov    %eax,%edx
  801432:	8b 45 10             	mov    0x10(%ebp),%eax
  801435:	01 c2                	add    %eax,%edx
  801437:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80143a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143d:	01 c8                	add    %ecx,%eax
  80143f:	8a 00                	mov    (%eax),%al
  801441:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801443:	ff 45 f8             	incl   -0x8(%ebp)
  801446:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801449:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80144c:	7c d9                	jl     801427 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80144e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801451:	8b 45 10             	mov    0x10(%ebp),%eax
  801454:	01 d0                	add    %edx,%eax
  801456:	c6 00 00             	movb   $0x0,(%eax)
}
  801459:	90                   	nop
  80145a:	c9                   	leave  
  80145b:	c3                   	ret    

0080145c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80145f:	8b 45 14             	mov    0x14(%ebp),%eax
  801462:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801468:	8b 45 14             	mov    0x14(%ebp),%eax
  80146b:	8b 00                	mov    (%eax),%eax
  80146d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801474:	8b 45 10             	mov    0x10(%ebp),%eax
  801477:	01 d0                	add    %edx,%eax
  801479:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80147f:	eb 0c                	jmp    80148d <strsplit+0x31>
			*string++ = 0;
  801481:	8b 45 08             	mov    0x8(%ebp),%eax
  801484:	8d 50 01             	lea    0x1(%eax),%edx
  801487:	89 55 08             	mov    %edx,0x8(%ebp)
  80148a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80148d:	8b 45 08             	mov    0x8(%ebp),%eax
  801490:	8a 00                	mov    (%eax),%al
  801492:	84 c0                	test   %al,%al
  801494:	74 18                	je     8014ae <strsplit+0x52>
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	8a 00                	mov    (%eax),%al
  80149b:	0f be c0             	movsbl %al,%eax
  80149e:	50                   	push   %eax
  80149f:	ff 75 0c             	pushl  0xc(%ebp)
  8014a2:	e8 13 fb ff ff       	call   800fba <strchr>
  8014a7:	83 c4 08             	add    $0x8,%esp
  8014aa:	85 c0                	test   %eax,%eax
  8014ac:	75 d3                	jne    801481 <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  8014ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b1:	8a 00                	mov    (%eax),%al
  8014b3:	84 c0                	test   %al,%al
  8014b5:	74 5a                	je     801511 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  8014b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ba:	8b 00                	mov    (%eax),%eax
  8014bc:	83 f8 0f             	cmp    $0xf,%eax
  8014bf:	75 07                	jne    8014c8 <strsplit+0x6c>
		{
			return 0;
  8014c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c6:	eb 66                	jmp    80152e <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014cb:	8b 00                	mov    (%eax),%eax
  8014cd:	8d 48 01             	lea    0x1(%eax),%ecx
  8014d0:	8b 55 14             	mov    0x14(%ebp),%edx
  8014d3:	89 0a                	mov    %ecx,(%edx)
  8014d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014df:	01 c2                	add    %eax,%edx
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014e6:	eb 03                	jmp    8014eb <strsplit+0x8f>
			string++;
  8014e8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ee:	8a 00                	mov    (%eax),%al
  8014f0:	84 c0                	test   %al,%al
  8014f2:	74 8b                	je     80147f <strsplit+0x23>
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	8a 00                	mov    (%eax),%al
  8014f9:	0f be c0             	movsbl %al,%eax
  8014fc:	50                   	push   %eax
  8014fd:	ff 75 0c             	pushl  0xc(%ebp)
  801500:	e8 b5 fa ff ff       	call   800fba <strchr>
  801505:	83 c4 08             	add    $0x8,%esp
  801508:	85 c0                	test   %eax,%eax
  80150a:	74 dc                	je     8014e8 <strsplit+0x8c>
			string++;
	}
  80150c:	e9 6e ff ff ff       	jmp    80147f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801511:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801512:	8b 45 14             	mov    0x14(%ebp),%eax
  801515:	8b 00                	mov    (%eax),%eax
  801517:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80151e:	8b 45 10             	mov    0x10(%ebp),%eax
  801521:	01 d0                	add    %edx,%eax
  801523:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801529:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80152e:	c9                   	leave  
  80152f:	c3                   	ret    

00801530 <malloc>:
int cnt_mem = 0;
int heap_mem[size_uhmem] = { 0 };
struct hmem heap_size[size_uhmem] = { 0 };
int check = 0;

void* malloc(uint32 size) {
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
  801533:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyNEXTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	//NEXT FIT
	if (sys_isUHeapPlacementStrategyNEXTFIT()) {
  801539:	e8 7d 0f 00 00       	call   8024bb <sys_isUHeapPlacementStrategyNEXTFIT>
  80153e:	85 c0                	test   %eax,%eax
  801540:	0f 84 6f 03 00 00    	je     8018b5 <malloc+0x385>
		size = ROUNDUP(size, PAGE_SIZE);
  801546:	c7 45 84 00 10 00 00 	movl   $0x1000,-0x7c(%ebp)
  80154d:	8b 55 08             	mov    0x8(%ebp),%edx
  801550:	8b 45 84             	mov    -0x7c(%ebp),%eax
  801553:	01 d0                	add    %edx,%eax
  801555:	48                   	dec    %eax
  801556:	89 45 80             	mov    %eax,-0x80(%ebp)
  801559:	8b 45 80             	mov    -0x80(%ebp),%eax
  80155c:	ba 00 00 00 00       	mov    $0x0,%edx
  801561:	f7 75 84             	divl   -0x7c(%ebp)
  801564:	8b 45 80             	mov    -0x80(%ebp),%eax
  801567:	29 d0                	sub    %edx,%eax
  801569:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  80156c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801570:	74 09                	je     80157b <malloc+0x4b>
  801572:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801579:	76 0a                	jbe    801585 <malloc+0x55>
			return NULL;
  80157b:	b8 00 00 00 00       	mov    $0x0,%eax
  801580:	e9 4b 09 00 00       	jmp    801ed0 <malloc+0x9a0>
		}
		// first we can allocate by " Strategy Continues "
		if (ptr_uheap + size <= (uint32) USER_HEAP_MAX && !check) {
  801585:	8b 15 04 30 80 00    	mov    0x803004,%edx
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	01 d0                	add    %edx,%eax
  801590:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801595:	0f 87 a2 00 00 00    	ja     80163d <malloc+0x10d>
  80159b:	a1 40 30 98 00       	mov    0x983040,%eax
  8015a0:	85 c0                	test   %eax,%eax
  8015a2:	0f 85 95 00 00 00    	jne    80163d <malloc+0x10d>

			void* ret = (void *) ptr_uheap;
  8015a8:	a1 04 30 80 00       	mov    0x803004,%eax
  8015ad:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			sys_allocateMem(ptr_uheap, size);
  8015b3:	a1 04 30 80 00       	mov    0x803004,%eax
  8015b8:	83 ec 08             	sub    $0x8,%esp
  8015bb:	ff 75 08             	pushl  0x8(%ebp)
  8015be:	50                   	push   %eax
  8015bf:	e8 a3 0b 00 00       	call   802167 <sys_allocateMem>
  8015c4:	83 c4 10             	add    $0x10,%esp

			heap_size[cnt_mem].size = size;
  8015c7:	a1 20 30 80 00       	mov    0x803020,%eax
  8015cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8015cf:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8015d6:	a1 20 30 80 00       	mov    0x803020,%eax
  8015db:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8015e1:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
			cnt_mem++;
  8015e8:	a1 20 30 80 00       	mov    0x803020,%eax
  8015ed:	40                   	inc    %eax
  8015ee:	a3 20 30 80 00       	mov    %eax,0x803020
			int i = 0;
  8015f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  8015fa:	eb 2e                	jmp    80162a <malloc+0xfa>
			{

				heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8015fc:	a1 04 30 80 00       	mov    0x803004,%eax
  801601:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] = 1;
  801606:	c1 e8 0c             	shr    $0xc,%eax
  801609:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801610:	01 00 00 00 

				ptr_uheap += (uint32) PAGE_SIZE;
  801614:	a1 04 30 80 00       	mov    0x803004,%eax
  801619:	05 00 10 00 00       	add    $0x1000,%eax
  80161e:	a3 04 30 80 00       	mov    %eax,0x803004
			heap_size[cnt_mem].size = size;
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
			cnt_mem++;
			int i = 0;
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  801623:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  80162a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801630:	72 ca                	jb     8015fc <malloc+0xcc>
						/ (uint32) PAGE_SIZE)] = 1;

				ptr_uheap += (uint32) PAGE_SIZE;
			}

			return ret;
  801632:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  801638:	e9 93 08 00 00       	jmp    801ed0 <malloc+0x9a0>

		} else {
			// second we can allocate by " Strategy NEXTFIT "
			void* temp_end = NULL;
  80163d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

			int check_start = 0;
  801644:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			// check first that we used " Strategy Continues " before and not do it again and turn to NEXTFIT
			if (!check) {
  80164b:	a1 40 30 98 00       	mov    0x983040,%eax
  801650:	85 c0                	test   %eax,%eax
  801652:	75 1d                	jne    801671 <malloc+0x141>
				ptr_uheap = (uint32) USER_HEAP_START;
  801654:	c7 05 04 30 80 00 00 	movl   $0x80000000,0x803004
  80165b:	00 00 80 
				check = 1;
  80165e:	c7 05 40 30 98 00 01 	movl   $0x1,0x983040
  801665:	00 00 00 
				check_start = 1;// to dont use second loop CZ ptr_uheap start from USER_HEAP_START
  801668:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  80166f:	eb 08                	jmp    801679 <malloc+0x149>
			} else {
				temp_end = (void*) ptr_uheap;
  801671:	a1 04 30 80 00       	mov    0x803004,%eax
  801676:	89 45 f0             	mov    %eax,-0x10(%ebp)

			}

			uint32 sz = 0;
  801679:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
			int f = 0;
  801680:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			uint32 ptr = ptr_uheap;
  801687:	a1 04 30 80 00       	mov    0x803004,%eax
  80168c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  80168f:	eb 4d                	jmp    8016de <malloc+0x1ae>
				if (sz == size) {
  801691:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801694:	3b 45 08             	cmp    0x8(%ebp),%eax
  801697:	75 09                	jne    8016a2 <malloc+0x172>
					f = 1;
  801699:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  8016a0:	eb 45                	jmp    8016e7 <malloc+0x1b7>
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  8016a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016a5:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] == 0) {
  8016aa:	c1 e8 0c             	shr    $0xc,%eax
			while (ptr < (uint32) USER_HEAP_MAX) {
				if (sz == size) {
					f = 1;
					break;
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  8016ad:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  8016b4:	85 c0                	test   %eax,%eax
  8016b6:	75 10                	jne    8016c8 <malloc+0x198>
						/ (uint32) PAGE_SIZE)] == 0) {

					sz += PAGE_SIZE;
  8016b8:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
					ptr += PAGE_SIZE;
  8016bf:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  8016c6:	eb 16                	jmp    8016de <malloc+0x1ae>
				} else {
					sz = 0;
  8016c8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
					ptr += PAGE_SIZE;
  8016cf:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
					ptr_uheap = ptr;
  8016d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016d9:	a3 04 30 80 00       	mov    %eax,0x803004

			uint32 sz = 0;
			int f = 0;
			uint32 ptr = ptr_uheap;
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  8016de:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  8016e5:	76 aa                	jbe    801691 <malloc+0x161>
					ptr_uheap = ptr;
				}

			}

			if (f) {
  8016e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016eb:	0f 84 95 00 00 00    	je     801786 <malloc+0x256>

				void* ret = (void *) ptr_uheap;
  8016f1:	a1 04 30 80 00       	mov    0x803004,%eax
  8016f6:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

				sys_allocateMem(ptr_uheap, size);
  8016fc:	a1 04 30 80 00       	mov    0x803004,%eax
  801701:	83 ec 08             	sub    $0x8,%esp
  801704:	ff 75 08             	pushl  0x8(%ebp)
  801707:	50                   	push   %eax
  801708:	e8 5a 0a 00 00       	call   802167 <sys_allocateMem>
  80170d:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  801710:	a1 20 30 80 00       	mov    0x803020,%eax
  801715:	8b 55 08             	mov    0x8(%ebp),%edx
  801718:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
  80171f:	a1 20 30 80 00       	mov    0x803020,%eax
  801724:	8b 15 04 30 80 00    	mov    0x803004,%edx
  80172a:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
				cnt_mem++;
  801731:	a1 20 30 80 00       	mov    0x803020,%eax
  801736:	40                   	inc    %eax
  801737:	a3 20 30 80 00       	mov    %eax,0x803020
				int i = 0;
  80173c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801743:	eb 2e                	jmp    801773 <malloc+0x243>
				{

					heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801745:	a1 04 30 80 00       	mov    0x803004,%eax
  80174a:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  80174f:	c1 e8 0c             	shr    $0xc,%eax
  801752:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801759:	01 00 00 00 

					ptr_uheap += (uint32) PAGE_SIZE;
  80175d:	a1 04 30 80 00       	mov    0x803004,%eax
  801762:	05 00 10 00 00       	add    $0x1000,%eax
  801767:	a3 04 30 80 00       	mov    %eax,0x803004
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
				cnt_mem++;
				int i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  80176c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801773:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801776:	3b 45 08             	cmp    0x8(%ebp),%eax
  801779:	72 ca                	jb     801745 <malloc+0x215>
							/ (uint32) PAGE_SIZE)] = 1;

					ptr_uheap += (uint32) PAGE_SIZE;
				}

				return ret;
  80177b:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  801781:	e9 4a 07 00 00       	jmp    801ed0 <malloc+0x9a0>

			} else {

				if (check_start) {
  801786:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80178a:	74 0a                	je     801796 <malloc+0x266>

					return NULL;
  80178c:	b8 00 00 00 00       	mov    $0x0,%eax
  801791:	e9 3a 07 00 00       	jmp    801ed0 <malloc+0x9a0>
				}

//////////////back loop////////////////

				uint32 sz = 0;
  801796:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
				int f = 0;
  80179d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				uint32 ptr = USER_HEAP_START;
  8017a4:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
				ptr_uheap = USER_HEAP_START;
  8017ab:	c7 05 04 30 80 00 00 	movl   $0x80000000,0x803004
  8017b2:	00 00 80 
				while (ptr < (uint32) temp_end) {
  8017b5:	eb 4d                	jmp    801804 <malloc+0x2d4>
					if (sz == size) {
  8017b7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8017ba:	3b 45 08             	cmp    0x8(%ebp),%eax
  8017bd:	75 09                	jne    8017c8 <malloc+0x298>
						f = 1;
  8017bf:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
						break;
  8017c6:	eb 44                	jmp    80180c <malloc+0x2dc>
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  8017c8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8017cb:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] == 0) {
  8017d0:	c1 e8 0c             	shr    $0xc,%eax
				while (ptr < (uint32) temp_end) {
					if (sz == size) {
						f = 1;
						break;
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  8017d3:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  8017da:	85 c0                	test   %eax,%eax
  8017dc:	75 10                	jne    8017ee <malloc+0x2be>
							/ (uint32) PAGE_SIZE)] == 0) {

						sz += PAGE_SIZE;
  8017de:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
						ptr += PAGE_SIZE;
  8017e5:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
  8017ec:	eb 16                	jmp    801804 <malloc+0x2d4>
					} else {
						sz = 0;
  8017ee:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
						ptr += PAGE_SIZE;
  8017f5:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
						ptr_uheap = ptr;
  8017fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8017ff:	a3 04 30 80 00       	mov    %eax,0x803004

				uint32 sz = 0;
				int f = 0;
				uint32 ptr = USER_HEAP_START;
				ptr_uheap = USER_HEAP_START;
				while (ptr < (uint32) temp_end) {
  801804:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801807:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  80180a:	72 ab                	jb     8017b7 <malloc+0x287>
						ptr_uheap = ptr;
					}

				}

				if (f) {
  80180c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801810:	0f 84 95 00 00 00    	je     8018ab <malloc+0x37b>

					void* ret = (void *) ptr_uheap;
  801816:	a1 04 30 80 00       	mov    0x803004,%eax
  80181b:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

					sys_allocateMem(ptr_uheap, size);
  801821:	a1 04 30 80 00       	mov    0x803004,%eax
  801826:	83 ec 08             	sub    $0x8,%esp
  801829:	ff 75 08             	pushl  0x8(%ebp)
  80182c:	50                   	push   %eax
  80182d:	e8 35 09 00 00       	call   802167 <sys_allocateMem>
  801832:	83 c4 10             	add    $0x10,%esp

					heap_size[cnt_mem].size = size;
  801835:	a1 20 30 80 00       	mov    0x803020,%eax
  80183a:	8b 55 08             	mov    0x8(%ebp),%edx
  80183d:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801844:	a1 20 30 80 00       	mov    0x803020,%eax
  801849:	8b 15 04 30 80 00    	mov    0x803004,%edx
  80184f:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
					cnt_mem++;
  801856:	a1 20 30 80 00       	mov    0x803020,%eax
  80185b:	40                   	inc    %eax
  80185c:	a3 20 30 80 00       	mov    %eax,0x803020
					int i = 0;
  801861:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

					for (; i < size; i += PAGE_SIZE)
  801868:	eb 2e                	jmp    801898 <malloc+0x368>
					{

						heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  80186a:	a1 04 30 80 00       	mov    0x803004,%eax
  80186f:	05 00 00 00 80       	add    $0x80000000,%eax
								/ (uint32) PAGE_SIZE)] = 1;
  801874:	c1 e8 0c             	shr    $0xc,%eax
  801877:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  80187e:	01 00 00 00 

						ptr_uheap += (uint32) PAGE_SIZE;
  801882:	a1 04 30 80 00       	mov    0x803004,%eax
  801887:	05 00 10 00 00       	add    $0x1000,%eax
  80188c:	a3 04 30 80 00       	mov    %eax,0x803004
					heap_size[cnt_mem].size = size;
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
					cnt_mem++;
					int i = 0;

					for (; i < size; i += PAGE_SIZE)
  801891:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  801898:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80189b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80189e:	72 ca                	jb     80186a <malloc+0x33a>
								/ (uint32) PAGE_SIZE)] = 1;

						ptr_uheap += (uint32) PAGE_SIZE;
					}

					return ret;
  8018a0:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8018a6:	e9 25 06 00 00       	jmp    801ed0 <malloc+0x9a0>

				} else {

					return NULL;
  8018ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b0:	e9 1b 06 00 00       	jmp    801ed0 <malloc+0x9a0>

		}

	}

	else if (sys_isUHeapPlacementStrategyBESTFIT()) {
  8018b5:	e8 d0 0b 00 00       	call   80248a <sys_isUHeapPlacementStrategyBESTFIT>
  8018ba:	85 c0                	test   %eax,%eax
  8018bc:	0f 84 ba 01 00 00    	je     801a7c <malloc+0x54c>

		size = ROUNDUP(size, PAGE_SIZE);
  8018c2:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  8018c9:	10 00 00 
  8018cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8018cf:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8018d5:	01 d0                	add    %edx,%eax
  8018d7:	48                   	dec    %eax
  8018d8:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  8018de:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8018e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e9:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  8018ef:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8018f5:	29 d0                	sub    %edx,%eax
  8018f7:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  8018fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018fe:	74 09                	je     801909 <malloc+0x3d9>
  801900:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801907:	76 0a                	jbe    801913 <malloc+0x3e3>
			return NULL;
  801909:	b8 00 00 00 00       	mov    $0x0,%eax
  80190e:	e9 bd 05 00 00       	jmp    801ed0 <malloc+0x9a0>
		}
		uint32 ptr = (uint32) USER_HEAP_START;
  801913:	c7 45 c8 00 00 00 80 	movl   $0x80000000,-0x38(%ebp)
		uint32 temp = 0;
  80191a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		uint32 min_sz = size_uhmem + 1;
  801921:	c7 45 c0 01 00 02 00 	movl   $0x20001,-0x40(%ebp)
		uint32 count = 0;
  801928:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
		int i = 0;
  80192f:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801936:	8b 45 08             	mov    0x8(%ebp),%eax
  801939:	c1 e8 0c             	shr    $0xc,%eax
  80193c:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801942:	e9 80 00 00 00       	jmp    8019c7 <malloc+0x497>

			if (heap_mem[i] == 0) {
  801947:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80194a:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  801951:	85 c0                	test   %eax,%eax
  801953:	75 0c                	jne    801961 <malloc+0x431>

				count++;
  801955:	ff 45 bc             	incl   -0x44(%ebp)
				ptr += PAGE_SIZE;
  801958:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  80195f:	eb 2d                	jmp    80198e <malloc+0x45e>
			} else {
				if (num_p <= count && min_sz > count) {
  801961:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801967:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  80196a:	77 14                	ja     801980 <malloc+0x450>
  80196c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80196f:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801972:	76 0c                	jbe    801980 <malloc+0x450>

					min_sz = count;
  801974:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801977:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  80197a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80197d:	89 45 c4             	mov    %eax,-0x3c(%ebp)

				}
				count = 0;
  801980:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
				ptr += PAGE_SIZE;
  801987:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
			}

			if (i == size_uhmem - 1) {
  80198e:	81 7d b8 ff ff 01 00 	cmpl   $0x1ffff,-0x48(%ebp)
  801995:	75 2d                	jne    8019c4 <malloc+0x494>

				if (num_p <= count && min_sz > count) {
  801997:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80199d:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  8019a0:	77 22                	ja     8019c4 <malloc+0x494>
  8019a2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8019a5:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  8019a8:	76 1a                	jbe    8019c4 <malloc+0x494>

					min_sz = count;
  8019aa:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8019ad:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  8019b0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8019b3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
					count = 0;
  8019b6:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
					ptr += PAGE_SIZE;
  8019bd:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  8019c4:	ff 45 b8             	incl   -0x48(%ebp)
  8019c7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8019ca:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  8019cf:	0f 86 72 ff ff ff    	jbe    801947 <malloc+0x417>

			}

		}

		if (num_p > min_sz || temp == 0) {
  8019d5:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  8019db:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  8019de:	77 06                	ja     8019e6 <malloc+0x4b6>
  8019e0:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8019e4:	75 0a                	jne    8019f0 <malloc+0x4c0>
			return NULL;
  8019e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019eb:	e9 e0 04 00 00       	jmp    801ed0 <malloc+0x9a0>

		}

		temp = temp - (PAGE_SIZE * min_sz);
  8019f0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8019f3:	c1 e0 0c             	shl    $0xc,%eax
  8019f6:	29 45 c4             	sub    %eax,-0x3c(%ebp)
		void* ret = (void*) temp;
  8019f9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8019fc:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)

		sys_allocateMem(temp, size);
  801a02:	83 ec 08             	sub    $0x8,%esp
  801a05:	ff 75 08             	pushl  0x8(%ebp)
  801a08:	ff 75 c4             	pushl  -0x3c(%ebp)
  801a0b:	e8 57 07 00 00       	call   802167 <sys_allocateMem>
  801a10:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801a13:	a1 20 30 80 00       	mov    0x803020,%eax
  801a18:	8b 55 08             	mov    0x8(%ebp),%edx
  801a1b:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801a22:	a1 20 30 80 00       	mov    0x803020,%eax
  801a27:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801a2a:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
		cnt_mem++;
  801a31:	a1 20 30 80 00       	mov    0x803020,%eax
  801a36:	40                   	inc    %eax
  801a37:	a3 20 30 80 00       	mov    %eax,0x803020
		i = 0;
  801a3c:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801a43:	eb 24                	jmp    801a69 <malloc+0x539>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801a45:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801a48:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801a4d:	c1 e8 0c             	shr    $0xc,%eax
  801a50:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801a57:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801a5b:	81 45 c4 00 10 00 00 	addl   $0x1000,-0x3c(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801a62:	81 45 b8 00 10 00 00 	addl   $0x1000,-0x48(%ebp)
  801a69:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801a6c:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a6f:	72 d4                	jb     801a45 <malloc+0x515>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801a71:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801a77:	e9 54 04 00 00       	jmp    801ed0 <malloc+0x9a0>

	} else if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801a7c:	e8 d8 09 00 00       	call   802459 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a81:	85 c0                	test   %eax,%eax
  801a83:	0f 84 88 01 00 00    	je     801c11 <malloc+0x6e1>

		size = ROUNDUP(size, PAGE_SIZE);
  801a89:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  801a90:	10 00 00 
  801a93:	8b 55 08             	mov    0x8(%ebp),%edx
  801a96:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  801a9c:	01 d0                	add    %edx,%eax
  801a9e:	48                   	dec    %eax
  801a9f:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  801aa5:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801aab:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab0:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  801ab6:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801abc:	29 d0                	sub    %edx,%eax
  801abe:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801ac1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ac5:	74 09                	je     801ad0 <malloc+0x5a0>
  801ac7:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801ace:	76 0a                	jbe    801ada <malloc+0x5aa>
			return NULL;
  801ad0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad5:	e9 f6 03 00 00       	jmp    801ed0 <malloc+0x9a0>
		}

		uint32 ptr = (uint32) USER_HEAP_START;
  801ada:	c7 45 b4 00 00 00 80 	movl   $0x80000000,-0x4c(%ebp)
		uint32 temp = 0;
  801ae1:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
		uint32 found = 0;
  801ae8:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		uint32 count = 0;
  801aef:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
		int i = 0;
  801af6:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801afd:	8b 45 08             	mov    0x8(%ebp),%eax
  801b00:	c1 e8 0c             	shr    $0xc,%eax
  801b03:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

		for (; i < size_uhmem; i++) {
  801b09:	eb 5a                	jmp    801b65 <malloc+0x635>

			if (heap_mem[i] == 0) {
  801b0b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801b0e:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  801b15:	85 c0                	test   %eax,%eax
  801b17:	75 0c                	jne    801b25 <malloc+0x5f5>

				count++;
  801b19:	ff 45 a8             	incl   -0x58(%ebp)
				ptr += PAGE_SIZE;
  801b1c:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
  801b23:	eb 22                	jmp    801b47 <malloc+0x617>
			} else {
				if (num_p <= count) {
  801b25:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801b2b:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801b2e:	77 09                	ja     801b39 <malloc+0x609>

					found = 1;
  801b30:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)

					break;
  801b37:	eb 36                	jmp    801b6f <malloc+0x63f>
				}
				count = 0;
  801b39:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
				ptr += PAGE_SIZE;
  801b40:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
			}

			if (i == size_uhmem - 1) {
  801b47:	81 7d a4 ff ff 01 00 	cmpl   $0x1ffff,-0x5c(%ebp)
  801b4e:	75 12                	jne    801b62 <malloc+0x632>

				if (num_p <= count) {
  801b50:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801b56:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801b59:	77 07                	ja     801b62 <malloc+0x632>

					found = 1;
  801b5b:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
		uint32 found = 0;
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		for (; i < size_uhmem; i++) {
  801b62:	ff 45 a4             	incl   -0x5c(%ebp)
  801b65:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801b68:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801b6d:	76 9c                	jbe    801b0b <malloc+0x5db>

			}

		}

		if (!found) {
  801b6f:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  801b73:	75 0a                	jne    801b7f <malloc+0x64f>
			return NULL;
  801b75:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7a:	e9 51 03 00 00       	jmp    801ed0 <malloc+0x9a0>

		}

		temp = ptr;
  801b7f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801b82:	89 45 b0             	mov    %eax,-0x50(%ebp)
		temp = temp - (PAGE_SIZE * count);
  801b85:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801b88:	c1 e0 0c             	shl    $0xc,%eax
  801b8b:	29 45 b0             	sub    %eax,-0x50(%ebp)
		void* ret = (void*) temp;
  801b8e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801b91:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)

		sys_allocateMem(temp, size);
  801b97:	83 ec 08             	sub    $0x8,%esp
  801b9a:	ff 75 08             	pushl  0x8(%ebp)
  801b9d:	ff 75 b0             	pushl  -0x50(%ebp)
  801ba0:	e8 c2 05 00 00       	call   802167 <sys_allocateMem>
  801ba5:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801ba8:	a1 20 30 80 00       	mov    0x803020,%eax
  801bad:	8b 55 08             	mov    0x8(%ebp),%edx
  801bb0:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801bb7:	a1 20 30 80 00       	mov    0x803020,%eax
  801bbc:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801bbf:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
		cnt_mem++;
  801bc6:	a1 20 30 80 00       	mov    0x803020,%eax
  801bcb:	40                   	inc    %eax
  801bcc:	a3 20 30 80 00       	mov    %eax,0x803020
		i = 0;
  801bd1:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801bd8:	eb 24                	jmp    801bfe <malloc+0x6ce>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801bda:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801bdd:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801be2:	c1 e8 0c             	shr    $0xc,%eax
  801be5:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801bec:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801bf0:	81 45 b0 00 10 00 00 	addl   $0x1000,-0x50(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801bf7:	81 45 a4 00 10 00 00 	addl   $0x1000,-0x5c(%ebp)
  801bfe:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801c01:	3b 45 08             	cmp    0x8(%ebp),%eax
  801c04:	72 d4                	jb     801bda <malloc+0x6aa>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801c06:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  801c0c:	e9 bf 02 00 00       	jmp    801ed0 <malloc+0x9a0>

	}
	else if(sys_isUHeapPlacementStrategyWORSTFIT())
  801c11:	e8 d6 08 00 00       	call   8024ec <sys_isUHeapPlacementStrategyWORSTFIT>
  801c16:	85 c0                	test   %eax,%eax
  801c18:	0f 84 ba 01 00 00    	je     801dd8 <malloc+0x8a8>
	{
		size = ROUNDUP(size, PAGE_SIZE);
  801c1e:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  801c25:	10 00 00 
  801c28:	8b 55 08             	mov    0x8(%ebp),%edx
  801c2b:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  801c31:	01 d0                	add    %edx,%eax
  801c33:	48                   	dec    %eax
  801c34:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  801c3a:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  801c40:	ba 00 00 00 00       	mov    $0x0,%edx
  801c45:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  801c4b:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  801c51:	29 d0                	sub    %edx,%eax
  801c53:	89 45 08             	mov    %eax,0x8(%ebp)

				if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801c56:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c5a:	74 09                	je     801c65 <malloc+0x735>
  801c5c:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801c63:	76 0a                	jbe    801c6f <malloc+0x73f>
					return NULL;
  801c65:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6a:	e9 61 02 00 00       	jmp    801ed0 <malloc+0x9a0>
				}
				uint32 ptr = (uint32) USER_HEAP_START;
  801c6f:	c7 45 a0 00 00 00 80 	movl   $0x80000000,-0x60(%ebp)
				uint32 temp = 0;
  801c76:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
				uint32 max_sz = -1;
  801c7d:	c7 45 98 ff ff ff ff 	movl   $0xffffffff,-0x68(%ebp)
				uint32 count = 0;
  801c84:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
				int i = 0;
  801c8b:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				uint32 num_p = size / PAGE_SIZE;
  801c92:	8b 45 08             	mov    0x8(%ebp),%eax
  801c95:	c1 e8 0c             	shr    $0xc,%eax
  801c98:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  801c9e:	e9 80 00 00 00       	jmp    801d23 <malloc+0x7f3>

					if (heap_mem[i] == 0) {
  801ca3:	8b 45 90             	mov    -0x70(%ebp),%eax
  801ca6:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  801cad:	85 c0                	test   %eax,%eax
  801caf:	75 0c                	jne    801cbd <malloc+0x78d>

						count++;
  801cb1:	ff 45 94             	incl   -0x6c(%ebp)
						ptr += PAGE_SIZE;
  801cb4:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
  801cbb:	eb 2d                	jmp    801cea <malloc+0x7ba>
					} else {
						if (num_p <= count && max_sz < count) {
  801cbd:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801cc3:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801cc6:	77 14                	ja     801cdc <malloc+0x7ac>
  801cc8:	8b 45 98             	mov    -0x68(%ebp),%eax
  801ccb:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801cce:	73 0c                	jae    801cdc <malloc+0x7ac>

							max_sz = count;
  801cd0:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801cd3:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  801cd6:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801cd9:	89 45 9c             	mov    %eax,-0x64(%ebp)

						}
						count = 0;
  801cdc:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
						ptr += PAGE_SIZE;
  801ce3:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
					}

					if (i == size_uhmem - 1) {
  801cea:	81 7d 90 ff ff 01 00 	cmpl   $0x1ffff,-0x70(%ebp)
  801cf1:	75 2d                	jne    801d20 <malloc+0x7f0>

						if (num_p <= count && max_sz > count) {
  801cf3:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801cf9:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801cfc:	77 22                	ja     801d20 <malloc+0x7f0>
  801cfe:	8b 45 98             	mov    -0x68(%ebp),%eax
  801d01:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801d04:	76 1a                	jbe    801d20 <malloc+0x7f0>

							max_sz = count;
  801d06:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801d09:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  801d0c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801d0f:	89 45 9c             	mov    %eax,-0x64(%ebp)
							count = 0;
  801d12:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
							ptr += PAGE_SIZE;
  801d19:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
				uint32 count = 0;
				int i = 0;
				uint32 num_p = size / PAGE_SIZE;

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  801d20:	ff 45 90             	incl   -0x70(%ebp)
  801d23:	8b 45 90             	mov    -0x70(%ebp),%eax
  801d26:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801d2b:	0f 86 72 ff ff ff    	jbe    801ca3 <malloc+0x773>

					}

				}

				if (num_p > max_sz || temp == 0) {
  801d31:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801d37:	3b 45 98             	cmp    -0x68(%ebp),%eax
  801d3a:	77 06                	ja     801d42 <malloc+0x812>
  801d3c:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  801d40:	75 0a                	jne    801d4c <malloc+0x81c>
					return NULL;
  801d42:	b8 00 00 00 00       	mov    $0x0,%eax
  801d47:	e9 84 01 00 00       	jmp    801ed0 <malloc+0x9a0>

				}

				temp = temp - (PAGE_SIZE * max_sz);
  801d4c:	8b 45 98             	mov    -0x68(%ebp),%eax
  801d4f:	c1 e0 0c             	shl    $0xc,%eax
  801d52:	29 45 9c             	sub    %eax,-0x64(%ebp)
				void* ret = (void*) temp;
  801d55:	8b 45 9c             	mov    -0x64(%ebp),%eax
  801d58:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

				sys_allocateMem(temp, size);
  801d5e:	83 ec 08             	sub    $0x8,%esp
  801d61:	ff 75 08             	pushl  0x8(%ebp)
  801d64:	ff 75 9c             	pushl  -0x64(%ebp)
  801d67:	e8 fb 03 00 00       	call   802167 <sys_allocateMem>
  801d6c:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  801d6f:	a1 20 30 80 00       	mov    0x803020,%eax
  801d74:	8b 55 08             	mov    0x8(%ebp),%edx
  801d77:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) temp;
  801d7e:	a1 20 30 80 00       	mov    0x803020,%eax
  801d83:	8b 55 9c             	mov    -0x64(%ebp),%edx
  801d86:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
				cnt_mem++;
  801d8d:	a1 20 30 80 00       	mov    0x803020,%eax
  801d92:	40                   	inc    %eax
  801d93:	a3 20 30 80 00       	mov    %eax,0x803020
				i = 0;
  801d98:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801d9f:	eb 24                	jmp    801dc5 <malloc+0x895>
				{

					heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801da1:	8b 45 9c             	mov    -0x64(%ebp),%eax
  801da4:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  801da9:	c1 e8 0c             	shr    $0xc,%eax
  801dac:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801db3:	01 00 00 00 

					temp += (uint32) PAGE_SIZE;
  801db7:	81 45 9c 00 10 00 00 	addl   $0x1000,-0x64(%ebp)
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) temp;
				cnt_mem++;
				i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801dbe:	81 45 90 00 10 00 00 	addl   $0x1000,-0x70(%ebp)
  801dc5:	8b 45 90             	mov    -0x70(%ebp),%eax
  801dc8:	3b 45 08             	cmp    0x8(%ebp),%eax
  801dcb:	72 d4                	jb     801da1 <malloc+0x871>

					temp += (uint32) PAGE_SIZE;
				}

				//cprintf("\n size = %d.........vir= %d  \n",num_p,((uint32) ret-USER_HEAP_START)/PAGE_SIZE);
				return ret;
  801dcd:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  801dd3:	e9 f8 00 00 00       	jmp    801ed0 <malloc+0x9a0>

	}
// this is to make malloc is work
	void* ret = NULL;
  801dd8:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
	size = ROUNDUP(size, PAGE_SIZE);
  801ddf:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  801de6:	10 00 00 
  801de9:	8b 55 08             	mov    0x8(%ebp),%edx
  801dec:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  801df2:	01 d0                	add    %edx,%eax
  801df4:	48                   	dec    %eax
  801df5:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  801dfb:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  801e01:	ba 00 00 00 00       	mov    $0x0,%edx
  801e06:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  801e0c:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  801e12:	29 d0                	sub    %edx,%eax
  801e14:	89 45 08             	mov    %eax,0x8(%ebp)

	if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801e17:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e1b:	74 09                	je     801e26 <malloc+0x8f6>
  801e1d:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801e24:	76 0a                	jbe    801e30 <malloc+0x900>
		return NULL;
  801e26:	b8 00 00 00 00       	mov    $0x0,%eax
  801e2b:	e9 a0 00 00 00       	jmp    801ed0 <malloc+0x9a0>
	}

	if (ptr_uheap + size <= (uint32) USER_HEAP_MAX) {
  801e30:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801e36:	8b 45 08             	mov    0x8(%ebp),%eax
  801e39:	01 d0                	add    %edx,%eax
  801e3b:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801e40:	0f 87 87 00 00 00    	ja     801ecd <malloc+0x99d>

		ret = (void *) ptr_uheap;
  801e46:	a1 04 30 80 00       	mov    0x803004,%eax
  801e4b:	89 45 8c             	mov    %eax,-0x74(%ebp)
		sys_allocateMem(ptr_uheap, size);
  801e4e:	a1 04 30 80 00       	mov    0x803004,%eax
  801e53:	83 ec 08             	sub    $0x8,%esp
  801e56:	ff 75 08             	pushl  0x8(%ebp)
  801e59:	50                   	push   %eax
  801e5a:	e8 08 03 00 00       	call   802167 <sys_allocateMem>
  801e5f:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801e62:	a1 20 30 80 00       	mov    0x803020,%eax
  801e67:	8b 55 08             	mov    0x8(%ebp),%edx
  801e6a:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801e71:	a1 20 30 80 00       	mov    0x803020,%eax
  801e76:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801e7c:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
		cnt_mem++;
  801e83:	a1 20 30 80 00       	mov    0x803020,%eax
  801e88:	40                   	inc    %eax
  801e89:	a3 20 30 80 00       	mov    %eax,0x803020
		int i = 0;
  801e8e:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)

		for (; i < size; i += PAGE_SIZE)
  801e95:	eb 2e                	jmp    801ec5 <malloc+0x995>
		{

			heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801e97:	a1 04 30 80 00       	mov    0x803004,%eax
  801e9c:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801ea1:	c1 e8 0c             	shr    $0xc,%eax
  801ea4:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801eab:	01 00 00 00 

			ptr_uheap += (uint32) PAGE_SIZE;
  801eaf:	a1 04 30 80 00       	mov    0x803004,%eax
  801eb4:	05 00 10 00 00       	add    $0x1000,%eax
  801eb9:	a3 04 30 80 00       	mov    %eax,0x803004
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
		cnt_mem++;
		int i = 0;

		for (; i < size; i += PAGE_SIZE)
  801ebe:	81 45 88 00 10 00 00 	addl   $0x1000,-0x78(%ebp)
  801ec5:	8b 45 88             	mov    -0x78(%ebp),%eax
  801ec8:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ecb:	72 ca                	jb     801e97 <malloc+0x967>
					/ (uint32) PAGE_SIZE)] = 1;

			ptr_uheap += (uint32) PAGE_SIZE;
		}
	}
	return ret;
  801ecd:	8b 45 8c             	mov    -0x74(%ebp),%eax

	//TODO: [PROJECT 2016 - BONUS2] Apply FIRST FIT and WORST FIT policies

//return 0;

}
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <free>:
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address) {
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
  801ed5:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
  801ed8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; inx < cnt_mem; inx++) {
  801edf:	e9 c1 00 00 00       	jmp    801fa5 <free+0xd3>
		if (heap_size[inx].vir == virtual_address) {
  801ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee7:	8b 04 c5 40 30 88 00 	mov    0x883040(,%eax,8),%eax
  801eee:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ef1:	0f 85 ab 00 00 00    	jne    801fa2 <free+0xd0>

			if (heap_size[inx].size == 0) {
  801ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efa:	8b 04 c5 44 30 88 00 	mov    0x883044(,%eax,8),%eax
  801f01:	85 c0                	test   %eax,%eax
  801f03:	75 21                	jne    801f26 <free+0x54>
				heap_size[inx].size = 0;
  801f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f08:	c7 04 c5 44 30 88 00 	movl   $0x0,0x883044(,%eax,8)
  801f0f:	00 00 00 00 
				heap_size[inx].vir = NULL;
  801f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f16:	c7 04 c5 40 30 88 00 	movl   $0x0,0x883040(,%eax,8)
  801f1d:	00 00 00 00 
				return;
  801f21:	e9 8d 00 00 00       	jmp    801fb3 <free+0xe1>

			}

			sys_freeMem((uint32) virtual_address, heap_size[inx].size);
  801f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f29:	8b 14 c5 44 30 88 00 	mov    0x883044(,%eax,8),%edx
  801f30:	8b 45 08             	mov    0x8(%ebp),%eax
  801f33:	83 ec 08             	sub    $0x8,%esp
  801f36:	52                   	push   %edx
  801f37:	50                   	push   %eax
  801f38:	e8 0e 02 00 00       	call   80214b <sys_freeMem>
  801f3d:	83 c4 10             	add    $0x10,%esp

			int i = 0;
  801f40:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
  801f47:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4a:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  801f4d:	eb 24                	jmp    801f73 <free+0xa1>
			{
				heap_mem[(int) (((uint32) va - USER_HEAP_START) / PAGE_SIZE)] =
  801f4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f52:	05 00 00 00 80       	add    $0x80000000,%eax
  801f57:	c1 e8 0c             	shr    $0xc,%eax
  801f5a:	c7 04 85 40 30 80 00 	movl   $0x0,0x803040(,%eax,4)
  801f61:	00 00 00 00 
						0;

				va += PAGE_SIZE;
  801f65:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
			sys_freeMem((uint32) virtual_address, heap_size[inx].size);

			int i = 0;
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  801f6c:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f76:	8b 14 c5 44 30 88 00 	mov    0x883044(,%eax,8),%edx
  801f7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f80:	39 c2                	cmp    %eax,%edx
  801f82:	77 cb                	ja     801f4f <free+0x7d>

				va += PAGE_SIZE;

			}

			heap_size[inx].size = 0;
  801f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f87:	c7 04 c5 44 30 88 00 	movl   $0x0,0x883044(,%eax,8)
  801f8e:	00 00 00 00 
			heap_size[inx].vir = NULL;
  801f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f95:	c7 04 c5 40 30 88 00 	movl   $0x0,0x883040(,%eax,8)
  801f9c:	00 00 00 00 
			break;
  801fa0:	eb 11                	jmp    801fb3 <free+0xe1>
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
	for (; inx < cnt_mem; inx++) {
  801fa2:	ff 45 f4             	incl   -0xc(%ebp)
  801fa5:	a1 20 30 80 00       	mov    0x803020,%eax
  801faa:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801fad:	0f 8c 31 ff ff ff    	jl     801ee4 <free+0x12>
	}

	//get the size of the given allocation using its address
	//you need to call sys_freeMem()

}
  801fb3:	c9                   	leave  
  801fb4:	c3                   	ret    

00801fb5 <realloc>:
//  Hint: you may need to use the sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size) {
  801fb5:	55                   	push   %ebp
  801fb6:	89 e5                	mov    %esp,%ebp
  801fb8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2016 - BONUS4] realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801fbb:	83 ec 04             	sub    $0x4,%esp
  801fbe:	68 b0 2d 80 00       	push   $0x802db0
  801fc3:	68 1c 02 00 00       	push   $0x21c
  801fc8:	68 d6 2d 80 00       	push   $0x802dd6
  801fcd:	e8 b0 e6 ff ff       	call   800682 <_panic>

00801fd2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
  801fd5:	57                   	push   %edi
  801fd6:	56                   	push   %esi
  801fd7:	53                   	push   %ebx
  801fd8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fde:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fe4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fe7:	8b 7d 18             	mov    0x18(%ebp),%edi
  801fea:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801fed:	cd 30                	int    $0x30
  801fef:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ff2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ff5:	83 c4 10             	add    $0x10,%esp
  801ff8:	5b                   	pop    %ebx
  801ff9:	5e                   	pop    %esi
  801ffa:	5f                   	pop    %edi
  801ffb:	5d                   	pop    %ebp
  801ffc:	c3                   	ret    

00801ffd <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  802000:	8b 45 08             	mov    0x8(%ebp),%eax
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	ff 75 0c             	pushl  0xc(%ebp)
  80200c:	50                   	push   %eax
  80200d:	6a 00                	push   $0x0
  80200f:	e8 be ff ff ff       	call   801fd2 <syscall>
  802014:	83 c4 18             	add    $0x18,%esp
}
  802017:	90                   	nop
  802018:	c9                   	leave  
  802019:	c3                   	ret    

0080201a <sys_cgetc>:

int
sys_cgetc(void)
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 01                	push   $0x1
  802029:	e8 a4 ff ff ff       	call   801fd2 <syscall>
  80202e:	83 c4 18             	add    $0x18,%esp
}
  802031:	c9                   	leave  
  802032:	c3                   	ret    

00802033 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  802036:	8b 45 08             	mov    0x8(%ebp),%eax
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	50                   	push   %eax
  802042:	6a 03                	push   $0x3
  802044:	e8 89 ff ff ff       	call   801fd2 <syscall>
  802049:	83 c4 18             	add    $0x18,%esp
}
  80204c:	c9                   	leave  
  80204d:	c3                   	ret    

0080204e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 02                	push   $0x2
  80205d:	e8 70 ff ff ff       	call   801fd2 <syscall>
  802062:	83 c4 18             	add    $0x18,%esp
}
  802065:	c9                   	leave  
  802066:	c3                   	ret    

00802067 <sys_env_exit>:

void sys_env_exit(void)
{
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 04                	push   $0x4
  802076:	e8 57 ff ff ff       	call   801fd2 <syscall>
  80207b:	83 c4 18             	add    $0x18,%esp
}
  80207e:	90                   	nop
  80207f:	c9                   	leave  
  802080:	c3                   	ret    

00802081 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  802081:	55                   	push   %ebp
  802082:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802084:	8b 55 0c             	mov    0xc(%ebp),%edx
  802087:	8b 45 08             	mov    0x8(%ebp),%eax
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	52                   	push   %edx
  802091:	50                   	push   %eax
  802092:	6a 05                	push   $0x5
  802094:	e8 39 ff ff ff       	call   801fd2 <syscall>
  802099:	83 c4 18             	add    $0x18,%esp
}
  80209c:	c9                   	leave  
  80209d:	c3                   	ret    

0080209e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80209e:	55                   	push   %ebp
  80209f:	89 e5                	mov    %esp,%ebp
  8020a1:	56                   	push   %esi
  8020a2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020a3:	8b 75 18             	mov    0x18(%ebp),%esi
  8020a6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020a9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020af:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b2:	56                   	push   %esi
  8020b3:	53                   	push   %ebx
  8020b4:	51                   	push   %ecx
  8020b5:	52                   	push   %edx
  8020b6:	50                   	push   %eax
  8020b7:	6a 06                	push   $0x6
  8020b9:	e8 14 ff ff ff       	call   801fd2 <syscall>
  8020be:	83 c4 18             	add    $0x18,%esp
}
  8020c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020c4:	5b                   	pop    %ebx
  8020c5:	5e                   	pop    %esi
  8020c6:	5d                   	pop    %ebp
  8020c7:	c3                   	ret    

008020c8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8020c8:	55                   	push   %ebp
  8020c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8020cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	52                   	push   %edx
  8020d8:	50                   	push   %eax
  8020d9:	6a 07                	push   $0x7
  8020db:	e8 f2 fe ff ff       	call   801fd2 <syscall>
  8020e0:	83 c4 18             	add    $0x18,%esp
}
  8020e3:	c9                   	leave  
  8020e4:	c3                   	ret    

008020e5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8020e5:	55                   	push   %ebp
  8020e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 00                	push   $0x0
  8020ee:	ff 75 0c             	pushl  0xc(%ebp)
  8020f1:	ff 75 08             	pushl  0x8(%ebp)
  8020f4:	6a 08                	push   $0x8
  8020f6:	e8 d7 fe ff ff       	call   801fd2 <syscall>
  8020fb:	83 c4 18             	add    $0x18,%esp
}
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    

00802100 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802103:	6a 00                	push   $0x0
  802105:	6a 00                	push   $0x0
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 09                	push   $0x9
  80210f:	e8 be fe ff ff       	call   801fd2 <syscall>
  802114:	83 c4 18             	add    $0x18,%esp
}
  802117:	c9                   	leave  
  802118:	c3                   	ret    

00802119 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	6a 0a                	push   $0xa
  802128:	e8 a5 fe ff ff       	call   801fd2 <syscall>
  80212d:	83 c4 18             	add    $0x18,%esp
}
  802130:	c9                   	leave  
  802131:	c3                   	ret    

00802132 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802132:	55                   	push   %ebp
  802133:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802135:	6a 00                	push   $0x0
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	6a 00                	push   $0x0
  80213d:	6a 00                	push   $0x0
  80213f:	6a 0b                	push   $0xb
  802141:	e8 8c fe ff ff       	call   801fd2 <syscall>
  802146:	83 c4 18             	add    $0x18,%esp
}
  802149:	c9                   	leave  
  80214a:	c3                   	ret    

0080214b <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  80214b:	55                   	push   %ebp
  80214c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	ff 75 0c             	pushl  0xc(%ebp)
  802157:	ff 75 08             	pushl  0x8(%ebp)
  80215a:	6a 0d                	push   $0xd
  80215c:	e8 71 fe ff ff       	call   801fd2 <syscall>
  802161:	83 c4 18             	add    $0x18,%esp
	return;
  802164:	90                   	nop
}
  802165:	c9                   	leave  
  802166:	c3                   	ret    

00802167 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  802167:	55                   	push   %ebp
  802168:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  80216a:	6a 00                	push   $0x0
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	ff 75 0c             	pushl  0xc(%ebp)
  802173:	ff 75 08             	pushl  0x8(%ebp)
  802176:	6a 0e                	push   $0xe
  802178:	e8 55 fe ff ff       	call   801fd2 <syscall>
  80217d:	83 c4 18             	add    $0x18,%esp
	return ;
  802180:	90                   	nop
}
  802181:	c9                   	leave  
  802182:	c3                   	ret    

00802183 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802183:	55                   	push   %ebp
  802184:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	6a 0c                	push   $0xc
  802192:	e8 3b fe ff ff       	call   801fd2 <syscall>
  802197:	83 c4 18             	add    $0x18,%esp
}
  80219a:	c9                   	leave  
  80219b:	c3                   	ret    

0080219c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 10                	push   $0x10
  8021ab:	e8 22 fe ff ff       	call   801fd2 <syscall>
  8021b0:	83 c4 18             	add    $0x18,%esp
}
  8021b3:	90                   	nop
  8021b4:	c9                   	leave  
  8021b5:	c3                   	ret    

008021b6 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8021b6:	55                   	push   %ebp
  8021b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8021b9:	6a 00                	push   $0x0
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 11                	push   $0x11
  8021c5:	e8 08 fe ff ff       	call   801fd2 <syscall>
  8021ca:	83 c4 18             	add    $0x18,%esp
}
  8021cd:	90                   	nop
  8021ce:	c9                   	leave  
  8021cf:	c3                   	ret    

008021d0 <sys_cputc>:


void
sys_cputc(const char c)
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
  8021d3:	83 ec 04             	sub    $0x4,%esp
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8021dc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 00                	push   $0x0
  8021e8:	50                   	push   %eax
  8021e9:	6a 12                	push   $0x12
  8021eb:	e8 e2 fd ff ff       	call   801fd2 <syscall>
  8021f0:	83 c4 18             	add    $0x18,%esp
}
  8021f3:	90                   	nop
  8021f4:	c9                   	leave  
  8021f5:	c3                   	ret    

008021f6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 13                	push   $0x13
  802205:	e8 c8 fd ff ff       	call   801fd2 <syscall>
  80220a:	83 c4 18             	add    $0x18,%esp
}
  80220d:	90                   	nop
  80220e:	c9                   	leave  
  80220f:	c3                   	ret    

00802210 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802210:	55                   	push   %ebp
  802211:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802213:	8b 45 08             	mov    0x8(%ebp),%eax
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	ff 75 0c             	pushl  0xc(%ebp)
  80221f:	50                   	push   %eax
  802220:	6a 14                	push   $0x14
  802222:	e8 ab fd ff ff       	call   801fd2 <syscall>
  802227:	83 c4 18             	add    $0x18,%esp
}
  80222a:	c9                   	leave  
  80222b:	c3                   	ret    

0080222c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  80222f:	8b 45 08             	mov    0x8(%ebp),%eax
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	50                   	push   %eax
  80223b:	6a 17                	push   $0x17
  80223d:	e8 90 fd ff ff       	call   801fd2 <syscall>
  802242:	83 c4 18             	add    $0x18,%esp
}
  802245:	c9                   	leave  
  802246:	c3                   	ret    

00802247 <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  802247:	55                   	push   %ebp
  802248:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  80224a:	8b 45 08             	mov    0x8(%ebp),%eax
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	50                   	push   %eax
  802256:	6a 15                	push   $0x15
  802258:	e8 75 fd ff ff       	call   801fd2 <syscall>
  80225d:	83 c4 18             	add    $0x18,%esp
}
  802260:	90                   	nop
  802261:	c9                   	leave  
  802262:	c3                   	ret    

00802263 <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  802263:	55                   	push   %ebp
  802264:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  802266:	8b 45 08             	mov    0x8(%ebp),%eax
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	6a 00                	push   $0x0
  802271:	50                   	push   %eax
  802272:	6a 16                	push   $0x16
  802274:	e8 59 fd ff ff       	call   801fd2 <syscall>
  802279:	83 c4 18             	add    $0x18,%esp
}
  80227c:	90                   	nop
  80227d:	c9                   	leave  
  80227e:	c3                   	ret    

0080227f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  80227f:	55                   	push   %ebp
  802280:	89 e5                	mov    %esp,%ebp
  802282:	83 ec 04             	sub    $0x4,%esp
  802285:	8b 45 10             	mov    0x10(%ebp),%eax
  802288:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  80228b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80228e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802292:	8b 45 08             	mov    0x8(%ebp),%eax
  802295:	6a 00                	push   $0x0
  802297:	51                   	push   %ecx
  802298:	52                   	push   %edx
  802299:	ff 75 0c             	pushl  0xc(%ebp)
  80229c:	50                   	push   %eax
  80229d:	6a 18                	push   $0x18
  80229f:	e8 2e fd ff ff       	call   801fd2 <syscall>
  8022a4:	83 c4 18             	add    $0x18,%esp
}
  8022a7:	c9                   	leave  
  8022a8:	c3                   	ret    

008022a9 <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  8022ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022af:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	52                   	push   %edx
  8022b9:	50                   	push   %eax
  8022ba:	6a 19                	push   $0x19
  8022bc:	e8 11 fd ff ff       	call   801fd2 <syscall>
  8022c1:	83 c4 18             	add    $0x18,%esp
}
  8022c4:	c9                   	leave  
  8022c5:	c3                   	ret    

008022c6 <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  8022c6:	55                   	push   %ebp
  8022c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  8022c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	50                   	push   %eax
  8022d5:	6a 1a                	push   $0x1a
  8022d7:	e8 f6 fc ff ff       	call   801fd2 <syscall>
  8022dc:	83 c4 18             	add    $0x18,%esp
}
  8022df:	c9                   	leave  
  8022e0:	c3                   	ret    

008022e1 <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  8022e1:	55                   	push   %ebp
  8022e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 1b                	push   $0x1b
  8022f0:	e8 dd fc ff ff       	call   801fd2 <syscall>
  8022f5:	83 c4 18             	add    $0x18,%esp
}
  8022f8:	c9                   	leave  
  8022f9:	c3                   	ret    

008022fa <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8022fa:	55                   	push   %ebp
  8022fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8022fd:	6a 00                	push   $0x0
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	6a 00                	push   $0x0
  802305:	6a 00                	push   $0x0
  802307:	6a 1c                	push   $0x1c
  802309:	e8 c4 fc ff ff       	call   801fd2 <syscall>
  80230e:	83 c4 18             	add    $0x18,%esp
}
  802311:	c9                   	leave  
  802312:	c3                   	ret    

00802313 <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  802313:	55                   	push   %ebp
  802314:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  802316:	8b 45 08             	mov    0x8(%ebp),%eax
  802319:	6a 00                	push   $0x0
  80231b:	6a 00                	push   $0x0
  80231d:	6a 00                	push   $0x0
  80231f:	ff 75 0c             	pushl  0xc(%ebp)
  802322:	50                   	push   %eax
  802323:	6a 1d                	push   $0x1d
  802325:	e8 a8 fc ff ff       	call   801fd2 <syscall>
  80232a:	83 c4 18             	add    $0x18,%esp
}
  80232d:	c9                   	leave  
  80232e:	c3                   	ret    

0080232f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80232f:	55                   	push   %ebp
  802330:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802332:	8b 45 08             	mov    0x8(%ebp),%eax
  802335:	6a 00                	push   $0x0
  802337:	6a 00                	push   $0x0
  802339:	6a 00                	push   $0x0
  80233b:	6a 00                	push   $0x0
  80233d:	50                   	push   %eax
  80233e:	6a 1e                	push   $0x1e
  802340:	e8 8d fc ff ff       	call   801fd2 <syscall>
  802345:	83 c4 18             	add    $0x18,%esp
}
  802348:	90                   	nop
  802349:	c9                   	leave  
  80234a:	c3                   	ret    

0080234b <sys_free_env>:

void
sys_free_env(int32 envId)
{
  80234b:	55                   	push   %ebp
  80234c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  80234e:	8b 45 08             	mov    0x8(%ebp),%eax
  802351:	6a 00                	push   $0x0
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	6a 00                	push   $0x0
  802359:	50                   	push   %eax
  80235a:	6a 1f                	push   $0x1f
  80235c:	e8 71 fc ff ff       	call   801fd2 <syscall>
  802361:	83 c4 18             	add    $0x18,%esp
}
  802364:	90                   	nop
  802365:	c9                   	leave  
  802366:	c3                   	ret    

00802367 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  802367:	55                   	push   %ebp
  802368:	89 e5                	mov    %esp,%ebp
  80236a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80236d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802370:	8d 50 04             	lea    0x4(%eax),%edx
  802373:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802376:	6a 00                	push   $0x0
  802378:	6a 00                	push   $0x0
  80237a:	6a 00                	push   $0x0
  80237c:	52                   	push   %edx
  80237d:	50                   	push   %eax
  80237e:	6a 20                	push   $0x20
  802380:	e8 4d fc ff ff       	call   801fd2 <syscall>
  802385:	83 c4 18             	add    $0x18,%esp
	return result;
  802388:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80238b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80238e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802391:	89 01                	mov    %eax,(%ecx)
  802393:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802396:	8b 45 08             	mov    0x8(%ebp),%eax
  802399:	c9                   	leave  
  80239a:	c2 04 00             	ret    $0x4

0080239d <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80239d:	55                   	push   %ebp
  80239e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 00                	push   $0x0
  8023a4:	ff 75 10             	pushl  0x10(%ebp)
  8023a7:	ff 75 0c             	pushl  0xc(%ebp)
  8023aa:	ff 75 08             	pushl  0x8(%ebp)
  8023ad:	6a 0f                	push   $0xf
  8023af:	e8 1e fc ff ff       	call   801fd2 <syscall>
  8023b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8023b7:	90                   	nop
}
  8023b8:	c9                   	leave  
  8023b9:	c3                   	ret    

008023ba <sys_rcr2>:
uint32 sys_rcr2()
{
  8023ba:	55                   	push   %ebp
  8023bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 00                	push   $0x0
  8023c1:	6a 00                	push   $0x0
  8023c3:	6a 00                	push   $0x0
  8023c5:	6a 00                	push   $0x0
  8023c7:	6a 21                	push   $0x21
  8023c9:	e8 04 fc ff ff       	call   801fd2 <syscall>
  8023ce:	83 c4 18             	add    $0x18,%esp
}
  8023d1:	c9                   	leave  
  8023d2:	c3                   	ret    

008023d3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8023d3:	55                   	push   %ebp
  8023d4:	89 e5                	mov    %esp,%ebp
  8023d6:	83 ec 04             	sub    $0x4,%esp
  8023d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8023df:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 00                	push   $0x0
  8023e9:	6a 00                	push   $0x0
  8023eb:	50                   	push   %eax
  8023ec:	6a 22                	push   $0x22
  8023ee:	e8 df fb ff ff       	call   801fd2 <syscall>
  8023f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8023f6:	90                   	nop
}
  8023f7:	c9                   	leave  
  8023f8:	c3                   	ret    

008023f9 <rsttst>:
void rsttst()
{
  8023f9:	55                   	push   %ebp
  8023fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	6a 24                	push   $0x24
  802408:	e8 c5 fb ff ff       	call   801fd2 <syscall>
  80240d:	83 c4 18             	add    $0x18,%esp
	return ;
  802410:	90                   	nop
}
  802411:	c9                   	leave  
  802412:	c3                   	ret    

00802413 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802413:	55                   	push   %ebp
  802414:	89 e5                	mov    %esp,%ebp
  802416:	83 ec 04             	sub    $0x4,%esp
  802419:	8b 45 14             	mov    0x14(%ebp),%eax
  80241c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80241f:	8b 55 18             	mov    0x18(%ebp),%edx
  802422:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802426:	52                   	push   %edx
  802427:	50                   	push   %eax
  802428:	ff 75 10             	pushl  0x10(%ebp)
  80242b:	ff 75 0c             	pushl  0xc(%ebp)
  80242e:	ff 75 08             	pushl  0x8(%ebp)
  802431:	6a 23                	push   $0x23
  802433:	e8 9a fb ff ff       	call   801fd2 <syscall>
  802438:	83 c4 18             	add    $0x18,%esp
	return ;
  80243b:	90                   	nop
}
  80243c:	c9                   	leave  
  80243d:	c3                   	ret    

0080243e <chktst>:
void chktst(uint32 n)
{
  80243e:	55                   	push   %ebp
  80243f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802441:	6a 00                	push   $0x0
  802443:	6a 00                	push   $0x0
  802445:	6a 00                	push   $0x0
  802447:	6a 00                	push   $0x0
  802449:	ff 75 08             	pushl  0x8(%ebp)
  80244c:	6a 25                	push   $0x25
  80244e:	e8 7f fb ff ff       	call   801fd2 <syscall>
  802453:	83 c4 18             	add    $0x18,%esp
	return ;
  802456:	90                   	nop
}
  802457:	c9                   	leave  
  802458:	c3                   	ret    

00802459 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802459:	55                   	push   %ebp
  80245a:	89 e5                	mov    %esp,%ebp
  80245c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80245f:	6a 00                	push   $0x0
  802461:	6a 00                	push   $0x0
  802463:	6a 00                	push   $0x0
  802465:	6a 00                	push   $0x0
  802467:	6a 00                	push   $0x0
  802469:	6a 26                	push   $0x26
  80246b:	e8 62 fb ff ff       	call   801fd2 <syscall>
  802470:	83 c4 18             	add    $0x18,%esp
  802473:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802476:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80247a:	75 07                	jne    802483 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80247c:	b8 01 00 00 00       	mov    $0x1,%eax
  802481:	eb 05                	jmp    802488 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802483:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802488:	c9                   	leave  
  802489:	c3                   	ret    

0080248a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80248a:	55                   	push   %ebp
  80248b:	89 e5                	mov    %esp,%ebp
  80248d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802490:	6a 00                	push   $0x0
  802492:	6a 00                	push   $0x0
  802494:	6a 00                	push   $0x0
  802496:	6a 00                	push   $0x0
  802498:	6a 00                	push   $0x0
  80249a:	6a 26                	push   $0x26
  80249c:	e8 31 fb ff ff       	call   801fd2 <syscall>
  8024a1:	83 c4 18             	add    $0x18,%esp
  8024a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8024a7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8024ab:	75 07                	jne    8024b4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8024ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8024b2:	eb 05                	jmp    8024b9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8024b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024b9:	c9                   	leave  
  8024ba:	c3                   	ret    

008024bb <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8024bb:	55                   	push   %ebp
  8024bc:	89 e5                	mov    %esp,%ebp
  8024be:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024c1:	6a 00                	push   $0x0
  8024c3:	6a 00                	push   $0x0
  8024c5:	6a 00                	push   $0x0
  8024c7:	6a 00                	push   $0x0
  8024c9:	6a 00                	push   $0x0
  8024cb:	6a 26                	push   $0x26
  8024cd:	e8 00 fb ff ff       	call   801fd2 <syscall>
  8024d2:	83 c4 18             	add    $0x18,%esp
  8024d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8024d8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8024dc:	75 07                	jne    8024e5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8024de:	b8 01 00 00 00       	mov    $0x1,%eax
  8024e3:	eb 05                	jmp    8024ea <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8024e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ea:	c9                   	leave  
  8024eb:	c3                   	ret    

008024ec <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8024ec:	55                   	push   %ebp
  8024ed:	89 e5                	mov    %esp,%ebp
  8024ef:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024f2:	6a 00                	push   $0x0
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 00                	push   $0x0
  8024f8:	6a 00                	push   $0x0
  8024fa:	6a 00                	push   $0x0
  8024fc:	6a 26                	push   $0x26
  8024fe:	e8 cf fa ff ff       	call   801fd2 <syscall>
  802503:	83 c4 18             	add    $0x18,%esp
  802506:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802509:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80250d:	75 07                	jne    802516 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80250f:	b8 01 00 00 00       	mov    $0x1,%eax
  802514:	eb 05                	jmp    80251b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802516:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80251b:	c9                   	leave  
  80251c:	c3                   	ret    

0080251d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80251d:	55                   	push   %ebp
  80251e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802520:	6a 00                	push   $0x0
  802522:	6a 00                	push   $0x0
  802524:	6a 00                	push   $0x0
  802526:	6a 00                	push   $0x0
  802528:	ff 75 08             	pushl  0x8(%ebp)
  80252b:	6a 27                	push   $0x27
  80252d:	e8 a0 fa ff ff       	call   801fd2 <syscall>
  802532:	83 c4 18             	add    $0x18,%esp
	return ;
  802535:	90                   	nop
}
  802536:	c9                   	leave  
  802537:	c3                   	ret    

00802538 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802538:	55                   	push   %ebp
  802539:	89 e5                	mov    %esp,%ebp
  80253b:	83 ec 28             	sub    $0x28,%esp
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80253e:	8b 55 08             	mov    0x8(%ebp),%edx
  802541:	89 d0                	mov    %edx,%eax
  802543:	c1 e0 02             	shl    $0x2,%eax
  802546:	01 d0                	add    %edx,%eax
  802548:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80254f:	01 d0                	add    %edx,%eax
  802551:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802558:	01 d0                	add    %edx,%eax
  80255a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802561:	01 d0                	add    %edx,%eax
  802563:	c1 e0 04             	shl    $0x4,%eax
  802566:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802569:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  802570:	8d 45 e8             	lea    -0x18(%ebp),%eax
  802573:	83 ec 0c             	sub    $0xc,%esp
  802576:	50                   	push   %eax
  802577:	e8 eb fd ff ff       	call   802367 <sys_get_virtual_time>
  80257c:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80257f:	eb 41                	jmp    8025c2 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802581:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802584:	83 ec 0c             	sub    $0xc,%esp
  802587:	50                   	push   %eax
  802588:	e8 da fd ff ff       	call   802367 <sys_get_virtual_time>
  80258d:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802590:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802593:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802596:	29 c2                	sub    %eax,%edx
  802598:	89 d0                	mov    %edx,%eax
  80259a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80259d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a3:	89 d1                	mov    %edx,%ecx
  8025a5:	29 c1                	sub    %eax,%ecx
  8025a7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8025aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025ad:	39 c2                	cmp    %eax,%edx
  8025af:	0f 97 c0             	seta   %al
  8025b2:	0f b6 c0             	movzbl %al,%eax
  8025b5:	29 c1                	sub    %eax,%ecx
  8025b7:	89 c8                	mov    %ecx,%eax
  8025b9:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8025bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8025c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025c8:	72 b7                	jb     802581 <env_sleep+0x49>
//				,currentTime.hi, currentTime.low
//				,res.hi, res.low
//				,cycles_counter
//				);
	}
}
  8025ca:	90                   	nop
  8025cb:	c9                   	leave  
  8025cc:	c3                   	ret    
  8025cd:	66 90                	xchg   %ax,%ax
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
