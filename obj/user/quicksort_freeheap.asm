
obj/user/quicksort_freeheap:     file format elf32-i386


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
  800031:	e8 92 05 00 00       	call   8005c8 <libmain>
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

	do
	{
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames();
  800049:	e8 bf 22 00 00       	call   80230d <sys_calculate_free_frames>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	e8 d1 22 00 00       	call   802326 <sys_calculate_modified_frames>
  800055:	01 d8                	add    %ebx,%eax
  800057:	89 45 f0             	mov    %eax,-0x10(%ebp)

		Iteration++ ;
  80005a:	ff 45 f4             	incl   -0xc(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

//	sys_disable_interrupt();

			readline("Enter the number of elements: ", Line);
  80005d:	83 ec 08             	sub    $0x8,%esp
  800060:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800066:	50                   	push   %eax
  800067:	68 c0 29 80 00       	push   $0x8029c0
  80006c:	e8 be 0d 00 00       	call   800e2f <readline>
  800071:	83 c4 10             	add    $0x10,%esp
			int NumOfElements = strtol(Line, NULL, 10) ;
  800074:	83 ec 04             	sub    $0x4,%esp
  800077:	6a 0a                	push   $0xa
  800079:	6a 00                	push   $0x0
  80007b:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800081:	50                   	push   %eax
  800082:	e8 0e 13 00 00       	call   801395 <strtol>
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	89 45 ec             	mov    %eax,-0x14(%ebp)
			int *Elements = malloc(sizeof(int) * NumOfElements) ;
  80008d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800090:	c1 e0 02             	shl    $0x2,%eax
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	50                   	push   %eax
  800097:	e8 a1 16 00 00       	call   80173d <malloc>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			cprintf("Choose the initialization method:\n") ;
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	68 e0 29 80 00       	push   $0x8029e0
  8000aa:	e8 05 07 00 00       	call   8007b4 <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000b2:	83 ec 0c             	sub    $0xc,%esp
  8000b5:	68 03 2a 80 00       	push   $0x802a03
  8000ba:	e8 f5 06 00 00       	call   8007b4 <cprintf>
  8000bf:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000c2:	83 ec 0c             	sub    $0xc,%esp
  8000c5:	68 11 2a 80 00       	push   $0x802a11
  8000ca:	e8 e5 06 00 00       	call   8007b4 <cprintf>
  8000cf:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\nSelect: ") ;
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 20 2a 80 00       	push   $0x802a20
  8000da:	e8 d5 06 00 00       	call   8007b4 <cprintf>
  8000df:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8000e2:	e8 89 04 00 00       	call   800570 <getchar>
  8000e7:	88 45 e7             	mov    %al,-0x19(%ebp)
			cputchar(Chose);
  8000ea:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	50                   	push   %eax
  8000f2:	e8 31 04 00 00       	call   800528 <cputchar>
  8000f7:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8000fa:	83 ec 0c             	sub    $0xc,%esp
  8000fd:	6a 0a                	push   $0xa
  8000ff:	e8 24 04 00 00       	call   800528 <cputchar>
  800104:	83 c4 10             	add    $0x10,%esp
		//sys_enable_interrupt();
		int  i ;
		switch (Chose)
  800107:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  80010b:	83 f8 62             	cmp    $0x62,%eax
  80010e:	74 1d                	je     80012d <_main+0xf5>
  800110:	83 f8 63             	cmp    $0x63,%eax
  800113:	74 2b                	je     800140 <_main+0x108>
  800115:	83 f8 61             	cmp    $0x61,%eax
  800118:	75 39                	jne    800153 <_main+0x11b>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80011a:	83 ec 08             	sub    $0x8,%esp
  80011d:	ff 75 ec             	pushl  -0x14(%ebp)
  800120:	ff 75 e8             	pushl  -0x18(%ebp)
  800123:	e8 c8 02 00 00       	call   8003f0 <InitializeAscending>
  800128:	83 c4 10             	add    $0x10,%esp
			break ;
  80012b:	eb 37                	jmp    800164 <_main+0x12c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80012d:	83 ec 08             	sub    $0x8,%esp
  800130:	ff 75 ec             	pushl  -0x14(%ebp)
  800133:	ff 75 e8             	pushl  -0x18(%ebp)
  800136:	e8 e6 02 00 00       	call   800421 <InitializeDescending>
  80013b:	83 c4 10             	add    $0x10,%esp
			break ;
  80013e:	eb 24                	jmp    800164 <_main+0x12c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800140:	83 ec 08             	sub    $0x8,%esp
  800143:	ff 75 ec             	pushl  -0x14(%ebp)
  800146:	ff 75 e8             	pushl  -0x18(%ebp)
  800149:	e8 08 03 00 00       	call   800456 <InitializeSemiRandom>
  80014e:	83 c4 10             	add    $0x10,%esp
			break ;
  800151:	eb 11                	jmp    800164 <_main+0x12c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  800153:	83 ec 08             	sub    $0x8,%esp
  800156:	ff 75 ec             	pushl  -0x14(%ebp)
  800159:	ff 75 e8             	pushl  -0x18(%ebp)
  80015c:	e8 f5 02 00 00       	call   800456 <InitializeSemiRandom>
  800161:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  800164:	83 ec 08             	sub    $0x8,%esp
  800167:	ff 75 ec             	pushl  -0x14(%ebp)
  80016a:	ff 75 e8             	pushl  -0x18(%ebp)
  80016d:	e8 c3 00 00 00       	call   800235 <QuickSort>
  800172:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  800175:	83 ec 08             	sub    $0x8,%esp
  800178:	ff 75 ec             	pushl  -0x14(%ebp)
  80017b:	ff 75 e8             	pushl  -0x18(%ebp)
  80017e:	e8 c3 01 00 00       	call   800346 <CheckSorted>
  800183:	83 c4 10             	add    $0x10,%esp
  800186:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800189:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80018d:	75 14                	jne    8001a3 <_main+0x16b>
  80018f:	83 ec 04             	sub    $0x4,%esp
  800192:	68 38 2a 80 00       	push   $0x802a38
  800197:	6a 41                	push   $0x41
  800199:	68 5a 2a 80 00       	push   $0x802a5a
  80019e:	e8 e6 04 00 00       	call   800689 <_panic>
		else
		{ 
				cprintf("===============================================\n") ;
  8001a3:	83 ec 0c             	sub    $0xc,%esp
  8001a6:	68 74 2a 80 00       	push   $0x802a74
  8001ab:	e8 04 06 00 00       	call   8007b4 <cprintf>
  8001b0:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	68 a8 2a 80 00       	push   $0x802aa8
  8001bb:	e8 f4 05 00 00       	call   8007b4 <cprintf>
  8001c0:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  8001c3:	83 ec 0c             	sub    $0xc,%esp
  8001c6:	68 dc 2a 80 00       	push   $0x802adc
  8001cb:	e8 e4 05 00 00       	call   8007b4 <cprintf>
  8001d0:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

			cprintf("Freeing the Heap...\n\n") ;
  8001d3:	83 ec 0c             	sub    $0xc,%esp
  8001d6:	68 0e 2b 80 00       	push   $0x802b0e
  8001db:	e8 d4 05 00 00       	call   8007b4 <cprintf>
  8001e0:	83 c4 10             	add    $0x10,%esp

		//freeHeap() ;

		///========================================================================
	//sys_disable_interrupt();
			cprintf("Do you want to repeat (y/n): ") ;
  8001e3:	83 ec 0c             	sub    $0xc,%esp
  8001e6:	68 24 2b 80 00       	push   $0x802b24
  8001eb:	e8 c4 05 00 00       	call   8007b4 <cprintf>
  8001f0:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8001f3:	e8 78 03 00 00       	call   800570 <getchar>
  8001f8:	88 45 e7             	mov    %al,-0x19(%ebp)
			cputchar(Chose);
  8001fb:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  8001ff:	83 ec 0c             	sub    $0xc,%esp
  800202:	50                   	push   %eax
  800203:	e8 20 03 00 00       	call   800528 <cputchar>
  800208:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	6a 0a                	push   $0xa
  800210:	e8 13 03 00 00       	call   800528 <cputchar>
  800215:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800218:	83 ec 0c             	sub    $0xc,%esp
  80021b:	6a 0a                	push   $0xa
  80021d:	e8 06 03 00 00       	call   800528 <cputchar>
  800222:	83 c4 10             	add    $0x10,%esp
	//sys_enable_interrupt();

	} while (Chose == 'y');
  800225:	80 7d e7 79          	cmpb   $0x79,-0x19(%ebp)
  800229:	0f 84 1a fe ff ff    	je     800049 <_main+0x11>

}
  80022f:	90                   	nop
  800230:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800233:	c9                   	leave  
  800234:	c3                   	ret    

00800235 <QuickSort>:

///Quick sort 
void QuickSort(int *Elements, int NumOfElements)
{
  800235:	55                   	push   %ebp
  800236:	89 e5                	mov    %esp,%ebp
  800238:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  80023b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80023e:	48                   	dec    %eax
  80023f:	50                   	push   %eax
  800240:	6a 00                	push   $0x0
  800242:	ff 75 0c             	pushl  0xc(%ebp)
  800245:	ff 75 08             	pushl  0x8(%ebp)
  800248:	e8 06 00 00 00       	call   800253 <QSort>
  80024d:	83 c4 10             	add    $0x10,%esp
}
  800250:	90                   	nop
  800251:	c9                   	leave  
  800252:	c3                   	ret    

00800253 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  800253:	55                   	push   %ebp
  800254:	89 e5                	mov    %esp,%ebp
  800256:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  800259:	8b 45 10             	mov    0x10(%ebp),%eax
  80025c:	3b 45 14             	cmp    0x14(%ebp),%eax
  80025f:	0f 8d de 00 00 00    	jge    800343 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  800265:	8b 45 10             	mov    0x10(%ebp),%eax
  800268:	40                   	inc    %eax
  800269:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80026c:	8b 45 14             	mov    0x14(%ebp),%eax
  80026f:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800272:	e9 80 00 00 00       	jmp    8002f7 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800277:	ff 45 f4             	incl   -0xc(%ebp)
  80027a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80027d:	3b 45 14             	cmp    0x14(%ebp),%eax
  800280:	7f 2b                	jg     8002ad <QSort+0x5a>
  800282:	8b 45 10             	mov    0x10(%ebp),%eax
  800285:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80028c:	8b 45 08             	mov    0x8(%ebp),%eax
  80028f:	01 d0                	add    %edx,%eax
  800291:	8b 10                	mov    (%eax),%edx
  800293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800296:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80029d:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a0:	01 c8                	add    %ecx,%eax
  8002a2:	8b 00                	mov    (%eax),%eax
  8002a4:	39 c2                	cmp    %eax,%edx
  8002a6:	7d cf                	jge    800277 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002a8:	eb 03                	jmp    8002ad <QSort+0x5a>
  8002aa:	ff 4d f0             	decl   -0x10(%ebp)
  8002ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002b0:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002b3:	7e 26                	jle    8002db <QSort+0x88>
  8002b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c2:	01 d0                	add    %edx,%eax
  8002c4:	8b 10                	mov    (%eax),%edx
  8002c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002c9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d3:	01 c8                	add    %ecx,%eax
  8002d5:	8b 00                	mov    (%eax),%eax
  8002d7:	39 c2                	cmp    %eax,%edx
  8002d9:	7e cf                	jle    8002aa <QSort+0x57>

		if (i <= j)
  8002db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002de:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002e1:	7f 14                	jg     8002f7 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  8002e3:	83 ec 04             	sub    $0x4,%esp
  8002e6:	ff 75 f0             	pushl  -0x10(%ebp)
  8002e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ec:	ff 75 08             	pushl  0x8(%ebp)
  8002ef:	e8 a9 00 00 00       	call   80039d <Swap>
  8002f4:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  8002f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002fa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002fd:	0f 8e 77 ff ff ff    	jle    80027a <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800303:	83 ec 04             	sub    $0x4,%esp
  800306:	ff 75 f0             	pushl  -0x10(%ebp)
  800309:	ff 75 10             	pushl  0x10(%ebp)
  80030c:	ff 75 08             	pushl  0x8(%ebp)
  80030f:	e8 89 00 00 00       	call   80039d <Swap>
  800314:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800317:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80031a:	48                   	dec    %eax
  80031b:	50                   	push   %eax
  80031c:	ff 75 10             	pushl  0x10(%ebp)
  80031f:	ff 75 0c             	pushl  0xc(%ebp)
  800322:	ff 75 08             	pushl  0x8(%ebp)
  800325:	e8 29 ff ff ff       	call   800253 <QSort>
  80032a:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  80032d:	ff 75 14             	pushl  0x14(%ebp)
  800330:	ff 75 f4             	pushl  -0xc(%ebp)
  800333:	ff 75 0c             	pushl  0xc(%ebp)
  800336:	ff 75 08             	pushl  0x8(%ebp)
  800339:	e8 15 ff ff ff       	call   800253 <QSort>
  80033e:	83 c4 10             	add    $0x10,%esp
  800341:	eb 01                	jmp    800344 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  800343:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  800344:	c9                   	leave  
  800345:	c3                   	ret    

00800346 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  800349:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  80034c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800353:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80035a:	eb 33                	jmp    80038f <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  80035c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80035f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800366:	8b 45 08             	mov    0x8(%ebp),%eax
  800369:	01 d0                	add    %edx,%eax
  80036b:	8b 10                	mov    (%eax),%edx
  80036d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800370:	40                   	inc    %eax
  800371:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800378:	8b 45 08             	mov    0x8(%ebp),%eax
  80037b:	01 c8                	add    %ecx,%eax
  80037d:	8b 00                	mov    (%eax),%eax
  80037f:	39 c2                	cmp    %eax,%edx
  800381:	7e 09                	jle    80038c <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800383:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  80038a:	eb 0c                	jmp    800398 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80038c:	ff 45 f8             	incl   -0x8(%ebp)
  80038f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800392:	48                   	dec    %eax
  800393:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800396:	7f c4                	jg     80035c <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800398:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80039b:	c9                   	leave  
  80039c:	c3                   	ret    

0080039d <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80039d:	55                   	push   %ebp
  80039e:	89 e5                	mov    %esp,%ebp
  8003a0:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8003a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b0:	01 d0                	add    %edx,%eax
  8003b2:	8b 00                	mov    (%eax),%eax
  8003b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8003b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c4:	01 c2                	add    %eax,%edx
  8003c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d3:	01 c8                	add    %ecx,%eax
  8003d5:	8b 00                	mov    (%eax),%eax
  8003d7:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8003d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8003dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	01 c2                	add    %eax,%edx
  8003e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003eb:	89 02                	mov    %eax,(%edx)
}
  8003ed:	90                   	nop
  8003ee:	c9                   	leave  
  8003ef:	c3                   	ret    

008003f0 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  8003f0:	55                   	push   %ebp
  8003f1:	89 e5                	mov    %esp,%ebp
  8003f3:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003fd:	eb 17                	jmp    800416 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  8003ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800402:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800409:	8b 45 08             	mov    0x8(%ebp),%eax
  80040c:	01 c2                	add    %eax,%edx
  80040e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800411:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800413:	ff 45 fc             	incl   -0x4(%ebp)
  800416:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800419:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80041c:	7c e1                	jl     8003ff <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80041e:	90                   	nop
  80041f:	c9                   	leave  
  800420:	c3                   	ret    

00800421 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  800421:	55                   	push   %ebp
  800422:	89 e5                	mov    %esp,%ebp
  800424:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800427:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80042e:	eb 1b                	jmp    80044b <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800430:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800433:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	01 c2                	add    %eax,%edx
  80043f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800442:	2b 45 fc             	sub    -0x4(%ebp),%eax
  800445:	48                   	dec    %eax
  800446:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800448:	ff 45 fc             	incl   -0x4(%ebp)
  80044b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80044e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800451:	7c dd                	jl     800430 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  800453:	90                   	nop
  800454:	c9                   	leave  
  800455:	c3                   	ret    

00800456 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  800456:	55                   	push   %ebp
  800457:	89 e5                	mov    %esp,%ebp
  800459:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  80045c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80045f:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800464:	f7 e9                	imul   %ecx
  800466:	c1 f9 1f             	sar    $0x1f,%ecx
  800469:	89 d0                	mov    %edx,%eax
  80046b:	29 c8                	sub    %ecx,%eax
  80046d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800470:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800477:	eb 1e                	jmp    800497 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800479:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80047c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800483:	8b 45 08             	mov    0x8(%ebp),%eax
  800486:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800489:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80048c:	99                   	cltd   
  80048d:	f7 7d f8             	idivl  -0x8(%ebp)
  800490:	89 d0                	mov    %edx,%eax
  800492:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800494:	ff 45 fc             	incl   -0x4(%ebp)
  800497:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80049d:	7c da                	jl     800479 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
	}

}
  80049f:	90                   	nop
  8004a0:	c9                   	leave  
  8004a1:	c3                   	ret    

008004a2 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  8004a2:	55                   	push   %ebp
  8004a3:	89 e5                	mov    %esp,%ebp
  8004a5:	83 ec 18             	sub    $0x18,%esp
		int i ;
		int NumsPerLine = 20 ;
  8004a8:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
		for (i = 0 ; i < NumOfElements-1 ; i++)
  8004af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8004b6:	eb 42                	jmp    8004fa <PrintElements+0x58>
		{
			if (i%NumsPerLine == 0)
  8004b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004bb:	99                   	cltd   
  8004bc:	f7 7d f0             	idivl  -0x10(%ebp)
  8004bf:	89 d0                	mov    %edx,%eax
  8004c1:	85 c0                	test   %eax,%eax
  8004c3:	75 10                	jne    8004d5 <PrintElements+0x33>
				cprintf("\n");
  8004c5:	83 ec 0c             	sub    $0xc,%esp
  8004c8:	68 42 2b 80 00       	push   $0x802b42
  8004cd:	e8 e2 02 00 00       	call   8007b4 <cprintf>
  8004d2:	83 c4 10             	add    $0x10,%esp
			cprintf("%d, ",Elements[i]);
  8004d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004df:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e2:	01 d0                	add    %edx,%eax
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	83 ec 08             	sub    $0x8,%esp
  8004e9:	50                   	push   %eax
  8004ea:	68 44 2b 80 00       	push   $0x802b44
  8004ef:	e8 c0 02 00 00       	call   8007b4 <cprintf>
  8004f4:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
		int i ;
		int NumsPerLine = 20 ;
		for (i = 0 ; i < NumOfElements-1 ; i++)
  8004f7:	ff 45 f4             	incl   -0xc(%ebp)
  8004fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fd:	48                   	dec    %eax
  8004fe:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800501:	7f b5                	jg     8004b8 <PrintElements+0x16>
		{
			if (i%NumsPerLine == 0)
				cprintf("\n");
			cprintf("%d, ",Elements[i]);
		}
		cprintf("%d\n",Elements[i]);
  800503:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800506:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80050d:	8b 45 08             	mov    0x8(%ebp),%eax
  800510:	01 d0                	add    %edx,%eax
  800512:	8b 00                	mov    (%eax),%eax
  800514:	83 ec 08             	sub    $0x8,%esp
  800517:	50                   	push   %eax
  800518:	68 49 2b 80 00       	push   $0x802b49
  80051d:	e8 92 02 00 00       	call   8007b4 <cprintf>
  800522:	83 c4 10             	add    $0x10,%esp
}
  800525:	90                   	nop
  800526:	c9                   	leave  
  800527:	c3                   	ret    

00800528 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800528:	55                   	push   %ebp
  800529:	89 e5                	mov    %esp,%ebp
  80052b:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80052e:	8b 45 08             	mov    0x8(%ebp),%eax
  800531:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800534:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800538:	83 ec 0c             	sub    $0xc,%esp
  80053b:	50                   	push   %eax
  80053c:	e8 9c 1e 00 00       	call   8023dd <sys_cputc>
  800541:	83 c4 10             	add    $0x10,%esp
}
  800544:	90                   	nop
  800545:	c9                   	leave  
  800546:	c3                   	ret    

00800547 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800547:	55                   	push   %ebp
  800548:	89 e5                	mov    %esp,%ebp
  80054a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80054d:	e8 57 1e 00 00       	call   8023a9 <sys_disable_interrupt>
	char c = ch;
  800552:	8b 45 08             	mov    0x8(%ebp),%eax
  800555:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800558:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80055c:	83 ec 0c             	sub    $0xc,%esp
  80055f:	50                   	push   %eax
  800560:	e8 78 1e 00 00       	call   8023dd <sys_cputc>
  800565:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800568:	e8 56 1e 00 00       	call   8023c3 <sys_enable_interrupt>
}
  80056d:	90                   	nop
  80056e:	c9                   	leave  
  80056f:	c3                   	ret    

00800570 <getchar>:

int
getchar(void)
{
  800570:	55                   	push   %ebp
  800571:	89 e5                	mov    %esp,%ebp
  800573:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800576:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80057d:	eb 08                	jmp    800587 <getchar+0x17>
	{
		c = sys_cgetc();
  80057f:	e8 a3 1c 00 00       	call   802227 <sys_cgetc>
  800584:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800587:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80058b:	74 f2                	je     80057f <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80058d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800590:	c9                   	leave  
  800591:	c3                   	ret    

00800592 <atomic_getchar>:

int
atomic_getchar(void)
{
  800592:	55                   	push   %ebp
  800593:	89 e5                	mov    %esp,%ebp
  800595:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800598:	e8 0c 1e 00 00       	call   8023a9 <sys_disable_interrupt>
	int c=0;
  80059d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005a4:	eb 08                	jmp    8005ae <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8005a6:	e8 7c 1c 00 00       	call   802227 <sys_cgetc>
  8005ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8005ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8005b2:	74 f2                	je     8005a6 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8005b4:	e8 0a 1e 00 00       	call   8023c3 <sys_enable_interrupt>
	return c;
  8005b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005bc:	c9                   	leave  
  8005bd:	c3                   	ret    

008005be <iscons>:

int iscons(int fdnum)
{
  8005be:	55                   	push   %ebp
  8005bf:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8005c1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8005c6:	5d                   	pop    %ebp
  8005c7:	c3                   	ret    

008005c8 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005c8:	55                   	push   %ebp
  8005c9:	89 e5                	mov    %esp,%ebp
  8005cb:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005d2:	7e 0a                	jle    8005de <libmain+0x16>
		binaryname = argv[0];
  8005d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d7:	8b 00                	mov    (%eax),%eax
  8005d9:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8005de:	83 ec 08             	sub    $0x8,%esp
  8005e1:	ff 75 0c             	pushl  0xc(%ebp)
  8005e4:	ff 75 08             	pushl  0x8(%ebp)
  8005e7:	e8 4c fa ff ff       	call   800038 <_main>
  8005ec:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8005ef:	e8 67 1c 00 00       	call   80225b <sys_getenvid>
  8005f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  8005f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005fa:	89 d0                	mov    %edx,%eax
  8005fc:	c1 e0 03             	shl    $0x3,%eax
  8005ff:	01 d0                	add    %edx,%eax
  800601:	01 c0                	add    %eax,%eax
  800603:	01 d0                	add    %edx,%eax
  800605:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80060c:	01 d0                	add    %edx,%eax
  80060e:	c1 e0 03             	shl    $0x3,%eax
  800611:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800616:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  800619:	e8 8b 1d 00 00       	call   8023a9 <sys_disable_interrupt>
		cprintf("**************************************\n");
  80061e:	83 ec 0c             	sub    $0xc,%esp
  800621:	68 68 2b 80 00       	push   $0x802b68
  800626:	e8 89 01 00 00       	call   8007b4 <cprintf>
  80062b:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  80062e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800631:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  800637:	83 ec 08             	sub    $0x8,%esp
  80063a:	50                   	push   %eax
  80063b:	68 90 2b 80 00       	push   $0x802b90
  800640:	e8 6f 01 00 00       	call   8007b4 <cprintf>
  800645:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800648:	83 ec 0c             	sub    $0xc,%esp
  80064b:	68 68 2b 80 00       	push   $0x802b68
  800650:	e8 5f 01 00 00       	call   8007b4 <cprintf>
  800655:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800658:	e8 66 1d 00 00       	call   8023c3 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80065d:	e8 19 00 00 00       	call   80067b <exit>
}
  800662:	90                   	nop
  800663:	c9                   	leave  
  800664:	c3                   	ret    

00800665 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800665:	55                   	push   %ebp
  800666:	89 e5                	mov    %esp,%ebp
  800668:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80066b:	83 ec 0c             	sub    $0xc,%esp
  80066e:	6a 00                	push   $0x0
  800670:	e8 cb 1b 00 00       	call   802240 <sys_env_destroy>
  800675:	83 c4 10             	add    $0x10,%esp
}
  800678:	90                   	nop
  800679:	c9                   	leave  
  80067a:	c3                   	ret    

0080067b <exit>:

void
exit(void)
{
  80067b:	55                   	push   %ebp
  80067c:	89 e5                	mov    %esp,%ebp
  80067e:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800681:	e8 ee 1b 00 00       	call   802274 <sys_env_exit>
}
  800686:	90                   	nop
  800687:	c9                   	leave  
  800688:	c3                   	ret    

00800689 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800689:	55                   	push   %ebp
  80068a:	89 e5                	mov    %esp,%ebp
  80068c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80068f:	8d 45 10             	lea    0x10(%ebp),%eax
  800692:	83 c0 04             	add    $0x4,%eax
  800695:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  800698:	a1 70 30 98 00       	mov    0x983070,%eax
  80069d:	85 c0                	test   %eax,%eax
  80069f:	74 16                	je     8006b7 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006a1:	a1 70 30 98 00       	mov    0x983070,%eax
  8006a6:	83 ec 08             	sub    $0x8,%esp
  8006a9:	50                   	push   %eax
  8006aa:	68 a9 2b 80 00       	push   $0x802ba9
  8006af:	e8 00 01 00 00       	call   8007b4 <cprintf>
  8006b4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006b7:	a1 00 30 80 00       	mov    0x803000,%eax
  8006bc:	ff 75 0c             	pushl  0xc(%ebp)
  8006bf:	ff 75 08             	pushl  0x8(%ebp)
  8006c2:	50                   	push   %eax
  8006c3:	68 ae 2b 80 00       	push   $0x802bae
  8006c8:	e8 e7 00 00 00       	call   8007b4 <cprintf>
  8006cd:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8006d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8006d3:	83 ec 08             	sub    $0x8,%esp
  8006d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8006d9:	50                   	push   %eax
  8006da:	e8 7a 00 00 00       	call   800759 <vcprintf>
  8006df:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  8006e2:	83 ec 0c             	sub    $0xc,%esp
  8006e5:	68 ca 2b 80 00       	push   $0x802bca
  8006ea:	e8 c5 00 00 00       	call   8007b4 <cprintf>
  8006ef:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8006f2:	e8 84 ff ff ff       	call   80067b <exit>

	// should not return here
	while (1) ;
  8006f7:	eb fe                	jmp    8006f7 <_panic+0x6e>

008006f9 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8006f9:	55                   	push   %ebp
  8006fa:	89 e5                	mov    %esp,%ebp
  8006fc:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800702:	8b 00                	mov    (%eax),%eax
  800704:	8d 48 01             	lea    0x1(%eax),%ecx
  800707:	8b 55 0c             	mov    0xc(%ebp),%edx
  80070a:	89 0a                	mov    %ecx,(%edx)
  80070c:	8b 55 08             	mov    0x8(%ebp),%edx
  80070f:	88 d1                	mov    %dl,%cl
  800711:	8b 55 0c             	mov    0xc(%ebp),%edx
  800714:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800718:	8b 45 0c             	mov    0xc(%ebp),%eax
  80071b:	8b 00                	mov    (%eax),%eax
  80071d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800722:	75 23                	jne    800747 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  800724:	8b 45 0c             	mov    0xc(%ebp),%eax
  800727:	8b 00                	mov    (%eax),%eax
  800729:	89 c2                	mov    %eax,%edx
  80072b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80072e:	83 c0 08             	add    $0x8,%eax
  800731:	83 ec 08             	sub    $0x8,%esp
  800734:	52                   	push   %edx
  800735:	50                   	push   %eax
  800736:	e8 cf 1a 00 00       	call   80220a <sys_cputs>
  80073b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80073e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800741:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800747:	8b 45 0c             	mov    0xc(%ebp),%eax
  80074a:	8b 40 04             	mov    0x4(%eax),%eax
  80074d:	8d 50 01             	lea    0x1(%eax),%edx
  800750:	8b 45 0c             	mov    0xc(%ebp),%eax
  800753:	89 50 04             	mov    %edx,0x4(%eax)
}
  800756:	90                   	nop
  800757:	c9                   	leave  
  800758:	c3                   	ret    

00800759 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800759:	55                   	push   %ebp
  80075a:	89 e5                	mov    %esp,%ebp
  80075c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800762:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800769:	00 00 00 
	b.cnt = 0;
  80076c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800773:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800776:	ff 75 0c             	pushl  0xc(%ebp)
  800779:	ff 75 08             	pushl  0x8(%ebp)
  80077c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800782:	50                   	push   %eax
  800783:	68 f9 06 80 00       	push   $0x8006f9
  800788:	e8 fa 01 00 00       	call   800987 <vprintfmt>
  80078d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  800790:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800796:	83 ec 08             	sub    $0x8,%esp
  800799:	50                   	push   %eax
  80079a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007a0:	83 c0 08             	add    $0x8,%eax
  8007a3:	50                   	push   %eax
  8007a4:	e8 61 1a 00 00       	call   80220a <sys_cputs>
  8007a9:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  8007ac:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007b2:	c9                   	leave  
  8007b3:	c3                   	ret    

008007b4 <cprintf>:

int cprintf(const char *fmt, ...) {
  8007b4:	55                   	push   %ebp
  8007b5:	89 e5                	mov    %esp,%ebp
  8007b7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007ba:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c3:	83 ec 08             	sub    $0x8,%esp
  8007c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c9:	50                   	push   %eax
  8007ca:	e8 8a ff ff ff       	call   800759 <vcprintf>
  8007cf:	83 c4 10             	add    $0x10,%esp
  8007d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007d8:	c9                   	leave  
  8007d9:	c3                   	ret    

008007da <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007da:	55                   	push   %ebp
  8007db:	89 e5                	mov    %esp,%ebp
  8007dd:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007e0:	e8 c4 1b 00 00       	call   8023a9 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007e5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ee:	83 ec 08             	sub    $0x8,%esp
  8007f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8007f4:	50                   	push   %eax
  8007f5:	e8 5f ff ff ff       	call   800759 <vcprintf>
  8007fa:	83 c4 10             	add    $0x10,%esp
  8007fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800800:	e8 be 1b 00 00       	call   8023c3 <sys_enable_interrupt>
	return cnt;
  800805:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800808:	c9                   	leave  
  800809:	c3                   	ret    

0080080a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80080a:	55                   	push   %ebp
  80080b:	89 e5                	mov    %esp,%ebp
  80080d:	53                   	push   %ebx
  80080e:	83 ec 14             	sub    $0x14,%esp
  800811:	8b 45 10             	mov    0x10(%ebp),%eax
  800814:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800817:	8b 45 14             	mov    0x14(%ebp),%eax
  80081a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80081d:	8b 45 18             	mov    0x18(%ebp),%eax
  800820:	ba 00 00 00 00       	mov    $0x0,%edx
  800825:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800828:	77 55                	ja     80087f <printnum+0x75>
  80082a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80082d:	72 05                	jb     800834 <printnum+0x2a>
  80082f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800832:	77 4b                	ja     80087f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800834:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800837:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80083a:	8b 45 18             	mov    0x18(%ebp),%eax
  80083d:	ba 00 00 00 00       	mov    $0x0,%edx
  800842:	52                   	push   %edx
  800843:	50                   	push   %eax
  800844:	ff 75 f4             	pushl  -0xc(%ebp)
  800847:	ff 75 f0             	pushl  -0x10(%ebp)
  80084a:	e8 f9 1e 00 00       	call   802748 <__udivdi3>
  80084f:	83 c4 10             	add    $0x10,%esp
  800852:	83 ec 04             	sub    $0x4,%esp
  800855:	ff 75 20             	pushl  0x20(%ebp)
  800858:	53                   	push   %ebx
  800859:	ff 75 18             	pushl  0x18(%ebp)
  80085c:	52                   	push   %edx
  80085d:	50                   	push   %eax
  80085e:	ff 75 0c             	pushl  0xc(%ebp)
  800861:	ff 75 08             	pushl  0x8(%ebp)
  800864:	e8 a1 ff ff ff       	call   80080a <printnum>
  800869:	83 c4 20             	add    $0x20,%esp
  80086c:	eb 1a                	jmp    800888 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80086e:	83 ec 08             	sub    $0x8,%esp
  800871:	ff 75 0c             	pushl  0xc(%ebp)
  800874:	ff 75 20             	pushl  0x20(%ebp)
  800877:	8b 45 08             	mov    0x8(%ebp),%eax
  80087a:	ff d0                	call   *%eax
  80087c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80087f:	ff 4d 1c             	decl   0x1c(%ebp)
  800882:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800886:	7f e6                	jg     80086e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800888:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80088b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800890:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800893:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800896:	53                   	push   %ebx
  800897:	51                   	push   %ecx
  800898:	52                   	push   %edx
  800899:	50                   	push   %eax
  80089a:	e8 b9 1f 00 00       	call   802858 <__umoddi3>
  80089f:	83 c4 10             	add    $0x10,%esp
  8008a2:	05 f4 2d 80 00       	add    $0x802df4,%eax
  8008a7:	8a 00                	mov    (%eax),%al
  8008a9:	0f be c0             	movsbl %al,%eax
  8008ac:	83 ec 08             	sub    $0x8,%esp
  8008af:	ff 75 0c             	pushl  0xc(%ebp)
  8008b2:	50                   	push   %eax
  8008b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b6:	ff d0                	call   *%eax
  8008b8:	83 c4 10             	add    $0x10,%esp
}
  8008bb:	90                   	nop
  8008bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008bf:	c9                   	leave  
  8008c0:	c3                   	ret    

008008c1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008c1:	55                   	push   %ebp
  8008c2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008c4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008c8:	7e 1c                	jle    8008e6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cd:	8b 00                	mov    (%eax),%eax
  8008cf:	8d 50 08             	lea    0x8(%eax),%edx
  8008d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d5:	89 10                	mov    %edx,(%eax)
  8008d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008da:	8b 00                	mov    (%eax),%eax
  8008dc:	83 e8 08             	sub    $0x8,%eax
  8008df:	8b 50 04             	mov    0x4(%eax),%edx
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	eb 40                	jmp    800926 <getuint+0x65>
	else if (lflag)
  8008e6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ea:	74 1e                	je     80090a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ef:	8b 00                	mov    (%eax),%eax
  8008f1:	8d 50 04             	lea    0x4(%eax),%edx
  8008f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f7:	89 10                	mov    %edx,(%eax)
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	8b 00                	mov    (%eax),%eax
  8008fe:	83 e8 04             	sub    $0x4,%eax
  800901:	8b 00                	mov    (%eax),%eax
  800903:	ba 00 00 00 00       	mov    $0x0,%edx
  800908:	eb 1c                	jmp    800926 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	8b 00                	mov    (%eax),%eax
  80090f:	8d 50 04             	lea    0x4(%eax),%edx
  800912:	8b 45 08             	mov    0x8(%ebp),%eax
  800915:	89 10                	mov    %edx,(%eax)
  800917:	8b 45 08             	mov    0x8(%ebp),%eax
  80091a:	8b 00                	mov    (%eax),%eax
  80091c:	83 e8 04             	sub    $0x4,%eax
  80091f:	8b 00                	mov    (%eax),%eax
  800921:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800926:	5d                   	pop    %ebp
  800927:	c3                   	ret    

00800928 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800928:	55                   	push   %ebp
  800929:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80092b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80092f:	7e 1c                	jle    80094d <getint+0x25>
		return va_arg(*ap, long long);
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	8b 00                	mov    (%eax),%eax
  800936:	8d 50 08             	lea    0x8(%eax),%edx
  800939:	8b 45 08             	mov    0x8(%ebp),%eax
  80093c:	89 10                	mov    %edx,(%eax)
  80093e:	8b 45 08             	mov    0x8(%ebp),%eax
  800941:	8b 00                	mov    (%eax),%eax
  800943:	83 e8 08             	sub    $0x8,%eax
  800946:	8b 50 04             	mov    0x4(%eax),%edx
  800949:	8b 00                	mov    (%eax),%eax
  80094b:	eb 38                	jmp    800985 <getint+0x5d>
	else if (lflag)
  80094d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800951:	74 1a                	je     80096d <getint+0x45>
		return va_arg(*ap, long);
  800953:	8b 45 08             	mov    0x8(%ebp),%eax
  800956:	8b 00                	mov    (%eax),%eax
  800958:	8d 50 04             	lea    0x4(%eax),%edx
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	89 10                	mov    %edx,(%eax)
  800960:	8b 45 08             	mov    0x8(%ebp),%eax
  800963:	8b 00                	mov    (%eax),%eax
  800965:	83 e8 04             	sub    $0x4,%eax
  800968:	8b 00                	mov    (%eax),%eax
  80096a:	99                   	cltd   
  80096b:	eb 18                	jmp    800985 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80096d:	8b 45 08             	mov    0x8(%ebp),%eax
  800970:	8b 00                	mov    (%eax),%eax
  800972:	8d 50 04             	lea    0x4(%eax),%edx
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	89 10                	mov    %edx,(%eax)
  80097a:	8b 45 08             	mov    0x8(%ebp),%eax
  80097d:	8b 00                	mov    (%eax),%eax
  80097f:	83 e8 04             	sub    $0x4,%eax
  800982:	8b 00                	mov    (%eax),%eax
  800984:	99                   	cltd   
}
  800985:	5d                   	pop    %ebp
  800986:	c3                   	ret    

