
obj/user/tst_quicksort_freeHeap:     file format elf32-i386


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
  800031:	e8 e2 07 00 00       	call   800818 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 CheckSorted(int *Elements, int NumOfElements);

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv);

void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 44 01 00 00    	sub    $0x144,%esp
	int envID = sys_getenvid();
  800042:	e8 64 24 00 00       	call   8024ab <sys_getenvid>
  800047:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//	cprintf("envID = %d\n",envID);

	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  80004a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80004d:	89 d0                	mov    %edx,%eax
  80004f:	c1 e0 03             	shl    $0x3,%eax
  800052:	01 d0                	add    %edx,%eax
  800054:	01 c0                	add    %eax,%eax
  800056:	01 d0                	add    %edx,%eax
  800058:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80005f:	01 d0                	add    %edx,%eax
  800061:	c1 e0 03             	shl    $0x3,%eax
  800064:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800069:	89 45 ec             	mov    %eax,-0x14(%ebp)


	//int InitFreeFrames = sys_calculate_free_frames() ;
	char Line[255] ;
	char Chose ;
	int Iteration = 0 ;
  80006c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	do
	{

		Iteration++ ;
  800073:	ff 45 f4             	incl   -0xc(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

	sys_disable_interrupt();
  800076:	e8 7e 25 00 00       	call   8025f9 <sys_disable_interrupt>
		readline("Enter the number of elements: ", Line);
  80007b:	83 ec 08             	sub    $0x8,%esp
  80007e:	8d 85 c1 fe ff ff    	lea    -0x13f(%ebp),%eax
  800084:	50                   	push   %eax
  800085:	68 00 2c 80 00       	push   $0x802c00
  80008a:	e8 f0 0f 00 00       	call   80107f <readline>
  80008f:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  800092:	83 ec 04             	sub    $0x4,%esp
  800095:	6a 0a                	push   $0xa
  800097:	6a 00                	push   $0x0
  800099:	8d 85 c1 fe ff ff    	lea    -0x13f(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	e8 40 15 00 00       	call   8015e5 <strtol>
  8000a5:	83 c4 10             	add    $0x10,%esp
  8000a8:	89 45 e8             	mov    %eax,-0x18(%ebp)

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000ae:	c1 e0 02             	shl    $0x2,%eax
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	50                   	push   %eax
  8000b5:	e8 d3 18 00 00       	call   80198d <malloc>
  8000ba:	83 c4 10             	add    $0x10,%esp
  8000bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  8000c0:	83 ec 0c             	sub    $0xc,%esp
  8000c3:	ff 75 ec             	pushl  -0x14(%ebp)
  8000c6:	e8 1a 03 00 00       	call   8003e5 <CheckAndCountEmptyLocInWS>
  8000cb:	83 c4 10             	add    $0x10,%esp
  8000ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS ;
  8000d1:	e8 87 24 00 00       	call   80255d <sys_calculate_free_frames>
  8000d6:	89 c3                	mov    %eax,%ebx
  8000d8:	e8 99 24 00 00       	call   802576 <sys_calculate_modified_frames>
  8000dd:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8000e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000e3:	29 c2                	sub    %eax,%edx
  8000e5:	89 d0                	mov    %edx,%eax
  8000e7:	89 45 dc             	mov    %eax,-0x24(%ebp)

		Elements[NumOfElements] = 10 ;
  8000ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f7:	01 d0                	add    %edx,%eax
  8000f9:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
		//		cprintf("Free Frames After Allocation = %d\n", sys_calculate_free_frames()) ;
		cprintf("Choose the initialization method:\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 20 2c 80 00       	push   $0x802c20
  800107:	e8 f8 08 00 00       	call   800a04 <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 43 2c 80 00       	push   $0x802c43
  800117:	e8 e8 08 00 00       	call   800a04 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 51 2c 80 00       	push   $0x802c51
  800127:	e8 d8 08 00 00       	call   800a04 <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\nSelect: ") ;
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	68 60 2c 80 00       	push   $0x802c60
  800137:	e8 c8 08 00 00       	call   800a04 <cprintf>
  80013c:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  80013f:	e8 7c 06 00 00       	call   8007c0 <getchar>
  800144:	88 45 db             	mov    %al,-0x25(%ebp)
		cputchar(Chose);
  800147:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80014b:	83 ec 0c             	sub    $0xc,%esp
  80014e:	50                   	push   %eax
  80014f:	e8 24 06 00 00       	call   800778 <cputchar>
  800154:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	6a 0a                	push   $0xa
  80015c:	e8 17 06 00 00       	call   800778 <cputchar>
  800161:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800164:	e8 aa 24 00 00       	call   802613 <sys_enable_interrupt>
		int  i ;
		switch (Chose)
  800169:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80016d:	83 f8 62             	cmp    $0x62,%eax
  800170:	74 1d                	je     80018f <_main+0x157>
  800172:	83 f8 63             	cmp    $0x63,%eax
  800175:	74 2b                	je     8001a2 <_main+0x16a>
  800177:	83 f8 61             	cmp    $0x61,%eax
  80017a:	75 39                	jne    8001b5 <_main+0x17d>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80017c:	83 ec 08             	sub    $0x8,%esp
  80017f:	ff 75 e8             	pushl  -0x18(%ebp)
  800182:	ff 75 e4             	pushl  -0x1c(%ebp)
  800185:	e8 b6 04 00 00       	call   800640 <InitializeAscending>
  80018a:	83 c4 10             	add    $0x10,%esp
			break ;
  80018d:	eb 37                	jmp    8001c6 <_main+0x18e>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018f:	83 ec 08             	sub    $0x8,%esp
  800192:	ff 75 e8             	pushl  -0x18(%ebp)
  800195:	ff 75 e4             	pushl  -0x1c(%ebp)
  800198:	e8 d4 04 00 00       	call   800671 <InitializeDescending>
  80019d:	83 c4 10             	add    $0x10,%esp
			break ;
  8001a0:	eb 24                	jmp    8001c6 <_main+0x18e>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	ff 75 e8             	pushl  -0x18(%ebp)
  8001a8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ab:	e8 f6 04 00 00       	call   8006a6 <InitializeSemiRandom>
  8001b0:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b3:	eb 11                	jmp    8001c6 <_main+0x18e>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b5:	83 ec 08             	sub    $0x8,%esp
  8001b8:	ff 75 e8             	pushl  -0x18(%ebp)
  8001bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001be:	e8 e3 04 00 00       	call   8006a6 <InitializeSemiRandom>
  8001c3:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c6:	83 ec 08             	sub    $0x8,%esp
  8001c9:	ff 75 e8             	pushl  -0x18(%ebp)
  8001cc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001cf:	e8 b1 02 00 00       	call   800485 <QuickSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001d7:	83 ec 08             	sub    $0x8,%esp
  8001da:	ff 75 e8             	pushl  -0x18(%ebp)
  8001dd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001e0:	e8 b1 03 00 00       	call   800596 <CheckSorted>
  8001e5:	83 c4 10             	add    $0x10,%esp
  8001e8:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001eb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8001ef:	75 14                	jne    800205 <_main+0x1cd>
  8001f1:	83 ec 04             	sub    $0x4,%esp
  8001f4:	68 78 2c 80 00       	push   $0x802c78
  8001f9:	6a 53                	push   $0x53
  8001fb:	68 9a 2c 80 00       	push   $0x802c9a
  800200:	e8 d4 06 00 00       	call   8008d9 <_panic>
		else
		{ 
			cprintf("\n===============================================\n") ;
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 b8 2c 80 00       	push   $0x802cb8
  80020d:	e8 f2 07 00 00       	call   800a04 <cprintf>
  800212:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800215:	83 ec 0c             	sub    $0xc,%esp
  800218:	68 ec 2c 80 00       	push   $0x802cec
  80021d:	e8 e2 07 00 00       	call   800a04 <cprintf>
  800222:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800225:	83 ec 0c             	sub    $0xc,%esp
  800228:	68 20 2d 80 00       	push   $0x802d20
  80022d:	e8 d2 07 00 00       	call   800a04 <cprintf>
  800232:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  800235:	83 ec 0c             	sub    $0xc,%esp
  800238:	68 52 2d 80 00       	push   $0x802d52
  80023d:	e8 c2 07 00 00       	call   800a04 <cprintf>
  800242:	83 c4 10             	add    $0x10,%esp
		free(Elements) ;
  800245:	83 ec 0c             	sub    $0xc,%esp
  800248:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024b:	e8 df 20 00 00       	call   80232f <free>
  800250:	83 c4 10             	add    $0x10,%esp


		///Testing the freeHeap according to the specified scenario
		if (Iteration == 1 && NumOfElements == 1000 && Chose == 'a')
  800253:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  800257:	75 5b                	jne    8002b4 <_main+0x27c>
  800259:	81 7d e8 e8 03 00 00 	cmpl   $0x3e8,-0x18(%ebp)
  800260:	75 52                	jne    8002b4 <_main+0x27c>
  800262:	80 7d db 61          	cmpb   $0x61,-0x25(%ebp)
  800266:	75 4c                	jne    8002b4 <_main+0x27c>
		{
			numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	ff 75 ec             	pushl  -0x14(%ebp)
  80026e:	e8 72 01 00 00       	call   8003e5 <CheckAndCountEmptyLocInWS>
  800273:	83 c4 10             	add    $0x10,%esp
  800276:	89 45 e0             	mov    %eax,-0x20(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  800279:	e8 df 22 00 00       	call   80255d <sys_calculate_free_frames>
  80027e:	89 c3                	mov    %eax,%ebx
  800280:	e8 f1 22 00 00       	call   802576 <sys_calculate_modified_frames>
  800285:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  800288:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80028b:	29 c2                	sub    %eax,%edx
  80028d:	89 d0                	mov    %edx,%eax
  80028f:	89 45 d0             	mov    %eax,-0x30(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  800292:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800295:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800298:	0f 84 e7 00 00 00    	je     800385 <_main+0x34d>
  80029e:	68 68 2d 80 00       	push   $0x802d68
  8002a3:	68 8d 2d 80 00       	push   $0x802d8d
  8002a8:	6a 66                	push   $0x66
  8002aa:	68 9a 2c 80 00       	push   $0x802c9a
  8002af:	e8 25 06 00 00       	call   8008d9 <_panic>
		}
		else if (Iteration == 2 && NumOfElements == 5000 && Chose == 'b')
  8002b4:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
  8002b8:	75 5b                	jne    800315 <_main+0x2dd>
  8002ba:	81 7d e8 88 13 00 00 	cmpl   $0x1388,-0x18(%ebp)
  8002c1:	75 52                	jne    800315 <_main+0x2dd>
  8002c3:	80 7d db 62          	cmpb   $0x62,-0x25(%ebp)
  8002c7:	75 4c                	jne    800315 <_main+0x2dd>
		{
			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  8002c9:	83 ec 0c             	sub    $0xc,%esp
  8002cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8002cf:	e8 11 01 00 00       	call   8003e5 <CheckAndCountEmptyLocInWS>
  8002d4:	83 c4 10             	add    $0x10,%esp
  8002d7:	89 45 cc             	mov    %eax,-0x34(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  8002da:	e8 7e 22 00 00       	call   80255d <sys_calculate_free_frames>
  8002df:	89 c3                	mov    %eax,%ebx
  8002e1:	e8 90 22 00 00       	call   802576 <sys_calculate_modified_frames>
  8002e6:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8002e9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002ec:	29 c2                	sub    %eax,%edx
  8002ee:	89 d0                	mov    %edx,%eax
  8002f0:	89 45 c8             	mov    %eax,-0x38(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  8002f3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8002f6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002f9:	0f 84 89 00 00 00    	je     800388 <_main+0x350>
  8002ff:	68 68 2d 80 00       	push   $0x802d68
  800304:	68 8d 2d 80 00       	push   $0x802d8d
  800309:	6a 6c                	push   $0x6c
  80030b:	68 9a 2c 80 00       	push   $0x802c9a
  800310:	e8 c4 05 00 00       	call   8008d9 <_panic>
		}
		else if (Iteration == 3 && NumOfElements == 300000 && Chose == 'c')
  800315:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
  800319:	75 6e                	jne    800389 <_main+0x351>
  80031b:	81 7d e8 e0 93 04 00 	cmpl   $0x493e0,-0x18(%ebp)
  800322:	75 65                	jne    800389 <_main+0x351>
  800324:	80 7d db 63          	cmpb   $0x63,-0x25(%ebp)
  800328:	75 5f                	jne    800389 <_main+0x351>
		{
			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  80032a:	83 ec 0c             	sub    $0xc,%esp
  80032d:	ff 75 ec             	pushl  -0x14(%ebp)
  800330:	e8 b0 00 00 00       	call   8003e5 <CheckAndCountEmptyLocInWS>
  800335:	83 c4 10             	add    $0x10,%esp
  800338:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  80033b:	e8 1d 22 00 00       	call   80255d <sys_calculate_free_frames>
  800340:	89 c3                	mov    %eax,%ebx
  800342:	e8 2f 22 00 00       	call   802576 <sys_calculate_modified_frames>
  800347:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  80034a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80034d:	29 c2                	sub    %eax,%edx
  80034f:	89 d0                	mov    %edx,%eax
  800351:	89 45 c0             	mov    %eax,-0x40(%ebp)
			cprintf("numOFEmptyLocInWS = %d\n", numOFEmptyLocInWS );
  800354:	83 ec 08             	sub    $0x8,%esp
  800357:	ff 75 c4             	pushl  -0x3c(%ebp)
  80035a:	68 a2 2d 80 00       	push   $0x802da2
  80035f:	e8 a0 06 00 00       	call   800a04 <cprintf>
  800364:	83 c4 10             	add    $0x10,%esp
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  800367:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80036a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80036d:	74 1a                	je     800389 <_main+0x351>
  80036f:	68 68 2d 80 00       	push   $0x802d68
  800374:	68 8d 2d 80 00       	push   $0x802d8d
  800379:	6a 73                	push   $0x73
  80037b:	68 9a 2c 80 00       	push   $0x802c9a
  800380:	e8 54 05 00 00       	call   8008d9 <_panic>
		free(Elements) ;


		///Testing the freeHeap according to the specified scenario
		if (Iteration == 1 && NumOfElements == 1000 && Chose == 'a')
		{
  800385:	90                   	nop
  800386:	eb 01                	jmp    800389 <_main+0x351>
			numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
		}
		else if (Iteration == 2 && NumOfElements == 5000 && Chose == 'b')
		{
  800388:	90                   	nop
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
			cprintf("numOFEmptyLocInWS = %d\n", numOFEmptyLocInWS );
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
		}
		///========================================================================
	sys_disable_interrupt();
  800389:	e8 6b 22 00 00       	call   8025f9 <sys_disable_interrupt>
		cprintf("Do you want to repeat (y/n): ") ;
  80038e:	83 ec 0c             	sub    $0xc,%esp
  800391:	68 ba 2d 80 00       	push   $0x802dba
  800396:	e8 69 06 00 00       	call   800a04 <cprintf>
  80039b:	83 c4 10             	add    $0x10,%esp

		Chose = getchar() ;
  80039e:	e8 1d 04 00 00       	call   8007c0 <getchar>
  8003a3:	88 45 db             	mov    %al,-0x25(%ebp)
		cputchar(Chose);
  8003a6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8003aa:	83 ec 0c             	sub    $0xc,%esp
  8003ad:	50                   	push   %eax
  8003ae:	e8 c5 03 00 00       	call   800778 <cputchar>
  8003b3:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  8003b6:	83 ec 0c             	sub    $0xc,%esp
  8003b9:	6a 0a                	push   $0xa
  8003bb:	e8 b8 03 00 00       	call   800778 <cputchar>
  8003c0:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  8003c3:	83 ec 0c             	sub    $0xc,%esp
  8003c6:	6a 0a                	push   $0xa
  8003c8:	e8 ab 03 00 00       	call   800778 <cputchar>
  8003cd:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003d0:	e8 3e 22 00 00       	call   802613 <sys_enable_interrupt>

	} while (Chose == 'y');
  8003d5:	80 7d db 79          	cmpb   $0x79,-0x25(%ebp)
  8003d9:	0f 84 94 fc ff ff    	je     800073 <_main+0x3b>
}
  8003df:	90                   	nop
  8003e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003e3:	c9                   	leave  
  8003e4:	c3                   	ret    

008003e5 <CheckAndCountEmptyLocInWS>:

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv)
{
  8003e5:	55                   	push   %ebp
  8003e6:	89 e5                	mov    %esp,%ebp
  8003e8:	83 ec 18             	sub    $0x18,%esp
	int numOFEmptyLocInWS = 0, i;
  8003eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (i = 0 ; i < myEnv->page_WS_max_size; i++)
  8003f2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003f9:	eb 74                	jmp    80046f <CheckAndCountEmptyLocInWS+0x8a>
	{
		if (myEnv->__uptr_pws[i].empty)
  8003fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fe:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  800404:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800407:	89 d0                	mov    %edx,%eax
  800409:	01 c0                	add    %eax,%eax
  80040b:	01 d0                	add    %edx,%eax
  80040d:	c1 e0 02             	shl    $0x2,%eax
  800410:	01 c8                	add    %ecx,%eax
  800412:	8a 40 04             	mov    0x4(%eax),%al
  800415:	84 c0                	test   %al,%al
  800417:	74 05                	je     80041e <CheckAndCountEmptyLocInWS+0x39>
		{
			numOFEmptyLocInWS++;
  800419:	ff 45 f4             	incl   -0xc(%ebp)
  80041c:	eb 4e                	jmp    80046c <CheckAndCountEmptyLocInWS+0x87>
		}
		else
		{
			uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
  80041e:	8b 45 08             	mov    0x8(%ebp),%eax
  800421:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  800427:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80042a:	89 d0                	mov    %edx,%eax
  80042c:	01 c0                	add    %eax,%eax
  80042e:	01 d0                	add    %edx,%eax
  800430:	c1 e0 02             	shl    $0x2,%eax
  800433:	01 c8                	add    %ecx,%eax
  800435:	8b 00                	mov    (%eax),%eax
  800437:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80043a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80043d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800442:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (va >= USER_HEAP_START && va < (USER_HEAP_MAX))
  800445:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800448:	85 c0                	test   %eax,%eax
  80044a:	79 20                	jns    80046c <CheckAndCountEmptyLocInWS+0x87>
  80044c:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  800453:	77 17                	ja     80046c <CheckAndCountEmptyLocInWS+0x87>
				panic("freeMem didn't remove its page(s) from the WS");
  800455:	83 ec 04             	sub    $0x4,%esp
  800458:	68 d8 2d 80 00       	push   $0x802dd8
  80045d:	68 8f 00 00 00       	push   $0x8f
  800462:	68 9a 2c 80 00       	push   $0x802c9a
  800467:	e8 6d 04 00 00       	call   8008d9 <_panic>
}

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv)
{
	int numOFEmptyLocInWS = 0, i;
	for (i = 0 ; i < myEnv->page_WS_max_size; i++)
  80046c:	ff 45 f0             	incl   -0x10(%ebp)
  80046f:	8b 45 08             	mov    0x8(%ebp),%eax
  800472:	8b 50 74             	mov    0x74(%eax),%edx
  800475:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800478:	39 c2                	cmp    %eax,%edx
  80047a:	0f 87 7b ff ff ff    	ja     8003fb <CheckAndCountEmptyLocInWS+0x16>
			uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
			if (va >= USER_HEAP_START && va < (USER_HEAP_MAX))
				panic("freeMem didn't remove its page(s) from the WS");
		}
	}
	return numOFEmptyLocInWS;
  800480:	8b 45 f4             	mov    -0xc(%ebp),%eax

}
  800483:	c9                   	leave  
  800484:	c3                   	ret    

00800485 <QuickSort>:

///Quick sort 
void QuickSort(int *Elements, int NumOfElements)
{
  800485:	55                   	push   %ebp
  800486:	89 e5                	mov    %esp,%ebp
  800488:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  80048b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048e:	48                   	dec    %eax
  80048f:	50                   	push   %eax
  800490:	6a 00                	push   $0x0
  800492:	ff 75 0c             	pushl  0xc(%ebp)
  800495:	ff 75 08             	pushl  0x8(%ebp)
  800498:	e8 06 00 00 00       	call   8004a3 <QSort>
  80049d:	83 c4 10             	add    $0x10,%esp
}
  8004a0:	90                   	nop
  8004a1:	c9                   	leave  
  8004a2:	c3                   	ret    

008004a3 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8004a3:	55                   	push   %ebp
  8004a4:	89 e5                	mov    %esp,%ebp
  8004a6:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8004a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ac:	3b 45 14             	cmp    0x14(%ebp),%eax
  8004af:	0f 8d de 00 00 00    	jge    800593 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8004b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b8:	40                   	inc    %eax
  8004b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8004bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bf:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8004c2:	e9 80 00 00 00       	jmp    800547 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  8004c7:	ff 45 f4             	incl   -0xc(%ebp)
  8004ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004cd:	3b 45 14             	cmp    0x14(%ebp),%eax
  8004d0:	7f 2b                	jg     8004fd <QSort+0x5a>
  8004d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8004d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004df:	01 d0                	add    %edx,%eax
  8004e1:	8b 10                	mov    (%eax),%edx
  8004e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004e6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f0:	01 c8                	add    %ecx,%eax
  8004f2:	8b 00                	mov    (%eax),%eax
  8004f4:	39 c2                	cmp    %eax,%edx
  8004f6:	7d cf                	jge    8004c7 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8004f8:	eb 03                	jmp    8004fd <QSort+0x5a>
  8004fa:	ff 4d f0             	decl   -0x10(%ebp)
  8004fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800500:	3b 45 10             	cmp    0x10(%ebp),%eax
  800503:	7e 26                	jle    80052b <QSort+0x88>
  800505:	8b 45 10             	mov    0x10(%ebp),%eax
  800508:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80050f:	8b 45 08             	mov    0x8(%ebp),%eax
  800512:	01 d0                	add    %edx,%eax
  800514:	8b 10                	mov    (%eax),%edx
  800516:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800519:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800520:	8b 45 08             	mov    0x8(%ebp),%eax
  800523:	01 c8                	add    %ecx,%eax
  800525:	8b 00                	mov    (%eax),%eax
  800527:	39 c2                	cmp    %eax,%edx
  800529:	7e cf                	jle    8004fa <QSort+0x57>

		if (i <= j)
  80052b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80052e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800531:	7f 14                	jg     800547 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800533:	83 ec 04             	sub    $0x4,%esp
  800536:	ff 75 f0             	pushl  -0x10(%ebp)
  800539:	ff 75 f4             	pushl  -0xc(%ebp)
  80053c:	ff 75 08             	pushl  0x8(%ebp)
  80053f:	e8 a9 00 00 00       	call   8005ed <Swap>
  800544:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80054a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80054d:	0f 8e 77 ff ff ff    	jle    8004ca <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800553:	83 ec 04             	sub    $0x4,%esp
  800556:	ff 75 f0             	pushl  -0x10(%ebp)
  800559:	ff 75 10             	pushl  0x10(%ebp)
  80055c:	ff 75 08             	pushl  0x8(%ebp)
  80055f:	e8 89 00 00 00       	call   8005ed <Swap>
  800564:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800567:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80056a:	48                   	dec    %eax
  80056b:	50                   	push   %eax
  80056c:	ff 75 10             	pushl  0x10(%ebp)
  80056f:	ff 75 0c             	pushl  0xc(%ebp)
  800572:	ff 75 08             	pushl  0x8(%ebp)
  800575:	e8 29 ff ff ff       	call   8004a3 <QSort>
  80057a:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  80057d:	ff 75 14             	pushl  0x14(%ebp)
  800580:	ff 75 f4             	pushl  -0xc(%ebp)
  800583:	ff 75 0c             	pushl  0xc(%ebp)
  800586:	ff 75 08             	pushl  0x8(%ebp)
  800589:	e8 15 ff ff ff       	call   8004a3 <QSort>
  80058e:	83 c4 10             	add    $0x10,%esp
  800591:	eb 01                	jmp    800594 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  800593:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  800594:	c9                   	leave  
  800595:	c3                   	ret    

00800596 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  800596:	55                   	push   %ebp
  800597:	89 e5                	mov    %esp,%ebp
  800599:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  80059c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8005a3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8005aa:	eb 33                	jmp    8005df <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8005ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8005af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b9:	01 d0                	add    %edx,%eax
  8005bb:	8b 10                	mov    (%eax),%edx
  8005bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8005c0:	40                   	inc    %eax
  8005c1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cb:	01 c8                	add    %ecx,%eax
  8005cd:	8b 00                	mov    (%eax),%eax
  8005cf:	39 c2                	cmp    %eax,%edx
  8005d1:	7e 09                	jle    8005dc <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8005d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8005da:	eb 0c                	jmp    8005e8 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8005dc:	ff 45 f8             	incl   -0x8(%ebp)
  8005df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e2:	48                   	dec    %eax
  8005e3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8005e6:	7f c4                	jg     8005ac <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8005e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8005eb:	c9                   	leave  
  8005ec:	c3                   	ret    

008005ed <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  8005ed:	55                   	push   %ebp
  8005ee:	89 e5                	mov    %esp,%ebp
  8005f0:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8005f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800600:	01 d0                	add    %edx,%eax
  800602:	8b 00                	mov    (%eax),%eax
  800604:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800607:	8b 45 0c             	mov    0xc(%ebp),%eax
  80060a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800611:	8b 45 08             	mov    0x8(%ebp),%eax
  800614:	01 c2                	add    %eax,%edx
  800616:	8b 45 10             	mov    0x10(%ebp),%eax
  800619:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800620:	8b 45 08             	mov    0x8(%ebp),%eax
  800623:	01 c8                	add    %ecx,%eax
  800625:	8b 00                	mov    (%eax),%eax
  800627:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800629:	8b 45 10             	mov    0x10(%ebp),%eax
  80062c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800633:	8b 45 08             	mov    0x8(%ebp),%eax
  800636:	01 c2                	add    %eax,%edx
  800638:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80063b:	89 02                	mov    %eax,(%edx)
}
  80063d:	90                   	nop
  80063e:	c9                   	leave  
  80063f:	c3                   	ret    

00800640 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800640:	55                   	push   %ebp
  800641:	89 e5                	mov    %esp,%ebp
  800643:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800646:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80064d:	eb 17                	jmp    800666 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80064f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800652:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800659:	8b 45 08             	mov    0x8(%ebp),%eax
  80065c:	01 c2                	add    %eax,%edx
  80065e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800661:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800663:	ff 45 fc             	incl   -0x4(%ebp)
  800666:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800669:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80066c:	7c e1                	jl     80064f <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80066e:	90                   	nop
  80066f:	c9                   	leave  
  800670:	c3                   	ret    

00800671 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  800671:	55                   	push   %ebp
  800672:	89 e5                	mov    %esp,%ebp
  800674:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800677:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80067e:	eb 1b                	jmp    80069b <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800680:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800683:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80068a:	8b 45 08             	mov    0x8(%ebp),%eax
  80068d:	01 c2                	add    %eax,%edx
  80068f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800692:	2b 45 fc             	sub    -0x4(%ebp),%eax
  800695:	48                   	dec    %eax
  800696:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800698:	ff 45 fc             	incl   -0x4(%ebp)
  80069b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80069e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006a1:	7c dd                	jl     800680 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8006a3:	90                   	nop
  8006a4:	c9                   	leave  
  8006a5:	c3                   	ret    

008006a6 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8006a6:	55                   	push   %ebp
  8006a7:	89 e5                	mov    %esp,%ebp
  8006a9:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8006ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006af:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8006b4:	f7 e9                	imul   %ecx
  8006b6:	c1 f9 1f             	sar    $0x1f,%ecx
  8006b9:	89 d0                	mov    %edx,%eax
  8006bb:	29 c8                	sub    %ecx,%eax
  8006bd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8006c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8006c7:	eb 1e                	jmp    8006e7 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8006c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d6:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006dc:	99                   	cltd   
  8006dd:	f7 7d f8             	idivl  -0x8(%ebp)
  8006e0:	89 d0                	mov    %edx,%eax
  8006e2:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006e4:	ff 45 fc             	incl   -0x4(%ebp)
  8006e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006ed:	7c da                	jl     8006c9 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
	}

}
  8006ef:	90                   	nop
  8006f0:	c9                   	leave  
  8006f1:	c3                   	ret    

008006f2 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  8006f2:	55                   	push   %ebp
  8006f3:	89 e5                	mov    %esp,%ebp
  8006f5:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  8006f8:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8006ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800706:	eb 42                	jmp    80074a <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800708:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80070b:	99                   	cltd   
  80070c:	f7 7d f0             	idivl  -0x10(%ebp)
  80070f:	89 d0                	mov    %edx,%eax
  800711:	85 c0                	test   %eax,%eax
  800713:	75 10                	jne    800725 <PrintElements+0x33>
			cprintf("\n");
  800715:	83 ec 0c             	sub    $0xc,%esp
  800718:	68 06 2e 80 00       	push   $0x802e06
  80071d:	e8 e2 02 00 00       	call   800a04 <cprintf>
  800722:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800728:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80072f:	8b 45 08             	mov    0x8(%ebp),%eax
  800732:	01 d0                	add    %edx,%eax
  800734:	8b 00                	mov    (%eax),%eax
  800736:	83 ec 08             	sub    $0x8,%esp
  800739:	50                   	push   %eax
  80073a:	68 08 2e 80 00       	push   $0x802e08
  80073f:	e8 c0 02 00 00       	call   800a04 <cprintf>
  800744:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800747:	ff 45 f4             	incl   -0xc(%ebp)
  80074a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80074d:	48                   	dec    %eax
  80074e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800751:	7f b5                	jg     800708 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800756:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	01 d0                	add    %edx,%eax
  800762:	8b 00                	mov    (%eax),%eax
  800764:	83 ec 08             	sub    $0x8,%esp
  800767:	50                   	push   %eax
  800768:	68 0d 2e 80 00       	push   $0x802e0d
  80076d:	e8 92 02 00 00       	call   800a04 <cprintf>
  800772:	83 c4 10             	add    $0x10,%esp

}
  800775:	90                   	nop
  800776:	c9                   	leave  
  800777:	c3                   	ret    

00800778 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800778:	55                   	push   %ebp
  800779:	89 e5                	mov    %esp,%ebp
  80077b:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800784:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800788:	83 ec 0c             	sub    $0xc,%esp
  80078b:	50                   	push   %eax
  80078c:	e8 9c 1e 00 00       	call   80262d <sys_cputc>
  800791:	83 c4 10             	add    $0x10,%esp
}
  800794:	90                   	nop
  800795:	c9                   	leave  
  800796:	c3                   	ret    

00800797 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800797:	55                   	push   %ebp
  800798:	89 e5                	mov    %esp,%ebp
  80079a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80079d:	e8 57 1e 00 00       	call   8025f9 <sys_disable_interrupt>
	char c = ch;
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8007a8:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8007ac:	83 ec 0c             	sub    $0xc,%esp
  8007af:	50                   	push   %eax
  8007b0:	e8 78 1e 00 00       	call   80262d <sys_cputc>
  8007b5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8007b8:	e8 56 1e 00 00       	call   802613 <sys_enable_interrupt>
}
  8007bd:	90                   	nop
  8007be:	c9                   	leave  
  8007bf:	c3                   	ret    

