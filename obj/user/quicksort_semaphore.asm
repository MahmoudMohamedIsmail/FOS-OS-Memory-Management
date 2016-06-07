
obj/user/quicksort_semaphore:     file format elf32-i386


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
  800031:	e8 44 06 00 00       	call   80067a <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);
uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 24 01 00 00    	sub    $0x124,%esp
	char Chose ;
	char Line[255] ;
	int Iteration = 0 ;
  800042:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	sys_createSemaphore("IO.CS", 1);
  800049:	83 ec 08             	sub    $0x8,%esp
  80004c:	6a 01                	push   $0x1
  80004e:	68 60 2a 80 00       	push   $0x802a60
  800053:	e8 77 24 00 00       	call   8024cf <sys_createSemaphore>
  800058:	83 c4 10             	add    $0x10,%esp
	do
	{
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames();
  80005b:	e8 5f 23 00 00       	call   8023bf <sys_calculate_free_frames>
  800060:	89 c3                	mov    %eax,%ebx
  800062:	e8 71 23 00 00       	call   8023d8 <sys_calculate_modified_frames>
  800067:	01 d8                	add    %ebx,%eax
  800069:	89 45 f0             	mov    %eax,-0x10(%ebp)

		Iteration++ ;
  80006c:	ff 45 f4             	incl   -0xc(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

//	sys_disable_interrupt();

		sys_waitSemaphore("IO.CS");
  80006f:	83 ec 0c             	sub    $0xc,%esp
  800072:	68 60 2a 80 00       	push   $0x802a60
  800077:	e8 8a 24 00 00       	call   802506 <sys_waitSemaphore>
  80007c:	83 c4 10             	add    $0x10,%esp
			readline("Enter the number of elements: ", Line);
  80007f:	83 ec 08             	sub    $0x8,%esp
  800082:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800088:	50                   	push   %eax
  800089:	68 68 2a 80 00       	push   $0x802a68
  80008e:	e8 4e 0e 00 00       	call   800ee1 <readline>
  800093:	83 c4 10             	add    $0x10,%esp
			int NumOfElements = strtol(Line, NULL, 10) ;
  800096:	83 ec 04             	sub    $0x4,%esp
  800099:	6a 0a                	push   $0xa
  80009b:	6a 00                	push   $0x0
  80009d:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  8000a3:	50                   	push   %eax
  8000a4:	e8 9e 13 00 00       	call   801447 <strtol>
  8000a9:	83 c4 10             	add    $0x10,%esp
  8000ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
			int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000b2:	c1 e0 02             	shl    $0x2,%eax
  8000b5:	83 ec 0c             	sub    $0xc,%esp
  8000b8:	50                   	push   %eax
  8000b9:	e8 31 17 00 00       	call   8017ef <malloc>
  8000be:	83 c4 10             	add    $0x10,%esp
  8000c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
			cprintf("Choose the initialization method:\n") ;
  8000c4:	83 ec 0c             	sub    $0xc,%esp
  8000c7:	68 88 2a 80 00       	push   $0x802a88
  8000cc:	e8 95 07 00 00       	call   800866 <cprintf>
  8000d1:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	68 ab 2a 80 00       	push   $0x802aab
  8000dc:	e8 85 07 00 00       	call   800866 <cprintf>
  8000e1:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	68 b9 2a 80 00       	push   $0x802ab9
  8000ec:	e8 75 07 00 00       	call   800866 <cprintf>
  8000f1:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\nSelect: ") ;
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	68 c8 2a 80 00       	push   $0x802ac8
  8000fc:	e8 65 07 00 00       	call   800866 <cprintf>
  800101:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  800104:	e8 19 05 00 00       	call   800622 <getchar>
  800109:	88 45 e7             	mov    %al,-0x19(%ebp)
			cputchar(Chose);
  80010c:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800110:	83 ec 0c             	sub    $0xc,%esp
  800113:	50                   	push   %eax
  800114:	e8 c1 04 00 00       	call   8005da <cputchar>
  800119:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80011c:	83 ec 0c             	sub    $0xc,%esp
  80011f:	6a 0a                	push   $0xa
  800121:	e8 b4 04 00 00       	call   8005da <cputchar>
  800126:	83 c4 10             	add    $0x10,%esp
		sys_signalSemaphore("IO.CS");
  800129:	83 ec 0c             	sub    $0xc,%esp
  80012c:	68 60 2a 80 00       	push   $0x802a60
  800131:	e8 ec 23 00 00       	call   802522 <sys_signalSemaphore>
  800136:	83 c4 10             	add    $0x10,%esp
		//sys_enable_interrupt();
		int  i ;
		switch (Chose)
  800139:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  80013d:	83 f8 62             	cmp    $0x62,%eax
  800140:	74 1d                	je     80015f <_main+0x127>
  800142:	83 f8 63             	cmp    $0x63,%eax
  800145:	74 2b                	je     800172 <_main+0x13a>
  800147:	83 f8 61             	cmp    $0x61,%eax
  80014a:	75 39                	jne    800185 <_main+0x14d>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80014c:	83 ec 08             	sub    $0x8,%esp
  80014f:	ff 75 ec             	pushl  -0x14(%ebp)
  800152:	ff 75 e8             	pushl  -0x18(%ebp)
  800155:	e8 28 03 00 00       	call   800482 <InitializeAscending>
  80015a:	83 c4 10             	add    $0x10,%esp
			break ;
  80015d:	eb 37                	jmp    800196 <_main+0x15e>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80015f:	83 ec 08             	sub    $0x8,%esp
  800162:	ff 75 ec             	pushl  -0x14(%ebp)
  800165:	ff 75 e8             	pushl  -0x18(%ebp)
  800168:	e8 46 03 00 00       	call   8004b3 <InitializeDescending>
  80016d:	83 c4 10             	add    $0x10,%esp
			break ;
  800170:	eb 24                	jmp    800196 <_main+0x15e>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800172:	83 ec 08             	sub    $0x8,%esp
  800175:	ff 75 ec             	pushl  -0x14(%ebp)
  800178:	ff 75 e8             	pushl  -0x18(%ebp)
  80017b:	e8 68 03 00 00       	call   8004e8 <InitializeSemiRandom>
  800180:	83 c4 10             	add    $0x10,%esp
			break ;
  800183:	eb 11                	jmp    800196 <_main+0x15e>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  800185:	83 ec 08             	sub    $0x8,%esp
  800188:	ff 75 ec             	pushl  -0x14(%ebp)
  80018b:	ff 75 e8             	pushl  -0x18(%ebp)
  80018e:	e8 55 03 00 00       	call   8004e8 <InitializeSemiRandom>
  800193:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  800196:	83 ec 08             	sub    $0x8,%esp
  800199:	ff 75 ec             	pushl  -0x14(%ebp)
  80019c:	ff 75 e8             	pushl  -0x18(%ebp)
  80019f:	e8 23 01 00 00       	call   8002c7 <QuickSort>
  8001a4:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001a7:	83 ec 08             	sub    $0x8,%esp
  8001aa:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ad:	ff 75 e8             	pushl  -0x18(%ebp)
  8001b0:	e8 23 02 00 00       	call   8003d8 <CheckSorted>
  8001b5:	83 c4 10             	add    $0x10,%esp
  8001b8:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001bb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8001bf:	75 14                	jne    8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 e0 2a 80 00       	push   $0x802ae0
  8001c9:	6a 44                	push   $0x44
  8001cb:	68 02 2b 80 00       	push   $0x802b02
  8001d0:	e8 66 05 00 00       	call   80073b <_panic>
		else
		{ 
			sys_waitSemaphore("IO.CS");
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 60 2a 80 00       	push   $0x802a60
  8001dd:	e8 24 23 00 00       	call   802506 <sys_waitSemaphore>
  8001e2:	83 c4 10             	add    $0x10,%esp
				cprintf("\n===============================================\n") ;
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	68 20 2b 80 00       	push   $0x802b20
  8001ed:	e8 74 06 00 00       	call   800866 <cprintf>
  8001f2:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	68 54 2b 80 00       	push   $0x802b54
  8001fd:	e8 64 06 00 00       	call   800866 <cprintf>
  800202:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 88 2b 80 00       	push   $0x802b88
  80020d:	e8 54 06 00 00       	call   800866 <cprintf>
  800212:	83 c4 10             	add    $0x10,%esp
			sys_signalSemaphore("IO.CS");
  800215:	83 ec 0c             	sub    $0xc,%esp
  800218:	68 60 2a 80 00       	push   $0x802a60
  80021d:	e8 00 23 00 00       	call   802522 <sys_signalSemaphore>
  800222:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		sys_waitSemaphore("IO.CS");
  800225:	83 ec 0c             	sub    $0xc,%esp
  800228:	68 60 2a 80 00       	push   $0x802a60
  80022d:	e8 d4 22 00 00       	call   802506 <sys_waitSemaphore>
  800232:	83 c4 10             	add    $0x10,%esp
			cprintf("Freeing the Heap...\n\n") ;
  800235:	83 ec 0c             	sub    $0xc,%esp
  800238:	68 ba 2b 80 00       	push   $0x802bba
  80023d:	e8 24 06 00 00       	call   800866 <cprintf>
  800242:	83 c4 10             	add    $0x10,%esp
		sys_signalSemaphore("IO.CS");
  800245:	83 ec 0c             	sub    $0xc,%esp
  800248:	68 60 2a 80 00       	push   $0x802a60
  80024d:	e8 d0 22 00 00       	call   802522 <sys_signalSemaphore>
  800252:	83 c4 10             	add    $0x10,%esp

		//freeHeap() ;

		///========================================================================
	//sys_disable_interrupt();
		sys_waitSemaphore("IO.CS");
  800255:	83 ec 0c             	sub    $0xc,%esp
  800258:	68 60 2a 80 00       	push   $0x802a60
  80025d:	e8 a4 22 00 00       	call   802506 <sys_waitSemaphore>
  800262:	83 c4 10             	add    $0x10,%esp
			cprintf("Do you want to repeat (y/n): ") ;
  800265:	83 ec 0c             	sub    $0xc,%esp
  800268:	68 d0 2b 80 00       	push   $0x802bd0
  80026d:	e8 f4 05 00 00       	call   800866 <cprintf>
  800272:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  800275:	e8 a8 03 00 00       	call   800622 <getchar>
  80027a:	88 45 e7             	mov    %al,-0x19(%ebp)
			cputchar(Chose);
  80027d:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800281:	83 ec 0c             	sub    $0xc,%esp
  800284:	50                   	push   %eax
  800285:	e8 50 03 00 00       	call   8005da <cputchar>
  80028a:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80028d:	83 ec 0c             	sub    $0xc,%esp
  800290:	6a 0a                	push   $0xa
  800292:	e8 43 03 00 00       	call   8005da <cputchar>
  800297:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	6a 0a                	push   $0xa
  80029f:	e8 36 03 00 00       	call   8005da <cputchar>
  8002a4:	83 c4 10             	add    $0x10,%esp
	//sys_enable_interrupt();
		sys_signalSemaphore("IO.CS");
  8002a7:	83 ec 0c             	sub    $0xc,%esp
  8002aa:	68 60 2a 80 00       	push   $0x802a60
  8002af:	e8 6e 22 00 00       	call   802522 <sys_signalSemaphore>
  8002b4:	83 c4 10             	add    $0x10,%esp

	} while (Chose == 'y');
  8002b7:	80 7d e7 79          	cmpb   $0x79,-0x19(%ebp)
  8002bb:	0f 84 9a fd ff ff    	je     80005b <_main+0x23>

}
  8002c1:	90                   	nop
  8002c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002c5:	c9                   	leave  
  8002c6:	c3                   	ret    

008002c7 <QuickSort>:

///Quick sort 
void QuickSort(int *Elements, int NumOfElements)
{
  8002c7:	55                   	push   %ebp
  8002c8:	89 e5                	mov    %esp,%ebp
  8002ca:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d0:	48                   	dec    %eax
  8002d1:	50                   	push   %eax
  8002d2:	6a 00                	push   $0x0
  8002d4:	ff 75 0c             	pushl  0xc(%ebp)
  8002d7:	ff 75 08             	pushl  0x8(%ebp)
  8002da:	e8 06 00 00 00       	call   8002e5 <QSort>
  8002df:	83 c4 10             	add    $0x10,%esp
}
  8002e2:	90                   	nop
  8002e3:	c9                   	leave  
  8002e4:	c3                   	ret    

008002e5 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002e5:	55                   	push   %ebp
  8002e6:	89 e5                	mov    %esp,%ebp
  8002e8:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ee:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002f1:	0f 8d de 00 00 00    	jge    8003d5 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8002fa:	40                   	inc    %eax
  8002fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800301:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800304:	e9 80 00 00 00       	jmp    800389 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800309:	ff 45 f4             	incl   -0xc(%ebp)
  80030c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80030f:	3b 45 14             	cmp    0x14(%ebp),%eax
  800312:	7f 2b                	jg     80033f <QSort+0x5a>
  800314:	8b 45 10             	mov    0x10(%ebp),%eax
  800317:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80031e:	8b 45 08             	mov    0x8(%ebp),%eax
  800321:	01 d0                	add    %edx,%eax
  800323:	8b 10                	mov    (%eax),%edx
  800325:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800328:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80032f:	8b 45 08             	mov    0x8(%ebp),%eax
  800332:	01 c8                	add    %ecx,%eax
  800334:	8b 00                	mov    (%eax),%eax
  800336:	39 c2                	cmp    %eax,%edx
  800338:	7d cf                	jge    800309 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  80033a:	eb 03                	jmp    80033f <QSort+0x5a>
  80033c:	ff 4d f0             	decl   -0x10(%ebp)
  80033f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800342:	3b 45 10             	cmp    0x10(%ebp),%eax
  800345:	7e 26                	jle    80036d <QSort+0x88>
  800347:	8b 45 10             	mov    0x10(%ebp),%eax
  80034a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800351:	8b 45 08             	mov    0x8(%ebp),%eax
  800354:	01 d0                	add    %edx,%eax
  800356:	8b 10                	mov    (%eax),%edx
  800358:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80035b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800362:	8b 45 08             	mov    0x8(%ebp),%eax
  800365:	01 c8                	add    %ecx,%eax
  800367:	8b 00                	mov    (%eax),%eax
  800369:	39 c2                	cmp    %eax,%edx
  80036b:	7e cf                	jle    80033c <QSort+0x57>

		if (i <= j)
  80036d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800370:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800373:	7f 14                	jg     800389 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800375:	83 ec 04             	sub    $0x4,%esp
  800378:	ff 75 f0             	pushl  -0x10(%ebp)
  80037b:	ff 75 f4             	pushl  -0xc(%ebp)
  80037e:	ff 75 08             	pushl  0x8(%ebp)
  800381:	e8 a9 00 00 00       	call   80042f <Swap>
  800386:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80038c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80038f:	0f 8e 77 ff ff ff    	jle    80030c <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800395:	83 ec 04             	sub    $0x4,%esp
  800398:	ff 75 f0             	pushl  -0x10(%ebp)
  80039b:	ff 75 10             	pushl  0x10(%ebp)
  80039e:	ff 75 08             	pushl  0x8(%ebp)
  8003a1:	e8 89 00 00 00       	call   80042f <Swap>
  8003a6:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8003a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ac:	48                   	dec    %eax
  8003ad:	50                   	push   %eax
  8003ae:	ff 75 10             	pushl  0x10(%ebp)
  8003b1:	ff 75 0c             	pushl  0xc(%ebp)
  8003b4:	ff 75 08             	pushl  0x8(%ebp)
  8003b7:	e8 29 ff ff ff       	call   8002e5 <QSort>
  8003bc:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003bf:	ff 75 14             	pushl  0x14(%ebp)
  8003c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c5:	ff 75 0c             	pushl  0xc(%ebp)
  8003c8:	ff 75 08             	pushl  0x8(%ebp)
  8003cb:	e8 15 ff ff ff       	call   8002e5 <QSort>
  8003d0:	83 c4 10             	add    $0x10,%esp
  8003d3:	eb 01                	jmp    8003d6 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003d5:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  8003d6:	c9                   	leave  
  8003d7:	c3                   	ret    

008003d8 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003de:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003e5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003ec:	eb 33                	jmp    800421 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003f1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fb:	01 d0                	add    %edx,%eax
  8003fd:	8b 10                	mov    (%eax),%edx
  8003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800402:	40                   	inc    %eax
  800403:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80040a:	8b 45 08             	mov    0x8(%ebp),%eax
  80040d:	01 c8                	add    %ecx,%eax
  80040f:	8b 00                	mov    (%eax),%eax
  800411:	39 c2                	cmp    %eax,%edx
  800413:	7e 09                	jle    80041e <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800415:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  80041c:	eb 0c                	jmp    80042a <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80041e:	ff 45 f8             	incl   -0x8(%ebp)
  800421:	8b 45 0c             	mov    0xc(%ebp),%eax
  800424:	48                   	dec    %eax
  800425:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800428:	7f c4                	jg     8003ee <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  80042a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80042d:	c9                   	leave  
  80042e:	c3                   	ret    

0080042f <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80042f:	55                   	push   %ebp
  800430:	89 e5                	mov    %esp,%ebp
  800432:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800435:	8b 45 0c             	mov    0xc(%ebp),%eax
  800438:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043f:	8b 45 08             	mov    0x8(%ebp),%eax
  800442:	01 d0                	add    %edx,%eax
  800444:	8b 00                	mov    (%eax),%eax
  800446:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800449:	8b 45 0c             	mov    0xc(%ebp),%eax
  80044c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800453:	8b 45 08             	mov    0x8(%ebp),%eax
  800456:	01 c2                	add    %eax,%edx
  800458:	8b 45 10             	mov    0x10(%ebp),%eax
  80045b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800462:	8b 45 08             	mov    0x8(%ebp),%eax
  800465:	01 c8                	add    %ecx,%eax
  800467:	8b 00                	mov    (%eax),%eax
  800469:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  80046b:	8b 45 10             	mov    0x10(%ebp),%eax
  80046e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800475:	8b 45 08             	mov    0x8(%ebp),%eax
  800478:	01 c2                	add    %eax,%edx
  80047a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80047d:	89 02                	mov    %eax,(%edx)
}
  80047f:	90                   	nop
  800480:	c9                   	leave  
  800481:	c3                   	ret    

00800482 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800482:	55                   	push   %ebp
  800483:	89 e5                	mov    %esp,%ebp
  800485:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800488:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80048f:	eb 17                	jmp    8004a8 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800491:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800494:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80049b:	8b 45 08             	mov    0x8(%ebp),%eax
  80049e:	01 c2                	add    %eax,%edx
  8004a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004a3:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004a5:	ff 45 fc             	incl   -0x4(%ebp)
  8004a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ab:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004ae:	7c e1                	jl     800491 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8004b0:	90                   	nop
  8004b1:	c9                   	leave  
  8004b2:	c3                   	ret    

008004b3 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8004b3:	55                   	push   %ebp
  8004b4:	89 e5                	mov    %esp,%ebp
  8004b6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004c0:	eb 1b                	jmp    8004dd <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cf:	01 c2                	add    %eax,%edx
  8004d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d4:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004d7:	48                   	dec    %eax
  8004d8:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004da:	ff 45 fc             	incl   -0x4(%ebp)
  8004dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004e0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004e3:	7c dd                	jl     8004c2 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004e5:	90                   	nop
  8004e6:	c9                   	leave  
  8004e7:	c3                   	ret    

008004e8 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004e8:	55                   	push   %ebp
  8004e9:	89 e5                	mov    %esp,%ebp
  8004eb:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004f1:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004f6:	f7 e9                	imul   %ecx
  8004f8:	c1 f9 1f             	sar    $0x1f,%ecx
  8004fb:	89 d0                	mov    %edx,%eax
  8004fd:	29 c8                	sub    %ecx,%eax
  8004ff:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800502:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800509:	eb 1e                	jmp    800529 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  80050b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80050e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800515:	8b 45 08             	mov    0x8(%ebp),%eax
  800518:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80051b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80051e:	99                   	cltd   
  80051f:	f7 7d f8             	idivl  -0x8(%ebp)
  800522:	89 d0                	mov    %edx,%eax
  800524:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800526:	ff 45 fc             	incl   -0x4(%ebp)
  800529:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80052c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80052f:	7c da                	jl     80050b <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
	}

}
  800531:	90                   	nop
  800532:	c9                   	leave  
  800533:	c3                   	ret    