00800987 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800987:	55                   	push   %ebp
  800988:	89 e5                	mov    %esp,%ebp
  80098a:	56                   	push   %esi
  80098b:	53                   	push   %ebx
  80098c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80098f:	eb 17                	jmp    8009a8 <vprintfmt+0x21>
			if (ch == '\0')
  800991:	85 db                	test   %ebx,%ebx
  800993:	0f 84 af 03 00 00    	je     800d48 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800999:	83 ec 08             	sub    $0x8,%esp
  80099c:	ff 75 0c             	pushl  0xc(%ebp)
  80099f:	53                   	push   %ebx
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	ff d0                	call   *%eax
  8009a5:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ab:	8d 50 01             	lea    0x1(%eax),%edx
  8009ae:	89 55 10             	mov    %edx,0x10(%ebp)
  8009b1:	8a 00                	mov    (%eax),%al
  8009b3:	0f b6 d8             	movzbl %al,%ebx
  8009b6:	83 fb 25             	cmp    $0x25,%ebx
  8009b9:	75 d6                	jne    800991 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009bb:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009bf:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009c6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009cd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009d4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009db:	8b 45 10             	mov    0x10(%ebp),%eax
  8009de:	8d 50 01             	lea    0x1(%eax),%edx
  8009e1:	89 55 10             	mov    %edx,0x10(%ebp)
  8009e4:	8a 00                	mov    (%eax),%al
  8009e6:	0f b6 d8             	movzbl %al,%ebx
  8009e9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009ec:	83 f8 55             	cmp    $0x55,%eax
  8009ef:	0f 87 2b 03 00 00    	ja     800d20 <vprintfmt+0x399>
  8009f5:	8b 04 85 18 2e 80 00 	mov    0x802e18(,%eax,4),%eax
  8009fc:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009fe:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a02:	eb d7                	jmp    8009db <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a04:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a08:	eb d1                	jmp    8009db <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a0a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a11:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a14:	89 d0                	mov    %edx,%eax
  800a16:	c1 e0 02             	shl    $0x2,%eax
  800a19:	01 d0                	add    %edx,%eax
  800a1b:	01 c0                	add    %eax,%eax
  800a1d:	01 d8                	add    %ebx,%eax
  800a1f:	83 e8 30             	sub    $0x30,%eax
  800a22:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a25:	8b 45 10             	mov    0x10(%ebp),%eax
  800a28:	8a 00                	mov    (%eax),%al
  800a2a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a2d:	83 fb 2f             	cmp    $0x2f,%ebx
  800a30:	7e 3e                	jle    800a70 <vprintfmt+0xe9>
  800a32:	83 fb 39             	cmp    $0x39,%ebx
  800a35:	7f 39                	jg     800a70 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a37:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a3a:	eb d5                	jmp    800a11 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3f:	83 c0 04             	add    $0x4,%eax
  800a42:	89 45 14             	mov    %eax,0x14(%ebp)
  800a45:	8b 45 14             	mov    0x14(%ebp),%eax
  800a48:	83 e8 04             	sub    $0x4,%eax
  800a4b:	8b 00                	mov    (%eax),%eax
  800a4d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a50:	eb 1f                	jmp    800a71 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a52:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a56:	79 83                	jns    8009db <vprintfmt+0x54>
				width = 0;
  800a58:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a5f:	e9 77 ff ff ff       	jmp    8009db <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a64:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a6b:	e9 6b ff ff ff       	jmp    8009db <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a70:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a71:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a75:	0f 89 60 ff ff ff    	jns    8009db <vprintfmt+0x54>
				width = precision, precision = -1;
  800a7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a7e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a81:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a88:	e9 4e ff ff ff       	jmp    8009db <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a8d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a90:	e9 46 ff ff ff       	jmp    8009db <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a95:	8b 45 14             	mov    0x14(%ebp),%eax
  800a98:	83 c0 04             	add    $0x4,%eax
  800a9b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa1:	83 e8 04             	sub    $0x4,%eax
  800aa4:	8b 00                	mov    (%eax),%eax
  800aa6:	83 ec 08             	sub    $0x8,%esp
  800aa9:	ff 75 0c             	pushl  0xc(%ebp)
  800aac:	50                   	push   %eax
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	ff d0                	call   *%eax
  800ab2:	83 c4 10             	add    $0x10,%esp
			break;
  800ab5:	e9 89 02 00 00       	jmp    800d43 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800aba:	8b 45 14             	mov    0x14(%ebp),%eax
  800abd:	83 c0 04             	add    $0x4,%eax
  800ac0:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac6:	83 e8 04             	sub    $0x4,%eax
  800ac9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800acb:	85 db                	test   %ebx,%ebx
  800acd:	79 02                	jns    800ad1 <vprintfmt+0x14a>
				err = -err;
  800acf:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ad1:	83 fb 64             	cmp    $0x64,%ebx
  800ad4:	7f 0b                	jg     800ae1 <vprintfmt+0x15a>
  800ad6:	8b 34 9d 60 2c 80 00 	mov    0x802c60(,%ebx,4),%esi
  800add:	85 f6                	test   %esi,%esi
  800adf:	75 19                	jne    800afa <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ae1:	53                   	push   %ebx
  800ae2:	68 05 2e 80 00       	push   $0x802e05
  800ae7:	ff 75 0c             	pushl  0xc(%ebp)
  800aea:	ff 75 08             	pushl  0x8(%ebp)
  800aed:	e8 5e 02 00 00       	call   800d50 <printfmt>
  800af2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800af5:	e9 49 02 00 00       	jmp    800d43 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800afa:	56                   	push   %esi
  800afb:	68 0e 2e 80 00       	push   $0x802e0e
  800b00:	ff 75 0c             	pushl  0xc(%ebp)
  800b03:	ff 75 08             	pushl  0x8(%ebp)
  800b06:	e8 45 02 00 00       	call   800d50 <printfmt>
  800b0b:	83 c4 10             	add    $0x10,%esp
			break;
  800b0e:	e9 30 02 00 00       	jmp    800d43 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b13:	8b 45 14             	mov    0x14(%ebp),%eax
  800b16:	83 c0 04             	add    $0x4,%eax
  800b19:	89 45 14             	mov    %eax,0x14(%ebp)
  800b1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1f:	83 e8 04             	sub    $0x4,%eax
  800b22:	8b 30                	mov    (%eax),%esi
  800b24:	85 f6                	test   %esi,%esi
  800b26:	75 05                	jne    800b2d <vprintfmt+0x1a6>
				p = "(null)";
  800b28:	be 11 2e 80 00       	mov    $0x802e11,%esi
			if (width > 0 && padc != '-')
  800b2d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b31:	7e 6d                	jle    800ba0 <vprintfmt+0x219>
  800b33:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b37:	74 67                	je     800ba0 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b39:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	50                   	push   %eax
  800b40:	56                   	push   %esi
  800b41:	e8 12 05 00 00       	call   801058 <strnlen>
  800b46:	83 c4 10             	add    $0x10,%esp
  800b49:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b4c:	eb 16                	jmp    800b64 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b4e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b52:	83 ec 08             	sub    $0x8,%esp
  800b55:	ff 75 0c             	pushl  0xc(%ebp)
  800b58:	50                   	push   %eax
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	ff d0                	call   *%eax
  800b5e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b61:	ff 4d e4             	decl   -0x1c(%ebp)
  800b64:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b68:	7f e4                	jg     800b4e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b6a:	eb 34                	jmp    800ba0 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b6c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b70:	74 1c                	je     800b8e <vprintfmt+0x207>
  800b72:	83 fb 1f             	cmp    $0x1f,%ebx
  800b75:	7e 05                	jle    800b7c <vprintfmt+0x1f5>
  800b77:	83 fb 7e             	cmp    $0x7e,%ebx
  800b7a:	7e 12                	jle    800b8e <vprintfmt+0x207>
					putch('?', putdat);
  800b7c:	83 ec 08             	sub    $0x8,%esp
  800b7f:	ff 75 0c             	pushl  0xc(%ebp)
  800b82:	6a 3f                	push   $0x3f
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	ff d0                	call   *%eax
  800b89:	83 c4 10             	add    $0x10,%esp
  800b8c:	eb 0f                	jmp    800b9d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b8e:	83 ec 08             	sub    $0x8,%esp
  800b91:	ff 75 0c             	pushl  0xc(%ebp)
  800b94:	53                   	push   %ebx
  800b95:	8b 45 08             	mov    0x8(%ebp),%eax
  800b98:	ff d0                	call   *%eax
  800b9a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b9d:	ff 4d e4             	decl   -0x1c(%ebp)
  800ba0:	89 f0                	mov    %esi,%eax
  800ba2:	8d 70 01             	lea    0x1(%eax),%esi
  800ba5:	8a 00                	mov    (%eax),%al
  800ba7:	0f be d8             	movsbl %al,%ebx
  800baa:	85 db                	test   %ebx,%ebx
  800bac:	74 24                	je     800bd2 <vprintfmt+0x24b>
  800bae:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bb2:	78 b8                	js     800b6c <vprintfmt+0x1e5>
  800bb4:	ff 4d e0             	decl   -0x20(%ebp)
  800bb7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bbb:	79 af                	jns    800b6c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bbd:	eb 13                	jmp    800bd2 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bbf:	83 ec 08             	sub    $0x8,%esp
  800bc2:	ff 75 0c             	pushl  0xc(%ebp)
  800bc5:	6a 20                	push   $0x20
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bca:	ff d0                	call   *%eax
  800bcc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bcf:	ff 4d e4             	decl   -0x1c(%ebp)
  800bd2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bd6:	7f e7                	jg     800bbf <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bd8:	e9 66 01 00 00       	jmp    800d43 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bdd:	83 ec 08             	sub    $0x8,%esp
  800be0:	ff 75 e8             	pushl  -0x18(%ebp)
  800be3:	8d 45 14             	lea    0x14(%ebp),%eax
  800be6:	50                   	push   %eax
  800be7:	e8 3c fd ff ff       	call   800928 <getint>
  800bec:	83 c4 10             	add    $0x10,%esp
  800bef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bfb:	85 d2                	test   %edx,%edx
  800bfd:	79 23                	jns    800c22 <vprintfmt+0x29b>
				putch('-', putdat);
  800bff:	83 ec 08             	sub    $0x8,%esp
  800c02:	ff 75 0c             	pushl  0xc(%ebp)
  800c05:	6a 2d                	push   $0x2d
  800c07:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0a:	ff d0                	call   *%eax
  800c0c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c15:	f7 d8                	neg    %eax
  800c17:	83 d2 00             	adc    $0x0,%edx
  800c1a:	f7 da                	neg    %edx
  800c1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c1f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c22:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c29:	e9 bc 00 00 00       	jmp    800cea <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c2e:	83 ec 08             	sub    $0x8,%esp
  800c31:	ff 75 e8             	pushl  -0x18(%ebp)
  800c34:	8d 45 14             	lea    0x14(%ebp),%eax
  800c37:	50                   	push   %eax
  800c38:	e8 84 fc ff ff       	call   8008c1 <getuint>
  800c3d:	83 c4 10             	add    $0x10,%esp
  800c40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c43:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c46:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c4d:	e9 98 00 00 00       	jmp    800cea <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c52:	83 ec 08             	sub    $0x8,%esp
  800c55:	ff 75 0c             	pushl  0xc(%ebp)
  800c58:	6a 58                	push   $0x58
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	ff d0                	call   *%eax
  800c5f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c62:	83 ec 08             	sub    $0x8,%esp
  800c65:	ff 75 0c             	pushl  0xc(%ebp)
  800c68:	6a 58                	push   $0x58
  800c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6d:	ff d0                	call   *%eax
  800c6f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c72:	83 ec 08             	sub    $0x8,%esp
  800c75:	ff 75 0c             	pushl  0xc(%ebp)
  800c78:	6a 58                	push   $0x58
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	ff d0                	call   *%eax
  800c7f:	83 c4 10             	add    $0x10,%esp
			break;
  800c82:	e9 bc 00 00 00       	jmp    800d43 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c87:	83 ec 08             	sub    $0x8,%esp
  800c8a:	ff 75 0c             	pushl  0xc(%ebp)
  800c8d:	6a 30                	push   $0x30
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	ff d0                	call   *%eax
  800c94:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c97:	83 ec 08             	sub    $0x8,%esp
  800c9a:	ff 75 0c             	pushl  0xc(%ebp)
  800c9d:	6a 78                	push   $0x78
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	ff d0                	call   *%eax
  800ca4:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ca7:	8b 45 14             	mov    0x14(%ebp),%eax
  800caa:	83 c0 04             	add    $0x4,%eax
  800cad:	89 45 14             	mov    %eax,0x14(%ebp)
  800cb0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb3:	83 e8 04             	sub    $0x4,%eax
  800cb6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cc2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cc9:	eb 1f                	jmp    800cea <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ccb:	83 ec 08             	sub    $0x8,%esp
  800cce:	ff 75 e8             	pushl  -0x18(%ebp)
  800cd1:	8d 45 14             	lea    0x14(%ebp),%eax
  800cd4:	50                   	push   %eax
  800cd5:	e8 e7 fb ff ff       	call   8008c1 <getuint>
  800cda:	83 c4 10             	add    $0x10,%esp
  800cdd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ce3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cea:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cf1:	83 ec 04             	sub    $0x4,%esp
  800cf4:	52                   	push   %edx
  800cf5:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cf8:	50                   	push   %eax
  800cf9:	ff 75 f4             	pushl  -0xc(%ebp)
  800cfc:	ff 75 f0             	pushl  -0x10(%ebp)
  800cff:	ff 75 0c             	pushl  0xc(%ebp)
  800d02:	ff 75 08             	pushl  0x8(%ebp)
  800d05:	e8 00 fb ff ff       	call   80080a <printnum>
  800d0a:	83 c4 20             	add    $0x20,%esp
			break;
  800d0d:	eb 34                	jmp    800d43 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d0f:	83 ec 08             	sub    $0x8,%esp
  800d12:	ff 75 0c             	pushl  0xc(%ebp)
  800d15:	53                   	push   %ebx
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	ff d0                	call   *%eax
  800d1b:	83 c4 10             	add    $0x10,%esp
			break;
  800d1e:	eb 23                	jmp    800d43 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d20:	83 ec 08             	sub    $0x8,%esp
  800d23:	ff 75 0c             	pushl  0xc(%ebp)
  800d26:	6a 25                	push   $0x25
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	ff d0                	call   *%eax
  800d2d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d30:	ff 4d 10             	decl   0x10(%ebp)
  800d33:	eb 03                	jmp    800d38 <vprintfmt+0x3b1>
  800d35:	ff 4d 10             	decl   0x10(%ebp)
  800d38:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3b:	48                   	dec    %eax
  800d3c:	8a 00                	mov    (%eax),%al
  800d3e:	3c 25                	cmp    $0x25,%al
  800d40:	75 f3                	jne    800d35 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d42:	90                   	nop
		}
	}
  800d43:	e9 47 fc ff ff       	jmp    80098f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d48:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d49:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d4c:	5b                   	pop    %ebx
  800d4d:	5e                   	pop    %esi
  800d4e:	5d                   	pop    %ebp
  800d4f:	c3                   	ret    

00800d50 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d56:	8d 45 10             	lea    0x10(%ebp),%eax
  800d59:	83 c0 04             	add    $0x4,%eax
  800d5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d62:	ff 75 f4             	pushl  -0xc(%ebp)
  800d65:	50                   	push   %eax
  800d66:	ff 75 0c             	pushl  0xc(%ebp)
  800d69:	ff 75 08             	pushl  0x8(%ebp)
  800d6c:	e8 16 fc ff ff       	call   800987 <vprintfmt>
  800d71:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d74:	90                   	nop
  800d75:	c9                   	leave  
  800d76:	c3                   	ret    

00800d77 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7d:	8b 40 08             	mov    0x8(%eax),%eax
  800d80:	8d 50 01             	lea    0x1(%eax),%edx
  800d83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d86:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8c:	8b 10                	mov    (%eax),%edx
  800d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d91:	8b 40 04             	mov    0x4(%eax),%eax
  800d94:	39 c2                	cmp    %eax,%edx
  800d96:	73 12                	jae    800daa <sprintputch+0x33>
		*b->buf++ = ch;
  800d98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9b:	8b 00                	mov    (%eax),%eax
  800d9d:	8d 48 01             	lea    0x1(%eax),%ecx
  800da0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da3:	89 0a                	mov    %ecx,(%edx)
  800da5:	8b 55 08             	mov    0x8(%ebp),%edx
  800da8:	88 10                	mov    %dl,(%eax)
}
  800daa:	90                   	nop
  800dab:	5d                   	pop    %ebp
  800dac:	c3                   	ret    

00800dad <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
  800db0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800db9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	01 d0                	add    %edx,%eax
  800dc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dd2:	74 06                	je     800dda <vsnprintf+0x2d>
  800dd4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd8:	7f 07                	jg     800de1 <vsnprintf+0x34>
		return -E_INVAL;
  800dda:	b8 03 00 00 00       	mov    $0x3,%eax
  800ddf:	eb 20                	jmp    800e01 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800de1:	ff 75 14             	pushl  0x14(%ebp)
  800de4:	ff 75 10             	pushl  0x10(%ebp)
  800de7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dea:	50                   	push   %eax
  800deb:	68 77 0d 80 00       	push   $0x800d77
  800df0:	e8 92 fb ff ff       	call   800987 <vprintfmt>
  800df5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800df8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dfb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e01:	c9                   	leave  
  800e02:	c3                   	ret    

00800e03 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e03:	55                   	push   %ebp
  800e04:	89 e5                	mov    %esp,%ebp
  800e06:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e09:	8d 45 10             	lea    0x10(%ebp),%eax
  800e0c:	83 c0 04             	add    $0x4,%eax
  800e0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e12:	8b 45 10             	mov    0x10(%ebp),%eax
  800e15:	ff 75 f4             	pushl  -0xc(%ebp)
  800e18:	50                   	push   %eax
  800e19:	ff 75 0c             	pushl  0xc(%ebp)
  800e1c:	ff 75 08             	pushl  0x8(%ebp)
  800e1f:	e8 89 ff ff ff       	call   800dad <vsnprintf>
  800e24:	83 c4 10             	add    $0x10,%esp
  800e27:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e2d:	c9                   	leave  
  800e2e:	c3                   	ret    

00800e2f <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  800e35:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e39:	74 13                	je     800e4e <readline+0x1f>
		cprintf("%s", prompt);
  800e3b:	83 ec 08             	sub    $0x8,%esp
  800e3e:	ff 75 08             	pushl  0x8(%ebp)
  800e41:	68 70 2f 80 00       	push   $0x802f70
  800e46:	e8 69 f9 ff ff       	call   8007b4 <cprintf>
  800e4b:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800e4e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800e55:	83 ec 0c             	sub    $0xc,%esp
  800e58:	6a 00                	push   $0x0
  800e5a:	e8 5f f7 ff ff       	call   8005be <iscons>
  800e5f:	83 c4 10             	add    $0x10,%esp
  800e62:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800e65:	e8 06 f7 ff ff       	call   800570 <getchar>
  800e6a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800e6d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e71:	79 22                	jns    800e95 <readline+0x66>
			if (c != -E_EOF)
  800e73:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800e77:	0f 84 ad 00 00 00    	je     800f2a <readline+0xfb>
				cprintf("read error: %e\n", c);
  800e7d:	83 ec 08             	sub    $0x8,%esp
  800e80:	ff 75 ec             	pushl  -0x14(%ebp)
  800e83:	68 73 2f 80 00       	push   $0x802f73
  800e88:	e8 27 f9 ff ff       	call   8007b4 <cprintf>
  800e8d:	83 c4 10             	add    $0x10,%esp
			return;
  800e90:	e9 95 00 00 00       	jmp    800f2a <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800e95:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800e99:	7e 34                	jle    800ecf <readline+0xa0>
  800e9b:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800ea2:	7f 2b                	jg     800ecf <readline+0xa0>
			if (echoing)
  800ea4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ea8:	74 0e                	je     800eb8 <readline+0x89>
				cputchar(c);
  800eaa:	83 ec 0c             	sub    $0xc,%esp
  800ead:	ff 75 ec             	pushl  -0x14(%ebp)
  800eb0:	e8 73 f6 ff ff       	call   800528 <cputchar>
  800eb5:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ebb:	8d 50 01             	lea    0x1(%eax),%edx
  800ebe:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800ec1:	89 c2                	mov    %eax,%edx
  800ec3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec6:	01 d0                	add    %edx,%eax
  800ec8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ecb:	88 10                	mov    %dl,(%eax)
  800ecd:	eb 56                	jmp    800f25 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800ecf:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800ed3:	75 1f                	jne    800ef4 <readline+0xc5>
  800ed5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800ed9:	7e 19                	jle    800ef4 <readline+0xc5>
			if (echoing)
  800edb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800edf:	74 0e                	je     800eef <readline+0xc0>
				cputchar(c);
  800ee1:	83 ec 0c             	sub    $0xc,%esp
  800ee4:	ff 75 ec             	pushl  -0x14(%ebp)
  800ee7:	e8 3c f6 ff ff       	call   800528 <cputchar>
  800eec:	83 c4 10             	add    $0x10,%esp

			i--;
  800eef:	ff 4d f4             	decl   -0xc(%ebp)
  800ef2:	eb 31                	jmp    800f25 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800ef4:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800ef8:	74 0a                	je     800f04 <readline+0xd5>
  800efa:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800efe:	0f 85 61 ff ff ff    	jne    800e65 <readline+0x36>
			if (echoing)
  800f04:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f08:	74 0e                	je     800f18 <readline+0xe9>
				cputchar(c);
  800f0a:	83 ec 0c             	sub    $0xc,%esp
  800f0d:	ff 75 ec             	pushl  -0x14(%ebp)
  800f10:	e8 13 f6 ff ff       	call   800528 <cputchar>
  800f15:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800f18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1e:	01 d0                	add    %edx,%eax
  800f20:	c6 00 00             	movb   $0x0,(%eax)
			return;
  800f23:	eb 06                	jmp    800f2b <readline+0xfc>
		}
	}
  800f25:	e9 3b ff ff ff       	jmp    800e65 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  800f2a:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  800f2b:	c9                   	leave  
  800f2c:	c3                   	ret    

00800f2d <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800f2d:	55                   	push   %ebp
  800f2e:	89 e5                	mov    %esp,%ebp
  800f30:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f33:	e8 71 14 00 00       	call   8023a9 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  800f38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f3c:	74 13                	je     800f51 <atomic_readline+0x24>
		cprintf("%s", prompt);
  800f3e:	83 ec 08             	sub    $0x8,%esp
  800f41:	ff 75 08             	pushl  0x8(%ebp)
  800f44:	68 70 2f 80 00       	push   $0x802f70
  800f49:	e8 66 f8 ff ff       	call   8007b4 <cprintf>
  800f4e:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800f51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800f58:	83 ec 0c             	sub    $0xc,%esp
  800f5b:	6a 00                	push   $0x0
  800f5d:	e8 5c f6 ff ff       	call   8005be <iscons>
  800f62:	83 c4 10             	add    $0x10,%esp
  800f65:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800f68:	e8 03 f6 ff ff       	call   800570 <getchar>
  800f6d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800f70:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800f74:	79 23                	jns    800f99 <atomic_readline+0x6c>
			if (c != -E_EOF)
  800f76:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800f7a:	74 13                	je     800f8f <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  800f7c:	83 ec 08             	sub    $0x8,%esp
  800f7f:	ff 75 ec             	pushl  -0x14(%ebp)
  800f82:	68 73 2f 80 00       	push   $0x802f73
  800f87:	e8 28 f8 ff ff       	call   8007b4 <cprintf>
  800f8c:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800f8f:	e8 2f 14 00 00       	call   8023c3 <sys_enable_interrupt>
			return;
  800f94:	e9 9a 00 00 00       	jmp    801033 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800f99:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800f9d:	7e 34                	jle    800fd3 <atomic_readline+0xa6>
  800f9f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800fa6:	7f 2b                	jg     800fd3 <atomic_readline+0xa6>
			if (echoing)
  800fa8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fac:	74 0e                	je     800fbc <atomic_readline+0x8f>
				cputchar(c);
  800fae:	83 ec 0c             	sub    $0xc,%esp
  800fb1:	ff 75 ec             	pushl  -0x14(%ebp)
  800fb4:	e8 6f f5 ff ff       	call   800528 <cputchar>
  800fb9:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fbf:	8d 50 01             	lea    0x1(%eax),%edx
  800fc2:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800fc5:	89 c2                	mov    %eax,%edx
  800fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fca:	01 d0                	add    %edx,%eax
  800fcc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fcf:	88 10                	mov    %dl,(%eax)
  800fd1:	eb 5b                	jmp    80102e <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  800fd3:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800fd7:	75 1f                	jne    800ff8 <atomic_readline+0xcb>
  800fd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800fdd:	7e 19                	jle    800ff8 <atomic_readline+0xcb>
			if (echoing)
  800fdf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fe3:	74 0e                	je     800ff3 <atomic_readline+0xc6>
				cputchar(c);
  800fe5:	83 ec 0c             	sub    $0xc,%esp
  800fe8:	ff 75 ec             	pushl  -0x14(%ebp)
  800feb:	e8 38 f5 ff ff       	call   800528 <cputchar>
  800ff0:	83 c4 10             	add    $0x10,%esp
			i--;
  800ff3:	ff 4d f4             	decl   -0xc(%ebp)
  800ff6:	eb 36                	jmp    80102e <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  800ff8:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800ffc:	74 0a                	je     801008 <atomic_readline+0xdb>
  800ffe:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801002:	0f 85 60 ff ff ff    	jne    800f68 <atomic_readline+0x3b>
			if (echoing)
  801008:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80100c:	74 0e                	je     80101c <atomic_readline+0xef>
				cputchar(c);
  80100e:	83 ec 0c             	sub    $0xc,%esp
  801011:	ff 75 ec             	pushl  -0x14(%ebp)
  801014:	e8 0f f5 ff ff       	call   800528 <cputchar>
  801019:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  80101c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80101f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801022:	01 d0                	add    %edx,%eax
  801024:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  801027:	e8 97 13 00 00       	call   8023c3 <sys_enable_interrupt>
			return;
  80102c:	eb 05                	jmp    801033 <atomic_readline+0x106>
		}
	}
  80102e:	e9 35 ff ff ff       	jmp    800f68 <atomic_readline+0x3b>
}
  801033:	c9                   	leave  
  801034:	c3                   	ret    

00801035 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801035:	55                   	push   %ebp
  801036:	89 e5                	mov    %esp,%ebp
  801038:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80103b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801042:	eb 06                	jmp    80104a <strlen+0x15>
		n++;
  801044:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801047:	ff 45 08             	incl   0x8(%ebp)
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
  80104d:	8a 00                	mov    (%eax),%al
  80104f:	84 c0                	test   %al,%al
  801051:	75 f1                	jne    801044 <strlen+0xf>
		n++;
	return n;
  801053:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801056:	c9                   	leave  
  801057:	c3                   	ret    

00801058 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801058:	55                   	push   %ebp
  801059:	89 e5                	mov    %esp,%ebp
  80105b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80105e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801065:	eb 09                	jmp    801070 <strnlen+0x18>
		n++;
  801067:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80106a:	ff 45 08             	incl   0x8(%ebp)
  80106d:	ff 4d 0c             	decl   0xc(%ebp)
  801070:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801074:	74 09                	je     80107f <strnlen+0x27>
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	8a 00                	mov    (%eax),%al
  80107b:	84 c0                	test   %al,%al
  80107d:	75 e8                	jne    801067 <strnlen+0xf>
		n++;
	return n;
  80107f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801082:	c9                   	leave  
  801083:	c3                   	ret    