008007c0 <getchar>:

int
getchar(void)
{
  8007c0:	55                   	push   %ebp
  8007c1:	89 e5                	mov    %esp,%ebp
  8007c3:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8007c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8007cd:	eb 08                	jmp    8007d7 <getchar+0x17>
	{
		c = sys_cgetc();
  8007cf:	e8 a3 1c 00 00       	call   802477 <sys_cgetc>
  8007d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  8007d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8007db:	74 f2                	je     8007cf <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  8007dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007e0:	c9                   	leave  
  8007e1:	c3                   	ret    

008007e2 <atomic_getchar>:

int
atomic_getchar(void)
{
  8007e2:	55                   	push   %ebp
  8007e3:	89 e5                	mov    %esp,%ebp
  8007e5:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007e8:	e8 0c 1e 00 00       	call   8025f9 <sys_disable_interrupt>
	int c=0;
  8007ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8007f4:	eb 08                	jmp    8007fe <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8007f6:	e8 7c 1c 00 00       	call   802477 <sys_cgetc>
  8007fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8007fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800802:	74 f2                	je     8007f6 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800804:	e8 0a 1e 00 00       	call   802613 <sys_enable_interrupt>
	return c;
  800809:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80080c:	c9                   	leave  
  80080d:	c3                   	ret    

0080080e <iscons>:

int iscons(int fdnum)
{
  80080e:	55                   	push   %ebp
  80080f:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800811:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800816:	5d                   	pop    %ebp
  800817:	c3                   	ret    

00800818 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800818:	55                   	push   %ebp
  800819:	89 e5                	mov    %esp,%ebp
  80081b:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80081e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800822:	7e 0a                	jle    80082e <libmain+0x16>
		binaryname = argv[0];
  800824:	8b 45 0c             	mov    0xc(%ebp),%eax
  800827:	8b 00                	mov    (%eax),%eax
  800829:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80082e:	83 ec 08             	sub    $0x8,%esp
  800831:	ff 75 0c             	pushl  0xc(%ebp)
  800834:	ff 75 08             	pushl  0x8(%ebp)
  800837:	e8 fc f7 ff ff       	call   800038 <_main>
  80083c:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  80083f:	e8 67 1c 00 00       	call   8024ab <sys_getenvid>
  800844:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  800847:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80084a:	89 d0                	mov    %edx,%eax
  80084c:	c1 e0 03             	shl    $0x3,%eax
  80084f:	01 d0                	add    %edx,%eax
  800851:	01 c0                	add    %eax,%eax
  800853:	01 d0                	add    %edx,%eax
  800855:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80085c:	01 d0                	add    %edx,%eax
  80085e:	c1 e0 03             	shl    $0x3,%eax
  800861:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800866:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  800869:	e8 8b 1d 00 00       	call   8025f9 <sys_disable_interrupt>
		cprintf("**************************************\n");
  80086e:	83 ec 0c             	sub    $0xc,%esp
  800871:	68 2c 2e 80 00       	push   $0x802e2c
  800876:	e8 89 01 00 00       	call   800a04 <cprintf>
  80087b:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  80087e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800881:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  800887:	83 ec 08             	sub    $0x8,%esp
  80088a:	50                   	push   %eax
  80088b:	68 54 2e 80 00       	push   $0x802e54
  800890:	e8 6f 01 00 00       	call   800a04 <cprintf>
  800895:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800898:	83 ec 0c             	sub    $0xc,%esp
  80089b:	68 2c 2e 80 00       	push   $0x802e2c
  8008a0:	e8 5f 01 00 00       	call   800a04 <cprintf>
  8008a5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008a8:	e8 66 1d 00 00       	call   802613 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008ad:	e8 19 00 00 00       	call   8008cb <exit>
}
  8008b2:	90                   	nop
  8008b3:	c9                   	leave  
  8008b4:	c3                   	ret    

008008b5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
  8008b8:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8008bb:	83 ec 0c             	sub    $0xc,%esp
  8008be:	6a 00                	push   $0x0
  8008c0:	e8 cb 1b 00 00       	call   802490 <sys_env_destroy>
  8008c5:	83 c4 10             	add    $0x10,%esp
}
  8008c8:	90                   	nop
  8008c9:	c9                   	leave  
  8008ca:	c3                   	ret    

008008cb <exit>:

void
exit(void)
{
  8008cb:	55                   	push   %ebp
  8008cc:	89 e5                	mov    %esp,%ebp
  8008ce:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8008d1:	e8 ee 1b 00 00       	call   8024c4 <sys_env_exit>
}
  8008d6:	90                   	nop
  8008d7:	c9                   	leave  
  8008d8:	c3                   	ret    

008008d9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008d9:	55                   	push   %ebp
  8008da:	89 e5                	mov    %esp,%ebp
  8008dc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008df:	8d 45 10             	lea    0x10(%ebp),%eax
  8008e2:	83 c0 04             	add    $0x4,%eax
  8008e5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  8008e8:	a1 70 40 98 00       	mov    0x984070,%eax
  8008ed:	85 c0                	test   %eax,%eax
  8008ef:	74 16                	je     800907 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008f1:	a1 70 40 98 00       	mov    0x984070,%eax
  8008f6:	83 ec 08             	sub    $0x8,%esp
  8008f9:	50                   	push   %eax
  8008fa:	68 6d 2e 80 00       	push   $0x802e6d
  8008ff:	e8 00 01 00 00       	call   800a04 <cprintf>
  800904:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800907:	a1 00 40 80 00       	mov    0x804000,%eax
  80090c:	ff 75 0c             	pushl  0xc(%ebp)
  80090f:	ff 75 08             	pushl  0x8(%ebp)
  800912:	50                   	push   %eax
  800913:	68 72 2e 80 00       	push   $0x802e72
  800918:	e8 e7 00 00 00       	call   800a04 <cprintf>
  80091d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800920:	8b 45 10             	mov    0x10(%ebp),%eax
  800923:	83 ec 08             	sub    $0x8,%esp
  800926:	ff 75 f4             	pushl  -0xc(%ebp)
  800929:	50                   	push   %eax
  80092a:	e8 7a 00 00 00       	call   8009a9 <vcprintf>
  80092f:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  800932:	83 ec 0c             	sub    $0xc,%esp
  800935:	68 8e 2e 80 00       	push   $0x802e8e
  80093a:	e8 c5 00 00 00       	call   800a04 <cprintf>
  80093f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800942:	e8 84 ff ff ff       	call   8008cb <exit>

	// should not return here
	while (1) ;
  800947:	eb fe                	jmp    800947 <_panic+0x6e>

00800949 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80094f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800952:	8b 00                	mov    (%eax),%eax
  800954:	8d 48 01             	lea    0x1(%eax),%ecx
  800957:	8b 55 0c             	mov    0xc(%ebp),%edx
  80095a:	89 0a                	mov    %ecx,(%edx)
  80095c:	8b 55 08             	mov    0x8(%ebp),%edx
  80095f:	88 d1                	mov    %dl,%cl
  800961:	8b 55 0c             	mov    0xc(%ebp),%edx
  800964:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800968:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096b:	8b 00                	mov    (%eax),%eax
  80096d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800972:	75 23                	jne    800997 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  800974:	8b 45 0c             	mov    0xc(%ebp),%eax
  800977:	8b 00                	mov    (%eax),%eax
  800979:	89 c2                	mov    %eax,%edx
  80097b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097e:	83 c0 08             	add    $0x8,%eax
  800981:	83 ec 08             	sub    $0x8,%esp
  800984:	52                   	push   %edx
  800985:	50                   	push   %eax
  800986:	e8 cf 1a 00 00       	call   80245a <sys_cputs>
  80098b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80098e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800991:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800997:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099a:	8b 40 04             	mov    0x4(%eax),%eax
  80099d:	8d 50 01             	lea    0x1(%eax),%edx
  8009a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009a6:	90                   	nop
  8009a7:	c9                   	leave  
  8009a8:	c3                   	ret    

008009a9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009a9:	55                   	push   %ebp
  8009aa:	89 e5                	mov    %esp,%ebp
  8009ac:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009b2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009b9:	00 00 00 
	b.cnt = 0;
  8009bc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009c3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009c6:	ff 75 0c             	pushl  0xc(%ebp)
  8009c9:	ff 75 08             	pushl  0x8(%ebp)
  8009cc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009d2:	50                   	push   %eax
  8009d3:	68 49 09 80 00       	push   $0x800949
  8009d8:	e8 fa 01 00 00       	call   800bd7 <vprintfmt>
  8009dd:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  8009e0:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8009e6:	83 ec 08             	sub    $0x8,%esp
  8009e9:	50                   	push   %eax
  8009ea:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009f0:	83 c0 08             	add    $0x8,%eax
  8009f3:	50                   	push   %eax
  8009f4:	e8 61 1a 00 00       	call   80245a <sys_cputs>
  8009f9:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  8009fc:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a02:	c9                   	leave  
  800a03:	c3                   	ret    

00800a04 <cprintf>:

int cprintf(const char *fmt, ...) {
  800a04:	55                   	push   %ebp
  800a05:	89 e5                	mov    %esp,%ebp
  800a07:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a0a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	ff 75 f4             	pushl  -0xc(%ebp)
  800a19:	50                   	push   %eax
  800a1a:	e8 8a ff ff ff       	call   8009a9 <vcprintf>
  800a1f:	83 c4 10             	add    $0x10,%esp
  800a22:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a25:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a28:	c9                   	leave  
  800a29:	c3                   	ret    

00800a2a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a2a:	55                   	push   %ebp
  800a2b:	89 e5                	mov    %esp,%ebp
  800a2d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a30:	e8 c4 1b 00 00       	call   8025f9 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a35:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a38:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3e:	83 ec 08             	sub    $0x8,%esp
  800a41:	ff 75 f4             	pushl  -0xc(%ebp)
  800a44:	50                   	push   %eax
  800a45:	e8 5f ff ff ff       	call   8009a9 <vcprintf>
  800a4a:	83 c4 10             	add    $0x10,%esp
  800a4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a50:	e8 be 1b 00 00       	call   802613 <sys_enable_interrupt>
	return cnt;
  800a55:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a58:	c9                   	leave  
  800a59:	c3                   	ret    

00800a5a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
  800a5d:	53                   	push   %ebx
  800a5e:	83 ec 14             	sub    $0x14,%esp
  800a61:	8b 45 10             	mov    0x10(%ebp),%eax
  800a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a67:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a6d:	8b 45 18             	mov    0x18(%ebp),%eax
  800a70:	ba 00 00 00 00       	mov    $0x0,%edx
  800a75:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a78:	77 55                	ja     800acf <printnum+0x75>
  800a7a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a7d:	72 05                	jb     800a84 <printnum+0x2a>
  800a7f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a82:	77 4b                	ja     800acf <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a84:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a87:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a8a:	8b 45 18             	mov    0x18(%ebp),%eax
  800a8d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a92:	52                   	push   %edx
  800a93:	50                   	push   %eax
  800a94:	ff 75 f4             	pushl  -0xc(%ebp)
  800a97:	ff 75 f0             	pushl  -0x10(%ebp)
  800a9a:	e8 f9 1e 00 00       	call   802998 <__udivdi3>
  800a9f:	83 c4 10             	add    $0x10,%esp
  800aa2:	83 ec 04             	sub    $0x4,%esp
  800aa5:	ff 75 20             	pushl  0x20(%ebp)
  800aa8:	53                   	push   %ebx
  800aa9:	ff 75 18             	pushl  0x18(%ebp)
  800aac:	52                   	push   %edx
  800aad:	50                   	push   %eax
  800aae:	ff 75 0c             	pushl  0xc(%ebp)
  800ab1:	ff 75 08             	pushl  0x8(%ebp)
  800ab4:	e8 a1 ff ff ff       	call   800a5a <printnum>
  800ab9:	83 c4 20             	add    $0x20,%esp
  800abc:	eb 1a                	jmp    800ad8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800abe:	83 ec 08             	sub    $0x8,%esp
  800ac1:	ff 75 0c             	pushl  0xc(%ebp)
  800ac4:	ff 75 20             	pushl  0x20(%ebp)
  800ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aca:	ff d0                	call   *%eax
  800acc:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800acf:	ff 4d 1c             	decl   0x1c(%ebp)
  800ad2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ad6:	7f e6                	jg     800abe <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ad8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800adb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ae3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ae6:	53                   	push   %ebx
  800ae7:	51                   	push   %ecx
  800ae8:	52                   	push   %edx
  800ae9:	50                   	push   %eax
  800aea:	e8 b9 1f 00 00       	call   802aa8 <__umoddi3>
  800aef:	83 c4 10             	add    $0x10,%esp
  800af2:	05 b4 30 80 00       	add    $0x8030b4,%eax
  800af7:	8a 00                	mov    (%eax),%al
  800af9:	0f be c0             	movsbl %al,%eax
  800afc:	83 ec 08             	sub    $0x8,%esp
  800aff:	ff 75 0c             	pushl  0xc(%ebp)
  800b02:	50                   	push   %eax
  800b03:	8b 45 08             	mov    0x8(%ebp),%eax
  800b06:	ff d0                	call   *%eax
  800b08:	83 c4 10             	add    $0x10,%esp
}
  800b0b:	90                   	nop
  800b0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b0f:	c9                   	leave  
  800b10:	c3                   	ret    

00800b11 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b11:	55                   	push   %ebp
  800b12:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b14:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b18:	7e 1c                	jle    800b36 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	8b 00                	mov    (%eax),%eax
  800b1f:	8d 50 08             	lea    0x8(%eax),%edx
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	89 10                	mov    %edx,(%eax)
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	8b 00                	mov    (%eax),%eax
  800b2c:	83 e8 08             	sub    $0x8,%eax
  800b2f:	8b 50 04             	mov    0x4(%eax),%edx
  800b32:	8b 00                	mov    (%eax),%eax
  800b34:	eb 40                	jmp    800b76 <getuint+0x65>
	else if (lflag)
  800b36:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b3a:	74 1e                	je     800b5a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	8b 00                	mov    (%eax),%eax
  800b41:	8d 50 04             	lea    0x4(%eax),%edx
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	89 10                	mov    %edx,(%eax)
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	8b 00                	mov    (%eax),%eax
  800b4e:	83 e8 04             	sub    $0x4,%eax
  800b51:	8b 00                	mov    (%eax),%eax
  800b53:	ba 00 00 00 00       	mov    $0x0,%edx
  800b58:	eb 1c                	jmp    800b76 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5d:	8b 00                	mov    (%eax),%eax
  800b5f:	8d 50 04             	lea    0x4(%eax),%edx
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	89 10                	mov    %edx,(%eax)
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	8b 00                	mov    (%eax),%eax
  800b6c:	83 e8 04             	sub    $0x4,%eax
  800b6f:	8b 00                	mov    (%eax),%eax
  800b71:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b76:	5d                   	pop    %ebp
  800b77:	c3                   	ret    

00800b78 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b78:	55                   	push   %ebp
  800b79:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b7b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b7f:	7e 1c                	jle    800b9d <getint+0x25>
		return va_arg(*ap, long long);
  800b81:	8b 45 08             	mov    0x8(%ebp),%eax
  800b84:	8b 00                	mov    (%eax),%eax
  800b86:	8d 50 08             	lea    0x8(%eax),%edx
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	89 10                	mov    %edx,(%eax)
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	8b 00                	mov    (%eax),%eax
  800b93:	83 e8 08             	sub    $0x8,%eax
  800b96:	8b 50 04             	mov    0x4(%eax),%edx
  800b99:	8b 00                	mov    (%eax),%eax
  800b9b:	eb 38                	jmp    800bd5 <getint+0x5d>
	else if (lflag)
  800b9d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ba1:	74 1a                	je     800bbd <getint+0x45>
		return va_arg(*ap, long);
  800ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba6:	8b 00                	mov    (%eax),%eax
  800ba8:	8d 50 04             	lea    0x4(%eax),%edx
  800bab:	8b 45 08             	mov    0x8(%ebp),%eax
  800bae:	89 10                	mov    %edx,(%eax)
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	8b 00                	mov    (%eax),%eax
  800bb5:	83 e8 04             	sub    $0x4,%eax
  800bb8:	8b 00                	mov    (%eax),%eax
  800bba:	99                   	cltd   
  800bbb:	eb 18                	jmp    800bd5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc0:	8b 00                	mov    (%eax),%eax
  800bc2:	8d 50 04             	lea    0x4(%eax),%edx
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	89 10                	mov    %edx,(%eax)
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	8b 00                	mov    (%eax),%eax
  800bcf:	83 e8 04             	sub    $0x4,%eax
  800bd2:	8b 00                	mov    (%eax),%eax
  800bd4:	99                   	cltd   
}
  800bd5:	5d                   	pop    %ebp
  800bd6:	c3                   	ret    

00800bd7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
  800bda:	56                   	push   %esi
  800bdb:	53                   	push   %ebx
  800bdc:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bdf:	eb 17                	jmp    800bf8 <vprintfmt+0x21>
			if (ch == '\0')
  800be1:	85 db                	test   %ebx,%ebx
  800be3:	0f 84 af 03 00 00    	je     800f98 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800be9:	83 ec 08             	sub    $0x8,%esp
  800bec:	ff 75 0c             	pushl  0xc(%ebp)
  800bef:	53                   	push   %ebx
  800bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf3:	ff d0                	call   *%eax
  800bf5:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bf8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfb:	8d 50 01             	lea    0x1(%eax),%edx
  800bfe:	89 55 10             	mov    %edx,0x10(%ebp)
  800c01:	8a 00                	mov    (%eax),%al
  800c03:	0f b6 d8             	movzbl %al,%ebx
  800c06:	83 fb 25             	cmp    $0x25,%ebx
  800c09:	75 d6                	jne    800be1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c0b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c0f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c16:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c1d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c24:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c2e:	8d 50 01             	lea    0x1(%eax),%edx
  800c31:	89 55 10             	mov    %edx,0x10(%ebp)
  800c34:	8a 00                	mov    (%eax),%al
  800c36:	0f b6 d8             	movzbl %al,%ebx
  800c39:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c3c:	83 f8 55             	cmp    $0x55,%eax
  800c3f:	0f 87 2b 03 00 00    	ja     800f70 <vprintfmt+0x399>
  800c45:	8b 04 85 d8 30 80 00 	mov    0x8030d8(,%eax,4),%eax
  800c4c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c4e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c52:	eb d7                	jmp    800c2b <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c54:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c58:	eb d1                	jmp    800c2b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c5a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c61:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c64:	89 d0                	mov    %edx,%eax
  800c66:	c1 e0 02             	shl    $0x2,%eax
  800c69:	01 d0                	add    %edx,%eax
  800c6b:	01 c0                	add    %eax,%eax
  800c6d:	01 d8                	add    %ebx,%eax
  800c6f:	83 e8 30             	sub    $0x30,%eax
  800c72:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c75:	8b 45 10             	mov    0x10(%ebp),%eax
  800c78:	8a 00                	mov    (%eax),%al
  800c7a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c7d:	83 fb 2f             	cmp    $0x2f,%ebx
  800c80:	7e 3e                	jle    800cc0 <vprintfmt+0xe9>
  800c82:	83 fb 39             	cmp    $0x39,%ebx
  800c85:	7f 39                	jg     800cc0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c87:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c8a:	eb d5                	jmp    800c61 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c8c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c8f:	83 c0 04             	add    $0x4,%eax
  800c92:	89 45 14             	mov    %eax,0x14(%ebp)
  800c95:	8b 45 14             	mov    0x14(%ebp),%eax
  800c98:	83 e8 04             	sub    $0x4,%eax
  800c9b:	8b 00                	mov    (%eax),%eax
  800c9d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ca0:	eb 1f                	jmp    800cc1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ca2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ca6:	79 83                	jns    800c2b <vprintfmt+0x54>
				width = 0;
  800ca8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800caf:	e9 77 ff ff ff       	jmp    800c2b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800cb4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800cbb:	e9 6b ff ff ff       	jmp    800c2b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cc0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cc1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cc5:	0f 89 60 ff ff ff    	jns    800c2b <vprintfmt+0x54>
				width = precision, precision = -1;
  800ccb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cd1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800cd8:	e9 4e ff ff ff       	jmp    800c2b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800cdd:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ce0:	e9 46 ff ff ff       	jmp    800c2b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ce5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce8:	83 c0 04             	add    $0x4,%eax
  800ceb:	89 45 14             	mov    %eax,0x14(%ebp)
  800cee:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf1:	83 e8 04             	sub    $0x4,%eax
  800cf4:	8b 00                	mov    (%eax),%eax
  800cf6:	83 ec 08             	sub    $0x8,%esp
  800cf9:	ff 75 0c             	pushl  0xc(%ebp)
  800cfc:	50                   	push   %eax
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	ff d0                	call   *%eax
  800d02:	83 c4 10             	add    $0x10,%esp
			break;
  800d05:	e9 89 02 00 00       	jmp    800f93 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d0a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d0d:	83 c0 04             	add    $0x4,%eax
  800d10:	89 45 14             	mov    %eax,0x14(%ebp)
  800d13:	8b 45 14             	mov    0x14(%ebp),%eax
  800d16:	83 e8 04             	sub    $0x4,%eax
  800d19:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d1b:	85 db                	test   %ebx,%ebx
  800d1d:	79 02                	jns    800d21 <vprintfmt+0x14a>
				err = -err;
  800d1f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d21:	83 fb 64             	cmp    $0x64,%ebx
  800d24:	7f 0b                	jg     800d31 <vprintfmt+0x15a>
  800d26:	8b 34 9d 20 2f 80 00 	mov    0x802f20(,%ebx,4),%esi
  800d2d:	85 f6                	test   %esi,%esi
  800d2f:	75 19                	jne    800d4a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d31:	53                   	push   %ebx
  800d32:	68 c5 30 80 00       	push   $0x8030c5
  800d37:	ff 75 0c             	pushl  0xc(%ebp)
  800d3a:	ff 75 08             	pushl  0x8(%ebp)
  800d3d:	e8 5e 02 00 00       	call   800fa0 <printfmt>
  800d42:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d45:	e9 49 02 00 00       	jmp    800f93 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d4a:	56                   	push   %esi
  800d4b:	68 ce 30 80 00       	push   $0x8030ce
  800d50:	ff 75 0c             	pushl  0xc(%ebp)
  800d53:	ff 75 08             	pushl  0x8(%ebp)
  800d56:	e8 45 02 00 00       	call   800fa0 <printfmt>
  800d5b:	83 c4 10             	add    $0x10,%esp
			break;
  800d5e:	e9 30 02 00 00       	jmp    800f93 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d63:	8b 45 14             	mov    0x14(%ebp),%eax
  800d66:	83 c0 04             	add    $0x4,%eax
  800d69:	89 45 14             	mov    %eax,0x14(%ebp)
  800d6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d6f:	83 e8 04             	sub    $0x4,%eax
  800d72:	8b 30                	mov    (%eax),%esi
  800d74:	85 f6                	test   %esi,%esi
  800d76:	75 05                	jne    800d7d <vprintfmt+0x1a6>
				p = "(null)";
  800d78:	be d1 30 80 00       	mov    $0x8030d1,%esi
			if (width > 0 && padc != '-')
  800d7d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d81:	7e 6d                	jle    800df0 <vprintfmt+0x219>
  800d83:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d87:	74 67                	je     800df0 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d8c:	83 ec 08             	sub    $0x8,%esp
  800d8f:	50                   	push   %eax
  800d90:	56                   	push   %esi
  800d91:	e8 12 05 00 00       	call   8012a8 <strnlen>
  800d96:	83 c4 10             	add    $0x10,%esp
  800d99:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d9c:	eb 16                	jmp    800db4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d9e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800da2:	83 ec 08             	sub    $0x8,%esp
  800da5:	ff 75 0c             	pushl  0xc(%ebp)
  800da8:	50                   	push   %eax
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	ff d0                	call   *%eax
  800dae:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800db1:	ff 4d e4             	decl   -0x1c(%ebp)
  800db4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800db8:	7f e4                	jg     800d9e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dba:	eb 34                	jmp    800df0 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800dbc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800dc0:	74 1c                	je     800dde <vprintfmt+0x207>
  800dc2:	83 fb 1f             	cmp    $0x1f,%ebx
  800dc5:	7e 05                	jle    800dcc <vprintfmt+0x1f5>
  800dc7:	83 fb 7e             	cmp    $0x7e,%ebx
  800dca:	7e 12                	jle    800dde <vprintfmt+0x207>
					putch('?', putdat);
  800dcc:	83 ec 08             	sub    $0x8,%esp
  800dcf:	ff 75 0c             	pushl  0xc(%ebp)
  800dd2:	6a 3f                	push   $0x3f
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	ff d0                	call   *%eax
  800dd9:	83 c4 10             	add    $0x10,%esp
  800ddc:	eb 0f                	jmp    800ded <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800dde:	83 ec 08             	sub    $0x8,%esp
  800de1:	ff 75 0c             	pushl  0xc(%ebp)
  800de4:	53                   	push   %ebx
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
  800de8:	ff d0                	call   *%eax
  800dea:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ded:	ff 4d e4             	decl   -0x1c(%ebp)
  800df0:	89 f0                	mov    %esi,%eax
  800df2:	8d 70 01             	lea    0x1(%eax),%esi
  800df5:	8a 00                	mov    (%eax),%al
  800df7:	0f be d8             	movsbl %al,%ebx
  800dfa:	85 db                	test   %ebx,%ebx
  800dfc:	74 24                	je     800e22 <vprintfmt+0x24b>
  800dfe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e02:	78 b8                	js     800dbc <vprintfmt+0x1e5>
  800e04:	ff 4d e0             	decl   -0x20(%ebp)
  800e07:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e0b:	79 af                	jns    800dbc <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e0d:	eb 13                	jmp    800e22 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e0f:	83 ec 08             	sub    $0x8,%esp
  800e12:	ff 75 0c             	pushl  0xc(%ebp)
  800e15:	6a 20                	push   $0x20
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	ff d0                	call   *%eax
  800e1c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e1f:	ff 4d e4             	decl   -0x1c(%ebp)
  800e22:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e26:	7f e7                	jg     800e0f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e28:	e9 66 01 00 00       	jmp    800f93 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e2d:	83 ec 08             	sub    $0x8,%esp
  800e30:	ff 75 e8             	pushl  -0x18(%ebp)
  800e33:	8d 45 14             	lea    0x14(%ebp),%eax
  800e36:	50                   	push   %eax
  800e37:	e8 3c fd ff ff       	call   800b78 <getint>
  800e3c:	83 c4 10             	add    $0x10,%esp
  800e3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e42:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e4b:	85 d2                	test   %edx,%edx
  800e4d:	79 23                	jns    800e72 <vprintfmt+0x29b>
				putch('-', putdat);
  800e4f:	83 ec 08             	sub    $0x8,%esp
  800e52:	ff 75 0c             	pushl  0xc(%ebp)
  800e55:	6a 2d                	push   $0x2d
  800e57:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5a:	ff d0                	call   *%eax
  800e5c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e65:	f7 d8                	neg    %eax
  800e67:	83 d2 00             	adc    $0x0,%edx
  800e6a:	f7 da                	neg    %edx
  800e6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e6f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e72:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e79:	e9 bc 00 00 00       	jmp    800f3a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e7e:	83 ec 08             	sub    $0x8,%esp
  800e81:	ff 75 e8             	pushl  -0x18(%ebp)
  800e84:	8d 45 14             	lea    0x14(%ebp),%eax
  800e87:	50                   	push   %eax
  800e88:	e8 84 fc ff ff       	call   800b11 <getuint>
  800e8d:	83 c4 10             	add    $0x10,%esp
  800e90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e93:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e96:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e9d:	e9 98 00 00 00       	jmp    800f3a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ea2:	83 ec 08             	sub    $0x8,%esp
  800ea5:	ff 75 0c             	pushl  0xc(%ebp)
  800ea8:	6a 58                	push   $0x58
  800eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ead:	ff d0                	call   *%eax
  800eaf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800eb2:	83 ec 08             	sub    $0x8,%esp
  800eb5:	ff 75 0c             	pushl  0xc(%ebp)
  800eb8:	6a 58                	push   $0x58
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	ff d0                	call   *%eax
  800ebf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ec2:	83 ec 08             	sub    $0x8,%esp
  800ec5:	ff 75 0c             	pushl  0xc(%ebp)
  800ec8:	6a 58                	push   $0x58
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	ff d0                	call   *%eax
  800ecf:	83 c4 10             	add    $0x10,%esp
			break;
  800ed2:	e9 bc 00 00 00       	jmp    800f93 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ed7:	83 ec 08             	sub    $0x8,%esp
  800eda:	ff 75 0c             	pushl  0xc(%ebp)
  800edd:	6a 30                	push   $0x30
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee2:	ff d0                	call   *%eax
  800ee4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ee7:	83 ec 08             	sub    $0x8,%esp
  800eea:	ff 75 0c             	pushl  0xc(%ebp)
  800eed:	6a 78                	push   $0x78
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	ff d0                	call   *%eax
  800ef4:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ef7:	8b 45 14             	mov    0x14(%ebp),%eax
  800efa:	83 c0 04             	add    $0x4,%eax
  800efd:	89 45 14             	mov    %eax,0x14(%ebp)
  800f00:	8b 45 14             	mov    0x14(%ebp),%eax
  800f03:	83 e8 04             	sub    $0x4,%eax
  800f06:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f08:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f0b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f12:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f19:	eb 1f                	jmp    800f3a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f1b:	83 ec 08             	sub    $0x8,%esp
  800f1e:	ff 75 e8             	pushl  -0x18(%ebp)
  800f21:	8d 45 14             	lea    0x14(%ebp),%eax
  800f24:	50                   	push   %eax
  800f25:	e8 e7 fb ff ff       	call   800b11 <getuint>
  800f2a:	83 c4 10             	add    $0x10,%esp
  800f2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f30:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f33:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f3a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f41:	83 ec 04             	sub    $0x4,%esp
  800f44:	52                   	push   %edx
  800f45:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f48:	50                   	push   %eax
  800f49:	ff 75 f4             	pushl  -0xc(%ebp)
  800f4c:	ff 75 f0             	pushl  -0x10(%ebp)
  800f4f:	ff 75 0c             	pushl  0xc(%ebp)
  800f52:	ff 75 08             	pushl  0x8(%ebp)
  800f55:	e8 00 fb ff ff       	call   800a5a <printnum>
  800f5a:	83 c4 20             	add    $0x20,%esp
			break;
  800f5d:	eb 34                	jmp    800f93 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f5f:	83 ec 08             	sub    $0x8,%esp
  800f62:	ff 75 0c             	pushl  0xc(%ebp)
  800f65:	53                   	push   %ebx
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
  800f69:	ff d0                	call   *%eax
  800f6b:	83 c4 10             	add    $0x10,%esp
			break;
  800f6e:	eb 23                	jmp    800f93 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f70:	83 ec 08             	sub    $0x8,%esp
  800f73:	ff 75 0c             	pushl  0xc(%ebp)
  800f76:	6a 25                	push   $0x25
  800f78:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7b:	ff d0                	call   *%eax
  800f7d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f80:	ff 4d 10             	decl   0x10(%ebp)
  800f83:	eb 03                	jmp    800f88 <vprintfmt+0x3b1>
  800f85:	ff 4d 10             	decl   0x10(%ebp)
  800f88:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8b:	48                   	dec    %eax
  800f8c:	8a 00                	mov    (%eax),%al
  800f8e:	3c 25                	cmp    $0x25,%al
  800f90:	75 f3                	jne    800f85 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f92:	90                   	nop
		}
	}
  800f93:	e9 47 fc ff ff       	jmp    800bdf <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f98:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f99:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f9c:	5b                   	pop    %ebx
  800f9d:	5e                   	pop    %esi
  800f9e:	5d                   	pop    %ebp
  800f9f:	c3                   	ret    