00800534 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800534:	55                   	push   %ebp
  800535:	89 e5                	mov    %esp,%ebp
  800537:	83 ec 18             	sub    $0x18,%esp
	sys_waitSemaphore("IO.CS");
  80053a:	83 ec 0c             	sub    $0xc,%esp
  80053d:	68 60 2a 80 00       	push   $0x802a60
  800542:	e8 bf 1f 00 00       	call   802506 <sys_waitSemaphore>
  800547:	83 c4 10             	add    $0x10,%esp
		int i ;
		int NumsPerLine = 20 ;
  80054a:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
		for (i = 0 ; i < NumOfElements-1 ; i++)
  800551:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800558:	eb 42                	jmp    80059c <PrintElements+0x68>
		{
			if (i%NumsPerLine == 0)
  80055a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80055d:	99                   	cltd   
  80055e:	f7 7d f0             	idivl  -0x10(%ebp)
  800561:	89 d0                	mov    %edx,%eax
  800563:	85 c0                	test   %eax,%eax
  800565:	75 10                	jne    800577 <PrintElements+0x43>
				cprintf("\n");
  800567:	83 ec 0c             	sub    $0xc,%esp
  80056a:	68 ee 2b 80 00       	push   $0x802bee
  80056f:	e8 f2 02 00 00       	call   800866 <cprintf>
  800574:	83 c4 10             	add    $0x10,%esp
			cprintf("%d, ",Elements[i]);
  800577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80057a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800581:	8b 45 08             	mov    0x8(%ebp),%eax
  800584:	01 d0                	add    %edx,%eax
  800586:	8b 00                	mov    (%eax),%eax
  800588:	83 ec 08             	sub    $0x8,%esp
  80058b:	50                   	push   %eax
  80058c:	68 f0 2b 80 00       	push   $0x802bf0
  800591:	e8 d0 02 00 00       	call   800866 <cprintf>
  800596:	83 c4 10             	add    $0x10,%esp
void PrintElements(int *Elements, int NumOfElements)
{
	sys_waitSemaphore("IO.CS");
		int i ;
		int NumsPerLine = 20 ;
		for (i = 0 ; i < NumOfElements-1 ; i++)
  800599:	ff 45 f4             	incl   -0xc(%ebp)
  80059c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059f:	48                   	dec    %eax
  8005a0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8005a3:	7f b5                	jg     80055a <PrintElements+0x26>
		{
			if (i%NumsPerLine == 0)
				cprintf("\n");
			cprintf("%d, ",Elements[i]);
		}
		cprintf("%d\n",Elements[i]);
  8005a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005af:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b2:	01 d0                	add    %edx,%eax
  8005b4:	8b 00                	mov    (%eax),%eax
  8005b6:	83 ec 08             	sub    $0x8,%esp
  8005b9:	50                   	push   %eax
  8005ba:	68 f5 2b 80 00       	push   $0x802bf5
  8005bf:	e8 a2 02 00 00       	call   800866 <cprintf>
  8005c4:	83 c4 10             	add    $0x10,%esp
	sys_signalSemaphore("IO.CS");
  8005c7:	83 ec 0c             	sub    $0xc,%esp
  8005ca:	68 60 2a 80 00       	push   $0x802a60
  8005cf:	e8 4e 1f 00 00       	call   802522 <sys_signalSemaphore>
  8005d4:	83 c4 10             	add    $0x10,%esp
}
  8005d7:	90                   	nop
  8005d8:	c9                   	leave  
  8005d9:	c3                   	ret    

008005da <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005da:	55                   	push   %ebp
  8005db:	89 e5                	mov    %esp,%ebp
  8005dd:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e3:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005e6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005ea:	83 ec 0c             	sub    $0xc,%esp
  8005ed:	50                   	push   %eax
  8005ee:	e8 9c 1e 00 00       	call   80248f <sys_cputc>
  8005f3:	83 c4 10             	add    $0x10,%esp
}
  8005f6:	90                   	nop
  8005f7:	c9                   	leave  
  8005f8:	c3                   	ret    

008005f9 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8005f9:	55                   	push   %ebp
  8005fa:	89 e5                	mov    %esp,%ebp
  8005fc:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005ff:	e8 57 1e 00 00       	call   80245b <sys_disable_interrupt>
	char c = ch;
  800604:	8b 45 08             	mov    0x8(%ebp),%eax
  800607:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80060a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80060e:	83 ec 0c             	sub    $0xc,%esp
  800611:	50                   	push   %eax
  800612:	e8 78 1e 00 00       	call   80248f <sys_cputc>
  800617:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80061a:	e8 56 1e 00 00       	call   802475 <sys_enable_interrupt>
}
  80061f:	90                   	nop
  800620:	c9                   	leave  
  800621:	c3                   	ret    

00800622 <getchar>:

int
getchar(void)
{
  800622:	55                   	push   %ebp
  800623:	89 e5                	mov    %esp,%ebp
  800625:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800628:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80062f:	eb 08                	jmp    800639 <getchar+0x17>
	{
		c = sys_cgetc();
  800631:	e8 a3 1c 00 00       	call   8022d9 <sys_cgetc>
  800636:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800639:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80063d:	74 f2                	je     800631 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80063f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800642:	c9                   	leave  
  800643:	c3                   	ret    

00800644 <atomic_getchar>:

int
atomic_getchar(void)
{
  800644:	55                   	push   %ebp
  800645:	89 e5                	mov    %esp,%ebp
  800647:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80064a:	e8 0c 1e 00 00       	call   80245b <sys_disable_interrupt>
	int c=0;
  80064f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800656:	eb 08                	jmp    800660 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800658:	e8 7c 1c 00 00       	call   8022d9 <sys_cgetc>
  80065d:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  800660:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800664:	74 f2                	je     800658 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800666:	e8 0a 1e 00 00       	call   802475 <sys_enable_interrupt>
	return c;
  80066b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80066e:	c9                   	leave  
  80066f:	c3                   	ret    

00800670 <iscons>:

int iscons(int fdnum)
{
  800670:	55                   	push   %ebp
  800671:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800673:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800678:	5d                   	pop    %ebp
  800679:	c3                   	ret    

0080067a <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80067a:	55                   	push   %ebp
  80067b:	89 e5                	mov    %esp,%ebp
  80067d:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800680:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800684:	7e 0a                	jle    800690 <libmain+0x16>
		binaryname = argv[0];
  800686:	8b 45 0c             	mov    0xc(%ebp),%eax
  800689:	8b 00                	mov    (%eax),%eax
  80068b:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800690:	83 ec 08             	sub    $0x8,%esp
  800693:	ff 75 0c             	pushl  0xc(%ebp)
  800696:	ff 75 08             	pushl  0x8(%ebp)
  800699:	e8 9a f9 ff ff       	call   800038 <_main>
  80069e:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8006a1:	e8 67 1c 00 00       	call   80230d <sys_getenvid>
  8006a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  8006a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006ac:	89 d0                	mov    %edx,%eax
  8006ae:	c1 e0 03             	shl    $0x3,%eax
  8006b1:	01 d0                	add    %edx,%eax
  8006b3:	01 c0                	add    %eax,%eax
  8006b5:	01 d0                	add    %edx,%eax
  8006b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006be:	01 d0                	add    %edx,%eax
  8006c0:	c1 e0 03             	shl    $0x3,%eax
  8006c3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006c8:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  8006cb:	e8 8b 1d 00 00       	call   80245b <sys_disable_interrupt>
		cprintf("**************************************\n");
  8006d0:	83 ec 0c             	sub    $0xc,%esp
  8006d3:	68 14 2c 80 00       	push   $0x802c14
  8006d8:	e8 89 01 00 00       	call   800866 <cprintf>
  8006dd:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  8006e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e3:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  8006e9:	83 ec 08             	sub    $0x8,%esp
  8006ec:	50                   	push   %eax
  8006ed:	68 3c 2c 80 00       	push   $0x802c3c
  8006f2:	e8 6f 01 00 00       	call   800866 <cprintf>
  8006f7:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8006fa:	83 ec 0c             	sub    $0xc,%esp
  8006fd:	68 14 2c 80 00       	push   $0x802c14
  800702:	e8 5f 01 00 00       	call   800866 <cprintf>
  800707:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80070a:	e8 66 1d 00 00       	call   802475 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80070f:	e8 19 00 00 00       	call   80072d <exit>
}
  800714:	90                   	nop
  800715:	c9                   	leave  
  800716:	c3                   	ret    

00800717 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800717:	55                   	push   %ebp
  800718:	89 e5                	mov    %esp,%ebp
  80071a:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80071d:	83 ec 0c             	sub    $0xc,%esp
  800720:	6a 00                	push   $0x0
  800722:	e8 cb 1b 00 00       	call   8022f2 <sys_env_destroy>
  800727:	83 c4 10             	add    $0x10,%esp
}
  80072a:	90                   	nop
  80072b:	c9                   	leave  
  80072c:	c3                   	ret    

0080072d <exit>:

void
exit(void)
{
  80072d:	55                   	push   %ebp
  80072e:	89 e5                	mov    %esp,%ebp
  800730:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800733:	e8 ee 1b 00 00       	call   802326 <sys_env_exit>
}
  800738:	90                   	nop
  800739:	c9                   	leave  
  80073a:	c3                   	ret    

0080073b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80073b:	55                   	push   %ebp
  80073c:	89 e5                	mov    %esp,%ebp
  80073e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800741:	8d 45 10             	lea    0x10(%ebp),%eax
  800744:	83 c0 04             	add    $0x4,%eax
  800747:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  80074a:	a1 70 40 98 00       	mov    0x984070,%eax
  80074f:	85 c0                	test   %eax,%eax
  800751:	74 16                	je     800769 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800753:	a1 70 40 98 00       	mov    0x984070,%eax
  800758:	83 ec 08             	sub    $0x8,%esp
  80075b:	50                   	push   %eax
  80075c:	68 55 2c 80 00       	push   $0x802c55
  800761:	e8 00 01 00 00       	call   800866 <cprintf>
  800766:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800769:	a1 00 40 80 00       	mov    0x804000,%eax
  80076e:	ff 75 0c             	pushl  0xc(%ebp)
  800771:	ff 75 08             	pushl  0x8(%ebp)
  800774:	50                   	push   %eax
  800775:	68 5a 2c 80 00       	push   $0x802c5a
  80077a:	e8 e7 00 00 00       	call   800866 <cprintf>
  80077f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800782:	8b 45 10             	mov    0x10(%ebp),%eax
  800785:	83 ec 08             	sub    $0x8,%esp
  800788:	ff 75 f4             	pushl  -0xc(%ebp)
  80078b:	50                   	push   %eax
  80078c:	e8 7a 00 00 00       	call   80080b <vcprintf>
  800791:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  800794:	83 ec 0c             	sub    $0xc,%esp
  800797:	68 76 2c 80 00       	push   $0x802c76
  80079c:	e8 c5 00 00 00       	call   800866 <cprintf>
  8007a1:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007a4:	e8 84 ff ff ff       	call   80072d <exit>

	// should not return here
	while (1) ;
  8007a9:	eb fe                	jmp    8007a9 <_panic+0x6e>

008007ab <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8007ab:	55                   	push   %ebp
  8007ac:	89 e5                	mov    %esp,%ebp
  8007ae:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8007b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b4:	8b 00                	mov    (%eax),%eax
  8007b6:	8d 48 01             	lea    0x1(%eax),%ecx
  8007b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007bc:	89 0a                	mov    %ecx,(%edx)
  8007be:	8b 55 08             	mov    0x8(%ebp),%edx
  8007c1:	88 d1                	mov    %dl,%cl
  8007c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8007ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007cd:	8b 00                	mov    (%eax),%eax
  8007cf:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007d4:	75 23                	jne    8007f9 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  8007d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d9:	8b 00                	mov    (%eax),%eax
  8007db:	89 c2                	mov    %eax,%edx
  8007dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e0:	83 c0 08             	add    $0x8,%eax
  8007e3:	83 ec 08             	sub    $0x8,%esp
  8007e6:	52                   	push   %edx
  8007e7:	50                   	push   %eax
  8007e8:	e8 cf 1a 00 00       	call   8022bc <sys_cputs>
  8007ed:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8007f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8007f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007fc:	8b 40 04             	mov    0x4(%eax),%eax
  8007ff:	8d 50 01             	lea    0x1(%eax),%edx
  800802:	8b 45 0c             	mov    0xc(%ebp),%eax
  800805:	89 50 04             	mov    %edx,0x4(%eax)
}
  800808:	90                   	nop
  800809:	c9                   	leave  
  80080a:	c3                   	ret    

0080080b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80080b:	55                   	push   %ebp
  80080c:	89 e5                	mov    %esp,%ebp
  80080e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800814:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80081b:	00 00 00 
	b.cnt = 0;
  80081e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800825:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800828:	ff 75 0c             	pushl  0xc(%ebp)
  80082b:	ff 75 08             	pushl  0x8(%ebp)
  80082e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800834:	50                   	push   %eax
  800835:	68 ab 07 80 00       	push   $0x8007ab
  80083a:	e8 fa 01 00 00       	call   800a39 <vprintfmt>
  80083f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  800842:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800848:	83 ec 08             	sub    $0x8,%esp
  80084b:	50                   	push   %eax
  80084c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800852:	83 c0 08             	add    $0x8,%eax
  800855:	50                   	push   %eax
  800856:	e8 61 1a 00 00       	call   8022bc <sys_cputs>
  80085b:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  80085e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800864:	c9                   	leave  
  800865:	c3                   	ret    

00800866 <cprintf>:

int cprintf(const char *fmt, ...) {
  800866:	55                   	push   %ebp
  800867:	89 e5                	mov    %esp,%ebp
  800869:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80086c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80086f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800872:	8b 45 08             	mov    0x8(%ebp),%eax
  800875:	83 ec 08             	sub    $0x8,%esp
  800878:	ff 75 f4             	pushl  -0xc(%ebp)
  80087b:	50                   	push   %eax
  80087c:	e8 8a ff ff ff       	call   80080b <vcprintf>
  800881:	83 c4 10             	add    $0x10,%esp
  800884:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800887:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80088a:	c9                   	leave  
  80088b:	c3                   	ret    

0080088c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80088c:	55                   	push   %ebp
  80088d:	89 e5                	mov    %esp,%ebp
  80088f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800892:	e8 c4 1b 00 00       	call   80245b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800897:	8d 45 0c             	lea    0xc(%ebp),%eax
  80089a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80089d:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a0:	83 ec 08             	sub    $0x8,%esp
  8008a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8008a6:	50                   	push   %eax
  8008a7:	e8 5f ff ff ff       	call   80080b <vcprintf>
  8008ac:	83 c4 10             	add    $0x10,%esp
  8008af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8008b2:	e8 be 1b 00 00       	call   802475 <sys_enable_interrupt>
	return cnt;
  8008b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008ba:	c9                   	leave  
  8008bb:	c3                   	ret    

008008bc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008bc:	55                   	push   %ebp
  8008bd:	89 e5                	mov    %esp,%ebp
  8008bf:	53                   	push   %ebx
  8008c0:	83 ec 14             	sub    $0x14,%esp
  8008c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008cf:	8b 45 18             	mov    0x18(%ebp),%eax
  8008d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008da:	77 55                	ja     800931 <printnum+0x75>
  8008dc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008df:	72 05                	jb     8008e6 <printnum+0x2a>
  8008e1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8008e4:	77 4b                	ja     800931 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008e6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8008e9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008ec:	8b 45 18             	mov    0x18(%ebp),%eax
  8008ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f4:	52                   	push   %edx
  8008f5:	50                   	push   %eax
  8008f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8008f9:	ff 75 f0             	pushl  -0x10(%ebp)
  8008fc:	e8 f7 1e 00 00       	call   8027f8 <__udivdi3>
  800901:	83 c4 10             	add    $0x10,%esp
  800904:	83 ec 04             	sub    $0x4,%esp
  800907:	ff 75 20             	pushl  0x20(%ebp)
  80090a:	53                   	push   %ebx
  80090b:	ff 75 18             	pushl  0x18(%ebp)
  80090e:	52                   	push   %edx
  80090f:	50                   	push   %eax
  800910:	ff 75 0c             	pushl  0xc(%ebp)
  800913:	ff 75 08             	pushl  0x8(%ebp)
  800916:	e8 a1 ff ff ff       	call   8008bc <printnum>
  80091b:	83 c4 20             	add    $0x20,%esp
  80091e:	eb 1a                	jmp    80093a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800920:	83 ec 08             	sub    $0x8,%esp
  800923:	ff 75 0c             	pushl  0xc(%ebp)
  800926:	ff 75 20             	pushl  0x20(%ebp)
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	ff d0                	call   *%eax
  80092e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800931:	ff 4d 1c             	decl   0x1c(%ebp)
  800934:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800938:	7f e6                	jg     800920 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80093a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80093d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800942:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800945:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800948:	53                   	push   %ebx
  800949:	51                   	push   %ecx
  80094a:	52                   	push   %edx
  80094b:	50                   	push   %eax
  80094c:	e8 b7 1f 00 00       	call   802908 <__umoddi3>
  800951:	83 c4 10             	add    $0x10,%esp
  800954:	05 94 2e 80 00       	add    $0x802e94,%eax
  800959:	8a 00                	mov    (%eax),%al
  80095b:	0f be c0             	movsbl %al,%eax
  80095e:	83 ec 08             	sub    $0x8,%esp
  800961:	ff 75 0c             	pushl  0xc(%ebp)
  800964:	50                   	push   %eax
  800965:	8b 45 08             	mov    0x8(%ebp),%eax
  800968:	ff d0                	call   *%eax
  80096a:	83 c4 10             	add    $0x10,%esp
}
  80096d:	90                   	nop
  80096e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800971:	c9                   	leave  
  800972:	c3                   	ret    

00800973 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800976:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80097a:	7e 1c                	jle    800998 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80097c:	8b 45 08             	mov    0x8(%ebp),%eax
  80097f:	8b 00                	mov    (%eax),%eax
  800981:	8d 50 08             	lea    0x8(%eax),%edx
  800984:	8b 45 08             	mov    0x8(%ebp),%eax
  800987:	89 10                	mov    %edx,(%eax)
  800989:	8b 45 08             	mov    0x8(%ebp),%eax
  80098c:	8b 00                	mov    (%eax),%eax
  80098e:	83 e8 08             	sub    $0x8,%eax
  800991:	8b 50 04             	mov    0x4(%eax),%edx
  800994:	8b 00                	mov    (%eax),%eax
  800996:	eb 40                	jmp    8009d8 <getuint+0x65>
	else if (lflag)
  800998:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80099c:	74 1e                	je     8009bc <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	8b 00                	mov    (%eax),%eax
  8009a3:	8d 50 04             	lea    0x4(%eax),%edx
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	89 10                	mov    %edx,(%eax)
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	8b 00                	mov    (%eax),%eax
  8009b0:	83 e8 04             	sub    $0x4,%eax
  8009b3:	8b 00                	mov    (%eax),%eax
  8009b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ba:	eb 1c                	jmp    8009d8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8009bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bf:	8b 00                	mov    (%eax),%eax
  8009c1:	8d 50 04             	lea    0x4(%eax),%edx
  8009c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c7:	89 10                	mov    %edx,(%eax)
  8009c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cc:	8b 00                	mov    (%eax),%eax
  8009ce:	83 e8 04             	sub    $0x4,%eax
  8009d1:	8b 00                	mov    (%eax),%eax
  8009d3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8009d8:	5d                   	pop    %ebp
  8009d9:	c3                   	ret    

008009da <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009dd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009e1:	7e 1c                	jle    8009ff <getint+0x25>
		return va_arg(*ap, long long);
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	8b 00                	mov    (%eax),%eax
  8009e8:	8d 50 08             	lea    0x8(%eax),%edx
  8009eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ee:	89 10                	mov    %edx,(%eax)
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	8b 00                	mov    (%eax),%eax
  8009f5:	83 e8 08             	sub    $0x8,%eax
  8009f8:	8b 50 04             	mov    0x4(%eax),%edx
  8009fb:	8b 00                	mov    (%eax),%eax
  8009fd:	eb 38                	jmp    800a37 <getint+0x5d>
	else if (lflag)
  8009ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a03:	74 1a                	je     800a1f <getint+0x45>
		return va_arg(*ap, long);
  800a05:	8b 45 08             	mov    0x8(%ebp),%eax
  800a08:	8b 00                	mov    (%eax),%eax
  800a0a:	8d 50 04             	lea    0x4(%eax),%edx
  800a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a10:	89 10                	mov    %edx,(%eax)
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	8b 00                	mov    (%eax),%eax
  800a17:	83 e8 04             	sub    $0x4,%eax
  800a1a:	8b 00                	mov    (%eax),%eax
  800a1c:	99                   	cltd   
  800a1d:	eb 18                	jmp    800a37 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a22:	8b 00                	mov    (%eax),%eax
  800a24:	8d 50 04             	lea    0x4(%eax),%edx
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	89 10                	mov    %edx,(%eax)
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	8b 00                	mov    (%eax),%eax
  800a31:	83 e8 04             	sub    $0x4,%eax
  800a34:	8b 00                	mov    (%eax),%eax
  800a36:	99                   	cltd   
}
  800a37:	5d                   	pop    %ebp
  800a38:	c3                   	ret    