00801084 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801084:	55                   	push   %ebp
  801085:	89 e5                	mov    %esp,%ebp
  801087:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80108a:	8b 45 08             	mov    0x8(%ebp),%eax
  80108d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801090:	90                   	nop
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
  801094:	8d 50 01             	lea    0x1(%eax),%edx
  801097:	89 55 08             	mov    %edx,0x8(%ebp)
  80109a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80109d:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010a0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010a3:	8a 12                	mov    (%edx),%dl
  8010a5:	88 10                	mov    %dl,(%eax)
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	84 c0                	test   %al,%al
  8010ab:	75 e4                	jne    801091 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010b0:	c9                   	leave  
  8010b1:	c3                   	ret    

008010b2 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010b2:	55                   	push   %ebp
  8010b3:	89 e5                	mov    %esp,%ebp
  8010b5:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010c5:	eb 1f                	jmp    8010e6 <strncpy+0x34>
		*dst++ = *src;
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	8d 50 01             	lea    0x1(%eax),%edx
  8010cd:	89 55 08             	mov    %edx,0x8(%ebp)
  8010d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d3:	8a 12                	mov    (%edx),%dl
  8010d5:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010da:	8a 00                	mov    (%eax),%al
  8010dc:	84 c0                	test   %al,%al
  8010de:	74 03                	je     8010e3 <strncpy+0x31>
			src++;
  8010e0:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010e3:	ff 45 fc             	incl   -0x4(%ebp)
  8010e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010ec:	72 d9                	jb     8010c7 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010f1:	c9                   	leave  
  8010f2:	c3                   	ret    

008010f3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010f3:	55                   	push   %ebp
  8010f4:	89 e5                	mov    %esp,%ebp
  8010f6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801103:	74 30                	je     801135 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801105:	eb 16                	jmp    80111d <strlcpy+0x2a>
			*dst++ = *src++;
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	8d 50 01             	lea    0x1(%eax),%edx
  80110d:	89 55 08             	mov    %edx,0x8(%ebp)
  801110:	8b 55 0c             	mov    0xc(%ebp),%edx
  801113:	8d 4a 01             	lea    0x1(%edx),%ecx
  801116:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801119:	8a 12                	mov    (%edx),%dl
  80111b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80111d:	ff 4d 10             	decl   0x10(%ebp)
  801120:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801124:	74 09                	je     80112f <strlcpy+0x3c>
  801126:	8b 45 0c             	mov    0xc(%ebp),%eax
  801129:	8a 00                	mov    (%eax),%al
  80112b:	84 c0                	test   %al,%al
  80112d:	75 d8                	jne    801107 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80112f:	8b 45 08             	mov    0x8(%ebp),%eax
  801132:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801135:	8b 55 08             	mov    0x8(%ebp),%edx
  801138:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80113b:	29 c2                	sub    %eax,%edx
  80113d:	89 d0                	mov    %edx,%eax
}
  80113f:	c9                   	leave  
  801140:	c3                   	ret    

00801141 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801144:	eb 06                	jmp    80114c <strcmp+0xb>
		p++, q++;
  801146:	ff 45 08             	incl   0x8(%ebp)
  801149:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	84 c0                	test   %al,%al
  801153:	74 0e                	je     801163 <strcmp+0x22>
  801155:	8b 45 08             	mov    0x8(%ebp),%eax
  801158:	8a 10                	mov    (%eax),%dl
  80115a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	38 c2                	cmp    %al,%dl
  801161:	74 e3                	je     801146 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	8a 00                	mov    (%eax),%al
  801168:	0f b6 d0             	movzbl %al,%edx
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	8a 00                	mov    (%eax),%al
  801170:	0f b6 c0             	movzbl %al,%eax
  801173:	29 c2                	sub    %eax,%edx
  801175:	89 d0                	mov    %edx,%eax
}
  801177:	5d                   	pop    %ebp
  801178:	c3                   	ret    

00801179 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801179:	55                   	push   %ebp
  80117a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80117c:	eb 09                	jmp    801187 <strncmp+0xe>
		n--, p++, q++;
  80117e:	ff 4d 10             	decl   0x10(%ebp)
  801181:	ff 45 08             	incl   0x8(%ebp)
  801184:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801187:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80118b:	74 17                	je     8011a4 <strncmp+0x2b>
  80118d:	8b 45 08             	mov    0x8(%ebp),%eax
  801190:	8a 00                	mov    (%eax),%al
  801192:	84 c0                	test   %al,%al
  801194:	74 0e                	je     8011a4 <strncmp+0x2b>
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	8a 10                	mov    (%eax),%dl
  80119b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119e:	8a 00                	mov    (%eax),%al
  8011a0:	38 c2                	cmp    %al,%dl
  8011a2:	74 da                	je     80117e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011a8:	75 07                	jne    8011b1 <strncmp+0x38>
		return 0;
  8011aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8011af:	eb 14                	jmp    8011c5 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b4:	8a 00                	mov    (%eax),%al
  8011b6:	0f b6 d0             	movzbl %al,%edx
  8011b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	0f b6 c0             	movzbl %al,%eax
  8011c1:	29 c2                	sub    %eax,%edx
  8011c3:	89 d0                	mov    %edx,%eax
}
  8011c5:	5d                   	pop    %ebp
  8011c6:	c3                   	ret    

008011c7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
  8011ca:	83 ec 04             	sub    $0x4,%esp
  8011cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011d3:	eb 12                	jmp    8011e7 <strchr+0x20>
		if (*s == c)
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d8:	8a 00                	mov    (%eax),%al
  8011da:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011dd:	75 05                	jne    8011e4 <strchr+0x1d>
			return (char *) s;
  8011df:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e2:	eb 11                	jmp    8011f5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011e4:	ff 45 08             	incl   0x8(%ebp)
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	84 c0                	test   %al,%al
  8011ee:	75 e5                	jne    8011d5 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011f5:	c9                   	leave  
  8011f6:	c3                   	ret    

008011f7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011f7:	55                   	push   %ebp
  8011f8:	89 e5                	mov    %esp,%ebp
  8011fa:	83 ec 04             	sub    $0x4,%esp
  8011fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801200:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801203:	eb 0d                	jmp    801212 <strfind+0x1b>
		if (*s == c)
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
  801208:	8a 00                	mov    (%eax),%al
  80120a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80120d:	74 0e                	je     80121d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80120f:	ff 45 08             	incl   0x8(%ebp)
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	84 c0                	test   %al,%al
  801219:	75 ea                	jne    801205 <strfind+0xe>
  80121b:	eb 01                	jmp    80121e <strfind+0x27>
		if (*s == c)
			break;
  80121d:	90                   	nop
	return (char *) s;
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801221:	c9                   	leave  
  801222:	c3                   	ret    

00801223 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801223:	55                   	push   %ebp
  801224:	89 e5                	mov    %esp,%ebp
  801226:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801229:	8b 45 08             	mov    0x8(%ebp),%eax
  80122c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80122f:	8b 45 10             	mov    0x10(%ebp),%eax
  801232:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801235:	eb 0e                	jmp    801245 <memset+0x22>
		*p++ = c;
  801237:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80123a:	8d 50 01             	lea    0x1(%eax),%edx
  80123d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801240:	8b 55 0c             	mov    0xc(%ebp),%edx
  801243:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801245:	ff 4d f8             	decl   -0x8(%ebp)
  801248:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80124c:	79 e9                	jns    801237 <memset+0x14>
		*p++ = c;

	return v;
  80124e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801251:	c9                   	leave  
  801252:	c3                   	ret    

00801253 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801253:	55                   	push   %ebp
  801254:	89 e5                	mov    %esp,%ebp
  801256:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801259:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80125f:	8b 45 08             	mov    0x8(%ebp),%eax
  801262:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801265:	eb 16                	jmp    80127d <memcpy+0x2a>
		*d++ = *s++;
  801267:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126a:	8d 50 01             	lea    0x1(%eax),%edx
  80126d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801270:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801273:	8d 4a 01             	lea    0x1(%edx),%ecx
  801276:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801279:	8a 12                	mov    (%edx),%dl
  80127b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80127d:	8b 45 10             	mov    0x10(%ebp),%eax
  801280:	8d 50 ff             	lea    -0x1(%eax),%edx
  801283:	89 55 10             	mov    %edx,0x10(%ebp)
  801286:	85 c0                	test   %eax,%eax
  801288:	75 dd                	jne    801267 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80128a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80128d:	c9                   	leave  
  80128e:	c3                   	ret    

0080128f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
  801292:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  801295:	8b 45 0c             	mov    0xc(%ebp),%eax
  801298:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012a7:	73 50                	jae    8012f9 <memmove+0x6a>
  8012a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8012af:	01 d0                	add    %edx,%eax
  8012b1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012b4:	76 43                	jbe    8012f9 <memmove+0x6a>
		s += n;
  8012b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b9:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8012bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bf:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012c2:	eb 10                	jmp    8012d4 <memmove+0x45>
			*--d = *--s;
  8012c4:	ff 4d f8             	decl   -0x8(%ebp)
  8012c7:	ff 4d fc             	decl   -0x4(%ebp)
  8012ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012cd:	8a 10                	mov    (%eax),%dl
  8012cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012da:	89 55 10             	mov    %edx,0x10(%ebp)
  8012dd:	85 c0                	test   %eax,%eax
  8012df:	75 e3                	jne    8012c4 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012e1:	eb 23                	jmp    801306 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e6:	8d 50 01             	lea    0x1(%eax),%edx
  8012e9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ef:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012f2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012f5:	8a 12                	mov    (%edx),%dl
  8012f7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012fc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012ff:	89 55 10             	mov    %edx,0x10(%ebp)
  801302:	85 c0                	test   %eax,%eax
  801304:	75 dd                	jne    8012e3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801311:	8b 45 08             	mov    0x8(%ebp),%eax
  801314:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801317:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80131d:	eb 2a                	jmp    801349 <memcmp+0x3e>
		if (*s1 != *s2)
  80131f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801322:	8a 10                	mov    (%eax),%dl
  801324:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801327:	8a 00                	mov    (%eax),%al
  801329:	38 c2                	cmp    %al,%dl
  80132b:	74 16                	je     801343 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80132d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801330:	8a 00                	mov    (%eax),%al
  801332:	0f b6 d0             	movzbl %al,%edx
  801335:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801338:	8a 00                	mov    (%eax),%al
  80133a:	0f b6 c0             	movzbl %al,%eax
  80133d:	29 c2                	sub    %eax,%edx
  80133f:	89 d0                	mov    %edx,%eax
  801341:	eb 18                	jmp    80135b <memcmp+0x50>
		s1++, s2++;
  801343:	ff 45 fc             	incl   -0x4(%ebp)
  801346:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801349:	8b 45 10             	mov    0x10(%ebp),%eax
  80134c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80134f:	89 55 10             	mov    %edx,0x10(%ebp)
  801352:	85 c0                	test   %eax,%eax
  801354:	75 c9                	jne    80131f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801356:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80135b:	c9                   	leave  
  80135c:	c3                   	ret    

0080135d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801363:	8b 55 08             	mov    0x8(%ebp),%edx
  801366:	8b 45 10             	mov    0x10(%ebp),%eax
  801369:	01 d0                	add    %edx,%eax
  80136b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80136e:	eb 15                	jmp    801385 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	8a 00                	mov    (%eax),%al
  801375:	0f b6 d0             	movzbl %al,%edx
  801378:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137b:	0f b6 c0             	movzbl %al,%eax
  80137e:	39 c2                	cmp    %eax,%edx
  801380:	74 0d                	je     80138f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801382:	ff 45 08             	incl   0x8(%ebp)
  801385:	8b 45 08             	mov    0x8(%ebp),%eax
  801388:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80138b:	72 e3                	jb     801370 <memfind+0x13>
  80138d:	eb 01                	jmp    801390 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80138f:	90                   	nop
	return (void *) s;
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801393:	c9                   	leave  
  801394:	c3                   	ret    

00801395 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
  801398:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80139b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013a2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013a9:	eb 03                	jmp    8013ae <strtol+0x19>
		s++;
  8013ab:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b1:	8a 00                	mov    (%eax),%al
  8013b3:	3c 20                	cmp    $0x20,%al
  8013b5:	74 f4                	je     8013ab <strtol+0x16>
  8013b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ba:	8a 00                	mov    (%eax),%al
  8013bc:	3c 09                	cmp    $0x9,%al
  8013be:	74 eb                	je     8013ab <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c3:	8a 00                	mov    (%eax),%al
  8013c5:	3c 2b                	cmp    $0x2b,%al
  8013c7:	75 05                	jne    8013ce <strtol+0x39>
		s++;
  8013c9:	ff 45 08             	incl   0x8(%ebp)
  8013cc:	eb 13                	jmp    8013e1 <strtol+0x4c>
	else if (*s == '-')
  8013ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d1:	8a 00                	mov    (%eax),%al
  8013d3:	3c 2d                	cmp    $0x2d,%al
  8013d5:	75 0a                	jne    8013e1 <strtol+0x4c>
		s++, neg = 1;
  8013d7:	ff 45 08             	incl   0x8(%ebp)
  8013da:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e5:	74 06                	je     8013ed <strtol+0x58>
  8013e7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013eb:	75 20                	jne    80140d <strtol+0x78>
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	8a 00                	mov    (%eax),%al
  8013f2:	3c 30                	cmp    $0x30,%al
  8013f4:	75 17                	jne    80140d <strtol+0x78>
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	40                   	inc    %eax
  8013fa:	8a 00                	mov    (%eax),%al
  8013fc:	3c 78                	cmp    $0x78,%al
  8013fe:	75 0d                	jne    80140d <strtol+0x78>
		s += 2, base = 16;
  801400:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801404:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80140b:	eb 28                	jmp    801435 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80140d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801411:	75 15                	jne    801428 <strtol+0x93>
  801413:	8b 45 08             	mov    0x8(%ebp),%eax
  801416:	8a 00                	mov    (%eax),%al
  801418:	3c 30                	cmp    $0x30,%al
  80141a:	75 0c                	jne    801428 <strtol+0x93>
		s++, base = 8;
  80141c:	ff 45 08             	incl   0x8(%ebp)
  80141f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801426:	eb 0d                	jmp    801435 <strtol+0xa0>
	else if (base == 0)
  801428:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80142c:	75 07                	jne    801435 <strtol+0xa0>
		base = 10;
  80142e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801435:	8b 45 08             	mov    0x8(%ebp),%eax
  801438:	8a 00                	mov    (%eax),%al
  80143a:	3c 2f                	cmp    $0x2f,%al
  80143c:	7e 19                	jle    801457 <strtol+0xc2>
  80143e:	8b 45 08             	mov    0x8(%ebp),%eax
  801441:	8a 00                	mov    (%eax),%al
  801443:	3c 39                	cmp    $0x39,%al
  801445:	7f 10                	jg     801457 <strtol+0xc2>
			dig = *s - '0';
  801447:	8b 45 08             	mov    0x8(%ebp),%eax
  80144a:	8a 00                	mov    (%eax),%al
  80144c:	0f be c0             	movsbl %al,%eax
  80144f:	83 e8 30             	sub    $0x30,%eax
  801452:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801455:	eb 42                	jmp    801499 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801457:	8b 45 08             	mov    0x8(%ebp),%eax
  80145a:	8a 00                	mov    (%eax),%al
  80145c:	3c 60                	cmp    $0x60,%al
  80145e:	7e 19                	jle    801479 <strtol+0xe4>
  801460:	8b 45 08             	mov    0x8(%ebp),%eax
  801463:	8a 00                	mov    (%eax),%al
  801465:	3c 7a                	cmp    $0x7a,%al
  801467:	7f 10                	jg     801479 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801469:	8b 45 08             	mov    0x8(%ebp),%eax
  80146c:	8a 00                	mov    (%eax),%al
  80146e:	0f be c0             	movsbl %al,%eax
  801471:	83 e8 57             	sub    $0x57,%eax
  801474:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801477:	eb 20                	jmp    801499 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801479:	8b 45 08             	mov    0x8(%ebp),%eax
  80147c:	8a 00                	mov    (%eax),%al
  80147e:	3c 40                	cmp    $0x40,%al
  801480:	7e 39                	jle    8014bb <strtol+0x126>
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	8a 00                	mov    (%eax),%al
  801487:	3c 5a                	cmp    $0x5a,%al
  801489:	7f 30                	jg     8014bb <strtol+0x126>
			dig = *s - 'A' + 10;
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	0f be c0             	movsbl %al,%eax
  801493:	83 e8 37             	sub    $0x37,%eax
  801496:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80149c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80149f:	7d 19                	jge    8014ba <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014a1:	ff 45 08             	incl   0x8(%ebp)
  8014a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014a7:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014ab:	89 c2                	mov    %eax,%edx
  8014ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b0:	01 d0                	add    %edx,%eax
  8014b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8014b5:	e9 7b ff ff ff       	jmp    801435 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014ba:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014bf:	74 08                	je     8014c9 <strtol+0x134>
		*endptr = (char *) s;
  8014c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8014c7:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014cd:	74 07                	je     8014d6 <strtol+0x141>
  8014cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014d2:	f7 d8                	neg    %eax
  8014d4:	eb 03                	jmp    8014d9 <strtol+0x144>
  8014d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014d9:	c9                   	leave  
  8014da:	c3                   	ret    

008014db <ltostr>:

void
ltostr(long value, char *str)
{
  8014db:	55                   	push   %ebp
  8014dc:	89 e5                	mov    %esp,%ebp
  8014de:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014e8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014f3:	79 13                	jns    801508 <ltostr+0x2d>
	{
		neg = 1;
  8014f5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ff:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801502:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801505:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801508:	8b 45 08             	mov    0x8(%ebp),%eax
  80150b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801510:	99                   	cltd   
  801511:	f7 f9                	idiv   %ecx
  801513:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801516:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801519:	8d 50 01             	lea    0x1(%eax),%edx
  80151c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80151f:	89 c2                	mov    %eax,%edx
  801521:	8b 45 0c             	mov    0xc(%ebp),%eax
  801524:	01 d0                	add    %edx,%eax
  801526:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801529:	83 c2 30             	add    $0x30,%edx
  80152c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80152e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801531:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801536:	f7 e9                	imul   %ecx
  801538:	c1 fa 02             	sar    $0x2,%edx
  80153b:	89 c8                	mov    %ecx,%eax
  80153d:	c1 f8 1f             	sar    $0x1f,%eax
  801540:	29 c2                	sub    %eax,%edx
  801542:	89 d0                	mov    %edx,%eax
  801544:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801547:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80154a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80154f:	f7 e9                	imul   %ecx
  801551:	c1 fa 02             	sar    $0x2,%edx
  801554:	89 c8                	mov    %ecx,%eax
  801556:	c1 f8 1f             	sar    $0x1f,%eax
  801559:	29 c2                	sub    %eax,%edx
  80155b:	89 d0                	mov    %edx,%eax
  80155d:	c1 e0 02             	shl    $0x2,%eax
  801560:	01 d0                	add    %edx,%eax
  801562:	01 c0                	add    %eax,%eax
  801564:	29 c1                	sub    %eax,%ecx
  801566:	89 ca                	mov    %ecx,%edx
  801568:	85 d2                	test   %edx,%edx
  80156a:	75 9c                	jne    801508 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80156c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801573:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801576:	48                   	dec    %eax
  801577:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80157a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80157e:	74 3d                	je     8015bd <ltostr+0xe2>
		start = 1 ;
  801580:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801587:	eb 34                	jmp    8015bd <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801589:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80158c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158f:	01 d0                	add    %edx,%eax
  801591:	8a 00                	mov    (%eax),%al
  801593:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801596:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801599:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159c:	01 c2                	add    %eax,%edx
  80159e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a4:	01 c8                	add    %ecx,%eax
  8015a6:	8a 00                	mov    (%eax),%al
  8015a8:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b0:	01 c2                	add    %eax,%edx
  8015b2:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015b5:	88 02                	mov    %al,(%edx)
		start++ ;
  8015b7:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015ba:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015c3:	7c c4                	jl     801589 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015c5:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cb:	01 d0                	add    %edx,%eax
  8015cd:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015d0:	90                   	nop
  8015d1:	c9                   	leave  
  8015d2:	c3                   	ret    

008015d3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
  8015d6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015d9:	ff 75 08             	pushl  0x8(%ebp)
  8015dc:	e8 54 fa ff ff       	call   801035 <strlen>
  8015e1:	83 c4 04             	add    $0x4,%esp
  8015e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015e7:	ff 75 0c             	pushl  0xc(%ebp)
  8015ea:	e8 46 fa ff ff       	call   801035 <strlen>
  8015ef:	83 c4 04             	add    $0x4,%esp
  8015f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801603:	eb 17                	jmp    80161c <strcconcat+0x49>
		final[s] = str1[s] ;
  801605:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801608:	8b 45 10             	mov    0x10(%ebp),%eax
  80160b:	01 c2                	add    %eax,%edx
  80160d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801610:	8b 45 08             	mov    0x8(%ebp),%eax
  801613:	01 c8                	add    %ecx,%eax
  801615:	8a 00                	mov    (%eax),%al
  801617:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801619:	ff 45 fc             	incl   -0x4(%ebp)
  80161c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80161f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801622:	7c e1                	jl     801605 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801624:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80162b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801632:	eb 1f                	jmp    801653 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801634:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801637:	8d 50 01             	lea    0x1(%eax),%edx
  80163a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80163d:	89 c2                	mov    %eax,%edx
  80163f:	8b 45 10             	mov    0x10(%ebp),%eax
  801642:	01 c2                	add    %eax,%edx
  801644:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801647:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164a:	01 c8                	add    %ecx,%eax
  80164c:	8a 00                	mov    (%eax),%al
  80164e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801650:	ff 45 f8             	incl   -0x8(%ebp)
  801653:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801656:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801659:	7c d9                	jl     801634 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80165b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80165e:	8b 45 10             	mov    0x10(%ebp),%eax
  801661:	01 d0                	add    %edx,%eax
  801663:	c6 00 00             	movb   $0x0,(%eax)
}
  801666:	90                   	nop
  801667:	c9                   	leave  
  801668:	c3                   	ret    

00801669 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80166c:	8b 45 14             	mov    0x14(%ebp),%eax
  80166f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801675:	8b 45 14             	mov    0x14(%ebp),%eax
  801678:	8b 00                	mov    (%eax),%eax
  80167a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801681:	8b 45 10             	mov    0x10(%ebp),%eax
  801684:	01 d0                	add    %edx,%eax
  801686:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80168c:	eb 0c                	jmp    80169a <strsplit+0x31>
			*string++ = 0;
  80168e:	8b 45 08             	mov    0x8(%ebp),%eax
  801691:	8d 50 01             	lea    0x1(%eax),%edx
  801694:	89 55 08             	mov    %edx,0x8(%ebp)
  801697:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80169a:	8b 45 08             	mov    0x8(%ebp),%eax
  80169d:	8a 00                	mov    (%eax),%al
  80169f:	84 c0                	test   %al,%al
  8016a1:	74 18                	je     8016bb <strsplit+0x52>
  8016a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a6:	8a 00                	mov    (%eax),%al
  8016a8:	0f be c0             	movsbl %al,%eax
  8016ab:	50                   	push   %eax
  8016ac:	ff 75 0c             	pushl  0xc(%ebp)
  8016af:	e8 13 fb ff ff       	call   8011c7 <strchr>
  8016b4:	83 c4 08             	add    $0x8,%esp
  8016b7:	85 c0                	test   %eax,%eax
  8016b9:	75 d3                	jne    80168e <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	8a 00                	mov    (%eax),%al
  8016c0:	84 c0                	test   %al,%al
  8016c2:	74 5a                	je     80171e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  8016c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c7:	8b 00                	mov    (%eax),%eax
  8016c9:	83 f8 0f             	cmp    $0xf,%eax
  8016cc:	75 07                	jne    8016d5 <strsplit+0x6c>
		{
			return 0;
  8016ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d3:	eb 66                	jmp    80173b <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d8:	8b 00                	mov    (%eax),%eax
  8016da:	8d 48 01             	lea    0x1(%eax),%ecx
  8016dd:	8b 55 14             	mov    0x14(%ebp),%edx
  8016e0:	89 0a                	mov    %ecx,(%edx)
  8016e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ec:	01 c2                	add    %eax,%edx
  8016ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016f3:	eb 03                	jmp    8016f8 <strsplit+0x8f>
			string++;
  8016f5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fb:	8a 00                	mov    (%eax),%al
  8016fd:	84 c0                	test   %al,%al
  8016ff:	74 8b                	je     80168c <strsplit+0x23>
  801701:	8b 45 08             	mov    0x8(%ebp),%eax
  801704:	8a 00                	mov    (%eax),%al
  801706:	0f be c0             	movsbl %al,%eax
  801709:	50                   	push   %eax
  80170a:	ff 75 0c             	pushl  0xc(%ebp)
  80170d:	e8 b5 fa ff ff       	call   8011c7 <strchr>
  801712:	83 c4 08             	add    $0x8,%esp
  801715:	85 c0                	test   %eax,%eax
  801717:	74 dc                	je     8016f5 <strsplit+0x8c>
			string++;
	}
  801719:	e9 6e ff ff ff       	jmp    80168c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80171e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80171f:	8b 45 14             	mov    0x14(%ebp),%eax
  801722:	8b 00                	mov    (%eax),%eax
  801724:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80172b:	8b 45 10             	mov    0x10(%ebp),%eax
  80172e:	01 d0                	add    %edx,%eax
  801730:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801736:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80173b:	c9                   	leave  
  80173c:	c3                   	ret    

0080173d <malloc>:
int cnt_mem = 0;
int heap_mem[size_uhmem] = { 0 };
struct hmem heap_size[size_uhmem] = { 0 };
int check = 0;

void* malloc(uint32 size) {
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
  801740:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyNEXTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	//NEXT FIT
	if (sys_isUHeapPlacementStrategyNEXTFIT()) {
  801746:	e8 7d 0f 00 00       	call   8026c8 <sys_isUHeapPlacementStrategyNEXTFIT>
  80174b:	85 c0                	test   %eax,%eax
  80174d:	0f 84 6f 03 00 00    	je     801ac2 <malloc+0x385>
		size = ROUNDUP(size, PAGE_SIZE);
  801753:	c7 45 84 00 10 00 00 	movl   $0x1000,-0x7c(%ebp)
  80175a:	8b 55 08             	mov    0x8(%ebp),%edx
  80175d:	8b 45 84             	mov    -0x7c(%ebp),%eax
  801760:	01 d0                	add    %edx,%eax
  801762:	48                   	dec    %eax
  801763:	89 45 80             	mov    %eax,-0x80(%ebp)
  801766:	8b 45 80             	mov    -0x80(%ebp),%eax
  801769:	ba 00 00 00 00       	mov    $0x0,%edx
  80176e:	f7 75 84             	divl   -0x7c(%ebp)
  801771:	8b 45 80             	mov    -0x80(%ebp),%eax
  801774:	29 d0                	sub    %edx,%eax
  801776:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801779:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80177d:	74 09                	je     801788 <malloc+0x4b>
  80177f:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801786:	76 0a                	jbe    801792 <malloc+0x55>
			return NULL;
  801788:	b8 00 00 00 00       	mov    $0x0,%eax
  80178d:	e9 4b 09 00 00       	jmp    8020dd <malloc+0x9a0>
		}
		// first we can allocate by " Strategy Continues "
		if (ptr_uheap + size <= (uint32) USER_HEAP_MAX && !check) {
  801792:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801798:	8b 45 08             	mov    0x8(%ebp),%eax
  80179b:	01 d0                	add    %edx,%eax
  80179d:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8017a2:	0f 87 a2 00 00 00    	ja     80184a <malloc+0x10d>
  8017a8:	a1 60 30 98 00       	mov    0x983060,%eax
  8017ad:	85 c0                	test   %eax,%eax
  8017af:	0f 85 95 00 00 00    	jne    80184a <malloc+0x10d>

			void* ret = (void *) ptr_uheap;
  8017b5:	a1 04 30 80 00       	mov    0x803004,%eax
  8017ba:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			sys_allocateMem(ptr_uheap, size);
  8017c0:	a1 04 30 80 00       	mov    0x803004,%eax
  8017c5:	83 ec 08             	sub    $0x8,%esp
  8017c8:	ff 75 08             	pushl  0x8(%ebp)
  8017cb:	50                   	push   %eax
  8017cc:	e8 a3 0b 00 00       	call   802374 <sys_allocateMem>
  8017d1:	83 c4 10             	add    $0x10,%esp

			heap_size[cnt_mem].size = size;
  8017d4:	a1 40 30 80 00       	mov    0x803040,%eax
  8017d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8017dc:	89 14 c5 64 30 88 00 	mov    %edx,0x883064(,%eax,8)
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8017e3:	a1 40 30 80 00       	mov    0x803040,%eax
  8017e8:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8017ee:	89 14 c5 60 30 88 00 	mov    %edx,0x883060(,%eax,8)
			cnt_mem++;
  8017f5:	a1 40 30 80 00       	mov    0x803040,%eax
  8017fa:	40                   	inc    %eax
  8017fb:	a3 40 30 80 00       	mov    %eax,0x803040
			int i = 0;
  801800:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  801807:	eb 2e                	jmp    801837 <malloc+0xfa>
			{

				heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801809:	a1 04 30 80 00       	mov    0x803004,%eax
  80180e:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] = 1;
  801813:	c1 e8 0c             	shr    $0xc,%eax
  801816:	c7 04 85 60 30 80 00 	movl   $0x1,0x803060(,%eax,4)
  80181d:	01 00 00 00 

				ptr_uheap += (uint32) PAGE_SIZE;
  801821:	a1 04 30 80 00       	mov    0x803004,%eax
  801826:	05 00 10 00 00       	add    $0x1000,%eax
  80182b:	a3 04 30 80 00       	mov    %eax,0x803004
			heap_size[cnt_mem].size = size;
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
			cnt_mem++;
			int i = 0;
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  801830:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80183a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80183d:	72 ca                	jb     801809 <malloc+0xcc>
						/ (uint32) PAGE_SIZE)] = 1;

				ptr_uheap += (uint32) PAGE_SIZE;
			}

			return ret;
  80183f:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  801845:	e9 93 08 00 00       	jmp    8020dd <malloc+0x9a0>

		} else {
			// second we can allocate by " Strategy NEXTFIT "
			void* temp_end = NULL;
  80184a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

			int check_start = 0;
  801851:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			// check first that we used " Strategy Continues " before and not do it again and turn to NEXTFIT
			if (!check) {
  801858:	a1 60 30 98 00       	mov    0x983060,%eax
  80185d:	85 c0                	test   %eax,%eax
  80185f:	75 1d                	jne    80187e <malloc+0x141>
				ptr_uheap = (uint32) USER_HEAP_START;
  801861:	c7 05 04 30 80 00 00 	movl   $0x80000000,0x803004
  801868:	00 00 80 
				check = 1;
  80186b:	c7 05 60 30 98 00 01 	movl   $0x1,0x983060
  801872:	00 00 00 
				check_start = 1;// to dont use second loop CZ ptr_uheap start from USER_HEAP_START
  801875:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  80187c:	eb 08                	jmp    801886 <malloc+0x149>
			} else {
				temp_end = (void*) ptr_uheap;
  80187e:	a1 04 30 80 00       	mov    0x803004,%eax
  801883:	89 45 f0             	mov    %eax,-0x10(%ebp)

			}

			uint32 sz = 0;
  801886:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
			int f = 0;
  80188d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			uint32 ptr = ptr_uheap;
  801894:	a1 04 30 80 00       	mov    0x803004,%eax
  801899:	89 45 e0             	mov    %eax,-0x20(%ebp)
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  80189c:	eb 4d                	jmp    8018eb <malloc+0x1ae>
				if (sz == size) {
  80189e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018a1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8018a4:	75 09                	jne    8018af <malloc+0x172>
					f = 1;
  8018a6:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  8018ad:	eb 45                	jmp    8018f4 <malloc+0x1b7>
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  8018af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018b2:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] == 0) {
  8018b7:	c1 e8 0c             	shr    $0xc,%eax
			while (ptr < (uint32) USER_HEAP_MAX) {
				if (sz == size) {
					f = 1;
					break;
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  8018ba:	8b 04 85 60 30 80 00 	mov    0x803060(,%eax,4),%eax
  8018c1:	85 c0                	test   %eax,%eax
  8018c3:	75 10                	jne    8018d5 <malloc+0x198>
						/ (uint32) PAGE_SIZE)] == 0) {

					sz += PAGE_SIZE;
  8018c5:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
					ptr += PAGE_SIZE;
  8018cc:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  8018d3:	eb 16                	jmp    8018eb <malloc+0x1ae>
				} else {
					sz = 0;
  8018d5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
					ptr += PAGE_SIZE;
  8018dc:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
					ptr_uheap = ptr;
  8018e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018e6:	a3 04 30 80 00       	mov    %eax,0x803004

			uint32 sz = 0;
			int f = 0;
			uint32 ptr = ptr_uheap;
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  8018eb:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  8018f2:	76 aa                	jbe    80189e <malloc+0x161>
					ptr_uheap = ptr;
				}

			}

			if (f) {
  8018f4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018f8:	0f 84 95 00 00 00    	je     801993 <malloc+0x256>

				void* ret = (void *) ptr_uheap;
  8018fe:	a1 04 30 80 00       	mov    0x803004,%eax
  801903:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

				sys_allocateMem(ptr_uheap, size);
  801909:	a1 04 30 80 00       	mov    0x803004,%eax
  80190e:	83 ec 08             	sub    $0x8,%esp
  801911:	ff 75 08             	pushl  0x8(%ebp)
  801914:	50                   	push   %eax
  801915:	e8 5a 0a 00 00       	call   802374 <sys_allocateMem>
  80191a:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  80191d:	a1 40 30 80 00       	mov    0x803040,%eax
  801922:	8b 55 08             	mov    0x8(%ebp),%edx
  801925:	89 14 c5 64 30 88 00 	mov    %edx,0x883064(,%eax,8)
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
  80192c:	a1 40 30 80 00       	mov    0x803040,%eax
  801931:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801937:	89 14 c5 60 30 88 00 	mov    %edx,0x883060(,%eax,8)
				cnt_mem++;
  80193e:	a1 40 30 80 00       	mov    0x803040,%eax
  801943:	40                   	inc    %eax
  801944:	a3 40 30 80 00       	mov    %eax,0x803040
				int i = 0;
  801949:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801950:	eb 2e                	jmp    801980 <malloc+0x243>
				{

					heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801952:	a1 04 30 80 00       	mov    0x803004,%eax
  801957:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  80195c:	c1 e8 0c             	shr    $0xc,%eax
  80195f:	c7 04 85 60 30 80 00 	movl   $0x1,0x803060(,%eax,4)
  801966:	01 00 00 00 

					ptr_uheap += (uint32) PAGE_SIZE;
  80196a:	a1 04 30 80 00       	mov    0x803004,%eax
  80196f:	05 00 10 00 00       	add    $0x1000,%eax
  801974:	a3 04 30 80 00       	mov    %eax,0x803004
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
				cnt_mem++;
				int i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801979:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801980:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801983:	3b 45 08             	cmp    0x8(%ebp),%eax
  801986:	72 ca                	jb     801952 <malloc+0x215>
							/ (uint32) PAGE_SIZE)] = 1;

					ptr_uheap += (uint32) PAGE_SIZE;
				}

				return ret;
  801988:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80198e:	e9 4a 07 00 00       	jmp    8020dd <malloc+0x9a0>

			} else {

				if (check_start) {
  801993:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801997:	74 0a                	je     8019a3 <malloc+0x266>

					return NULL;
  801999:	b8 00 00 00 00       	mov    $0x0,%eax
  80199e:	e9 3a 07 00 00       	jmp    8020dd <malloc+0x9a0>
				}

//////////////back loop////////////////

				uint32 sz = 0;
  8019a3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
				int f = 0;
  8019aa:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				uint32 ptr = USER_HEAP_START;
  8019b1:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
				ptr_uheap = USER_HEAP_START;
  8019b8:	c7 05 04 30 80 00 00 	movl   $0x80000000,0x803004
  8019bf:	00 00 80 
				while (ptr < (uint32) temp_end) {
  8019c2:	eb 4d                	jmp    801a11 <malloc+0x2d4>
					if (sz == size) {
  8019c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8019ca:	75 09                	jne    8019d5 <malloc+0x298>
						f = 1;
  8019cc:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
						break;
  8019d3:	eb 44                	jmp    801a19 <malloc+0x2dc>
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  8019d5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8019d8:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] == 0) {
  8019dd:	c1 e8 0c             	shr    $0xc,%eax
				while (ptr < (uint32) temp_end) {
					if (sz == size) {
						f = 1;
						break;
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  8019e0:	8b 04 85 60 30 80 00 	mov    0x803060(,%eax,4),%eax
  8019e7:	85 c0                	test   %eax,%eax
  8019e9:	75 10                	jne    8019fb <malloc+0x2be>
							/ (uint32) PAGE_SIZE)] == 0) {

						sz += PAGE_SIZE;
  8019eb:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
						ptr += PAGE_SIZE;
  8019f2:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
  8019f9:	eb 16                	jmp    801a11 <malloc+0x2d4>
					} else {
						sz = 0;
  8019fb:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801a02:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
						ptr_uheap = ptr;
  801a09:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801a0c:	a3 04 30 80 00       	mov    %eax,0x803004

				uint32 sz = 0;
				int f = 0;
				uint32 ptr = USER_HEAP_START;
				ptr_uheap = USER_HEAP_START;
				while (ptr < (uint32) temp_end) {
  801a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a14:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801a17:	72 ab                	jb     8019c4 <malloc+0x287>
						ptr_uheap = ptr;
					}

				}

				if (f) {
  801a19:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801a1d:	0f 84 95 00 00 00    	je     801ab8 <malloc+0x37b>

					void* ret = (void *) ptr_uheap;
  801a23:	a1 04 30 80 00       	mov    0x803004,%eax
  801a28:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

					sys_allocateMem(ptr_uheap, size);
  801a2e:	a1 04 30 80 00       	mov    0x803004,%eax
  801a33:	83 ec 08             	sub    $0x8,%esp
  801a36:	ff 75 08             	pushl  0x8(%ebp)
  801a39:	50                   	push   %eax
  801a3a:	e8 35 09 00 00       	call   802374 <sys_allocateMem>
  801a3f:	83 c4 10             	add    $0x10,%esp

					heap_size[cnt_mem].size = size;
  801a42:	a1 40 30 80 00       	mov    0x803040,%eax
  801a47:	8b 55 08             	mov    0x8(%ebp),%edx
  801a4a:	89 14 c5 64 30 88 00 	mov    %edx,0x883064(,%eax,8)
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801a51:	a1 40 30 80 00       	mov    0x803040,%eax
  801a56:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801a5c:	89 14 c5 60 30 88 00 	mov    %edx,0x883060(,%eax,8)
					cnt_mem++;
  801a63:	a1 40 30 80 00       	mov    0x803040,%eax
  801a68:	40                   	inc    %eax
  801a69:	a3 40 30 80 00       	mov    %eax,0x803040
					int i = 0;
  801a6e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

					for (; i < size; i += PAGE_SIZE)
  801a75:	eb 2e                	jmp    801aa5 <malloc+0x368>
					{

						heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801a77:	a1 04 30 80 00       	mov    0x803004,%eax
  801a7c:	05 00 00 00 80       	add    $0x80000000,%eax
								/ (uint32) PAGE_SIZE)] = 1;
  801a81:	c1 e8 0c             	shr    $0xc,%eax
  801a84:	c7 04 85 60 30 80 00 	movl   $0x1,0x803060(,%eax,4)
  801a8b:	01 00 00 00 

						ptr_uheap += (uint32) PAGE_SIZE;
  801a8f:	a1 04 30 80 00       	mov    0x803004,%eax
  801a94:	05 00 10 00 00       	add    $0x1000,%eax
  801a99:	a3 04 30 80 00       	mov    %eax,0x803004
					heap_size[cnt_mem].size = size;
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
					cnt_mem++;
					int i = 0;

					for (; i < size; i += PAGE_SIZE)
  801a9e:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  801aa5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801aa8:	3b 45 08             	cmp    0x8(%ebp),%eax
  801aab:	72 ca                	jb     801a77 <malloc+0x33a>
								/ (uint32) PAGE_SIZE)] = 1;

						ptr_uheap += (uint32) PAGE_SIZE;
					}

					return ret;
  801aad:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801ab3:	e9 25 06 00 00       	jmp    8020dd <malloc+0x9a0>

				} else {

					return NULL;
  801ab8:	b8 00 00 00 00       	mov    $0x0,%eax
  801abd:	e9 1b 06 00 00       	jmp    8020dd <malloc+0x9a0>

		}

	}

	else if (sys_isUHeapPlacementStrategyBESTFIT()) {
  801ac2:	e8 d0 0b 00 00       	call   802697 <sys_isUHeapPlacementStrategyBESTFIT>
  801ac7:	85 c0                	test   %eax,%eax
  801ac9:	0f 84 ba 01 00 00    	je     801c89 <malloc+0x54c>

		size = ROUNDUP(size, PAGE_SIZE);
  801acf:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  801ad6:	10 00 00 
  801ad9:	8b 55 08             	mov    0x8(%ebp),%edx
  801adc:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  801ae2:	01 d0                	add    %edx,%eax
  801ae4:	48                   	dec    %eax
  801ae5:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  801aeb:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801af1:	ba 00 00 00 00       	mov    $0x0,%edx
  801af6:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  801afc:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801b02:	29 d0                	sub    %edx,%eax
  801b04:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801b07:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b0b:	74 09                	je     801b16 <malloc+0x3d9>
  801b0d:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801b14:	76 0a                	jbe    801b20 <malloc+0x3e3>
			return NULL;
  801b16:	b8 00 00 00 00       	mov    $0x0,%eax
  801b1b:	e9 bd 05 00 00       	jmp    8020dd <malloc+0x9a0>
		}
		uint32 ptr = (uint32) USER_HEAP_START;
  801b20:	c7 45 c8 00 00 00 80 	movl   $0x80000000,-0x38(%ebp)
		uint32 temp = 0;
  801b27:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		uint32 min_sz = size_uhmem + 1;
  801b2e:	c7 45 c0 01 00 02 00 	movl   $0x20001,-0x40(%ebp)
		uint32 count = 0;
  801b35:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
		int i = 0;
  801b3c:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	c1 e8 0c             	shr    $0xc,%eax
  801b49:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801b4f:	e9 80 00 00 00       	jmp    801bd4 <malloc+0x497>

			if (heap_mem[i] == 0) {
  801b54:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801b57:	8b 04 85 60 30 80 00 	mov    0x803060(,%eax,4),%eax
  801b5e:	85 c0                	test   %eax,%eax
  801b60:	75 0c                	jne    801b6e <malloc+0x431>

				count++;
  801b62:	ff 45 bc             	incl   -0x44(%ebp)
				ptr += PAGE_SIZE;
  801b65:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801b6c:	eb 2d                	jmp    801b9b <malloc+0x45e>
			} else {
				if (num_p <= count && min_sz > count) {
  801b6e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801b74:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801b77:	77 14                	ja     801b8d <malloc+0x450>
  801b79:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801b7c:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801b7f:	76 0c                	jbe    801b8d <malloc+0x450>

					min_sz = count;
  801b81:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801b84:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801b87:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801b8a:	89 45 c4             	mov    %eax,-0x3c(%ebp)

				}
				count = 0;
  801b8d:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
				ptr += PAGE_SIZE;
  801b94:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
			}

			if (i == size_uhmem - 1) {
  801b9b:	81 7d b8 ff ff 01 00 	cmpl   $0x1ffff,-0x48(%ebp)
  801ba2:	75 2d                	jne    801bd1 <malloc+0x494>

				if (num_p <= count && min_sz > count) {
  801ba4:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801baa:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801bad:	77 22                	ja     801bd1 <malloc+0x494>
  801baf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801bb2:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801bb5:	76 1a                	jbe    801bd1 <malloc+0x494>

					min_sz = count;
  801bb7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801bba:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801bbd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801bc0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
					count = 0;
  801bc3:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
					ptr += PAGE_SIZE;
  801bca:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801bd1:	ff 45 b8             	incl   -0x48(%ebp)
  801bd4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801bd7:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801bdc:	0f 86 72 ff ff ff    	jbe    801b54 <malloc+0x417>

			}

		}

		if (num_p > min_sz || temp == 0) {
  801be2:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801be8:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  801beb:	77 06                	ja     801bf3 <malloc+0x4b6>
  801bed:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801bf1:	75 0a                	jne    801bfd <malloc+0x4c0>
			return NULL;
  801bf3:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf8:	e9 e0 04 00 00       	jmp    8020dd <malloc+0x9a0>

		}

		temp = temp - (PAGE_SIZE * min_sz);
  801bfd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c00:	c1 e0 0c             	shl    $0xc,%eax
  801c03:	29 45 c4             	sub    %eax,-0x3c(%ebp)
		void* ret = (void*) temp;
  801c06:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801c09:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)

		sys_allocateMem(temp, size);
  801c0f:	83 ec 08             	sub    $0x8,%esp
  801c12:	ff 75 08             	pushl  0x8(%ebp)
  801c15:	ff 75 c4             	pushl  -0x3c(%ebp)
  801c18:	e8 57 07 00 00       	call   802374 <sys_allocateMem>
  801c1d:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801c20:	a1 40 30 80 00       	mov    0x803040,%eax
  801c25:	8b 55 08             	mov    0x8(%ebp),%edx
  801c28:	89 14 c5 64 30 88 00 	mov    %edx,0x883064(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801c2f:	a1 40 30 80 00       	mov    0x803040,%eax
  801c34:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801c37:	89 14 c5 60 30 88 00 	mov    %edx,0x883060(,%eax,8)
		cnt_mem++;
  801c3e:	a1 40 30 80 00       	mov    0x803040,%eax
  801c43:	40                   	inc    %eax
  801c44:	a3 40 30 80 00       	mov    %eax,0x803040
		i = 0;
  801c49:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801c50:	eb 24                	jmp    801c76 <malloc+0x539>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801c52:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801c55:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801c5a:	c1 e8 0c             	shr    $0xc,%eax
  801c5d:	c7 04 85 60 30 80 00 	movl   $0x1,0x803060(,%eax,4)
  801c64:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801c68:	81 45 c4 00 10 00 00 	addl   $0x1000,-0x3c(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801c6f:	81 45 b8 00 10 00 00 	addl   $0x1000,-0x48(%ebp)
  801c76:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801c79:	3b 45 08             	cmp    0x8(%ebp),%eax
  801c7c:	72 d4                	jb     801c52 <malloc+0x515>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801c7e:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801c84:	e9 54 04 00 00       	jmp    8020dd <malloc+0x9a0>

	} else if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801c89:	e8 d8 09 00 00       	call   802666 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c8e:	85 c0                	test   %eax,%eax
  801c90:	0f 84 88 01 00 00    	je     801e1e <malloc+0x6e1>

		size = ROUNDUP(size, PAGE_SIZE);
  801c96:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  801c9d:	10 00 00 
  801ca0:	8b 55 08             	mov    0x8(%ebp),%edx
  801ca3:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  801ca9:	01 d0                	add    %edx,%eax
  801cab:	48                   	dec    %eax
  801cac:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  801cb2:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801cb8:	ba 00 00 00 00       	mov    $0x0,%edx
  801cbd:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  801cc3:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801cc9:	29 d0                	sub    %edx,%eax
  801ccb:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801cce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801cd2:	74 09                	je     801cdd <malloc+0x5a0>
  801cd4:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801cdb:	76 0a                	jbe    801ce7 <malloc+0x5aa>
			return NULL;
  801cdd:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce2:	e9 f6 03 00 00       	jmp    8020dd <malloc+0x9a0>
		}

		uint32 ptr = (uint32) USER_HEAP_START;
  801ce7:	c7 45 b4 00 00 00 80 	movl   $0x80000000,-0x4c(%ebp)
		uint32 temp = 0;
  801cee:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
		uint32 found = 0;
  801cf5:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		uint32 count = 0;
  801cfc:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
		int i = 0;
  801d03:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0d:	c1 e8 0c             	shr    $0xc,%eax
  801d10:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

		for (; i < size_uhmem; i++) {
  801d16:	eb 5a                	jmp    801d72 <malloc+0x635>

			if (heap_mem[i] == 0) {
  801d18:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801d1b:	8b 04 85 60 30 80 00 	mov    0x803060(,%eax,4),%eax
  801d22:	85 c0                	test   %eax,%eax
  801d24:	75 0c                	jne    801d32 <malloc+0x5f5>

				count++;
  801d26:	ff 45 a8             	incl   -0x58(%ebp)
				ptr += PAGE_SIZE;
  801d29:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
  801d30:	eb 22                	jmp    801d54 <malloc+0x617>
			} else {
				if (num_p <= count) {
  801d32:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801d38:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801d3b:	77 09                	ja     801d46 <malloc+0x609>

					found = 1;
  801d3d:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)

					break;
  801d44:	eb 36                	jmp    801d7c <malloc+0x63f>
				}
				count = 0;
  801d46:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
				ptr += PAGE_SIZE;
  801d4d:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
			}

			if (i == size_uhmem - 1) {
  801d54:	81 7d a4 ff ff 01 00 	cmpl   $0x1ffff,-0x5c(%ebp)
  801d5b:	75 12                	jne    801d6f <malloc+0x632>

				if (num_p <= count) {
  801d5d:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801d63:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801d66:	77 07                	ja     801d6f <malloc+0x632>

					found = 1;
  801d68:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
		uint32 found = 0;
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		for (; i < size_uhmem; i++) {
  801d6f:	ff 45 a4             	incl   -0x5c(%ebp)
  801d72:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801d75:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801d7a:	76 9c                	jbe    801d18 <malloc+0x5db>

			}

		}

		if (!found) {
  801d7c:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  801d80:	75 0a                	jne    801d8c <malloc+0x64f>
			return NULL;
  801d82:	b8 00 00 00 00       	mov    $0x0,%eax
  801d87:	e9 51 03 00 00       	jmp    8020dd <malloc+0x9a0>

		}

		temp = ptr;
  801d8c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801d8f:	89 45 b0             	mov    %eax,-0x50(%ebp)
		temp = temp - (PAGE_SIZE * count);
  801d92:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801d95:	c1 e0 0c             	shl    $0xc,%eax
  801d98:	29 45 b0             	sub    %eax,-0x50(%ebp)
		void* ret = (void*) temp;
  801d9b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801d9e:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)

		sys_allocateMem(temp, size);
  801da4:	83 ec 08             	sub    $0x8,%esp
  801da7:	ff 75 08             	pushl  0x8(%ebp)
  801daa:	ff 75 b0             	pushl  -0x50(%ebp)
  801dad:	e8 c2 05 00 00       	call   802374 <sys_allocateMem>
  801db2:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801db5:	a1 40 30 80 00       	mov    0x803040,%eax
  801dba:	8b 55 08             	mov    0x8(%ebp),%edx
  801dbd:	89 14 c5 64 30 88 00 	mov    %edx,0x883064(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801dc4:	a1 40 30 80 00       	mov    0x803040,%eax
  801dc9:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801dcc:	89 14 c5 60 30 88 00 	mov    %edx,0x883060(,%eax,8)
		cnt_mem++;
  801dd3:	a1 40 30 80 00       	mov    0x803040,%eax
  801dd8:	40                   	inc    %eax
  801dd9:	a3 40 30 80 00       	mov    %eax,0x803040
		i = 0;
  801dde:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801de5:	eb 24                	jmp    801e0b <malloc+0x6ce>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801de7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801dea:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801def:	c1 e8 0c             	shr    $0xc,%eax
  801df2:	c7 04 85 60 30 80 00 	movl   $0x1,0x803060(,%eax,4)
  801df9:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801dfd:	81 45 b0 00 10 00 00 	addl   $0x1000,-0x50(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801e04:	81 45 a4 00 10 00 00 	addl   $0x1000,-0x5c(%ebp)
  801e0b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801e0e:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e11:	72 d4                	jb     801de7 <malloc+0x6aa>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801e13:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  801e19:	e9 bf 02 00 00       	jmp    8020dd <malloc+0x9a0>

	}
	else if(sys_isUHeapPlacementStrategyWORSTFIT())
  801e1e:	e8 d6 08 00 00       	call   8026f9 <sys_isUHeapPlacementStrategyWORSTFIT>
  801e23:	85 c0                	test   %eax,%eax
  801e25:	0f 84 ba 01 00 00    	je     801fe5 <malloc+0x8a8>
	{
		size = ROUNDUP(size, PAGE_SIZE);
  801e2b:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  801e32:	10 00 00 
  801e35:	8b 55 08             	mov    0x8(%ebp),%edx
  801e38:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  801e3e:	01 d0                	add    %edx,%eax
  801e40:	48                   	dec    %eax
  801e41:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  801e47:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  801e4d:	ba 00 00 00 00       	mov    $0x0,%edx
  801e52:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  801e58:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  801e5e:	29 d0                	sub    %edx,%eax
  801e60:	89 45 08             	mov    %eax,0x8(%ebp)

				if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801e63:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e67:	74 09                	je     801e72 <malloc+0x735>
  801e69:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801e70:	76 0a                	jbe    801e7c <malloc+0x73f>
					return NULL;
  801e72:	b8 00 00 00 00       	mov    $0x0,%eax
  801e77:	e9 61 02 00 00       	jmp    8020dd <malloc+0x9a0>
				}
				uint32 ptr = (uint32) USER_HEAP_START;
  801e7c:	c7 45 a0 00 00 00 80 	movl   $0x80000000,-0x60(%ebp)
				uint32 temp = 0;
  801e83:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
				uint32 max_sz = -1;
  801e8a:	c7 45 98 ff ff ff ff 	movl   $0xffffffff,-0x68(%ebp)
				uint32 count = 0;
  801e91:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
				int i = 0;
  801e98:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				uint32 num_p = size / PAGE_SIZE;
  801e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea2:	c1 e8 0c             	shr    $0xc,%eax
  801ea5:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  801eab:	e9 80 00 00 00       	jmp    801f30 <malloc+0x7f3>

					if (heap_mem[i] == 0) {
  801eb0:	8b 45 90             	mov    -0x70(%ebp),%eax
  801eb3:	8b 04 85 60 30 80 00 	mov    0x803060(,%eax,4),%eax
  801eba:	85 c0                	test   %eax,%eax
  801ebc:	75 0c                	jne    801eca <malloc+0x78d>

						count++;
  801ebe:	ff 45 94             	incl   -0x6c(%ebp)
						ptr += PAGE_SIZE;
  801ec1:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
  801ec8:	eb 2d                	jmp    801ef7 <malloc+0x7ba>
					} else {
						if (num_p <= count && max_sz < count) {
  801eca:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801ed0:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801ed3:	77 14                	ja     801ee9 <malloc+0x7ac>
  801ed5:	8b 45 98             	mov    -0x68(%ebp),%eax
  801ed8:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801edb:	73 0c                	jae    801ee9 <malloc+0x7ac>

							max_sz = count;
  801edd:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801ee0:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  801ee3:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801ee6:	89 45 9c             	mov    %eax,-0x64(%ebp)

						}
						count = 0;
  801ee9:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
						ptr += PAGE_SIZE;
  801ef0:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
					}

					if (i == size_uhmem - 1) {
  801ef7:	81 7d 90 ff ff 01 00 	cmpl   $0x1ffff,-0x70(%ebp)
  801efe:	75 2d                	jne    801f2d <malloc+0x7f0>

						if (num_p <= count && max_sz > count) {
  801f00:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801f06:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801f09:	77 22                	ja     801f2d <malloc+0x7f0>
  801f0b:	8b 45 98             	mov    -0x68(%ebp),%eax
  801f0e:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801f11:	76 1a                	jbe    801f2d <malloc+0x7f0>

							max_sz = count;
  801f13:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801f16:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  801f19:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801f1c:	89 45 9c             	mov    %eax,-0x64(%ebp)
							count = 0;
  801f1f:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
							ptr += PAGE_SIZE;
  801f26:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
				uint32 count = 0;
				int i = 0;
				uint32 num_p = size / PAGE_SIZE;

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  801f2d:	ff 45 90             	incl   -0x70(%ebp)
  801f30:	8b 45 90             	mov    -0x70(%ebp),%eax
  801f33:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801f38:	0f 86 72 ff ff ff    	jbe    801eb0 <malloc+0x773>

					}

				}

				if (num_p > max_sz || temp == 0) {
  801f3e:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801f44:	3b 45 98             	cmp    -0x68(%ebp),%eax
  801f47:	77 06                	ja     801f4f <malloc+0x812>
  801f49:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  801f4d:	75 0a                	jne    801f59 <malloc+0x81c>
					return NULL;
  801f4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f54:	e9 84 01 00 00       	jmp    8020dd <malloc+0x9a0>

				}

				temp = temp - (PAGE_SIZE * max_sz);
  801f59:	8b 45 98             	mov    -0x68(%ebp),%eax
  801f5c:	c1 e0 0c             	shl    $0xc,%eax
  801f5f:	29 45 9c             	sub    %eax,-0x64(%ebp)
				void* ret = (void*) temp;
  801f62:	8b 45 9c             	mov    -0x64(%ebp),%eax
  801f65:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

				sys_allocateMem(temp, size);
  801f6b:	83 ec 08             	sub    $0x8,%esp
  801f6e:	ff 75 08             	pushl  0x8(%ebp)
  801f71:	ff 75 9c             	pushl  -0x64(%ebp)
  801f74:	e8 fb 03 00 00       	call   802374 <sys_allocateMem>
  801f79:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  801f7c:	a1 40 30 80 00       	mov    0x803040,%eax
  801f81:	8b 55 08             	mov    0x8(%ebp),%edx
  801f84:	89 14 c5 64 30 88 00 	mov    %edx,0x883064(,%eax,8)
				heap_size[cnt_mem].vir = (void*) temp;
  801f8b:	a1 40 30 80 00       	mov    0x803040,%eax
  801f90:	8b 55 9c             	mov    -0x64(%ebp),%edx
  801f93:	89 14 c5 60 30 88 00 	mov    %edx,0x883060(,%eax,8)
				cnt_mem++;
  801f9a:	a1 40 30 80 00       	mov    0x803040,%eax
  801f9f:	40                   	inc    %eax
  801fa0:	a3 40 30 80 00       	mov    %eax,0x803040
				i = 0;
  801fa5:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801fac:	eb 24                	jmp    801fd2 <malloc+0x895>
				{

					heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801fae:	8b 45 9c             	mov    -0x64(%ebp),%eax
  801fb1:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  801fb6:	c1 e8 0c             	shr    $0xc,%eax
  801fb9:	c7 04 85 60 30 80 00 	movl   $0x1,0x803060(,%eax,4)
  801fc0:	01 00 00 00 

					temp += (uint32) PAGE_SIZE;
  801fc4:	81 45 9c 00 10 00 00 	addl   $0x1000,-0x64(%ebp)
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) temp;
				cnt_mem++;
				i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801fcb:	81 45 90 00 10 00 00 	addl   $0x1000,-0x70(%ebp)
  801fd2:	8b 45 90             	mov    -0x70(%ebp),%eax
  801fd5:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fd8:	72 d4                	jb     801fae <malloc+0x871>

					temp += (uint32) PAGE_SIZE;
				}

				//cprintf("\n size = %d.........vir= %d  \n",num_p,((uint32) ret-USER_HEAP_START)/PAGE_SIZE);
				return ret;
  801fda:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  801fe0:	e9 f8 00 00 00       	jmp    8020dd <malloc+0x9a0>

	}