00800fa0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fa0:	55                   	push   %ebp
  800fa1:	89 e5                	mov    %esp,%ebp
  800fa3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fa6:	8d 45 10             	lea    0x10(%ebp),%eax
  800fa9:	83 c0 04             	add    $0x4,%eax
  800fac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800faf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fb5:	50                   	push   %eax
  800fb6:	ff 75 0c             	pushl  0xc(%ebp)
  800fb9:	ff 75 08             	pushl  0x8(%ebp)
  800fbc:	e8 16 fc ff ff       	call   800bd7 <vprintfmt>
  800fc1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fc4:	90                   	nop
  800fc5:	c9                   	leave  
  800fc6:	c3                   	ret    

00800fc7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fc7:	55                   	push   %ebp
  800fc8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcd:	8b 40 08             	mov    0x8(%eax),%eax
  800fd0:	8d 50 01             	lea    0x1(%eax),%edx
  800fd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdc:	8b 10                	mov    (%eax),%edx
  800fde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe1:	8b 40 04             	mov    0x4(%eax),%eax
  800fe4:	39 c2                	cmp    %eax,%edx
  800fe6:	73 12                	jae    800ffa <sprintputch+0x33>
		*b->buf++ = ch;
  800fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800feb:	8b 00                	mov    (%eax),%eax
  800fed:	8d 48 01             	lea    0x1(%eax),%ecx
  800ff0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ff3:	89 0a                	mov    %ecx,(%edx)
  800ff5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff8:	88 10                	mov    %dl,(%eax)
}
  800ffa:	90                   	nop
  800ffb:	5d                   	pop    %ebp
  800ffc:	c3                   	ret    

00800ffd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ffd:	55                   	push   %ebp
  800ffe:	89 e5                	mov    %esp,%ebp
  801000:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801009:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
  801012:	01 d0                	add    %edx,%eax
  801014:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801017:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80101e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801022:	74 06                	je     80102a <vsnprintf+0x2d>
  801024:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801028:	7f 07                	jg     801031 <vsnprintf+0x34>
		return -E_INVAL;
  80102a:	b8 03 00 00 00       	mov    $0x3,%eax
  80102f:	eb 20                	jmp    801051 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801031:	ff 75 14             	pushl  0x14(%ebp)
  801034:	ff 75 10             	pushl  0x10(%ebp)
  801037:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80103a:	50                   	push   %eax
  80103b:	68 c7 0f 80 00       	push   $0x800fc7
  801040:	e8 92 fb ff ff       	call   800bd7 <vprintfmt>
  801045:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801048:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80104b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80104e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801051:	c9                   	leave  
  801052:	c3                   	ret    

00801053 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801053:	55                   	push   %ebp
  801054:	89 e5                	mov    %esp,%ebp
  801056:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801059:	8d 45 10             	lea    0x10(%ebp),%eax
  80105c:	83 c0 04             	add    $0x4,%eax
  80105f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801062:	8b 45 10             	mov    0x10(%ebp),%eax
  801065:	ff 75 f4             	pushl  -0xc(%ebp)
  801068:	50                   	push   %eax
  801069:	ff 75 0c             	pushl  0xc(%ebp)
  80106c:	ff 75 08             	pushl  0x8(%ebp)
  80106f:	e8 89 ff ff ff       	call   800ffd <vsnprintf>
  801074:	83 c4 10             	add    $0x10,%esp
  801077:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80107a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80107d:	c9                   	leave  
  80107e:	c3                   	ret    

0080107f <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80107f:	55                   	push   %ebp
  801080:	89 e5                	mov    %esp,%ebp
  801082:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  801085:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801089:	74 13                	je     80109e <readline+0x1f>
		cprintf("%s", prompt);
  80108b:	83 ec 08             	sub    $0x8,%esp
  80108e:	ff 75 08             	pushl  0x8(%ebp)
  801091:	68 30 32 80 00       	push   $0x803230
  801096:	e8 69 f9 ff ff       	call   800a04 <cprintf>
  80109b:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80109e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8010a5:	83 ec 0c             	sub    $0xc,%esp
  8010a8:	6a 00                	push   $0x0
  8010aa:	e8 5f f7 ff ff       	call   80080e <iscons>
  8010af:	83 c4 10             	add    $0x10,%esp
  8010b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8010b5:	e8 06 f7 ff ff       	call   8007c0 <getchar>
  8010ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8010bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010c1:	79 22                	jns    8010e5 <readline+0x66>
			if (c != -E_EOF)
  8010c3:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8010c7:	0f 84 ad 00 00 00    	je     80117a <readline+0xfb>
				cprintf("read error: %e\n", c);
  8010cd:	83 ec 08             	sub    $0x8,%esp
  8010d0:	ff 75 ec             	pushl  -0x14(%ebp)
  8010d3:	68 33 32 80 00       	push   $0x803233
  8010d8:	e8 27 f9 ff ff       	call   800a04 <cprintf>
  8010dd:	83 c4 10             	add    $0x10,%esp
			return;
  8010e0:	e9 95 00 00 00       	jmp    80117a <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8010e5:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8010e9:	7e 34                	jle    80111f <readline+0xa0>
  8010eb:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8010f2:	7f 2b                	jg     80111f <readline+0xa0>
			if (echoing)
  8010f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8010f8:	74 0e                	je     801108 <readline+0x89>
				cputchar(c);
  8010fa:	83 ec 0c             	sub    $0xc,%esp
  8010fd:	ff 75 ec             	pushl  -0x14(%ebp)
  801100:	e8 73 f6 ff ff       	call   800778 <cputchar>
  801105:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80110b:	8d 50 01             	lea    0x1(%eax),%edx
  80110e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801111:	89 c2                	mov    %eax,%edx
  801113:	8b 45 0c             	mov    0xc(%ebp),%eax
  801116:	01 d0                	add    %edx,%eax
  801118:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80111b:	88 10                	mov    %dl,(%eax)
  80111d:	eb 56                	jmp    801175 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80111f:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801123:	75 1f                	jne    801144 <readline+0xc5>
  801125:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801129:	7e 19                	jle    801144 <readline+0xc5>
			if (echoing)
  80112b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80112f:	74 0e                	je     80113f <readline+0xc0>
				cputchar(c);
  801131:	83 ec 0c             	sub    $0xc,%esp
  801134:	ff 75 ec             	pushl  -0x14(%ebp)
  801137:	e8 3c f6 ff ff       	call   800778 <cputchar>
  80113c:	83 c4 10             	add    $0x10,%esp

			i--;
  80113f:	ff 4d f4             	decl   -0xc(%ebp)
  801142:	eb 31                	jmp    801175 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801144:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801148:	74 0a                	je     801154 <readline+0xd5>
  80114a:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80114e:	0f 85 61 ff ff ff    	jne    8010b5 <readline+0x36>
			if (echoing)
  801154:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801158:	74 0e                	je     801168 <readline+0xe9>
				cputchar(c);
  80115a:	83 ec 0c             	sub    $0xc,%esp
  80115d:	ff 75 ec             	pushl  -0x14(%ebp)
  801160:	e8 13 f6 ff ff       	call   800778 <cputchar>
  801165:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801168:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	01 d0                	add    %edx,%eax
  801170:	c6 00 00             	movb   $0x0,(%eax)
			return;
  801173:	eb 06                	jmp    80117b <readline+0xfc>
		}
	}
  801175:	e9 3b ff ff ff       	jmp    8010b5 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  80117a:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  80117b:	c9                   	leave  
  80117c:	c3                   	ret    