00800a39 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a39:	55                   	push   %ebp
  800a3a:	89 e5                	mov    %esp,%ebp
  800a3c:	56                   	push   %esi
  800a3d:	53                   	push   %ebx
  800a3e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a41:	eb 17                	jmp    800a5a <vprintfmt+0x21>
			if (ch == '\0')
  800a43:	85 db                	test   %ebx,%ebx
  800a45:	0f 84 af 03 00 00    	je     800dfa <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800a4b:	83 ec 08             	sub    $0x8,%esp
  800a4e:	ff 75 0c             	pushl  0xc(%ebp)
  800a51:	53                   	push   %ebx
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	ff d0                	call   *%eax
  800a57:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a5d:	8d 50 01             	lea    0x1(%eax),%edx
  800a60:	89 55 10             	mov    %edx,0x10(%ebp)
  800a63:	8a 00                	mov    (%eax),%al
  800a65:	0f b6 d8             	movzbl %al,%ebx
  800a68:	83 fb 25             	cmp    $0x25,%ebx
  800a6b:	75 d6                	jne    800a43 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a6d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a71:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a78:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a7f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a86:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800a90:	8d 50 01             	lea    0x1(%eax),%edx
  800a93:	89 55 10             	mov    %edx,0x10(%ebp)
  800a96:	8a 00                	mov    (%eax),%al
  800a98:	0f b6 d8             	movzbl %al,%ebx
  800a9b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a9e:	83 f8 55             	cmp    $0x55,%eax
  800aa1:	0f 87 2b 03 00 00    	ja     800dd2 <vprintfmt+0x399>
  800aa7:	8b 04 85 b8 2e 80 00 	mov    0x802eb8(,%eax,4),%eax
  800aae:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ab0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ab4:	eb d7                	jmp    800a8d <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ab6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800aba:	eb d1                	jmp    800a8d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800abc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ac3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ac6:	89 d0                	mov    %edx,%eax
  800ac8:	c1 e0 02             	shl    $0x2,%eax
  800acb:	01 d0                	add    %edx,%eax
  800acd:	01 c0                	add    %eax,%eax
  800acf:	01 d8                	add    %ebx,%eax
  800ad1:	83 e8 30             	sub    $0x30,%eax
  800ad4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ad7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ada:	8a 00                	mov    (%eax),%al
  800adc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800adf:	83 fb 2f             	cmp    $0x2f,%ebx
  800ae2:	7e 3e                	jle    800b22 <vprintfmt+0xe9>
  800ae4:	83 fb 39             	cmp    $0x39,%ebx
  800ae7:	7f 39                	jg     800b22 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ae9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800aec:	eb d5                	jmp    800ac3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800aee:	8b 45 14             	mov    0x14(%ebp),%eax
  800af1:	83 c0 04             	add    $0x4,%eax
  800af4:	89 45 14             	mov    %eax,0x14(%ebp)
  800af7:	8b 45 14             	mov    0x14(%ebp),%eax
  800afa:	83 e8 04             	sub    $0x4,%eax
  800afd:	8b 00                	mov    (%eax),%eax
  800aff:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800b02:	eb 1f                	jmp    800b23 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800b04:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b08:	79 83                	jns    800a8d <vprintfmt+0x54>
				width = 0;
  800b0a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800b11:	e9 77 ff ff ff       	jmp    800a8d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800b16:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b1d:	e9 6b ff ff ff       	jmp    800a8d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b22:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b23:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b27:	0f 89 60 ff ff ff    	jns    800a8d <vprintfmt+0x54>
				width = precision, precision = -1;
  800b2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b33:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b3a:	e9 4e ff ff ff       	jmp    800a8d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b3f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b42:	e9 46 ff ff ff       	jmp    800a8d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b47:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4a:	83 c0 04             	add    $0x4,%eax
  800b4d:	89 45 14             	mov    %eax,0x14(%ebp)
  800b50:	8b 45 14             	mov    0x14(%ebp),%eax
  800b53:	83 e8 04             	sub    $0x4,%eax
  800b56:	8b 00                	mov    (%eax),%eax
  800b58:	83 ec 08             	sub    $0x8,%esp
  800b5b:	ff 75 0c             	pushl  0xc(%ebp)
  800b5e:	50                   	push   %eax
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	ff d0                	call   *%eax
  800b64:	83 c4 10             	add    $0x10,%esp
			break;
  800b67:	e9 89 02 00 00       	jmp    800df5 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6f:	83 c0 04             	add    $0x4,%eax
  800b72:	89 45 14             	mov    %eax,0x14(%ebp)
  800b75:	8b 45 14             	mov    0x14(%ebp),%eax
  800b78:	83 e8 04             	sub    $0x4,%eax
  800b7b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b7d:	85 db                	test   %ebx,%ebx
  800b7f:	79 02                	jns    800b83 <vprintfmt+0x14a>
				err = -err;
  800b81:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b83:	83 fb 64             	cmp    $0x64,%ebx
  800b86:	7f 0b                	jg     800b93 <vprintfmt+0x15a>
  800b88:	8b 34 9d 00 2d 80 00 	mov    0x802d00(,%ebx,4),%esi
  800b8f:	85 f6                	test   %esi,%esi
  800b91:	75 19                	jne    800bac <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b93:	53                   	push   %ebx
  800b94:	68 a5 2e 80 00       	push   $0x802ea5
  800b99:	ff 75 0c             	pushl  0xc(%ebp)
  800b9c:	ff 75 08             	pushl  0x8(%ebp)
  800b9f:	e8 5e 02 00 00       	call   800e02 <printfmt>
  800ba4:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ba7:	e9 49 02 00 00       	jmp    800df5 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800bac:	56                   	push   %esi
  800bad:	68 ae 2e 80 00       	push   $0x802eae
  800bb2:	ff 75 0c             	pushl  0xc(%ebp)
  800bb5:	ff 75 08             	pushl  0x8(%ebp)
  800bb8:	e8 45 02 00 00       	call   800e02 <printfmt>
  800bbd:	83 c4 10             	add    $0x10,%esp
			break;
  800bc0:	e9 30 02 00 00       	jmp    800df5 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800bc5:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc8:	83 c0 04             	add    $0x4,%eax
  800bcb:	89 45 14             	mov    %eax,0x14(%ebp)
  800bce:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd1:	83 e8 04             	sub    $0x4,%eax
  800bd4:	8b 30                	mov    (%eax),%esi
  800bd6:	85 f6                	test   %esi,%esi
  800bd8:	75 05                	jne    800bdf <vprintfmt+0x1a6>
				p = "(null)";
  800bda:	be b1 2e 80 00       	mov    $0x802eb1,%esi
			if (width > 0 && padc != '-')
  800bdf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800be3:	7e 6d                	jle    800c52 <vprintfmt+0x219>
  800be5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800be9:	74 67                	je     800c52 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800beb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bee:	83 ec 08             	sub    $0x8,%esp
  800bf1:	50                   	push   %eax
  800bf2:	56                   	push   %esi
  800bf3:	e8 12 05 00 00       	call   80110a <strnlen>
  800bf8:	83 c4 10             	add    $0x10,%esp
  800bfb:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800bfe:	eb 16                	jmp    800c16 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800c00:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800c04:	83 ec 08             	sub    $0x8,%esp
  800c07:	ff 75 0c             	pushl  0xc(%ebp)
  800c0a:	50                   	push   %eax
  800c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0e:	ff d0                	call   *%eax
  800c10:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c13:	ff 4d e4             	decl   -0x1c(%ebp)
  800c16:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c1a:	7f e4                	jg     800c00 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c1c:	eb 34                	jmp    800c52 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c1e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c22:	74 1c                	je     800c40 <vprintfmt+0x207>
  800c24:	83 fb 1f             	cmp    $0x1f,%ebx
  800c27:	7e 05                	jle    800c2e <vprintfmt+0x1f5>
  800c29:	83 fb 7e             	cmp    $0x7e,%ebx
  800c2c:	7e 12                	jle    800c40 <vprintfmt+0x207>
					putch('?', putdat);
  800c2e:	83 ec 08             	sub    $0x8,%esp
  800c31:	ff 75 0c             	pushl  0xc(%ebp)
  800c34:	6a 3f                	push   $0x3f
  800c36:	8b 45 08             	mov    0x8(%ebp),%eax
  800c39:	ff d0                	call   *%eax
  800c3b:	83 c4 10             	add    $0x10,%esp
  800c3e:	eb 0f                	jmp    800c4f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c40:	83 ec 08             	sub    $0x8,%esp
  800c43:	ff 75 0c             	pushl  0xc(%ebp)
  800c46:	53                   	push   %ebx
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	ff d0                	call   *%eax
  800c4c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c4f:	ff 4d e4             	decl   -0x1c(%ebp)
  800c52:	89 f0                	mov    %esi,%eax
  800c54:	8d 70 01             	lea    0x1(%eax),%esi
  800c57:	8a 00                	mov    (%eax),%al
  800c59:	0f be d8             	movsbl %al,%ebx
  800c5c:	85 db                	test   %ebx,%ebx
  800c5e:	74 24                	je     800c84 <vprintfmt+0x24b>
  800c60:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c64:	78 b8                	js     800c1e <vprintfmt+0x1e5>
  800c66:	ff 4d e0             	decl   -0x20(%ebp)
  800c69:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c6d:	79 af                	jns    800c1e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c6f:	eb 13                	jmp    800c84 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c71:	83 ec 08             	sub    $0x8,%esp
  800c74:	ff 75 0c             	pushl  0xc(%ebp)
  800c77:	6a 20                	push   $0x20
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	ff d0                	call   *%eax
  800c7e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c81:	ff 4d e4             	decl   -0x1c(%ebp)
  800c84:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c88:	7f e7                	jg     800c71 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c8a:	e9 66 01 00 00       	jmp    800df5 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c8f:	83 ec 08             	sub    $0x8,%esp
  800c92:	ff 75 e8             	pushl  -0x18(%ebp)
  800c95:	8d 45 14             	lea    0x14(%ebp),%eax
  800c98:	50                   	push   %eax
  800c99:	e8 3c fd ff ff       	call   8009da <getint>
  800c9e:	83 c4 10             	add    $0x10,%esp
  800ca1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ca7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800caa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cad:	85 d2                	test   %edx,%edx
  800caf:	79 23                	jns    800cd4 <vprintfmt+0x29b>
				putch('-', putdat);
  800cb1:	83 ec 08             	sub    $0x8,%esp
  800cb4:	ff 75 0c             	pushl  0xc(%ebp)
  800cb7:	6a 2d                	push   $0x2d
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	ff d0                	call   *%eax
  800cbe:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cc7:	f7 d8                	neg    %eax
  800cc9:	83 d2 00             	adc    $0x0,%edx
  800ccc:	f7 da                	neg    %edx
  800cce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800cd4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cdb:	e9 bc 00 00 00       	jmp    800d9c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ce0:	83 ec 08             	sub    $0x8,%esp
  800ce3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ce6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ce9:	50                   	push   %eax
  800cea:	e8 84 fc ff ff       	call   800973 <getuint>
  800cef:	83 c4 10             	add    $0x10,%esp
  800cf2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cf5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800cf8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cff:	e9 98 00 00 00       	jmp    800d9c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d04:	83 ec 08             	sub    $0x8,%esp
  800d07:	ff 75 0c             	pushl  0xc(%ebp)
  800d0a:	6a 58                	push   $0x58
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	ff d0                	call   *%eax
  800d11:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d14:	83 ec 08             	sub    $0x8,%esp
  800d17:	ff 75 0c             	pushl  0xc(%ebp)
  800d1a:	6a 58                	push   $0x58
  800d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1f:	ff d0                	call   *%eax
  800d21:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d24:	83 ec 08             	sub    $0x8,%esp
  800d27:	ff 75 0c             	pushl  0xc(%ebp)
  800d2a:	6a 58                	push   $0x58
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	ff d0                	call   *%eax
  800d31:	83 c4 10             	add    $0x10,%esp
			break;
  800d34:	e9 bc 00 00 00       	jmp    800df5 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800d39:	83 ec 08             	sub    $0x8,%esp
  800d3c:	ff 75 0c             	pushl  0xc(%ebp)
  800d3f:	6a 30                	push   $0x30
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	ff d0                	call   *%eax
  800d46:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d49:	83 ec 08             	sub    $0x8,%esp
  800d4c:	ff 75 0c             	pushl  0xc(%ebp)
  800d4f:	6a 78                	push   $0x78
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	ff d0                	call   *%eax
  800d56:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d59:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5c:	83 c0 04             	add    $0x4,%eax
  800d5f:	89 45 14             	mov    %eax,0x14(%ebp)
  800d62:	8b 45 14             	mov    0x14(%ebp),%eax
  800d65:	83 e8 04             	sub    $0x4,%eax
  800d68:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d6d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d74:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d7b:	eb 1f                	jmp    800d9c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d7d:	83 ec 08             	sub    $0x8,%esp
  800d80:	ff 75 e8             	pushl  -0x18(%ebp)
  800d83:	8d 45 14             	lea    0x14(%ebp),%eax
  800d86:	50                   	push   %eax
  800d87:	e8 e7 fb ff ff       	call   800973 <getuint>
  800d8c:	83 c4 10             	add    $0x10,%esp
  800d8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d92:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d95:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d9c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800da0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800da3:	83 ec 04             	sub    $0x4,%esp
  800da6:	52                   	push   %edx
  800da7:	ff 75 e4             	pushl  -0x1c(%ebp)
  800daa:	50                   	push   %eax
  800dab:	ff 75 f4             	pushl  -0xc(%ebp)
  800dae:	ff 75 f0             	pushl  -0x10(%ebp)
  800db1:	ff 75 0c             	pushl  0xc(%ebp)
  800db4:	ff 75 08             	pushl  0x8(%ebp)
  800db7:	e8 00 fb ff ff       	call   8008bc <printnum>
  800dbc:	83 c4 20             	add    $0x20,%esp
			break;
  800dbf:	eb 34                	jmp    800df5 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800dc1:	83 ec 08             	sub    $0x8,%esp
  800dc4:	ff 75 0c             	pushl  0xc(%ebp)
  800dc7:	53                   	push   %ebx
  800dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcb:	ff d0                	call   *%eax
  800dcd:	83 c4 10             	add    $0x10,%esp
			break;
  800dd0:	eb 23                	jmp    800df5 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dd2:	83 ec 08             	sub    $0x8,%esp
  800dd5:	ff 75 0c             	pushl  0xc(%ebp)
  800dd8:	6a 25                	push   $0x25
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	ff d0                	call   *%eax
  800ddf:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800de2:	ff 4d 10             	decl   0x10(%ebp)
  800de5:	eb 03                	jmp    800dea <vprintfmt+0x3b1>
  800de7:	ff 4d 10             	decl   0x10(%ebp)
  800dea:	8b 45 10             	mov    0x10(%ebp),%eax
  800ded:	48                   	dec    %eax
  800dee:	8a 00                	mov    (%eax),%al
  800df0:	3c 25                	cmp    $0x25,%al
  800df2:	75 f3                	jne    800de7 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800df4:	90                   	nop
		}
	}
  800df5:	e9 47 fc ff ff       	jmp    800a41 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800dfa:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800dfb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800dfe:	5b                   	pop    %ebx
  800dff:	5e                   	pop    %esi
  800e00:	5d                   	pop    %ebp
  800e01:	c3                   	ret    

00800e02 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e02:	55                   	push   %ebp
  800e03:	89 e5                	mov    %esp,%ebp
  800e05:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800e08:	8d 45 10             	lea    0x10(%ebp),%eax
  800e0b:	83 c0 04             	add    $0x4,%eax
  800e0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e11:	8b 45 10             	mov    0x10(%ebp),%eax
  800e14:	ff 75 f4             	pushl  -0xc(%ebp)
  800e17:	50                   	push   %eax
  800e18:	ff 75 0c             	pushl  0xc(%ebp)
  800e1b:	ff 75 08             	pushl  0x8(%ebp)
  800e1e:	e8 16 fc ff ff       	call   800a39 <vprintfmt>
  800e23:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e26:	90                   	nop
  800e27:	c9                   	leave  
  800e28:	c3                   	ret    

00800e29 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e29:	55                   	push   %ebp
  800e2a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2f:	8b 40 08             	mov    0x8(%eax),%eax
  800e32:	8d 50 01             	lea    0x1(%eax),%edx
  800e35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e38:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3e:	8b 10                	mov    (%eax),%edx
  800e40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e43:	8b 40 04             	mov    0x4(%eax),%eax
  800e46:	39 c2                	cmp    %eax,%edx
  800e48:	73 12                	jae    800e5c <sprintputch+0x33>
		*b->buf++ = ch;
  800e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4d:	8b 00                	mov    (%eax),%eax
  800e4f:	8d 48 01             	lea    0x1(%eax),%ecx
  800e52:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e55:	89 0a                	mov    %ecx,(%edx)
  800e57:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5a:	88 10                	mov    %dl,(%eax)
}
  800e5c:	90                   	nop
  800e5d:	5d                   	pop    %ebp
  800e5e:	c3                   	ret    

00800e5f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e5f:	55                   	push   %ebp
  800e60:	89 e5                	mov    %esp,%ebp
  800e62:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
  800e68:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e71:	8b 45 08             	mov    0x8(%ebp),%eax
  800e74:	01 d0                	add    %edx,%eax
  800e76:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e80:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e84:	74 06                	je     800e8c <vsnprintf+0x2d>
  800e86:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e8a:	7f 07                	jg     800e93 <vsnprintf+0x34>
		return -E_INVAL;
  800e8c:	b8 03 00 00 00       	mov    $0x3,%eax
  800e91:	eb 20                	jmp    800eb3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e93:	ff 75 14             	pushl  0x14(%ebp)
  800e96:	ff 75 10             	pushl  0x10(%ebp)
  800e99:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e9c:	50                   	push   %eax
  800e9d:	68 29 0e 80 00       	push   $0x800e29
  800ea2:	e8 92 fb ff ff       	call   800a39 <vprintfmt>
  800ea7:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800eaa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ead:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800eb3:	c9                   	leave  
  800eb4:	c3                   	ret    

00800eb5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800eb5:	55                   	push   %ebp
  800eb6:	89 e5                	mov    %esp,%ebp
  800eb8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ebb:	8d 45 10             	lea    0x10(%ebp),%eax
  800ebe:	83 c0 04             	add    $0x4,%eax
  800ec1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ec4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec7:	ff 75 f4             	pushl  -0xc(%ebp)
  800eca:	50                   	push   %eax
  800ecb:	ff 75 0c             	pushl  0xc(%ebp)
  800ece:	ff 75 08             	pushl  0x8(%ebp)
  800ed1:	e8 89 ff ff ff       	call   800e5f <vsnprintf>
  800ed6:	83 c4 10             	add    $0x10,%esp
  800ed9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800edc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800edf:	c9                   	leave  
  800ee0:	c3                   	ret    

00800ee1 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800ee1:	55                   	push   %ebp
  800ee2:	89 e5                	mov    %esp,%ebp
  800ee4:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  800ee7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800eeb:	74 13                	je     800f00 <readline+0x1f>
		cprintf("%s", prompt);
  800eed:	83 ec 08             	sub    $0x8,%esp
  800ef0:	ff 75 08             	pushl  0x8(%ebp)
  800ef3:	68 10 30 80 00       	push   $0x803010
  800ef8:	e8 69 f9 ff ff       	call   800866 <cprintf>
  800efd:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800f00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800f07:	83 ec 0c             	sub    $0xc,%esp
  800f0a:	6a 00                	push   $0x0
  800f0c:	e8 5f f7 ff ff       	call   800670 <iscons>
  800f11:	83 c4 10             	add    $0x10,%esp
  800f14:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800f17:	e8 06 f7 ff ff       	call   800622 <getchar>
  800f1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800f1f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800f23:	79 22                	jns    800f47 <readline+0x66>
			if (c != -E_EOF)
  800f25:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800f29:	0f 84 ad 00 00 00    	je     800fdc <readline+0xfb>
				cprintf("read error: %e\n", c);
  800f2f:	83 ec 08             	sub    $0x8,%esp
  800f32:	ff 75 ec             	pushl  -0x14(%ebp)
  800f35:	68 13 30 80 00       	push   $0x803013
  800f3a:	e8 27 f9 ff ff       	call   800866 <cprintf>
  800f3f:	83 c4 10             	add    $0x10,%esp
			return;
  800f42:	e9 95 00 00 00       	jmp    800fdc <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800f47:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800f4b:	7e 34                	jle    800f81 <readline+0xa0>
  800f4d:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800f54:	7f 2b                	jg     800f81 <readline+0xa0>
			if (echoing)
  800f56:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f5a:	74 0e                	je     800f6a <readline+0x89>
				cputchar(c);
  800f5c:	83 ec 0c             	sub    $0xc,%esp
  800f5f:	ff 75 ec             	pushl  -0x14(%ebp)
  800f62:	e8 73 f6 ff ff       	call   8005da <cputchar>
  800f67:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f6d:	8d 50 01             	lea    0x1(%eax),%edx
  800f70:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800f73:	89 c2                	mov    %eax,%edx
  800f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f78:	01 d0                	add    %edx,%eax
  800f7a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f7d:	88 10                	mov    %dl,(%eax)
  800f7f:	eb 56                	jmp    800fd7 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800f81:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800f85:	75 1f                	jne    800fa6 <readline+0xc5>
  800f87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800f8b:	7e 19                	jle    800fa6 <readline+0xc5>
			if (echoing)
  800f8d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f91:	74 0e                	je     800fa1 <readline+0xc0>
				cputchar(c);
  800f93:	83 ec 0c             	sub    $0xc,%esp
  800f96:	ff 75 ec             	pushl  -0x14(%ebp)
  800f99:	e8 3c f6 ff ff       	call   8005da <cputchar>
  800f9e:	83 c4 10             	add    $0x10,%esp

			i--;
  800fa1:	ff 4d f4             	decl   -0xc(%ebp)
  800fa4:	eb 31                	jmp    800fd7 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800fa6:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800faa:	74 0a                	je     800fb6 <readline+0xd5>
  800fac:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800fb0:	0f 85 61 ff ff ff    	jne    800f17 <readline+0x36>
			if (echoing)
  800fb6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fba:	74 0e                	je     800fca <readline+0xe9>
				cputchar(c);
  800fbc:	83 ec 0c             	sub    $0xc,%esp
  800fbf:	ff 75 ec             	pushl  -0x14(%ebp)
  800fc2:	e8 13 f6 ff ff       	call   8005da <cputchar>
  800fc7:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800fca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd0:	01 d0                	add    %edx,%eax
  800fd2:	c6 00 00             	movb   $0x0,(%eax)
			return;
  800fd5:	eb 06                	jmp    800fdd <readline+0xfc>
		}
	}
  800fd7:	e9 3b ff ff ff       	jmp    800f17 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  800fdc:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  800fdd:	c9                   	leave  
  800fde:	c3                   	ret    

00800fdf <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800fe5:	e8 71 14 00 00       	call   80245b <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  800fea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fee:	74 13                	je     801003 <atomic_readline+0x24>
		cprintf("%s", prompt);
  800ff0:	83 ec 08             	sub    $0x8,%esp
  800ff3:	ff 75 08             	pushl  0x8(%ebp)
  800ff6:	68 10 30 80 00       	push   $0x803010
  800ffb:	e8 66 f8 ff ff       	call   800866 <cprintf>
  801000:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801003:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  80100a:	83 ec 0c             	sub    $0xc,%esp
  80100d:	6a 00                	push   $0x0
  80100f:	e8 5c f6 ff ff       	call   800670 <iscons>
  801014:	83 c4 10             	add    $0x10,%esp
  801017:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80101a:	e8 03 f6 ff ff       	call   800622 <getchar>
  80101f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801022:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801026:	79 23                	jns    80104b <atomic_readline+0x6c>
			if (c != -E_EOF)
  801028:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80102c:	74 13                	je     801041 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  80102e:	83 ec 08             	sub    $0x8,%esp
  801031:	ff 75 ec             	pushl  -0x14(%ebp)
  801034:	68 13 30 80 00       	push   $0x803013
  801039:	e8 28 f8 ff ff       	call   800866 <cprintf>
  80103e:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801041:	e8 2f 14 00 00       	call   802475 <sys_enable_interrupt>
			return;
  801046:	e9 9a 00 00 00       	jmp    8010e5 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80104b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80104f:	7e 34                	jle    801085 <atomic_readline+0xa6>
  801051:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801058:	7f 2b                	jg     801085 <atomic_readline+0xa6>
			if (echoing)
  80105a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80105e:	74 0e                	je     80106e <atomic_readline+0x8f>
				cputchar(c);
  801060:	83 ec 0c             	sub    $0xc,%esp
  801063:	ff 75 ec             	pushl  -0x14(%ebp)
  801066:	e8 6f f5 ff ff       	call   8005da <cputchar>
  80106b:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80106e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801071:	8d 50 01             	lea    0x1(%eax),%edx
  801074:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801077:	89 c2                	mov    %eax,%edx
  801079:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107c:	01 d0                	add    %edx,%eax
  80107e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801081:	88 10                	mov    %dl,(%eax)
  801083:	eb 5b                	jmp    8010e0 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  801085:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801089:	75 1f                	jne    8010aa <atomic_readline+0xcb>
  80108b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80108f:	7e 19                	jle    8010aa <atomic_readline+0xcb>
			if (echoing)
  801091:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801095:	74 0e                	je     8010a5 <atomic_readline+0xc6>
				cputchar(c);
  801097:	83 ec 0c             	sub    $0xc,%esp
  80109a:	ff 75 ec             	pushl  -0x14(%ebp)
  80109d:	e8 38 f5 ff ff       	call   8005da <cputchar>
  8010a2:	83 c4 10             	add    $0x10,%esp
			i--;
  8010a5:	ff 4d f4             	decl   -0xc(%ebp)
  8010a8:	eb 36                	jmp    8010e0 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  8010aa:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8010ae:	74 0a                	je     8010ba <atomic_readline+0xdb>
  8010b0:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8010b4:	0f 85 60 ff ff ff    	jne    80101a <atomic_readline+0x3b>
			if (echoing)
  8010ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8010be:	74 0e                	je     8010ce <atomic_readline+0xef>
				cputchar(c);
  8010c0:	83 ec 0c             	sub    $0xc,%esp
  8010c3:	ff 75 ec             	pushl  -0x14(%ebp)
  8010c6:	e8 0f f5 ff ff       	call   8005da <cputchar>
  8010cb:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8010ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d4:	01 d0                	add    %edx,%eax
  8010d6:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8010d9:	e8 97 13 00 00       	call   802475 <sys_enable_interrupt>
			return;
  8010de:	eb 05                	jmp    8010e5 <atomic_readline+0x106>
		}
	}
  8010e0:	e9 35 ff ff ff       	jmp    80101a <atomic_readline+0x3b>
}
  8010e5:	c9                   	leave  
  8010e6:	c3                   	ret    