// this is to make malloc is work
	void* ret = NULL;
  801fe5:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
	size = ROUNDUP(size, PAGE_SIZE);
  801fec:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  801ff3:	10 00 00 
  801ff6:	8b 55 08             	mov    0x8(%ebp),%edx
  801ff9:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  801fff:	01 d0                	add    %edx,%eax
  802001:	48                   	dec    %eax
  802002:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  802008:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  80200e:	ba 00 00 00 00       	mov    $0x0,%edx
  802013:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  802019:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  80201f:	29 d0                	sub    %edx,%eax
  802021:	89 45 08             	mov    %eax,0x8(%ebp)

	if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  802024:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802028:	74 09                	je     802033 <malloc+0x8f6>
  80202a:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  802031:	76 0a                	jbe    80203d <malloc+0x900>
		return NULL;
  802033:	b8 00 00 00 00       	mov    $0x0,%eax
  802038:	e9 a0 00 00 00       	jmp    8020dd <malloc+0x9a0>
	}

	if (ptr_uheap + size <= (uint32) USER_HEAP_MAX) {
  80203d:	8b 15 04 30 80 00    	mov    0x803004,%edx
  802043:	8b 45 08             	mov    0x8(%ebp),%eax
  802046:	01 d0                	add    %edx,%eax
  802048:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80204d:	0f 87 87 00 00 00    	ja     8020da <malloc+0x99d>

		ret = (void *) ptr_uheap;
  802053:	a1 04 30 80 00       	mov    0x803004,%eax
  802058:	89 45 8c             	mov    %eax,-0x74(%ebp)
		sys_allocateMem(ptr_uheap, size);
  80205b:	a1 04 30 80 00       	mov    0x803004,%eax
  802060:	83 ec 08             	sub    $0x8,%esp
  802063:	ff 75 08             	pushl  0x8(%ebp)
  802066:	50                   	push   %eax
  802067:	e8 08 03 00 00       	call   802374 <sys_allocateMem>
  80206c:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  80206f:	a1 40 30 80 00       	mov    0x803040,%eax
  802074:	8b 55 08             	mov    0x8(%ebp),%edx
  802077:	89 14 c5 64 30 88 00 	mov    %edx,0x883064(,%eax,8)
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
  80207e:	a1 40 30 80 00       	mov    0x803040,%eax
  802083:	8b 15 04 30 80 00    	mov    0x803004,%edx
  802089:	89 14 c5 60 30 88 00 	mov    %edx,0x883060(,%eax,8)
		cnt_mem++;
  802090:	a1 40 30 80 00       	mov    0x803040,%eax
  802095:	40                   	inc    %eax
  802096:	a3 40 30 80 00       	mov    %eax,0x803040
		int i = 0;
  80209b:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)

		for (; i < size; i += PAGE_SIZE)
  8020a2:	eb 2e                	jmp    8020d2 <malloc+0x995>
		{

			heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8020a4:	a1 04 30 80 00       	mov    0x803004,%eax
  8020a9:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  8020ae:	c1 e8 0c             	shr    $0xc,%eax
  8020b1:	c7 04 85 60 30 80 00 	movl   $0x1,0x803060(,%eax,4)
  8020b8:	01 00 00 00 

			ptr_uheap += (uint32) PAGE_SIZE;
  8020bc:	a1 04 30 80 00       	mov    0x803004,%eax
  8020c1:	05 00 10 00 00       	add    $0x1000,%eax
  8020c6:	a3 04 30 80 00       	mov    %eax,0x803004
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
		cnt_mem++;
		int i = 0;

		for (; i < size; i += PAGE_SIZE)
  8020cb:	81 45 88 00 10 00 00 	addl   $0x1000,-0x78(%ebp)
  8020d2:	8b 45 88             	mov    -0x78(%ebp),%eax
  8020d5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020d8:	72 ca                	jb     8020a4 <malloc+0x967>
					/ (uint32) PAGE_SIZE)] = 1;

			ptr_uheap += (uint32) PAGE_SIZE;
		}
	}
	return ret;
  8020da:	8b 45 8c             	mov    -0x74(%ebp),%eax

	//TODO: [PROJECT 2016 - BONUS2] Apply FIRST FIT and WORST FIT policies

//return 0;

}
  8020dd:	c9                   	leave  
  8020de:	c3                   	ret    