0080117d <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80117d:	55                   	push   %ebp
  80117e:	89 e5                	mov    %esp,%ebp
  801180:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801183:	e8 71 14 00 00       	call   8025f9 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801188:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80118c:	74 13                	je     8011a1 <atomic_readline+0x24>
		cprintf("%s", prompt);
  80118e:	83 ec 08             	sub    $0x8,%esp
  801191:	ff 75 08             	pushl  0x8(%ebp)
  801194:	68 30 32 80 00       	push   $0x803230
  801199:	e8 66 f8 ff ff       	call   800a04 <cprintf>
  80119e:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011a8:	83 ec 0c             	sub    $0xc,%esp
  8011ab:	6a 00                	push   $0x0
  8011ad:	e8 5c f6 ff ff       	call   80080e <iscons>
  8011b2:	83 c4 10             	add    $0x10,%esp
  8011b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8011b8:	e8 03 f6 ff ff       	call   8007c0 <getchar>
  8011bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8011c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011c4:	79 23                	jns    8011e9 <atomic_readline+0x6c>
			if (c != -E_EOF)
  8011c6:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8011ca:	74 13                	je     8011df <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  8011cc:	83 ec 08             	sub    $0x8,%esp
  8011cf:	ff 75 ec             	pushl  -0x14(%ebp)
  8011d2:	68 33 32 80 00       	push   $0x803233
  8011d7:	e8 28 f8 ff ff       	call   800a04 <cprintf>
  8011dc:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  8011df:	e8 2f 14 00 00       	call   802613 <sys_enable_interrupt>
			return;
  8011e4:	e9 9a 00 00 00       	jmp    801283 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8011e9:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8011ed:	7e 34                	jle    801223 <atomic_readline+0xa6>
  8011ef:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8011f6:	7f 2b                	jg     801223 <atomic_readline+0xa6>
			if (echoing)
  8011f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011fc:	74 0e                	je     80120c <atomic_readline+0x8f>
				cputchar(c);
  8011fe:	83 ec 0c             	sub    $0xc,%esp
  801201:	ff 75 ec             	pushl  -0x14(%ebp)
  801204:	e8 6f f5 ff ff       	call   800778 <cputchar>
  801209:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80120c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80120f:	8d 50 01             	lea    0x1(%eax),%edx
  801212:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801215:	89 c2                	mov    %eax,%edx
  801217:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121a:	01 d0                	add    %edx,%eax
  80121c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80121f:	88 10                	mov    %dl,(%eax)
  801221:	eb 5b                	jmp    80127e <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  801223:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801227:	75 1f                	jne    801248 <atomic_readline+0xcb>
  801229:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80122d:	7e 19                	jle    801248 <atomic_readline+0xcb>
			if (echoing)
  80122f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801233:	74 0e                	je     801243 <atomic_readline+0xc6>
				cputchar(c);
  801235:	83 ec 0c             	sub    $0xc,%esp
  801238:	ff 75 ec             	pushl  -0x14(%ebp)
  80123b:	e8 38 f5 ff ff       	call   800778 <cputchar>
  801240:	83 c4 10             	add    $0x10,%esp
			i--;
  801243:	ff 4d f4             	decl   -0xc(%ebp)
  801246:	eb 36                	jmp    80127e <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801248:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80124c:	74 0a                	je     801258 <atomic_readline+0xdb>
  80124e:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801252:	0f 85 60 ff ff ff    	jne    8011b8 <atomic_readline+0x3b>
			if (echoing)
  801258:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80125c:	74 0e                	je     80126c <atomic_readline+0xef>
				cputchar(c);
  80125e:	83 ec 0c             	sub    $0xc,%esp
  801261:	ff 75 ec             	pushl  -0x14(%ebp)
  801264:	e8 0f f5 ff ff       	call   800778 <cputchar>
  801269:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  80126c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80126f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801272:	01 d0                	add    %edx,%eax
  801274:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  801277:	e8 97 13 00 00       	call   802613 <sys_enable_interrupt>
			return;
  80127c:	eb 05                	jmp    801283 <atomic_readline+0x106>
		}
	}
  80127e:	e9 35 ff ff ff       	jmp    8011b8 <atomic_readline+0x3b>
}
  801283:	c9                   	leave  
  801284:	c3                   	ret    

00801285 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801285:	55                   	push   %ebp
  801286:	89 e5                	mov    %esp,%ebp
  801288:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80128b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801292:	eb 06                	jmp    80129a <strlen+0x15>
		n++;
  801294:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801297:	ff 45 08             	incl   0x8(%ebp)
  80129a:	8b 45 08             	mov    0x8(%ebp),%eax
  80129d:	8a 00                	mov    (%eax),%al
  80129f:	84 c0                	test   %al,%al
  8012a1:	75 f1                	jne    801294 <strlen+0xf>
		n++;
	return n;
  8012a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012a6:	c9                   	leave  
  8012a7:	c3                   	ret    

008012a8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012a8:	55                   	push   %ebp
  8012a9:	89 e5                	mov    %esp,%ebp
  8012ab:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012b5:	eb 09                	jmp    8012c0 <strnlen+0x18>
		n++;
  8012b7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012ba:	ff 45 08             	incl   0x8(%ebp)
  8012bd:	ff 4d 0c             	decl   0xc(%ebp)
  8012c0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012c4:	74 09                	je     8012cf <strnlen+0x27>
  8012c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c9:	8a 00                	mov    (%eax),%al
  8012cb:	84 c0                	test   %al,%al
  8012cd:	75 e8                	jne    8012b7 <strnlen+0xf>
		n++;
	return n;
  8012cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012d2:	c9                   	leave  
  8012d3:	c3                   	ret    

008012d4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012d4:	55                   	push   %ebp
  8012d5:	89 e5                	mov    %esp,%ebp
  8012d7:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8012da:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8012e0:	90                   	nop
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	8d 50 01             	lea    0x1(%eax),%edx
  8012e7:	89 55 08             	mov    %edx,0x8(%ebp)
  8012ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ed:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012f0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012f3:	8a 12                	mov    (%edx),%dl
  8012f5:	88 10                	mov    %dl,(%eax)
  8012f7:	8a 00                	mov    (%eax),%al
  8012f9:	84 c0                	test   %al,%al
  8012fb:	75 e4                	jne    8012e1 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8012fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801300:	c9                   	leave  
  801301:	c3                   	ret    

00801302 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801302:	55                   	push   %ebp
  801303:	89 e5                	mov    %esp,%ebp
  801305:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801308:	8b 45 08             	mov    0x8(%ebp),%eax
  80130b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80130e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801315:	eb 1f                	jmp    801336 <strncpy+0x34>
		*dst++ = *src;
  801317:	8b 45 08             	mov    0x8(%ebp),%eax
  80131a:	8d 50 01             	lea    0x1(%eax),%edx
  80131d:	89 55 08             	mov    %edx,0x8(%ebp)
  801320:	8b 55 0c             	mov    0xc(%ebp),%edx
  801323:	8a 12                	mov    (%edx),%dl
  801325:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801327:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132a:	8a 00                	mov    (%eax),%al
  80132c:	84 c0                	test   %al,%al
  80132e:	74 03                	je     801333 <strncpy+0x31>
			src++;
  801330:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801333:	ff 45 fc             	incl   -0x4(%ebp)
  801336:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801339:	3b 45 10             	cmp    0x10(%ebp),%eax
  80133c:	72 d9                	jb     801317 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80133e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801341:	c9                   	leave  
  801342:	c3                   	ret    

00801343 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801343:	55                   	push   %ebp
  801344:	89 e5                	mov    %esp,%ebp
  801346:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
  80134c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80134f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801353:	74 30                	je     801385 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801355:	eb 16                	jmp    80136d <strlcpy+0x2a>
			*dst++ = *src++;
  801357:	8b 45 08             	mov    0x8(%ebp),%eax
  80135a:	8d 50 01             	lea    0x1(%eax),%edx
  80135d:	89 55 08             	mov    %edx,0x8(%ebp)
  801360:	8b 55 0c             	mov    0xc(%ebp),%edx
  801363:	8d 4a 01             	lea    0x1(%edx),%ecx
  801366:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801369:	8a 12                	mov    (%edx),%dl
  80136b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80136d:	ff 4d 10             	decl   0x10(%ebp)
  801370:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801374:	74 09                	je     80137f <strlcpy+0x3c>
  801376:	8b 45 0c             	mov    0xc(%ebp),%eax
  801379:	8a 00                	mov    (%eax),%al
  80137b:	84 c0                	test   %al,%al
  80137d:	75 d8                	jne    801357 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80137f:	8b 45 08             	mov    0x8(%ebp),%eax
  801382:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801385:	8b 55 08             	mov    0x8(%ebp),%edx
  801388:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80138b:	29 c2                	sub    %eax,%edx
  80138d:	89 d0                	mov    %edx,%eax
}
  80138f:	c9                   	leave  
  801390:	c3                   	ret    

00801391 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801391:	55                   	push   %ebp
  801392:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801394:	eb 06                	jmp    80139c <strcmp+0xb>
		p++, q++;
  801396:	ff 45 08             	incl   0x8(%ebp)
  801399:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80139c:	8b 45 08             	mov    0x8(%ebp),%eax
  80139f:	8a 00                	mov    (%eax),%al
  8013a1:	84 c0                	test   %al,%al
  8013a3:	74 0e                	je     8013b3 <strcmp+0x22>
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	8a 10                	mov    (%eax),%dl
  8013aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ad:	8a 00                	mov    (%eax),%al
  8013af:	38 c2                	cmp    %al,%dl
  8013b1:	74 e3                	je     801396 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	8a 00                	mov    (%eax),%al
  8013b8:	0f b6 d0             	movzbl %al,%edx
  8013bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013be:	8a 00                	mov    (%eax),%al
  8013c0:	0f b6 c0             	movzbl %al,%eax
  8013c3:	29 c2                	sub    %eax,%edx
  8013c5:	89 d0                	mov    %edx,%eax
}
  8013c7:	5d                   	pop    %ebp
  8013c8:	c3                   	ret    

008013c9 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8013c9:	55                   	push   %ebp
  8013ca:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8013cc:	eb 09                	jmp    8013d7 <strncmp+0xe>
		n--, p++, q++;
  8013ce:	ff 4d 10             	decl   0x10(%ebp)
  8013d1:	ff 45 08             	incl   0x8(%ebp)
  8013d4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8013d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013db:	74 17                	je     8013f4 <strncmp+0x2b>
  8013dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e0:	8a 00                	mov    (%eax),%al
  8013e2:	84 c0                	test   %al,%al
  8013e4:	74 0e                	je     8013f4 <strncmp+0x2b>
  8013e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e9:	8a 10                	mov    (%eax),%dl
  8013eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ee:	8a 00                	mov    (%eax),%al
  8013f0:	38 c2                	cmp    %al,%dl
  8013f2:	74 da                	je     8013ce <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8013f4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013f8:	75 07                	jne    801401 <strncmp+0x38>
		return 0;
  8013fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ff:	eb 14                	jmp    801415 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801401:	8b 45 08             	mov    0x8(%ebp),%eax
  801404:	8a 00                	mov    (%eax),%al
  801406:	0f b6 d0             	movzbl %al,%edx
  801409:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140c:	8a 00                	mov    (%eax),%al
  80140e:	0f b6 c0             	movzbl %al,%eax
  801411:	29 c2                	sub    %eax,%edx
  801413:	89 d0                	mov    %edx,%eax
}
  801415:	5d                   	pop    %ebp
  801416:	c3                   	ret    

00801417 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
  80141a:	83 ec 04             	sub    $0x4,%esp
  80141d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801420:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801423:	eb 12                	jmp    801437 <strchr+0x20>
		if (*s == c)
  801425:	8b 45 08             	mov    0x8(%ebp),%eax
  801428:	8a 00                	mov    (%eax),%al
  80142a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80142d:	75 05                	jne    801434 <strchr+0x1d>
			return (char *) s;
  80142f:	8b 45 08             	mov    0x8(%ebp),%eax
  801432:	eb 11                	jmp    801445 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801434:	ff 45 08             	incl   0x8(%ebp)
  801437:	8b 45 08             	mov    0x8(%ebp),%eax
  80143a:	8a 00                	mov    (%eax),%al
  80143c:	84 c0                	test   %al,%al
  80143e:	75 e5                	jne    801425 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801440:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801445:	c9                   	leave  
  801446:	c3                   	ret    

00801447 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	83 ec 04             	sub    $0x4,%esp
  80144d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801450:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801453:	eb 0d                	jmp    801462 <strfind+0x1b>
		if (*s == c)
  801455:	8b 45 08             	mov    0x8(%ebp),%eax
  801458:	8a 00                	mov    (%eax),%al
  80145a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80145d:	74 0e                	je     80146d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80145f:	ff 45 08             	incl   0x8(%ebp)
  801462:	8b 45 08             	mov    0x8(%ebp),%eax
  801465:	8a 00                	mov    (%eax),%al
  801467:	84 c0                	test   %al,%al
  801469:	75 ea                	jne    801455 <strfind+0xe>
  80146b:	eb 01                	jmp    80146e <strfind+0x27>
		if (*s == c)
			break;
  80146d:	90                   	nop
	return (char *) s;
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801471:	c9                   	leave  
  801472:	c3                   	ret    

00801473 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801473:	55                   	push   %ebp
  801474:	89 e5                	mov    %esp,%ebp
  801476:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801479:	8b 45 08             	mov    0x8(%ebp),%eax
  80147c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80147f:	8b 45 10             	mov    0x10(%ebp),%eax
  801482:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801485:	eb 0e                	jmp    801495 <memset+0x22>
		*p++ = c;
  801487:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80148a:	8d 50 01             	lea    0x1(%eax),%edx
  80148d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801490:	8b 55 0c             	mov    0xc(%ebp),%edx
  801493:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801495:	ff 4d f8             	decl   -0x8(%ebp)
  801498:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80149c:	79 e9                	jns    801487 <memset+0x14>
		*p++ = c;

	return v;
  80149e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014a1:	c9                   	leave  
  8014a2:	c3                   	ret    

008014a3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014a3:	55                   	push   %ebp
  8014a4:	89 e5                	mov    %esp,%ebp
  8014a6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8014b5:	eb 16                	jmp    8014cd <memcpy+0x2a>
		*d++ = *s++;
  8014b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ba:	8d 50 01             	lea    0x1(%eax),%edx
  8014bd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014c0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014c3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014c6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014c9:	8a 12                	mov    (%edx),%dl
  8014cb:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8014cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014d3:	89 55 10             	mov    %edx,0x10(%ebp)
  8014d6:	85 c0                	test   %eax,%eax
  8014d8:	75 dd                	jne    8014b7 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8014da:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014dd:	c9                   	leave  
  8014de:	c3                   	ret    

008014df <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8014df:	55                   	push   %ebp
  8014e0:	89 e5                	mov    %esp,%ebp
  8014e2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  8014e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ee:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8014f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014f4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014f7:	73 50                	jae    801549 <memmove+0x6a>
  8014f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ff:	01 d0                	add    %edx,%eax
  801501:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801504:	76 43                	jbe    801549 <memmove+0x6a>
		s += n;
  801506:	8b 45 10             	mov    0x10(%ebp),%eax
  801509:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80150c:	8b 45 10             	mov    0x10(%ebp),%eax
  80150f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801512:	eb 10                	jmp    801524 <memmove+0x45>
			*--d = *--s;
  801514:	ff 4d f8             	decl   -0x8(%ebp)
  801517:	ff 4d fc             	decl   -0x4(%ebp)
  80151a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80151d:	8a 10                	mov    (%eax),%dl
  80151f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801522:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801524:	8b 45 10             	mov    0x10(%ebp),%eax
  801527:	8d 50 ff             	lea    -0x1(%eax),%edx
  80152a:	89 55 10             	mov    %edx,0x10(%ebp)
  80152d:	85 c0                	test   %eax,%eax
  80152f:	75 e3                	jne    801514 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801531:	eb 23                	jmp    801556 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801533:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801536:	8d 50 01             	lea    0x1(%eax),%edx
  801539:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80153c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80153f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801542:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801545:	8a 12                	mov    (%edx),%dl
  801547:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801549:	8b 45 10             	mov    0x10(%ebp),%eax
  80154c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80154f:	89 55 10             	mov    %edx,0x10(%ebp)
  801552:	85 c0                	test   %eax,%eax
  801554:	75 dd                	jne    801533 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801556:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801559:	c9                   	leave  
  80155a:	c3                   	ret    

0080155b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
  80155e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
  801564:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801567:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80156d:	eb 2a                	jmp    801599 <memcmp+0x3e>
		if (*s1 != *s2)
  80156f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801572:	8a 10                	mov    (%eax),%dl
  801574:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801577:	8a 00                	mov    (%eax),%al
  801579:	38 c2                	cmp    %al,%dl
  80157b:	74 16                	je     801593 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80157d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801580:	8a 00                	mov    (%eax),%al
  801582:	0f b6 d0             	movzbl %al,%edx
  801585:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801588:	8a 00                	mov    (%eax),%al
  80158a:	0f b6 c0             	movzbl %al,%eax
  80158d:	29 c2                	sub    %eax,%edx
  80158f:	89 d0                	mov    %edx,%eax
  801591:	eb 18                	jmp    8015ab <memcmp+0x50>
		s1++, s2++;
  801593:	ff 45 fc             	incl   -0x4(%ebp)
  801596:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801599:	8b 45 10             	mov    0x10(%ebp),%eax
  80159c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80159f:	89 55 10             	mov    %edx,0x10(%ebp)
  8015a2:	85 c0                	test   %eax,%eax
  8015a4:	75 c9                	jne    80156f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ab:	c9                   	leave  
  8015ac:	c3                   	ret    

008015ad <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
  8015b0:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8015b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b9:	01 d0                	add    %edx,%eax
  8015bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8015be:	eb 15                	jmp    8015d5 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c3:	8a 00                	mov    (%eax),%al
  8015c5:	0f b6 d0             	movzbl %al,%edx
  8015c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cb:	0f b6 c0             	movzbl %al,%eax
  8015ce:	39 c2                	cmp    %eax,%edx
  8015d0:	74 0d                	je     8015df <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015d2:	ff 45 08             	incl   0x8(%ebp)
  8015d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015db:	72 e3                	jb     8015c0 <memfind+0x13>
  8015dd:	eb 01                	jmp    8015e0 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8015df:	90                   	nop
	return (void *) s;
  8015e0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015e3:	c9                   	leave  
  8015e4:	c3                   	ret    

008015e5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
  8015e8:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8015eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8015f2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015f9:	eb 03                	jmp    8015fe <strtol+0x19>
		s++;
  8015fb:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801601:	8a 00                	mov    (%eax),%al
  801603:	3c 20                	cmp    $0x20,%al
  801605:	74 f4                	je     8015fb <strtol+0x16>
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	8a 00                	mov    (%eax),%al
  80160c:	3c 09                	cmp    $0x9,%al
  80160e:	74 eb                	je     8015fb <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801610:	8b 45 08             	mov    0x8(%ebp),%eax
  801613:	8a 00                	mov    (%eax),%al
  801615:	3c 2b                	cmp    $0x2b,%al
  801617:	75 05                	jne    80161e <strtol+0x39>
		s++;
  801619:	ff 45 08             	incl   0x8(%ebp)
  80161c:	eb 13                	jmp    801631 <strtol+0x4c>
	else if (*s == '-')
  80161e:	8b 45 08             	mov    0x8(%ebp),%eax
  801621:	8a 00                	mov    (%eax),%al
  801623:	3c 2d                	cmp    $0x2d,%al
  801625:	75 0a                	jne    801631 <strtol+0x4c>
		s++, neg = 1;
  801627:	ff 45 08             	incl   0x8(%ebp)
  80162a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801631:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801635:	74 06                	je     80163d <strtol+0x58>
  801637:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80163b:	75 20                	jne    80165d <strtol+0x78>
  80163d:	8b 45 08             	mov    0x8(%ebp),%eax
  801640:	8a 00                	mov    (%eax),%al
  801642:	3c 30                	cmp    $0x30,%al
  801644:	75 17                	jne    80165d <strtol+0x78>
  801646:	8b 45 08             	mov    0x8(%ebp),%eax
  801649:	40                   	inc    %eax
  80164a:	8a 00                	mov    (%eax),%al
  80164c:	3c 78                	cmp    $0x78,%al
  80164e:	75 0d                	jne    80165d <strtol+0x78>
		s += 2, base = 16;
  801650:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801654:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80165b:	eb 28                	jmp    801685 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80165d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801661:	75 15                	jne    801678 <strtol+0x93>
  801663:	8b 45 08             	mov    0x8(%ebp),%eax
  801666:	8a 00                	mov    (%eax),%al
  801668:	3c 30                	cmp    $0x30,%al
  80166a:	75 0c                	jne    801678 <strtol+0x93>
		s++, base = 8;
  80166c:	ff 45 08             	incl   0x8(%ebp)
  80166f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801676:	eb 0d                	jmp    801685 <strtol+0xa0>
	else if (base == 0)
  801678:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80167c:	75 07                	jne    801685 <strtol+0xa0>
		base = 10;
  80167e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
  801688:	8a 00                	mov    (%eax),%al
  80168a:	3c 2f                	cmp    $0x2f,%al
  80168c:	7e 19                	jle    8016a7 <strtol+0xc2>
  80168e:	8b 45 08             	mov    0x8(%ebp),%eax
  801691:	8a 00                	mov    (%eax),%al
  801693:	3c 39                	cmp    $0x39,%al
  801695:	7f 10                	jg     8016a7 <strtol+0xc2>
			dig = *s - '0';
  801697:	8b 45 08             	mov    0x8(%ebp),%eax
  80169a:	8a 00                	mov    (%eax),%al
  80169c:	0f be c0             	movsbl %al,%eax
  80169f:	83 e8 30             	sub    $0x30,%eax
  8016a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016a5:	eb 42                	jmp    8016e9 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016aa:	8a 00                	mov    (%eax),%al
  8016ac:	3c 60                	cmp    $0x60,%al
  8016ae:	7e 19                	jle    8016c9 <strtol+0xe4>
  8016b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b3:	8a 00                	mov    (%eax),%al
  8016b5:	3c 7a                	cmp    $0x7a,%al
  8016b7:	7f 10                	jg     8016c9 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	8a 00                	mov    (%eax),%al
  8016be:	0f be c0             	movsbl %al,%eax
  8016c1:	83 e8 57             	sub    $0x57,%eax
  8016c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016c7:	eb 20                	jmp    8016e9 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8016c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cc:	8a 00                	mov    (%eax),%al
  8016ce:	3c 40                	cmp    $0x40,%al
  8016d0:	7e 39                	jle    80170b <strtol+0x126>
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	8a 00                	mov    (%eax),%al
  8016d7:	3c 5a                	cmp    $0x5a,%al
  8016d9:	7f 30                	jg     80170b <strtol+0x126>
			dig = *s - 'A' + 10;
  8016db:	8b 45 08             	mov    0x8(%ebp),%eax
  8016de:	8a 00                	mov    (%eax),%al
  8016e0:	0f be c0             	movsbl %al,%eax
  8016e3:	83 e8 37             	sub    $0x37,%eax
  8016e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8016e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ec:	3b 45 10             	cmp    0x10(%ebp),%eax
  8016ef:	7d 19                	jge    80170a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8016f1:	ff 45 08             	incl   0x8(%ebp)
  8016f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016f7:	0f af 45 10          	imul   0x10(%ebp),%eax
  8016fb:	89 c2                	mov    %eax,%edx
  8016fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801700:	01 d0                	add    %edx,%eax
  801702:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801705:	e9 7b ff ff ff       	jmp    801685 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80170a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80170b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80170f:	74 08                	je     801719 <strtol+0x134>
		*endptr = (char *) s;
  801711:	8b 45 0c             	mov    0xc(%ebp),%eax
  801714:	8b 55 08             	mov    0x8(%ebp),%edx
  801717:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801719:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80171d:	74 07                	je     801726 <strtol+0x141>
  80171f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801722:	f7 d8                	neg    %eax
  801724:	eb 03                	jmp    801729 <strtol+0x144>
  801726:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801729:	c9                   	leave  
  80172a:	c3                   	ret    