008010e7 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
  8010ea:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8010ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010f4:	eb 06                	jmp    8010fc <strlen+0x15>
		n++;
  8010f6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010f9:	ff 45 08             	incl   0x8(%ebp)
  8010fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ff:	8a 00                	mov    (%eax),%al
  801101:	84 c0                	test   %al,%al
  801103:	75 f1                	jne    8010f6 <strlen+0xf>
		n++;
	return n;
  801105:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801108:	c9                   	leave  
  801109:	c3                   	ret    

0080110a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80110a:	55                   	push   %ebp
  80110b:	89 e5                	mov    %esp,%ebp
  80110d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801110:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801117:	eb 09                	jmp    801122 <strnlen+0x18>
		n++;
  801119:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80111c:	ff 45 08             	incl   0x8(%ebp)
  80111f:	ff 4d 0c             	decl   0xc(%ebp)
  801122:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801126:	74 09                	je     801131 <strnlen+0x27>
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
  80112b:	8a 00                	mov    (%eax),%al
  80112d:	84 c0                	test   %al,%al
  80112f:	75 e8                	jne    801119 <strnlen+0xf>
		n++;
	return n;
  801131:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801134:	c9                   	leave  
  801135:	c3                   	ret    

00801136 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
  801139:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801142:	90                   	nop
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	8d 50 01             	lea    0x1(%eax),%edx
  801149:	89 55 08             	mov    %edx,0x8(%ebp)
  80114c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80114f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801152:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801155:	8a 12                	mov    (%edx),%dl
  801157:	88 10                	mov    %dl,(%eax)
  801159:	8a 00                	mov    (%eax),%al
  80115b:	84 c0                	test   %al,%al
  80115d:	75 e4                	jne    801143 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80115f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801162:	c9                   	leave  
  801163:	c3                   	ret    

00801164 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801164:	55                   	push   %ebp
  801165:	89 e5                	mov    %esp,%ebp
  801167:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80116a:	8b 45 08             	mov    0x8(%ebp),%eax
  80116d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801170:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801177:	eb 1f                	jmp    801198 <strncpy+0x34>
		*dst++ = *src;
  801179:	8b 45 08             	mov    0x8(%ebp),%eax
  80117c:	8d 50 01             	lea    0x1(%eax),%edx
  80117f:	89 55 08             	mov    %edx,0x8(%ebp)
  801182:	8b 55 0c             	mov    0xc(%ebp),%edx
  801185:	8a 12                	mov    (%edx),%dl
  801187:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801189:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118c:	8a 00                	mov    (%eax),%al
  80118e:	84 c0                	test   %al,%al
  801190:	74 03                	je     801195 <strncpy+0x31>
			src++;
  801192:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801195:	ff 45 fc             	incl   -0x4(%ebp)
  801198:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80119b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80119e:	72 d9                	jb     801179 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011a3:	c9                   	leave  
  8011a4:	c3                   	ret    

008011a5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8011a5:	55                   	push   %ebp
  8011a6:	89 e5                	mov    %esp,%ebp
  8011a8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8011ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8011b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b5:	74 30                	je     8011e7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8011b7:	eb 16                	jmp    8011cf <strlcpy+0x2a>
			*dst++ = *src++;
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	8d 50 01             	lea    0x1(%eax),%edx
  8011bf:	89 55 08             	mov    %edx,0x8(%ebp)
  8011c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011c5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011c8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011cb:	8a 12                	mov    (%edx),%dl
  8011cd:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011cf:	ff 4d 10             	decl   0x10(%ebp)
  8011d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d6:	74 09                	je     8011e1 <strlcpy+0x3c>
  8011d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	84 c0                	test   %al,%al
  8011df:	75 d8                	jne    8011b9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8011e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ed:	29 c2                	sub    %eax,%edx
  8011ef:	89 d0                	mov    %edx,%eax
}
  8011f1:	c9                   	leave  
  8011f2:	c3                   	ret    

008011f3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8011f6:	eb 06                	jmp    8011fe <strcmp+0xb>
		p++, q++;
  8011f8:	ff 45 08             	incl   0x8(%ebp)
  8011fb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801201:	8a 00                	mov    (%eax),%al
  801203:	84 c0                	test   %al,%al
  801205:	74 0e                	je     801215 <strcmp+0x22>
  801207:	8b 45 08             	mov    0x8(%ebp),%eax
  80120a:	8a 10                	mov    (%eax),%dl
  80120c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	38 c2                	cmp    %al,%dl
  801213:	74 e3                	je     8011f8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	0f b6 d0             	movzbl %al,%edx
  80121d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801220:	8a 00                	mov    (%eax),%al
  801222:	0f b6 c0             	movzbl %al,%eax
  801225:	29 c2                	sub    %eax,%edx
  801227:	89 d0                	mov    %edx,%eax
}
  801229:	5d                   	pop    %ebp
  80122a:	c3                   	ret    

0080122b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80122b:	55                   	push   %ebp
  80122c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80122e:	eb 09                	jmp    801239 <strncmp+0xe>
		n--, p++, q++;
  801230:	ff 4d 10             	decl   0x10(%ebp)
  801233:	ff 45 08             	incl   0x8(%ebp)
  801236:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801239:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80123d:	74 17                	je     801256 <strncmp+0x2b>
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
  801242:	8a 00                	mov    (%eax),%al
  801244:	84 c0                	test   %al,%al
  801246:	74 0e                	je     801256 <strncmp+0x2b>
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
  80124b:	8a 10                	mov    (%eax),%dl
  80124d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801250:	8a 00                	mov    (%eax),%al
  801252:	38 c2                	cmp    %al,%dl
  801254:	74 da                	je     801230 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801256:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80125a:	75 07                	jne    801263 <strncmp+0x38>
		return 0;
  80125c:	b8 00 00 00 00       	mov    $0x0,%eax
  801261:	eb 14                	jmp    801277 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
  801266:	8a 00                	mov    (%eax),%al
  801268:	0f b6 d0             	movzbl %al,%edx
  80126b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126e:	8a 00                	mov    (%eax),%al
  801270:	0f b6 c0             	movzbl %al,%eax
  801273:	29 c2                	sub    %eax,%edx
  801275:	89 d0                	mov    %edx,%eax
}
  801277:	5d                   	pop    %ebp
  801278:	c3                   	ret    

00801279 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801279:	55                   	push   %ebp
  80127a:	89 e5                	mov    %esp,%ebp
  80127c:	83 ec 04             	sub    $0x4,%esp
  80127f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801282:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801285:	eb 12                	jmp    801299 <strchr+0x20>
		if (*s == c)
  801287:	8b 45 08             	mov    0x8(%ebp),%eax
  80128a:	8a 00                	mov    (%eax),%al
  80128c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80128f:	75 05                	jne    801296 <strchr+0x1d>
			return (char *) s;
  801291:	8b 45 08             	mov    0x8(%ebp),%eax
  801294:	eb 11                	jmp    8012a7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801296:	ff 45 08             	incl   0x8(%ebp)
  801299:	8b 45 08             	mov    0x8(%ebp),%eax
  80129c:	8a 00                	mov    (%eax),%al
  80129e:	84 c0                	test   %al,%al
  8012a0:	75 e5                	jne    801287 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8012a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012a7:	c9                   	leave  
  8012a8:	c3                   	ret    

008012a9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012a9:	55                   	push   %ebp
  8012aa:	89 e5                	mov    %esp,%ebp
  8012ac:	83 ec 04             	sub    $0x4,%esp
  8012af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012b5:	eb 0d                	jmp    8012c4 <strfind+0x1b>
		if (*s == c)
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	8a 00                	mov    (%eax),%al
  8012bc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012bf:	74 0e                	je     8012cf <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012c1:	ff 45 08             	incl   0x8(%ebp)
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	8a 00                	mov    (%eax),%al
  8012c9:	84 c0                	test   %al,%al
  8012cb:	75 ea                	jne    8012b7 <strfind+0xe>
  8012cd:	eb 01                	jmp    8012d0 <strfind+0x27>
		if (*s == c)
			break;
  8012cf:	90                   	nop
	return (char *) s;
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012d3:	c9                   	leave  
  8012d4:	c3                   	ret    

008012d5 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8012d5:	55                   	push   %ebp
  8012d6:	89 e5                	mov    %esp,%ebp
  8012d8:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8012db:	8b 45 08             	mov    0x8(%ebp),%eax
  8012de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8012e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8012e7:	eb 0e                	jmp    8012f7 <memset+0x22>
		*p++ = c;
  8012e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ec:	8d 50 01             	lea    0x1(%eax),%edx
  8012ef:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f5:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8012f7:	ff 4d f8             	decl   -0x8(%ebp)
  8012fa:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8012fe:	79 e9                	jns    8012e9 <memset+0x14>
		*p++ = c;

	return v;
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801303:	c9                   	leave  
  801304:	c3                   	ret    

00801305 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801305:	55                   	push   %ebp
  801306:	89 e5                	mov    %esp,%ebp
  801308:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80130b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801311:	8b 45 08             	mov    0x8(%ebp),%eax
  801314:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801317:	eb 16                	jmp    80132f <memcpy+0x2a>
		*d++ = *s++;
  801319:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131c:	8d 50 01             	lea    0x1(%eax),%edx
  80131f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801322:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801325:	8d 4a 01             	lea    0x1(%edx),%ecx
  801328:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80132b:	8a 12                	mov    (%edx),%dl
  80132d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80132f:	8b 45 10             	mov    0x10(%ebp),%eax
  801332:	8d 50 ff             	lea    -0x1(%eax),%edx
  801335:	89 55 10             	mov    %edx,0x10(%ebp)
  801338:	85 c0                	test   %eax,%eax
  80133a:	75 dd                	jne    801319 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80133c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80133f:	c9                   	leave  
  801340:	c3                   	ret    

00801341 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801341:	55                   	push   %ebp
  801342:	89 e5                	mov    %esp,%ebp
  801344:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  801347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80134d:	8b 45 08             	mov    0x8(%ebp),%eax
  801350:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801353:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801356:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801359:	73 50                	jae    8013ab <memmove+0x6a>
  80135b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80135e:	8b 45 10             	mov    0x10(%ebp),%eax
  801361:	01 d0                	add    %edx,%eax
  801363:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801366:	76 43                	jbe    8013ab <memmove+0x6a>
		s += n;
  801368:	8b 45 10             	mov    0x10(%ebp),%eax
  80136b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80136e:	8b 45 10             	mov    0x10(%ebp),%eax
  801371:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801374:	eb 10                	jmp    801386 <memmove+0x45>
			*--d = *--s;
  801376:	ff 4d f8             	decl   -0x8(%ebp)
  801379:	ff 4d fc             	decl   -0x4(%ebp)
  80137c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80137f:	8a 10                	mov    (%eax),%dl
  801381:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801384:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801386:	8b 45 10             	mov    0x10(%ebp),%eax
  801389:	8d 50 ff             	lea    -0x1(%eax),%edx
  80138c:	89 55 10             	mov    %edx,0x10(%ebp)
  80138f:	85 c0                	test   %eax,%eax
  801391:	75 e3                	jne    801376 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801393:	eb 23                	jmp    8013b8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801395:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801398:	8d 50 01             	lea    0x1(%eax),%edx
  80139b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80139e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013a1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013a4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013a7:	8a 12                	mov    (%edx),%dl
  8013a9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8013ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ae:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8013b4:	85 c0                	test   %eax,%eax
  8013b6:	75 dd                	jne    801395 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013bb:	c9                   	leave  
  8013bc:	c3                   	ret    

008013bd <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013bd:	55                   	push   %ebp
  8013be:	89 e5                	mov    %esp,%ebp
  8013c0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cc:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8013cf:	eb 2a                	jmp    8013fb <memcmp+0x3e>
		if (*s1 != *s2)
  8013d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d4:	8a 10                	mov    (%eax),%dl
  8013d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d9:	8a 00                	mov    (%eax),%al
  8013db:	38 c2                	cmp    %al,%dl
  8013dd:	74 16                	je     8013f5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8013df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013e2:	8a 00                	mov    (%eax),%al
  8013e4:	0f b6 d0             	movzbl %al,%edx
  8013e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ea:	8a 00                	mov    (%eax),%al
  8013ec:	0f b6 c0             	movzbl %al,%eax
  8013ef:	29 c2                	sub    %eax,%edx
  8013f1:	89 d0                	mov    %edx,%eax
  8013f3:	eb 18                	jmp    80140d <memcmp+0x50>
		s1++, s2++;
  8013f5:	ff 45 fc             	incl   -0x4(%ebp)
  8013f8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	8d 50 ff             	lea    -0x1(%eax),%edx
  801401:	89 55 10             	mov    %edx,0x10(%ebp)
  801404:	85 c0                	test   %eax,%eax
  801406:	75 c9                	jne    8013d1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801408:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80140d:	c9                   	leave  
  80140e:	c3                   	ret    

0080140f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80140f:	55                   	push   %ebp
  801410:	89 e5                	mov    %esp,%ebp
  801412:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801415:	8b 55 08             	mov    0x8(%ebp),%edx
  801418:	8b 45 10             	mov    0x10(%ebp),%eax
  80141b:	01 d0                	add    %edx,%eax
  80141d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801420:	eb 15                	jmp    801437 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801422:	8b 45 08             	mov    0x8(%ebp),%eax
  801425:	8a 00                	mov    (%eax),%al
  801427:	0f b6 d0             	movzbl %al,%edx
  80142a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142d:	0f b6 c0             	movzbl %al,%eax
  801430:	39 c2                	cmp    %eax,%edx
  801432:	74 0d                	je     801441 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801434:	ff 45 08             	incl   0x8(%ebp)
  801437:	8b 45 08             	mov    0x8(%ebp),%eax
  80143a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80143d:	72 e3                	jb     801422 <memfind+0x13>
  80143f:	eb 01                	jmp    801442 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801441:	90                   	nop
	return (void *) s;
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801445:	c9                   	leave  
  801446:	c3                   	ret    

00801447 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80144d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801454:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80145b:	eb 03                	jmp    801460 <strtol+0x19>
		s++;
  80145d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801460:	8b 45 08             	mov    0x8(%ebp),%eax
  801463:	8a 00                	mov    (%eax),%al
  801465:	3c 20                	cmp    $0x20,%al
  801467:	74 f4                	je     80145d <strtol+0x16>
  801469:	8b 45 08             	mov    0x8(%ebp),%eax
  80146c:	8a 00                	mov    (%eax),%al
  80146e:	3c 09                	cmp    $0x9,%al
  801470:	74 eb                	je     80145d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801472:	8b 45 08             	mov    0x8(%ebp),%eax
  801475:	8a 00                	mov    (%eax),%al
  801477:	3c 2b                	cmp    $0x2b,%al
  801479:	75 05                	jne    801480 <strtol+0x39>
		s++;
  80147b:	ff 45 08             	incl   0x8(%ebp)
  80147e:	eb 13                	jmp    801493 <strtol+0x4c>
	else if (*s == '-')
  801480:	8b 45 08             	mov    0x8(%ebp),%eax
  801483:	8a 00                	mov    (%eax),%al
  801485:	3c 2d                	cmp    $0x2d,%al
  801487:	75 0a                	jne    801493 <strtol+0x4c>
		s++, neg = 1;
  801489:	ff 45 08             	incl   0x8(%ebp)
  80148c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801493:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801497:	74 06                	je     80149f <strtol+0x58>
  801499:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80149d:	75 20                	jne    8014bf <strtol+0x78>
  80149f:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a2:	8a 00                	mov    (%eax),%al
  8014a4:	3c 30                	cmp    $0x30,%al
  8014a6:	75 17                	jne    8014bf <strtol+0x78>
  8014a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ab:	40                   	inc    %eax
  8014ac:	8a 00                	mov    (%eax),%al
  8014ae:	3c 78                	cmp    $0x78,%al
  8014b0:	75 0d                	jne    8014bf <strtol+0x78>
		s += 2, base = 16;
  8014b2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014b6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014bd:	eb 28                	jmp    8014e7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014c3:	75 15                	jne    8014da <strtol+0x93>
  8014c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c8:	8a 00                	mov    (%eax),%al
  8014ca:	3c 30                	cmp    $0x30,%al
  8014cc:	75 0c                	jne    8014da <strtol+0x93>
		s++, base = 8;
  8014ce:	ff 45 08             	incl   0x8(%ebp)
  8014d1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8014d8:	eb 0d                	jmp    8014e7 <strtol+0xa0>
	else if (base == 0)
  8014da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014de:	75 07                	jne    8014e7 <strtol+0xa0>
		base = 10;
  8014e0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ea:	8a 00                	mov    (%eax),%al
  8014ec:	3c 2f                	cmp    $0x2f,%al
  8014ee:	7e 19                	jle    801509 <strtol+0xc2>
  8014f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f3:	8a 00                	mov    (%eax),%al
  8014f5:	3c 39                	cmp    $0x39,%al
  8014f7:	7f 10                	jg     801509 <strtol+0xc2>
			dig = *s - '0';
  8014f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fc:	8a 00                	mov    (%eax),%al
  8014fe:	0f be c0             	movsbl %al,%eax
  801501:	83 e8 30             	sub    $0x30,%eax
  801504:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801507:	eb 42                	jmp    80154b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801509:	8b 45 08             	mov    0x8(%ebp),%eax
  80150c:	8a 00                	mov    (%eax),%al
  80150e:	3c 60                	cmp    $0x60,%al
  801510:	7e 19                	jle    80152b <strtol+0xe4>
  801512:	8b 45 08             	mov    0x8(%ebp),%eax
  801515:	8a 00                	mov    (%eax),%al
  801517:	3c 7a                	cmp    $0x7a,%al
  801519:	7f 10                	jg     80152b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80151b:	8b 45 08             	mov    0x8(%ebp),%eax
  80151e:	8a 00                	mov    (%eax),%al
  801520:	0f be c0             	movsbl %al,%eax
  801523:	83 e8 57             	sub    $0x57,%eax
  801526:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801529:	eb 20                	jmp    80154b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80152b:	8b 45 08             	mov    0x8(%ebp),%eax
  80152e:	8a 00                	mov    (%eax),%al
  801530:	3c 40                	cmp    $0x40,%al
  801532:	7e 39                	jle    80156d <strtol+0x126>
  801534:	8b 45 08             	mov    0x8(%ebp),%eax
  801537:	8a 00                	mov    (%eax),%al
  801539:	3c 5a                	cmp    $0x5a,%al
  80153b:	7f 30                	jg     80156d <strtol+0x126>
			dig = *s - 'A' + 10;
  80153d:	8b 45 08             	mov    0x8(%ebp),%eax
  801540:	8a 00                	mov    (%eax),%al
  801542:	0f be c0             	movsbl %al,%eax
  801545:	83 e8 37             	sub    $0x37,%eax
  801548:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80154b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80154e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801551:	7d 19                	jge    80156c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801553:	ff 45 08             	incl   0x8(%ebp)
  801556:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801559:	0f af 45 10          	imul   0x10(%ebp),%eax
  80155d:	89 c2                	mov    %eax,%edx
  80155f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801562:	01 d0                	add    %edx,%eax
  801564:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801567:	e9 7b ff ff ff       	jmp    8014e7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80156c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80156d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801571:	74 08                	je     80157b <strtol+0x134>
		*endptr = (char *) s;
  801573:	8b 45 0c             	mov    0xc(%ebp),%eax
  801576:	8b 55 08             	mov    0x8(%ebp),%edx
  801579:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80157b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80157f:	74 07                	je     801588 <strtol+0x141>
  801581:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801584:	f7 d8                	neg    %eax
  801586:	eb 03                	jmp    80158b <strtol+0x144>
  801588:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80158b:	c9                   	leave  
  80158c:	c3                   	ret    

0080158d <ltostr>:

void
ltostr(long value, char *str)
{
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
  801590:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801593:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80159a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8015a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015a5:	79 13                	jns    8015ba <ltostr+0x2d>
	{
		neg = 1;
  8015a7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8015ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8015b4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015b7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015c2:	99                   	cltd   
  8015c3:	f7 f9                	idiv   %ecx
  8015c5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015cb:	8d 50 01             	lea    0x1(%eax),%edx
  8015ce:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015d1:	89 c2                	mov    %eax,%edx
  8015d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d6:	01 d0                	add    %edx,%eax
  8015d8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015db:	83 c2 30             	add    $0x30,%edx
  8015de:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8015e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015e3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015e8:	f7 e9                	imul   %ecx
  8015ea:	c1 fa 02             	sar    $0x2,%edx
  8015ed:	89 c8                	mov    %ecx,%eax
  8015ef:	c1 f8 1f             	sar    $0x1f,%eax
  8015f2:	29 c2                	sub    %eax,%edx
  8015f4:	89 d0                	mov    %edx,%eax
  8015f6:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8015f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015fc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801601:	f7 e9                	imul   %ecx
  801603:	c1 fa 02             	sar    $0x2,%edx
  801606:	89 c8                	mov    %ecx,%eax
  801608:	c1 f8 1f             	sar    $0x1f,%eax
  80160b:	29 c2                	sub    %eax,%edx
  80160d:	89 d0                	mov    %edx,%eax
  80160f:	c1 e0 02             	shl    $0x2,%eax
  801612:	01 d0                	add    %edx,%eax
  801614:	01 c0                	add    %eax,%eax
  801616:	29 c1                	sub    %eax,%ecx
  801618:	89 ca                	mov    %ecx,%edx
  80161a:	85 d2                	test   %edx,%edx
  80161c:	75 9c                	jne    8015ba <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80161e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801625:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801628:	48                   	dec    %eax
  801629:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80162c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801630:	74 3d                	je     80166f <ltostr+0xe2>
		start = 1 ;
  801632:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801639:	eb 34                	jmp    80166f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80163b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80163e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801641:	01 d0                	add    %edx,%eax
  801643:	8a 00                	mov    (%eax),%al
  801645:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801648:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80164b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164e:	01 c2                	add    %eax,%edx
  801650:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801653:	8b 45 0c             	mov    0xc(%ebp),%eax
  801656:	01 c8                	add    %ecx,%eax
  801658:	8a 00                	mov    (%eax),%al
  80165a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80165c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80165f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801662:	01 c2                	add    %eax,%edx
  801664:	8a 45 eb             	mov    -0x15(%ebp),%al
  801667:	88 02                	mov    %al,(%edx)
		start++ ;
  801669:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80166c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80166f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801672:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801675:	7c c4                	jl     80163b <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801677:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80167a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167d:	01 d0                	add    %edx,%eax
  80167f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801682:	90                   	nop
  801683:	c9                   	leave  
  801684:	c3                   	ret    

00801685 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
  801688:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80168b:	ff 75 08             	pushl  0x8(%ebp)
  80168e:	e8 54 fa ff ff       	call   8010e7 <strlen>
  801693:	83 c4 04             	add    $0x4,%esp
  801696:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801699:	ff 75 0c             	pushl  0xc(%ebp)
  80169c:	e8 46 fa ff ff       	call   8010e7 <strlen>
  8016a1:	83 c4 04             	add    $0x4,%esp
  8016a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8016a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8016ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016b5:	eb 17                	jmp    8016ce <strcconcat+0x49>
		final[s] = str1[s] ;
  8016b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bd:	01 c2                	add    %eax,%edx
  8016bf:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	01 c8                	add    %ecx,%eax
  8016c7:	8a 00                	mov    (%eax),%al
  8016c9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016cb:	ff 45 fc             	incl   -0x4(%ebp)
  8016ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016d4:	7c e1                	jl     8016b7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016d6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016dd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016e4:	eb 1f                	jmp    801705 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e9:	8d 50 01             	lea    0x1(%eax),%edx
  8016ec:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016ef:	89 c2                	mov    %eax,%edx
  8016f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f4:	01 c2                	add    %eax,%edx
  8016f6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016fc:	01 c8                	add    %ecx,%eax
  8016fe:	8a 00                	mov    (%eax),%al
  801700:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801702:	ff 45 f8             	incl   -0x8(%ebp)
  801705:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801708:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80170b:	7c d9                	jl     8016e6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80170d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801710:	8b 45 10             	mov    0x10(%ebp),%eax
  801713:	01 d0                	add    %edx,%eax
  801715:	c6 00 00             	movb   $0x0,(%eax)
}
  801718:	90                   	nop
  801719:	c9                   	leave  
  80171a:	c3                   	ret    

0080171b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80171b:	55                   	push   %ebp
  80171c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80171e:	8b 45 14             	mov    0x14(%ebp),%eax
  801721:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801727:	8b 45 14             	mov    0x14(%ebp),%eax
  80172a:	8b 00                	mov    (%eax),%eax
  80172c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801733:	8b 45 10             	mov    0x10(%ebp),%eax
  801736:	01 d0                	add    %edx,%eax
  801738:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80173e:	eb 0c                	jmp    80174c <strsplit+0x31>
			*string++ = 0;
  801740:	8b 45 08             	mov    0x8(%ebp),%eax
  801743:	8d 50 01             	lea    0x1(%eax),%edx
  801746:	89 55 08             	mov    %edx,0x8(%ebp)
  801749:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80174c:	8b 45 08             	mov    0x8(%ebp),%eax
  80174f:	8a 00                	mov    (%eax),%al
  801751:	84 c0                	test   %al,%al
  801753:	74 18                	je     80176d <strsplit+0x52>
  801755:	8b 45 08             	mov    0x8(%ebp),%eax
  801758:	8a 00                	mov    (%eax),%al
  80175a:	0f be c0             	movsbl %al,%eax
  80175d:	50                   	push   %eax
  80175e:	ff 75 0c             	pushl  0xc(%ebp)
  801761:	e8 13 fb ff ff       	call   801279 <strchr>
  801766:	83 c4 08             	add    $0x8,%esp
  801769:	85 c0                	test   %eax,%eax
  80176b:	75 d3                	jne    801740 <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  80176d:	8b 45 08             	mov    0x8(%ebp),%eax
  801770:	8a 00                	mov    (%eax),%al
  801772:	84 c0                	test   %al,%al
  801774:	74 5a                	je     8017d0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  801776:	8b 45 14             	mov    0x14(%ebp),%eax
  801779:	8b 00                	mov    (%eax),%eax
  80177b:	83 f8 0f             	cmp    $0xf,%eax
  80177e:	75 07                	jne    801787 <strsplit+0x6c>
		{
			return 0;
  801780:	b8 00 00 00 00       	mov    $0x0,%eax
  801785:	eb 66                	jmp    8017ed <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801787:	8b 45 14             	mov    0x14(%ebp),%eax
  80178a:	8b 00                	mov    (%eax),%eax
  80178c:	8d 48 01             	lea    0x1(%eax),%ecx
  80178f:	8b 55 14             	mov    0x14(%ebp),%edx
  801792:	89 0a                	mov    %ecx,(%edx)
  801794:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80179b:	8b 45 10             	mov    0x10(%ebp),%eax
  80179e:	01 c2                	add    %eax,%edx
  8017a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017a5:	eb 03                	jmp    8017aa <strsplit+0x8f>
			string++;
  8017a7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ad:	8a 00                	mov    (%eax),%al
  8017af:	84 c0                	test   %al,%al
  8017b1:	74 8b                	je     80173e <strsplit+0x23>
  8017b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b6:	8a 00                	mov    (%eax),%al
  8017b8:	0f be c0             	movsbl %al,%eax
  8017bb:	50                   	push   %eax
  8017bc:	ff 75 0c             	pushl  0xc(%ebp)
  8017bf:	e8 b5 fa ff ff       	call   801279 <strchr>
  8017c4:	83 c4 08             	add    $0x8,%esp
  8017c7:	85 c0                	test   %eax,%eax
  8017c9:	74 dc                	je     8017a7 <strsplit+0x8c>
			string++;
	}
  8017cb:	e9 6e ff ff ff       	jmp    80173e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017d0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8017d4:	8b 00                	mov    (%eax),%eax
  8017d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e0:	01 d0                	add    %edx,%eax
  8017e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017e8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017ed:	c9                   	leave  
  8017ee:	c3                   	ret    

008017ef <malloc>:
int cnt_mem = 0;
int heap_mem[size_uhmem] = { 0 };
struct hmem heap_size[size_uhmem] = { 0 };
int check = 0;

void* malloc(uint32 size) {
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
  8017f2:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyNEXTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	//NEXT FIT
	if (sys_isUHeapPlacementStrategyNEXTFIT()) {
  8017f8:	e8 7d 0f 00 00       	call   80277a <sys_isUHeapPlacementStrategyNEXTFIT>
  8017fd:	85 c0                	test   %eax,%eax
  8017ff:	0f 84 6f 03 00 00    	je     801b74 <malloc+0x385>
		size = ROUNDUP(size, PAGE_SIZE);
  801805:	c7 45 84 00 10 00 00 	movl   $0x1000,-0x7c(%ebp)
  80180c:	8b 55 08             	mov    0x8(%ebp),%edx
  80180f:	8b 45 84             	mov    -0x7c(%ebp),%eax
  801812:	01 d0                	add    %edx,%eax
  801814:	48                   	dec    %eax
  801815:	89 45 80             	mov    %eax,-0x80(%ebp)
  801818:	8b 45 80             	mov    -0x80(%ebp),%eax
  80181b:	ba 00 00 00 00       	mov    $0x0,%edx
  801820:	f7 75 84             	divl   -0x7c(%ebp)
  801823:	8b 45 80             	mov    -0x80(%ebp),%eax
  801826:	29 d0                	sub    %edx,%eax
  801828:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  80182b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80182f:	74 09                	je     80183a <malloc+0x4b>
  801831:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801838:	76 0a                	jbe    801844 <malloc+0x55>
			return NULL;
  80183a:	b8 00 00 00 00       	mov    $0x0,%eax
  80183f:	e9 4b 09 00 00       	jmp    80218f <malloc+0x9a0>
		}
		// first we can allocate by " Strategy Continues "
		if (ptr_uheap + size <= (uint32) USER_HEAP_MAX && !check) {
  801844:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80184a:	8b 45 08             	mov    0x8(%ebp),%eax
  80184d:	01 d0                	add    %edx,%eax
  80184f:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801854:	0f 87 a2 00 00 00    	ja     8018fc <malloc+0x10d>
  80185a:	a1 60 40 98 00       	mov    0x984060,%eax
  80185f:	85 c0                	test   %eax,%eax
  801861:	0f 85 95 00 00 00    	jne    8018fc <malloc+0x10d>

			void* ret = (void *) ptr_uheap;
  801867:	a1 04 40 80 00       	mov    0x804004,%eax
  80186c:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			sys_allocateMem(ptr_uheap, size);
  801872:	a1 04 40 80 00       	mov    0x804004,%eax
  801877:	83 ec 08             	sub    $0x8,%esp
  80187a:	ff 75 08             	pushl  0x8(%ebp)
  80187d:	50                   	push   %eax
  80187e:	e8 a3 0b 00 00       	call   802426 <sys_allocateMem>
  801883:	83 c4 10             	add    $0x10,%esp

			heap_size[cnt_mem].size = size;
  801886:	a1 40 40 80 00       	mov    0x804040,%eax
  80188b:	8b 55 08             	mov    0x8(%ebp),%edx
  80188e:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801895:	a1 40 40 80 00       	mov    0x804040,%eax
  80189a:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8018a0:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
			cnt_mem++;
  8018a7:	a1 40 40 80 00       	mov    0x804040,%eax
  8018ac:	40                   	inc    %eax
  8018ad:	a3 40 40 80 00       	mov    %eax,0x804040
			int i = 0;
  8018b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  8018b9:	eb 2e                	jmp    8018e9 <malloc+0xfa>
			{

				heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8018bb:	a1 04 40 80 00       	mov    0x804004,%eax
  8018c0:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] = 1;
  8018c5:	c1 e8 0c             	shr    $0xc,%eax
  8018c8:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  8018cf:	01 00 00 00 

				ptr_uheap += (uint32) PAGE_SIZE;
  8018d3:	a1 04 40 80 00       	mov    0x804004,%eax
  8018d8:	05 00 10 00 00       	add    $0x1000,%eax
  8018dd:	a3 04 40 80 00       	mov    %eax,0x804004
			heap_size[cnt_mem].size = size;
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
			cnt_mem++;
			int i = 0;
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  8018e2:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  8018e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ec:	3b 45 08             	cmp    0x8(%ebp),%eax
  8018ef:	72 ca                	jb     8018bb <malloc+0xcc>
						/ (uint32) PAGE_SIZE)] = 1;

				ptr_uheap += (uint32) PAGE_SIZE;
			}

			return ret;
  8018f1:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8018f7:	e9 93 08 00 00       	jmp    80218f <malloc+0x9a0>

		} else {
			// second we can allocate by " Strategy NEXTFIT "
			void* temp_end = NULL;
  8018fc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

			int check_start = 0;
  801903:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			// check first that we used " Strategy Continues " before and not do it again and turn to NEXTFIT
			if (!check) {
  80190a:	a1 60 40 98 00       	mov    0x984060,%eax
  80190f:	85 c0                	test   %eax,%eax
  801911:	75 1d                	jne    801930 <malloc+0x141>
				ptr_uheap = (uint32) USER_HEAP_START;
  801913:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  80191a:	00 00 80 
				check = 1;
  80191d:	c7 05 60 40 98 00 01 	movl   $0x1,0x984060
  801924:	00 00 00 
				check_start = 1;// to dont use second loop CZ ptr_uheap start from USER_HEAP_START
  801927:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  80192e:	eb 08                	jmp    801938 <malloc+0x149>
			} else {
				temp_end = (void*) ptr_uheap;
  801930:	a1 04 40 80 00       	mov    0x804004,%eax
  801935:	89 45 f0             	mov    %eax,-0x10(%ebp)

			}

			uint32 sz = 0;
  801938:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
			int f = 0;
  80193f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			uint32 ptr = ptr_uheap;
  801946:	a1 04 40 80 00       	mov    0x804004,%eax
  80194b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  80194e:	eb 4d                	jmp    80199d <malloc+0x1ae>
				if (sz == size) {
  801950:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801953:	3b 45 08             	cmp    0x8(%ebp),%eax
  801956:	75 09                	jne    801961 <malloc+0x172>
					f = 1;
  801958:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  80195f:	eb 45                	jmp    8019a6 <malloc+0x1b7>
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801961:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801964:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] == 0) {
  801969:	c1 e8 0c             	shr    $0xc,%eax
			while (ptr < (uint32) USER_HEAP_MAX) {
				if (sz == size) {
					f = 1;
					break;
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  80196c:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  801973:	85 c0                	test   %eax,%eax
  801975:	75 10                	jne    801987 <malloc+0x198>
						/ (uint32) PAGE_SIZE)] == 0) {

					sz += PAGE_SIZE;
  801977:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
					ptr += PAGE_SIZE;
  80197e:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  801985:	eb 16                	jmp    80199d <malloc+0x1ae>
				} else {
					sz = 0;
  801987:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
					ptr += PAGE_SIZE;
  80198e:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
					ptr_uheap = ptr;
  801995:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801998:	a3 04 40 80 00       	mov    %eax,0x804004

			uint32 sz = 0;
			int f = 0;
			uint32 ptr = ptr_uheap;
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  80199d:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  8019a4:	76 aa                	jbe    801950 <malloc+0x161>
					ptr_uheap = ptr;
				}

			}

			if (f) {
  8019a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8019aa:	0f 84 95 00 00 00    	je     801a45 <malloc+0x256>

				void* ret = (void *) ptr_uheap;
  8019b0:	a1 04 40 80 00       	mov    0x804004,%eax
  8019b5:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

				sys_allocateMem(ptr_uheap, size);
  8019bb:	a1 04 40 80 00       	mov    0x804004,%eax
  8019c0:	83 ec 08             	sub    $0x8,%esp
  8019c3:	ff 75 08             	pushl  0x8(%ebp)
  8019c6:	50                   	push   %eax
  8019c7:	e8 5a 0a 00 00       	call   802426 <sys_allocateMem>
  8019cc:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  8019cf:	a1 40 40 80 00       	mov    0x804040,%eax
  8019d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8019d7:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8019de:	a1 40 40 80 00       	mov    0x804040,%eax
  8019e3:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8019e9:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
				cnt_mem++;
  8019f0:	a1 40 40 80 00       	mov    0x804040,%eax
  8019f5:	40                   	inc    %eax
  8019f6:	a3 40 40 80 00       	mov    %eax,0x804040
				int i = 0;
  8019fb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801a02:	eb 2e                	jmp    801a32 <malloc+0x243>
				{

					heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801a04:	a1 04 40 80 00       	mov    0x804004,%eax
  801a09:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  801a0e:	c1 e8 0c             	shr    $0xc,%eax
  801a11:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  801a18:	01 00 00 00 

					ptr_uheap += (uint32) PAGE_SIZE;
  801a1c:	a1 04 40 80 00       	mov    0x804004,%eax
  801a21:	05 00 10 00 00       	add    $0x1000,%eax
  801a26:	a3 04 40 80 00       	mov    %eax,0x804004
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
				cnt_mem++;
				int i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801a2b:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801a32:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a35:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a38:	72 ca                	jb     801a04 <malloc+0x215>
							/ (uint32) PAGE_SIZE)] = 1;

					ptr_uheap += (uint32) PAGE_SIZE;
				}

				return ret;
  801a3a:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  801a40:	e9 4a 07 00 00       	jmp    80218f <malloc+0x9a0>

			} else {

				if (check_start) {
  801a45:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a49:	74 0a                	je     801a55 <malloc+0x266>

					return NULL;
  801a4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801a50:	e9 3a 07 00 00       	jmp    80218f <malloc+0x9a0>
				}

//////////////back loop////////////////

				uint32 sz = 0;
  801a55:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
				int f = 0;
  801a5c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				uint32 ptr = USER_HEAP_START;
  801a63:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
				ptr_uheap = USER_HEAP_START;
  801a6a:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  801a71:	00 00 80 
				while (ptr < (uint32) temp_end) {
  801a74:	eb 4d                	jmp    801ac3 <malloc+0x2d4>
					if (sz == size) {
  801a76:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a79:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a7c:	75 09                	jne    801a87 <malloc+0x298>
						f = 1;
  801a7e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
						break;
  801a85:	eb 44                	jmp    801acb <malloc+0x2dc>
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801a87:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801a8a:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] == 0) {
  801a8f:	c1 e8 0c             	shr    $0xc,%eax
				while (ptr < (uint32) temp_end) {
					if (sz == size) {
						f = 1;
						break;
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801a92:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  801a99:	85 c0                	test   %eax,%eax
  801a9b:	75 10                	jne    801aad <malloc+0x2be>
							/ (uint32) PAGE_SIZE)] == 0) {

						sz += PAGE_SIZE;
  801a9d:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801aa4:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
  801aab:	eb 16                	jmp    801ac3 <malloc+0x2d4>
					} else {
						sz = 0;
  801aad:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801ab4:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
						ptr_uheap = ptr;
  801abb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801abe:	a3 04 40 80 00       	mov    %eax,0x804004

				uint32 sz = 0;
				int f = 0;
				uint32 ptr = USER_HEAP_START;
				ptr_uheap = USER_HEAP_START;
				while (ptr < (uint32) temp_end) {
  801ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac6:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801ac9:	72 ab                	jb     801a76 <malloc+0x287>
						ptr_uheap = ptr;
					}

				}

				if (f) {
  801acb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801acf:	0f 84 95 00 00 00    	je     801b6a <malloc+0x37b>

					void* ret = (void *) ptr_uheap;
  801ad5:	a1 04 40 80 00       	mov    0x804004,%eax
  801ada:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

					sys_allocateMem(ptr_uheap, size);
  801ae0:	a1 04 40 80 00       	mov    0x804004,%eax
  801ae5:	83 ec 08             	sub    $0x8,%esp
  801ae8:	ff 75 08             	pushl  0x8(%ebp)
  801aeb:	50                   	push   %eax
  801aec:	e8 35 09 00 00       	call   802426 <sys_allocateMem>
  801af1:	83 c4 10             	add    $0x10,%esp

					heap_size[cnt_mem].size = size;
  801af4:	a1 40 40 80 00       	mov    0x804040,%eax
  801af9:	8b 55 08             	mov    0x8(%ebp),%edx
  801afc:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801b03:	a1 40 40 80 00       	mov    0x804040,%eax
  801b08:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b0e:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
					cnt_mem++;
  801b15:	a1 40 40 80 00       	mov    0x804040,%eax
  801b1a:	40                   	inc    %eax
  801b1b:	a3 40 40 80 00       	mov    %eax,0x804040
					int i = 0;
  801b20:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

					for (; i < size; i += PAGE_SIZE)
  801b27:	eb 2e                	jmp    801b57 <malloc+0x368>
					{

						heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801b29:	a1 04 40 80 00       	mov    0x804004,%eax
  801b2e:	05 00 00 00 80       	add    $0x80000000,%eax
								/ (uint32) PAGE_SIZE)] = 1;
  801b33:	c1 e8 0c             	shr    $0xc,%eax
  801b36:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  801b3d:	01 00 00 00 

						ptr_uheap += (uint32) PAGE_SIZE;
  801b41:	a1 04 40 80 00       	mov    0x804004,%eax
  801b46:	05 00 10 00 00       	add    $0x1000,%eax
  801b4b:	a3 04 40 80 00       	mov    %eax,0x804004
					heap_size[cnt_mem].size = size;
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
					cnt_mem++;
					int i = 0;

					for (; i < size; i += PAGE_SIZE)
  801b50:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  801b57:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801b5a:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b5d:	72 ca                	jb     801b29 <malloc+0x33a>
								/ (uint32) PAGE_SIZE)] = 1;

						ptr_uheap += (uint32) PAGE_SIZE;
					}

					return ret;
  801b5f:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801b65:	e9 25 06 00 00       	jmp    80218f <malloc+0x9a0>

				} else {

					return NULL;
  801b6a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b6f:	e9 1b 06 00 00       	jmp    80218f <malloc+0x9a0>

		}

	}

	else if (sys_isUHeapPlacementStrategyBESTFIT()) {
  801b74:	e8 d0 0b 00 00       	call   802749 <sys_isUHeapPlacementStrategyBESTFIT>
  801b79:	85 c0                	test   %eax,%eax
  801b7b:	0f 84 ba 01 00 00    	je     801d3b <malloc+0x54c>

		size = ROUNDUP(size, PAGE_SIZE);
  801b81:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  801b88:	10 00 00 
  801b8b:	8b 55 08             	mov    0x8(%ebp),%edx
  801b8e:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  801b94:	01 d0                	add    %edx,%eax
  801b96:	48                   	dec    %eax
  801b97:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  801b9d:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801ba3:	ba 00 00 00 00       	mov    $0x0,%edx
  801ba8:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  801bae:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801bb4:	29 d0                	sub    %edx,%eax
  801bb6:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801bb9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bbd:	74 09                	je     801bc8 <malloc+0x3d9>
  801bbf:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801bc6:	76 0a                	jbe    801bd2 <malloc+0x3e3>
			return NULL;
  801bc8:	b8 00 00 00 00       	mov    $0x0,%eax
  801bcd:	e9 bd 05 00 00       	jmp    80218f <malloc+0x9a0>
		}
		uint32 ptr = (uint32) USER_HEAP_START;
  801bd2:	c7 45 c8 00 00 00 80 	movl   $0x80000000,-0x38(%ebp)
		uint32 temp = 0;
  801bd9:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		uint32 min_sz = size_uhmem + 1;
  801be0:	c7 45 c0 01 00 02 00 	movl   $0x20001,-0x40(%ebp)
		uint32 count = 0;
  801be7:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
		int i = 0;
  801bee:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf8:	c1 e8 0c             	shr    $0xc,%eax
  801bfb:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801c01:	e9 80 00 00 00       	jmp    801c86 <malloc+0x497>

			if (heap_mem[i] == 0) {
  801c06:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801c09:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  801c10:	85 c0                	test   %eax,%eax
  801c12:	75 0c                	jne    801c20 <malloc+0x431>

				count++;
  801c14:	ff 45 bc             	incl   -0x44(%ebp)
				ptr += PAGE_SIZE;
  801c17:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801c1e:	eb 2d                	jmp    801c4d <malloc+0x45e>
			} else {
				if (num_p <= count && min_sz > count) {
  801c20:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801c26:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801c29:	77 14                	ja     801c3f <malloc+0x450>
  801c2b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c2e:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801c31:	76 0c                	jbe    801c3f <malloc+0x450>

					min_sz = count;
  801c33:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801c36:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801c39:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c3c:	89 45 c4             	mov    %eax,-0x3c(%ebp)

				}
				count = 0;
  801c3f:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
				ptr += PAGE_SIZE;
  801c46:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
			}

			if (i == size_uhmem - 1) {
  801c4d:	81 7d b8 ff ff 01 00 	cmpl   $0x1ffff,-0x48(%ebp)
  801c54:	75 2d                	jne    801c83 <malloc+0x494>

				if (num_p <= count && min_sz > count) {
  801c56:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801c5c:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801c5f:	77 22                	ja     801c83 <malloc+0x494>
  801c61:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c64:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801c67:	76 1a                	jbe    801c83 <malloc+0x494>

					min_sz = count;
  801c69:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801c6c:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801c6f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c72:	89 45 c4             	mov    %eax,-0x3c(%ebp)
					count = 0;
  801c75:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
					ptr += PAGE_SIZE;
  801c7c:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801c83:	ff 45 b8             	incl   -0x48(%ebp)
  801c86:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801c89:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801c8e:	0f 86 72 ff ff ff    	jbe    801c06 <malloc+0x417>

			}

		}

		if (num_p > min_sz || temp == 0) {
  801c94:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801c9a:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  801c9d:	77 06                	ja     801ca5 <malloc+0x4b6>
  801c9f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801ca3:	75 0a                	jne    801caf <malloc+0x4c0>
			return NULL;
  801ca5:	b8 00 00 00 00       	mov    $0x0,%eax
  801caa:	e9 e0 04 00 00       	jmp    80218f <malloc+0x9a0>

		}

		temp = temp - (PAGE_SIZE * min_sz);
  801caf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801cb2:	c1 e0 0c             	shl    $0xc,%eax
  801cb5:	29 45 c4             	sub    %eax,-0x3c(%ebp)
		void* ret = (void*) temp;
  801cb8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801cbb:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)

		sys_allocateMem(temp, size);
  801cc1:	83 ec 08             	sub    $0x8,%esp
  801cc4:	ff 75 08             	pushl  0x8(%ebp)
  801cc7:	ff 75 c4             	pushl  -0x3c(%ebp)
  801cca:	e8 57 07 00 00       	call   802426 <sys_allocateMem>
  801ccf:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801cd2:	a1 40 40 80 00       	mov    0x804040,%eax
  801cd7:	8b 55 08             	mov    0x8(%ebp),%edx
  801cda:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801ce1:	a1 40 40 80 00       	mov    0x804040,%eax
  801ce6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801ce9:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
		cnt_mem++;
  801cf0:	a1 40 40 80 00       	mov    0x804040,%eax
  801cf5:	40                   	inc    %eax
  801cf6:	a3 40 40 80 00       	mov    %eax,0x804040
		i = 0;
  801cfb:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801d02:	eb 24                	jmp    801d28 <malloc+0x539>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801d04:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801d07:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801d0c:	c1 e8 0c             	shr    $0xc,%eax
  801d0f:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  801d16:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801d1a:	81 45 c4 00 10 00 00 	addl   $0x1000,-0x3c(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801d21:	81 45 b8 00 10 00 00 	addl   $0x1000,-0x48(%ebp)
  801d28:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801d2b:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d2e:	72 d4                	jb     801d04 <malloc+0x515>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801d30:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801d36:	e9 54 04 00 00       	jmp    80218f <malloc+0x9a0>

	} else if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801d3b:	e8 d8 09 00 00       	call   802718 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d40:	85 c0                	test   %eax,%eax
  801d42:	0f 84 88 01 00 00    	je     801ed0 <malloc+0x6e1>

		size = ROUNDUP(size, PAGE_SIZE);
  801d48:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  801d4f:	10 00 00 
  801d52:	8b 55 08             	mov    0x8(%ebp),%edx
  801d55:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  801d5b:	01 d0                	add    %edx,%eax
  801d5d:	48                   	dec    %eax
  801d5e:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  801d64:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801d6a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d6f:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  801d75:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801d7b:	29 d0                	sub    %edx,%eax
  801d7d:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801d80:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d84:	74 09                	je     801d8f <malloc+0x5a0>
  801d86:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801d8d:	76 0a                	jbe    801d99 <malloc+0x5aa>
			return NULL;
  801d8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d94:	e9 f6 03 00 00       	jmp    80218f <malloc+0x9a0>
		}

		uint32 ptr = (uint32) USER_HEAP_START;
  801d99:	c7 45 b4 00 00 00 80 	movl   $0x80000000,-0x4c(%ebp)
		uint32 temp = 0;
  801da0:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
		uint32 found = 0;
  801da7:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		uint32 count = 0;
  801dae:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
		int i = 0;
  801db5:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbf:	c1 e8 0c             	shr    $0xc,%eax
  801dc2:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

		for (; i < size_uhmem; i++) {
  801dc8:	eb 5a                	jmp    801e24 <malloc+0x635>

			if (heap_mem[i] == 0) {
  801dca:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801dcd:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  801dd4:	85 c0                	test   %eax,%eax
  801dd6:	75 0c                	jne    801de4 <malloc+0x5f5>

				count++;
  801dd8:	ff 45 a8             	incl   -0x58(%ebp)
				ptr += PAGE_SIZE;
  801ddb:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
  801de2:	eb 22                	jmp    801e06 <malloc+0x617>
			} else {
				if (num_p <= count) {
  801de4:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801dea:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801ded:	77 09                	ja     801df8 <malloc+0x609>

					found = 1;
  801def:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)

					break;
  801df6:	eb 36                	jmp    801e2e <malloc+0x63f>
				}
				count = 0;
  801df8:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
				ptr += PAGE_SIZE;
  801dff:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
			}

			if (i == size_uhmem - 1) {
  801e06:	81 7d a4 ff ff 01 00 	cmpl   $0x1ffff,-0x5c(%ebp)
  801e0d:	75 12                	jne    801e21 <malloc+0x632>

				if (num_p <= count) {
  801e0f:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801e15:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801e18:	77 07                	ja     801e21 <malloc+0x632>

					found = 1;
  801e1a:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
		uint32 found = 0;
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		for (; i < size_uhmem; i++) {
  801e21:	ff 45 a4             	incl   -0x5c(%ebp)
  801e24:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801e27:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801e2c:	76 9c                	jbe    801dca <malloc+0x5db>

			}

		}

		if (!found) {
  801e2e:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  801e32:	75 0a                	jne    801e3e <malloc+0x64f>
			return NULL;
  801e34:	b8 00 00 00 00       	mov    $0x0,%eax
  801e39:	e9 51 03 00 00       	jmp    80218f <malloc+0x9a0>

		}

		temp = ptr;
  801e3e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801e41:	89 45 b0             	mov    %eax,-0x50(%ebp)
		temp = temp - (PAGE_SIZE * count);
  801e44:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801e47:	c1 e0 0c             	shl    $0xc,%eax
  801e4a:	29 45 b0             	sub    %eax,-0x50(%ebp)
		void* ret = (void*) temp;
  801e4d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801e50:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)

		sys_allocateMem(temp, size);
  801e56:	83 ec 08             	sub    $0x8,%esp
  801e59:	ff 75 08             	pushl  0x8(%ebp)
  801e5c:	ff 75 b0             	pushl  -0x50(%ebp)
  801e5f:	e8 c2 05 00 00       	call   802426 <sys_allocateMem>
  801e64:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801e67:	a1 40 40 80 00       	mov    0x804040,%eax
  801e6c:	8b 55 08             	mov    0x8(%ebp),%edx
  801e6f:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801e76:	a1 40 40 80 00       	mov    0x804040,%eax
  801e7b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801e7e:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
		cnt_mem++;
  801e85:	a1 40 40 80 00       	mov    0x804040,%eax
  801e8a:	40                   	inc    %eax
  801e8b:	a3 40 40 80 00       	mov    %eax,0x804040
		i = 0;
  801e90:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801e97:	eb 24                	jmp    801ebd <malloc+0x6ce>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801e99:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801e9c:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801ea1:	c1 e8 0c             	shr    $0xc,%eax
  801ea4:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  801eab:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801eaf:	81 45 b0 00 10 00 00 	addl   $0x1000,-0x50(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801eb6:	81 45 a4 00 10 00 00 	addl   $0x1000,-0x5c(%ebp)
  801ebd:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801ec0:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ec3:	72 d4                	jb     801e99 <malloc+0x6aa>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801ec5:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  801ecb:	e9 bf 02 00 00       	jmp    80218f <malloc+0x9a0>

	}
	else if(sys_isUHeapPlacementStrategyWORSTFIT())
  801ed0:	e8 d6 08 00 00       	call   8027ab <sys_isUHeapPlacementStrategyWORSTFIT>
  801ed5:	85 c0                	test   %eax,%eax
  801ed7:	0f 84 ba 01 00 00    	je     802097 <malloc+0x8a8>
	{
		size = ROUNDUP(size, PAGE_SIZE);
  801edd:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  801ee4:	10 00 00 
  801ee7:	8b 55 08             	mov    0x8(%ebp),%edx
  801eea:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  801ef0:	01 d0                	add    %edx,%eax
  801ef2:	48                   	dec    %eax
  801ef3:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  801ef9:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  801eff:	ba 00 00 00 00       	mov    $0x0,%edx
  801f04:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  801f0a:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  801f10:	29 d0                	sub    %edx,%eax
  801f12:	89 45 08             	mov    %eax,0x8(%ebp)

				if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801f15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f19:	74 09                	je     801f24 <malloc+0x735>
  801f1b:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801f22:	76 0a                	jbe    801f2e <malloc+0x73f>
					return NULL;
  801f24:	b8 00 00 00 00       	mov    $0x0,%eax
  801f29:	e9 61 02 00 00       	jmp    80218f <malloc+0x9a0>
				}
				uint32 ptr = (uint32) USER_HEAP_START;
  801f2e:	c7 45 a0 00 00 00 80 	movl   $0x80000000,-0x60(%ebp)
				uint32 temp = 0;
  801f35:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
				uint32 max_sz = -1;
  801f3c:	c7 45 98 ff ff ff ff 	movl   $0xffffffff,-0x68(%ebp)
				uint32 count = 0;
  801f43:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
				int i = 0;
  801f4a:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				uint32 num_p = size / PAGE_SIZE;
  801f51:	8b 45 08             	mov    0x8(%ebp),%eax
  801f54:	c1 e8 0c             	shr    $0xc,%eax
  801f57:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  801f5d:	e9 80 00 00 00       	jmp    801fe2 <malloc+0x7f3>

					if (heap_mem[i] == 0) {
  801f62:	8b 45 90             	mov    -0x70(%ebp),%eax
  801f65:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  801f6c:	85 c0                	test   %eax,%eax
  801f6e:	75 0c                	jne    801f7c <malloc+0x78d>

						count++;
  801f70:	ff 45 94             	incl   -0x6c(%ebp)
						ptr += PAGE_SIZE;
  801f73:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
  801f7a:	eb 2d                	jmp    801fa9 <malloc+0x7ba>
					} else {
						if (num_p <= count && max_sz < count) {
  801f7c:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801f82:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801f85:	77 14                	ja     801f9b <malloc+0x7ac>
  801f87:	8b 45 98             	mov    -0x68(%ebp),%eax
  801f8a:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801f8d:	73 0c                	jae    801f9b <malloc+0x7ac>

							max_sz = count;
  801f8f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801f92:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  801f95:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801f98:	89 45 9c             	mov    %eax,-0x64(%ebp)

						}
						count = 0;
  801f9b:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
						ptr += PAGE_SIZE;
  801fa2:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
					}

					if (i == size_uhmem - 1) {
  801fa9:	81 7d 90 ff ff 01 00 	cmpl   $0x1ffff,-0x70(%ebp)
  801fb0:	75 2d                	jne    801fdf <malloc+0x7f0>

						if (num_p <= count && max_sz > count) {
  801fb2:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801fb8:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801fbb:	77 22                	ja     801fdf <malloc+0x7f0>
  801fbd:	8b 45 98             	mov    -0x68(%ebp),%eax
  801fc0:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801fc3:	76 1a                	jbe    801fdf <malloc+0x7f0>

							max_sz = count;
  801fc5:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801fc8:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  801fcb:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801fce:	89 45 9c             	mov    %eax,-0x64(%ebp)
							count = 0;
  801fd1:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
							ptr += PAGE_SIZE;
  801fd8:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
				uint32 count = 0;
				int i = 0;
				uint32 num_p = size / PAGE_SIZE;

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  801fdf:	ff 45 90             	incl   -0x70(%ebp)
  801fe2:	8b 45 90             	mov    -0x70(%ebp),%eax
  801fe5:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801fea:	0f 86 72 ff ff ff    	jbe    801f62 <malloc+0x773>

					}

				}

				if (num_p > max_sz || temp == 0) {
  801ff0:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801ff6:	3b 45 98             	cmp    -0x68(%ebp),%eax
  801ff9:	77 06                	ja     802001 <malloc+0x812>
  801ffb:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  801fff:	75 0a                	jne    80200b <malloc+0x81c>
					return NULL;
  802001:	b8 00 00 00 00       	mov    $0x0,%eax
  802006:	e9 84 01 00 00       	jmp    80218f <malloc+0x9a0>

				}

				temp = temp - (PAGE_SIZE * max_sz);
  80200b:	8b 45 98             	mov    -0x68(%ebp),%eax
  80200e:	c1 e0 0c             	shl    $0xc,%eax
  802011:	29 45 9c             	sub    %eax,-0x64(%ebp)
				void* ret = (void*) temp;
  802014:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802017:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

				sys_allocateMem(temp, size);
  80201d:	83 ec 08             	sub    $0x8,%esp
  802020:	ff 75 08             	pushl  0x8(%ebp)
  802023:	ff 75 9c             	pushl  -0x64(%ebp)
  802026:	e8 fb 03 00 00       	call   802426 <sys_allocateMem>
  80202b:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  80202e:	a1 40 40 80 00       	mov    0x804040,%eax
  802033:	8b 55 08             	mov    0x8(%ebp),%edx
  802036:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
				heap_size[cnt_mem].vir = (void*) temp;
  80203d:	a1 40 40 80 00       	mov    0x804040,%eax
  802042:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802045:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
				cnt_mem++;
  80204c:	a1 40 40 80 00       	mov    0x804040,%eax
  802051:	40                   	inc    %eax
  802052:	a3 40 40 80 00       	mov    %eax,0x804040
				i = 0;
  802057:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  80205e:	eb 24                	jmp    802084 <malloc+0x895>
				{

					heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  802060:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802063:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  802068:	c1 e8 0c             	shr    $0xc,%eax
  80206b:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  802072:	01 00 00 00 

					temp += (uint32) PAGE_SIZE;
  802076:	81 45 9c 00 10 00 00 	addl   $0x1000,-0x64(%ebp)
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) temp;
				cnt_mem++;
				i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  80207d:	81 45 90 00 10 00 00 	addl   $0x1000,-0x70(%ebp)
  802084:	8b 45 90             	mov    -0x70(%ebp),%eax
  802087:	3b 45 08             	cmp    0x8(%ebp),%eax
  80208a:	72 d4                	jb     802060 <malloc+0x871>

					temp += (uint32) PAGE_SIZE;
				}

				//cprintf("\n size = %d.........vir= %d  \n",num_p,((uint32) ret-USER_HEAP_START)/PAGE_SIZE);
				return ret;
  80208c:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  802092:	e9 f8 00 00 00       	jmp    80218f <malloc+0x9a0>

	}