008020df <free>:
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address) {
  8020df:	55                   	push   %ebp
  8020e0:	89 e5                	mov    %esp,%ebp
  8020e2:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
  8020e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; inx < cnt_mem; inx++) {
  8020ec:	e9 c1 00 00 00       	jmp    8021b2 <free+0xd3>
		if (heap_size[inx].vir == virtual_address) {
  8020f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f4:	8b 04 c5 60 30 88 00 	mov    0x883060(,%eax,8),%eax
  8020fb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020fe:	0f 85 ab 00 00 00    	jne    8021af <free+0xd0>

			if (heap_size[inx].size == 0) {
  802104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802107:	8b 04 c5 64 30 88 00 	mov    0x883064(,%eax,8),%eax
  80210e:	85 c0                	test   %eax,%eax
  802110:	75 21                	jne    802133 <free+0x54>
				heap_size[inx].size = 0;
  802112:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802115:	c7 04 c5 64 30 88 00 	movl   $0x0,0x883064(,%eax,8)
  80211c:	00 00 00 00 
				heap_size[inx].vir = NULL;
  802120:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802123:	c7 04 c5 60 30 88 00 	movl   $0x0,0x883060(,%eax,8)
  80212a:	00 00 00 00 
				return;
  80212e:	e9 8d 00 00 00       	jmp    8021c0 <free+0xe1>

			}

			sys_freeMem((uint32) virtual_address, heap_size[inx].size);
  802133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802136:	8b 14 c5 64 30 88 00 	mov    0x883064(,%eax,8),%edx
  80213d:	8b 45 08             	mov    0x8(%ebp),%eax
  802140:	83 ec 08             	sub    $0x8,%esp
  802143:	52                   	push   %edx
  802144:	50                   	push   %eax
  802145:	e8 0e 02 00 00       	call   802358 <sys_freeMem>
  80214a:	83 c4 10             	add    $0x10,%esp

			int i = 0;
  80214d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
  802154:	8b 45 08             	mov    0x8(%ebp),%eax
  802157:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  80215a:	eb 24                	jmp    802180 <free+0xa1>
			{
				heap_mem[(int) (((uint32) va - USER_HEAP_START) / PAGE_SIZE)] =
  80215c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80215f:	05 00 00 00 80       	add    $0x80000000,%eax
  802164:	c1 e8 0c             	shr    $0xc,%eax
  802167:	c7 04 85 60 30 80 00 	movl   $0x0,0x803060(,%eax,4)
  80216e:	00 00 00 00 
						0;

				va += PAGE_SIZE;
  802172:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
			sys_freeMem((uint32) virtual_address, heap_size[inx].size);

			int i = 0;
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  802179:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  802180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802183:	8b 14 c5 64 30 88 00 	mov    0x883064(,%eax,8),%edx
  80218a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80218d:	39 c2                	cmp    %eax,%edx
  80218f:	77 cb                	ja     80215c <free+0x7d>

				va += PAGE_SIZE;

			}

			heap_size[inx].size = 0;
  802191:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802194:	c7 04 c5 64 30 88 00 	movl   $0x0,0x883064(,%eax,8)
  80219b:	00 00 00 00 
			heap_size[inx].vir = NULL;
  80219f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a2:	c7 04 c5 60 30 88 00 	movl   $0x0,0x883060(,%eax,8)
  8021a9:	00 00 00 00 
			break;
  8021ad:	eb 11                	jmp    8021c0 <free+0xe1>
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
	for (; inx < cnt_mem; inx++) {
  8021af:	ff 45 f4             	incl   -0xc(%ebp)
  8021b2:	a1 40 30 80 00       	mov    0x803040,%eax
  8021b7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  8021ba:	0f 8c 31 ff ff ff    	jl     8020f1 <free+0x12>
	}

	//get the size of the given allocation using its address
	//you need to call sys_freeMem()

}
  8021c0:	c9                   	leave  
  8021c1:	c3                   	ret    

008021c2 <realloc>:
//  Hint: you may need to use the sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size) {
  8021c2:	55                   	push   %ebp
  8021c3:	89 e5                	mov    %esp,%ebp
  8021c5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2016 - BONUS4] realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8021c8:	83 ec 04             	sub    $0x4,%esp
  8021cb:	68 84 2f 80 00       	push   $0x802f84
  8021d0:	68 1c 02 00 00       	push   $0x21c
  8021d5:	68 aa 2f 80 00       	push   $0x802faa
  8021da:	e8 aa e4 ff ff       	call   800689 <_panic>

008021df <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8021df:	55                   	push   %ebp
  8021e0:	89 e5                	mov    %esp,%ebp
  8021e2:	57                   	push   %edi
  8021e3:	56                   	push   %esi
  8021e4:	53                   	push   %ebx
  8021e5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8021e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021f1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021f4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8021f7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8021fa:	cd 30                	int    $0x30
  8021fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8021ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802202:	83 c4 10             	add    $0x10,%esp
  802205:	5b                   	pop    %ebx
  802206:	5e                   	pop    %esi
  802207:	5f                   	pop    %edi
  802208:	5d                   	pop    %ebp
  802209:	c3                   	ret    

0080220a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  80220a:	55                   	push   %ebp
  80220b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  80220d:	8b 45 08             	mov    0x8(%ebp),%eax
  802210:	6a 00                	push   $0x0
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	ff 75 0c             	pushl  0xc(%ebp)
  802219:	50                   	push   %eax
  80221a:	6a 00                	push   $0x0
  80221c:	e8 be ff ff ff       	call   8021df <syscall>
  802221:	83 c4 18             	add    $0x18,%esp
}
  802224:	90                   	nop
  802225:	c9                   	leave  
  802226:	c3                   	ret    

00802227 <sys_cgetc>:

int
sys_cgetc(void)
{
  802227:	55                   	push   %ebp
  802228:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80222a:	6a 00                	push   $0x0
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	6a 00                	push   $0x0
  802232:	6a 00                	push   $0x0
  802234:	6a 01                	push   $0x1
  802236:	e8 a4 ff ff ff       	call   8021df <syscall>
  80223b:	83 c4 18             	add    $0x18,%esp
}
  80223e:	c9                   	leave  
  80223f:	c3                   	ret    

00802240 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  802240:	55                   	push   %ebp
  802241:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  802243:	8b 45 08             	mov    0x8(%ebp),%eax
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	50                   	push   %eax
  80224f:	6a 03                	push   $0x3
  802251:	e8 89 ff ff ff       	call   8021df <syscall>
  802256:	83 c4 18             	add    $0x18,%esp
}
  802259:	c9                   	leave  
  80225a:	c3                   	ret    

0080225b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	6a 02                	push   $0x2
  80226a:	e8 70 ff ff ff       	call   8021df <syscall>
  80226f:	83 c4 18             	add    $0x18,%esp
}
  802272:	c9                   	leave  
  802273:	c3                   	ret    

00802274 <sys_env_exit>:

void sys_env_exit(void)
{
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  802277:	6a 00                	push   $0x0
  802279:	6a 00                	push   $0x0
  80227b:	6a 00                	push   $0x0
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	6a 04                	push   $0x4
  802283:	e8 57 ff ff ff       	call   8021df <syscall>
  802288:	83 c4 18             	add    $0x18,%esp
}
  80228b:	90                   	nop
  80228c:	c9                   	leave  
  80228d:	c3                   	ret    

0080228e <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  80228e:	55                   	push   %ebp
  80228f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802291:	8b 55 0c             	mov    0xc(%ebp),%edx
  802294:	8b 45 08             	mov    0x8(%ebp),%eax
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	52                   	push   %edx
  80229e:	50                   	push   %eax
  80229f:	6a 05                	push   $0x5
  8022a1:	e8 39 ff ff ff       	call   8021df <syscall>
  8022a6:	83 c4 18             	add    $0x18,%esp
}
  8022a9:	c9                   	leave  
  8022aa:	c3                   	ret    

008022ab <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8022ab:	55                   	push   %ebp
  8022ac:	89 e5                	mov    %esp,%ebp
  8022ae:	56                   	push   %esi
  8022af:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8022b0:	8b 75 18             	mov    0x18(%ebp),%esi
  8022b3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bf:	56                   	push   %esi
  8022c0:	53                   	push   %ebx
  8022c1:	51                   	push   %ecx
  8022c2:	52                   	push   %edx
  8022c3:	50                   	push   %eax
  8022c4:	6a 06                	push   $0x6
  8022c6:	e8 14 ff ff ff       	call   8021df <syscall>
  8022cb:	83 c4 18             	add    $0x18,%esp
}
  8022ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022d1:	5b                   	pop    %ebx
  8022d2:	5e                   	pop    %esi
  8022d3:	5d                   	pop    %ebp
  8022d4:	c3                   	ret    

008022d5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8022d5:	55                   	push   %ebp
  8022d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8022d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022db:	8b 45 08             	mov    0x8(%ebp),%eax
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 00                	push   $0x0
  8022e4:	52                   	push   %edx
  8022e5:	50                   	push   %eax
  8022e6:	6a 07                	push   $0x7
  8022e8:	e8 f2 fe ff ff       	call   8021df <syscall>
  8022ed:	83 c4 18             	add    $0x18,%esp
}
  8022f0:	c9                   	leave  
  8022f1:	c3                   	ret    

008022f2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8022f2:	55                   	push   %ebp
  8022f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 00                	push   $0x0
  8022f9:	6a 00                	push   $0x0
  8022fb:	ff 75 0c             	pushl  0xc(%ebp)
  8022fe:	ff 75 08             	pushl  0x8(%ebp)
  802301:	6a 08                	push   $0x8
  802303:	e8 d7 fe ff ff       	call   8021df <syscall>
  802308:	83 c4 18             	add    $0x18,%esp
}
  80230b:	c9                   	leave  
  80230c:	c3                   	ret    

0080230d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80230d:	55                   	push   %ebp
  80230e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802310:	6a 00                	push   $0x0
  802312:	6a 00                	push   $0x0
  802314:	6a 00                	push   $0x0
  802316:	6a 00                	push   $0x0
  802318:	6a 00                	push   $0x0
  80231a:	6a 09                	push   $0x9
  80231c:	e8 be fe ff ff       	call   8021df <syscall>
  802321:	83 c4 18             	add    $0x18,%esp
}
  802324:	c9                   	leave  
  802325:	c3                   	ret    

00802326 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802326:	55                   	push   %ebp
  802327:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802329:	6a 00                	push   $0x0
  80232b:	6a 00                	push   $0x0
  80232d:	6a 00                	push   $0x0
  80232f:	6a 00                	push   $0x0
  802331:	6a 00                	push   $0x0
  802333:	6a 0a                	push   $0xa
  802335:	e8 a5 fe ff ff       	call   8021df <syscall>
  80233a:	83 c4 18             	add    $0x18,%esp
}
  80233d:	c9                   	leave  
  80233e:	c3                   	ret    

0080233f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80233f:	55                   	push   %ebp
  802340:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	6a 00                	push   $0x0
  802348:	6a 00                	push   $0x0
  80234a:	6a 00                	push   $0x0
  80234c:	6a 0b                	push   $0xb
  80234e:	e8 8c fe ff ff       	call   8021df <syscall>
  802353:	83 c4 18             	add    $0x18,%esp
}
  802356:	c9                   	leave  
  802357:	c3                   	ret    

00802358 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  802358:	55                   	push   %ebp
  802359:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  80235b:	6a 00                	push   $0x0
  80235d:	6a 00                	push   $0x0
  80235f:	6a 00                	push   $0x0
  802361:	ff 75 0c             	pushl  0xc(%ebp)
  802364:	ff 75 08             	pushl  0x8(%ebp)
  802367:	6a 0d                	push   $0xd
  802369:	e8 71 fe ff ff       	call   8021df <syscall>
  80236e:	83 c4 18             	add    $0x18,%esp
	return;
  802371:	90                   	nop
}
  802372:	c9                   	leave  
  802373:	c3                   	ret    

00802374 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  802374:	55                   	push   %ebp
  802375:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  802377:	6a 00                	push   $0x0
  802379:	6a 00                	push   $0x0
  80237b:	6a 00                	push   $0x0
  80237d:	ff 75 0c             	pushl  0xc(%ebp)
  802380:	ff 75 08             	pushl  0x8(%ebp)
  802383:	6a 0e                	push   $0xe
  802385:	e8 55 fe ff ff       	call   8021df <syscall>
  80238a:	83 c4 18             	add    $0x18,%esp
	return ;
  80238d:	90                   	nop
}
  80238e:	c9                   	leave  
  80238f:	c3                   	ret    

00802390 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802393:	6a 00                	push   $0x0
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	6a 0c                	push   $0xc
  80239f:	e8 3b fe ff ff       	call   8021df <syscall>
  8023a4:	83 c4 18             	add    $0x18,%esp
}
  8023a7:	c9                   	leave  
  8023a8:	c3                   	ret    

008023a9 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8023a9:	55                   	push   %ebp
  8023aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8023ac:	6a 00                	push   $0x0
  8023ae:	6a 00                	push   $0x0
  8023b0:	6a 00                	push   $0x0
  8023b2:	6a 00                	push   $0x0
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 10                	push   $0x10
  8023b8:	e8 22 fe ff ff       	call   8021df <syscall>
  8023bd:	83 c4 18             	add    $0x18,%esp
}
  8023c0:	90                   	nop
  8023c1:	c9                   	leave  
  8023c2:	c3                   	ret    

008023c3 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8023c3:	55                   	push   %ebp
  8023c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 11                	push   $0x11
  8023d2:	e8 08 fe ff ff       	call   8021df <syscall>
  8023d7:	83 c4 18             	add    $0x18,%esp
}
  8023da:	90                   	nop
  8023db:	c9                   	leave  
  8023dc:	c3                   	ret    

008023dd <sys_cputc>:


void
sys_cputc(const char c)
{
  8023dd:	55                   	push   %ebp
  8023de:	89 e5                	mov    %esp,%ebp
  8023e0:	83 ec 04             	sub    $0x4,%esp
  8023e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8023e9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	50                   	push   %eax
  8023f6:	6a 12                	push   $0x12
  8023f8:	e8 e2 fd ff ff       	call   8021df <syscall>
  8023fd:	83 c4 18             	add    $0x18,%esp
}
  802400:	90                   	nop
  802401:	c9                   	leave  
  802402:	c3                   	ret    

00802403 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802403:	55                   	push   %ebp
  802404:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	6a 00                	push   $0x0
  802410:	6a 13                	push   $0x13
  802412:	e8 c8 fd ff ff       	call   8021df <syscall>
  802417:	83 c4 18             	add    $0x18,%esp
}
  80241a:	90                   	nop
  80241b:	c9                   	leave  
  80241c:	c3                   	ret    

0080241d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80241d:	55                   	push   %ebp
  80241e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802420:	8b 45 08             	mov    0x8(%ebp),%eax
  802423:	6a 00                	push   $0x0
  802425:	6a 00                	push   $0x0
  802427:	6a 00                	push   $0x0
  802429:	ff 75 0c             	pushl  0xc(%ebp)
  80242c:	50                   	push   %eax
  80242d:	6a 14                	push   $0x14
  80242f:	e8 ab fd ff ff       	call   8021df <syscall>
  802434:	83 c4 18             	add    $0x18,%esp
}
  802437:	c9                   	leave  
  802438:	c3                   	ret    

00802439 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  802439:	55                   	push   %ebp
  80243a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  80243c:	8b 45 08             	mov    0x8(%ebp),%eax
  80243f:	6a 00                	push   $0x0
  802441:	6a 00                	push   $0x0
  802443:	6a 00                	push   $0x0
  802445:	6a 00                	push   $0x0
  802447:	50                   	push   %eax
  802448:	6a 17                	push   $0x17
  80244a:	e8 90 fd ff ff       	call   8021df <syscall>
  80244f:	83 c4 18             	add    $0x18,%esp
}
  802452:	c9                   	leave  
  802453:	c3                   	ret    

00802454 <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  802454:	55                   	push   %ebp
  802455:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  802457:	8b 45 08             	mov    0x8(%ebp),%eax
  80245a:	6a 00                	push   $0x0
  80245c:	6a 00                	push   $0x0
  80245e:	6a 00                	push   $0x0
  802460:	6a 00                	push   $0x0
  802462:	50                   	push   %eax
  802463:	6a 15                	push   $0x15
  802465:	e8 75 fd ff ff       	call   8021df <syscall>
  80246a:	83 c4 18             	add    $0x18,%esp
}
  80246d:	90                   	nop
  80246e:	c9                   	leave  
  80246f:	c3                   	ret    

00802470 <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  802470:	55                   	push   %ebp
  802471:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  802473:	8b 45 08             	mov    0x8(%ebp),%eax
  802476:	6a 00                	push   $0x0
  802478:	6a 00                	push   $0x0
  80247a:	6a 00                	push   $0x0
  80247c:	6a 00                	push   $0x0
  80247e:	50                   	push   %eax
  80247f:	6a 16                	push   $0x16
  802481:	e8 59 fd ff ff       	call   8021df <syscall>
  802486:	83 c4 18             	add    $0x18,%esp
}
  802489:	90                   	nop
  80248a:	c9                   	leave  
  80248b:	c3                   	ret    

0080248c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  80248c:	55                   	push   %ebp
  80248d:	89 e5                	mov    %esp,%ebp
  80248f:	83 ec 04             	sub    $0x4,%esp
  802492:	8b 45 10             	mov    0x10(%ebp),%eax
  802495:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  802498:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80249b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80249f:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a2:	6a 00                	push   $0x0
  8024a4:	51                   	push   %ecx
  8024a5:	52                   	push   %edx
  8024a6:	ff 75 0c             	pushl  0xc(%ebp)
  8024a9:	50                   	push   %eax
  8024aa:	6a 18                	push   $0x18
  8024ac:	e8 2e fd ff ff       	call   8021df <syscall>
  8024b1:	83 c4 18             	add    $0x18,%esp
}
  8024b4:	c9                   	leave  
  8024b5:	c3                   	ret    

008024b6 <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  8024b6:	55                   	push   %ebp
  8024b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  8024b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bf:	6a 00                	push   $0x0
  8024c1:	6a 00                	push   $0x0
  8024c3:	6a 00                	push   $0x0
  8024c5:	52                   	push   %edx
  8024c6:	50                   	push   %eax
  8024c7:	6a 19                	push   $0x19
  8024c9:	e8 11 fd ff ff       	call   8021df <syscall>
  8024ce:	83 c4 18             	add    $0x18,%esp
}
  8024d1:	c9                   	leave  
  8024d2:	c3                   	ret    

008024d3 <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  8024d3:	55                   	push   %ebp
  8024d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  8024d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d9:	6a 00                	push   $0x0
  8024db:	6a 00                	push   $0x0
  8024dd:	6a 00                	push   $0x0
  8024df:	6a 00                	push   $0x0
  8024e1:	50                   	push   %eax
  8024e2:	6a 1a                	push   $0x1a
  8024e4:	e8 f6 fc ff ff       	call   8021df <syscall>
  8024e9:	83 c4 18             	add    $0x18,%esp
}
  8024ec:	c9                   	leave  
  8024ed:	c3                   	ret    

008024ee <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  8024ee:	55                   	push   %ebp
  8024ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  8024f1:	6a 00                	push   $0x0
  8024f3:	6a 00                	push   $0x0
  8024f5:	6a 00                	push   $0x0
  8024f7:	6a 00                	push   $0x0
  8024f9:	6a 00                	push   $0x0
  8024fb:	6a 1b                	push   $0x1b
  8024fd:	e8 dd fc ff ff       	call   8021df <syscall>
  802502:	83 c4 18             	add    $0x18,%esp
}
  802505:	c9                   	leave  
  802506:	c3                   	ret    

00802507 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802507:	55                   	push   %ebp
  802508:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80250a:	6a 00                	push   $0x0
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	6a 00                	push   $0x0
  802512:	6a 00                	push   $0x0
  802514:	6a 1c                	push   $0x1c
  802516:	e8 c4 fc ff ff       	call   8021df <syscall>
  80251b:	83 c4 18             	add    $0x18,%esp
}
  80251e:	c9                   	leave  
  80251f:	c3                   	ret    

00802520 <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  802520:	55                   	push   %ebp
  802521:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  802523:	8b 45 08             	mov    0x8(%ebp),%eax
  802526:	6a 00                	push   $0x0
  802528:	6a 00                	push   $0x0
  80252a:	6a 00                	push   $0x0
  80252c:	ff 75 0c             	pushl  0xc(%ebp)
  80252f:	50                   	push   %eax
  802530:	6a 1d                	push   $0x1d
  802532:	e8 a8 fc ff ff       	call   8021df <syscall>
  802537:	83 c4 18             	add    $0x18,%esp
}
  80253a:	c9                   	leave  
  80253b:	c3                   	ret    

0080253c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80253c:	55                   	push   %ebp
  80253d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80253f:	8b 45 08             	mov    0x8(%ebp),%eax
  802542:	6a 00                	push   $0x0
  802544:	6a 00                	push   $0x0
  802546:	6a 00                	push   $0x0
  802548:	6a 00                	push   $0x0
  80254a:	50                   	push   %eax
  80254b:	6a 1e                	push   $0x1e
  80254d:	e8 8d fc ff ff       	call   8021df <syscall>
  802552:	83 c4 18             	add    $0x18,%esp
}
  802555:	90                   	nop
  802556:	c9                   	leave  
  802557:	c3                   	ret    

00802558 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  802558:	55                   	push   %ebp
  802559:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  80255b:	8b 45 08             	mov    0x8(%ebp),%eax
  80255e:	6a 00                	push   $0x0
  802560:	6a 00                	push   $0x0
  802562:	6a 00                	push   $0x0
  802564:	6a 00                	push   $0x0
  802566:	50                   	push   %eax
  802567:	6a 1f                	push   $0x1f
  802569:	e8 71 fc ff ff       	call   8021df <syscall>
  80256e:	83 c4 18             	add    $0x18,%esp
}
  802571:	90                   	nop
  802572:	c9                   	leave  
  802573:	c3                   	ret    

00802574 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  802574:	55                   	push   %ebp
  802575:	89 e5                	mov    %esp,%ebp
  802577:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80257a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80257d:	8d 50 04             	lea    0x4(%eax),%edx
  802580:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802583:	6a 00                	push   $0x0
  802585:	6a 00                	push   $0x0
  802587:	6a 00                	push   $0x0
  802589:	52                   	push   %edx
  80258a:	50                   	push   %eax
  80258b:	6a 20                	push   $0x20
  80258d:	e8 4d fc ff ff       	call   8021df <syscall>
  802592:	83 c4 18             	add    $0x18,%esp
	return result;
  802595:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802598:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80259b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80259e:	89 01                	mov    %eax,(%ecx)
  8025a0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8025a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a6:	c9                   	leave  
  8025a7:	c2 04 00             	ret    $0x4