0080172b <ltostr>:

void
ltostr(long value, char *str)
{
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
  80172e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801731:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801738:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80173f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801743:	79 13                	jns    801758 <ltostr+0x2d>
	{
		neg = 1;
  801745:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80174c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801752:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801755:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801758:	8b 45 08             	mov    0x8(%ebp),%eax
  80175b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801760:	99                   	cltd   
  801761:	f7 f9                	idiv   %ecx
  801763:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801766:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801769:	8d 50 01             	lea    0x1(%eax),%edx
  80176c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80176f:	89 c2                	mov    %eax,%edx
  801771:	8b 45 0c             	mov    0xc(%ebp),%eax
  801774:	01 d0                	add    %edx,%eax
  801776:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801779:	83 c2 30             	add    $0x30,%edx
  80177c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80177e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801781:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801786:	f7 e9                	imul   %ecx
  801788:	c1 fa 02             	sar    $0x2,%edx
  80178b:	89 c8                	mov    %ecx,%eax
  80178d:	c1 f8 1f             	sar    $0x1f,%eax
  801790:	29 c2                	sub    %eax,%edx
  801792:	89 d0                	mov    %edx,%eax
  801794:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801797:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80179a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80179f:	f7 e9                	imul   %ecx
  8017a1:	c1 fa 02             	sar    $0x2,%edx
  8017a4:	89 c8                	mov    %ecx,%eax
  8017a6:	c1 f8 1f             	sar    $0x1f,%eax
  8017a9:	29 c2                	sub    %eax,%edx
  8017ab:	89 d0                	mov    %edx,%eax
  8017ad:	c1 e0 02             	shl    $0x2,%eax
  8017b0:	01 d0                	add    %edx,%eax
  8017b2:	01 c0                	add    %eax,%eax
  8017b4:	29 c1                	sub    %eax,%ecx
  8017b6:	89 ca                	mov    %ecx,%edx
  8017b8:	85 d2                	test   %edx,%edx
  8017ba:	75 9c                	jne    801758 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8017bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017c6:	48                   	dec    %eax
  8017c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8017ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017ce:	74 3d                	je     80180d <ltostr+0xe2>
		start = 1 ;
  8017d0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8017d7:	eb 34                	jmp    80180d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8017d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017df:	01 d0                	add    %edx,%eax
  8017e1:	8a 00                	mov    (%eax),%al
  8017e3:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ec:	01 c2                	add    %eax,%edx
  8017ee:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f4:	01 c8                	add    %ecx,%eax
  8017f6:	8a 00                	mov    (%eax),%al
  8017f8:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8017fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801800:	01 c2                	add    %eax,%edx
  801802:	8a 45 eb             	mov    -0x15(%ebp),%al
  801805:	88 02                	mov    %al,(%edx)
		start++ ;
  801807:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80180a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80180d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801810:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801813:	7c c4                	jl     8017d9 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801815:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801818:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181b:	01 d0                	add    %edx,%eax
  80181d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801820:	90                   	nop
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
  801826:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801829:	ff 75 08             	pushl  0x8(%ebp)
  80182c:	e8 54 fa ff ff       	call   801285 <strlen>
  801831:	83 c4 04             	add    $0x4,%esp
  801834:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801837:	ff 75 0c             	pushl  0xc(%ebp)
  80183a:	e8 46 fa ff ff       	call   801285 <strlen>
  80183f:	83 c4 04             	add    $0x4,%esp
  801842:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801845:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80184c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801853:	eb 17                	jmp    80186c <strcconcat+0x49>
		final[s] = str1[s] ;
  801855:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801858:	8b 45 10             	mov    0x10(%ebp),%eax
  80185b:	01 c2                	add    %eax,%edx
  80185d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	01 c8                	add    %ecx,%eax
  801865:	8a 00                	mov    (%eax),%al
  801867:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801869:	ff 45 fc             	incl   -0x4(%ebp)
  80186c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80186f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801872:	7c e1                	jl     801855 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801874:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80187b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801882:	eb 1f                	jmp    8018a3 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801884:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801887:	8d 50 01             	lea    0x1(%eax),%edx
  80188a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80188d:	89 c2                	mov    %eax,%edx
  80188f:	8b 45 10             	mov    0x10(%ebp),%eax
  801892:	01 c2                	add    %eax,%edx
  801894:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801897:	8b 45 0c             	mov    0xc(%ebp),%eax
  80189a:	01 c8                	add    %ecx,%eax
  80189c:	8a 00                	mov    (%eax),%al
  80189e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8018a0:	ff 45 f8             	incl   -0x8(%ebp)
  8018a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018a6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018a9:	7c d9                	jl     801884 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8018ab:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b1:	01 d0                	add    %edx,%eax
  8018b3:	c6 00 00             	movb   $0x0,(%eax)
}
  8018b6:	90                   	nop
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8018bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8018bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8018c8:	8b 00                	mov    (%eax),%eax
  8018ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d4:	01 d0                	add    %edx,%eax
  8018d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018dc:	eb 0c                	jmp    8018ea <strsplit+0x31>
			*string++ = 0;
  8018de:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e1:	8d 50 01             	lea    0x1(%eax),%edx
  8018e4:	89 55 08             	mov    %edx,0x8(%ebp)
  8018e7:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ed:	8a 00                	mov    (%eax),%al
  8018ef:	84 c0                	test   %al,%al
  8018f1:	74 18                	je     80190b <strsplit+0x52>
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	8a 00                	mov    (%eax),%al
  8018f8:	0f be c0             	movsbl %al,%eax
  8018fb:	50                   	push   %eax
  8018fc:	ff 75 0c             	pushl  0xc(%ebp)
  8018ff:	e8 13 fb ff ff       	call   801417 <strchr>
  801904:	83 c4 08             	add    $0x8,%esp
  801907:	85 c0                	test   %eax,%eax
  801909:	75 d3                	jne    8018de <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  80190b:	8b 45 08             	mov    0x8(%ebp),%eax
  80190e:	8a 00                	mov    (%eax),%al
  801910:	84 c0                	test   %al,%al
  801912:	74 5a                	je     80196e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  801914:	8b 45 14             	mov    0x14(%ebp),%eax
  801917:	8b 00                	mov    (%eax),%eax
  801919:	83 f8 0f             	cmp    $0xf,%eax
  80191c:	75 07                	jne    801925 <strsplit+0x6c>
		{
			return 0;
  80191e:	b8 00 00 00 00       	mov    $0x0,%eax
  801923:	eb 66                	jmp    80198b <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801925:	8b 45 14             	mov    0x14(%ebp),%eax
  801928:	8b 00                	mov    (%eax),%eax
  80192a:	8d 48 01             	lea    0x1(%eax),%ecx
  80192d:	8b 55 14             	mov    0x14(%ebp),%edx
  801930:	89 0a                	mov    %ecx,(%edx)
  801932:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801939:	8b 45 10             	mov    0x10(%ebp),%eax
  80193c:	01 c2                	add    %eax,%edx
  80193e:	8b 45 08             	mov    0x8(%ebp),%eax
  801941:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801943:	eb 03                	jmp    801948 <strsplit+0x8f>
			string++;
  801945:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801948:	8b 45 08             	mov    0x8(%ebp),%eax
  80194b:	8a 00                	mov    (%eax),%al
  80194d:	84 c0                	test   %al,%al
  80194f:	74 8b                	je     8018dc <strsplit+0x23>
  801951:	8b 45 08             	mov    0x8(%ebp),%eax
  801954:	8a 00                	mov    (%eax),%al
  801956:	0f be c0             	movsbl %al,%eax
  801959:	50                   	push   %eax
  80195a:	ff 75 0c             	pushl  0xc(%ebp)
  80195d:	e8 b5 fa ff ff       	call   801417 <strchr>
  801962:	83 c4 08             	add    $0x8,%esp
  801965:	85 c0                	test   %eax,%eax
  801967:	74 dc                	je     801945 <strsplit+0x8c>
			string++;
	}
  801969:	e9 6e ff ff ff       	jmp    8018dc <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80196e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80196f:	8b 45 14             	mov    0x14(%ebp),%eax
  801972:	8b 00                	mov    (%eax),%eax
  801974:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80197b:	8b 45 10             	mov    0x10(%ebp),%eax
  80197e:	01 d0                	add    %edx,%eax
  801980:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801986:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80198b:	c9                   	leave  
  80198c:	c3                   	ret    

0080198d <malloc>:
int cnt_mem = 0;
int heap_mem[size_uhmem] = { 0 };
struct hmem heap_size[size_uhmem] = { 0 };
int check = 0;

void* malloc(uint32 size) {
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
  801990:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyNEXTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	//NEXT FIT
	if (sys_isUHeapPlacementStrategyNEXTFIT()) {
  801996:	e8 7d 0f 00 00       	call   802918 <sys_isUHeapPlacementStrategyNEXTFIT>
  80199b:	85 c0                	test   %eax,%eax
  80199d:	0f 84 6f 03 00 00    	je     801d12 <malloc+0x385>
		size = ROUNDUP(size, PAGE_SIZE);
  8019a3:	c7 45 84 00 10 00 00 	movl   $0x1000,-0x7c(%ebp)
  8019aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8019ad:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8019b0:	01 d0                	add    %edx,%eax
  8019b2:	48                   	dec    %eax
  8019b3:	89 45 80             	mov    %eax,-0x80(%ebp)
  8019b6:	8b 45 80             	mov    -0x80(%ebp),%eax
  8019b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8019be:	f7 75 84             	divl   -0x7c(%ebp)
  8019c1:	8b 45 80             	mov    -0x80(%ebp),%eax
  8019c4:	29 d0                	sub    %edx,%eax
  8019c6:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  8019c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019cd:	74 09                	je     8019d8 <malloc+0x4b>
  8019cf:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8019d6:	76 0a                	jbe    8019e2 <malloc+0x55>
			return NULL;
  8019d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8019dd:	e9 4b 09 00 00       	jmp    80232d <malloc+0x9a0>
		}
		// first we can allocate by " Strategy Continues "
		if (ptr_uheap + size <= (uint32) USER_HEAP_MAX && !check) {
  8019e2:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	01 d0                	add    %edx,%eax
  8019ed:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8019f2:	0f 87 a2 00 00 00    	ja     801a9a <malloc+0x10d>
  8019f8:	a1 60 40 98 00       	mov    0x984060,%eax
  8019fd:	85 c0                	test   %eax,%eax
  8019ff:	0f 85 95 00 00 00    	jne    801a9a <malloc+0x10d>

			void* ret = (void *) ptr_uheap;
  801a05:	a1 04 40 80 00       	mov    0x804004,%eax
  801a0a:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			sys_allocateMem(ptr_uheap, size);
  801a10:	a1 04 40 80 00       	mov    0x804004,%eax
  801a15:	83 ec 08             	sub    $0x8,%esp
  801a18:	ff 75 08             	pushl  0x8(%ebp)
  801a1b:	50                   	push   %eax
  801a1c:	e8 a3 0b 00 00       	call   8025c4 <sys_allocateMem>
  801a21:	83 c4 10             	add    $0x10,%esp

			heap_size[cnt_mem].size = size;
  801a24:	a1 40 40 80 00       	mov    0x804040,%eax
  801a29:	8b 55 08             	mov    0x8(%ebp),%edx
  801a2c:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801a33:	a1 40 40 80 00       	mov    0x804040,%eax
  801a38:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801a3e:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
			cnt_mem++;
  801a45:	a1 40 40 80 00       	mov    0x804040,%eax
  801a4a:	40                   	inc    %eax
  801a4b:	a3 40 40 80 00       	mov    %eax,0x804040
			int i = 0;
  801a50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  801a57:	eb 2e                	jmp    801a87 <malloc+0xfa>
			{

				heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801a59:	a1 04 40 80 00       	mov    0x804004,%eax
  801a5e:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] = 1;
  801a63:	c1 e8 0c             	shr    $0xc,%eax
  801a66:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  801a6d:	01 00 00 00 

				ptr_uheap += (uint32) PAGE_SIZE;
  801a71:	a1 04 40 80 00       	mov    0x804004,%eax
  801a76:	05 00 10 00 00       	add    $0x1000,%eax
  801a7b:	a3 04 40 80 00       	mov    %eax,0x804004
			heap_size[cnt_mem].size = size;
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
			cnt_mem++;
			int i = 0;
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  801a80:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8a:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a8d:	72 ca                	jb     801a59 <malloc+0xcc>
						/ (uint32) PAGE_SIZE)] = 1;

				ptr_uheap += (uint32) PAGE_SIZE;
			}

			return ret;
  801a8f:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  801a95:	e9 93 08 00 00       	jmp    80232d <malloc+0x9a0>

		} else {
			// second we can allocate by " Strategy NEXTFIT "
			void* temp_end = NULL;
  801a9a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

			int check_start = 0;
  801aa1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			// check first that we used " Strategy Continues " before and not do it again and turn to NEXTFIT
			if (!check) {
  801aa8:	a1 60 40 98 00       	mov    0x984060,%eax
  801aad:	85 c0                	test   %eax,%eax
  801aaf:	75 1d                	jne    801ace <malloc+0x141>
				ptr_uheap = (uint32) USER_HEAP_START;
  801ab1:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  801ab8:	00 00 80 
				check = 1;
  801abb:	c7 05 60 40 98 00 01 	movl   $0x1,0x984060
  801ac2:	00 00 00 
				check_start = 1;// to dont use second loop CZ ptr_uheap start from USER_HEAP_START
  801ac5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  801acc:	eb 08                	jmp    801ad6 <malloc+0x149>
			} else {
				temp_end = (void*) ptr_uheap;
  801ace:	a1 04 40 80 00       	mov    0x804004,%eax
  801ad3:	89 45 f0             	mov    %eax,-0x10(%ebp)

			}

			uint32 sz = 0;
  801ad6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
			int f = 0;
  801add:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			uint32 ptr = ptr_uheap;
  801ae4:	a1 04 40 80 00       	mov    0x804004,%eax
  801ae9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  801aec:	eb 4d                	jmp    801b3b <malloc+0x1ae>
				if (sz == size) {
  801aee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801af1:	3b 45 08             	cmp    0x8(%ebp),%eax
  801af4:	75 09                	jne    801aff <malloc+0x172>
					f = 1;
  801af6:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  801afd:	eb 45                	jmp    801b44 <malloc+0x1b7>
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801aff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b02:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] == 0) {
  801b07:	c1 e8 0c             	shr    $0xc,%eax
			while (ptr < (uint32) USER_HEAP_MAX) {
				if (sz == size) {
					f = 1;
					break;
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801b0a:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  801b11:	85 c0                	test   %eax,%eax
  801b13:	75 10                	jne    801b25 <malloc+0x198>
						/ (uint32) PAGE_SIZE)] == 0) {

					sz += PAGE_SIZE;
  801b15:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
					ptr += PAGE_SIZE;
  801b1c:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  801b23:	eb 16                	jmp    801b3b <malloc+0x1ae>
				} else {
					sz = 0;
  801b25:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
					ptr += PAGE_SIZE;
  801b2c:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
					ptr_uheap = ptr;
  801b33:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b36:	a3 04 40 80 00       	mov    %eax,0x804004

			uint32 sz = 0;
			int f = 0;
			uint32 ptr = ptr_uheap;
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  801b3b:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  801b42:	76 aa                	jbe    801aee <malloc+0x161>
					ptr_uheap = ptr;
				}

			}

			if (f) {
  801b44:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b48:	0f 84 95 00 00 00    	je     801be3 <malloc+0x256>

				void* ret = (void *) ptr_uheap;
  801b4e:	a1 04 40 80 00       	mov    0x804004,%eax
  801b53:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

				sys_allocateMem(ptr_uheap, size);
  801b59:	a1 04 40 80 00       	mov    0x804004,%eax
  801b5e:	83 ec 08             	sub    $0x8,%esp
  801b61:	ff 75 08             	pushl  0x8(%ebp)
  801b64:	50                   	push   %eax
  801b65:	e8 5a 0a 00 00       	call   8025c4 <sys_allocateMem>
  801b6a:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  801b6d:	a1 40 40 80 00       	mov    0x804040,%eax
  801b72:	8b 55 08             	mov    0x8(%ebp),%edx
  801b75:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801b7c:	a1 40 40 80 00       	mov    0x804040,%eax
  801b81:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b87:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
				cnt_mem++;
  801b8e:	a1 40 40 80 00       	mov    0x804040,%eax
  801b93:	40                   	inc    %eax
  801b94:	a3 40 40 80 00       	mov    %eax,0x804040
				int i = 0;
  801b99:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801ba0:	eb 2e                	jmp    801bd0 <malloc+0x243>
				{

					heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801ba2:	a1 04 40 80 00       	mov    0x804004,%eax
  801ba7:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  801bac:	c1 e8 0c             	shr    $0xc,%eax
  801baf:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  801bb6:	01 00 00 00 

					ptr_uheap += (uint32) PAGE_SIZE;
  801bba:	a1 04 40 80 00       	mov    0x804004,%eax
  801bbf:	05 00 10 00 00       	add    $0x1000,%eax
  801bc4:	a3 04 40 80 00       	mov    %eax,0x804004
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
				cnt_mem++;
				int i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801bc9:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801bd0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801bd3:	3b 45 08             	cmp    0x8(%ebp),%eax
  801bd6:	72 ca                	jb     801ba2 <malloc+0x215>
							/ (uint32) PAGE_SIZE)] = 1;

					ptr_uheap += (uint32) PAGE_SIZE;
				}

				return ret;
  801bd8:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  801bde:	e9 4a 07 00 00       	jmp    80232d <malloc+0x9a0>

			} else {

				if (check_start) {
  801be3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801be7:	74 0a                	je     801bf3 <malloc+0x266>

					return NULL;
  801be9:	b8 00 00 00 00       	mov    $0x0,%eax
  801bee:	e9 3a 07 00 00       	jmp    80232d <malloc+0x9a0>
				}

//////////////back loop////////////////

				uint32 sz = 0;
  801bf3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
				int f = 0;
  801bfa:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				uint32 ptr = USER_HEAP_START;
  801c01:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
				ptr_uheap = USER_HEAP_START;
  801c08:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  801c0f:	00 00 80 
				while (ptr < (uint32) temp_end) {
  801c12:	eb 4d                	jmp    801c61 <malloc+0x2d4>
					if (sz == size) {
  801c14:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c17:	3b 45 08             	cmp    0x8(%ebp),%eax
  801c1a:	75 09                	jne    801c25 <malloc+0x298>
						f = 1;
  801c1c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
						break;
  801c23:	eb 44                	jmp    801c69 <malloc+0x2dc>
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801c25:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801c28:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] == 0) {
  801c2d:	c1 e8 0c             	shr    $0xc,%eax
				while (ptr < (uint32) temp_end) {
					if (sz == size) {
						f = 1;
						break;
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801c30:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  801c37:	85 c0                	test   %eax,%eax
  801c39:	75 10                	jne    801c4b <malloc+0x2be>
							/ (uint32) PAGE_SIZE)] == 0) {

						sz += PAGE_SIZE;
  801c3b:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801c42:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
  801c49:	eb 16                	jmp    801c61 <malloc+0x2d4>
					} else {
						sz = 0;
  801c4b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801c52:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
						ptr_uheap = ptr;
  801c59:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801c5c:	a3 04 40 80 00       	mov    %eax,0x804004

				uint32 sz = 0;
				int f = 0;
				uint32 ptr = USER_HEAP_START;
				ptr_uheap = USER_HEAP_START;
				while (ptr < (uint32) temp_end) {
  801c61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c64:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801c67:	72 ab                	jb     801c14 <malloc+0x287>
						ptr_uheap = ptr;
					}

				}

				if (f) {
  801c69:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801c6d:	0f 84 95 00 00 00    	je     801d08 <malloc+0x37b>

					void* ret = (void *) ptr_uheap;
  801c73:	a1 04 40 80 00       	mov    0x804004,%eax
  801c78:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

					sys_allocateMem(ptr_uheap, size);
  801c7e:	a1 04 40 80 00       	mov    0x804004,%eax
  801c83:	83 ec 08             	sub    $0x8,%esp
  801c86:	ff 75 08             	pushl  0x8(%ebp)
  801c89:	50                   	push   %eax
  801c8a:	e8 35 09 00 00       	call   8025c4 <sys_allocateMem>
  801c8f:	83 c4 10             	add    $0x10,%esp

					heap_size[cnt_mem].size = size;
  801c92:	a1 40 40 80 00       	mov    0x804040,%eax
  801c97:	8b 55 08             	mov    0x8(%ebp),%edx
  801c9a:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801ca1:	a1 40 40 80 00       	mov    0x804040,%eax
  801ca6:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801cac:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
					cnt_mem++;
  801cb3:	a1 40 40 80 00       	mov    0x804040,%eax
  801cb8:	40                   	inc    %eax
  801cb9:	a3 40 40 80 00       	mov    %eax,0x804040
					int i = 0;
  801cbe:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

					for (; i < size; i += PAGE_SIZE)
  801cc5:	eb 2e                	jmp    801cf5 <malloc+0x368>
					{

						heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801cc7:	a1 04 40 80 00       	mov    0x804004,%eax
  801ccc:	05 00 00 00 80       	add    $0x80000000,%eax
								/ (uint32) PAGE_SIZE)] = 1;
  801cd1:	c1 e8 0c             	shr    $0xc,%eax
  801cd4:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  801cdb:	01 00 00 00 

						ptr_uheap += (uint32) PAGE_SIZE;
  801cdf:	a1 04 40 80 00       	mov    0x804004,%eax
  801ce4:	05 00 10 00 00       	add    $0x1000,%eax
  801ce9:	a3 04 40 80 00       	mov    %eax,0x804004
					heap_size[cnt_mem].size = size;
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
					cnt_mem++;
					int i = 0;

					for (; i < size; i += PAGE_SIZE)
  801cee:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  801cf5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801cf8:	3b 45 08             	cmp    0x8(%ebp),%eax
  801cfb:	72 ca                	jb     801cc7 <malloc+0x33a>
								/ (uint32) PAGE_SIZE)] = 1;

						ptr_uheap += (uint32) PAGE_SIZE;
					}

					return ret;
  801cfd:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801d03:	e9 25 06 00 00       	jmp    80232d <malloc+0x9a0>

				} else {

					return NULL;
  801d08:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0d:	e9 1b 06 00 00       	jmp    80232d <malloc+0x9a0>

		}

	}

	else if (sys_isUHeapPlacementStrategyBESTFIT()) {
  801d12:	e8 d0 0b 00 00       	call   8028e7 <sys_isUHeapPlacementStrategyBESTFIT>
  801d17:	85 c0                	test   %eax,%eax
  801d19:	0f 84 ba 01 00 00    	je     801ed9 <malloc+0x54c>

		size = ROUNDUP(size, PAGE_SIZE);
  801d1f:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  801d26:	10 00 00 
  801d29:	8b 55 08             	mov    0x8(%ebp),%edx
  801d2c:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  801d32:	01 d0                	add    %edx,%eax
  801d34:	48                   	dec    %eax
  801d35:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  801d3b:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801d41:	ba 00 00 00 00       	mov    $0x0,%edx
  801d46:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  801d4c:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801d52:	29 d0                	sub    %edx,%eax
  801d54:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801d57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d5b:	74 09                	je     801d66 <malloc+0x3d9>
  801d5d:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801d64:	76 0a                	jbe    801d70 <malloc+0x3e3>
			return NULL;
  801d66:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6b:	e9 bd 05 00 00       	jmp    80232d <malloc+0x9a0>
		}
		uint32 ptr = (uint32) USER_HEAP_START;
  801d70:	c7 45 c8 00 00 00 80 	movl   $0x80000000,-0x38(%ebp)
		uint32 temp = 0;
  801d77:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		uint32 min_sz = size_uhmem + 1;
  801d7e:	c7 45 c0 01 00 02 00 	movl   $0x20001,-0x40(%ebp)
		uint32 count = 0;
  801d85:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
		int i = 0;
  801d8c:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801d93:	8b 45 08             	mov    0x8(%ebp),%eax
  801d96:	c1 e8 0c             	shr    $0xc,%eax
  801d99:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801d9f:	e9 80 00 00 00       	jmp    801e24 <malloc+0x497>

			if (heap_mem[i] == 0) {
  801da4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801da7:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  801dae:	85 c0                	test   %eax,%eax
  801db0:	75 0c                	jne    801dbe <malloc+0x431>

				count++;
  801db2:	ff 45 bc             	incl   -0x44(%ebp)
				ptr += PAGE_SIZE;
  801db5:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801dbc:	eb 2d                	jmp    801deb <malloc+0x45e>
			} else {
				if (num_p <= count && min_sz > count) {
  801dbe:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801dc4:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801dc7:	77 14                	ja     801ddd <malloc+0x450>
  801dc9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801dcc:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801dcf:	76 0c                	jbe    801ddd <malloc+0x450>

					min_sz = count;
  801dd1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801dd4:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801dd7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801dda:	89 45 c4             	mov    %eax,-0x3c(%ebp)

				}
				count = 0;
  801ddd:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
				ptr += PAGE_SIZE;
  801de4:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
			}

			if (i == size_uhmem - 1) {
  801deb:	81 7d b8 ff ff 01 00 	cmpl   $0x1ffff,-0x48(%ebp)
  801df2:	75 2d                	jne    801e21 <malloc+0x494>

				if (num_p <= count && min_sz > count) {
  801df4:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801dfa:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801dfd:	77 22                	ja     801e21 <malloc+0x494>
  801dff:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e02:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801e05:	76 1a                	jbe    801e21 <malloc+0x494>

					min_sz = count;
  801e07:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801e0a:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801e0d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801e10:	89 45 c4             	mov    %eax,-0x3c(%ebp)
					count = 0;
  801e13:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
					ptr += PAGE_SIZE;
  801e1a:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801e21:	ff 45 b8             	incl   -0x48(%ebp)
  801e24:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801e27:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801e2c:	0f 86 72 ff ff ff    	jbe    801da4 <malloc+0x417>

			}

		}

		if (num_p > min_sz || temp == 0) {
  801e32:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801e38:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  801e3b:	77 06                	ja     801e43 <malloc+0x4b6>
  801e3d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801e41:	75 0a                	jne    801e4d <malloc+0x4c0>
			return NULL;
  801e43:	b8 00 00 00 00       	mov    $0x0,%eax
  801e48:	e9 e0 04 00 00       	jmp    80232d <malloc+0x9a0>

		}

		temp = temp - (PAGE_SIZE * min_sz);
  801e4d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e50:	c1 e0 0c             	shl    $0xc,%eax
  801e53:	29 45 c4             	sub    %eax,-0x3c(%ebp)
		void* ret = (void*) temp;
  801e56:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801e59:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)

		sys_allocateMem(temp, size);
  801e5f:	83 ec 08             	sub    $0x8,%esp
  801e62:	ff 75 08             	pushl  0x8(%ebp)
  801e65:	ff 75 c4             	pushl  -0x3c(%ebp)
  801e68:	e8 57 07 00 00       	call   8025c4 <sys_allocateMem>
  801e6d:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801e70:	a1 40 40 80 00       	mov    0x804040,%eax
  801e75:	8b 55 08             	mov    0x8(%ebp),%edx
  801e78:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801e7f:	a1 40 40 80 00       	mov    0x804040,%eax
  801e84:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801e87:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
		cnt_mem++;
  801e8e:	a1 40 40 80 00       	mov    0x804040,%eax
  801e93:	40                   	inc    %eax
  801e94:	a3 40 40 80 00       	mov    %eax,0x804040
		i = 0;
  801e99:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801ea0:	eb 24                	jmp    801ec6 <malloc+0x539>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801ea2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801ea5:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801eaa:	c1 e8 0c             	shr    $0xc,%eax
  801ead:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  801eb4:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801eb8:	81 45 c4 00 10 00 00 	addl   $0x1000,-0x3c(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801ebf:	81 45 b8 00 10 00 00 	addl   $0x1000,-0x48(%ebp)
  801ec6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801ec9:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ecc:	72 d4                	jb     801ea2 <malloc+0x515>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801ece:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801ed4:	e9 54 04 00 00       	jmp    80232d <malloc+0x9a0>

	} else if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801ed9:	e8 d8 09 00 00       	call   8028b6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ede:	85 c0                	test   %eax,%eax
  801ee0:	0f 84 88 01 00 00    	je     80206e <malloc+0x6e1>

		size = ROUNDUP(size, PAGE_SIZE);
  801ee6:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  801eed:	10 00 00 
  801ef0:	8b 55 08             	mov    0x8(%ebp),%edx
  801ef3:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  801ef9:	01 d0                	add    %edx,%eax
  801efb:	48                   	dec    %eax
  801efc:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  801f02:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801f08:	ba 00 00 00 00       	mov    $0x0,%edx
  801f0d:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  801f13:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801f19:	29 d0                	sub    %edx,%eax
  801f1b:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801f1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f22:	74 09                	je     801f2d <malloc+0x5a0>
  801f24:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801f2b:	76 0a                	jbe    801f37 <malloc+0x5aa>
			return NULL;
  801f2d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f32:	e9 f6 03 00 00       	jmp    80232d <malloc+0x9a0>
		}

		uint32 ptr = (uint32) USER_HEAP_START;
  801f37:	c7 45 b4 00 00 00 80 	movl   $0x80000000,-0x4c(%ebp)
		uint32 temp = 0;
  801f3e:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
		uint32 found = 0;
  801f45:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		uint32 count = 0;
  801f4c:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
		int i = 0;
  801f53:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5d:	c1 e8 0c             	shr    $0xc,%eax
  801f60:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

		for (; i < size_uhmem; i++) {
  801f66:	eb 5a                	jmp    801fc2 <malloc+0x635>

			if (heap_mem[i] == 0) {
  801f68:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801f6b:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  801f72:	85 c0                	test   %eax,%eax
  801f74:	75 0c                	jne    801f82 <malloc+0x5f5>

				count++;
  801f76:	ff 45 a8             	incl   -0x58(%ebp)
				ptr += PAGE_SIZE;
  801f79:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
  801f80:	eb 22                	jmp    801fa4 <malloc+0x617>
			} else {
				if (num_p <= count) {
  801f82:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801f88:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801f8b:	77 09                	ja     801f96 <malloc+0x609>

					found = 1;
  801f8d:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)

					break;
  801f94:	eb 36                	jmp    801fcc <malloc+0x63f>
				}
				count = 0;
  801f96:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
				ptr += PAGE_SIZE;
  801f9d:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
			}

			if (i == size_uhmem - 1) {
  801fa4:	81 7d a4 ff ff 01 00 	cmpl   $0x1ffff,-0x5c(%ebp)
  801fab:	75 12                	jne    801fbf <malloc+0x632>

				if (num_p <= count) {
  801fad:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801fb3:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801fb6:	77 07                	ja     801fbf <malloc+0x632>

					found = 1;
  801fb8:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
		uint32 found = 0;
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		for (; i < size_uhmem; i++) {
  801fbf:	ff 45 a4             	incl   -0x5c(%ebp)
  801fc2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801fc5:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801fca:	76 9c                	jbe    801f68 <malloc+0x5db>

			}

		}

		if (!found) {
  801fcc:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  801fd0:	75 0a                	jne    801fdc <malloc+0x64f>
			return NULL;
  801fd2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd7:	e9 51 03 00 00       	jmp    80232d <malloc+0x9a0>

		}

		temp = ptr;
  801fdc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801fdf:	89 45 b0             	mov    %eax,-0x50(%ebp)
		temp = temp - (PAGE_SIZE * count);
  801fe2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801fe5:	c1 e0 0c             	shl    $0xc,%eax
  801fe8:	29 45 b0             	sub    %eax,-0x50(%ebp)
		void* ret = (void*) temp;
  801feb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801fee:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)

		sys_allocateMem(temp, size);
  801ff4:	83 ec 08             	sub    $0x8,%esp
  801ff7:	ff 75 08             	pushl  0x8(%ebp)
  801ffa:	ff 75 b0             	pushl  -0x50(%ebp)
  801ffd:	e8 c2 05 00 00       	call   8025c4 <sys_allocateMem>
  802002:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  802005:	a1 40 40 80 00       	mov    0x804040,%eax
  80200a:	8b 55 08             	mov    0x8(%ebp),%edx
  80200d:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  802014:	a1 40 40 80 00       	mov    0x804040,%eax
  802019:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80201c:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
		cnt_mem++;
  802023:	a1 40 40 80 00       	mov    0x804040,%eax
  802028:	40                   	inc    %eax
  802029:	a3 40 40 80 00       	mov    %eax,0x804040
		i = 0;
  80202e:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  802035:	eb 24                	jmp    80205b <malloc+0x6ce>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  802037:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80203a:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  80203f:	c1 e8 0c             	shr    $0xc,%eax
  802042:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  802049:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  80204d:	81 45 b0 00 10 00 00 	addl   $0x1000,-0x50(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  802054:	81 45 a4 00 10 00 00 	addl   $0x1000,-0x5c(%ebp)
  80205b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80205e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802061:	72 d4                	jb     802037 <malloc+0x6aa>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  802063:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  802069:	e9 bf 02 00 00       	jmp    80232d <malloc+0x9a0>

	}
	else if(sys_isUHeapPlacementStrategyWORSTFIT())
  80206e:	e8 d6 08 00 00       	call   802949 <sys_isUHeapPlacementStrategyWORSTFIT>
  802073:	85 c0                	test   %eax,%eax
  802075:	0f 84 ba 01 00 00    	je     802235 <malloc+0x8a8>
	{
		size = ROUNDUP(size, PAGE_SIZE);
  80207b:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  802082:	10 00 00 
  802085:	8b 55 08             	mov    0x8(%ebp),%edx
  802088:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  80208e:	01 d0                	add    %edx,%eax
  802090:	48                   	dec    %eax
  802091:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  802097:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  80209d:	ba 00 00 00 00       	mov    $0x0,%edx
  8020a2:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  8020a8:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  8020ae:	29 d0                	sub    %edx,%eax
  8020b0:	89 45 08             	mov    %eax,0x8(%ebp)

				if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  8020b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020b7:	74 09                	je     8020c2 <malloc+0x735>
  8020b9:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8020c0:	76 0a                	jbe    8020cc <malloc+0x73f>
					return NULL;
  8020c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c7:	e9 61 02 00 00       	jmp    80232d <malloc+0x9a0>
				}
				uint32 ptr = (uint32) USER_HEAP_START;
  8020cc:	c7 45 a0 00 00 00 80 	movl   $0x80000000,-0x60(%ebp)
				uint32 temp = 0;
  8020d3:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
				uint32 max_sz = -1;
  8020da:	c7 45 98 ff ff ff ff 	movl   $0xffffffff,-0x68(%ebp)
				uint32 count = 0;
  8020e1:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
				int i = 0;
  8020e8:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				uint32 num_p = size / PAGE_SIZE;
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	c1 e8 0c             	shr    $0xc,%eax
  8020f5:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  8020fb:	e9 80 00 00 00       	jmp    802180 <malloc+0x7f3>

					if (heap_mem[i] == 0) {
  802100:	8b 45 90             	mov    -0x70(%ebp),%eax
  802103:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  80210a:	85 c0                	test   %eax,%eax
  80210c:	75 0c                	jne    80211a <malloc+0x78d>

						count++;
  80210e:	ff 45 94             	incl   -0x6c(%ebp)
						ptr += PAGE_SIZE;
  802111:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
  802118:	eb 2d                	jmp    802147 <malloc+0x7ba>
					} else {
						if (num_p <= count && max_sz < count) {
  80211a:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  802120:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  802123:	77 14                	ja     802139 <malloc+0x7ac>
  802125:	8b 45 98             	mov    -0x68(%ebp),%eax
  802128:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  80212b:	73 0c                	jae    802139 <malloc+0x7ac>

							max_sz = count;
  80212d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802130:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  802133:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802136:	89 45 9c             	mov    %eax,-0x64(%ebp)

						}
						count = 0;
  802139:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
						ptr += PAGE_SIZE;
  802140:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
					}

					if (i == size_uhmem - 1) {
  802147:	81 7d 90 ff ff 01 00 	cmpl   $0x1ffff,-0x70(%ebp)
  80214e:	75 2d                	jne    80217d <malloc+0x7f0>

						if (num_p <= count && max_sz > count) {
  802150:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  802156:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  802159:	77 22                	ja     80217d <malloc+0x7f0>
  80215b:	8b 45 98             	mov    -0x68(%ebp),%eax
  80215e:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  802161:	76 1a                	jbe    80217d <malloc+0x7f0>

							max_sz = count;
  802163:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802166:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  802169:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80216c:	89 45 9c             	mov    %eax,-0x64(%ebp)
							count = 0;
  80216f:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
							ptr += PAGE_SIZE;
  802176:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
				uint32 count = 0;
				int i = 0;
				uint32 num_p = size / PAGE_SIZE;

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  80217d:	ff 45 90             	incl   -0x70(%ebp)
  802180:	8b 45 90             	mov    -0x70(%ebp),%eax
  802183:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  802188:	0f 86 72 ff ff ff    	jbe    802100 <malloc+0x773>

					}

				}

				if (num_p > max_sz || temp == 0) {
  80218e:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  802194:	3b 45 98             	cmp    -0x68(%ebp),%eax
  802197:	77 06                	ja     80219f <malloc+0x812>
  802199:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  80219d:	75 0a                	jne    8021a9 <malloc+0x81c>
					return NULL;
  80219f:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a4:	e9 84 01 00 00       	jmp    80232d <malloc+0x9a0>

				}

				temp = temp - (PAGE_SIZE * max_sz);
  8021a9:	8b 45 98             	mov    -0x68(%ebp),%eax
  8021ac:	c1 e0 0c             	shl    $0xc,%eax
  8021af:	29 45 9c             	sub    %eax,-0x64(%ebp)
				void* ret = (void*) temp;
  8021b2:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8021b5:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

				sys_allocateMem(temp, size);
  8021bb:	83 ec 08             	sub    $0x8,%esp
  8021be:	ff 75 08             	pushl  0x8(%ebp)
  8021c1:	ff 75 9c             	pushl  -0x64(%ebp)
  8021c4:	e8 fb 03 00 00       	call   8025c4 <sys_allocateMem>
  8021c9:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  8021cc:	a1 40 40 80 00       	mov    0x804040,%eax
  8021d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d4:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
				heap_size[cnt_mem].vir = (void*) temp;
  8021db:	a1 40 40 80 00       	mov    0x804040,%eax
  8021e0:	8b 55 9c             	mov    -0x64(%ebp),%edx
  8021e3:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
				cnt_mem++;
  8021ea:	a1 40 40 80 00       	mov    0x804040,%eax
  8021ef:	40                   	inc    %eax
  8021f0:	a3 40 40 80 00       	mov    %eax,0x804040
				i = 0;
  8021f5:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  8021fc:	eb 24                	jmp    802222 <malloc+0x895>
				{

					heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  8021fe:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802201:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  802206:	c1 e8 0c             	shr    $0xc,%eax
  802209:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  802210:	01 00 00 00 

					temp += (uint32) PAGE_SIZE;
  802214:	81 45 9c 00 10 00 00 	addl   $0x1000,-0x64(%ebp)
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) temp;
				cnt_mem++;
				i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  80221b:	81 45 90 00 10 00 00 	addl   $0x1000,-0x70(%ebp)
  802222:	8b 45 90             	mov    -0x70(%ebp),%eax
  802225:	3b 45 08             	cmp    0x8(%ebp),%eax
  802228:	72 d4                	jb     8021fe <malloc+0x871>

					temp += (uint32) PAGE_SIZE;
				}

				//cprintf("\n size = %d.........vir= %d  \n",num_p,((uint32) ret-USER_HEAP_START)/PAGE_SIZE);
				return ret;
  80222a:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  802230:	e9 f8 00 00 00       	jmp    80232d <malloc+0x9a0>

	}