// this is to make malloc is work
	void* ret = NULL;
  802097:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
	size = ROUNDUP(size, PAGE_SIZE);
  80209e:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  8020a5:	10 00 00 
  8020a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8020ab:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  8020b1:	01 d0                	add    %edx,%eax
  8020b3:	48                   	dec    %eax
  8020b4:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  8020ba:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  8020c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8020c5:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  8020cb:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  8020d1:	29 d0                	sub    %edx,%eax
  8020d3:	89 45 08             	mov    %eax,0x8(%ebp)

	if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  8020d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020da:	74 09                	je     8020e5 <malloc+0x8f6>
  8020dc:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8020e3:	76 0a                	jbe    8020ef <malloc+0x900>
		return NULL;
  8020e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ea:	e9 a0 00 00 00       	jmp    80218f <malloc+0x9a0>
	}

	if (ptr_uheap + size <= (uint32) USER_HEAP_MAX) {
  8020ef:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8020f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f8:	01 d0                	add    %edx,%eax
  8020fa:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8020ff:	0f 87 87 00 00 00    	ja     80218c <malloc+0x99d>

		ret = (void *) ptr_uheap;
  802105:	a1 04 40 80 00       	mov    0x804004,%eax
  80210a:	89 45 8c             	mov    %eax,-0x74(%ebp)
		sys_allocateMem(ptr_uheap, size);
  80210d:	a1 04 40 80 00       	mov    0x804004,%eax
  802112:	83 ec 08             	sub    $0x8,%esp
  802115:	ff 75 08             	pushl  0x8(%ebp)
  802118:	50                   	push   %eax
  802119:	e8 08 03 00 00       	call   802426 <sys_allocateMem>
  80211e:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  802121:	a1 40 40 80 00       	mov    0x804040,%eax
  802126:	8b 55 08             	mov    0x8(%ebp),%edx
  802129:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
  802130:	a1 40 40 80 00       	mov    0x804040,%eax
  802135:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80213b:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
		cnt_mem++;
  802142:	a1 40 40 80 00       	mov    0x804040,%eax
  802147:	40                   	inc    %eax
  802148:	a3 40 40 80 00       	mov    %eax,0x804040
		int i = 0;
  80214d:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)

		for (; i < size; i += PAGE_SIZE)
  802154:	eb 2e                	jmp    802184 <malloc+0x995>
		{

			heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  802156:	a1 04 40 80 00       	mov    0x804004,%eax
  80215b:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  802160:	c1 e8 0c             	shr    $0xc,%eax
  802163:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  80216a:	01 00 00 00 

			ptr_uheap += (uint32) PAGE_SIZE;
  80216e:	a1 04 40 80 00       	mov    0x804004,%eax
  802173:	05 00 10 00 00       	add    $0x1000,%eax
  802178:	a3 04 40 80 00       	mov    %eax,0x804004
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
		cnt_mem++;
		int i = 0;

		for (; i < size; i += PAGE_SIZE)
  80217d:	81 45 88 00 10 00 00 	addl   $0x1000,-0x78(%ebp)
  802184:	8b 45 88             	mov    -0x78(%ebp),%eax
  802187:	3b 45 08             	cmp    0x8(%ebp),%eax
  80218a:	72 ca                	jb     802156 <malloc+0x967>
					/ (uint32) PAGE_SIZE)] = 1;

			ptr_uheap += (uint32) PAGE_SIZE;
		}
	}
	return ret;
  80218c:	8b 45 8c             	mov    -0x74(%ebp),%eax

	//TODO: [PROJECT 2016 - BONUS2] Apply FIRST FIT and WORST FIT policies

//return 0;

}
  80218f:	c9                   	leave  
  802190:	c3                   	ret    