008025aa <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8025aa:	55                   	push   %ebp
  8025ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8025ad:	6a 00                	push   $0x0
  8025af:	6a 00                	push   $0x0
  8025b1:	ff 75 10             	pushl  0x10(%ebp)
  8025b4:	ff 75 0c             	pushl  0xc(%ebp)
  8025b7:	ff 75 08             	pushl  0x8(%ebp)
  8025ba:	6a 0f                	push   $0xf
  8025bc:	e8 1e fc ff ff       	call   8021df <syscall>
  8025c1:	83 c4 18             	add    $0x18,%esp
	return ;
  8025c4:	90                   	nop
}
  8025c5:	c9                   	leave  
  8025c6:	c3                   	ret    

008025c7 <sys_rcr2>:
uint32 sys_rcr2()
{
  8025c7:	55                   	push   %ebp
  8025c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8025ca:	6a 00                	push   $0x0
  8025cc:	6a 00                	push   $0x0
  8025ce:	6a 00                	push   $0x0
  8025d0:	6a 00                	push   $0x0
  8025d2:	6a 00                	push   $0x0
  8025d4:	6a 21                	push   $0x21
  8025d6:	e8 04 fc ff ff       	call   8021df <syscall>
  8025db:	83 c4 18             	add    $0x18,%esp
}
  8025de:	c9                   	leave  
  8025df:	c3                   	ret    

008025e0 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8025e0:	55                   	push   %ebp
  8025e1:	89 e5                	mov    %esp,%ebp
  8025e3:	83 ec 04             	sub    $0x4,%esp
  8025e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8025ec:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8025f0:	6a 00                	push   $0x0
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 00                	push   $0x0
  8025f6:	6a 00                	push   $0x0
  8025f8:	50                   	push   %eax
  8025f9:	6a 22                	push   $0x22
  8025fb:	e8 df fb ff ff       	call   8021df <syscall>
  802600:	83 c4 18             	add    $0x18,%esp
	return ;
  802603:	90                   	nop
}
  802604:	c9                   	leave  
  802605:	c3                   	ret    

00802606 <rsttst>:
void rsttst()
{
  802606:	55                   	push   %ebp
  802607:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802609:	6a 00                	push   $0x0
  80260b:	6a 00                	push   $0x0
  80260d:	6a 00                	push   $0x0
  80260f:	6a 00                	push   $0x0
  802611:	6a 00                	push   $0x0
  802613:	6a 24                	push   $0x24
  802615:	e8 c5 fb ff ff       	call   8021df <syscall>
  80261a:	83 c4 18             	add    $0x18,%esp
	return ;
  80261d:	90                   	nop
}
  80261e:	c9                   	leave  
  80261f:	c3                   	ret    

00802620 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802620:	55                   	push   %ebp
  802621:	89 e5                	mov    %esp,%ebp
  802623:	83 ec 04             	sub    $0x4,%esp
  802626:	8b 45 14             	mov    0x14(%ebp),%eax
  802629:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80262c:	8b 55 18             	mov    0x18(%ebp),%edx
  80262f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802633:	52                   	push   %edx
  802634:	50                   	push   %eax
  802635:	ff 75 10             	pushl  0x10(%ebp)
  802638:	ff 75 0c             	pushl  0xc(%ebp)
  80263b:	ff 75 08             	pushl  0x8(%ebp)
  80263e:	6a 23                	push   $0x23
  802640:	e8 9a fb ff ff       	call   8021df <syscall>
  802645:	83 c4 18             	add    $0x18,%esp
	return ;
  802648:	90                   	nop
}
  802649:	c9                   	leave  
  80264a:	c3                   	ret    

0080264b <chktst>:
void chktst(uint32 n)
{
  80264b:	55                   	push   %ebp
  80264c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80264e:	6a 00                	push   $0x0
  802650:	6a 00                	push   $0x0
  802652:	6a 00                	push   $0x0
  802654:	6a 00                	push   $0x0
  802656:	ff 75 08             	pushl  0x8(%ebp)
  802659:	6a 25                	push   $0x25
  80265b:	e8 7f fb ff ff       	call   8021df <syscall>
  802660:	83 c4 18             	add    $0x18,%esp
	return ;
  802663:	90                   	nop
}
  802664:	c9                   	leave  
  802665:	c3                   	ret    

00802666 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802666:	55                   	push   %ebp
  802667:	89 e5                	mov    %esp,%ebp
  802669:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80266c:	6a 00                	push   $0x0
  80266e:	6a 00                	push   $0x0
  802670:	6a 00                	push   $0x0
  802672:	6a 00                	push   $0x0
  802674:	6a 00                	push   $0x0
  802676:	6a 26                	push   $0x26
  802678:	e8 62 fb ff ff       	call   8021df <syscall>
  80267d:	83 c4 18             	add    $0x18,%esp
  802680:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802683:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802687:	75 07                	jne    802690 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802689:	b8 01 00 00 00       	mov    $0x1,%eax
  80268e:	eb 05                	jmp    802695 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802690:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802695:	c9                   	leave  
  802696:	c3                   	ret    

00802697 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802697:	55                   	push   %ebp
  802698:	89 e5                	mov    %esp,%ebp
  80269a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80269d:	6a 00                	push   $0x0
  80269f:	6a 00                	push   $0x0
  8026a1:	6a 00                	push   $0x0
  8026a3:	6a 00                	push   $0x0
  8026a5:	6a 00                	push   $0x0
  8026a7:	6a 26                	push   $0x26
  8026a9:	e8 31 fb ff ff       	call   8021df <syscall>
  8026ae:	83 c4 18             	add    $0x18,%esp
  8026b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8026b4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8026b8:	75 07                	jne    8026c1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8026ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8026bf:	eb 05                	jmp    8026c6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8026c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026c6:	c9                   	leave  
  8026c7:	c3                   	ret    

008026c8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8026c8:	55                   	push   %ebp
  8026c9:	89 e5                	mov    %esp,%ebp
  8026cb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026ce:	6a 00                	push   $0x0
  8026d0:	6a 00                	push   $0x0
  8026d2:	6a 00                	push   $0x0
  8026d4:	6a 00                	push   $0x0
  8026d6:	6a 00                	push   $0x0
  8026d8:	6a 26                	push   $0x26
  8026da:	e8 00 fb ff ff       	call   8021df <syscall>
  8026df:	83 c4 18             	add    $0x18,%esp
  8026e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8026e5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8026e9:	75 07                	jne    8026f2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8026eb:	b8 01 00 00 00       	mov    $0x1,%eax
  8026f0:	eb 05                	jmp    8026f7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8026f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026f7:	c9                   	leave  
  8026f8:	c3                   	ret    

008026f9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8026f9:	55                   	push   %ebp
  8026fa:	89 e5                	mov    %esp,%ebp
  8026fc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026ff:	6a 00                	push   $0x0
  802701:	6a 00                	push   $0x0
  802703:	6a 00                	push   $0x0
  802705:	6a 00                	push   $0x0
  802707:	6a 00                	push   $0x0
  802709:	6a 26                	push   $0x26
  80270b:	e8 cf fa ff ff       	call   8021df <syscall>
  802710:	83 c4 18             	add    $0x18,%esp
  802713:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802716:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80271a:	75 07                	jne    802723 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80271c:	b8 01 00 00 00       	mov    $0x1,%eax
  802721:	eb 05                	jmp    802728 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802723:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802728:	c9                   	leave  
  802729:	c3                   	ret    

0080272a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80272a:	55                   	push   %ebp
  80272b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80272d:	6a 00                	push   $0x0
  80272f:	6a 00                	push   $0x0
  802731:	6a 00                	push   $0x0
  802733:	6a 00                	push   $0x0
  802735:	ff 75 08             	pushl  0x8(%ebp)
  802738:	6a 27                	push   $0x27
  80273a:	e8 a0 fa ff ff       	call   8021df <syscall>
  80273f:	83 c4 18             	add    $0x18,%esp
	return ;
  802742:	90                   	nop
}
  802743:	c9                   	leave  
  802744:	c3                   	ret    
  802745:	66 90                	xchg   %ax,%ax
  802747:	90                   	nop

00802748 <__udivdi3>:
  802748:	55                   	push   %ebp
  802749:	57                   	push   %edi
  80274a:	56                   	push   %esi
  80274b:	53                   	push   %ebx
  80274c:	83 ec 1c             	sub    $0x1c,%esp
  80274f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802753:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802757:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80275b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80275f:	89 ca                	mov    %ecx,%edx
  802761:	89 f8                	mov    %edi,%eax
  802763:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802767:	85 f6                	test   %esi,%esi
  802769:	75 2d                	jne    802798 <__udivdi3+0x50>
  80276b:	39 cf                	cmp    %ecx,%edi
  80276d:	77 65                	ja     8027d4 <__udivdi3+0x8c>
  80276f:	89 fd                	mov    %edi,%ebp
  802771:	85 ff                	test   %edi,%edi
  802773:	75 0b                	jne    802780 <__udivdi3+0x38>
  802775:	b8 01 00 00 00       	mov    $0x1,%eax
  80277a:	31 d2                	xor    %edx,%edx
  80277c:	f7 f7                	div    %edi
  80277e:	89 c5                	mov    %eax,%ebp
  802780:	31 d2                	xor    %edx,%edx
  802782:	89 c8                	mov    %ecx,%eax
  802784:	f7 f5                	div    %ebp
  802786:	89 c1                	mov    %eax,%ecx
  802788:	89 d8                	mov    %ebx,%eax
  80278a:	f7 f5                	div    %ebp
  80278c:	89 cf                	mov    %ecx,%edi
  80278e:	89 fa                	mov    %edi,%edx
  802790:	83 c4 1c             	add    $0x1c,%esp
  802793:	5b                   	pop    %ebx
  802794:	5e                   	pop    %esi
  802795:	5f                   	pop    %edi
  802796:	5d                   	pop    %ebp
  802797:	c3                   	ret    
  802798:	39 ce                	cmp    %ecx,%esi
  80279a:	77 28                	ja     8027c4 <__udivdi3+0x7c>
  80279c:	0f bd fe             	bsr    %esi,%edi
  80279f:	83 f7 1f             	xor    $0x1f,%edi
  8027a2:	75 40                	jne    8027e4 <__udivdi3+0x9c>
  8027a4:	39 ce                	cmp    %ecx,%esi
  8027a6:	72 0a                	jb     8027b2 <__udivdi3+0x6a>
  8027a8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8027ac:	0f 87 9e 00 00 00    	ja     802850 <__udivdi3+0x108>
  8027b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8027b7:	89 fa                	mov    %edi,%edx
  8027b9:	83 c4 1c             	add    $0x1c,%esp
  8027bc:	5b                   	pop    %ebx
  8027bd:	5e                   	pop    %esi
  8027be:	5f                   	pop    %edi
  8027bf:	5d                   	pop    %ebp
  8027c0:	c3                   	ret    
  8027c1:	8d 76 00             	lea    0x0(%esi),%esi
  8027c4:	31 ff                	xor    %edi,%edi
  8027c6:	31 c0                	xor    %eax,%eax
  8027c8:	89 fa                	mov    %edi,%edx
  8027ca:	83 c4 1c             	add    $0x1c,%esp
  8027cd:	5b                   	pop    %ebx
  8027ce:	5e                   	pop    %esi
  8027cf:	5f                   	pop    %edi
  8027d0:	5d                   	pop    %ebp
  8027d1:	c3                   	ret    
  8027d2:	66 90                	xchg   %ax,%ax
  8027d4:	89 d8                	mov    %ebx,%eax
  8027d6:	f7 f7                	div    %edi
  8027d8:	31 ff                	xor    %edi,%edi
  8027da:	89 fa                	mov    %edi,%edx
  8027dc:	83 c4 1c             	add    $0x1c,%esp
  8027df:	5b                   	pop    %ebx
  8027e0:	5e                   	pop    %esi
  8027e1:	5f                   	pop    %edi
  8027e2:	5d                   	pop    %ebp
  8027e3:	c3                   	ret    
  8027e4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8027e9:	89 eb                	mov    %ebp,%ebx
  8027eb:	29 fb                	sub    %edi,%ebx
  8027ed:	89 f9                	mov    %edi,%ecx
  8027ef:	d3 e6                	shl    %cl,%esi
  8027f1:	89 c5                	mov    %eax,%ebp
  8027f3:	88 d9                	mov    %bl,%cl
  8027f5:	d3 ed                	shr    %cl,%ebp
  8027f7:	89 e9                	mov    %ebp,%ecx
  8027f9:	09 f1                	or     %esi,%ecx
  8027fb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8027ff:	89 f9                	mov    %edi,%ecx
  802801:	d3 e0                	shl    %cl,%eax
  802803:	89 c5                	mov    %eax,%ebp
  802805:	89 d6                	mov    %edx,%esi
  802807:	88 d9                	mov    %bl,%cl
  802809:	d3 ee                	shr    %cl,%esi
  80280b:	89 f9                	mov    %edi,%ecx
  80280d:	d3 e2                	shl    %cl,%edx
  80280f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802813:	88 d9                	mov    %bl,%cl
  802815:	d3 e8                	shr    %cl,%eax
  802817:	09 c2                	or     %eax,%edx
  802819:	89 d0                	mov    %edx,%eax
  80281b:	89 f2                	mov    %esi,%edx
  80281d:	f7 74 24 0c          	divl   0xc(%esp)
  802821:	89 d6                	mov    %edx,%esi
  802823:	89 c3                	mov    %eax,%ebx
  802825:	f7 e5                	mul    %ebp
  802827:	39 d6                	cmp    %edx,%esi
  802829:	72 19                	jb     802844 <__udivdi3+0xfc>
  80282b:	74 0b                	je     802838 <__udivdi3+0xf0>
  80282d:	89 d8                	mov    %ebx,%eax
  80282f:	31 ff                	xor    %edi,%edi
  802831:	e9 58 ff ff ff       	jmp    80278e <__udivdi3+0x46>
  802836:	66 90                	xchg   %ax,%ax
  802838:	8b 54 24 08          	mov    0x8(%esp),%edx
  80283c:	89 f9                	mov    %edi,%ecx
  80283e:	d3 e2                	shl    %cl,%edx
  802840:	39 c2                	cmp    %eax,%edx
  802842:	73 e9                	jae    80282d <__udivdi3+0xe5>
  802844:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802847:	31 ff                	xor    %edi,%edi
  802849:	e9 40 ff ff ff       	jmp    80278e <__udivdi3+0x46>
  80284e:	66 90                	xchg   %ax,%ax
  802850:	31 c0                	xor    %eax,%eax
  802852:	e9 37 ff ff ff       	jmp    80278e <__udivdi3+0x46>
  802857:	90                   	nop

00802858 <__umoddi3>:
  802858:	55                   	push   %ebp
  802859:	57                   	push   %edi
  80285a:	56                   	push   %esi
  80285b:	53                   	push   %ebx
  80285c:	83 ec 1c             	sub    $0x1c,%esp
  80285f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802863:	8b 74 24 34          	mov    0x34(%esp),%esi
  802867:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80286b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80286f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802873:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802877:	89 f3                	mov    %esi,%ebx
  802879:	89 fa                	mov    %edi,%edx
  80287b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80287f:	89 34 24             	mov    %esi,(%esp)
  802882:	85 c0                	test   %eax,%eax
  802884:	75 1a                	jne    8028a0 <__umoddi3+0x48>
  802886:	39 f7                	cmp    %esi,%edi
  802888:	0f 86 a2 00 00 00    	jbe    802930 <__umoddi3+0xd8>
  80288e:	89 c8                	mov    %ecx,%eax
  802890:	89 f2                	mov    %esi,%edx
  802892:	f7 f7                	div    %edi
  802894:	89 d0                	mov    %edx,%eax
  802896:	31 d2                	xor    %edx,%edx
  802898:	83 c4 1c             	add    $0x1c,%esp
  80289b:	5b                   	pop    %ebx
  80289c:	5e                   	pop    %esi
  80289d:	5f                   	pop    %edi
  80289e:	5d                   	pop    %ebp
  80289f:	c3                   	ret    
  8028a0:	39 f0                	cmp    %esi,%eax
  8028a2:	0f 87 ac 00 00 00    	ja     802954 <__umoddi3+0xfc>
  8028a8:	0f bd e8             	bsr    %eax,%ebp
  8028ab:	83 f5 1f             	xor    $0x1f,%ebp
  8028ae:	0f 84 ac 00 00 00    	je     802960 <__umoddi3+0x108>
  8028b4:	bf 20 00 00 00       	mov    $0x20,%edi
  8028b9:	29 ef                	sub    %ebp,%edi
  8028bb:	89 fe                	mov    %edi,%esi
  8028bd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028c1:	89 e9                	mov    %ebp,%ecx
  8028c3:	d3 e0                	shl    %cl,%eax
  8028c5:	89 d7                	mov    %edx,%edi
  8028c7:	89 f1                	mov    %esi,%ecx
  8028c9:	d3 ef                	shr    %cl,%edi
  8028cb:	09 c7                	or     %eax,%edi
  8028cd:	89 e9                	mov    %ebp,%ecx
  8028cf:	d3 e2                	shl    %cl,%edx
  8028d1:	89 14 24             	mov    %edx,(%esp)
  8028d4:	89 d8                	mov    %ebx,%eax
  8028d6:	d3 e0                	shl    %cl,%eax
  8028d8:	89 c2                	mov    %eax,%edx
  8028da:	8b 44 24 08          	mov    0x8(%esp),%eax
  8028de:	d3 e0                	shl    %cl,%eax
  8028e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028e4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8028e8:	89 f1                	mov    %esi,%ecx
  8028ea:	d3 e8                	shr    %cl,%eax
  8028ec:	09 d0                	or     %edx,%eax
  8028ee:	d3 eb                	shr    %cl,%ebx
  8028f0:	89 da                	mov    %ebx,%edx
  8028f2:	f7 f7                	div    %edi
  8028f4:	89 d3                	mov    %edx,%ebx
  8028f6:	f7 24 24             	mull   (%esp)
  8028f9:	89 c6                	mov    %eax,%esi
  8028fb:	89 d1                	mov    %edx,%ecx
  8028fd:	39 d3                	cmp    %edx,%ebx
  8028ff:	0f 82 87 00 00 00    	jb     80298c <__umoddi3+0x134>
  802905:	0f 84 91 00 00 00    	je     80299c <__umoddi3+0x144>
  80290b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80290f:	29 f2                	sub    %esi,%edx
  802911:	19 cb                	sbb    %ecx,%ebx
  802913:	89 d8                	mov    %ebx,%eax
  802915:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802919:	d3 e0                	shl    %cl,%eax
  80291b:	89 e9                	mov    %ebp,%ecx
  80291d:	d3 ea                	shr    %cl,%edx
  80291f:	09 d0                	or     %edx,%eax
  802921:	89 e9                	mov    %ebp,%ecx
  802923:	d3 eb                	shr    %cl,%ebx
  802925:	89 da                	mov    %ebx,%edx
  802927:	83 c4 1c             	add    $0x1c,%esp
  80292a:	5b                   	pop    %ebx
  80292b:	5e                   	pop    %esi
  80292c:	5f                   	pop    %edi
  80292d:	5d                   	pop    %ebp
  80292e:	c3                   	ret    
  80292f:	90                   	nop
  802930:	89 fd                	mov    %edi,%ebp
  802932:	85 ff                	test   %edi,%edi
  802934:	75 0b                	jne    802941 <__umoddi3+0xe9>
  802936:	b8 01 00 00 00       	mov    $0x1,%eax
  80293b:	31 d2                	xor    %edx,%edx
  80293d:	f7 f7                	div    %edi
  80293f:	89 c5                	mov    %eax,%ebp
  802941:	89 f0                	mov    %esi,%eax
  802943:	31 d2                	xor    %edx,%edx
  802945:	f7 f5                	div    %ebp
  802947:	89 c8                	mov    %ecx,%eax
  802949:	f7 f5                	div    %ebp
  80294b:	89 d0                	mov    %edx,%eax
  80294d:	e9 44 ff ff ff       	jmp    802896 <__umoddi3+0x3e>
  802952:	66 90                	xchg   %ax,%ax
  802954:	89 c8                	mov    %ecx,%eax
  802956:	89 f2                	mov    %esi,%edx
  802958:	83 c4 1c             	add    $0x1c,%esp
  80295b:	5b                   	pop    %ebx
  80295c:	5e                   	pop    %esi
  80295d:	5f                   	pop    %edi
  80295e:	5d                   	pop    %ebp
  80295f:	c3                   	ret    
  802960:	3b 04 24             	cmp    (%esp),%eax
  802963:	72 06                	jb     80296b <__umoddi3+0x113>
  802965:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802969:	77 0f                	ja     80297a <__umoddi3+0x122>
  80296b:	89 f2                	mov    %esi,%edx
  80296d:	29 f9                	sub    %edi,%ecx
  80296f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802973:	89 14 24             	mov    %edx,(%esp)
  802976:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80297a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80297e:	8b 14 24             	mov    (%esp),%edx
  802981:	83 c4 1c             	add    $0x1c,%esp
  802984:	5b                   	pop    %ebx
  802985:	5e                   	pop    %esi
  802986:	5f                   	pop    %edi
  802987:	5d                   	pop    %ebp
  802988:	c3                   	ret    
  802989:	8d 76 00             	lea    0x0(%esi),%esi
  80298c:	2b 04 24             	sub    (%esp),%eax
  80298f:	19 fa                	sbb    %edi,%edx
  802991:	89 d1                	mov    %edx,%ecx
  802993:	89 c6                	mov    %eax,%esi
  802995:	e9 71 ff ff ff       	jmp    80290b <__umoddi3+0xb3>
  80299a:	66 90                	xchg   %ax,%ax
  80299c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8029a0:	72 ea                	jb     80298c <__umoddi3+0x134>
  8029a2:	89 d9                	mov    %ebx,%ecx
  8029a4:	e9 62 ff ff ff       	jmp    80290b <__umoddi3+0xb3>