// this is to make malloc is work
	void* ret = NULL;
  802235:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
	size = ROUNDUP(size, PAGE_SIZE);
  80223c:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  802243:	10 00 00 
  802246:	8b 55 08             	mov    0x8(%ebp),%edx
  802249:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  80224f:	01 d0                	add    %edx,%eax
  802251:	48                   	dec    %eax
  802252:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  802258:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  80225e:	ba 00 00 00 00       	mov    $0x0,%edx
  802263:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  802269:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  80226f:	29 d0                	sub    %edx,%eax
  802271:	89 45 08             	mov    %eax,0x8(%ebp)

	if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  802274:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802278:	74 09                	je     802283 <malloc+0x8f6>
  80227a:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  802281:	76 0a                	jbe    80228d <malloc+0x900>
		return NULL;
  802283:	b8 00 00 00 00       	mov    $0x0,%eax
  802288:	e9 a0 00 00 00       	jmp    80232d <malloc+0x9a0>
	}

	if (ptr_uheap + size <= (uint32) USER_HEAP_MAX) {
  80228d:	8b 15 04 40 80 00    	mov    0x804004,%edx
  802293:	8b 45 08             	mov    0x8(%ebp),%eax
  802296:	01 d0                	add    %edx,%eax
  802298:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80229d:	0f 87 87 00 00 00    	ja     80232a <malloc+0x99d>

		ret = (void *) ptr_uheap;
  8022a3:	a1 04 40 80 00       	mov    0x804004,%eax
  8022a8:	89 45 8c             	mov    %eax,-0x74(%ebp)
		sys_allocateMem(ptr_uheap, size);
  8022ab:	a1 04 40 80 00       	mov    0x804004,%eax
  8022b0:	83 ec 08             	sub    $0x8,%esp
  8022b3:	ff 75 08             	pushl  0x8(%ebp)
  8022b6:	50                   	push   %eax
  8022b7:	e8 08 03 00 00       	call   8025c4 <sys_allocateMem>
  8022bc:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  8022bf:	a1 40 40 80 00       	mov    0x804040,%eax
  8022c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8022c7:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8022ce:	a1 40 40 80 00       	mov    0x804040,%eax
  8022d3:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8022d9:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
		cnt_mem++;
  8022e0:	a1 40 40 80 00       	mov    0x804040,%eax
  8022e5:	40                   	inc    %eax
  8022e6:	a3 40 40 80 00       	mov    %eax,0x804040
		int i = 0;
  8022eb:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)

		for (; i < size; i += PAGE_SIZE)
  8022f2:	eb 2e                	jmp    802322 <malloc+0x995>
		{

			heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8022f4:	a1 04 40 80 00       	mov    0x804004,%eax
  8022f9:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  8022fe:	c1 e8 0c             	shr    $0xc,%eax
  802301:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  802308:	01 00 00 00 

			ptr_uheap += (uint32) PAGE_SIZE;
  80230c:	a1 04 40 80 00       	mov    0x804004,%eax
  802311:	05 00 10 00 00       	add    $0x1000,%eax
  802316:	a3 04 40 80 00       	mov    %eax,0x804004
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
		cnt_mem++;
		int i = 0;

		for (; i < size; i += PAGE_SIZE)
  80231b:	81 45 88 00 10 00 00 	addl   $0x1000,-0x78(%ebp)
  802322:	8b 45 88             	mov    -0x78(%ebp),%eax
  802325:	3b 45 08             	cmp    0x8(%ebp),%eax
  802328:	72 ca                	jb     8022f4 <malloc+0x967>
					/ (uint32) PAGE_SIZE)] = 1;

			ptr_uheap += (uint32) PAGE_SIZE;
		}
	}
	return ret;
  80232a:	8b 45 8c             	mov    -0x74(%ebp),%eax

	//TODO: [PROJECT 2016 - BONUS2] Apply FIRST FIT and WORST FIT policies

//return 0;

}
  80232d:	c9                   	leave  
  80232e:	c3                   	ret    