00802191 <free>:
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address) {
  802191:	55                   	push   %ebp
  802192:	89 e5                	mov    %esp,%ebp
  802194:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
  802197:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; inx < cnt_mem; inx++) {
  80219e:	e9 c1 00 00 00       	jmp    802264 <free+0xd3>
		if (heap_size[inx].vir == virtual_address) {
  8021a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a6:	8b 04 c5 60 40 88 00 	mov    0x884060(,%eax,8),%eax
  8021ad:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021b0:	0f 85 ab 00 00 00    	jne    802261 <free+0xd0>

			if (heap_size[inx].size == 0) {
  8021b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b9:	8b 04 c5 64 40 88 00 	mov    0x884064(,%eax,8),%eax
  8021c0:	85 c0                	test   %eax,%eax
  8021c2:	75 21                	jne    8021e5 <free+0x54>
				heap_size[inx].size = 0;
  8021c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c7:	c7 04 c5 64 40 88 00 	movl   $0x0,0x884064(,%eax,8)
  8021ce:	00 00 00 00 
				heap_size[inx].vir = NULL;
  8021d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d5:	c7 04 c5 60 40 88 00 	movl   $0x0,0x884060(,%eax,8)
  8021dc:	00 00 00 00 
				return;
  8021e0:	e9 8d 00 00 00       	jmp    802272 <free+0xe1>

			}

			sys_freeMem((uint32) virtual_address, heap_size[inx].size);
  8021e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e8:	8b 14 c5 64 40 88 00 	mov    0x884064(,%eax,8),%edx
  8021ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f2:	83 ec 08             	sub    $0x8,%esp
  8021f5:	52                   	push   %edx
  8021f6:	50                   	push   %eax
  8021f7:	e8 0e 02 00 00       	call   80240a <sys_freeMem>
  8021fc:	83 c4 10             	add    $0x10,%esp

			int i = 0;
  8021ff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
  802206:	8b 45 08             	mov    0x8(%ebp),%eax
  802209:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  80220c:	eb 24                	jmp    802232 <free+0xa1>
			{
				heap_mem[(int) (((uint32) va - USER_HEAP_START) / PAGE_SIZE)] =
  80220e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802211:	05 00 00 00 80       	add    $0x80000000,%eax
  802216:	c1 e8 0c             	shr    $0xc,%eax
  802219:	c7 04 85 60 40 80 00 	movl   $0x0,0x804060(,%eax,4)
  802220:	00 00 00 00 
						0;

				va += PAGE_SIZE;
  802224:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
			sys_freeMem((uint32) virtual_address, heap_size[inx].size);

			int i = 0;
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  80222b:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  802232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802235:	8b 14 c5 64 40 88 00 	mov    0x884064(,%eax,8),%edx
  80223c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223f:	39 c2                	cmp    %eax,%edx
  802241:	77 cb                	ja     80220e <free+0x7d>

				va += PAGE_SIZE;

			}

			heap_size[inx].size = 0;
  802243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802246:	c7 04 c5 64 40 88 00 	movl   $0x0,0x884064(,%eax,8)
  80224d:	00 00 00 00 
			heap_size[inx].vir = NULL;
  802251:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802254:	c7 04 c5 60 40 88 00 	movl   $0x0,0x884060(,%eax,8)
  80225b:	00 00 00 00 
			break;
  80225f:	eb 11                	jmp    802272 <free+0xe1>
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
	for (; inx < cnt_mem; inx++) {
  802261:	ff 45 f4             	incl   -0xc(%ebp)
  802264:	a1 40 40 80 00       	mov    0x804040,%eax
  802269:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  80226c:	0f 8c 31 ff ff ff    	jl     8021a3 <free+0x12>
	}

	//get the size of the given allocation using its address
	//you need to call sys_freeMem()

}
  802272:	c9                   	leave  
  802273:	c3                   	ret    

00802274 <realloc>:
//  Hint: you may need to use the sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size) {
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
  802277:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2016 - BONUS4] realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80227a:	83 ec 04             	sub    $0x4,%esp
  80227d:	68 24 30 80 00       	push   $0x803024
  802282:	68 1c 02 00 00       	push   $0x21c
  802287:	68 4a 30 80 00       	push   $0x80304a
  80228c:	e8 aa e4 ff ff       	call   80073b <_panic>

00802291 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802291:	55                   	push   %ebp
  802292:	89 e5                	mov    %esp,%ebp
  802294:	57                   	push   %edi
  802295:	56                   	push   %esi
  802296:	53                   	push   %ebx
  802297:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80229a:	8b 45 08             	mov    0x8(%ebp),%eax
  80229d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022a3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022a6:	8b 7d 18             	mov    0x18(%ebp),%edi
  8022a9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8022ac:	cd 30                	int    $0x30
  8022ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8022b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8022b4:	83 c4 10             	add    $0x10,%esp
  8022b7:	5b                   	pop    %ebx
  8022b8:	5e                   	pop    %esi
  8022b9:	5f                   	pop    %edi
  8022ba:	5d                   	pop    %ebp
  8022bb:	c3                   	ret    

008022bc <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  8022bc:	55                   	push   %ebp
  8022bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  8022bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 00                	push   $0x0
  8022c8:	ff 75 0c             	pushl  0xc(%ebp)
  8022cb:	50                   	push   %eax
  8022cc:	6a 00                	push   $0x0
  8022ce:	e8 be ff ff ff       	call   802291 <syscall>
  8022d3:	83 c4 18             	add    $0x18,%esp
}
  8022d6:	90                   	nop
  8022d7:	c9                   	leave  
  8022d8:	c3                   	ret    

008022d9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8022d9:	55                   	push   %ebp
  8022da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8022dc:	6a 00                	push   $0x0
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 01                	push   $0x1
  8022e8:	e8 a4 ff ff ff       	call   802291 <syscall>
  8022ed:	83 c4 18             	add    $0x18,%esp
}
  8022f0:	c9                   	leave  
  8022f1:	c3                   	ret    

008022f2 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8022f2:	55                   	push   %ebp
  8022f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8022f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	50                   	push   %eax
  802301:	6a 03                	push   $0x3
  802303:	e8 89 ff ff ff       	call   802291 <syscall>
  802308:	83 c4 18             	add    $0x18,%esp
}
  80230b:	c9                   	leave  
  80230c:	c3                   	ret    

0080230d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80230d:	55                   	push   %ebp
  80230e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802310:	6a 00                	push   $0x0
  802312:	6a 00                	push   $0x0
  802314:	6a 00                	push   $0x0
  802316:	6a 00                	push   $0x0
  802318:	6a 00                	push   $0x0
  80231a:	6a 02                	push   $0x2
  80231c:	e8 70 ff ff ff       	call   802291 <syscall>
  802321:	83 c4 18             	add    $0x18,%esp
}
  802324:	c9                   	leave  
  802325:	c3                   	ret    

00802326 <sys_env_exit>:

void sys_env_exit(void)
{
  802326:	55                   	push   %ebp
  802327:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  802329:	6a 00                	push   $0x0
  80232b:	6a 00                	push   $0x0
  80232d:	6a 00                	push   $0x0
  80232f:	6a 00                	push   $0x0
  802331:	6a 00                	push   $0x0
  802333:	6a 04                	push   $0x4
  802335:	e8 57 ff ff ff       	call   802291 <syscall>
  80233a:	83 c4 18             	add    $0x18,%esp
}
  80233d:	90                   	nop
  80233e:	c9                   	leave  
  80233f:	c3                   	ret    

00802340 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  802340:	55                   	push   %ebp
  802341:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802343:	8b 55 0c             	mov    0xc(%ebp),%edx
  802346:	8b 45 08             	mov    0x8(%ebp),%eax
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	52                   	push   %edx
  802350:	50                   	push   %eax
  802351:	6a 05                	push   $0x5
  802353:	e8 39 ff ff ff       	call   802291 <syscall>
  802358:	83 c4 18             	add    $0x18,%esp
}
  80235b:	c9                   	leave  
  80235c:	c3                   	ret    

0080235d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80235d:	55                   	push   %ebp
  80235e:	89 e5                	mov    %esp,%ebp
  802360:	56                   	push   %esi
  802361:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802362:	8b 75 18             	mov    0x18(%ebp),%esi
  802365:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802368:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80236b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80236e:	8b 45 08             	mov    0x8(%ebp),%eax
  802371:	56                   	push   %esi
  802372:	53                   	push   %ebx
  802373:	51                   	push   %ecx
  802374:	52                   	push   %edx
  802375:	50                   	push   %eax
  802376:	6a 06                	push   $0x6
  802378:	e8 14 ff ff ff       	call   802291 <syscall>
  80237d:	83 c4 18             	add    $0x18,%esp
}
  802380:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802383:	5b                   	pop    %ebx
  802384:	5e                   	pop    %esi
  802385:	5d                   	pop    %ebp
  802386:	c3                   	ret    

00802387 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802387:	55                   	push   %ebp
  802388:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80238a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80238d:	8b 45 08             	mov    0x8(%ebp),%eax
  802390:	6a 00                	push   $0x0
  802392:	6a 00                	push   $0x0
  802394:	6a 00                	push   $0x0
  802396:	52                   	push   %edx
  802397:	50                   	push   %eax
  802398:	6a 07                	push   $0x7
  80239a:	e8 f2 fe ff ff       	call   802291 <syscall>
  80239f:	83 c4 18             	add    $0x18,%esp
}
  8023a2:	c9                   	leave  
  8023a3:	c3                   	ret    

008023a4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8023a4:	55                   	push   %ebp
  8023a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	ff 75 0c             	pushl  0xc(%ebp)
  8023b0:	ff 75 08             	pushl  0x8(%ebp)
  8023b3:	6a 08                	push   $0x8
  8023b5:	e8 d7 fe ff ff       	call   802291 <syscall>
  8023ba:	83 c4 18             	add    $0x18,%esp
}
  8023bd:	c9                   	leave  
  8023be:	c3                   	ret    

008023bf <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8023bf:	55                   	push   %ebp
  8023c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 09                	push   $0x9
  8023ce:	e8 be fe ff ff       	call   802291 <syscall>
  8023d3:	83 c4 18             	add    $0x18,%esp
}
  8023d6:	c9                   	leave  
  8023d7:	c3                   	ret    

008023d8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8023d8:	55                   	push   %ebp
  8023d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8023db:	6a 00                	push   $0x0
  8023dd:	6a 00                	push   $0x0
  8023df:	6a 00                	push   $0x0
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 0a                	push   $0xa
  8023e7:	e8 a5 fe ff ff       	call   802291 <syscall>
  8023ec:	83 c4 18             	add    $0x18,%esp
}
  8023ef:	c9                   	leave  
  8023f0:	c3                   	ret    

008023f1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8023f1:	55                   	push   %ebp
  8023f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8023f4:	6a 00                	push   $0x0
  8023f6:	6a 00                	push   $0x0
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 0b                	push   $0xb
  802400:	e8 8c fe ff ff       	call   802291 <syscall>
  802405:	83 c4 18             	add    $0x18,%esp
}
  802408:	c9                   	leave  
  802409:	c3                   	ret    

0080240a <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  80240a:	55                   	push   %ebp
  80240b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  80240d:	6a 00                	push   $0x0
  80240f:	6a 00                	push   $0x0
  802411:	6a 00                	push   $0x0
  802413:	ff 75 0c             	pushl  0xc(%ebp)
  802416:	ff 75 08             	pushl  0x8(%ebp)
  802419:	6a 0d                	push   $0xd
  80241b:	e8 71 fe ff ff       	call   802291 <syscall>
  802420:	83 c4 18             	add    $0x18,%esp
	return;
  802423:	90                   	nop
}
  802424:	c9                   	leave  
  802425:	c3                   	ret    

00802426 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  802426:	55                   	push   %ebp
  802427:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	6a 00                	push   $0x0
  80242f:	ff 75 0c             	pushl  0xc(%ebp)
  802432:	ff 75 08             	pushl  0x8(%ebp)
  802435:	6a 0e                	push   $0xe
  802437:	e8 55 fe ff ff       	call   802291 <syscall>
  80243c:	83 c4 18             	add    $0x18,%esp
	return ;
  80243f:	90                   	nop
}
  802440:	c9                   	leave  
  802441:	c3                   	ret    

00802442 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802442:	55                   	push   %ebp
  802443:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802445:	6a 00                	push   $0x0
  802447:	6a 00                	push   $0x0
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	6a 00                	push   $0x0
  80244f:	6a 0c                	push   $0xc
  802451:	e8 3b fe ff ff       	call   802291 <syscall>
  802456:	83 c4 18             	add    $0x18,%esp
}
  802459:	c9                   	leave  
  80245a:	c3                   	ret    

0080245b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80245b:	55                   	push   %ebp
  80245c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80245e:	6a 00                	push   $0x0
  802460:	6a 00                	push   $0x0
  802462:	6a 00                	push   $0x0
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 10                	push   $0x10
  80246a:	e8 22 fe ff ff       	call   802291 <syscall>
  80246f:	83 c4 18             	add    $0x18,%esp
}
  802472:	90                   	nop
  802473:	c9                   	leave  
  802474:	c3                   	ret    

00802475 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802475:	55                   	push   %ebp
  802476:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802478:	6a 00                	push   $0x0
  80247a:	6a 00                	push   $0x0
  80247c:	6a 00                	push   $0x0
  80247e:	6a 00                	push   $0x0
  802480:	6a 00                	push   $0x0
  802482:	6a 11                	push   $0x11
  802484:	e8 08 fe ff ff       	call   802291 <syscall>
  802489:	83 c4 18             	add    $0x18,%esp
}
  80248c:	90                   	nop
  80248d:	c9                   	leave  
  80248e:	c3                   	ret    

0080248f <sys_cputc>:


void
sys_cputc(const char c)
{
  80248f:	55                   	push   %ebp
  802490:	89 e5                	mov    %esp,%ebp
  802492:	83 ec 04             	sub    $0x4,%esp
  802495:	8b 45 08             	mov    0x8(%ebp),%eax
  802498:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80249b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 00                	push   $0x0
  8024a3:	6a 00                	push   $0x0
  8024a5:	6a 00                	push   $0x0
  8024a7:	50                   	push   %eax
  8024a8:	6a 12                	push   $0x12
  8024aa:	e8 e2 fd ff ff       	call   802291 <syscall>
  8024af:	83 c4 18             	add    $0x18,%esp
}
  8024b2:	90                   	nop
  8024b3:	c9                   	leave  
  8024b4:	c3                   	ret    

008024b5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8024b5:	55                   	push   %ebp
  8024b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8024b8:	6a 00                	push   $0x0
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 00                	push   $0x0
  8024be:	6a 00                	push   $0x0
  8024c0:	6a 00                	push   $0x0
  8024c2:	6a 13                	push   $0x13
  8024c4:	e8 c8 fd ff ff       	call   802291 <syscall>
  8024c9:	83 c4 18             	add    $0x18,%esp
}
  8024cc:	90                   	nop
  8024cd:	c9                   	leave  
  8024ce:	c3                   	ret    

008024cf <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8024cf:	55                   	push   %ebp
  8024d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8024d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d5:	6a 00                	push   $0x0
  8024d7:	6a 00                	push   $0x0
  8024d9:	6a 00                	push   $0x0
  8024db:	ff 75 0c             	pushl  0xc(%ebp)
  8024de:	50                   	push   %eax
  8024df:	6a 14                	push   $0x14
  8024e1:	e8 ab fd ff ff       	call   802291 <syscall>
  8024e6:	83 c4 18             	add    $0x18,%esp
}
  8024e9:	c9                   	leave  
  8024ea:	c3                   	ret    

008024eb <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  8024eb:	55                   	push   %ebp
  8024ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  8024ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f1:	6a 00                	push   $0x0
  8024f3:	6a 00                	push   $0x0
  8024f5:	6a 00                	push   $0x0
  8024f7:	6a 00                	push   $0x0
  8024f9:	50                   	push   %eax
  8024fa:	6a 17                	push   $0x17
  8024fc:	e8 90 fd ff ff       	call   802291 <syscall>
  802501:	83 c4 18             	add    $0x18,%esp
}
  802504:	c9                   	leave  
  802505:	c3                   	ret    

00802506 <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  802506:	55                   	push   %ebp
  802507:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  802509:	8b 45 08             	mov    0x8(%ebp),%eax
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	6a 00                	push   $0x0
  802512:	6a 00                	push   $0x0
  802514:	50                   	push   %eax
  802515:	6a 15                	push   $0x15
  802517:	e8 75 fd ff ff       	call   802291 <syscall>
  80251c:	83 c4 18             	add    $0x18,%esp
}
  80251f:	90                   	nop
  802520:	c9                   	leave  
  802521:	c3                   	ret    

00802522 <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  802522:	55                   	push   %ebp
  802523:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  802525:	8b 45 08             	mov    0x8(%ebp),%eax
  802528:	6a 00                	push   $0x0
  80252a:	6a 00                	push   $0x0
  80252c:	6a 00                	push   $0x0
  80252e:	6a 00                	push   $0x0
  802530:	50                   	push   %eax
  802531:	6a 16                	push   $0x16
  802533:	e8 59 fd ff ff       	call   802291 <syscall>
  802538:	83 c4 18             	add    $0x18,%esp
}
  80253b:	90                   	nop
  80253c:	c9                   	leave  
  80253d:	c3                   	ret    

0080253e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  80253e:	55                   	push   %ebp
  80253f:	89 e5                	mov    %esp,%ebp
  802541:	83 ec 04             	sub    $0x4,%esp
  802544:	8b 45 10             	mov    0x10(%ebp),%eax
  802547:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  80254a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80254d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802551:	8b 45 08             	mov    0x8(%ebp),%eax
  802554:	6a 00                	push   $0x0
  802556:	51                   	push   %ecx
  802557:	52                   	push   %edx
  802558:	ff 75 0c             	pushl  0xc(%ebp)
  80255b:	50                   	push   %eax
  80255c:	6a 18                	push   $0x18
  80255e:	e8 2e fd ff ff       	call   802291 <syscall>
  802563:	83 c4 18             	add    $0x18,%esp
}
  802566:	c9                   	leave  
  802567:	c3                   	ret    

00802568 <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  802568:	55                   	push   %ebp
  802569:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  80256b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80256e:	8b 45 08             	mov    0x8(%ebp),%eax
  802571:	6a 00                	push   $0x0
  802573:	6a 00                	push   $0x0
  802575:	6a 00                	push   $0x0
  802577:	52                   	push   %edx
  802578:	50                   	push   %eax
  802579:	6a 19                	push   $0x19
  80257b:	e8 11 fd ff ff       	call   802291 <syscall>
  802580:	83 c4 18             	add    $0x18,%esp
}
  802583:	c9                   	leave  
  802584:	c3                   	ret    

00802585 <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  802585:	55                   	push   %ebp
  802586:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  802588:	8b 45 08             	mov    0x8(%ebp),%eax
  80258b:	6a 00                	push   $0x0
  80258d:	6a 00                	push   $0x0
  80258f:	6a 00                	push   $0x0
  802591:	6a 00                	push   $0x0
  802593:	50                   	push   %eax
  802594:	6a 1a                	push   $0x1a
  802596:	e8 f6 fc ff ff       	call   802291 <syscall>
  80259b:	83 c4 18             	add    $0x18,%esp
}
  80259e:	c9                   	leave  
  80259f:	c3                   	ret    

008025a0 <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  8025a0:	55                   	push   %ebp
  8025a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  8025a3:	6a 00                	push   $0x0
  8025a5:	6a 00                	push   $0x0
  8025a7:	6a 00                	push   $0x0
  8025a9:	6a 00                	push   $0x0
  8025ab:	6a 00                	push   $0x0
  8025ad:	6a 1b                	push   $0x1b
  8025af:	e8 dd fc ff ff       	call   802291 <syscall>
  8025b4:	83 c4 18             	add    $0x18,%esp
}
  8025b7:	c9                   	leave  
  8025b8:	c3                   	ret    

008025b9 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8025b9:	55                   	push   %ebp
  8025ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8025bc:	6a 00                	push   $0x0
  8025be:	6a 00                	push   $0x0
  8025c0:	6a 00                	push   $0x0
  8025c2:	6a 00                	push   $0x0
  8025c4:	6a 00                	push   $0x0
  8025c6:	6a 1c                	push   $0x1c
  8025c8:	e8 c4 fc ff ff       	call   802291 <syscall>
  8025cd:	83 c4 18             	add    $0x18,%esp
}
  8025d0:	c9                   	leave  
  8025d1:	c3                   	ret    

008025d2 <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  8025d2:	55                   	push   %ebp
  8025d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  8025d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d8:	6a 00                	push   $0x0
  8025da:	6a 00                	push   $0x0
  8025dc:	6a 00                	push   $0x0
  8025de:	ff 75 0c             	pushl  0xc(%ebp)
  8025e1:	50                   	push   %eax
  8025e2:	6a 1d                	push   $0x1d
  8025e4:	e8 a8 fc ff ff       	call   802291 <syscall>
  8025e9:	83 c4 18             	add    $0x18,%esp
}
  8025ec:	c9                   	leave  
  8025ed:	c3                   	ret    

008025ee <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8025ee:	55                   	push   %ebp
  8025ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8025f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f4:	6a 00                	push   $0x0
  8025f6:	6a 00                	push   $0x0
  8025f8:	6a 00                	push   $0x0
  8025fa:	6a 00                	push   $0x0
  8025fc:	50                   	push   %eax
  8025fd:	6a 1e                	push   $0x1e
  8025ff:	e8 8d fc ff ff       	call   802291 <syscall>
  802604:	83 c4 18             	add    $0x18,%esp
}
  802607:	90                   	nop
  802608:	c9                   	leave  
  802609:	c3                   	ret    

0080260a <sys_free_env>:

void
sys_free_env(int32 envId)
{
  80260a:	55                   	push   %ebp
  80260b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  80260d:	8b 45 08             	mov    0x8(%ebp),%eax
  802610:	6a 00                	push   $0x0
  802612:	6a 00                	push   $0x0
  802614:	6a 00                	push   $0x0
  802616:	6a 00                	push   $0x0
  802618:	50                   	push   %eax
  802619:	6a 1f                	push   $0x1f
  80261b:	e8 71 fc ff ff       	call   802291 <syscall>
  802620:	83 c4 18             	add    $0x18,%esp
}
  802623:	90                   	nop
  802624:	c9                   	leave  
  802625:	c3                   	ret    

00802626 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  802626:	55                   	push   %ebp
  802627:	89 e5                	mov    %esp,%ebp
  802629:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80262c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80262f:	8d 50 04             	lea    0x4(%eax),%edx
  802632:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802635:	6a 00                	push   $0x0
  802637:	6a 00                	push   $0x0
  802639:	6a 00                	push   $0x0
  80263b:	52                   	push   %edx
  80263c:	50                   	push   %eax
  80263d:	6a 20                	push   $0x20
  80263f:	e8 4d fc ff ff       	call   802291 <syscall>
  802644:	83 c4 18             	add    $0x18,%esp
	return result;
  802647:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80264a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80264d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802650:	89 01                	mov    %eax,(%ecx)
  802652:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802655:	8b 45 08             	mov    0x8(%ebp),%eax
  802658:	c9                   	leave  
  802659:	c2 04 00             	ret    $0x4