0080232f <free>:
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address) {
  80232f:	55                   	push   %ebp
  802330:	89 e5                	mov    %esp,%ebp
  802332:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
  802335:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; inx < cnt_mem; inx++) {
  80233c:	e9 c1 00 00 00       	jmp    802402 <free+0xd3>
		if (heap_size[inx].vir == virtual_address) {
  802341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802344:	8b 04 c5 60 40 88 00 	mov    0x884060(,%eax,8),%eax
  80234b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80234e:	0f 85 ab 00 00 00    	jne    8023ff <free+0xd0>

			if (heap_size[inx].size == 0) {
  802354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802357:	8b 04 c5 64 40 88 00 	mov    0x884064(,%eax,8),%eax
  80235e:	85 c0                	test   %eax,%eax
  802360:	75 21                	jne    802383 <free+0x54>
				heap_size[inx].size = 0;
  802362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802365:	c7 04 c5 64 40 88 00 	movl   $0x0,0x884064(,%eax,8)
  80236c:	00 00 00 00 
				heap_size[inx].vir = NULL;
  802370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802373:	c7 04 c5 60 40 88 00 	movl   $0x0,0x884060(,%eax,8)
  80237a:	00 00 00 00 
				return;
  80237e:	e9 8d 00 00 00       	jmp    802410 <free+0xe1>

			}

			sys_freeMem((uint32) virtual_address, heap_size[inx].size);
  802383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802386:	8b 14 c5 64 40 88 00 	mov    0x884064(,%eax,8),%edx
  80238d:	8b 45 08             	mov    0x8(%ebp),%eax
  802390:	83 ec 08             	sub    $0x8,%esp
  802393:	52                   	push   %edx
  802394:	50                   	push   %eax
  802395:	e8 0e 02 00 00       	call   8025a8 <sys_freeMem>
  80239a:	83 c4 10             	add    $0x10,%esp

			int i = 0;
  80239d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
  8023a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  8023aa:	eb 24                	jmp    8023d0 <free+0xa1>
			{
				heap_mem[(int) (((uint32) va - USER_HEAP_START) / PAGE_SIZE)] =
  8023ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023af:	05 00 00 00 80       	add    $0x80000000,%eax
  8023b4:	c1 e8 0c             	shr    $0xc,%eax
  8023b7:	c7 04 85 60 40 80 00 	movl   $0x0,0x804060(,%eax,4)
  8023be:	00 00 00 00 
						0;

				va += PAGE_SIZE;
  8023c2:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
			sys_freeMem((uint32) virtual_address, heap_size[inx].size);

			int i = 0;
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  8023c9:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  8023d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d3:	8b 14 c5 64 40 88 00 	mov    0x884064(,%eax,8),%edx
  8023da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023dd:	39 c2                	cmp    %eax,%edx
  8023df:	77 cb                	ja     8023ac <free+0x7d>

				va += PAGE_SIZE;

			}

			heap_size[inx].size = 0;
  8023e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e4:	c7 04 c5 64 40 88 00 	movl   $0x0,0x884064(,%eax,8)
  8023eb:	00 00 00 00 
			heap_size[inx].vir = NULL;
  8023ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f2:	c7 04 c5 60 40 88 00 	movl   $0x0,0x884060(,%eax,8)
  8023f9:	00 00 00 00 
			break;
  8023fd:	eb 11                	jmp    802410 <free+0xe1>
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
	for (; inx < cnt_mem; inx++) {
  8023ff:	ff 45 f4             	incl   -0xc(%ebp)
  802402:	a1 40 40 80 00       	mov    0x804040,%eax
  802407:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  80240a:	0f 8c 31 ff ff ff    	jl     802341 <free+0x12>
	}

	//get the size of the given allocation using its address
	//you need to call sys_freeMem()

}
  802410:	c9                   	leave  
  802411:	c3                   	ret    

00802412 <realloc>:
//  Hint: you may need to use the sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size) {
  802412:	55                   	push   %ebp
  802413:	89 e5                	mov    %esp,%ebp
  802415:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2016 - BONUS4] realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802418:	83 ec 04             	sub    $0x4,%esp
  80241b:	68 44 32 80 00       	push   $0x803244
  802420:	68 1c 02 00 00       	push   $0x21c
  802425:	68 6a 32 80 00       	push   $0x80326a
  80242a:	e8 aa e4 ff ff       	call   8008d9 <_panic>

0080242f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80242f:	55                   	push   %ebp
  802430:	89 e5                	mov    %esp,%ebp
  802432:	57                   	push   %edi
  802433:	56                   	push   %esi
  802434:	53                   	push   %ebx
  802435:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802438:	8b 45 08             	mov    0x8(%ebp),%eax
  80243b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80243e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802441:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802444:	8b 7d 18             	mov    0x18(%ebp),%edi
  802447:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80244a:	cd 30                	int    $0x30
  80244c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80244f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802452:	83 c4 10             	add    $0x10,%esp
  802455:	5b                   	pop    %ebx
  802456:	5e                   	pop    %esi
  802457:	5f                   	pop    %edi
  802458:	5d                   	pop    %ebp
  802459:	c3                   	ret    

0080245a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  80245d:	8b 45 08             	mov    0x8(%ebp),%eax
  802460:	6a 00                	push   $0x0
  802462:	6a 00                	push   $0x0
  802464:	6a 00                	push   $0x0
  802466:	ff 75 0c             	pushl  0xc(%ebp)
  802469:	50                   	push   %eax
  80246a:	6a 00                	push   $0x0
  80246c:	e8 be ff ff ff       	call   80242f <syscall>
  802471:	83 c4 18             	add    $0x18,%esp
}
  802474:	90                   	nop
  802475:	c9                   	leave  
  802476:	c3                   	ret    

00802477 <sys_cgetc>:

int
sys_cgetc(void)
{
  802477:	55                   	push   %ebp
  802478:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80247a:	6a 00                	push   $0x0
  80247c:	6a 00                	push   $0x0
  80247e:	6a 00                	push   $0x0
  802480:	6a 00                	push   $0x0
  802482:	6a 00                	push   $0x0
  802484:	6a 01                	push   $0x1
  802486:	e8 a4 ff ff ff       	call   80242f <syscall>
  80248b:	83 c4 18             	add    $0x18,%esp
}
  80248e:	c9                   	leave  
  80248f:	c3                   	ret    

00802490 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  802490:	55                   	push   %ebp
  802491:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  802493:	8b 45 08             	mov    0x8(%ebp),%eax
  802496:	6a 00                	push   $0x0
  802498:	6a 00                	push   $0x0
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	50                   	push   %eax
  80249f:	6a 03                	push   $0x3
  8024a1:	e8 89 ff ff ff       	call   80242f <syscall>
  8024a6:	83 c4 18             	add    $0x18,%esp
}
  8024a9:	c9                   	leave  
  8024aa:	c3                   	ret    

008024ab <sys_getenvid>:

int32 sys_getenvid(void)
{
  8024ab:	55                   	push   %ebp
  8024ac:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8024ae:	6a 00                	push   $0x0
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 00                	push   $0x0
  8024b4:	6a 00                	push   $0x0
  8024b6:	6a 00                	push   $0x0
  8024b8:	6a 02                	push   $0x2
  8024ba:	e8 70 ff ff ff       	call   80242f <syscall>
  8024bf:	83 c4 18             	add    $0x18,%esp
}
  8024c2:	c9                   	leave  
  8024c3:	c3                   	ret    

008024c4 <sys_env_exit>:

void sys_env_exit(void)
{
  8024c4:	55                   	push   %ebp
  8024c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8024c7:	6a 00                	push   $0x0
  8024c9:	6a 00                	push   $0x0
  8024cb:	6a 00                	push   $0x0
  8024cd:	6a 00                	push   $0x0
  8024cf:	6a 00                	push   $0x0
  8024d1:	6a 04                	push   $0x4
  8024d3:	e8 57 ff ff ff       	call   80242f <syscall>
  8024d8:	83 c4 18             	add    $0x18,%esp
}
  8024db:	90                   	nop
  8024dc:	c9                   	leave  
  8024dd:	c3                   	ret    

008024de <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8024de:	55                   	push   %ebp
  8024df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8024e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e7:	6a 00                	push   $0x0
  8024e9:	6a 00                	push   $0x0
  8024eb:	6a 00                	push   $0x0
  8024ed:	52                   	push   %edx
  8024ee:	50                   	push   %eax
  8024ef:	6a 05                	push   $0x5
  8024f1:	e8 39 ff ff ff       	call   80242f <syscall>
  8024f6:	83 c4 18             	add    $0x18,%esp
}
  8024f9:	c9                   	leave  
  8024fa:	c3                   	ret    

008024fb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8024fb:	55                   	push   %ebp
  8024fc:	89 e5                	mov    %esp,%ebp
  8024fe:	56                   	push   %esi
  8024ff:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802500:	8b 75 18             	mov    0x18(%ebp),%esi
  802503:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802506:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802509:	8b 55 0c             	mov    0xc(%ebp),%edx
  80250c:	8b 45 08             	mov    0x8(%ebp),%eax
  80250f:	56                   	push   %esi
  802510:	53                   	push   %ebx
  802511:	51                   	push   %ecx
  802512:	52                   	push   %edx
  802513:	50                   	push   %eax
  802514:	6a 06                	push   $0x6
  802516:	e8 14 ff ff ff       	call   80242f <syscall>
  80251b:	83 c4 18             	add    $0x18,%esp
}
  80251e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802521:	5b                   	pop    %ebx
  802522:	5e                   	pop    %esi
  802523:	5d                   	pop    %ebp
  802524:	c3                   	ret    

00802525 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802525:	55                   	push   %ebp
  802526:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802528:	8b 55 0c             	mov    0xc(%ebp),%edx
  80252b:	8b 45 08             	mov    0x8(%ebp),%eax
  80252e:	6a 00                	push   $0x0
  802530:	6a 00                	push   $0x0
  802532:	6a 00                	push   $0x0
  802534:	52                   	push   %edx
  802535:	50                   	push   %eax
  802536:	6a 07                	push   $0x7
  802538:	e8 f2 fe ff ff       	call   80242f <syscall>
  80253d:	83 c4 18             	add    $0x18,%esp
}
  802540:	c9                   	leave  
  802541:	c3                   	ret    

00802542 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802542:	55                   	push   %ebp
  802543:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802545:	6a 00                	push   $0x0
  802547:	6a 00                	push   $0x0
  802549:	6a 00                	push   $0x0
  80254b:	ff 75 0c             	pushl  0xc(%ebp)
  80254e:	ff 75 08             	pushl  0x8(%ebp)
  802551:	6a 08                	push   $0x8
  802553:	e8 d7 fe ff ff       	call   80242f <syscall>
  802558:	83 c4 18             	add    $0x18,%esp
}
  80255b:	c9                   	leave  
  80255c:	c3                   	ret    

0080255d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80255d:	55                   	push   %ebp
  80255e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802560:	6a 00                	push   $0x0
  802562:	6a 00                	push   $0x0
  802564:	6a 00                	push   $0x0
  802566:	6a 00                	push   $0x0
  802568:	6a 00                	push   $0x0
  80256a:	6a 09                	push   $0x9
  80256c:	e8 be fe ff ff       	call   80242f <syscall>
  802571:	83 c4 18             	add    $0x18,%esp
}
  802574:	c9                   	leave  
  802575:	c3                   	ret    

00802576 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802576:	55                   	push   %ebp
  802577:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802579:	6a 00                	push   $0x0
  80257b:	6a 00                	push   $0x0
  80257d:	6a 00                	push   $0x0
  80257f:	6a 00                	push   $0x0
  802581:	6a 00                	push   $0x0
  802583:	6a 0a                	push   $0xa
  802585:	e8 a5 fe ff ff       	call   80242f <syscall>
  80258a:	83 c4 18             	add    $0x18,%esp
}
  80258d:	c9                   	leave  
  80258e:	c3                   	ret    

0080258f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80258f:	55                   	push   %ebp
  802590:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802592:	6a 00                	push   $0x0
  802594:	6a 00                	push   $0x0
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	6a 00                	push   $0x0
  80259c:	6a 0b                	push   $0xb
  80259e:	e8 8c fe ff ff       	call   80242f <syscall>
  8025a3:	83 c4 18             	add    $0x18,%esp
}
  8025a6:	c9                   	leave  
  8025a7:	c3                   	ret    

008025a8 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8025a8:	55                   	push   %ebp
  8025a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8025ab:	6a 00                	push   $0x0
  8025ad:	6a 00                	push   $0x0
  8025af:	6a 00                	push   $0x0
  8025b1:	ff 75 0c             	pushl  0xc(%ebp)
  8025b4:	ff 75 08             	pushl  0x8(%ebp)
  8025b7:	6a 0d                	push   $0xd
  8025b9:	e8 71 fe ff ff       	call   80242f <syscall>
  8025be:	83 c4 18             	add    $0x18,%esp
	return;
  8025c1:	90                   	nop
}
  8025c2:	c9                   	leave  
  8025c3:	c3                   	ret    

008025c4 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8025c4:	55                   	push   %ebp
  8025c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8025c7:	6a 00                	push   $0x0
  8025c9:	6a 00                	push   $0x0
  8025cb:	6a 00                	push   $0x0
  8025cd:	ff 75 0c             	pushl  0xc(%ebp)
  8025d0:	ff 75 08             	pushl  0x8(%ebp)
  8025d3:	6a 0e                	push   $0xe
  8025d5:	e8 55 fe ff ff       	call   80242f <syscall>
  8025da:	83 c4 18             	add    $0x18,%esp
	return ;
  8025dd:	90                   	nop
}
  8025de:	c9                   	leave  
  8025df:	c3                   	ret    

008025e0 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8025e0:	55                   	push   %ebp
  8025e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8025e3:	6a 00                	push   $0x0
  8025e5:	6a 00                	push   $0x0
  8025e7:	6a 00                	push   $0x0
  8025e9:	6a 00                	push   $0x0
  8025eb:	6a 00                	push   $0x0
  8025ed:	6a 0c                	push   $0xc
  8025ef:	e8 3b fe ff ff       	call   80242f <syscall>
  8025f4:	83 c4 18             	add    $0x18,%esp
}
  8025f7:	c9                   	leave  
  8025f8:	c3                   	ret    

008025f9 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8025f9:	55                   	push   %ebp
  8025fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8025fc:	6a 00                	push   $0x0
  8025fe:	6a 00                	push   $0x0
  802600:	6a 00                	push   $0x0
  802602:	6a 00                	push   $0x0
  802604:	6a 00                	push   $0x0
  802606:	6a 10                	push   $0x10
  802608:	e8 22 fe ff ff       	call   80242f <syscall>
  80260d:	83 c4 18             	add    $0x18,%esp
}
  802610:	90                   	nop
  802611:	c9                   	leave  
  802612:	c3                   	ret    

00802613 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802613:	55                   	push   %ebp
  802614:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802616:	6a 00                	push   $0x0
  802618:	6a 00                	push   $0x0
  80261a:	6a 00                	push   $0x0
  80261c:	6a 00                	push   $0x0
  80261e:	6a 00                	push   $0x0
  802620:	6a 11                	push   $0x11
  802622:	e8 08 fe ff ff       	call   80242f <syscall>
  802627:	83 c4 18             	add    $0x18,%esp
}
  80262a:	90                   	nop
  80262b:	c9                   	leave  
  80262c:	c3                   	ret    

0080262d <sys_cputc>:


void
sys_cputc(const char c)
{
  80262d:	55                   	push   %ebp
  80262e:	89 e5                	mov    %esp,%ebp
  802630:	83 ec 04             	sub    $0x4,%esp
  802633:	8b 45 08             	mov    0x8(%ebp),%eax
  802636:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802639:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80263d:	6a 00                	push   $0x0
  80263f:	6a 00                	push   $0x0
  802641:	6a 00                	push   $0x0
  802643:	6a 00                	push   $0x0
  802645:	50                   	push   %eax
  802646:	6a 12                	push   $0x12
  802648:	e8 e2 fd ff ff       	call   80242f <syscall>
  80264d:	83 c4 18             	add    $0x18,%esp
}
  802650:	90                   	nop
  802651:	c9                   	leave  
  802652:	c3                   	ret    

00802653 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802653:	55                   	push   %ebp
  802654:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802656:	6a 00                	push   $0x0
  802658:	6a 00                	push   $0x0
  80265a:	6a 00                	push   $0x0
  80265c:	6a 00                	push   $0x0
  80265e:	6a 00                	push   $0x0
  802660:	6a 13                	push   $0x13
  802662:	e8 c8 fd ff ff       	call   80242f <syscall>
  802667:	83 c4 18             	add    $0x18,%esp
}
  80266a:	90                   	nop
  80266b:	c9                   	leave  
  80266c:	c3                   	ret    

0080266d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80266d:	55                   	push   %ebp
  80266e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802670:	8b 45 08             	mov    0x8(%ebp),%eax
  802673:	6a 00                	push   $0x0
  802675:	6a 00                	push   $0x0
  802677:	6a 00                	push   $0x0
  802679:	ff 75 0c             	pushl  0xc(%ebp)
  80267c:	50                   	push   %eax
  80267d:	6a 14                	push   $0x14
  80267f:	e8 ab fd ff ff       	call   80242f <syscall>
  802684:	83 c4 18             	add    $0x18,%esp
}
  802687:	c9                   	leave  
  802688:	c3                   	ret    

00802689 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  802689:	55                   	push   %ebp
  80268a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  80268c:	8b 45 08             	mov    0x8(%ebp),%eax
  80268f:	6a 00                	push   $0x0
  802691:	6a 00                	push   $0x0
  802693:	6a 00                	push   $0x0
  802695:	6a 00                	push   $0x0
  802697:	50                   	push   %eax
  802698:	6a 17                	push   $0x17
  80269a:	e8 90 fd ff ff       	call   80242f <syscall>
  80269f:	83 c4 18             	add    $0x18,%esp
}
  8026a2:	c9                   	leave  
  8026a3:	c3                   	ret    

008026a4 <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  8026a4:	55                   	push   %ebp
  8026a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  8026a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026aa:	6a 00                	push   $0x0
  8026ac:	6a 00                	push   $0x0
  8026ae:	6a 00                	push   $0x0
  8026b0:	6a 00                	push   $0x0
  8026b2:	50                   	push   %eax
  8026b3:	6a 15                	push   $0x15
  8026b5:	e8 75 fd ff ff       	call   80242f <syscall>
  8026ba:	83 c4 18             	add    $0x18,%esp
}
  8026bd:	90                   	nop
  8026be:	c9                   	leave  
  8026bf:	c3                   	ret    

008026c0 <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  8026c0:	55                   	push   %ebp
  8026c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  8026c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c6:	6a 00                	push   $0x0
  8026c8:	6a 00                	push   $0x0
  8026ca:	6a 00                	push   $0x0
  8026cc:	6a 00                	push   $0x0
  8026ce:	50                   	push   %eax
  8026cf:	6a 16                	push   $0x16
  8026d1:	e8 59 fd ff ff       	call   80242f <syscall>
  8026d6:	83 c4 18             	add    $0x18,%esp
}
  8026d9:	90                   	nop
  8026da:	c9                   	leave  
  8026db:	c3                   	ret    

008026dc <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  8026dc:	55                   	push   %ebp
  8026dd:	89 e5                	mov    %esp,%ebp
  8026df:	83 ec 04             	sub    $0x4,%esp
  8026e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8026e5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  8026e8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8026eb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8026ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f2:	6a 00                	push   $0x0
  8026f4:	51                   	push   %ecx
  8026f5:	52                   	push   %edx
  8026f6:	ff 75 0c             	pushl  0xc(%ebp)
  8026f9:	50                   	push   %eax
  8026fa:	6a 18                	push   $0x18
  8026fc:	e8 2e fd ff ff       	call   80242f <syscall>
  802701:	83 c4 18             	add    $0x18,%esp
}
  802704:	c9                   	leave  
  802705:	c3                   	ret    

00802706 <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  802706:	55                   	push   %ebp
  802707:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  802709:	8b 55 0c             	mov    0xc(%ebp),%edx
  80270c:	8b 45 08             	mov    0x8(%ebp),%eax
  80270f:	6a 00                	push   $0x0
  802711:	6a 00                	push   $0x0
  802713:	6a 00                	push   $0x0
  802715:	52                   	push   %edx
  802716:	50                   	push   %eax
  802717:	6a 19                	push   $0x19
  802719:	e8 11 fd ff ff       	call   80242f <syscall>
  80271e:	83 c4 18             	add    $0x18,%esp
}
  802721:	c9                   	leave  
  802722:	c3                   	ret    

00802723 <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  802723:	55                   	push   %ebp
  802724:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  802726:	8b 45 08             	mov    0x8(%ebp),%eax
  802729:	6a 00                	push   $0x0
  80272b:	6a 00                	push   $0x0
  80272d:	6a 00                	push   $0x0
  80272f:	6a 00                	push   $0x0
  802731:	50                   	push   %eax
  802732:	6a 1a                	push   $0x1a
  802734:	e8 f6 fc ff ff       	call   80242f <syscall>
  802739:	83 c4 18             	add    $0x18,%esp
}
  80273c:	c9                   	leave  
  80273d:	c3                   	ret    

0080273e <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  80273e:	55                   	push   %ebp
  80273f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  802741:	6a 00                	push   $0x0
  802743:	6a 00                	push   $0x0
  802745:	6a 00                	push   $0x0
  802747:	6a 00                	push   $0x0
  802749:	6a 00                	push   $0x0
  80274b:	6a 1b                	push   $0x1b
  80274d:	e8 dd fc ff ff       	call   80242f <syscall>
  802752:	83 c4 18             	add    $0x18,%esp
}
  802755:	c9                   	leave  
  802756:	c3                   	ret    

00802757 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802757:	55                   	push   %ebp
  802758:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80275a:	6a 00                	push   $0x0
  80275c:	6a 00                	push   $0x0
  80275e:	6a 00                	push   $0x0
  802760:	6a 00                	push   $0x0
  802762:	6a 00                	push   $0x0
  802764:	6a 1c                	push   $0x1c
  802766:	e8 c4 fc ff ff       	call   80242f <syscall>
  80276b:	83 c4 18             	add    $0x18,%esp
}
  80276e:	c9                   	leave  
  80276f:	c3                   	ret    

00802770 <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  802770:	55                   	push   %ebp
  802771:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  802773:	8b 45 08             	mov    0x8(%ebp),%eax
  802776:	6a 00                	push   $0x0
  802778:	6a 00                	push   $0x0
  80277a:	6a 00                	push   $0x0
  80277c:	ff 75 0c             	pushl  0xc(%ebp)
  80277f:	50                   	push   %eax
  802780:	6a 1d                	push   $0x1d
  802782:	e8 a8 fc ff ff       	call   80242f <syscall>
  802787:	83 c4 18             	add    $0x18,%esp
}
  80278a:	c9                   	leave  
  80278b:	c3                   	ret    

0080278c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80278c:	55                   	push   %ebp
  80278d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80278f:	8b 45 08             	mov    0x8(%ebp),%eax
  802792:	6a 00                	push   $0x0
  802794:	6a 00                	push   $0x0
  802796:	6a 00                	push   $0x0
  802798:	6a 00                	push   $0x0
  80279a:	50                   	push   %eax
  80279b:	6a 1e                	push   $0x1e
  80279d:	e8 8d fc ff ff       	call   80242f <syscall>
  8027a2:	83 c4 18             	add    $0x18,%esp
}
  8027a5:	90                   	nop
  8027a6:	c9                   	leave  
  8027a7:	c3                   	ret    

008027a8 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8027a8:	55                   	push   %ebp
  8027a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8027ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ae:	6a 00                	push   $0x0
  8027b0:	6a 00                	push   $0x0
  8027b2:	6a 00                	push   $0x0
  8027b4:	6a 00                	push   $0x0
  8027b6:	50                   	push   %eax
  8027b7:	6a 1f                	push   $0x1f
  8027b9:	e8 71 fc ff ff       	call   80242f <syscall>
  8027be:	83 c4 18             	add    $0x18,%esp
}
  8027c1:	90                   	nop
  8027c2:	c9                   	leave  
  8027c3:	c3                   	ret    

008027c4 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8027c4:	55                   	push   %ebp
  8027c5:	89 e5                	mov    %esp,%ebp
  8027c7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8027ca:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8027cd:	8d 50 04             	lea    0x4(%eax),%edx
  8027d0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8027d3:	6a 00                	push   $0x0
  8027d5:	6a 00                	push   $0x0
  8027d7:	6a 00                	push   $0x0
  8027d9:	52                   	push   %edx
  8027da:	50                   	push   %eax
  8027db:	6a 20                	push   $0x20
  8027dd:	e8 4d fc ff ff       	call   80242f <syscall>
  8027e2:	83 c4 18             	add    $0x18,%esp
	return result;
  8027e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8027ee:	89 01                	mov    %eax,(%ecx)
  8027f0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8027f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f6:	c9                   	leave  
  8027f7:	c2 04 00             	ret    $0x4

008027fa <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8027fa:	55                   	push   %ebp
  8027fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8027fd:	6a 00                	push   $0x0
  8027ff:	6a 00                	push   $0x0
  802801:	ff 75 10             	pushl  0x10(%ebp)
  802804:	ff 75 0c             	pushl  0xc(%ebp)
  802807:	ff 75 08             	pushl  0x8(%ebp)
  80280a:	6a 0f                	push   $0xf
  80280c:	e8 1e fc ff ff       	call   80242f <syscall>
  802811:	83 c4 18             	add    $0x18,%esp
	return ;
  802814:	90                   	nop
}
  802815:	c9                   	leave  
  802816:	c3                   	ret    

00802817 <sys_rcr2>:
uint32 sys_rcr2()
{
  802817:	55                   	push   %ebp
  802818:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80281a:	6a 00                	push   $0x0
  80281c:	6a 00                	push   $0x0
  80281e:	6a 00                	push   $0x0
  802820:	6a 00                	push   $0x0
  802822:	6a 00                	push   $0x0
  802824:	6a 21                	push   $0x21
  802826:	e8 04 fc ff ff       	call   80242f <syscall>
  80282b:	83 c4 18             	add    $0x18,%esp
}
  80282e:	c9                   	leave  
  80282f:	c3                   	ret    

00802830 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802830:	55                   	push   %ebp
  802831:	89 e5                	mov    %esp,%ebp
  802833:	83 ec 04             	sub    $0x4,%esp
  802836:	8b 45 08             	mov    0x8(%ebp),%eax
  802839:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80283c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802840:	6a 00                	push   $0x0
  802842:	6a 00                	push   $0x0
  802844:	6a 00                	push   $0x0
  802846:	6a 00                	push   $0x0
  802848:	50                   	push   %eax
  802849:	6a 22                	push   $0x22
  80284b:	e8 df fb ff ff       	call   80242f <syscall>
  802850:	83 c4 18             	add    $0x18,%esp
	return ;
  802853:	90                   	nop
}
  802854:	c9                   	leave  
  802855:	c3                   	ret    

00802856 <rsttst>:
void rsttst()
{
  802856:	55                   	push   %ebp
  802857:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802859:	6a 00                	push   $0x0
  80285b:	6a 00                	push   $0x0
  80285d:	6a 00                	push   $0x0
  80285f:	6a 00                	push   $0x0
  802861:	6a 00                	push   $0x0
  802863:	6a 24                	push   $0x24
  802865:	e8 c5 fb ff ff       	call   80242f <syscall>
  80286a:	83 c4 18             	add    $0x18,%esp
	return ;
  80286d:	90                   	nop
}
  80286e:	c9                   	leave  
  80286f:	c3                   	ret    

00802870 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802870:	55                   	push   %ebp
  802871:	89 e5                	mov    %esp,%ebp
  802873:	83 ec 04             	sub    $0x4,%esp
  802876:	8b 45 14             	mov    0x14(%ebp),%eax
  802879:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80287c:	8b 55 18             	mov    0x18(%ebp),%edx
  80287f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802883:	52                   	push   %edx
  802884:	50                   	push   %eax
  802885:	ff 75 10             	pushl  0x10(%ebp)
  802888:	ff 75 0c             	pushl  0xc(%ebp)
  80288b:	ff 75 08             	pushl  0x8(%ebp)
  80288e:	6a 23                	push   $0x23
  802890:	e8 9a fb ff ff       	call   80242f <syscall>
  802895:	83 c4 18             	add    $0x18,%esp
	return ;
  802898:	90                   	nop
}
  802899:	c9                   	leave  
  80289a:	c3                   	ret    

0080289b <chktst>:
void chktst(uint32 n)
{
  80289b:	55                   	push   %ebp
  80289c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80289e:	6a 00                	push   $0x0
  8028a0:	6a 00                	push   $0x0
  8028a2:	6a 00                	push   $0x0
  8028a4:	6a 00                	push   $0x0
  8028a6:	ff 75 08             	pushl  0x8(%ebp)
  8028a9:	6a 25                	push   $0x25
  8028ab:	e8 7f fb ff ff       	call   80242f <syscall>
  8028b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8028b3:	90                   	nop
}
  8028b4:	c9                   	leave  
  8028b5:	c3                   	ret    

008028b6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8028b6:	55                   	push   %ebp
  8028b7:	89 e5                	mov    %esp,%ebp
  8028b9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028bc:	6a 00                	push   $0x0
  8028be:	6a 00                	push   $0x0
  8028c0:	6a 00                	push   $0x0
  8028c2:	6a 00                	push   $0x0
  8028c4:	6a 00                	push   $0x0
  8028c6:	6a 26                	push   $0x26
  8028c8:	e8 62 fb ff ff       	call   80242f <syscall>
  8028cd:	83 c4 18             	add    $0x18,%esp
  8028d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8028d3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8028d7:	75 07                	jne    8028e0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8028d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8028de:	eb 05                	jmp    8028e5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8028e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028e5:	c9                   	leave  
  8028e6:	c3                   	ret    

008028e7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8028e7:	55                   	push   %ebp
  8028e8:	89 e5                	mov    %esp,%ebp
  8028ea:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028ed:	6a 00                	push   $0x0
  8028ef:	6a 00                	push   $0x0
  8028f1:	6a 00                	push   $0x0
  8028f3:	6a 00                	push   $0x0
  8028f5:	6a 00                	push   $0x0
  8028f7:	6a 26                	push   $0x26
  8028f9:	e8 31 fb ff ff       	call   80242f <syscall>
  8028fe:	83 c4 18             	add    $0x18,%esp
  802901:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802904:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802908:	75 07                	jne    802911 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80290a:	b8 01 00 00 00       	mov    $0x1,%eax
  80290f:	eb 05                	jmp    802916 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802911:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802916:	c9                   	leave  
  802917:	c3                   	ret    

00802918 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802918:	55                   	push   %ebp
  802919:	89 e5                	mov    %esp,%ebp
  80291b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80291e:	6a 00                	push   $0x0
  802920:	6a 00                	push   $0x0
  802922:	6a 00                	push   $0x0
  802924:	6a 00                	push   $0x0
  802926:	6a 00                	push   $0x0
  802928:	6a 26                	push   $0x26
  80292a:	e8 00 fb ff ff       	call   80242f <syscall>
  80292f:	83 c4 18             	add    $0x18,%esp
  802932:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802935:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802939:	75 07                	jne    802942 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80293b:	b8 01 00 00 00       	mov    $0x1,%eax
  802940:	eb 05                	jmp    802947 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802942:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802947:	c9                   	leave  
  802948:	c3                   	ret    

00802949 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802949:	55                   	push   %ebp
  80294a:	89 e5                	mov    %esp,%ebp
  80294c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80294f:	6a 00                	push   $0x0
  802951:	6a 00                	push   $0x0
  802953:	6a 00                	push   $0x0
  802955:	6a 00                	push   $0x0
  802957:	6a 00                	push   $0x0
  802959:	6a 26                	push   $0x26
  80295b:	e8 cf fa ff ff       	call   80242f <syscall>
  802960:	83 c4 18             	add    $0x18,%esp
  802963:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802966:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80296a:	75 07                	jne    802973 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80296c:	b8 01 00 00 00       	mov    $0x1,%eax
  802971:	eb 05                	jmp    802978 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802973:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802978:	c9                   	leave  
  802979:	c3                   	ret    

0080297a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80297a:	55                   	push   %ebp
  80297b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80297d:	6a 00                	push   $0x0
  80297f:	6a 00                	push   $0x0
  802981:	6a 00                	push   $0x0
  802983:	6a 00                	push   $0x0
  802985:	ff 75 08             	pushl  0x8(%ebp)
  802988:	6a 27                	push   $0x27
  80298a:	e8 a0 fa ff ff       	call   80242f <syscall>
  80298f:	83 c4 18             	add    $0x18,%esp
	return ;
  802992:	90                   	nop
}
  802993:	c9                   	leave  
  802994:	c3                   	ret    
  802995:	66 90                	xchg   %ax,%ax
  802997:	90                   	nop

00802998 <__udivdi3>:
  802998:	55                   	push   %ebp
  802999:	57                   	push   %edi
  80299a:	56                   	push   %esi
  80299b:	53                   	push   %ebx
  80299c:	83 ec 1c             	sub    $0x1c,%esp
  80299f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8029a3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8029a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8029ab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8029af:	89 ca                	mov    %ecx,%edx
  8029b1:	89 f8                	mov    %edi,%eax
  8029b3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8029b7:	85 f6                	test   %esi,%esi
  8029b9:	75 2d                	jne    8029e8 <__udivdi3+0x50>
  8029bb:	39 cf                	cmp    %ecx,%edi
  8029bd:	77 65                	ja     802a24 <__udivdi3+0x8c>
  8029bf:	89 fd                	mov    %edi,%ebp
  8029c1:	85 ff                	test   %edi,%edi
  8029c3:	75 0b                	jne    8029d0 <__udivdi3+0x38>
  8029c5:	b8 01 00 00 00       	mov    $0x1,%eax
  8029ca:	31 d2                	xor    %edx,%edx
  8029cc:	f7 f7                	div    %edi
  8029ce:	89 c5                	mov    %eax,%ebp
  8029d0:	31 d2                	xor    %edx,%edx
  8029d2:	89 c8                	mov    %ecx,%eax
  8029d4:	f7 f5                	div    %ebp
  8029d6:	89 c1                	mov    %eax,%ecx
  8029d8:	89 d8                	mov    %ebx,%eax
  8029da:	f7 f5                	div    %ebp
  8029dc:	89 cf                	mov    %ecx,%edi
  8029de:	89 fa                	mov    %edi,%edx
  8029e0:	83 c4 1c             	add    $0x1c,%esp
  8029e3:	5b                   	pop    %ebx
  8029e4:	5e                   	pop    %esi
  8029e5:	5f                   	pop    %edi
  8029e6:	5d                   	pop    %ebp
  8029e7:	c3                   	ret    
  8029e8:	39 ce                	cmp    %ecx,%esi
  8029ea:	77 28                	ja     802a14 <__udivdi3+0x7c>
  8029ec:	0f bd fe             	bsr    %esi,%edi
  8029ef:	83 f7 1f             	xor    $0x1f,%edi
  8029f2:	75 40                	jne    802a34 <__udivdi3+0x9c>
  8029f4:	39 ce                	cmp    %ecx,%esi
  8029f6:	72 0a                	jb     802a02 <__udivdi3+0x6a>
  8029f8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8029fc:	0f 87 9e 00 00 00    	ja     802aa0 <__udivdi3+0x108>
  802a02:	b8 01 00 00 00       	mov    $0x1,%eax
  802a07:	89 fa                	mov    %edi,%edx
  802a09:	83 c4 1c             	add    $0x1c,%esp
  802a0c:	5b                   	pop    %ebx
  802a0d:	5e                   	pop    %esi
  802a0e:	5f                   	pop    %edi
  802a0f:	5d                   	pop    %ebp
  802a10:	c3                   	ret    
  802a11:	8d 76 00             	lea    0x0(%esi),%esi
  802a14:	31 ff                	xor    %edi,%edi
  802a16:	31 c0                	xor    %eax,%eax
  802a18:	89 fa                	mov    %edi,%edx
  802a1a:	83 c4 1c             	add    $0x1c,%esp
  802a1d:	5b                   	pop    %ebx
  802a1e:	5e                   	pop    %esi
  802a1f:	5f                   	pop    %edi
  802a20:	5d                   	pop    %ebp
  802a21:	c3                   	ret    
  802a22:	66 90                	xchg   %ax,%ax
  802a24:	89 d8                	mov    %ebx,%eax
  802a26:	f7 f7                	div    %edi
  802a28:	31 ff                	xor    %edi,%edi
  802a2a:	89 fa                	mov    %edi,%edx
  802a2c:	83 c4 1c             	add    $0x1c,%esp
  802a2f:	5b                   	pop    %ebx
  802a30:	5e                   	pop    %esi
  802a31:	5f                   	pop    %edi
  802a32:	5d                   	pop    %ebp
  802a33:	c3                   	ret    
  802a34:	bd 20 00 00 00       	mov    $0x20,%ebp
  802a39:	89 eb                	mov    %ebp,%ebx
  802a3b:	29 fb                	sub    %edi,%ebx
  802a3d:	89 f9                	mov    %edi,%ecx
  802a3f:	d3 e6                	shl    %cl,%esi
  802a41:	89 c5                	mov    %eax,%ebp
  802a43:	88 d9                	mov    %bl,%cl
  802a45:	d3 ed                	shr    %cl,%ebp
  802a47:	89 e9                	mov    %ebp,%ecx
  802a49:	09 f1                	or     %esi,%ecx
  802a4b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802a4f:	89 f9                	mov    %edi,%ecx
  802a51:	d3 e0                	shl    %cl,%eax
  802a53:	89 c5                	mov    %eax,%ebp
  802a55:	89 d6                	mov    %edx,%esi
  802a57:	88 d9                	mov    %bl,%cl
  802a59:	d3 ee                	shr    %cl,%esi
  802a5b:	89 f9                	mov    %edi,%ecx
  802a5d:	d3 e2                	shl    %cl,%edx
  802a5f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a63:	88 d9                	mov    %bl,%cl
  802a65:	d3 e8                	shr    %cl,%eax
  802a67:	09 c2                	or     %eax,%edx
  802a69:	89 d0                	mov    %edx,%eax
  802a6b:	89 f2                	mov    %esi,%edx
  802a6d:	f7 74 24 0c          	divl   0xc(%esp)
  802a71:	89 d6                	mov    %edx,%esi
  802a73:	89 c3                	mov    %eax,%ebx
  802a75:	f7 e5                	mul    %ebp
  802a77:	39 d6                	cmp    %edx,%esi
  802a79:	72 19                	jb     802a94 <__udivdi3+0xfc>
  802a7b:	74 0b                	je     802a88 <__udivdi3+0xf0>
  802a7d:	89 d8                	mov    %ebx,%eax
  802a7f:	31 ff                	xor    %edi,%edi
  802a81:	e9 58 ff ff ff       	jmp    8029de <__udivdi3+0x46>
  802a86:	66 90                	xchg   %ax,%ax
  802a88:	8b 54 24 08          	mov    0x8(%esp),%edx
  802a8c:	89 f9                	mov    %edi,%ecx
  802a8e:	d3 e2                	shl    %cl,%edx
  802a90:	39 c2                	cmp    %eax,%edx
  802a92:	73 e9                	jae    802a7d <__udivdi3+0xe5>
  802a94:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a97:	31 ff                	xor    %edi,%edi
  802a99:	e9 40 ff ff ff       	jmp    8029de <__udivdi3+0x46>
  802a9e:	66 90                	xchg   %ax,%ax
  802aa0:	31 c0                	xor    %eax,%eax
  802aa2:	e9 37 ff ff ff       	jmp    8029de <__udivdi3+0x46>
  802aa7:	90                   	nop

00802aa8 <__umoddi3>:
  802aa8:	55                   	push   %ebp
  802aa9:	57                   	push   %edi
  802aaa:	56                   	push   %esi
  802aab:	53                   	push   %ebx
  802aac:	83 ec 1c             	sub    $0x1c,%esp
  802aaf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802ab3:	8b 74 24 34          	mov    0x34(%esp),%esi
  802ab7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802abb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802abf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802ac3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ac7:	89 f3                	mov    %esi,%ebx
  802ac9:	89 fa                	mov    %edi,%edx
  802acb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802acf:	89 34 24             	mov    %esi,(%esp)
  802ad2:	85 c0                	test   %eax,%eax
  802ad4:	75 1a                	jne    802af0 <__umoddi3+0x48>
  802ad6:	39 f7                	cmp    %esi,%edi
  802ad8:	0f 86 a2 00 00 00    	jbe    802b80 <__umoddi3+0xd8>
  802ade:	89 c8                	mov    %ecx,%eax
  802ae0:	89 f2                	mov    %esi,%edx
  802ae2:	f7 f7                	div    %edi
  802ae4:	89 d0                	mov    %edx,%eax
  802ae6:	31 d2                	xor    %edx,%edx
  802ae8:	83 c4 1c             	add    $0x1c,%esp
  802aeb:	5b                   	pop    %ebx
  802aec:	5e                   	pop    %esi
  802aed:	5f                   	pop    %edi
  802aee:	5d                   	pop    %ebp
  802aef:	c3                   	ret    
  802af0:	39 f0                	cmp    %esi,%eax
  802af2:	0f 87 ac 00 00 00    	ja     802ba4 <__umoddi3+0xfc>
  802af8:	0f bd e8             	bsr    %eax,%ebp
  802afb:	83 f5 1f             	xor    $0x1f,%ebp
  802afe:	0f 84 ac 00 00 00    	je     802bb0 <__umoddi3+0x108>
  802b04:	bf 20 00 00 00       	mov    $0x20,%edi
  802b09:	29 ef                	sub    %ebp,%edi
  802b0b:	89 fe                	mov    %edi,%esi
  802b0d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b11:	89 e9                	mov    %ebp,%ecx
  802b13:	d3 e0                	shl    %cl,%eax
  802b15:	89 d7                	mov    %edx,%edi
  802b17:	89 f1                	mov    %esi,%ecx
  802b19:	d3 ef                	shr    %cl,%edi
  802b1b:	09 c7                	or     %eax,%edi
  802b1d:	89 e9                	mov    %ebp,%ecx
  802b1f:	d3 e2                	shl    %cl,%edx
  802b21:	89 14 24             	mov    %edx,(%esp)
  802b24:	89 d8                	mov    %ebx,%eax
  802b26:	d3 e0                	shl    %cl,%eax
  802b28:	89 c2                	mov    %eax,%edx
  802b2a:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b2e:	d3 e0                	shl    %cl,%eax
  802b30:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b34:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b38:	89 f1                	mov    %esi,%ecx
  802b3a:	d3 e8                	shr    %cl,%eax
  802b3c:	09 d0                	or     %edx,%eax
  802b3e:	d3 eb                	shr    %cl,%ebx
  802b40:	89 da                	mov    %ebx,%edx
  802b42:	f7 f7                	div    %edi
  802b44:	89 d3                	mov    %edx,%ebx
  802b46:	f7 24 24             	mull   (%esp)
  802b49:	89 c6                	mov    %eax,%esi
  802b4b:	89 d1                	mov    %edx,%ecx
  802b4d:	39 d3                	cmp    %edx,%ebx
  802b4f:	0f 82 87 00 00 00    	jb     802bdc <__umoddi3+0x134>
  802b55:	0f 84 91 00 00 00    	je     802bec <__umoddi3+0x144>
  802b5b:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b5f:	29 f2                	sub    %esi,%edx
  802b61:	19 cb                	sbb    %ecx,%ebx
  802b63:	89 d8                	mov    %ebx,%eax
  802b65:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802b69:	d3 e0                	shl    %cl,%eax
  802b6b:	89 e9                	mov    %ebp,%ecx
  802b6d:	d3 ea                	shr    %cl,%edx
  802b6f:	09 d0                	or     %edx,%eax
  802b71:	89 e9                	mov    %ebp,%ecx
  802b73:	d3 eb                	shr    %cl,%ebx
  802b75:	89 da                	mov    %ebx,%edx
  802b77:	83 c4 1c             	add    $0x1c,%esp
  802b7a:	5b                   	pop    %ebx
  802b7b:	5e                   	pop    %esi
  802b7c:	5f                   	pop    %edi
  802b7d:	5d                   	pop    %ebp
  802b7e:	c3                   	ret    
  802b7f:	90                   	nop
  802b80:	89 fd                	mov    %edi,%ebp
  802b82:	85 ff                	test   %edi,%edi
  802b84:	75 0b                	jne    802b91 <__umoddi3+0xe9>
  802b86:	b8 01 00 00 00       	mov    $0x1,%eax
  802b8b:	31 d2                	xor    %edx,%edx
  802b8d:	f7 f7                	div    %edi
  802b8f:	89 c5                	mov    %eax,%ebp
  802b91:	89 f0                	mov    %esi,%eax
  802b93:	31 d2                	xor    %edx,%edx
  802b95:	f7 f5                	div    %ebp
  802b97:	89 c8                	mov    %ecx,%eax
  802b99:	f7 f5                	div    %ebp
  802b9b:	89 d0                	mov    %edx,%eax
  802b9d:	e9 44 ff ff ff       	jmp    802ae6 <__umoddi3+0x3e>
  802ba2:	66 90                	xchg   %ax,%ax
  802ba4:	89 c8                	mov    %ecx,%eax
  802ba6:	89 f2                	mov    %esi,%edx
  802ba8:	83 c4 1c             	add    $0x1c,%esp
  802bab:	5b                   	pop    %ebx
  802bac:	5e                   	pop    %esi
  802bad:	5f                   	pop    %edi
  802bae:	5d                   	pop    %ebp
  802baf:	c3                   	ret    
  802bb0:	3b 04 24             	cmp    (%esp),%eax
  802bb3:	72 06                	jb     802bbb <__umoddi3+0x113>
  802bb5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802bb9:	77 0f                	ja     802bca <__umoddi3+0x122>
  802bbb:	89 f2                	mov    %esi,%edx
  802bbd:	29 f9                	sub    %edi,%ecx
  802bbf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802bc3:	89 14 24             	mov    %edx,(%esp)
  802bc6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802bca:	8b 44 24 04          	mov    0x4(%esp),%eax
  802bce:	8b 14 24             	mov    (%esp),%edx
  802bd1:	83 c4 1c             	add    $0x1c,%esp
  802bd4:	5b                   	pop    %ebx
  802bd5:	5e                   	pop    %esi
  802bd6:	5f                   	pop    %edi
  802bd7:	5d                   	pop    %ebp
  802bd8:	c3                   	ret    
  802bd9:	8d 76 00             	lea    0x0(%esi),%esi
  802bdc:	2b 04 24             	sub    (%esp),%eax
  802bdf:	19 fa                	sbb    %edi,%edx
  802be1:	89 d1                	mov    %edx,%ecx
  802be3:	89 c6                	mov    %eax,%esi
  802be5:	e9 71 ff ff ff       	jmp    802b5b <__umoddi3+0xb3>
  802bea:	66 90                	xchg   %ax,%ax
  802bec:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802bf0:	72 ea                	jb     802bdc <__umoddi3+0x134>
  802bf2:	89 d9                	mov    %ebx,%ecx
  802bf4:	e9 62 ff ff ff       	jmp    802b5b <__umoddi3+0xb3>