0080265c <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80265c:	55                   	push   %ebp
  80265d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80265f:	6a 00                	push   $0x0
  802661:	6a 00                	push   $0x0
  802663:	ff 75 10             	pushl  0x10(%ebp)
  802666:	ff 75 0c             	pushl  0xc(%ebp)
  802669:	ff 75 08             	pushl  0x8(%ebp)
  80266c:	6a 0f                	push   $0xf
  80266e:	e8 1e fc ff ff       	call   802291 <syscall>
  802673:	83 c4 18             	add    $0x18,%esp
	return ;
  802676:	90                   	nop
}
  802677:	c9                   	leave  
  802678:	c3                   	ret    

00802679 <sys_rcr2>:
uint32 sys_rcr2()
{
  802679:	55                   	push   %ebp
  80267a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80267c:	6a 00                	push   $0x0
  80267e:	6a 00                	push   $0x0
  802680:	6a 00                	push   $0x0
  802682:	6a 00                	push   $0x0
  802684:	6a 00                	push   $0x0
  802686:	6a 21                	push   $0x21
  802688:	e8 04 fc ff ff       	call   802291 <syscall>
  80268d:	83 c4 18             	add    $0x18,%esp
}
  802690:	c9                   	leave  
  802691:	c3                   	ret    

00802692 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802692:	55                   	push   %ebp
  802693:	89 e5                	mov    %esp,%ebp
  802695:	83 ec 04             	sub    $0x4,%esp
  802698:	8b 45 08             	mov    0x8(%ebp),%eax
  80269b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80269e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8026a2:	6a 00                	push   $0x0
  8026a4:	6a 00                	push   $0x0
  8026a6:	6a 00                	push   $0x0
  8026a8:	6a 00                	push   $0x0
  8026aa:	50                   	push   %eax
  8026ab:	6a 22                	push   $0x22
  8026ad:	e8 df fb ff ff       	call   802291 <syscall>
  8026b2:	83 c4 18             	add    $0x18,%esp
	return ;
  8026b5:	90                   	nop
}
  8026b6:	c9                   	leave  
  8026b7:	c3                   	ret    

008026b8 <rsttst>:
void rsttst()
{
  8026b8:	55                   	push   %ebp
  8026b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8026bb:	6a 00                	push   $0x0
  8026bd:	6a 00                	push   $0x0
  8026bf:	6a 00                	push   $0x0
  8026c1:	6a 00                	push   $0x0
  8026c3:	6a 00                	push   $0x0
  8026c5:	6a 24                	push   $0x24
  8026c7:	e8 c5 fb ff ff       	call   802291 <syscall>
  8026cc:	83 c4 18             	add    $0x18,%esp
	return ;
  8026cf:	90                   	nop
}
  8026d0:	c9                   	leave  
  8026d1:	c3                   	ret    

008026d2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8026d2:	55                   	push   %ebp
  8026d3:	89 e5                	mov    %esp,%ebp
  8026d5:	83 ec 04             	sub    $0x4,%esp
  8026d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8026db:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8026de:	8b 55 18             	mov    0x18(%ebp),%edx
  8026e1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8026e5:	52                   	push   %edx
  8026e6:	50                   	push   %eax
  8026e7:	ff 75 10             	pushl  0x10(%ebp)
  8026ea:	ff 75 0c             	pushl  0xc(%ebp)
  8026ed:	ff 75 08             	pushl  0x8(%ebp)
  8026f0:	6a 23                	push   $0x23
  8026f2:	e8 9a fb ff ff       	call   802291 <syscall>
  8026f7:	83 c4 18             	add    $0x18,%esp
	return ;
  8026fa:	90                   	nop
}
  8026fb:	c9                   	leave  
  8026fc:	c3                   	ret    

008026fd <chktst>:
void chktst(uint32 n)
{
  8026fd:	55                   	push   %ebp
  8026fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802700:	6a 00                	push   $0x0
  802702:	6a 00                	push   $0x0
  802704:	6a 00                	push   $0x0
  802706:	6a 00                	push   $0x0
  802708:	ff 75 08             	pushl  0x8(%ebp)
  80270b:	6a 25                	push   $0x25
  80270d:	e8 7f fb ff ff       	call   802291 <syscall>
  802712:	83 c4 18             	add    $0x18,%esp
	return ;
  802715:	90                   	nop
}
  802716:	c9                   	leave  
  802717:	c3                   	ret    

00802718 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802718:	55                   	push   %ebp
  802719:	89 e5                	mov    %esp,%ebp
  80271b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80271e:	6a 00                	push   $0x0
  802720:	6a 00                	push   $0x0
  802722:	6a 00                	push   $0x0
  802724:	6a 00                	push   $0x0
  802726:	6a 00                	push   $0x0
  802728:	6a 26                	push   $0x26
  80272a:	e8 62 fb ff ff       	call   802291 <syscall>
  80272f:	83 c4 18             	add    $0x18,%esp
  802732:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802735:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802739:	75 07                	jne    802742 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80273b:	b8 01 00 00 00       	mov    $0x1,%eax
  802740:	eb 05                	jmp    802747 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802742:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802747:	c9                   	leave  
  802748:	c3                   	ret    

00802749 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802749:	55                   	push   %ebp
  80274a:	89 e5                	mov    %esp,%ebp
  80274c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80274f:	6a 00                	push   $0x0
  802751:	6a 00                	push   $0x0
  802753:	6a 00                	push   $0x0
  802755:	6a 00                	push   $0x0
  802757:	6a 00                	push   $0x0
  802759:	6a 26                	push   $0x26
  80275b:	e8 31 fb ff ff       	call   802291 <syscall>
  802760:	83 c4 18             	add    $0x18,%esp
  802763:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802766:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80276a:	75 07                	jne    802773 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80276c:	b8 01 00 00 00       	mov    $0x1,%eax
  802771:	eb 05                	jmp    802778 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802773:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802778:	c9                   	leave  
  802779:	c3                   	ret    

0080277a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80277a:	55                   	push   %ebp
  80277b:	89 e5                	mov    %esp,%ebp
  80277d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802780:	6a 00                	push   $0x0
  802782:	6a 00                	push   $0x0
  802784:	6a 00                	push   $0x0
  802786:	6a 00                	push   $0x0
  802788:	6a 00                	push   $0x0
  80278a:	6a 26                	push   $0x26
  80278c:	e8 00 fb ff ff       	call   802291 <syscall>
  802791:	83 c4 18             	add    $0x18,%esp
  802794:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802797:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80279b:	75 07                	jne    8027a4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80279d:	b8 01 00 00 00       	mov    $0x1,%eax
  8027a2:	eb 05                	jmp    8027a9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8027a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027a9:	c9                   	leave  
  8027aa:	c3                   	ret    

008027ab <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8027ab:	55                   	push   %ebp
  8027ac:	89 e5                	mov    %esp,%ebp
  8027ae:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027b1:	6a 00                	push   $0x0
  8027b3:	6a 00                	push   $0x0
  8027b5:	6a 00                	push   $0x0
  8027b7:	6a 00                	push   $0x0
  8027b9:	6a 00                	push   $0x0
  8027bb:	6a 26                	push   $0x26
  8027bd:	e8 cf fa ff ff       	call   802291 <syscall>
  8027c2:	83 c4 18             	add    $0x18,%esp
  8027c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8027c8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8027cc:	75 07                	jne    8027d5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8027ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8027d3:	eb 05                	jmp    8027da <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8027d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027da:	c9                   	leave  
  8027db:	c3                   	ret    

008027dc <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8027dc:	55                   	push   %ebp
  8027dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8027df:	6a 00                	push   $0x0
  8027e1:	6a 00                	push   $0x0
  8027e3:	6a 00                	push   $0x0
  8027e5:	6a 00                	push   $0x0
  8027e7:	ff 75 08             	pushl  0x8(%ebp)
  8027ea:	6a 27                	push   $0x27
  8027ec:	e8 a0 fa ff ff       	call   802291 <syscall>
  8027f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8027f4:	90                   	nop
}
  8027f5:	c9                   	leave  
  8027f6:	c3                   	ret    
  8027f7:	90                   	nop

008027f8 <__udivdi3>:
  8027f8:	55                   	push   %ebp
  8027f9:	57                   	push   %edi
  8027fa:	56                   	push   %esi
  8027fb:	53                   	push   %ebx
  8027fc:	83 ec 1c             	sub    $0x1c,%esp
  8027ff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802803:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802807:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80280b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80280f:	89 ca                	mov    %ecx,%edx
  802811:	89 f8                	mov    %edi,%eax
  802813:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802817:	85 f6                	test   %esi,%esi
  802819:	75 2d                	jne    802848 <__udivdi3+0x50>
  80281b:	39 cf                	cmp    %ecx,%edi
  80281d:	77 65                	ja     802884 <__udivdi3+0x8c>
  80281f:	89 fd                	mov    %edi,%ebp
  802821:	85 ff                	test   %edi,%edi
  802823:	75 0b                	jne    802830 <__udivdi3+0x38>
  802825:	b8 01 00 00 00       	mov    $0x1,%eax
  80282a:	31 d2                	xor    %edx,%edx
  80282c:	f7 f7                	div    %edi
  80282e:	89 c5                	mov    %eax,%ebp
  802830:	31 d2                	xor    %edx,%edx
  802832:	89 c8                	mov    %ecx,%eax
  802834:	f7 f5                	div    %ebp
  802836:	89 c1                	mov    %eax,%ecx
  802838:	89 d8                	mov    %ebx,%eax
  80283a:	f7 f5                	div    %ebp
  80283c:	89 cf                	mov    %ecx,%edi
  80283e:	89 fa                	mov    %edi,%edx
  802840:	83 c4 1c             	add    $0x1c,%esp
  802843:	5b                   	pop    %ebx
  802844:	5e                   	pop    %esi
  802845:	5f                   	pop    %edi
  802846:	5d                   	pop    %ebp
  802847:	c3                   	ret    
  802848:	39 ce                	cmp    %ecx,%esi
  80284a:	77 28                	ja     802874 <__udivdi3+0x7c>
  80284c:	0f bd fe             	bsr    %esi,%edi
  80284f:	83 f7 1f             	xor    $0x1f,%edi
  802852:	75 40                	jne    802894 <__udivdi3+0x9c>
  802854:	39 ce                	cmp    %ecx,%esi
  802856:	72 0a                	jb     802862 <__udivdi3+0x6a>
  802858:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80285c:	0f 87 9e 00 00 00    	ja     802900 <__udivdi3+0x108>
  802862:	b8 01 00 00 00       	mov    $0x1,%eax
  802867:	89 fa                	mov    %edi,%edx
  802869:	83 c4 1c             	add    $0x1c,%esp
  80286c:	5b                   	pop    %ebx
  80286d:	5e                   	pop    %esi
  80286e:	5f                   	pop    %edi
  80286f:	5d                   	pop    %ebp
  802870:	c3                   	ret    
  802871:	8d 76 00             	lea    0x0(%esi),%esi
  802874:	31 ff                	xor    %edi,%edi
  802876:	31 c0                	xor    %eax,%eax
  802878:	89 fa                	mov    %edi,%edx
  80287a:	83 c4 1c             	add    $0x1c,%esp
  80287d:	5b                   	pop    %ebx
  80287e:	5e                   	pop    %esi
  80287f:	5f                   	pop    %edi
  802880:	5d                   	pop    %ebp
  802881:	c3                   	ret    
  802882:	66 90                	xchg   %ax,%ax
  802884:	89 d8                	mov    %ebx,%eax
  802886:	f7 f7                	div    %edi
  802888:	31 ff                	xor    %edi,%edi
  80288a:	89 fa                	mov    %edi,%edx
  80288c:	83 c4 1c             	add    $0x1c,%esp
  80288f:	5b                   	pop    %ebx
  802890:	5e                   	pop    %esi
  802891:	5f                   	pop    %edi
  802892:	5d                   	pop    %ebp
  802893:	c3                   	ret    
  802894:	bd 20 00 00 00       	mov    $0x20,%ebp
  802899:	89 eb                	mov    %ebp,%ebx
  80289b:	29 fb                	sub    %edi,%ebx
  80289d:	89 f9                	mov    %edi,%ecx
  80289f:	d3 e6                	shl    %cl,%esi
  8028a1:	89 c5                	mov    %eax,%ebp
  8028a3:	88 d9                	mov    %bl,%cl
  8028a5:	d3 ed                	shr    %cl,%ebp
  8028a7:	89 e9                	mov    %ebp,%ecx
  8028a9:	09 f1                	or     %esi,%ecx
  8028ab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8028af:	89 f9                	mov    %edi,%ecx
  8028b1:	d3 e0                	shl    %cl,%eax
  8028b3:	89 c5                	mov    %eax,%ebp
  8028b5:	89 d6                	mov    %edx,%esi
  8028b7:	88 d9                	mov    %bl,%cl
  8028b9:	d3 ee                	shr    %cl,%esi
  8028bb:	89 f9                	mov    %edi,%ecx
  8028bd:	d3 e2                	shl    %cl,%edx
  8028bf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8028c3:	88 d9                	mov    %bl,%cl
  8028c5:	d3 e8                	shr    %cl,%eax
  8028c7:	09 c2                	or     %eax,%edx
  8028c9:	89 d0                	mov    %edx,%eax
  8028cb:	89 f2                	mov    %esi,%edx
  8028cd:	f7 74 24 0c          	divl   0xc(%esp)
  8028d1:	89 d6                	mov    %edx,%esi
  8028d3:	89 c3                	mov    %eax,%ebx
  8028d5:	f7 e5                	mul    %ebp
  8028d7:	39 d6                	cmp    %edx,%esi
  8028d9:	72 19                	jb     8028f4 <__udivdi3+0xfc>
  8028db:	74 0b                	je     8028e8 <__udivdi3+0xf0>
  8028dd:	89 d8                	mov    %ebx,%eax
  8028df:	31 ff                	xor    %edi,%edi
  8028e1:	e9 58 ff ff ff       	jmp    80283e <__udivdi3+0x46>
  8028e6:	66 90                	xchg   %ax,%ax
  8028e8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8028ec:	89 f9                	mov    %edi,%ecx
  8028ee:	d3 e2                	shl    %cl,%edx
  8028f0:	39 c2                	cmp    %eax,%edx
  8028f2:	73 e9                	jae    8028dd <__udivdi3+0xe5>
  8028f4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8028f7:	31 ff                	xor    %edi,%edi
  8028f9:	e9 40 ff ff ff       	jmp    80283e <__udivdi3+0x46>
  8028fe:	66 90                	xchg   %ax,%ax
  802900:	31 c0                	xor    %eax,%eax
  802902:	e9 37 ff ff ff       	jmp    80283e <__udivdi3+0x46>
  802907:	90                   	nop

00802908 <__umoddi3>:
  802908:	55                   	push   %ebp
  802909:	57                   	push   %edi
  80290a:	56                   	push   %esi
  80290b:	53                   	push   %ebx
  80290c:	83 ec 1c             	sub    $0x1c,%esp
  80290f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802913:	8b 74 24 34          	mov    0x34(%esp),%esi
  802917:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80291b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80291f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802923:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802927:	89 f3                	mov    %esi,%ebx
  802929:	89 fa                	mov    %edi,%edx
  80292b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80292f:	89 34 24             	mov    %esi,(%esp)
  802932:	85 c0                	test   %eax,%eax
  802934:	75 1a                	jne    802950 <__umoddi3+0x48>
  802936:	39 f7                	cmp    %esi,%edi
  802938:	0f 86 a2 00 00 00    	jbe    8029e0 <__umoddi3+0xd8>
  80293e:	89 c8                	mov    %ecx,%eax
  802940:	89 f2                	mov    %esi,%edx
  802942:	f7 f7                	div    %edi
  802944:	89 d0                	mov    %edx,%eax
  802946:	31 d2                	xor    %edx,%edx
  802948:	83 c4 1c             	add    $0x1c,%esp
  80294b:	5b                   	pop    %ebx
  80294c:	5e                   	pop    %esi
  80294d:	5f                   	pop    %edi
  80294e:	5d                   	pop    %ebp
  80294f:	c3                   	ret    
  802950:	39 f0                	cmp    %esi,%eax
  802952:	0f 87 ac 00 00 00    	ja     802a04 <__umoddi3+0xfc>
  802958:	0f bd e8             	bsr    %eax,%ebp
  80295b:	83 f5 1f             	xor    $0x1f,%ebp
  80295e:	0f 84 ac 00 00 00    	je     802a10 <__umoddi3+0x108>
  802964:	bf 20 00 00 00       	mov    $0x20,%edi
  802969:	29 ef                	sub    %ebp,%edi
  80296b:	89 fe                	mov    %edi,%esi
  80296d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802971:	89 e9                	mov    %ebp,%ecx
  802973:	d3 e0                	shl    %cl,%eax
  802975:	89 d7                	mov    %edx,%edi
  802977:	89 f1                	mov    %esi,%ecx
  802979:	d3 ef                	shr    %cl,%edi
  80297b:	09 c7                	or     %eax,%edi
  80297d:	89 e9                	mov    %ebp,%ecx
  80297f:	d3 e2                	shl    %cl,%edx
  802981:	89 14 24             	mov    %edx,(%esp)
  802984:	89 d8                	mov    %ebx,%eax
  802986:	d3 e0                	shl    %cl,%eax
  802988:	89 c2                	mov    %eax,%edx
  80298a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80298e:	d3 e0                	shl    %cl,%eax
  802990:	89 44 24 04          	mov    %eax,0x4(%esp)
  802994:	8b 44 24 08          	mov    0x8(%esp),%eax
  802998:	89 f1                	mov    %esi,%ecx
  80299a:	d3 e8                	shr    %cl,%eax
  80299c:	09 d0                	or     %edx,%eax
  80299e:	d3 eb                	shr    %cl,%ebx
  8029a0:	89 da                	mov    %ebx,%edx
  8029a2:	f7 f7                	div    %edi
  8029a4:	89 d3                	mov    %edx,%ebx
  8029a6:	f7 24 24             	mull   (%esp)
  8029a9:	89 c6                	mov    %eax,%esi
  8029ab:	89 d1                	mov    %edx,%ecx
  8029ad:	39 d3                	cmp    %edx,%ebx
  8029af:	0f 82 87 00 00 00    	jb     802a3c <__umoddi3+0x134>
  8029b5:	0f 84 91 00 00 00    	je     802a4c <__umoddi3+0x144>
  8029bb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8029bf:	29 f2                	sub    %esi,%edx
  8029c1:	19 cb                	sbb    %ecx,%ebx
  8029c3:	89 d8                	mov    %ebx,%eax
  8029c5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8029c9:	d3 e0                	shl    %cl,%eax
  8029cb:	89 e9                	mov    %ebp,%ecx
  8029cd:	d3 ea                	shr    %cl,%edx
  8029cf:	09 d0                	or     %edx,%eax
  8029d1:	89 e9                	mov    %ebp,%ecx
  8029d3:	d3 eb                	shr    %cl,%ebx
  8029d5:	89 da                	mov    %ebx,%edx
  8029d7:	83 c4 1c             	add    $0x1c,%esp
  8029da:	5b                   	pop    %ebx
  8029db:	5e                   	pop    %esi
  8029dc:	5f                   	pop    %edi
  8029dd:	5d                   	pop    %ebp
  8029de:	c3                   	ret    
  8029df:	90                   	nop
  8029e0:	89 fd                	mov    %edi,%ebp
  8029e2:	85 ff                	test   %edi,%edi
  8029e4:	75 0b                	jne    8029f1 <__umoddi3+0xe9>
  8029e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8029eb:	31 d2                	xor    %edx,%edx
  8029ed:	f7 f7                	div    %edi
  8029ef:	89 c5                	mov    %eax,%ebp
  8029f1:	89 f0                	mov    %esi,%eax
  8029f3:	31 d2                	xor    %edx,%edx
  8029f5:	f7 f5                	div    %ebp
  8029f7:	89 c8                	mov    %ecx,%eax
  8029f9:	f7 f5                	div    %ebp
  8029fb:	89 d0                	mov    %edx,%eax
  8029fd:	e9 44 ff ff ff       	jmp    802946 <__umoddi3+0x3e>
  802a02:	66 90                	xchg   %ax,%ax
  802a04:	89 c8                	mov    %ecx,%eax
  802a06:	89 f2                	mov    %esi,%edx
  802a08:	83 c4 1c             	add    $0x1c,%esp
  802a0b:	5b                   	pop    %ebx
  802a0c:	5e                   	pop    %esi
  802a0d:	5f                   	pop    %edi
  802a0e:	5d                   	pop    %ebp
  802a0f:	c3                   	ret    
  802a10:	3b 04 24             	cmp    (%esp),%eax
  802a13:	72 06                	jb     802a1b <__umoddi3+0x113>
  802a15:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802a19:	77 0f                	ja     802a2a <__umoddi3+0x122>
  802a1b:	89 f2                	mov    %esi,%edx
  802a1d:	29 f9                	sub    %edi,%ecx
  802a1f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802a23:	89 14 24             	mov    %edx,(%esp)
  802a26:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802a2a:	8b 44 24 04          	mov    0x4(%esp),%eax
  802a2e:	8b 14 24             	mov    (%esp),%edx
  802a31:	83 c4 1c             	add    $0x1c,%esp
  802a34:	5b                   	pop    %ebx
  802a35:	5e                   	pop    %esi
  802a36:	5f                   	pop    %edi
  802a37:	5d                   	pop    %ebp
  802a38:	c3                   	ret    
  802a39:	8d 76 00             	lea    0x0(%esi),%esi
  802a3c:	2b 04 24             	sub    (%esp),%eax
  802a3f:	19 fa                	sbb    %edi,%edx
  802a41:	89 d1                	mov    %edx,%ecx
  802a43:	89 c6                	mov    %eax,%esi
  802a45:	e9 71 ff ff ff       	jmp    8029bb <__umoddi3+0xb3>
  802a4a:	66 90                	xchg   %ax,%ax
  802a4c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802a50:	72 ea                	jb     802a3c <__umoddi3+0x134>
  802a52:	89 d9                	mov    %ebx,%ecx
  802a54:	e9 62 ff ff ff       	jmp    8029bb <__umoddi3+0xb3>
