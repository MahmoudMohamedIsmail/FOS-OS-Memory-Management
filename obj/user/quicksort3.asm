
obj/user/quicksort3:     file format elf32-i386


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
  800031:	e8 c9 05 00 00       	call   8005ff <libmain>
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
	//int InitFreeFrames = sys_calculate_free_frames() ;
	char Line[255] ;
	char Chose ;
	int Iteration = 0 ;
  800042:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	do
	{
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames();
  800049:	e8 f6 22 00 00       	call   802344 <sys_calculate_free_frames>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	e8 08 23 00 00       	call   80235d <sys_calculate_modified_frames>
  800055:	01 d8                	add    %ebx,%eax
  800057:	89 45 f0             	mov    %eax,-0x10(%ebp)

		Iteration++ ;
  80005a:	ff 45 f4             	incl   -0xc(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

	sys_disable_interrupt();
  80005d:	e8 7e 23 00 00       	call   8023e0 <sys_disable_interrupt>
		readline("Enter the number of elements: ", Line);
  800062:	83 ec 08             	sub    $0x8,%esp
  800065:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  80006b:	50                   	push   %eax
  80006c:	68 e0 29 80 00       	push   $0x8029e0
  800071:	e8 f0 0d 00 00       	call   800e66 <readline>
  800076:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  800079:	83 ec 04             	sub    $0x4,%esp
  80007c:	6a 0a                	push   $0xa
  80007e:	6a 00                	push   $0x0
  800080:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800086:	50                   	push   %eax
  800087:	e8 40 13 00 00       	call   8013cc <strtol>
  80008c:	83 c4 10             	add    $0x10,%esp
  80008f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  800092:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800095:	c1 e0 02             	shl    $0x2,%eax
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	50                   	push   %eax
  80009c:	e8 d3 16 00 00       	call   801774 <malloc>
  8000a1:	83 c4 10             	add    $0x10,%esp
  8000a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Elements[NumOfElements] = 10 ;
  8000a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000b4:	01 d0                	add    %edx,%eax
  8000b6:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
		//		cprintf("Free Frames After Allocation = %d\n", sys_calculate_free_frames()) ;
		cprintf("Choose the initialization method:\n") ;
  8000bc:	83 ec 0c             	sub    $0xc,%esp
  8000bf:	68 00 2a 80 00       	push   $0x802a00
  8000c4:	e8 22 07 00 00       	call   8007eb <cprintf>
  8000c9:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	68 23 2a 80 00       	push   $0x802a23
  8000d4:	e8 12 07 00 00       	call   8007eb <cprintf>
  8000d9:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	68 31 2a 80 00       	push   $0x802a31
  8000e4:	e8 02 07 00 00       	call   8007eb <cprintf>
  8000e9:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\nSelect: ") ;
  8000ec:	83 ec 0c             	sub    $0xc,%esp
  8000ef:	68 40 2a 80 00       	push   $0x802a40
  8000f4:	e8 f2 06 00 00       	call   8007eb <cprintf>
  8000f9:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  8000fc:	e8 a6 04 00 00       	call   8005a7 <getchar>
  800101:	88 45 e7             	mov    %al,-0x19(%ebp)
		cputchar(Chose);
  800104:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800108:	83 ec 0c             	sub    $0xc,%esp
  80010b:	50                   	push   %eax
  80010c:	e8 4e 04 00 00       	call   80055f <cputchar>
  800111:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	6a 0a                	push   $0xa
  800119:	e8 41 04 00 00       	call   80055f <cputchar>
  80011e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800121:	e8 d4 22 00 00       	call   8023fa <sys_enable_interrupt>
		int  i ;
		switch (Chose)
  800126:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  80012a:	83 f8 62             	cmp    $0x62,%eax
  80012d:	74 1d                	je     80014c <_main+0x114>
  80012f:	83 f8 63             	cmp    $0x63,%eax
  800132:	74 2b                	je     80015f <_main+0x127>
  800134:	83 f8 61             	cmp    $0x61,%eax
  800137:	75 39                	jne    800172 <_main+0x13a>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  800139:	83 ec 08             	sub    $0x8,%esp
  80013c:	ff 75 ec             	pushl  -0x14(%ebp)
  80013f:	ff 75 e8             	pushl  -0x18(%ebp)
  800142:	e8 e0 02 00 00       	call   800427 <InitializeAscending>
  800147:	83 c4 10             	add    $0x10,%esp
			break ;
  80014a:	eb 37                	jmp    800183 <_main+0x14b>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80014c:	83 ec 08             	sub    $0x8,%esp
  80014f:	ff 75 ec             	pushl  -0x14(%ebp)
  800152:	ff 75 e8             	pushl  -0x18(%ebp)
  800155:	e8 fe 02 00 00       	call   800458 <InitializeDescending>
  80015a:	83 c4 10             	add    $0x10,%esp
			break ;
  80015d:	eb 24                	jmp    800183 <_main+0x14b>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  80015f:	83 ec 08             	sub    $0x8,%esp
  800162:	ff 75 ec             	pushl  -0x14(%ebp)
  800165:	ff 75 e8             	pushl  -0x18(%ebp)
  800168:	e8 20 03 00 00       	call   80048d <InitializeSemiRandom>
  80016d:	83 c4 10             	add    $0x10,%esp
			break ;
  800170:	eb 11                	jmp    800183 <_main+0x14b>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  800172:	83 ec 08             	sub    $0x8,%esp
  800175:	ff 75 ec             	pushl  -0x14(%ebp)
  800178:	ff 75 e8             	pushl  -0x18(%ebp)
  80017b:	e8 0d 03 00 00       	call   80048d <InitializeSemiRandom>
  800180:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  800183:	83 ec 08             	sub    $0x8,%esp
  800186:	ff 75 ec             	pushl  -0x14(%ebp)
  800189:	ff 75 e8             	pushl  -0x18(%ebp)
  80018c:	e8 db 00 00 00       	call   80026c <QuickSort>
  800191:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  800194:	83 ec 08             	sub    $0x8,%esp
  800197:	ff 75 ec             	pushl  -0x14(%ebp)
  80019a:	ff 75 e8             	pushl  -0x18(%ebp)
  80019d:	e8 db 01 00 00       	call   80037d <CheckSorted>
  8001a2:	83 c4 10             	add    $0x10,%esp
  8001a5:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8001ac:	75 14                	jne    8001c2 <_main+0x18a>
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	68 58 2a 80 00       	push   $0x802a58
  8001b6:	6a 42                	push   $0x42
  8001b8:	68 7a 2a 80 00       	push   $0x802a7a
  8001bd:	e8 fe 04 00 00       	call   8006c0 <_panic>
		else
		{ 
			cprintf("\n===============================================\n") ;
  8001c2:	83 ec 0c             	sub    $0xc,%esp
  8001c5:	68 8c 2a 80 00       	push   $0x802a8c
  8001ca:	e8 1c 06 00 00       	call   8007eb <cprintf>
  8001cf:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  8001d2:	83 ec 0c             	sub    $0xc,%esp
  8001d5:	68 c0 2a 80 00       	push   $0x802ac0
  8001da:	e8 0c 06 00 00       	call   8007eb <cprintf>
  8001df:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  8001e2:	83 ec 0c             	sub    $0xc,%esp
  8001e5:	68 f4 2a 80 00       	push   $0x802af4
  8001ea:	e8 fc 05 00 00       	call   8007eb <cprintf>
  8001ef:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  8001f2:	83 ec 0c             	sub    $0xc,%esp
  8001f5:	68 26 2b 80 00       	push   $0x802b26
  8001fa:	e8 ec 05 00 00       	call   8007eb <cprintf>
  8001ff:	83 c4 10             	add    $0x10,%esp
		free(Elements) ;
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	ff 75 e8             	pushl  -0x18(%ebp)
  800208:	e8 09 1f 00 00       	call   802116 <free>
  80020d:	83 c4 10             	add    $0x10,%esp


		///========================================================================
	sys_disable_interrupt();
  800210:	e8 cb 21 00 00       	call   8023e0 <sys_disable_interrupt>
		cprintf("Do you want to repeat (y/n): ") ;
  800215:	83 ec 0c             	sub    $0xc,%esp
  800218:	68 3c 2b 80 00       	push   $0x802b3c
  80021d:	e8 c9 05 00 00       	call   8007eb <cprintf>
  800222:	83 c4 10             	add    $0x10,%esp

		Chose = getchar() ;
  800225:	e8 7d 03 00 00       	call   8005a7 <getchar>
  80022a:	88 45 e7             	mov    %al,-0x19(%ebp)
		cputchar(Chose);
  80022d:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800231:	83 ec 0c             	sub    $0xc,%esp
  800234:	50                   	push   %eax
  800235:	e8 25 03 00 00       	call   80055f <cputchar>
  80023a:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  80023d:	83 ec 0c             	sub    $0xc,%esp
  800240:	6a 0a                	push   $0xa
  800242:	e8 18 03 00 00       	call   80055f <cputchar>
  800247:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  80024a:	83 ec 0c             	sub    $0xc,%esp
  80024d:	6a 0a                	push   $0xa
  80024f:	e8 0b 03 00 00       	call   80055f <cputchar>
  800254:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800257:	e8 9e 21 00 00       	call   8023fa <sys_enable_interrupt>

	} while (Chose == 'y');
  80025c:	80 7d e7 79          	cmpb   $0x79,-0x19(%ebp)
  800260:	0f 84 e3 fd ff ff    	je     800049 <_main+0x11>

}
  800266:	90                   	nop
  800267:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80026a:	c9                   	leave  
  80026b:	c3                   	ret    

0080026c <QuickSort>:

///Quick sort 
void QuickSort(int *Elements, int NumOfElements)
{
  80026c:	55                   	push   %ebp
  80026d:	89 e5                	mov    %esp,%ebp
  80026f:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  800272:	8b 45 0c             	mov    0xc(%ebp),%eax
  800275:	48                   	dec    %eax
  800276:	50                   	push   %eax
  800277:	6a 00                	push   $0x0
  800279:	ff 75 0c             	pushl  0xc(%ebp)
  80027c:	ff 75 08             	pushl  0x8(%ebp)
  80027f:	e8 06 00 00 00       	call   80028a <QSort>
  800284:	83 c4 10             	add    $0x10,%esp
}
  800287:	90                   	nop
  800288:	c9                   	leave  
  800289:	c3                   	ret    

0080028a <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  80028a:	55                   	push   %ebp
  80028b:	89 e5                	mov    %esp,%ebp
  80028d:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  800290:	8b 45 10             	mov    0x10(%ebp),%eax
  800293:	3b 45 14             	cmp    0x14(%ebp),%eax
  800296:	0f 8d de 00 00 00    	jge    80037a <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  80029c:	8b 45 10             	mov    0x10(%ebp),%eax
  80029f:	40                   	inc    %eax
  8002a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8002a6:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002a9:	e9 80 00 00 00       	jmp    80032e <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  8002ae:	ff 45 f4             	incl   -0xc(%ebp)
  8002b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002b4:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002b7:	7f 2b                	jg     8002e4 <QSort+0x5a>
  8002b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c6:	01 d0                	add    %edx,%eax
  8002c8:	8b 10                	mov    (%eax),%edx
  8002ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002cd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d7:	01 c8                	add    %ecx,%eax
  8002d9:	8b 00                	mov    (%eax),%eax
  8002db:	39 c2                	cmp    %eax,%edx
  8002dd:	7d cf                	jge    8002ae <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002df:	eb 03                	jmp    8002e4 <QSort+0x5a>
  8002e1:	ff 4d f0             	decl   -0x10(%ebp)
  8002e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002e7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002ea:	7e 26                	jle    800312 <QSort+0x88>
  8002ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f9:	01 d0                	add    %edx,%eax
  8002fb:	8b 10                	mov    (%eax),%edx
  8002fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800300:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800307:	8b 45 08             	mov    0x8(%ebp),%eax
  80030a:	01 c8                	add    %ecx,%eax
  80030c:	8b 00                	mov    (%eax),%eax
  80030e:	39 c2                	cmp    %eax,%edx
  800310:	7e cf                	jle    8002e1 <QSort+0x57>

		if (i <= j)
  800312:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800315:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800318:	7f 14                	jg     80032e <QSort+0xa4>
		{
			Swap(Elements, i, j);
  80031a:	83 ec 04             	sub    $0x4,%esp
  80031d:	ff 75 f0             	pushl  -0x10(%ebp)
  800320:	ff 75 f4             	pushl  -0xc(%ebp)
  800323:	ff 75 08             	pushl  0x8(%ebp)
  800326:	e8 a9 00 00 00       	call   8003d4 <Swap>
  80032b:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  80032e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800331:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800334:	0f 8e 77 ff ff ff    	jle    8002b1 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80033a:	83 ec 04             	sub    $0x4,%esp
  80033d:	ff 75 f0             	pushl  -0x10(%ebp)
  800340:	ff 75 10             	pushl  0x10(%ebp)
  800343:	ff 75 08             	pushl  0x8(%ebp)
  800346:	e8 89 00 00 00       	call   8003d4 <Swap>
  80034b:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  80034e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800351:	48                   	dec    %eax
  800352:	50                   	push   %eax
  800353:	ff 75 10             	pushl  0x10(%ebp)
  800356:	ff 75 0c             	pushl  0xc(%ebp)
  800359:	ff 75 08             	pushl  0x8(%ebp)
  80035c:	e8 29 ff ff ff       	call   80028a <QSort>
  800361:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  800364:	ff 75 14             	pushl  0x14(%ebp)
  800367:	ff 75 f4             	pushl  -0xc(%ebp)
  80036a:	ff 75 0c             	pushl  0xc(%ebp)
  80036d:	ff 75 08             	pushl  0x8(%ebp)
  800370:	e8 15 ff ff ff       	call   80028a <QSort>
  800375:	83 c4 10             	add    $0x10,%esp
  800378:	eb 01                	jmp    80037b <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  80037a:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  80037b:	c9                   	leave  
  80037c:	c3                   	ret    

0080037d <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  80037d:	55                   	push   %ebp
  80037e:	89 e5                	mov    %esp,%ebp
  800380:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  800383:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80038a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800391:	eb 33                	jmp    8003c6 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  800393:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800396:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80039d:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a0:	01 d0                	add    %edx,%eax
  8003a2:	8b 10                	mov    (%eax),%edx
  8003a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003a7:	40                   	inc    %eax
  8003a8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003af:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b2:	01 c8                	add    %ecx,%eax
  8003b4:	8b 00                	mov    (%eax),%eax
  8003b6:	39 c2                	cmp    %eax,%edx
  8003b8:	7e 09                	jle    8003c3 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8003c1:	eb 0c                	jmp    8003cf <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003c3:	ff 45 f8             	incl   -0x8(%ebp)
  8003c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c9:	48                   	dec    %eax
  8003ca:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8003cd:	7f c4                	jg     800393 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8003cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8003d2:	c9                   	leave  
  8003d3:	c3                   	ret    

008003d4 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8003da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e7:	01 d0                	add    %edx,%eax
  8003e9:	8b 00                	mov    (%eax),%eax
  8003eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8003ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fb:	01 c2                	add    %eax,%edx
  8003fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800400:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800407:	8b 45 08             	mov    0x8(%ebp),%eax
  80040a:	01 c8                	add    %ecx,%eax
  80040c:	8b 00                	mov    (%eax),%eax
  80040e:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800410:	8b 45 10             	mov    0x10(%ebp),%eax
  800413:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80041a:	8b 45 08             	mov    0x8(%ebp),%eax
  80041d:	01 c2                	add    %eax,%edx
  80041f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800422:	89 02                	mov    %eax,(%edx)
}
  800424:	90                   	nop
  800425:	c9                   	leave  
  800426:	c3                   	ret    

00800427 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800427:	55                   	push   %ebp
  800428:	89 e5                	mov    %esp,%ebp
  80042a:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80042d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800434:	eb 17                	jmp    80044d <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800436:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800439:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800440:	8b 45 08             	mov    0x8(%ebp),%eax
  800443:	01 c2                	add    %eax,%edx
  800445:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800448:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80044a:	ff 45 fc             	incl   -0x4(%ebp)
  80044d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800450:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800453:	7c e1                	jl     800436 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  800455:	90                   	nop
  800456:	c9                   	leave  
  800457:	c3                   	ret    

00800458 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  800458:	55                   	push   %ebp
  800459:	89 e5                	mov    %esp,%ebp
  80045b:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80045e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800465:	eb 1b                	jmp    800482 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800467:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80046a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800471:	8b 45 08             	mov    0x8(%ebp),%eax
  800474:	01 c2                	add    %eax,%edx
  800476:	8b 45 0c             	mov    0xc(%ebp),%eax
  800479:	2b 45 fc             	sub    -0x4(%ebp),%eax
  80047c:	48                   	dec    %eax
  80047d:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80047f:	ff 45 fc             	incl   -0x4(%ebp)
  800482:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800485:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800488:	7c dd                	jl     800467 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  80048a:	90                   	nop
  80048b:	c9                   	leave  
  80048c:	c3                   	ret    

0080048d <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  80048d:	55                   	push   %ebp
  80048e:	89 e5                	mov    %esp,%ebp
  800490:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  800493:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800496:	b8 56 55 55 55       	mov    $0x55555556,%eax
  80049b:	f7 e9                	imul   %ecx
  80049d:	c1 f9 1f             	sar    $0x1f,%ecx
  8004a0:	89 d0                	mov    %edx,%eax
  8004a2:	29 c8                	sub    %ecx,%eax
  8004a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8004a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004ae:	eb 1e                	jmp    8004ce <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8004b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8004c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004c3:	99                   	cltd   
  8004c4:	f7 7d f8             	idivl  -0x8(%ebp)
  8004c7:	89 d0                	mov    %edx,%eax
  8004c9:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004cb:	ff 45 fc             	incl   -0x4(%ebp)
  8004ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004d1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004d4:	7c da                	jl     8004b0 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
	}

}
  8004d6:	90                   	nop
  8004d7:	c9                   	leave  
  8004d8:	c3                   	ret    

008004d9 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  8004d9:	55                   	push   %ebp
  8004da:	89 e5                	mov    %esp,%ebp
  8004dc:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  8004df:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8004e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8004ed:	eb 42                	jmp    800531 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  8004ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004f2:	99                   	cltd   
  8004f3:	f7 7d f0             	idivl  -0x10(%ebp)
  8004f6:	89 d0                	mov    %edx,%eax
  8004f8:	85 c0                	test   %eax,%eax
  8004fa:	75 10                	jne    80050c <PrintElements+0x33>
			cprintf("\n");
  8004fc:	83 ec 0c             	sub    $0xc,%esp
  8004ff:	68 5a 2b 80 00       	push   $0x802b5a
  800504:	e8 e2 02 00 00       	call   8007eb <cprintf>
  800509:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80050c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80050f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800516:	8b 45 08             	mov    0x8(%ebp),%eax
  800519:	01 d0                	add    %edx,%eax
  80051b:	8b 00                	mov    (%eax),%eax
  80051d:	83 ec 08             	sub    $0x8,%esp
  800520:	50                   	push   %eax
  800521:	68 5c 2b 80 00       	push   $0x802b5c
  800526:	e8 c0 02 00 00       	call   8007eb <cprintf>
  80052b:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80052e:	ff 45 f4             	incl   -0xc(%ebp)
  800531:	8b 45 0c             	mov    0xc(%ebp),%eax
  800534:	48                   	dec    %eax
  800535:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800538:	7f b5                	jg     8004ef <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80053a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80053d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800544:	8b 45 08             	mov    0x8(%ebp),%eax
  800547:	01 d0                	add    %edx,%eax
  800549:	8b 00                	mov    (%eax),%eax
  80054b:	83 ec 08             	sub    $0x8,%esp
  80054e:	50                   	push   %eax
  80054f:	68 61 2b 80 00       	push   $0x802b61
  800554:	e8 92 02 00 00       	call   8007eb <cprintf>
  800559:	83 c4 10             	add    $0x10,%esp

}
  80055c:	90                   	nop
  80055d:	c9                   	leave  
  80055e:	c3                   	ret    

0080055f <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  80055f:	55                   	push   %ebp
  800560:	89 e5                	mov    %esp,%ebp
  800562:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800565:	8b 45 08             	mov    0x8(%ebp),%eax
  800568:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80056b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80056f:	83 ec 0c             	sub    $0xc,%esp
  800572:	50                   	push   %eax
  800573:	e8 9c 1e 00 00       	call   802414 <sys_cputc>
  800578:	83 c4 10             	add    $0x10,%esp
}
  80057b:	90                   	nop
  80057c:	c9                   	leave  
  80057d:	c3                   	ret    

0080057e <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  80057e:	55                   	push   %ebp
  80057f:	89 e5                	mov    %esp,%ebp
  800581:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800584:	e8 57 1e 00 00       	call   8023e0 <sys_disable_interrupt>
	char c = ch;
  800589:	8b 45 08             	mov    0x8(%ebp),%eax
  80058c:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80058f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800593:	83 ec 0c             	sub    $0xc,%esp
  800596:	50                   	push   %eax
  800597:	e8 78 1e 00 00       	call   802414 <sys_cputc>
  80059c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80059f:	e8 56 1e 00 00       	call   8023fa <sys_enable_interrupt>
}
  8005a4:	90                   	nop
  8005a5:	c9                   	leave  
  8005a6:	c3                   	ret    

008005a7 <getchar>:

int
getchar(void)
{
  8005a7:	55                   	push   %ebp
  8005a8:	89 e5                	mov    %esp,%ebp
  8005aa:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8005ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005b4:	eb 08                	jmp    8005be <getchar+0x17>
	{
		c = sys_cgetc();
  8005b6:	e8 a3 1c 00 00       	call   80225e <sys_cgetc>
  8005bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  8005be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8005c2:	74 f2                	je     8005b6 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  8005c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005c7:	c9                   	leave  
  8005c8:	c3                   	ret    

008005c9 <atomic_getchar>:

int
atomic_getchar(void)
{
  8005c9:	55                   	push   %ebp
  8005ca:	89 e5                	mov    %esp,%ebp
  8005cc:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005cf:	e8 0c 1e 00 00       	call   8023e0 <sys_disable_interrupt>
	int c=0;
  8005d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005db:	eb 08                	jmp    8005e5 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8005dd:	e8 7c 1c 00 00       	call   80225e <sys_cgetc>
  8005e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8005e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8005e9:	74 f2                	je     8005dd <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8005eb:	e8 0a 1e 00 00       	call   8023fa <sys_enable_interrupt>
	return c;
  8005f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005f3:	c9                   	leave  
  8005f4:	c3                   	ret    

008005f5 <iscons>:

int iscons(int fdnum)
{
  8005f5:	55                   	push   %ebp
  8005f6:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8005f8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8005fd:	5d                   	pop    %ebp
  8005fe:	c3                   	ret    

008005ff <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005ff:	55                   	push   %ebp
  800600:	89 e5                	mov    %esp,%ebp
  800602:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800605:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800609:	7e 0a                	jle    800615 <libmain+0x16>
		binaryname = argv[0];
  80060b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80060e:	8b 00                	mov    (%eax),%eax
  800610:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800615:	83 ec 08             	sub    $0x8,%esp
  800618:	ff 75 0c             	pushl  0xc(%ebp)
  80061b:	ff 75 08             	pushl  0x8(%ebp)
  80061e:	e8 15 fa ff ff       	call   800038 <_main>
  800623:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  800626:	e8 67 1c 00 00       	call   802292 <sys_getenvid>
  80062b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  80062e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800631:	89 d0                	mov    %edx,%eax
  800633:	c1 e0 03             	shl    $0x3,%eax
  800636:	01 d0                	add    %edx,%eax
  800638:	01 c0                	add    %eax,%eax
  80063a:	01 d0                	add    %edx,%eax
  80063c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800643:	01 d0                	add    %edx,%eax
  800645:	c1 e0 03             	shl    $0x3,%eax
  800648:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80064d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  800650:	e8 8b 1d 00 00       	call   8023e0 <sys_disable_interrupt>
		cprintf("**************************************\n");
  800655:	83 ec 0c             	sub    $0xc,%esp
  800658:	68 80 2b 80 00       	push   $0x802b80
  80065d:	e8 89 01 00 00       	call   8007eb <cprintf>
  800662:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  800665:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800668:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  80066e:	83 ec 08             	sub    $0x8,%esp
  800671:	50                   	push   %eax
  800672:	68 a8 2b 80 00       	push   $0x802ba8
  800677:	e8 6f 01 00 00       	call   8007eb <cprintf>
  80067c:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80067f:	83 ec 0c             	sub    $0xc,%esp
  800682:	68 80 2b 80 00       	push   $0x802b80
  800687:	e8 5f 01 00 00       	call   8007eb <cprintf>
  80068c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80068f:	e8 66 1d 00 00       	call   8023fa <sys_enable_interrupt>

	// exit gracefully
	exit();
  800694:	e8 19 00 00 00       	call   8006b2 <exit>
}
  800699:	90                   	nop
  80069a:	c9                   	leave  
  80069b:	c3                   	ret    

0080069c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80069c:	55                   	push   %ebp
  80069d:	89 e5                	mov    %esp,%ebp
  80069f:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8006a2:	83 ec 0c             	sub    $0xc,%esp
  8006a5:	6a 00                	push   $0x0
  8006a7:	e8 cb 1b 00 00       	call   802277 <sys_env_destroy>
  8006ac:	83 c4 10             	add    $0x10,%esp
}
  8006af:	90                   	nop
  8006b0:	c9                   	leave  
  8006b1:	c3                   	ret    

008006b2 <exit>:

void
exit(void)
{
  8006b2:	55                   	push   %ebp
  8006b3:	89 e5                	mov    %esp,%ebp
  8006b5:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8006b8:	e8 ee 1b 00 00       	call   8022ab <sys_env_exit>
}
  8006bd:	90                   	nop
  8006be:	c9                   	leave  
  8006bf:	c3                   	ret    

008006c0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006c0:	55                   	push   %ebp
  8006c1:	89 e5                	mov    %esp,%ebp
  8006c3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8006c6:	8d 45 10             	lea    0x10(%ebp),%eax
  8006c9:	83 c0 04             	add    $0x4,%eax
  8006cc:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  8006cf:	a1 70 30 98 00       	mov    0x983070,%eax
  8006d4:	85 c0                	test   %eax,%eax
  8006d6:	74 16                	je     8006ee <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006d8:	a1 70 30 98 00       	mov    0x983070,%eax
  8006dd:	83 ec 08             	sub    $0x8,%esp
  8006e0:	50                   	push   %eax
  8006e1:	68 c1 2b 80 00       	push   $0x802bc1
  8006e6:	e8 00 01 00 00       	call   8007eb <cprintf>
  8006eb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006ee:	a1 00 30 80 00       	mov    0x803000,%eax
  8006f3:	ff 75 0c             	pushl  0xc(%ebp)
  8006f6:	ff 75 08             	pushl  0x8(%ebp)
  8006f9:	50                   	push   %eax
  8006fa:	68 c6 2b 80 00       	push   $0x802bc6
  8006ff:	e8 e7 00 00 00       	call   8007eb <cprintf>
  800704:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800707:	8b 45 10             	mov    0x10(%ebp),%eax
  80070a:	83 ec 08             	sub    $0x8,%esp
  80070d:	ff 75 f4             	pushl  -0xc(%ebp)
  800710:	50                   	push   %eax
  800711:	e8 7a 00 00 00       	call   800790 <vcprintf>
  800716:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  800719:	83 ec 0c             	sub    $0xc,%esp
  80071c:	68 e2 2b 80 00       	push   $0x802be2
  800721:	e8 c5 00 00 00       	call   8007eb <cprintf>
  800726:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800729:	e8 84 ff ff ff       	call   8006b2 <exit>

	// should not return here
	while (1) ;
  80072e:	eb fe                	jmp    80072e <_panic+0x6e>

00800730 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800730:	55                   	push   %ebp
  800731:	89 e5                	mov    %esp,%ebp
  800733:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800736:	8b 45 0c             	mov    0xc(%ebp),%eax
  800739:	8b 00                	mov    (%eax),%eax
  80073b:	8d 48 01             	lea    0x1(%eax),%ecx
  80073e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800741:	89 0a                	mov    %ecx,(%edx)
  800743:	8b 55 08             	mov    0x8(%ebp),%edx
  800746:	88 d1                	mov    %dl,%cl
  800748:	8b 55 0c             	mov    0xc(%ebp),%edx
  80074b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80074f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800752:	8b 00                	mov    (%eax),%eax
  800754:	3d ff 00 00 00       	cmp    $0xff,%eax
  800759:	75 23                	jne    80077e <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  80075b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80075e:	8b 00                	mov    (%eax),%eax
  800760:	89 c2                	mov    %eax,%edx
  800762:	8b 45 0c             	mov    0xc(%ebp),%eax
  800765:	83 c0 08             	add    $0x8,%eax
  800768:	83 ec 08             	sub    $0x8,%esp
  80076b:	52                   	push   %edx
  80076c:	50                   	push   %eax
  80076d:	e8 cf 1a 00 00       	call   802241 <sys_cputs>
  800772:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800775:	8b 45 0c             	mov    0xc(%ebp),%eax
  800778:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80077e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800781:	8b 40 04             	mov    0x4(%eax),%eax
  800784:	8d 50 01             	lea    0x1(%eax),%edx
  800787:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80078d:	90                   	nop
  80078e:	c9                   	leave  
  80078f:	c3                   	ret    

00800790 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800790:	55                   	push   %ebp
  800791:	89 e5                	mov    %esp,%ebp
  800793:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800799:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007a0:	00 00 00 
	b.cnt = 0;
  8007a3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007aa:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007ad:	ff 75 0c             	pushl  0xc(%ebp)
  8007b0:	ff 75 08             	pushl  0x8(%ebp)
  8007b3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007b9:	50                   	push   %eax
  8007ba:	68 30 07 80 00       	push   $0x800730
  8007bf:	e8 fa 01 00 00       	call   8009be <vprintfmt>
  8007c4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  8007c7:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	50                   	push   %eax
  8007d1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007d7:	83 c0 08             	add    $0x8,%eax
  8007da:	50                   	push   %eax
  8007db:	e8 61 1a 00 00       	call   802241 <sys_cputs>
  8007e0:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  8007e3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007e9:	c9                   	leave  
  8007ea:	c3                   	ret    

008007eb <cprintf>:

int cprintf(const char *fmt, ...) {
  8007eb:	55                   	push   %ebp
  8007ec:	89 e5                	mov    %esp,%ebp
  8007ee:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007f1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	83 ec 08             	sub    $0x8,%esp
  8007fd:	ff 75 f4             	pushl  -0xc(%ebp)
  800800:	50                   	push   %eax
  800801:	e8 8a ff ff ff       	call   800790 <vcprintf>
  800806:	83 c4 10             	add    $0x10,%esp
  800809:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80080c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80080f:	c9                   	leave  
  800810:	c3                   	ret    

00800811 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800811:	55                   	push   %ebp
  800812:	89 e5                	mov    %esp,%ebp
  800814:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800817:	e8 c4 1b 00 00       	call   8023e0 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80081c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80081f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800822:	8b 45 08             	mov    0x8(%ebp),%eax
  800825:	83 ec 08             	sub    $0x8,%esp
  800828:	ff 75 f4             	pushl  -0xc(%ebp)
  80082b:	50                   	push   %eax
  80082c:	e8 5f ff ff ff       	call   800790 <vcprintf>
  800831:	83 c4 10             	add    $0x10,%esp
  800834:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800837:	e8 be 1b 00 00       	call   8023fa <sys_enable_interrupt>
	return cnt;
  80083c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80083f:	c9                   	leave  
  800840:	c3                   	ret    

00800841 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800841:	55                   	push   %ebp
  800842:	89 e5                	mov    %esp,%ebp
  800844:	53                   	push   %ebx
  800845:	83 ec 14             	sub    $0x14,%esp
  800848:	8b 45 10             	mov    0x10(%ebp),%eax
  80084b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80084e:	8b 45 14             	mov    0x14(%ebp),%eax
  800851:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800854:	8b 45 18             	mov    0x18(%ebp),%eax
  800857:	ba 00 00 00 00       	mov    $0x0,%edx
  80085c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80085f:	77 55                	ja     8008b6 <printnum+0x75>
  800861:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800864:	72 05                	jb     80086b <printnum+0x2a>
  800866:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800869:	77 4b                	ja     8008b6 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80086b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80086e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800871:	8b 45 18             	mov    0x18(%ebp),%eax
  800874:	ba 00 00 00 00       	mov    $0x0,%edx
  800879:	52                   	push   %edx
  80087a:	50                   	push   %eax
  80087b:	ff 75 f4             	pushl  -0xc(%ebp)
  80087e:	ff 75 f0             	pushl  -0x10(%ebp)
  800881:	e8 f6 1e 00 00       	call   80277c <__udivdi3>
  800886:	83 c4 10             	add    $0x10,%esp
  800889:	83 ec 04             	sub    $0x4,%esp
  80088c:	ff 75 20             	pushl  0x20(%ebp)
  80088f:	53                   	push   %ebx
  800890:	ff 75 18             	pushl  0x18(%ebp)
  800893:	52                   	push   %edx
  800894:	50                   	push   %eax
  800895:	ff 75 0c             	pushl  0xc(%ebp)
  800898:	ff 75 08             	pushl  0x8(%ebp)
  80089b:	e8 a1 ff ff ff       	call   800841 <printnum>
  8008a0:	83 c4 20             	add    $0x20,%esp
  8008a3:	eb 1a                	jmp    8008bf <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008a5:	83 ec 08             	sub    $0x8,%esp
  8008a8:	ff 75 0c             	pushl  0xc(%ebp)
  8008ab:	ff 75 20             	pushl  0x20(%ebp)
  8008ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b1:	ff d0                	call   *%eax
  8008b3:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008b6:	ff 4d 1c             	decl   0x1c(%ebp)
  8008b9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008bd:	7f e6                	jg     8008a5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008bf:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008c2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008cd:	53                   	push   %ebx
  8008ce:	51                   	push   %ecx
  8008cf:	52                   	push   %edx
  8008d0:	50                   	push   %eax
  8008d1:	e8 b6 1f 00 00       	call   80288c <__umoddi3>
  8008d6:	83 c4 10             	add    $0x10,%esp
  8008d9:	05 14 2e 80 00       	add    $0x802e14,%eax
  8008de:	8a 00                	mov    (%eax),%al
  8008e0:	0f be c0             	movsbl %al,%eax
  8008e3:	83 ec 08             	sub    $0x8,%esp
  8008e6:	ff 75 0c             	pushl  0xc(%ebp)
  8008e9:	50                   	push   %eax
  8008ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ed:	ff d0                	call   *%eax
  8008ef:	83 c4 10             	add    $0x10,%esp
}
  8008f2:	90                   	nop
  8008f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008f6:	c9                   	leave  
  8008f7:	c3                   	ret    

008008f8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008fb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008ff:	7e 1c                	jle    80091d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	8b 00                	mov    (%eax),%eax
  800906:	8d 50 08             	lea    0x8(%eax),%edx
  800909:	8b 45 08             	mov    0x8(%ebp),%eax
  80090c:	89 10                	mov    %edx,(%eax)
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	8b 00                	mov    (%eax),%eax
  800913:	83 e8 08             	sub    $0x8,%eax
  800916:	8b 50 04             	mov    0x4(%eax),%edx
  800919:	8b 00                	mov    (%eax),%eax
  80091b:	eb 40                	jmp    80095d <getuint+0x65>
	else if (lflag)
  80091d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800921:	74 1e                	je     800941 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	8b 00                	mov    (%eax),%eax
  800928:	8d 50 04             	lea    0x4(%eax),%edx
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	89 10                	mov    %edx,(%eax)
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	8b 00                	mov    (%eax),%eax
  800935:	83 e8 04             	sub    $0x4,%eax
  800938:	8b 00                	mov    (%eax),%eax
  80093a:	ba 00 00 00 00       	mov    $0x0,%edx
  80093f:	eb 1c                	jmp    80095d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	8d 50 04             	lea    0x4(%eax),%edx
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	89 10                	mov    %edx,(%eax)
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	8b 00                	mov    (%eax),%eax
  800953:	83 e8 04             	sub    $0x4,%eax
  800956:	8b 00                	mov    (%eax),%eax
  800958:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80095d:	5d                   	pop    %ebp
  80095e:	c3                   	ret    

0080095f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80095f:	55                   	push   %ebp
  800960:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800962:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800966:	7e 1c                	jle    800984 <getint+0x25>
		return va_arg(*ap, long long);
  800968:	8b 45 08             	mov    0x8(%ebp),%eax
  80096b:	8b 00                	mov    (%eax),%eax
  80096d:	8d 50 08             	lea    0x8(%eax),%edx
  800970:	8b 45 08             	mov    0x8(%ebp),%eax
  800973:	89 10                	mov    %edx,(%eax)
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	8b 00                	mov    (%eax),%eax
  80097a:	83 e8 08             	sub    $0x8,%eax
  80097d:	8b 50 04             	mov    0x4(%eax),%edx
  800980:	8b 00                	mov    (%eax),%eax
  800982:	eb 38                	jmp    8009bc <getint+0x5d>
	else if (lflag)
  800984:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800988:	74 1a                	je     8009a4 <getint+0x45>
		return va_arg(*ap, long);
  80098a:	8b 45 08             	mov    0x8(%ebp),%eax
  80098d:	8b 00                	mov    (%eax),%eax
  80098f:	8d 50 04             	lea    0x4(%eax),%edx
  800992:	8b 45 08             	mov    0x8(%ebp),%eax
  800995:	89 10                	mov    %edx,(%eax)
  800997:	8b 45 08             	mov    0x8(%ebp),%eax
  80099a:	8b 00                	mov    (%eax),%eax
  80099c:	83 e8 04             	sub    $0x4,%eax
  80099f:	8b 00                	mov    (%eax),%eax
  8009a1:	99                   	cltd   
  8009a2:	eb 18                	jmp    8009bc <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a7:	8b 00                	mov    (%eax),%eax
  8009a9:	8d 50 04             	lea    0x4(%eax),%edx
  8009ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8009af:	89 10                	mov    %edx,(%eax)
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	8b 00                	mov    (%eax),%eax
  8009b6:	83 e8 04             	sub    $0x4,%eax
  8009b9:	8b 00                	mov    (%eax),%eax
  8009bb:	99                   	cltd   
}
  8009bc:	5d                   	pop    %ebp
  8009bd:	c3                   	ret    

008009be <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009be:	55                   	push   %ebp
  8009bf:	89 e5                	mov    %esp,%ebp
  8009c1:	56                   	push   %esi
  8009c2:	53                   	push   %ebx
  8009c3:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009c6:	eb 17                	jmp    8009df <vprintfmt+0x21>
			if (ch == '\0')
  8009c8:	85 db                	test   %ebx,%ebx
  8009ca:	0f 84 af 03 00 00    	je     800d7f <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8009d0:	83 ec 08             	sub    $0x8,%esp
  8009d3:	ff 75 0c             	pushl  0xc(%ebp)
  8009d6:	53                   	push   %ebx
  8009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009da:	ff d0                	call   *%eax
  8009dc:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009df:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e2:	8d 50 01             	lea    0x1(%eax),%edx
  8009e5:	89 55 10             	mov    %edx,0x10(%ebp)
  8009e8:	8a 00                	mov    (%eax),%al
  8009ea:	0f b6 d8             	movzbl %al,%ebx
  8009ed:	83 fb 25             	cmp    $0x25,%ebx
  8009f0:	75 d6                	jne    8009c8 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009f2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009f6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009fd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a04:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a0b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a12:	8b 45 10             	mov    0x10(%ebp),%eax
  800a15:	8d 50 01             	lea    0x1(%eax),%edx
  800a18:	89 55 10             	mov    %edx,0x10(%ebp)
  800a1b:	8a 00                	mov    (%eax),%al
  800a1d:	0f b6 d8             	movzbl %al,%ebx
  800a20:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a23:	83 f8 55             	cmp    $0x55,%eax
  800a26:	0f 87 2b 03 00 00    	ja     800d57 <vprintfmt+0x399>
  800a2c:	8b 04 85 38 2e 80 00 	mov    0x802e38(,%eax,4),%eax
  800a33:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a35:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a39:	eb d7                	jmp    800a12 <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a3b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a3f:	eb d1                	jmp    800a12 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a41:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a48:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a4b:	89 d0                	mov    %edx,%eax
  800a4d:	c1 e0 02             	shl    $0x2,%eax
  800a50:	01 d0                	add    %edx,%eax
  800a52:	01 c0                	add    %eax,%eax
  800a54:	01 d8                	add    %ebx,%eax
  800a56:	83 e8 30             	sub    $0x30,%eax
  800a59:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a5f:	8a 00                	mov    (%eax),%al
  800a61:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a64:	83 fb 2f             	cmp    $0x2f,%ebx
  800a67:	7e 3e                	jle    800aa7 <vprintfmt+0xe9>
  800a69:	83 fb 39             	cmp    $0x39,%ebx
  800a6c:	7f 39                	jg     800aa7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a6e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a71:	eb d5                	jmp    800a48 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a73:	8b 45 14             	mov    0x14(%ebp),%eax
  800a76:	83 c0 04             	add    $0x4,%eax
  800a79:	89 45 14             	mov    %eax,0x14(%ebp)
  800a7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7f:	83 e8 04             	sub    $0x4,%eax
  800a82:	8b 00                	mov    (%eax),%eax
  800a84:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a87:	eb 1f                	jmp    800aa8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a89:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a8d:	79 83                	jns    800a12 <vprintfmt+0x54>
				width = 0;
  800a8f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a96:	e9 77 ff ff ff       	jmp    800a12 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a9b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800aa2:	e9 6b ff ff ff       	jmp    800a12 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800aa7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800aa8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aac:	0f 89 60 ff ff ff    	jns    800a12 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ab2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ab5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ab8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800abf:	e9 4e ff ff ff       	jmp    800a12 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ac4:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ac7:	e9 46 ff ff ff       	jmp    800a12 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800acc:	8b 45 14             	mov    0x14(%ebp),%eax
  800acf:	83 c0 04             	add    $0x4,%eax
  800ad2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad8:	83 e8 04             	sub    $0x4,%eax
  800adb:	8b 00                	mov    (%eax),%eax
  800add:	83 ec 08             	sub    $0x8,%esp
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	50                   	push   %eax
  800ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae7:	ff d0                	call   *%eax
  800ae9:	83 c4 10             	add    $0x10,%esp
			break;
  800aec:	e9 89 02 00 00       	jmp    800d7a <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800af1:	8b 45 14             	mov    0x14(%ebp),%eax
  800af4:	83 c0 04             	add    $0x4,%eax
  800af7:	89 45 14             	mov    %eax,0x14(%ebp)
  800afa:	8b 45 14             	mov    0x14(%ebp),%eax
  800afd:	83 e8 04             	sub    $0x4,%eax
  800b00:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b02:	85 db                	test   %ebx,%ebx
  800b04:	79 02                	jns    800b08 <vprintfmt+0x14a>
				err = -err;
  800b06:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b08:	83 fb 64             	cmp    $0x64,%ebx
  800b0b:	7f 0b                	jg     800b18 <vprintfmt+0x15a>
  800b0d:	8b 34 9d 80 2c 80 00 	mov    0x802c80(,%ebx,4),%esi
  800b14:	85 f6                	test   %esi,%esi
  800b16:	75 19                	jne    800b31 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b18:	53                   	push   %ebx
  800b19:	68 25 2e 80 00       	push   $0x802e25
  800b1e:	ff 75 0c             	pushl  0xc(%ebp)
  800b21:	ff 75 08             	pushl  0x8(%ebp)
  800b24:	e8 5e 02 00 00       	call   800d87 <printfmt>
  800b29:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b2c:	e9 49 02 00 00       	jmp    800d7a <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b31:	56                   	push   %esi
  800b32:	68 2e 2e 80 00       	push   $0x802e2e
  800b37:	ff 75 0c             	pushl  0xc(%ebp)
  800b3a:	ff 75 08             	pushl  0x8(%ebp)
  800b3d:	e8 45 02 00 00       	call   800d87 <printfmt>
  800b42:	83 c4 10             	add    $0x10,%esp
			break;
  800b45:	e9 30 02 00 00       	jmp    800d7a <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4d:	83 c0 04             	add    $0x4,%eax
  800b50:	89 45 14             	mov    %eax,0x14(%ebp)
  800b53:	8b 45 14             	mov    0x14(%ebp),%eax
  800b56:	83 e8 04             	sub    $0x4,%eax
  800b59:	8b 30                	mov    (%eax),%esi
  800b5b:	85 f6                	test   %esi,%esi
  800b5d:	75 05                	jne    800b64 <vprintfmt+0x1a6>
				p = "(null)";
  800b5f:	be 31 2e 80 00       	mov    $0x802e31,%esi
			if (width > 0 && padc != '-')
  800b64:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b68:	7e 6d                	jle    800bd7 <vprintfmt+0x219>
  800b6a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b6e:	74 67                	je     800bd7 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b73:	83 ec 08             	sub    $0x8,%esp
  800b76:	50                   	push   %eax
  800b77:	56                   	push   %esi
  800b78:	e8 12 05 00 00       	call   80108f <strnlen>
  800b7d:	83 c4 10             	add    $0x10,%esp
  800b80:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b83:	eb 16                	jmp    800b9b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b85:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b89:	83 ec 08             	sub    $0x8,%esp
  800b8c:	ff 75 0c             	pushl  0xc(%ebp)
  800b8f:	50                   	push   %eax
  800b90:	8b 45 08             	mov    0x8(%ebp),%eax
  800b93:	ff d0                	call   *%eax
  800b95:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b98:	ff 4d e4             	decl   -0x1c(%ebp)
  800b9b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b9f:	7f e4                	jg     800b85 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ba1:	eb 34                	jmp    800bd7 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800ba3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ba7:	74 1c                	je     800bc5 <vprintfmt+0x207>
  800ba9:	83 fb 1f             	cmp    $0x1f,%ebx
  800bac:	7e 05                	jle    800bb3 <vprintfmt+0x1f5>
  800bae:	83 fb 7e             	cmp    $0x7e,%ebx
  800bb1:	7e 12                	jle    800bc5 <vprintfmt+0x207>
					putch('?', putdat);
  800bb3:	83 ec 08             	sub    $0x8,%esp
  800bb6:	ff 75 0c             	pushl  0xc(%ebp)
  800bb9:	6a 3f                	push   $0x3f
  800bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbe:	ff d0                	call   *%eax
  800bc0:	83 c4 10             	add    $0x10,%esp
  800bc3:	eb 0f                	jmp    800bd4 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800bc5:	83 ec 08             	sub    $0x8,%esp
  800bc8:	ff 75 0c             	pushl  0xc(%ebp)
  800bcb:	53                   	push   %ebx
  800bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcf:	ff d0                	call   *%eax
  800bd1:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bd4:	ff 4d e4             	decl   -0x1c(%ebp)
  800bd7:	89 f0                	mov    %esi,%eax
  800bd9:	8d 70 01             	lea    0x1(%eax),%esi
  800bdc:	8a 00                	mov    (%eax),%al
  800bde:	0f be d8             	movsbl %al,%ebx
  800be1:	85 db                	test   %ebx,%ebx
  800be3:	74 24                	je     800c09 <vprintfmt+0x24b>
  800be5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800be9:	78 b8                	js     800ba3 <vprintfmt+0x1e5>
  800beb:	ff 4d e0             	decl   -0x20(%ebp)
  800bee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bf2:	79 af                	jns    800ba3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bf4:	eb 13                	jmp    800c09 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bf6:	83 ec 08             	sub    $0x8,%esp
  800bf9:	ff 75 0c             	pushl  0xc(%ebp)
  800bfc:	6a 20                	push   $0x20
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	ff d0                	call   *%eax
  800c03:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c06:	ff 4d e4             	decl   -0x1c(%ebp)
  800c09:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c0d:	7f e7                	jg     800bf6 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c0f:	e9 66 01 00 00       	jmp    800d7a <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c14:	83 ec 08             	sub    $0x8,%esp
  800c17:	ff 75 e8             	pushl  -0x18(%ebp)
  800c1a:	8d 45 14             	lea    0x14(%ebp),%eax
  800c1d:	50                   	push   %eax
  800c1e:	e8 3c fd ff ff       	call   80095f <getint>
  800c23:	83 c4 10             	add    $0x10,%esp
  800c26:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c29:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c32:	85 d2                	test   %edx,%edx
  800c34:	79 23                	jns    800c59 <vprintfmt+0x29b>
				putch('-', putdat);
  800c36:	83 ec 08             	sub    $0x8,%esp
  800c39:	ff 75 0c             	pushl  0xc(%ebp)
  800c3c:	6a 2d                	push   $0x2d
  800c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c41:	ff d0                	call   *%eax
  800c43:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c4c:	f7 d8                	neg    %eax
  800c4e:	83 d2 00             	adc    $0x0,%edx
  800c51:	f7 da                	neg    %edx
  800c53:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c56:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c59:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c60:	e9 bc 00 00 00       	jmp    800d21 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c65:	83 ec 08             	sub    $0x8,%esp
  800c68:	ff 75 e8             	pushl  -0x18(%ebp)
  800c6b:	8d 45 14             	lea    0x14(%ebp),%eax
  800c6e:	50                   	push   %eax
  800c6f:	e8 84 fc ff ff       	call   8008f8 <getuint>
  800c74:	83 c4 10             	add    $0x10,%esp
  800c77:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c7a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c7d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c84:	e9 98 00 00 00       	jmp    800d21 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c89:	83 ec 08             	sub    $0x8,%esp
  800c8c:	ff 75 0c             	pushl  0xc(%ebp)
  800c8f:	6a 58                	push   $0x58
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	ff d0                	call   *%eax
  800c96:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c99:	83 ec 08             	sub    $0x8,%esp
  800c9c:	ff 75 0c             	pushl  0xc(%ebp)
  800c9f:	6a 58                	push   $0x58
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	ff d0                	call   *%eax
  800ca6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ca9:	83 ec 08             	sub    $0x8,%esp
  800cac:	ff 75 0c             	pushl  0xc(%ebp)
  800caf:	6a 58                	push   $0x58
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	ff d0                	call   *%eax
  800cb6:	83 c4 10             	add    $0x10,%esp
			break;
  800cb9:	e9 bc 00 00 00       	jmp    800d7a <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800cbe:	83 ec 08             	sub    $0x8,%esp
  800cc1:	ff 75 0c             	pushl  0xc(%ebp)
  800cc4:	6a 30                	push   $0x30
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	ff d0                	call   *%eax
  800ccb:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800cce:	83 ec 08             	sub    $0x8,%esp
  800cd1:	ff 75 0c             	pushl  0xc(%ebp)
  800cd4:	6a 78                	push   $0x78
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	ff d0                	call   *%eax
  800cdb:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cde:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce1:	83 c0 04             	add    $0x4,%eax
  800ce4:	89 45 14             	mov    %eax,0x14(%ebp)
  800ce7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cea:	83 e8 04             	sub    $0x4,%eax
  800ced:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cf2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cf9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d00:	eb 1f                	jmp    800d21 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d02:	83 ec 08             	sub    $0x8,%esp
  800d05:	ff 75 e8             	pushl  -0x18(%ebp)
  800d08:	8d 45 14             	lea    0x14(%ebp),%eax
  800d0b:	50                   	push   %eax
  800d0c:	e8 e7 fb ff ff       	call   8008f8 <getuint>
  800d11:	83 c4 10             	add    $0x10,%esp
  800d14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d17:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d1a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d21:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d28:	83 ec 04             	sub    $0x4,%esp
  800d2b:	52                   	push   %edx
  800d2c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d2f:	50                   	push   %eax
  800d30:	ff 75 f4             	pushl  -0xc(%ebp)
  800d33:	ff 75 f0             	pushl  -0x10(%ebp)
  800d36:	ff 75 0c             	pushl  0xc(%ebp)
  800d39:	ff 75 08             	pushl  0x8(%ebp)
  800d3c:	e8 00 fb ff ff       	call   800841 <printnum>
  800d41:	83 c4 20             	add    $0x20,%esp
			break;
  800d44:	eb 34                	jmp    800d7a <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d46:	83 ec 08             	sub    $0x8,%esp
  800d49:	ff 75 0c             	pushl  0xc(%ebp)
  800d4c:	53                   	push   %ebx
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	ff d0                	call   *%eax
  800d52:	83 c4 10             	add    $0x10,%esp
			break;
  800d55:	eb 23                	jmp    800d7a <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d57:	83 ec 08             	sub    $0x8,%esp
  800d5a:	ff 75 0c             	pushl  0xc(%ebp)
  800d5d:	6a 25                	push   $0x25
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	ff d0                	call   *%eax
  800d64:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d67:	ff 4d 10             	decl   0x10(%ebp)
  800d6a:	eb 03                	jmp    800d6f <vprintfmt+0x3b1>
  800d6c:	ff 4d 10             	decl   0x10(%ebp)
  800d6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d72:	48                   	dec    %eax
  800d73:	8a 00                	mov    (%eax),%al
  800d75:	3c 25                	cmp    $0x25,%al
  800d77:	75 f3                	jne    800d6c <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d79:	90                   	nop
		}
	}
  800d7a:	e9 47 fc ff ff       	jmp    8009c6 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d7f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d80:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d83:	5b                   	pop    %ebx
  800d84:	5e                   	pop    %esi
  800d85:	5d                   	pop    %ebp
  800d86:	c3                   	ret    

00800d87 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
  800d8a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d8d:	8d 45 10             	lea    0x10(%ebp),%eax
  800d90:	83 c0 04             	add    $0x4,%eax
  800d93:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d96:	8b 45 10             	mov    0x10(%ebp),%eax
  800d99:	ff 75 f4             	pushl  -0xc(%ebp)
  800d9c:	50                   	push   %eax
  800d9d:	ff 75 0c             	pushl  0xc(%ebp)
  800da0:	ff 75 08             	pushl  0x8(%ebp)
  800da3:	e8 16 fc ff ff       	call   8009be <vprintfmt>
  800da8:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800dab:	90                   	nop
  800dac:	c9                   	leave  
  800dad:	c3                   	ret    

00800dae <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800db1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db4:	8b 40 08             	mov    0x8(%eax),%eax
  800db7:	8d 50 01             	lea    0x1(%eax),%edx
  800dba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbd:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800dc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc3:	8b 10                	mov    (%eax),%edx
  800dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc8:	8b 40 04             	mov    0x4(%eax),%eax
  800dcb:	39 c2                	cmp    %eax,%edx
  800dcd:	73 12                	jae    800de1 <sprintputch+0x33>
		*b->buf++ = ch;
  800dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd2:	8b 00                	mov    (%eax),%eax
  800dd4:	8d 48 01             	lea    0x1(%eax),%ecx
  800dd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dda:	89 0a                	mov    %ecx,(%edx)
  800ddc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddf:	88 10                	mov    %dl,(%eax)
}
  800de1:	90                   	nop
  800de2:	5d                   	pop    %ebp
  800de3:	c3                   	ret    

00800de4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ded:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800df0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	01 d0                	add    %edx,%eax
  800dfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dfe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e05:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e09:	74 06                	je     800e11 <vsnprintf+0x2d>
  800e0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e0f:	7f 07                	jg     800e18 <vsnprintf+0x34>
		return -E_INVAL;
  800e11:	b8 03 00 00 00       	mov    $0x3,%eax
  800e16:	eb 20                	jmp    800e38 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e18:	ff 75 14             	pushl  0x14(%ebp)
  800e1b:	ff 75 10             	pushl  0x10(%ebp)
  800e1e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e21:	50                   	push   %eax
  800e22:	68 ae 0d 80 00       	push   $0x800dae
  800e27:	e8 92 fb ff ff       	call   8009be <vprintfmt>
  800e2c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e32:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e38:	c9                   	leave  
  800e39:	c3                   	ret    

00800e3a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e40:	8d 45 10             	lea    0x10(%ebp),%eax
  800e43:	83 c0 04             	add    $0x4,%eax
  800e46:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e49:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4c:	ff 75 f4             	pushl  -0xc(%ebp)
  800e4f:	50                   	push   %eax
  800e50:	ff 75 0c             	pushl  0xc(%ebp)
  800e53:	ff 75 08             	pushl  0x8(%ebp)
  800e56:	e8 89 ff ff ff       	call   800de4 <vsnprintf>
  800e5b:	83 c4 10             	add    $0x10,%esp
  800e5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e61:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e64:	c9                   	leave  
  800e65:	c3                   	ret    

00800e66 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
  800e69:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  800e6c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e70:	74 13                	je     800e85 <readline+0x1f>
		cprintf("%s", prompt);
  800e72:	83 ec 08             	sub    $0x8,%esp
  800e75:	ff 75 08             	pushl  0x8(%ebp)
  800e78:	68 90 2f 80 00       	push   $0x802f90
  800e7d:	e8 69 f9 ff ff       	call   8007eb <cprintf>
  800e82:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800e85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800e8c:	83 ec 0c             	sub    $0xc,%esp
  800e8f:	6a 00                	push   $0x0
  800e91:	e8 5f f7 ff ff       	call   8005f5 <iscons>
  800e96:	83 c4 10             	add    $0x10,%esp
  800e99:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800e9c:	e8 06 f7 ff ff       	call   8005a7 <getchar>
  800ea1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800ea4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ea8:	79 22                	jns    800ecc <readline+0x66>
			if (c != -E_EOF)
  800eaa:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800eae:	0f 84 ad 00 00 00    	je     800f61 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800eb4:	83 ec 08             	sub    $0x8,%esp
  800eb7:	ff 75 ec             	pushl  -0x14(%ebp)
  800eba:	68 93 2f 80 00       	push   $0x802f93
  800ebf:	e8 27 f9 ff ff       	call   8007eb <cprintf>
  800ec4:	83 c4 10             	add    $0x10,%esp
			return;
  800ec7:	e9 95 00 00 00       	jmp    800f61 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800ecc:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800ed0:	7e 34                	jle    800f06 <readline+0xa0>
  800ed2:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800ed9:	7f 2b                	jg     800f06 <readline+0xa0>
			if (echoing)
  800edb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800edf:	74 0e                	je     800eef <readline+0x89>
				cputchar(c);
  800ee1:	83 ec 0c             	sub    $0xc,%esp
  800ee4:	ff 75 ec             	pushl  -0x14(%ebp)
  800ee7:	e8 73 f6 ff ff       	call   80055f <cputchar>
  800eec:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ef2:	8d 50 01             	lea    0x1(%eax),%edx
  800ef5:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800ef8:	89 c2                	mov    %eax,%edx
  800efa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efd:	01 d0                	add    %edx,%eax
  800eff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f02:	88 10                	mov    %dl,(%eax)
  800f04:	eb 56                	jmp    800f5c <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800f06:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800f0a:	75 1f                	jne    800f2b <readline+0xc5>
  800f0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800f10:	7e 19                	jle    800f2b <readline+0xc5>
			if (echoing)
  800f12:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f16:	74 0e                	je     800f26 <readline+0xc0>
				cputchar(c);
  800f18:	83 ec 0c             	sub    $0xc,%esp
  800f1b:	ff 75 ec             	pushl  -0x14(%ebp)
  800f1e:	e8 3c f6 ff ff       	call   80055f <cputchar>
  800f23:	83 c4 10             	add    $0x10,%esp

			i--;
  800f26:	ff 4d f4             	decl   -0xc(%ebp)
  800f29:	eb 31                	jmp    800f5c <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800f2b:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800f2f:	74 0a                	je     800f3b <readline+0xd5>
  800f31:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800f35:	0f 85 61 ff ff ff    	jne    800e9c <readline+0x36>
			if (echoing)
  800f3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f3f:	74 0e                	je     800f4f <readline+0xe9>
				cputchar(c);
  800f41:	83 ec 0c             	sub    $0xc,%esp
  800f44:	ff 75 ec             	pushl  -0x14(%ebp)
  800f47:	e8 13 f6 ff ff       	call   80055f <cputchar>
  800f4c:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800f4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f55:	01 d0                	add    %edx,%eax
  800f57:	c6 00 00             	movb   $0x0,(%eax)
			return;
  800f5a:	eb 06                	jmp    800f62 <readline+0xfc>
		}
	}
  800f5c:	e9 3b ff ff ff       	jmp    800e9c <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  800f61:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  800f62:	c9                   	leave  
  800f63:	c3                   	ret    

00800f64 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800f64:	55                   	push   %ebp
  800f65:	89 e5                	mov    %esp,%ebp
  800f67:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f6a:	e8 71 14 00 00       	call   8023e0 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  800f6f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f73:	74 13                	je     800f88 <atomic_readline+0x24>
		cprintf("%s", prompt);
  800f75:	83 ec 08             	sub    $0x8,%esp
  800f78:	ff 75 08             	pushl  0x8(%ebp)
  800f7b:	68 90 2f 80 00       	push   $0x802f90
  800f80:	e8 66 f8 ff ff       	call   8007eb <cprintf>
  800f85:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800f88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800f8f:	83 ec 0c             	sub    $0xc,%esp
  800f92:	6a 00                	push   $0x0
  800f94:	e8 5c f6 ff ff       	call   8005f5 <iscons>
  800f99:	83 c4 10             	add    $0x10,%esp
  800f9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800f9f:	e8 03 f6 ff ff       	call   8005a7 <getchar>
  800fa4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800fa7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800fab:	79 23                	jns    800fd0 <atomic_readline+0x6c>
			if (c != -E_EOF)
  800fad:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800fb1:	74 13                	je     800fc6 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  800fb3:	83 ec 08             	sub    $0x8,%esp
  800fb6:	ff 75 ec             	pushl  -0x14(%ebp)
  800fb9:	68 93 2f 80 00       	push   $0x802f93
  800fbe:	e8 28 f8 ff ff       	call   8007eb <cprintf>
  800fc3:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800fc6:	e8 2f 14 00 00       	call   8023fa <sys_enable_interrupt>
			return;
  800fcb:	e9 9a 00 00 00       	jmp    80106a <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800fd0:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800fd4:	7e 34                	jle    80100a <atomic_readline+0xa6>
  800fd6:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800fdd:	7f 2b                	jg     80100a <atomic_readline+0xa6>
			if (echoing)
  800fdf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fe3:	74 0e                	je     800ff3 <atomic_readline+0x8f>
				cputchar(c);
  800fe5:	83 ec 0c             	sub    $0xc,%esp
  800fe8:	ff 75 ec             	pushl  -0x14(%ebp)
  800feb:	e8 6f f5 ff ff       	call   80055f <cputchar>
  800ff0:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff6:	8d 50 01             	lea    0x1(%eax),%edx
  800ff9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800ffc:	89 c2                	mov    %eax,%edx
  800ffe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801001:	01 d0                	add    %edx,%eax
  801003:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801006:	88 10                	mov    %dl,(%eax)
  801008:	eb 5b                	jmp    801065 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80100a:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80100e:	75 1f                	jne    80102f <atomic_readline+0xcb>
  801010:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801014:	7e 19                	jle    80102f <atomic_readline+0xcb>
			if (echoing)
  801016:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80101a:	74 0e                	je     80102a <atomic_readline+0xc6>
				cputchar(c);
  80101c:	83 ec 0c             	sub    $0xc,%esp
  80101f:	ff 75 ec             	pushl  -0x14(%ebp)
  801022:	e8 38 f5 ff ff       	call   80055f <cputchar>
  801027:	83 c4 10             	add    $0x10,%esp
			i--;
  80102a:	ff 4d f4             	decl   -0xc(%ebp)
  80102d:	eb 36                	jmp    801065 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  80102f:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801033:	74 0a                	je     80103f <atomic_readline+0xdb>
  801035:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801039:	0f 85 60 ff ff ff    	jne    800f9f <atomic_readline+0x3b>
			if (echoing)
  80103f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801043:	74 0e                	je     801053 <atomic_readline+0xef>
				cputchar(c);
  801045:	83 ec 0c             	sub    $0xc,%esp
  801048:	ff 75 ec             	pushl  -0x14(%ebp)
  80104b:	e8 0f f5 ff ff       	call   80055f <cputchar>
  801050:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  801053:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801056:	8b 45 0c             	mov    0xc(%ebp),%eax
  801059:	01 d0                	add    %edx,%eax
  80105b:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  80105e:	e8 97 13 00 00       	call   8023fa <sys_enable_interrupt>
			return;
  801063:	eb 05                	jmp    80106a <atomic_readline+0x106>
		}
	}
  801065:	e9 35 ff ff ff       	jmp    800f9f <atomic_readline+0x3b>
}
  80106a:	c9                   	leave  
  80106b:	c3                   	ret    

0080106c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801072:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801079:	eb 06                	jmp    801081 <strlen+0x15>
		n++;
  80107b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80107e:	ff 45 08             	incl   0x8(%ebp)
  801081:	8b 45 08             	mov    0x8(%ebp),%eax
  801084:	8a 00                	mov    (%eax),%al
  801086:	84 c0                	test   %al,%al
  801088:	75 f1                	jne    80107b <strlen+0xf>
		n++;
	return n;
  80108a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80108d:	c9                   	leave  
  80108e:	c3                   	ret    

0080108f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80108f:	55                   	push   %ebp
  801090:	89 e5                	mov    %esp,%ebp
  801092:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801095:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80109c:	eb 09                	jmp    8010a7 <strnlen+0x18>
		n++;
  80109e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010a1:	ff 45 08             	incl   0x8(%ebp)
  8010a4:	ff 4d 0c             	decl   0xc(%ebp)
  8010a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010ab:	74 09                	je     8010b6 <strnlen+0x27>
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b0:	8a 00                	mov    (%eax),%al
  8010b2:	84 c0                	test   %al,%al
  8010b4:	75 e8                	jne    80109e <strnlen+0xf>
		n++;
	return n;
  8010b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010b9:	c9                   	leave  
  8010ba:	c3                   	ret    

008010bb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010bb:	55                   	push   %ebp
  8010bc:	89 e5                	mov    %esp,%ebp
  8010be:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010c7:	90                   	nop
  8010c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cb:	8d 50 01             	lea    0x1(%eax),%edx
  8010ce:	89 55 08             	mov    %edx,0x8(%ebp)
  8010d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010d7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010da:	8a 12                	mov    (%edx),%dl
  8010dc:	88 10                	mov    %dl,(%eax)
  8010de:	8a 00                	mov    (%eax),%al
  8010e0:	84 c0                	test   %al,%al
  8010e2:	75 e4                	jne    8010c8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010e7:	c9                   	leave  
  8010e8:	c3                   	ret    

008010e9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010e9:	55                   	push   %ebp
  8010ea:	89 e5                	mov    %esp,%ebp
  8010ec:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010fc:	eb 1f                	jmp    80111d <strncpy+0x34>
		*dst++ = *src;
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801101:	8d 50 01             	lea    0x1(%eax),%edx
  801104:	89 55 08             	mov    %edx,0x8(%ebp)
  801107:	8b 55 0c             	mov    0xc(%ebp),%edx
  80110a:	8a 12                	mov    (%edx),%dl
  80110c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80110e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	84 c0                	test   %al,%al
  801115:	74 03                	je     80111a <strncpy+0x31>
			src++;
  801117:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80111a:	ff 45 fc             	incl   -0x4(%ebp)
  80111d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801120:	3b 45 10             	cmp    0x10(%ebp),%eax
  801123:	72 d9                	jb     8010fe <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801125:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801128:	c9                   	leave  
  801129:	c3                   	ret    

0080112a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80112a:	55                   	push   %ebp
  80112b:	89 e5                	mov    %esp,%ebp
  80112d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801136:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80113a:	74 30                	je     80116c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80113c:	eb 16                	jmp    801154 <strlcpy+0x2a>
			*dst++ = *src++;
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	8d 50 01             	lea    0x1(%eax),%edx
  801144:	89 55 08             	mov    %edx,0x8(%ebp)
  801147:	8b 55 0c             	mov    0xc(%ebp),%edx
  80114a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80114d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801150:	8a 12                	mov    (%edx),%dl
  801152:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801154:	ff 4d 10             	decl   0x10(%ebp)
  801157:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115b:	74 09                	je     801166 <strlcpy+0x3c>
  80115d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	84 c0                	test   %al,%al
  801164:	75 d8                	jne    80113e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80116c:	8b 55 08             	mov    0x8(%ebp),%edx
  80116f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801172:	29 c2                	sub    %eax,%edx
  801174:	89 d0                	mov    %edx,%eax
}
  801176:	c9                   	leave  
  801177:	c3                   	ret    

00801178 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801178:	55                   	push   %ebp
  801179:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80117b:	eb 06                	jmp    801183 <strcmp+0xb>
		p++, q++;
  80117d:	ff 45 08             	incl   0x8(%ebp)
  801180:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	8a 00                	mov    (%eax),%al
  801188:	84 c0                	test   %al,%al
  80118a:	74 0e                	je     80119a <strcmp+0x22>
  80118c:	8b 45 08             	mov    0x8(%ebp),%eax
  80118f:	8a 10                	mov    (%eax),%dl
  801191:	8b 45 0c             	mov    0xc(%ebp),%eax
  801194:	8a 00                	mov    (%eax),%al
  801196:	38 c2                	cmp    %al,%dl
  801198:	74 e3                	je     80117d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80119a:	8b 45 08             	mov    0x8(%ebp),%eax
  80119d:	8a 00                	mov    (%eax),%al
  80119f:	0f b6 d0             	movzbl %al,%edx
  8011a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a5:	8a 00                	mov    (%eax),%al
  8011a7:	0f b6 c0             	movzbl %al,%eax
  8011aa:	29 c2                	sub    %eax,%edx
  8011ac:	89 d0                	mov    %edx,%eax
}
  8011ae:	5d                   	pop    %ebp
  8011af:	c3                   	ret    

008011b0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8011b3:	eb 09                	jmp    8011be <strncmp+0xe>
		n--, p++, q++;
  8011b5:	ff 4d 10             	decl   0x10(%ebp)
  8011b8:	ff 45 08             	incl   0x8(%ebp)
  8011bb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8011be:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c2:	74 17                	je     8011db <strncmp+0x2b>
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8a 00                	mov    (%eax),%al
  8011c9:	84 c0                	test   %al,%al
  8011cb:	74 0e                	je     8011db <strncmp+0x2b>
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	8a 10                	mov    (%eax),%dl
  8011d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d5:	8a 00                	mov    (%eax),%al
  8011d7:	38 c2                	cmp    %al,%dl
  8011d9:	74 da                	je     8011b5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011df:	75 07                	jne    8011e8 <strncmp+0x38>
		return 0;
  8011e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8011e6:	eb 14                	jmp    8011fc <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011eb:	8a 00                	mov    (%eax),%al
  8011ed:	0f b6 d0             	movzbl %al,%edx
  8011f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f3:	8a 00                	mov    (%eax),%al
  8011f5:	0f b6 c0             	movzbl %al,%eax
  8011f8:	29 c2                	sub    %eax,%edx
  8011fa:	89 d0                	mov    %edx,%eax
}
  8011fc:	5d                   	pop    %ebp
  8011fd:	c3                   	ret    

008011fe <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011fe:	55                   	push   %ebp
  8011ff:	89 e5                	mov    %esp,%ebp
  801201:	83 ec 04             	sub    $0x4,%esp
  801204:	8b 45 0c             	mov    0xc(%ebp),%eax
  801207:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80120a:	eb 12                	jmp    80121e <strchr+0x20>
		if (*s == c)
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801214:	75 05                	jne    80121b <strchr+0x1d>
			return (char *) s;
  801216:	8b 45 08             	mov    0x8(%ebp),%eax
  801219:	eb 11                	jmp    80122c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80121b:	ff 45 08             	incl   0x8(%ebp)
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	8a 00                	mov    (%eax),%al
  801223:	84 c0                	test   %al,%al
  801225:	75 e5                	jne    80120c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801227:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80122c:	c9                   	leave  
  80122d:	c3                   	ret    

0080122e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80122e:	55                   	push   %ebp
  80122f:	89 e5                	mov    %esp,%ebp
  801231:	83 ec 04             	sub    $0x4,%esp
  801234:	8b 45 0c             	mov    0xc(%ebp),%eax
  801237:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80123a:	eb 0d                	jmp    801249 <strfind+0x1b>
		if (*s == c)
  80123c:	8b 45 08             	mov    0x8(%ebp),%eax
  80123f:	8a 00                	mov    (%eax),%al
  801241:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801244:	74 0e                	je     801254 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801246:	ff 45 08             	incl   0x8(%ebp)
  801249:	8b 45 08             	mov    0x8(%ebp),%eax
  80124c:	8a 00                	mov    (%eax),%al
  80124e:	84 c0                	test   %al,%al
  801250:	75 ea                	jne    80123c <strfind+0xe>
  801252:	eb 01                	jmp    801255 <strfind+0x27>
		if (*s == c)
			break;
  801254:	90                   	nop
	return (char *) s;
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801258:	c9                   	leave  
  801259:	c3                   	ret    

0080125a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80125a:	55                   	push   %ebp
  80125b:	89 e5                	mov    %esp,%ebp
  80125d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801266:	8b 45 10             	mov    0x10(%ebp),%eax
  801269:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80126c:	eb 0e                	jmp    80127c <memset+0x22>
		*p++ = c;
  80126e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801271:	8d 50 01             	lea    0x1(%eax),%edx
  801274:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801277:	8b 55 0c             	mov    0xc(%ebp),%edx
  80127a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80127c:	ff 4d f8             	decl   -0x8(%ebp)
  80127f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801283:	79 e9                	jns    80126e <memset+0x14>
		*p++ = c;

	return v;
  801285:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801288:	c9                   	leave  
  801289:	c3                   	ret    

0080128a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
  80128d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801290:	8b 45 0c             	mov    0xc(%ebp),%eax
  801293:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801296:	8b 45 08             	mov    0x8(%ebp),%eax
  801299:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80129c:	eb 16                	jmp    8012b4 <memcpy+0x2a>
		*d++ = *s++;
  80129e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a1:	8d 50 01             	lea    0x1(%eax),%edx
  8012a4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012aa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012ad:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012b0:	8a 12                	mov    (%edx),%dl
  8012b2:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8012b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012ba:	89 55 10             	mov    %edx,0x10(%ebp)
  8012bd:	85 c0                	test   %eax,%eax
  8012bf:	75 dd                	jne    80129e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012c4:	c9                   	leave  
  8012c5:	c3                   	ret    

008012c6 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012c6:	55                   	push   %ebp
  8012c7:	89 e5                	mov    %esp,%ebp
  8012c9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  8012cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012db:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012de:	73 50                	jae    801330 <memmove+0x6a>
  8012e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e6:	01 d0                	add    %edx,%eax
  8012e8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012eb:	76 43                	jbe    801330 <memmove+0x6a>
		s += n;
  8012ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8012f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012f9:	eb 10                	jmp    80130b <memmove+0x45>
			*--d = *--s;
  8012fb:	ff 4d f8             	decl   -0x8(%ebp)
  8012fe:	ff 4d fc             	decl   -0x4(%ebp)
  801301:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801304:	8a 10                	mov    (%eax),%dl
  801306:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801309:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80130b:	8b 45 10             	mov    0x10(%ebp),%eax
  80130e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801311:	89 55 10             	mov    %edx,0x10(%ebp)
  801314:	85 c0                	test   %eax,%eax
  801316:	75 e3                	jne    8012fb <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801318:	eb 23                	jmp    80133d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80131a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131d:	8d 50 01             	lea    0x1(%eax),%edx
  801320:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801323:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801326:	8d 4a 01             	lea    0x1(%edx),%ecx
  801329:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80132c:	8a 12                	mov    (%edx),%dl
  80132e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801330:	8b 45 10             	mov    0x10(%ebp),%eax
  801333:	8d 50 ff             	lea    -0x1(%eax),%edx
  801336:	89 55 10             	mov    %edx,0x10(%ebp)
  801339:	85 c0                	test   %eax,%eax
  80133b:	75 dd                	jne    80131a <memmove+0x54>
			*d++ = *s++;

	return dst;
  80133d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801340:	c9                   	leave  
  801341:	c3                   	ret    

00801342 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801342:	55                   	push   %ebp
  801343:	89 e5                	mov    %esp,%ebp
  801345:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801348:	8b 45 08             	mov    0x8(%ebp),%eax
  80134b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80134e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801351:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801354:	eb 2a                	jmp    801380 <memcmp+0x3e>
		if (*s1 != *s2)
  801356:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801359:	8a 10                	mov    (%eax),%dl
  80135b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80135e:	8a 00                	mov    (%eax),%al
  801360:	38 c2                	cmp    %al,%dl
  801362:	74 16                	je     80137a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801364:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801367:	8a 00                	mov    (%eax),%al
  801369:	0f b6 d0             	movzbl %al,%edx
  80136c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80136f:	8a 00                	mov    (%eax),%al
  801371:	0f b6 c0             	movzbl %al,%eax
  801374:	29 c2                	sub    %eax,%edx
  801376:	89 d0                	mov    %edx,%eax
  801378:	eb 18                	jmp    801392 <memcmp+0x50>
		s1++, s2++;
  80137a:	ff 45 fc             	incl   -0x4(%ebp)
  80137d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801380:	8b 45 10             	mov    0x10(%ebp),%eax
  801383:	8d 50 ff             	lea    -0x1(%eax),%edx
  801386:	89 55 10             	mov    %edx,0x10(%ebp)
  801389:	85 c0                	test   %eax,%eax
  80138b:	75 c9                	jne    801356 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80138d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801392:	c9                   	leave  
  801393:	c3                   	ret    

00801394 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801394:	55                   	push   %ebp
  801395:	89 e5                	mov    %esp,%ebp
  801397:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80139a:	8b 55 08             	mov    0x8(%ebp),%edx
  80139d:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a0:	01 d0                	add    %edx,%eax
  8013a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8013a5:	eb 15                	jmp    8013bc <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	8a 00                	mov    (%eax),%al
  8013ac:	0f b6 d0             	movzbl %al,%edx
  8013af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b2:	0f b6 c0             	movzbl %al,%eax
  8013b5:	39 c2                	cmp    %eax,%edx
  8013b7:	74 0d                	je     8013c6 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013b9:	ff 45 08             	incl   0x8(%ebp)
  8013bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013c2:	72 e3                	jb     8013a7 <memfind+0x13>
  8013c4:	eb 01                	jmp    8013c7 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013c6:	90                   	nop
	return (void *) s;
  8013c7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013ca:	c9                   	leave  
  8013cb:	c3                   	ret    

008013cc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013cc:	55                   	push   %ebp
  8013cd:	89 e5                	mov    %esp,%ebp
  8013cf:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013d9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013e0:	eb 03                	jmp    8013e5 <strtol+0x19>
		s++;
  8013e2:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e8:	8a 00                	mov    (%eax),%al
  8013ea:	3c 20                	cmp    $0x20,%al
  8013ec:	74 f4                	je     8013e2 <strtol+0x16>
  8013ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	3c 09                	cmp    $0x9,%al
  8013f5:	74 eb                	je     8013e2 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fa:	8a 00                	mov    (%eax),%al
  8013fc:	3c 2b                	cmp    $0x2b,%al
  8013fe:	75 05                	jne    801405 <strtol+0x39>
		s++;
  801400:	ff 45 08             	incl   0x8(%ebp)
  801403:	eb 13                	jmp    801418 <strtol+0x4c>
	else if (*s == '-')
  801405:	8b 45 08             	mov    0x8(%ebp),%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	3c 2d                	cmp    $0x2d,%al
  80140c:	75 0a                	jne    801418 <strtol+0x4c>
		s++, neg = 1;
  80140e:	ff 45 08             	incl   0x8(%ebp)
  801411:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801418:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80141c:	74 06                	je     801424 <strtol+0x58>
  80141e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801422:	75 20                	jne    801444 <strtol+0x78>
  801424:	8b 45 08             	mov    0x8(%ebp),%eax
  801427:	8a 00                	mov    (%eax),%al
  801429:	3c 30                	cmp    $0x30,%al
  80142b:	75 17                	jne    801444 <strtol+0x78>
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	40                   	inc    %eax
  801431:	8a 00                	mov    (%eax),%al
  801433:	3c 78                	cmp    $0x78,%al
  801435:	75 0d                	jne    801444 <strtol+0x78>
		s += 2, base = 16;
  801437:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80143b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801442:	eb 28                	jmp    80146c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801444:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801448:	75 15                	jne    80145f <strtol+0x93>
  80144a:	8b 45 08             	mov    0x8(%ebp),%eax
  80144d:	8a 00                	mov    (%eax),%al
  80144f:	3c 30                	cmp    $0x30,%al
  801451:	75 0c                	jne    80145f <strtol+0x93>
		s++, base = 8;
  801453:	ff 45 08             	incl   0x8(%ebp)
  801456:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80145d:	eb 0d                	jmp    80146c <strtol+0xa0>
	else if (base == 0)
  80145f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801463:	75 07                	jne    80146c <strtol+0xa0>
		base = 10;
  801465:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80146c:	8b 45 08             	mov    0x8(%ebp),%eax
  80146f:	8a 00                	mov    (%eax),%al
  801471:	3c 2f                	cmp    $0x2f,%al
  801473:	7e 19                	jle    80148e <strtol+0xc2>
  801475:	8b 45 08             	mov    0x8(%ebp),%eax
  801478:	8a 00                	mov    (%eax),%al
  80147a:	3c 39                	cmp    $0x39,%al
  80147c:	7f 10                	jg     80148e <strtol+0xc2>
			dig = *s - '0';
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	8a 00                	mov    (%eax),%al
  801483:	0f be c0             	movsbl %al,%eax
  801486:	83 e8 30             	sub    $0x30,%eax
  801489:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80148c:	eb 42                	jmp    8014d0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80148e:	8b 45 08             	mov    0x8(%ebp),%eax
  801491:	8a 00                	mov    (%eax),%al
  801493:	3c 60                	cmp    $0x60,%al
  801495:	7e 19                	jle    8014b0 <strtol+0xe4>
  801497:	8b 45 08             	mov    0x8(%ebp),%eax
  80149a:	8a 00                	mov    (%eax),%al
  80149c:	3c 7a                	cmp    $0x7a,%al
  80149e:	7f 10                	jg     8014b0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8014a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a3:	8a 00                	mov    (%eax),%al
  8014a5:	0f be c0             	movsbl %al,%eax
  8014a8:	83 e8 57             	sub    $0x57,%eax
  8014ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014ae:	eb 20                	jmp    8014d0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8014b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b3:	8a 00                	mov    (%eax),%al
  8014b5:	3c 40                	cmp    $0x40,%al
  8014b7:	7e 39                	jle    8014f2 <strtol+0x126>
  8014b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bc:	8a 00                	mov    (%eax),%al
  8014be:	3c 5a                	cmp    $0x5a,%al
  8014c0:	7f 30                	jg     8014f2 <strtol+0x126>
			dig = *s - 'A' + 10;
  8014c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c5:	8a 00                	mov    (%eax),%al
  8014c7:	0f be c0             	movsbl %al,%eax
  8014ca:	83 e8 37             	sub    $0x37,%eax
  8014cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014d6:	7d 19                	jge    8014f1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014d8:	ff 45 08             	incl   0x8(%ebp)
  8014db:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014de:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014e2:	89 c2                	mov    %eax,%edx
  8014e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014e7:	01 d0                	add    %edx,%eax
  8014e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8014ec:	e9 7b ff ff ff       	jmp    80146c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014f1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014f6:	74 08                	je     801500 <strtol+0x134>
		*endptr = (char *) s;
  8014f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8014fe:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801500:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801504:	74 07                	je     80150d <strtol+0x141>
  801506:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801509:	f7 d8                	neg    %eax
  80150b:	eb 03                	jmp    801510 <strtol+0x144>
  80150d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801510:	c9                   	leave  
  801511:	c3                   	ret    

00801512 <ltostr>:

void
ltostr(long value, char *str)
{
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
  801515:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801518:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80151f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801526:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80152a:	79 13                	jns    80153f <ltostr+0x2d>
	{
		neg = 1;
  80152c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801533:	8b 45 0c             	mov    0xc(%ebp),%eax
  801536:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801539:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80153c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80153f:	8b 45 08             	mov    0x8(%ebp),%eax
  801542:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801547:	99                   	cltd   
  801548:	f7 f9                	idiv   %ecx
  80154a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80154d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801550:	8d 50 01             	lea    0x1(%eax),%edx
  801553:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801556:	89 c2                	mov    %eax,%edx
  801558:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155b:	01 d0                	add    %edx,%eax
  80155d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801560:	83 c2 30             	add    $0x30,%edx
  801563:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801565:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801568:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80156d:	f7 e9                	imul   %ecx
  80156f:	c1 fa 02             	sar    $0x2,%edx
  801572:	89 c8                	mov    %ecx,%eax
  801574:	c1 f8 1f             	sar    $0x1f,%eax
  801577:	29 c2                	sub    %eax,%edx
  801579:	89 d0                	mov    %edx,%eax
  80157b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80157e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801581:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801586:	f7 e9                	imul   %ecx
  801588:	c1 fa 02             	sar    $0x2,%edx
  80158b:	89 c8                	mov    %ecx,%eax
  80158d:	c1 f8 1f             	sar    $0x1f,%eax
  801590:	29 c2                	sub    %eax,%edx
  801592:	89 d0                	mov    %edx,%eax
  801594:	c1 e0 02             	shl    $0x2,%eax
  801597:	01 d0                	add    %edx,%eax
  801599:	01 c0                	add    %eax,%eax
  80159b:	29 c1                	sub    %eax,%ecx
  80159d:	89 ca                	mov    %ecx,%edx
  80159f:	85 d2                	test   %edx,%edx
  8015a1:	75 9c                	jne    80153f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8015a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8015aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ad:	48                   	dec    %eax
  8015ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8015b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015b5:	74 3d                	je     8015f4 <ltostr+0xe2>
		start = 1 ;
  8015b7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015be:	eb 34                	jmp    8015f4 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8015c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c6:	01 d0                	add    %edx,%eax
  8015c8:	8a 00                	mov    (%eax),%al
  8015ca:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d3:	01 c2                	add    %eax,%edx
  8015d5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015db:	01 c8                	add    %ecx,%eax
  8015dd:	8a 00                	mov    (%eax),%al
  8015df:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e7:	01 c2                	add    %eax,%edx
  8015e9:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015ec:	88 02                	mov    %al,(%edx)
		start++ ;
  8015ee:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015f1:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015fa:	7c c4                	jl     8015c0 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015fc:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801602:	01 d0                	add    %edx,%eax
  801604:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801607:	90                   	nop
  801608:	c9                   	leave  
  801609:	c3                   	ret    

0080160a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
  80160d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801610:	ff 75 08             	pushl  0x8(%ebp)
  801613:	e8 54 fa ff ff       	call   80106c <strlen>
  801618:	83 c4 04             	add    $0x4,%esp
  80161b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80161e:	ff 75 0c             	pushl  0xc(%ebp)
  801621:	e8 46 fa ff ff       	call   80106c <strlen>
  801626:	83 c4 04             	add    $0x4,%esp
  801629:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80162c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801633:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80163a:	eb 17                	jmp    801653 <strcconcat+0x49>
		final[s] = str1[s] ;
  80163c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80163f:	8b 45 10             	mov    0x10(%ebp),%eax
  801642:	01 c2                	add    %eax,%edx
  801644:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	01 c8                	add    %ecx,%eax
  80164c:	8a 00                	mov    (%eax),%al
  80164e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801650:	ff 45 fc             	incl   -0x4(%ebp)
  801653:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801656:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801659:	7c e1                	jl     80163c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80165b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801662:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801669:	eb 1f                	jmp    80168a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80166b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80166e:	8d 50 01             	lea    0x1(%eax),%edx
  801671:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801674:	89 c2                	mov    %eax,%edx
  801676:	8b 45 10             	mov    0x10(%ebp),%eax
  801679:	01 c2                	add    %eax,%edx
  80167b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80167e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801681:	01 c8                	add    %ecx,%eax
  801683:	8a 00                	mov    (%eax),%al
  801685:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801687:	ff 45 f8             	incl   -0x8(%ebp)
  80168a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80168d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801690:	7c d9                	jl     80166b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801692:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801695:	8b 45 10             	mov    0x10(%ebp),%eax
  801698:	01 d0                	add    %edx,%eax
  80169a:	c6 00 00             	movb   $0x0,(%eax)
}
  80169d:	90                   	nop
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8016a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8016ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8016af:	8b 00                	mov    (%eax),%eax
  8016b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bb:	01 d0                	add    %edx,%eax
  8016bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016c3:	eb 0c                	jmp    8016d1 <strsplit+0x31>
			*string++ = 0;
  8016c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c8:	8d 50 01             	lea    0x1(%eax),%edx
  8016cb:	89 55 08             	mov    %edx,0x8(%ebp)
  8016ce:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d4:	8a 00                	mov    (%eax),%al
  8016d6:	84 c0                	test   %al,%al
  8016d8:	74 18                	je     8016f2 <strsplit+0x52>
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	8a 00                	mov    (%eax),%al
  8016df:	0f be c0             	movsbl %al,%eax
  8016e2:	50                   	push   %eax
  8016e3:	ff 75 0c             	pushl  0xc(%ebp)
  8016e6:	e8 13 fb ff ff       	call   8011fe <strchr>
  8016eb:	83 c4 08             	add    $0x8,%esp
  8016ee:	85 c0                	test   %eax,%eax
  8016f0:	75 d3                	jne    8016c5 <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  8016f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f5:	8a 00                	mov    (%eax),%al
  8016f7:	84 c0                	test   %al,%al
  8016f9:	74 5a                	je     801755 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  8016fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8016fe:	8b 00                	mov    (%eax),%eax
  801700:	83 f8 0f             	cmp    $0xf,%eax
  801703:	75 07                	jne    80170c <strsplit+0x6c>
		{
			return 0;
  801705:	b8 00 00 00 00       	mov    $0x0,%eax
  80170a:	eb 66                	jmp    801772 <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80170c:	8b 45 14             	mov    0x14(%ebp),%eax
  80170f:	8b 00                	mov    (%eax),%eax
  801711:	8d 48 01             	lea    0x1(%eax),%ecx
  801714:	8b 55 14             	mov    0x14(%ebp),%edx
  801717:	89 0a                	mov    %ecx,(%edx)
  801719:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801720:	8b 45 10             	mov    0x10(%ebp),%eax
  801723:	01 c2                	add    %eax,%edx
  801725:	8b 45 08             	mov    0x8(%ebp),%eax
  801728:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80172a:	eb 03                	jmp    80172f <strsplit+0x8f>
			string++;
  80172c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80172f:	8b 45 08             	mov    0x8(%ebp),%eax
  801732:	8a 00                	mov    (%eax),%al
  801734:	84 c0                	test   %al,%al
  801736:	74 8b                	je     8016c3 <strsplit+0x23>
  801738:	8b 45 08             	mov    0x8(%ebp),%eax
  80173b:	8a 00                	mov    (%eax),%al
  80173d:	0f be c0             	movsbl %al,%eax
  801740:	50                   	push   %eax
  801741:	ff 75 0c             	pushl  0xc(%ebp)
  801744:	e8 b5 fa ff ff       	call   8011fe <strchr>
  801749:	83 c4 08             	add    $0x8,%esp
  80174c:	85 c0                	test   %eax,%eax
  80174e:	74 dc                	je     80172c <strsplit+0x8c>
			string++;
	}
  801750:	e9 6e ff ff ff       	jmp    8016c3 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801755:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801756:	8b 45 14             	mov    0x14(%ebp),%eax
  801759:	8b 00                	mov    (%eax),%eax
  80175b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801762:	8b 45 10             	mov    0x10(%ebp),%eax
  801765:	01 d0                	add    %edx,%eax
  801767:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80176d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801772:	c9                   	leave  
  801773:	c3                   	ret    

00801774 <malloc>:
int cnt_mem = 0;
int heap_mem[size_uhmem] = { 0 };
struct hmem heap_size[size_uhmem] = { 0 };
int check = 0;

void* malloc(uint32 size) {
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
  801777:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyNEXTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	//NEXT FIT
	if (sys_isUHeapPlacementStrategyNEXTFIT()) {
  80177d:	e8 7d 0f 00 00       	call   8026ff <sys_isUHeapPlacementStrategyNEXTFIT>
  801782:	85 c0                	test   %eax,%eax
  801784:	0f 84 6f 03 00 00    	je     801af9 <malloc+0x385>
		size = ROUNDUP(size, PAGE_SIZE);
  80178a:	c7 45 84 00 10 00 00 	movl   $0x1000,-0x7c(%ebp)
  801791:	8b 55 08             	mov    0x8(%ebp),%edx
  801794:	8b 45 84             	mov    -0x7c(%ebp),%eax
  801797:	01 d0                	add    %edx,%eax
  801799:	48                   	dec    %eax
  80179a:	89 45 80             	mov    %eax,-0x80(%ebp)
  80179d:	8b 45 80             	mov    -0x80(%ebp),%eax
  8017a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a5:	f7 75 84             	divl   -0x7c(%ebp)
  8017a8:	8b 45 80             	mov    -0x80(%ebp),%eax
  8017ab:	29 d0                	sub    %edx,%eax
  8017ad:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  8017b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017b4:	74 09                	je     8017bf <malloc+0x4b>
  8017b6:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8017bd:	76 0a                	jbe    8017c9 <malloc+0x55>
			return NULL;
  8017bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c4:	e9 4b 09 00 00       	jmp    802114 <malloc+0x9a0>
		}
		// first we can allocate by " Strategy Continues "
		if (ptr_uheap + size <= (uint32) USER_HEAP_MAX && !check) {
  8017c9:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8017cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d2:	01 d0                	add    %edx,%eax
  8017d4:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8017d9:	0f 87 a2 00 00 00    	ja     801881 <malloc+0x10d>
  8017df:	a1 60 30 98 00       	mov    0x983060,%eax
  8017e4:	85 c0                	test   %eax,%eax
  8017e6:	0f 85 95 00 00 00    	jne    801881 <malloc+0x10d>

			void* ret = (void *) ptr_uheap;
  8017ec:	a1 04 30 80 00       	mov    0x803004,%eax
  8017f1:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			sys_allocateMem(ptr_uheap, size);
  8017f7:	a1 04 30 80 00       	mov    0x803004,%eax
  8017fc:	83 ec 08             	sub    $0x8,%esp
  8017ff:	ff 75 08             	pushl  0x8(%ebp)
  801802:	50                   	push   %eax
  801803:	e8 a3 0b 00 00       	call   8023ab <sys_allocateMem>
  801808:	83 c4 10             	add    $0x10,%esp

			heap_size[cnt_mem].size = size;
  80180b:	a1 40 30 80 00       	mov    0x803040,%eax
  801810:	8b 55 08             	mov    0x8(%ebp),%edx
  801813:	89 14 c5 64 30 88 00 	mov    %edx,0x883064(,%eax,8)
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
  80181a:	a1 40 30 80 00       	mov    0x803040,%eax
  80181f:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801825:	89 14 c5 60 30 88 00 	mov    %edx,0x883060(,%eax,8)
			cnt_mem++;
  80182c:	a1 40 30 80 00       	mov    0x803040,%eax
  801831:	40                   	inc    %eax
  801832:	a3 40 30 80 00       	mov    %eax,0x803040
			int i = 0;
  801837:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  80183e:	eb 2e                	jmp    80186e <malloc+0xfa>
			{

				heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801840:	a1 04 30 80 00       	mov    0x803004,%eax
  801845:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] = 1;
  80184a:	c1 e8 0c             	shr    $0xc,%eax
  80184d:	c7 04 85 60 30 80 00 	movl   $0x1,0x803060(,%eax,4)
  801854:	01 00 00 00 

				ptr_uheap += (uint32) PAGE_SIZE;
  801858:	a1 04 30 80 00       	mov    0x803004,%eax
  80185d:	05 00 10 00 00       	add    $0x1000,%eax
  801862:	a3 04 30 80 00       	mov    %eax,0x803004
			heap_size[cnt_mem].size = size;
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
			cnt_mem++;
			int i = 0;
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  801867:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  80186e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801871:	3b 45 08             	cmp    0x8(%ebp),%eax
  801874:	72 ca                	jb     801840 <malloc+0xcc>
						/ (uint32) PAGE_SIZE)] = 1;

				ptr_uheap += (uint32) PAGE_SIZE;
			}

			return ret;
  801876:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80187c:	e9 93 08 00 00       	jmp    802114 <malloc+0x9a0>

		} else {
			// second we can allocate by " Strategy NEXTFIT "
			void* temp_end = NULL;
  801881:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

			int check_start = 0;
  801888:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			// check first that we used " Strategy Continues " before and not do it again and turn to NEXTFIT
			if (!check) {
  80188f:	a1 60 30 98 00       	mov    0x983060,%eax
  801894:	85 c0                	test   %eax,%eax
  801896:	75 1d                	jne    8018b5 <malloc+0x141>
				ptr_uheap = (uint32) USER_HEAP_START;
  801898:	c7 05 04 30 80 00 00 	movl   $0x80000000,0x803004
  80189f:	00 00 80 
				check = 1;
  8018a2:	c7 05 60 30 98 00 01 	movl   $0x1,0x983060
  8018a9:	00 00 00 
				check_start = 1;// to dont use second loop CZ ptr_uheap start from USER_HEAP_START
  8018ac:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  8018b3:	eb 08                	jmp    8018bd <malloc+0x149>
			} else {
				temp_end = (void*) ptr_uheap;
  8018b5:	a1 04 30 80 00       	mov    0x803004,%eax
  8018ba:	89 45 f0             	mov    %eax,-0x10(%ebp)

			}

			uint32 sz = 0;
  8018bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
			int f = 0;
  8018c4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			uint32 ptr = ptr_uheap;
  8018cb:	a1 04 30 80 00       	mov    0x803004,%eax
  8018d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  8018d3:	eb 4d                	jmp    801922 <malloc+0x1ae>
				if (sz == size) {
  8018d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018d8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8018db:	75 09                	jne    8018e6 <malloc+0x172>
					f = 1;
  8018dd:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  8018e4:	eb 45                	jmp    80192b <malloc+0x1b7>
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  8018e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018e9:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] == 0) {
  8018ee:	c1 e8 0c             	shr    $0xc,%eax
			while (ptr < (uint32) USER_HEAP_MAX) {
				if (sz == size) {
					f = 1;
					break;
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  8018f1:	8b 04 85 60 30 80 00 	mov    0x803060(,%eax,4),%eax
  8018f8:	85 c0                	test   %eax,%eax
  8018fa:	75 10                	jne    80190c <malloc+0x198>
						/ (uint32) PAGE_SIZE)] == 0) {

					sz += PAGE_SIZE;
  8018fc:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
					ptr += PAGE_SIZE;
  801903:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  80190a:	eb 16                	jmp    801922 <malloc+0x1ae>
				} else {
					sz = 0;
  80190c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
					ptr += PAGE_SIZE;
  801913:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
					ptr_uheap = ptr;
  80191a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80191d:	a3 04 30 80 00       	mov    %eax,0x803004

			uint32 sz = 0;
			int f = 0;
			uint32 ptr = ptr_uheap;
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  801922:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  801929:	76 aa                	jbe    8018d5 <malloc+0x161>
					ptr_uheap = ptr;
				}

			}

			if (f) {
  80192b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80192f:	0f 84 95 00 00 00    	je     8019ca <malloc+0x256>

				void* ret = (void *) ptr_uheap;
  801935:	a1 04 30 80 00       	mov    0x803004,%eax
  80193a:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

				sys_allocateMem(ptr_uheap, size);
  801940:	a1 04 30 80 00       	mov    0x803004,%eax
  801945:	83 ec 08             	sub    $0x8,%esp
  801948:	ff 75 08             	pushl  0x8(%ebp)
  80194b:	50                   	push   %eax
  80194c:	e8 5a 0a 00 00       	call   8023ab <sys_allocateMem>
  801951:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  801954:	a1 40 30 80 00       	mov    0x803040,%eax
  801959:	8b 55 08             	mov    0x8(%ebp),%edx
  80195c:	89 14 c5 64 30 88 00 	mov    %edx,0x883064(,%eax,8)
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801963:	a1 40 30 80 00       	mov    0x803040,%eax
  801968:	8b 15 04 30 80 00    	mov    0x803004,%edx
  80196e:	89 14 c5 60 30 88 00 	mov    %edx,0x883060(,%eax,8)
				cnt_mem++;
  801975:	a1 40 30 80 00       	mov    0x803040,%eax
  80197a:	40                   	inc    %eax
  80197b:	a3 40 30 80 00       	mov    %eax,0x803040
				int i = 0;
  801980:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801987:	eb 2e                	jmp    8019b7 <malloc+0x243>
				{

					heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801989:	a1 04 30 80 00       	mov    0x803004,%eax
  80198e:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  801993:	c1 e8 0c             	shr    $0xc,%eax
  801996:	c7 04 85 60 30 80 00 	movl   $0x1,0x803060(,%eax,4)
  80199d:	01 00 00 00 

					ptr_uheap += (uint32) PAGE_SIZE;
  8019a1:	a1 04 30 80 00       	mov    0x803004,%eax
  8019a6:	05 00 10 00 00       	add    $0x1000,%eax
  8019ab:	a3 04 30 80 00       	mov    %eax,0x803004
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
				cnt_mem++;
				int i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  8019b0:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  8019b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019ba:	3b 45 08             	cmp    0x8(%ebp),%eax
  8019bd:	72 ca                	jb     801989 <malloc+0x215>
							/ (uint32) PAGE_SIZE)] = 1;

					ptr_uheap += (uint32) PAGE_SIZE;
				}

				return ret;
  8019bf:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8019c5:	e9 4a 07 00 00       	jmp    802114 <malloc+0x9a0>

			} else {

				if (check_start) {
  8019ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019ce:	74 0a                	je     8019da <malloc+0x266>

					return NULL;
  8019d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d5:	e9 3a 07 00 00       	jmp    802114 <malloc+0x9a0>
				}

//////////////back loop////////////////

				uint32 sz = 0;
  8019da:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
				int f = 0;
  8019e1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				uint32 ptr = USER_HEAP_START;
  8019e8:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
				ptr_uheap = USER_HEAP_START;
  8019ef:	c7 05 04 30 80 00 00 	movl   $0x80000000,0x803004
  8019f6:	00 00 80 
				while (ptr < (uint32) temp_end) {
  8019f9:	eb 4d                	jmp    801a48 <malloc+0x2d4>
					if (sz == size) {
  8019fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019fe:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a01:	75 09                	jne    801a0c <malloc+0x298>
						f = 1;
  801a03:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
						break;
  801a0a:	eb 44                	jmp    801a50 <malloc+0x2dc>
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801a0c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801a0f:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] == 0) {
  801a14:	c1 e8 0c             	shr    $0xc,%eax
				while (ptr < (uint32) temp_end) {
					if (sz == size) {
						f = 1;
						break;
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801a17:	8b 04 85 60 30 80 00 	mov    0x803060(,%eax,4),%eax
  801a1e:	85 c0                	test   %eax,%eax
  801a20:	75 10                	jne    801a32 <malloc+0x2be>
							/ (uint32) PAGE_SIZE)] == 0) {

						sz += PAGE_SIZE;
  801a22:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801a29:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
  801a30:	eb 16                	jmp    801a48 <malloc+0x2d4>
					} else {
						sz = 0;
  801a32:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801a39:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
						ptr_uheap = ptr;
  801a40:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801a43:	a3 04 30 80 00       	mov    %eax,0x803004

				uint32 sz = 0;
				int f = 0;
				uint32 ptr = USER_HEAP_START;
				ptr_uheap = USER_HEAP_START;
				while (ptr < (uint32) temp_end) {
  801a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a4b:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801a4e:	72 ab                	jb     8019fb <malloc+0x287>
						ptr_uheap = ptr;
					}

				}

				if (f) {
  801a50:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801a54:	0f 84 95 00 00 00    	je     801aef <malloc+0x37b>

					void* ret = (void *) ptr_uheap;
  801a5a:	a1 04 30 80 00       	mov    0x803004,%eax
  801a5f:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

					sys_allocateMem(ptr_uheap, size);
  801a65:	a1 04 30 80 00       	mov    0x803004,%eax
  801a6a:	83 ec 08             	sub    $0x8,%esp
  801a6d:	ff 75 08             	pushl  0x8(%ebp)
  801a70:	50                   	push   %eax
  801a71:	e8 35 09 00 00       	call   8023ab <sys_allocateMem>
  801a76:	83 c4 10             	add    $0x10,%esp

					heap_size[cnt_mem].size = size;
  801a79:	a1 40 30 80 00       	mov    0x803040,%eax
  801a7e:	8b 55 08             	mov    0x8(%ebp),%edx
  801a81:	89 14 c5 64 30 88 00 	mov    %edx,0x883064(,%eax,8)
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801a88:	a1 40 30 80 00       	mov    0x803040,%eax
  801a8d:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801a93:	89 14 c5 60 30 88 00 	mov    %edx,0x883060(,%eax,8)
					cnt_mem++;
  801a9a:	a1 40 30 80 00       	mov    0x803040,%eax
  801a9f:	40                   	inc    %eax
  801aa0:	a3 40 30 80 00       	mov    %eax,0x803040
					int i = 0;
  801aa5:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

					for (; i < size; i += PAGE_SIZE)
  801aac:	eb 2e                	jmp    801adc <malloc+0x368>
					{

						heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801aae:	a1 04 30 80 00       	mov    0x803004,%eax
  801ab3:	05 00 00 00 80       	add    $0x80000000,%eax
								/ (uint32) PAGE_SIZE)] = 1;
  801ab8:	c1 e8 0c             	shr    $0xc,%eax
  801abb:	c7 04 85 60 30 80 00 	movl   $0x1,0x803060(,%eax,4)
  801ac2:	01 00 00 00 

						ptr_uheap += (uint32) PAGE_SIZE;
  801ac6:	a1 04 30 80 00       	mov    0x803004,%eax
  801acb:	05 00 10 00 00       	add    $0x1000,%eax
  801ad0:	a3 04 30 80 00       	mov    %eax,0x803004
					heap_size[cnt_mem].size = size;
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
					cnt_mem++;
					int i = 0;

					for (; i < size; i += PAGE_SIZE)
  801ad5:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  801adc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801adf:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ae2:	72 ca                	jb     801aae <malloc+0x33a>
								/ (uint32) PAGE_SIZE)] = 1;

						ptr_uheap += (uint32) PAGE_SIZE;
					}

					return ret;
  801ae4:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801aea:	e9 25 06 00 00       	jmp    802114 <malloc+0x9a0>

				} else {

					return NULL;
  801aef:	b8 00 00 00 00       	mov    $0x0,%eax
  801af4:	e9 1b 06 00 00       	jmp    802114 <malloc+0x9a0>

		}

	}

	else if (sys_isUHeapPlacementStrategyBESTFIT()) {
  801af9:	e8 d0 0b 00 00       	call   8026ce <sys_isUHeapPlacementStrategyBESTFIT>
  801afe:	85 c0                	test   %eax,%eax
  801b00:	0f 84 ba 01 00 00    	je     801cc0 <malloc+0x54c>

		size = ROUNDUP(size, PAGE_SIZE);
  801b06:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  801b0d:	10 00 00 
  801b10:	8b 55 08             	mov    0x8(%ebp),%edx
  801b13:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  801b19:	01 d0                	add    %edx,%eax
  801b1b:	48                   	dec    %eax
  801b1c:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  801b22:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801b28:	ba 00 00 00 00       	mov    $0x0,%edx
  801b2d:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  801b33:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801b39:	29 d0                	sub    %edx,%eax
  801b3b:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801b3e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b42:	74 09                	je     801b4d <malloc+0x3d9>
  801b44:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801b4b:	76 0a                	jbe    801b57 <malloc+0x3e3>
			return NULL;
  801b4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801b52:	e9 bd 05 00 00       	jmp    802114 <malloc+0x9a0>
		}
		uint32 ptr = (uint32) USER_HEAP_START;
  801b57:	c7 45 c8 00 00 00 80 	movl   $0x80000000,-0x38(%ebp)
		uint32 temp = 0;
  801b5e:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		uint32 min_sz = size_uhmem + 1;
  801b65:	c7 45 c0 01 00 02 00 	movl   $0x20001,-0x40(%ebp)
		uint32 count = 0;
  801b6c:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
		int i = 0;
  801b73:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7d:	c1 e8 0c             	shr    $0xc,%eax
  801b80:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801b86:	e9 80 00 00 00       	jmp    801c0b <malloc+0x497>

			if (heap_mem[i] == 0) {
  801b8b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801b8e:	8b 04 85 60 30 80 00 	mov    0x803060(,%eax,4),%eax
  801b95:	85 c0                	test   %eax,%eax
  801b97:	75 0c                	jne    801ba5 <malloc+0x431>

				count++;
  801b99:	ff 45 bc             	incl   -0x44(%ebp)
				ptr += PAGE_SIZE;
  801b9c:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801ba3:	eb 2d                	jmp    801bd2 <malloc+0x45e>
			} else {
				if (num_p <= count && min_sz > count) {
  801ba5:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801bab:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801bae:	77 14                	ja     801bc4 <malloc+0x450>
  801bb0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801bb3:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801bb6:	76 0c                	jbe    801bc4 <malloc+0x450>

					min_sz = count;
  801bb8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801bbb:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801bbe:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801bc1:	89 45 c4             	mov    %eax,-0x3c(%ebp)

				}
				count = 0;
  801bc4:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
				ptr += PAGE_SIZE;
  801bcb:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
			}

			if (i == size_uhmem - 1) {
  801bd2:	81 7d b8 ff ff 01 00 	cmpl   $0x1ffff,-0x48(%ebp)
  801bd9:	75 2d                	jne    801c08 <malloc+0x494>

				if (num_p <= count && min_sz > count) {
  801bdb:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801be1:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801be4:	77 22                	ja     801c08 <malloc+0x494>
  801be6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801be9:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801bec:	76 1a                	jbe    801c08 <malloc+0x494>

					min_sz = count;
  801bee:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801bf1:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801bf4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801bf7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
					count = 0;
  801bfa:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
					ptr += PAGE_SIZE;
  801c01:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801c08:	ff 45 b8             	incl   -0x48(%ebp)
  801c0b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801c0e:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801c13:	0f 86 72 ff ff ff    	jbe    801b8b <malloc+0x417>

			}

		}

		if (num_p > min_sz || temp == 0) {
  801c19:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801c1f:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  801c22:	77 06                	ja     801c2a <malloc+0x4b6>
  801c24:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801c28:	75 0a                	jne    801c34 <malloc+0x4c0>
			return NULL;
  801c2a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c2f:	e9 e0 04 00 00       	jmp    802114 <malloc+0x9a0>

		}

		temp = temp - (PAGE_SIZE * min_sz);
  801c34:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c37:	c1 e0 0c             	shl    $0xc,%eax
  801c3a:	29 45 c4             	sub    %eax,-0x3c(%ebp)
		void* ret = (void*) temp;
  801c3d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801c40:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)

		sys_allocateMem(temp, size);
  801c46:	83 ec 08             	sub    $0x8,%esp
  801c49:	ff 75 08             	pushl  0x8(%ebp)
  801c4c:	ff 75 c4             	pushl  -0x3c(%ebp)
  801c4f:	e8 57 07 00 00       	call   8023ab <sys_allocateMem>
  801c54:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801c57:	a1 40 30 80 00       	mov    0x803040,%eax
  801c5c:	8b 55 08             	mov    0x8(%ebp),%edx
  801c5f:	89 14 c5 64 30 88 00 	mov    %edx,0x883064(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801c66:	a1 40 30 80 00       	mov    0x803040,%eax
  801c6b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801c6e:	89 14 c5 60 30 88 00 	mov    %edx,0x883060(,%eax,8)
		cnt_mem++;
  801c75:	a1 40 30 80 00       	mov    0x803040,%eax
  801c7a:	40                   	inc    %eax
  801c7b:	a3 40 30 80 00       	mov    %eax,0x803040
		i = 0;
  801c80:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801c87:	eb 24                	jmp    801cad <malloc+0x539>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801c89:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801c8c:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801c91:	c1 e8 0c             	shr    $0xc,%eax
  801c94:	c7 04 85 60 30 80 00 	movl   $0x1,0x803060(,%eax,4)
  801c9b:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801c9f:	81 45 c4 00 10 00 00 	addl   $0x1000,-0x3c(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801ca6:	81 45 b8 00 10 00 00 	addl   $0x1000,-0x48(%ebp)
  801cad:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801cb0:	3b 45 08             	cmp    0x8(%ebp),%eax
  801cb3:	72 d4                	jb     801c89 <malloc+0x515>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801cb5:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801cbb:	e9 54 04 00 00       	jmp    802114 <malloc+0x9a0>

	} else if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801cc0:	e8 d8 09 00 00       	call   80269d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801cc5:	85 c0                	test   %eax,%eax
  801cc7:	0f 84 88 01 00 00    	je     801e55 <malloc+0x6e1>

		size = ROUNDUP(size, PAGE_SIZE);
  801ccd:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  801cd4:	10 00 00 
  801cd7:	8b 55 08             	mov    0x8(%ebp),%edx
  801cda:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  801ce0:	01 d0                	add    %edx,%eax
  801ce2:	48                   	dec    %eax
  801ce3:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  801ce9:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801cef:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf4:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  801cfa:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801d00:	29 d0                	sub    %edx,%eax
  801d02:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801d05:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d09:	74 09                	je     801d14 <malloc+0x5a0>
  801d0b:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801d12:	76 0a                	jbe    801d1e <malloc+0x5aa>
			return NULL;
  801d14:	b8 00 00 00 00       	mov    $0x0,%eax
  801d19:	e9 f6 03 00 00       	jmp    802114 <malloc+0x9a0>
		}

		uint32 ptr = (uint32) USER_HEAP_START;
  801d1e:	c7 45 b4 00 00 00 80 	movl   $0x80000000,-0x4c(%ebp)
		uint32 temp = 0;
  801d25:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
		uint32 found = 0;
  801d2c:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		uint32 count = 0;
  801d33:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
		int i = 0;
  801d3a:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801d41:	8b 45 08             	mov    0x8(%ebp),%eax
  801d44:	c1 e8 0c             	shr    $0xc,%eax
  801d47:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

		for (; i < size_uhmem; i++) {
  801d4d:	eb 5a                	jmp    801da9 <malloc+0x635>

			if (heap_mem[i] == 0) {
  801d4f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801d52:	8b 04 85 60 30 80 00 	mov    0x803060(,%eax,4),%eax
  801d59:	85 c0                	test   %eax,%eax
  801d5b:	75 0c                	jne    801d69 <malloc+0x5f5>

				count++;
  801d5d:	ff 45 a8             	incl   -0x58(%ebp)
				ptr += PAGE_SIZE;
  801d60:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
  801d67:	eb 22                	jmp    801d8b <malloc+0x617>
			} else {
				if (num_p <= count) {
  801d69:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801d6f:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801d72:	77 09                	ja     801d7d <malloc+0x609>

					found = 1;
  801d74:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)

					break;
  801d7b:	eb 36                	jmp    801db3 <malloc+0x63f>
				}
				count = 0;
  801d7d:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
				ptr += PAGE_SIZE;
  801d84:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
			}

			if (i == size_uhmem - 1) {
  801d8b:	81 7d a4 ff ff 01 00 	cmpl   $0x1ffff,-0x5c(%ebp)
  801d92:	75 12                	jne    801da6 <malloc+0x632>

				if (num_p <= count) {
  801d94:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801d9a:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801d9d:	77 07                	ja     801da6 <malloc+0x632>

					found = 1;
  801d9f:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
		uint32 found = 0;
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		for (; i < size_uhmem; i++) {
  801da6:	ff 45 a4             	incl   -0x5c(%ebp)
  801da9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801dac:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801db1:	76 9c                	jbe    801d4f <malloc+0x5db>

			}

		}

		if (!found) {
  801db3:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  801db7:	75 0a                	jne    801dc3 <malloc+0x64f>
			return NULL;
  801db9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbe:	e9 51 03 00 00       	jmp    802114 <malloc+0x9a0>

		}

		temp = ptr;
  801dc3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801dc6:	89 45 b0             	mov    %eax,-0x50(%ebp)
		temp = temp - (PAGE_SIZE * count);
  801dc9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801dcc:	c1 e0 0c             	shl    $0xc,%eax
  801dcf:	29 45 b0             	sub    %eax,-0x50(%ebp)
		void* ret = (void*) temp;
  801dd2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801dd5:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)

		sys_allocateMem(temp, size);
  801ddb:	83 ec 08             	sub    $0x8,%esp
  801dde:	ff 75 08             	pushl  0x8(%ebp)
  801de1:	ff 75 b0             	pushl  -0x50(%ebp)
  801de4:	e8 c2 05 00 00       	call   8023ab <sys_allocateMem>
  801de9:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801dec:	a1 40 30 80 00       	mov    0x803040,%eax
  801df1:	8b 55 08             	mov    0x8(%ebp),%edx
  801df4:	89 14 c5 64 30 88 00 	mov    %edx,0x883064(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801dfb:	a1 40 30 80 00       	mov    0x803040,%eax
  801e00:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801e03:	89 14 c5 60 30 88 00 	mov    %edx,0x883060(,%eax,8)
		cnt_mem++;
  801e0a:	a1 40 30 80 00       	mov    0x803040,%eax
  801e0f:	40                   	inc    %eax
  801e10:	a3 40 30 80 00       	mov    %eax,0x803040
		i = 0;
  801e15:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801e1c:	eb 24                	jmp    801e42 <malloc+0x6ce>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801e1e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801e21:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801e26:	c1 e8 0c             	shr    $0xc,%eax
  801e29:	c7 04 85 60 30 80 00 	movl   $0x1,0x803060(,%eax,4)
  801e30:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801e34:	81 45 b0 00 10 00 00 	addl   $0x1000,-0x50(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801e3b:	81 45 a4 00 10 00 00 	addl   $0x1000,-0x5c(%ebp)
  801e42:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801e45:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e48:	72 d4                	jb     801e1e <malloc+0x6aa>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801e4a:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  801e50:	e9 bf 02 00 00       	jmp    802114 <malloc+0x9a0>

	}
	else if(sys_isUHeapPlacementStrategyWORSTFIT())
  801e55:	e8 d6 08 00 00       	call   802730 <sys_isUHeapPlacementStrategyWORSTFIT>
  801e5a:	85 c0                	test   %eax,%eax
  801e5c:	0f 84 ba 01 00 00    	je     80201c <malloc+0x8a8>
	{
		size = ROUNDUP(size, PAGE_SIZE);
  801e62:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  801e69:	10 00 00 
  801e6c:	8b 55 08             	mov    0x8(%ebp),%edx
  801e6f:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  801e75:	01 d0                	add    %edx,%eax
  801e77:	48                   	dec    %eax
  801e78:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  801e7e:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  801e84:	ba 00 00 00 00       	mov    $0x0,%edx
  801e89:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  801e8f:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  801e95:	29 d0                	sub    %edx,%eax
  801e97:	89 45 08             	mov    %eax,0x8(%ebp)

				if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801e9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e9e:	74 09                	je     801ea9 <malloc+0x735>
  801ea0:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801ea7:	76 0a                	jbe    801eb3 <malloc+0x73f>
					return NULL;
  801ea9:	b8 00 00 00 00       	mov    $0x0,%eax
  801eae:	e9 61 02 00 00       	jmp    802114 <malloc+0x9a0>
				}
				uint32 ptr = (uint32) USER_HEAP_START;
  801eb3:	c7 45 a0 00 00 00 80 	movl   $0x80000000,-0x60(%ebp)
				uint32 temp = 0;
  801eba:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
				uint32 max_sz = -1;
  801ec1:	c7 45 98 ff ff ff ff 	movl   $0xffffffff,-0x68(%ebp)
				uint32 count = 0;
  801ec8:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
				int i = 0;
  801ecf:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				uint32 num_p = size / PAGE_SIZE;
  801ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed9:	c1 e8 0c             	shr    $0xc,%eax
  801edc:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  801ee2:	e9 80 00 00 00       	jmp    801f67 <malloc+0x7f3>

					if (heap_mem[i] == 0) {
  801ee7:	8b 45 90             	mov    -0x70(%ebp),%eax
  801eea:	8b 04 85 60 30 80 00 	mov    0x803060(,%eax,4),%eax
  801ef1:	85 c0                	test   %eax,%eax
  801ef3:	75 0c                	jne    801f01 <malloc+0x78d>

						count++;
  801ef5:	ff 45 94             	incl   -0x6c(%ebp)
						ptr += PAGE_SIZE;
  801ef8:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
  801eff:	eb 2d                	jmp    801f2e <malloc+0x7ba>
					} else {
						if (num_p <= count && max_sz < count) {
  801f01:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801f07:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801f0a:	77 14                	ja     801f20 <malloc+0x7ac>
  801f0c:	8b 45 98             	mov    -0x68(%ebp),%eax
  801f0f:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801f12:	73 0c                	jae    801f20 <malloc+0x7ac>

							max_sz = count;
  801f14:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801f17:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  801f1a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801f1d:	89 45 9c             	mov    %eax,-0x64(%ebp)

						}
						count = 0;
  801f20:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
						ptr += PAGE_SIZE;
  801f27:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
					}

					if (i == size_uhmem - 1) {
  801f2e:	81 7d 90 ff ff 01 00 	cmpl   $0x1ffff,-0x70(%ebp)
  801f35:	75 2d                	jne    801f64 <malloc+0x7f0>

						if (num_p <= count && max_sz > count) {
  801f37:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801f3d:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801f40:	77 22                	ja     801f64 <malloc+0x7f0>
  801f42:	8b 45 98             	mov    -0x68(%ebp),%eax
  801f45:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801f48:	76 1a                	jbe    801f64 <malloc+0x7f0>

							max_sz = count;
  801f4a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801f4d:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  801f50:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801f53:	89 45 9c             	mov    %eax,-0x64(%ebp)
							count = 0;
  801f56:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
							ptr += PAGE_SIZE;
  801f5d:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
				uint32 count = 0;
				int i = 0;
				uint32 num_p = size / PAGE_SIZE;

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  801f64:	ff 45 90             	incl   -0x70(%ebp)
  801f67:	8b 45 90             	mov    -0x70(%ebp),%eax
  801f6a:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801f6f:	0f 86 72 ff ff ff    	jbe    801ee7 <malloc+0x773>

					}

				}

				if (num_p > max_sz || temp == 0) {
  801f75:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801f7b:	3b 45 98             	cmp    -0x68(%ebp),%eax
  801f7e:	77 06                	ja     801f86 <malloc+0x812>
  801f80:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  801f84:	75 0a                	jne    801f90 <malloc+0x81c>
					return NULL;
  801f86:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8b:	e9 84 01 00 00       	jmp    802114 <malloc+0x9a0>

				}

				temp = temp - (PAGE_SIZE * max_sz);
  801f90:	8b 45 98             	mov    -0x68(%ebp),%eax
  801f93:	c1 e0 0c             	shl    $0xc,%eax
  801f96:	29 45 9c             	sub    %eax,-0x64(%ebp)
				void* ret = (void*) temp;
  801f99:	8b 45 9c             	mov    -0x64(%ebp),%eax
  801f9c:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

				sys_allocateMem(temp, size);
  801fa2:	83 ec 08             	sub    $0x8,%esp
  801fa5:	ff 75 08             	pushl  0x8(%ebp)
  801fa8:	ff 75 9c             	pushl  -0x64(%ebp)
  801fab:	e8 fb 03 00 00       	call   8023ab <sys_allocateMem>
  801fb0:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  801fb3:	a1 40 30 80 00       	mov    0x803040,%eax
  801fb8:	8b 55 08             	mov    0x8(%ebp),%edx
  801fbb:	89 14 c5 64 30 88 00 	mov    %edx,0x883064(,%eax,8)
				heap_size[cnt_mem].vir = (void*) temp;
  801fc2:	a1 40 30 80 00       	mov    0x803040,%eax
  801fc7:	8b 55 9c             	mov    -0x64(%ebp),%edx
  801fca:	89 14 c5 60 30 88 00 	mov    %edx,0x883060(,%eax,8)
				cnt_mem++;
  801fd1:	a1 40 30 80 00       	mov    0x803040,%eax
  801fd6:	40                   	inc    %eax
  801fd7:	a3 40 30 80 00       	mov    %eax,0x803040
				i = 0;
  801fdc:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801fe3:	eb 24                	jmp    802009 <malloc+0x895>
				{

					heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801fe5:	8b 45 9c             	mov    -0x64(%ebp),%eax
  801fe8:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  801fed:	c1 e8 0c             	shr    $0xc,%eax
  801ff0:	c7 04 85 60 30 80 00 	movl   $0x1,0x803060(,%eax,4)
  801ff7:	01 00 00 00 

					temp += (uint32) PAGE_SIZE;
  801ffb:	81 45 9c 00 10 00 00 	addl   $0x1000,-0x64(%ebp)
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) temp;
				cnt_mem++;
				i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  802002:	81 45 90 00 10 00 00 	addl   $0x1000,-0x70(%ebp)
  802009:	8b 45 90             	mov    -0x70(%ebp),%eax
  80200c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80200f:	72 d4                	jb     801fe5 <malloc+0x871>

					temp += (uint32) PAGE_SIZE;
				}

				//cprintf("\n size = %d.........vir= %d  \n",num_p,((uint32) ret-USER_HEAP_START)/PAGE_SIZE);
				return ret;
  802011:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  802017:	e9 f8 00 00 00       	jmp    802114 <malloc+0x9a0>

	}
// this is to make malloc is work
	void* ret = NULL;
  80201c:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
	size = ROUNDUP(size, PAGE_SIZE);
  802023:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  80202a:	10 00 00 
  80202d:	8b 55 08             	mov    0x8(%ebp),%edx
  802030:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  802036:	01 d0                	add    %edx,%eax
  802038:	48                   	dec    %eax
  802039:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  80203f:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  802045:	ba 00 00 00 00       	mov    $0x0,%edx
  80204a:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  802050:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  802056:	29 d0                	sub    %edx,%eax
  802058:	89 45 08             	mov    %eax,0x8(%ebp)

	if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  80205b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80205f:	74 09                	je     80206a <malloc+0x8f6>
  802061:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  802068:	76 0a                	jbe    802074 <malloc+0x900>
		return NULL;
  80206a:	b8 00 00 00 00       	mov    $0x0,%eax
  80206f:	e9 a0 00 00 00       	jmp    802114 <malloc+0x9a0>
	}

	if (ptr_uheap + size <= (uint32) USER_HEAP_MAX) {
  802074:	8b 15 04 30 80 00    	mov    0x803004,%edx
  80207a:	8b 45 08             	mov    0x8(%ebp),%eax
  80207d:	01 d0                	add    %edx,%eax
  80207f:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802084:	0f 87 87 00 00 00    	ja     802111 <malloc+0x99d>

		ret = (void *) ptr_uheap;
  80208a:	a1 04 30 80 00       	mov    0x803004,%eax
  80208f:	89 45 8c             	mov    %eax,-0x74(%ebp)
		sys_allocateMem(ptr_uheap, size);
  802092:	a1 04 30 80 00       	mov    0x803004,%eax
  802097:	83 ec 08             	sub    $0x8,%esp
  80209a:	ff 75 08             	pushl  0x8(%ebp)
  80209d:	50                   	push   %eax
  80209e:	e8 08 03 00 00       	call   8023ab <sys_allocateMem>
  8020a3:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  8020a6:	a1 40 30 80 00       	mov    0x803040,%eax
  8020ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8020ae:	89 14 c5 64 30 88 00 	mov    %edx,0x883064(,%eax,8)
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8020b5:	a1 40 30 80 00       	mov    0x803040,%eax
  8020ba:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8020c0:	89 14 c5 60 30 88 00 	mov    %edx,0x883060(,%eax,8)
		cnt_mem++;
  8020c7:	a1 40 30 80 00       	mov    0x803040,%eax
  8020cc:	40                   	inc    %eax
  8020cd:	a3 40 30 80 00       	mov    %eax,0x803040
		int i = 0;
  8020d2:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)

		for (; i < size; i += PAGE_SIZE)
  8020d9:	eb 2e                	jmp    802109 <malloc+0x995>
		{

			heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8020db:	a1 04 30 80 00       	mov    0x803004,%eax
  8020e0:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  8020e5:	c1 e8 0c             	shr    $0xc,%eax
  8020e8:	c7 04 85 60 30 80 00 	movl   $0x1,0x803060(,%eax,4)
  8020ef:	01 00 00 00 

			ptr_uheap += (uint32) PAGE_SIZE;
  8020f3:	a1 04 30 80 00       	mov    0x803004,%eax
  8020f8:	05 00 10 00 00       	add    $0x1000,%eax
  8020fd:	a3 04 30 80 00       	mov    %eax,0x803004
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
		cnt_mem++;
		int i = 0;

		for (; i < size; i += PAGE_SIZE)
  802102:	81 45 88 00 10 00 00 	addl   $0x1000,-0x78(%ebp)
  802109:	8b 45 88             	mov    -0x78(%ebp),%eax
  80210c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80210f:	72 ca                	jb     8020db <malloc+0x967>
					/ (uint32) PAGE_SIZE)] = 1;

			ptr_uheap += (uint32) PAGE_SIZE;
		}
	}
	return ret;
  802111:	8b 45 8c             	mov    -0x74(%ebp),%eax

	//TODO: [PROJECT 2016 - BONUS2] Apply FIRST FIT and WORST FIT policies

//return 0;

}
  802114:	c9                   	leave  
  802115:	c3                   	ret    

00802116 <free>:
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address) {
  802116:	55                   	push   %ebp
  802117:	89 e5                	mov    %esp,%ebp
  802119:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
  80211c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; inx < cnt_mem; inx++) {
  802123:	e9 c1 00 00 00       	jmp    8021e9 <free+0xd3>
		if (heap_size[inx].vir == virtual_address) {
  802128:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212b:	8b 04 c5 60 30 88 00 	mov    0x883060(,%eax,8),%eax
  802132:	3b 45 08             	cmp    0x8(%ebp),%eax
  802135:	0f 85 ab 00 00 00    	jne    8021e6 <free+0xd0>

			if (heap_size[inx].size == 0) {
  80213b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213e:	8b 04 c5 64 30 88 00 	mov    0x883064(,%eax,8),%eax
  802145:	85 c0                	test   %eax,%eax
  802147:	75 21                	jne    80216a <free+0x54>
				heap_size[inx].size = 0;
  802149:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214c:	c7 04 c5 64 30 88 00 	movl   $0x0,0x883064(,%eax,8)
  802153:	00 00 00 00 
				heap_size[inx].vir = NULL;
  802157:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215a:	c7 04 c5 60 30 88 00 	movl   $0x0,0x883060(,%eax,8)
  802161:	00 00 00 00 
				return;
  802165:	e9 8d 00 00 00       	jmp    8021f7 <free+0xe1>

			}

			sys_freeMem((uint32) virtual_address, heap_size[inx].size);
  80216a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216d:	8b 14 c5 64 30 88 00 	mov    0x883064(,%eax,8),%edx
  802174:	8b 45 08             	mov    0x8(%ebp),%eax
  802177:	83 ec 08             	sub    $0x8,%esp
  80217a:	52                   	push   %edx
  80217b:	50                   	push   %eax
  80217c:	e8 0e 02 00 00       	call   80238f <sys_freeMem>
  802181:	83 c4 10             	add    $0x10,%esp

			int i = 0;
  802184:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
  80218b:	8b 45 08             	mov    0x8(%ebp),%eax
  80218e:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  802191:	eb 24                	jmp    8021b7 <free+0xa1>
			{
				heap_mem[(int) (((uint32) va - USER_HEAP_START) / PAGE_SIZE)] =
  802193:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802196:	05 00 00 00 80       	add    $0x80000000,%eax
  80219b:	c1 e8 0c             	shr    $0xc,%eax
  80219e:	c7 04 85 60 30 80 00 	movl   $0x0,0x803060(,%eax,4)
  8021a5:	00 00 00 00 
						0;

				va += PAGE_SIZE;
  8021a9:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
			sys_freeMem((uint32) virtual_address, heap_size[inx].size);

			int i = 0;
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  8021b0:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  8021b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ba:	8b 14 c5 64 30 88 00 	mov    0x883064(,%eax,8),%edx
  8021c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c4:	39 c2                	cmp    %eax,%edx
  8021c6:	77 cb                	ja     802193 <free+0x7d>

				va += PAGE_SIZE;

			}

			heap_size[inx].size = 0;
  8021c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cb:	c7 04 c5 64 30 88 00 	movl   $0x0,0x883064(,%eax,8)
  8021d2:	00 00 00 00 
			heap_size[inx].vir = NULL;
  8021d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d9:	c7 04 c5 60 30 88 00 	movl   $0x0,0x883060(,%eax,8)
  8021e0:	00 00 00 00 
			break;
  8021e4:	eb 11                	jmp    8021f7 <free+0xe1>
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
	for (; inx < cnt_mem; inx++) {
  8021e6:	ff 45 f4             	incl   -0xc(%ebp)
  8021e9:	a1 40 30 80 00       	mov    0x803040,%eax
  8021ee:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  8021f1:	0f 8c 31 ff ff ff    	jl     802128 <free+0x12>
	}

	//get the size of the given allocation using its address
	//you need to call sys_freeMem()

}
  8021f7:	c9                   	leave  
  8021f8:	c3                   	ret    

008021f9 <realloc>:
//  Hint: you may need to use the sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size) {
  8021f9:	55                   	push   %ebp
  8021fa:	89 e5                	mov    %esp,%ebp
  8021fc:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2016 - BONUS4] realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8021ff:	83 ec 04             	sub    $0x4,%esp
  802202:	68 a4 2f 80 00       	push   $0x802fa4
  802207:	68 1c 02 00 00       	push   $0x21c
  80220c:	68 ca 2f 80 00       	push   $0x802fca
  802211:	e8 aa e4 ff ff       	call   8006c0 <_panic>

00802216 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
  802219:	57                   	push   %edi
  80221a:	56                   	push   %esi
  80221b:	53                   	push   %ebx
  80221c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80221f:	8b 45 08             	mov    0x8(%ebp),%eax
  802222:	8b 55 0c             	mov    0xc(%ebp),%edx
  802225:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802228:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80222b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80222e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802231:	cd 30                	int    $0x30
  802233:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802236:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802239:	83 c4 10             	add    $0x10,%esp
  80223c:	5b                   	pop    %ebx
  80223d:	5e                   	pop    %esi
  80223e:	5f                   	pop    %edi
  80223f:	5d                   	pop    %ebp
  802240:	c3                   	ret    

00802241 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  802241:	55                   	push   %ebp
  802242:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  802244:	8b 45 08             	mov    0x8(%ebp),%eax
  802247:	6a 00                	push   $0x0
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	ff 75 0c             	pushl  0xc(%ebp)
  802250:	50                   	push   %eax
  802251:	6a 00                	push   $0x0
  802253:	e8 be ff ff ff       	call   802216 <syscall>
  802258:	83 c4 18             	add    $0x18,%esp
}
  80225b:	90                   	nop
  80225c:	c9                   	leave  
  80225d:	c3                   	ret    

0080225e <sys_cgetc>:

int
sys_cgetc(void)
{
  80225e:	55                   	push   %ebp
  80225f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 01                	push   $0x1
  80226d:	e8 a4 ff ff ff       	call   802216 <syscall>
  802272:	83 c4 18             	add    $0x18,%esp
}
  802275:	c9                   	leave  
  802276:	c3                   	ret    

00802277 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80227a:	8b 45 08             	mov    0x8(%ebp),%eax
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	50                   	push   %eax
  802286:	6a 03                	push   $0x3
  802288:	e8 89 ff ff ff       	call   802216 <syscall>
  80228d:	83 c4 18             	add    $0x18,%esp
}
  802290:	c9                   	leave  
  802291:	c3                   	ret    

00802292 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802292:	55                   	push   %ebp
  802293:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802295:	6a 00                	push   $0x0
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	6a 02                	push   $0x2
  8022a1:	e8 70 ff ff ff       	call   802216 <syscall>
  8022a6:	83 c4 18             	add    $0x18,%esp
}
  8022a9:	c9                   	leave  
  8022aa:	c3                   	ret    

008022ab <sys_env_exit>:

void sys_env_exit(void)
{
  8022ab:	55                   	push   %ebp
  8022ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8022ae:	6a 00                	push   $0x0
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 04                	push   $0x4
  8022ba:	e8 57 ff ff ff       	call   802216 <syscall>
  8022bf:	83 c4 18             	add    $0x18,%esp
}
  8022c2:	90                   	nop
  8022c3:	c9                   	leave  
  8022c4:	c3                   	ret    

008022c5 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8022c5:	55                   	push   %ebp
  8022c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8022c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	52                   	push   %edx
  8022d5:	50                   	push   %eax
  8022d6:	6a 05                	push   $0x5
  8022d8:	e8 39 ff ff ff       	call   802216 <syscall>
  8022dd:	83 c4 18             	add    $0x18,%esp
}
  8022e0:	c9                   	leave  
  8022e1:	c3                   	ret    

008022e2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8022e2:	55                   	push   %ebp
  8022e3:	89 e5                	mov    %esp,%ebp
  8022e5:	56                   	push   %esi
  8022e6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8022e7:	8b 75 18             	mov    0x18(%ebp),%esi
  8022ea:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f6:	56                   	push   %esi
  8022f7:	53                   	push   %ebx
  8022f8:	51                   	push   %ecx
  8022f9:	52                   	push   %edx
  8022fa:	50                   	push   %eax
  8022fb:	6a 06                	push   $0x6
  8022fd:	e8 14 ff ff ff       	call   802216 <syscall>
  802302:	83 c4 18             	add    $0x18,%esp
}
  802305:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802308:	5b                   	pop    %ebx
  802309:	5e                   	pop    %esi
  80230a:	5d                   	pop    %ebp
  80230b:	c3                   	ret    

0080230c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80230c:	55                   	push   %ebp
  80230d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80230f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802312:	8b 45 08             	mov    0x8(%ebp),%eax
  802315:	6a 00                	push   $0x0
  802317:	6a 00                	push   $0x0
  802319:	6a 00                	push   $0x0
  80231b:	52                   	push   %edx
  80231c:	50                   	push   %eax
  80231d:	6a 07                	push   $0x7
  80231f:	e8 f2 fe ff ff       	call   802216 <syscall>
  802324:	83 c4 18             	add    $0x18,%esp
}
  802327:	c9                   	leave  
  802328:	c3                   	ret    

00802329 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802329:	55                   	push   %ebp
  80232a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80232c:	6a 00                	push   $0x0
  80232e:	6a 00                	push   $0x0
  802330:	6a 00                	push   $0x0
  802332:	ff 75 0c             	pushl  0xc(%ebp)
  802335:	ff 75 08             	pushl  0x8(%ebp)
  802338:	6a 08                	push   $0x8
  80233a:	e8 d7 fe ff ff       	call   802216 <syscall>
  80233f:	83 c4 18             	add    $0x18,%esp
}
  802342:	c9                   	leave  
  802343:	c3                   	ret    

00802344 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802344:	55                   	push   %ebp
  802345:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802347:	6a 00                	push   $0x0
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	6a 00                	push   $0x0
  802351:	6a 09                	push   $0x9
  802353:	e8 be fe ff ff       	call   802216 <syscall>
  802358:	83 c4 18             	add    $0x18,%esp
}
  80235b:	c9                   	leave  
  80235c:	c3                   	ret    

0080235d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80235d:	55                   	push   %ebp
  80235e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	6a 00                	push   $0x0
  802368:	6a 00                	push   $0x0
  80236a:	6a 0a                	push   $0xa
  80236c:	e8 a5 fe ff ff       	call   802216 <syscall>
  802371:	83 c4 18             	add    $0x18,%esp
}
  802374:	c9                   	leave  
  802375:	c3                   	ret    

00802376 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802376:	55                   	push   %ebp
  802377:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802379:	6a 00                	push   $0x0
  80237b:	6a 00                	push   $0x0
  80237d:	6a 00                	push   $0x0
  80237f:	6a 00                	push   $0x0
  802381:	6a 00                	push   $0x0
  802383:	6a 0b                	push   $0xb
  802385:	e8 8c fe ff ff       	call   802216 <syscall>
  80238a:	83 c4 18             	add    $0x18,%esp
}
  80238d:	c9                   	leave  
  80238e:	c3                   	ret    

0080238f <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  80238f:	55                   	push   %ebp
  802390:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  802392:	6a 00                	push   $0x0
  802394:	6a 00                	push   $0x0
  802396:	6a 00                	push   $0x0
  802398:	ff 75 0c             	pushl  0xc(%ebp)
  80239b:	ff 75 08             	pushl  0x8(%ebp)
  80239e:	6a 0d                	push   $0xd
  8023a0:	e8 71 fe ff ff       	call   802216 <syscall>
  8023a5:	83 c4 18             	add    $0x18,%esp
	return;
  8023a8:	90                   	nop
}
  8023a9:	c9                   	leave  
  8023aa:	c3                   	ret    

008023ab <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8023ab:	55                   	push   %ebp
  8023ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8023ae:	6a 00                	push   $0x0
  8023b0:	6a 00                	push   $0x0
  8023b2:	6a 00                	push   $0x0
  8023b4:	ff 75 0c             	pushl  0xc(%ebp)
  8023b7:	ff 75 08             	pushl  0x8(%ebp)
  8023ba:	6a 0e                	push   $0xe
  8023bc:	e8 55 fe ff ff       	call   802216 <syscall>
  8023c1:	83 c4 18             	add    $0x18,%esp
	return ;
  8023c4:	90                   	nop
}
  8023c5:	c9                   	leave  
  8023c6:	c3                   	ret    

008023c7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8023c7:	55                   	push   %ebp
  8023c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 0c                	push   $0xc
  8023d6:	e8 3b fe ff ff       	call   802216 <syscall>
  8023db:	83 c4 18             	add    $0x18,%esp
}
  8023de:	c9                   	leave  
  8023df:	c3                   	ret    

008023e0 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8023e0:	55                   	push   %ebp
  8023e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 00                	push   $0x0
  8023e9:	6a 00                	push   $0x0
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 10                	push   $0x10
  8023ef:	e8 22 fe ff ff       	call   802216 <syscall>
  8023f4:	83 c4 18             	add    $0x18,%esp
}
  8023f7:	90                   	nop
  8023f8:	c9                   	leave  
  8023f9:	c3                   	ret    

008023fa <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8023fa:	55                   	push   %ebp
  8023fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 00                	push   $0x0
  802403:	6a 00                	push   $0x0
  802405:	6a 00                	push   $0x0
  802407:	6a 11                	push   $0x11
  802409:	e8 08 fe ff ff       	call   802216 <syscall>
  80240e:	83 c4 18             	add    $0x18,%esp
}
  802411:	90                   	nop
  802412:	c9                   	leave  
  802413:	c3                   	ret    

00802414 <sys_cputc>:


void
sys_cputc(const char c)
{
  802414:	55                   	push   %ebp
  802415:	89 e5                	mov    %esp,%ebp
  802417:	83 ec 04             	sub    $0x4,%esp
  80241a:	8b 45 08             	mov    0x8(%ebp),%eax
  80241d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802420:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802424:	6a 00                	push   $0x0
  802426:	6a 00                	push   $0x0
  802428:	6a 00                	push   $0x0
  80242a:	6a 00                	push   $0x0
  80242c:	50                   	push   %eax
  80242d:	6a 12                	push   $0x12
  80242f:	e8 e2 fd ff ff       	call   802216 <syscall>
  802434:	83 c4 18             	add    $0x18,%esp
}
  802437:	90                   	nop
  802438:	c9                   	leave  
  802439:	c3                   	ret    

0080243a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80243a:	55                   	push   %ebp
  80243b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80243d:	6a 00                	push   $0x0
  80243f:	6a 00                	push   $0x0
  802441:	6a 00                	push   $0x0
  802443:	6a 00                	push   $0x0
  802445:	6a 00                	push   $0x0
  802447:	6a 13                	push   $0x13
  802449:	e8 c8 fd ff ff       	call   802216 <syscall>
  80244e:	83 c4 18             	add    $0x18,%esp
}
  802451:	90                   	nop
  802452:	c9                   	leave  
  802453:	c3                   	ret    

00802454 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802454:	55                   	push   %ebp
  802455:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802457:	8b 45 08             	mov    0x8(%ebp),%eax
  80245a:	6a 00                	push   $0x0
  80245c:	6a 00                	push   $0x0
  80245e:	6a 00                	push   $0x0
  802460:	ff 75 0c             	pushl  0xc(%ebp)
  802463:	50                   	push   %eax
  802464:	6a 14                	push   $0x14
  802466:	e8 ab fd ff ff       	call   802216 <syscall>
  80246b:	83 c4 18             	add    $0x18,%esp
}
  80246e:	c9                   	leave  
  80246f:	c3                   	ret    

00802470 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  802470:	55                   	push   %ebp
  802471:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  802473:	8b 45 08             	mov    0x8(%ebp),%eax
  802476:	6a 00                	push   $0x0
  802478:	6a 00                	push   $0x0
  80247a:	6a 00                	push   $0x0
  80247c:	6a 00                	push   $0x0
  80247e:	50                   	push   %eax
  80247f:	6a 17                	push   $0x17
  802481:	e8 90 fd ff ff       	call   802216 <syscall>
  802486:	83 c4 18             	add    $0x18,%esp
}
  802489:	c9                   	leave  
  80248a:	c3                   	ret    

0080248b <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  80248b:	55                   	push   %ebp
  80248c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  80248e:	8b 45 08             	mov    0x8(%ebp),%eax
  802491:	6a 00                	push   $0x0
  802493:	6a 00                	push   $0x0
  802495:	6a 00                	push   $0x0
  802497:	6a 00                	push   $0x0
  802499:	50                   	push   %eax
  80249a:	6a 15                	push   $0x15
  80249c:	e8 75 fd ff ff       	call   802216 <syscall>
  8024a1:	83 c4 18             	add    $0x18,%esp
}
  8024a4:	90                   	nop
  8024a5:	c9                   	leave  
  8024a6:	c3                   	ret    

008024a7 <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  8024a7:	55                   	push   %ebp
  8024a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  8024aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ad:	6a 00                	push   $0x0
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 00                	push   $0x0
  8024b3:	6a 00                	push   $0x0
  8024b5:	50                   	push   %eax
  8024b6:	6a 16                	push   $0x16
  8024b8:	e8 59 fd ff ff       	call   802216 <syscall>
  8024bd:	83 c4 18             	add    $0x18,%esp
}
  8024c0:	90                   	nop
  8024c1:	c9                   	leave  
  8024c2:	c3                   	ret    

008024c3 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  8024c3:	55                   	push   %ebp
  8024c4:	89 e5                	mov    %esp,%ebp
  8024c6:	83 ec 04             	sub    $0x4,%esp
  8024c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8024cc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  8024cf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8024d2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8024d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d9:	6a 00                	push   $0x0
  8024db:	51                   	push   %ecx
  8024dc:	52                   	push   %edx
  8024dd:	ff 75 0c             	pushl  0xc(%ebp)
  8024e0:	50                   	push   %eax
  8024e1:	6a 18                	push   $0x18
  8024e3:	e8 2e fd ff ff       	call   802216 <syscall>
  8024e8:	83 c4 18             	add    $0x18,%esp
}
  8024eb:	c9                   	leave  
  8024ec:	c3                   	ret    

008024ed <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  8024ed:	55                   	push   %ebp
  8024ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  8024f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f6:	6a 00                	push   $0x0
  8024f8:	6a 00                	push   $0x0
  8024fa:	6a 00                	push   $0x0
  8024fc:	52                   	push   %edx
  8024fd:	50                   	push   %eax
  8024fe:	6a 19                	push   $0x19
  802500:	e8 11 fd ff ff       	call   802216 <syscall>
  802505:	83 c4 18             	add    $0x18,%esp
}
  802508:	c9                   	leave  
  802509:	c3                   	ret    

0080250a <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  80250a:	55                   	push   %ebp
  80250b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  80250d:	8b 45 08             	mov    0x8(%ebp),%eax
  802510:	6a 00                	push   $0x0
  802512:	6a 00                	push   $0x0
  802514:	6a 00                	push   $0x0
  802516:	6a 00                	push   $0x0
  802518:	50                   	push   %eax
  802519:	6a 1a                	push   $0x1a
  80251b:	e8 f6 fc ff ff       	call   802216 <syscall>
  802520:	83 c4 18             	add    $0x18,%esp
}
  802523:	c9                   	leave  
  802524:	c3                   	ret    

00802525 <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  802525:	55                   	push   %ebp
  802526:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  802528:	6a 00                	push   $0x0
  80252a:	6a 00                	push   $0x0
  80252c:	6a 00                	push   $0x0
  80252e:	6a 00                	push   $0x0
  802530:	6a 00                	push   $0x0
  802532:	6a 1b                	push   $0x1b
  802534:	e8 dd fc ff ff       	call   802216 <syscall>
  802539:	83 c4 18             	add    $0x18,%esp
}
  80253c:	c9                   	leave  
  80253d:	c3                   	ret    

0080253e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80253e:	55                   	push   %ebp
  80253f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802541:	6a 00                	push   $0x0
  802543:	6a 00                	push   $0x0
  802545:	6a 00                	push   $0x0
  802547:	6a 00                	push   $0x0
  802549:	6a 00                	push   $0x0
  80254b:	6a 1c                	push   $0x1c
  80254d:	e8 c4 fc ff ff       	call   802216 <syscall>
  802552:	83 c4 18             	add    $0x18,%esp
}
  802555:	c9                   	leave  
  802556:	c3                   	ret    

00802557 <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  802557:	55                   	push   %ebp
  802558:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  80255a:	8b 45 08             	mov    0x8(%ebp),%eax
  80255d:	6a 00                	push   $0x0
  80255f:	6a 00                	push   $0x0
  802561:	6a 00                	push   $0x0
  802563:	ff 75 0c             	pushl  0xc(%ebp)
  802566:	50                   	push   %eax
  802567:	6a 1d                	push   $0x1d
  802569:	e8 a8 fc ff ff       	call   802216 <syscall>
  80256e:	83 c4 18             	add    $0x18,%esp
}
  802571:	c9                   	leave  
  802572:	c3                   	ret    

00802573 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802573:	55                   	push   %ebp
  802574:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802576:	8b 45 08             	mov    0x8(%ebp),%eax
  802579:	6a 00                	push   $0x0
  80257b:	6a 00                	push   $0x0
  80257d:	6a 00                	push   $0x0
  80257f:	6a 00                	push   $0x0
  802581:	50                   	push   %eax
  802582:	6a 1e                	push   $0x1e
  802584:	e8 8d fc ff ff       	call   802216 <syscall>
  802589:	83 c4 18             	add    $0x18,%esp
}
  80258c:	90                   	nop
  80258d:	c9                   	leave  
  80258e:	c3                   	ret    

0080258f <sys_free_env>:

void
sys_free_env(int32 envId)
{
  80258f:	55                   	push   %ebp
  802590:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  802592:	8b 45 08             	mov    0x8(%ebp),%eax
  802595:	6a 00                	push   $0x0
  802597:	6a 00                	push   $0x0
  802599:	6a 00                	push   $0x0
  80259b:	6a 00                	push   $0x0
  80259d:	50                   	push   %eax
  80259e:	6a 1f                	push   $0x1f
  8025a0:	e8 71 fc ff ff       	call   802216 <syscall>
  8025a5:	83 c4 18             	add    $0x18,%esp
}
  8025a8:	90                   	nop
  8025a9:	c9                   	leave  
  8025aa:	c3                   	ret    

008025ab <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8025ab:	55                   	push   %ebp
  8025ac:	89 e5                	mov    %esp,%ebp
  8025ae:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8025b1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8025b4:	8d 50 04             	lea    0x4(%eax),%edx
  8025b7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8025ba:	6a 00                	push   $0x0
  8025bc:	6a 00                	push   $0x0
  8025be:	6a 00                	push   $0x0
  8025c0:	52                   	push   %edx
  8025c1:	50                   	push   %eax
  8025c2:	6a 20                	push   $0x20
  8025c4:	e8 4d fc ff ff       	call   802216 <syscall>
  8025c9:	83 c4 18             	add    $0x18,%esp
	return result;
  8025cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8025d5:	89 01                	mov    %eax,(%ecx)
  8025d7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8025da:	8b 45 08             	mov    0x8(%ebp),%eax
  8025dd:	c9                   	leave  
  8025de:	c2 04 00             	ret    $0x4

008025e1 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8025e1:	55                   	push   %ebp
  8025e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8025e4:	6a 00                	push   $0x0
  8025e6:	6a 00                	push   $0x0
  8025e8:	ff 75 10             	pushl  0x10(%ebp)
  8025eb:	ff 75 0c             	pushl  0xc(%ebp)
  8025ee:	ff 75 08             	pushl  0x8(%ebp)
  8025f1:	6a 0f                	push   $0xf
  8025f3:	e8 1e fc ff ff       	call   802216 <syscall>
  8025f8:	83 c4 18             	add    $0x18,%esp
	return ;
  8025fb:	90                   	nop
}
  8025fc:	c9                   	leave  
  8025fd:	c3                   	ret    

008025fe <sys_rcr2>:
uint32 sys_rcr2()
{
  8025fe:	55                   	push   %ebp
  8025ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802601:	6a 00                	push   $0x0
  802603:	6a 00                	push   $0x0
  802605:	6a 00                	push   $0x0
  802607:	6a 00                	push   $0x0
  802609:	6a 00                	push   $0x0
  80260b:	6a 21                	push   $0x21
  80260d:	e8 04 fc ff ff       	call   802216 <syscall>
  802612:	83 c4 18             	add    $0x18,%esp
}
  802615:	c9                   	leave  
  802616:	c3                   	ret    

00802617 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802617:	55                   	push   %ebp
  802618:	89 e5                	mov    %esp,%ebp
  80261a:	83 ec 04             	sub    $0x4,%esp
  80261d:	8b 45 08             	mov    0x8(%ebp),%eax
  802620:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802623:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802627:	6a 00                	push   $0x0
  802629:	6a 00                	push   $0x0
  80262b:	6a 00                	push   $0x0
  80262d:	6a 00                	push   $0x0
  80262f:	50                   	push   %eax
  802630:	6a 22                	push   $0x22
  802632:	e8 df fb ff ff       	call   802216 <syscall>
  802637:	83 c4 18             	add    $0x18,%esp
	return ;
  80263a:	90                   	nop
}
  80263b:	c9                   	leave  
  80263c:	c3                   	ret    

0080263d <rsttst>:
void rsttst()
{
  80263d:	55                   	push   %ebp
  80263e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802640:	6a 00                	push   $0x0
  802642:	6a 00                	push   $0x0
  802644:	6a 00                	push   $0x0
  802646:	6a 00                	push   $0x0
  802648:	6a 00                	push   $0x0
  80264a:	6a 24                	push   $0x24
  80264c:	e8 c5 fb ff ff       	call   802216 <syscall>
  802651:	83 c4 18             	add    $0x18,%esp
	return ;
  802654:	90                   	nop
}
  802655:	c9                   	leave  
  802656:	c3                   	ret    

00802657 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802657:	55                   	push   %ebp
  802658:	89 e5                	mov    %esp,%ebp
  80265a:	83 ec 04             	sub    $0x4,%esp
  80265d:	8b 45 14             	mov    0x14(%ebp),%eax
  802660:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802663:	8b 55 18             	mov    0x18(%ebp),%edx
  802666:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80266a:	52                   	push   %edx
  80266b:	50                   	push   %eax
  80266c:	ff 75 10             	pushl  0x10(%ebp)
  80266f:	ff 75 0c             	pushl  0xc(%ebp)
  802672:	ff 75 08             	pushl  0x8(%ebp)
  802675:	6a 23                	push   $0x23
  802677:	e8 9a fb ff ff       	call   802216 <syscall>
  80267c:	83 c4 18             	add    $0x18,%esp
	return ;
  80267f:	90                   	nop
}
  802680:	c9                   	leave  
  802681:	c3                   	ret    

00802682 <chktst>:
void chktst(uint32 n)
{
  802682:	55                   	push   %ebp
  802683:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802685:	6a 00                	push   $0x0
  802687:	6a 00                	push   $0x0
  802689:	6a 00                	push   $0x0
  80268b:	6a 00                	push   $0x0
  80268d:	ff 75 08             	pushl  0x8(%ebp)
  802690:	6a 25                	push   $0x25
  802692:	e8 7f fb ff ff       	call   802216 <syscall>
  802697:	83 c4 18             	add    $0x18,%esp
	return ;
  80269a:	90                   	nop
}
  80269b:	c9                   	leave  
  80269c:	c3                   	ret    

0080269d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80269d:	55                   	push   %ebp
  80269e:	89 e5                	mov    %esp,%ebp
  8026a0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026a3:	6a 00                	push   $0x0
  8026a5:	6a 00                	push   $0x0
  8026a7:	6a 00                	push   $0x0
  8026a9:	6a 00                	push   $0x0
  8026ab:	6a 00                	push   $0x0
  8026ad:	6a 26                	push   $0x26
  8026af:	e8 62 fb ff ff       	call   802216 <syscall>
  8026b4:	83 c4 18             	add    $0x18,%esp
  8026b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8026ba:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8026be:	75 07                	jne    8026c7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8026c0:	b8 01 00 00 00       	mov    $0x1,%eax
  8026c5:	eb 05                	jmp    8026cc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8026c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026cc:	c9                   	leave  
  8026cd:	c3                   	ret    

008026ce <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8026ce:	55                   	push   %ebp
  8026cf:	89 e5                	mov    %esp,%ebp
  8026d1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026d4:	6a 00                	push   $0x0
  8026d6:	6a 00                	push   $0x0
  8026d8:	6a 00                	push   $0x0
  8026da:	6a 00                	push   $0x0
  8026dc:	6a 00                	push   $0x0
  8026de:	6a 26                	push   $0x26
  8026e0:	e8 31 fb ff ff       	call   802216 <syscall>
  8026e5:	83 c4 18             	add    $0x18,%esp
  8026e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8026eb:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8026ef:	75 07                	jne    8026f8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8026f1:	b8 01 00 00 00       	mov    $0x1,%eax
  8026f6:	eb 05                	jmp    8026fd <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8026f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026fd:	c9                   	leave  
  8026fe:	c3                   	ret    

008026ff <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8026ff:	55                   	push   %ebp
  802700:	89 e5                	mov    %esp,%ebp
  802702:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802705:	6a 00                	push   $0x0
  802707:	6a 00                	push   $0x0
  802709:	6a 00                	push   $0x0
  80270b:	6a 00                	push   $0x0
  80270d:	6a 00                	push   $0x0
  80270f:	6a 26                	push   $0x26
  802711:	e8 00 fb ff ff       	call   802216 <syscall>
  802716:	83 c4 18             	add    $0x18,%esp
  802719:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80271c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802720:	75 07                	jne    802729 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802722:	b8 01 00 00 00       	mov    $0x1,%eax
  802727:	eb 05                	jmp    80272e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802729:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80272e:	c9                   	leave  
  80272f:	c3                   	ret    

00802730 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802730:	55                   	push   %ebp
  802731:	89 e5                	mov    %esp,%ebp
  802733:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802736:	6a 00                	push   $0x0
  802738:	6a 00                	push   $0x0
  80273a:	6a 00                	push   $0x0
  80273c:	6a 00                	push   $0x0
  80273e:	6a 00                	push   $0x0
  802740:	6a 26                	push   $0x26
  802742:	e8 cf fa ff ff       	call   802216 <syscall>
  802747:	83 c4 18             	add    $0x18,%esp
  80274a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80274d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802751:	75 07                	jne    80275a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802753:	b8 01 00 00 00       	mov    $0x1,%eax
  802758:	eb 05                	jmp    80275f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80275a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80275f:	c9                   	leave  
  802760:	c3                   	ret    

00802761 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802761:	55                   	push   %ebp
  802762:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802764:	6a 00                	push   $0x0
  802766:	6a 00                	push   $0x0
  802768:	6a 00                	push   $0x0
  80276a:	6a 00                	push   $0x0
  80276c:	ff 75 08             	pushl  0x8(%ebp)
  80276f:	6a 27                	push   $0x27
  802771:	e8 a0 fa ff ff       	call   802216 <syscall>
  802776:	83 c4 18             	add    $0x18,%esp
	return ;
  802779:	90                   	nop
}
  80277a:	c9                   	leave  
  80277b:	c3                   	ret    

0080277c <__udivdi3>:
  80277c:	55                   	push   %ebp
  80277d:	57                   	push   %edi
  80277e:	56                   	push   %esi
  80277f:	53                   	push   %ebx
  802780:	83 ec 1c             	sub    $0x1c,%esp
  802783:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802787:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80278b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80278f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802793:	89 ca                	mov    %ecx,%edx
  802795:	89 f8                	mov    %edi,%eax
  802797:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80279b:	85 f6                	test   %esi,%esi
  80279d:	75 2d                	jne    8027cc <__udivdi3+0x50>
  80279f:	39 cf                	cmp    %ecx,%edi
  8027a1:	77 65                	ja     802808 <__udivdi3+0x8c>
  8027a3:	89 fd                	mov    %edi,%ebp
  8027a5:	85 ff                	test   %edi,%edi
  8027a7:	75 0b                	jne    8027b4 <__udivdi3+0x38>
  8027a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8027ae:	31 d2                	xor    %edx,%edx
  8027b0:	f7 f7                	div    %edi
  8027b2:	89 c5                	mov    %eax,%ebp
  8027b4:	31 d2                	xor    %edx,%edx
  8027b6:	89 c8                	mov    %ecx,%eax
  8027b8:	f7 f5                	div    %ebp
  8027ba:	89 c1                	mov    %eax,%ecx
  8027bc:	89 d8                	mov    %ebx,%eax
  8027be:	f7 f5                	div    %ebp
  8027c0:	89 cf                	mov    %ecx,%edi
  8027c2:	89 fa                	mov    %edi,%edx
  8027c4:	83 c4 1c             	add    $0x1c,%esp
  8027c7:	5b                   	pop    %ebx
  8027c8:	5e                   	pop    %esi
  8027c9:	5f                   	pop    %edi
  8027ca:	5d                   	pop    %ebp
  8027cb:	c3                   	ret    
  8027cc:	39 ce                	cmp    %ecx,%esi
  8027ce:	77 28                	ja     8027f8 <__udivdi3+0x7c>
  8027d0:	0f bd fe             	bsr    %esi,%edi
  8027d3:	83 f7 1f             	xor    $0x1f,%edi
  8027d6:	75 40                	jne    802818 <__udivdi3+0x9c>
  8027d8:	39 ce                	cmp    %ecx,%esi
  8027da:	72 0a                	jb     8027e6 <__udivdi3+0x6a>
  8027dc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8027e0:	0f 87 9e 00 00 00    	ja     802884 <__udivdi3+0x108>
  8027e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8027eb:	89 fa                	mov    %edi,%edx
  8027ed:	83 c4 1c             	add    $0x1c,%esp
  8027f0:	5b                   	pop    %ebx
  8027f1:	5e                   	pop    %esi
  8027f2:	5f                   	pop    %edi
  8027f3:	5d                   	pop    %ebp
  8027f4:	c3                   	ret    
  8027f5:	8d 76 00             	lea    0x0(%esi),%esi
  8027f8:	31 ff                	xor    %edi,%edi
  8027fa:	31 c0                	xor    %eax,%eax
  8027fc:	89 fa                	mov    %edi,%edx
  8027fe:	83 c4 1c             	add    $0x1c,%esp
  802801:	5b                   	pop    %ebx
  802802:	5e                   	pop    %esi
  802803:	5f                   	pop    %edi
  802804:	5d                   	pop    %ebp
  802805:	c3                   	ret    
  802806:	66 90                	xchg   %ax,%ax
  802808:	89 d8                	mov    %ebx,%eax
  80280a:	f7 f7                	div    %edi
  80280c:	31 ff                	xor    %edi,%edi
  80280e:	89 fa                	mov    %edi,%edx
  802810:	83 c4 1c             	add    $0x1c,%esp
  802813:	5b                   	pop    %ebx
  802814:	5e                   	pop    %esi
  802815:	5f                   	pop    %edi
  802816:	5d                   	pop    %ebp
  802817:	c3                   	ret    
  802818:	bd 20 00 00 00       	mov    $0x20,%ebp
  80281d:	89 eb                	mov    %ebp,%ebx
  80281f:	29 fb                	sub    %edi,%ebx
  802821:	89 f9                	mov    %edi,%ecx
  802823:	d3 e6                	shl    %cl,%esi
  802825:	89 c5                	mov    %eax,%ebp
  802827:	88 d9                	mov    %bl,%cl
  802829:	d3 ed                	shr    %cl,%ebp
  80282b:	89 e9                	mov    %ebp,%ecx
  80282d:	09 f1                	or     %esi,%ecx
  80282f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802833:	89 f9                	mov    %edi,%ecx
  802835:	d3 e0                	shl    %cl,%eax
  802837:	89 c5                	mov    %eax,%ebp
  802839:	89 d6                	mov    %edx,%esi
  80283b:	88 d9                	mov    %bl,%cl
  80283d:	d3 ee                	shr    %cl,%esi
  80283f:	89 f9                	mov    %edi,%ecx
  802841:	d3 e2                	shl    %cl,%edx
  802843:	8b 44 24 08          	mov    0x8(%esp),%eax
  802847:	88 d9                	mov    %bl,%cl
  802849:	d3 e8                	shr    %cl,%eax
  80284b:	09 c2                	or     %eax,%edx
  80284d:	89 d0                	mov    %edx,%eax
  80284f:	89 f2                	mov    %esi,%edx
  802851:	f7 74 24 0c          	divl   0xc(%esp)
  802855:	89 d6                	mov    %edx,%esi
  802857:	89 c3                	mov    %eax,%ebx
  802859:	f7 e5                	mul    %ebp
  80285b:	39 d6                	cmp    %edx,%esi
  80285d:	72 19                	jb     802878 <__udivdi3+0xfc>
  80285f:	74 0b                	je     80286c <__udivdi3+0xf0>
  802861:	89 d8                	mov    %ebx,%eax
  802863:	31 ff                	xor    %edi,%edi
  802865:	e9 58 ff ff ff       	jmp    8027c2 <__udivdi3+0x46>
  80286a:	66 90                	xchg   %ax,%ax
  80286c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802870:	89 f9                	mov    %edi,%ecx
  802872:	d3 e2                	shl    %cl,%edx
  802874:	39 c2                	cmp    %eax,%edx
  802876:	73 e9                	jae    802861 <__udivdi3+0xe5>
  802878:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80287b:	31 ff                	xor    %edi,%edi
  80287d:	e9 40 ff ff ff       	jmp    8027c2 <__udivdi3+0x46>
  802882:	66 90                	xchg   %ax,%ax
  802884:	31 c0                	xor    %eax,%eax
  802886:	e9 37 ff ff ff       	jmp    8027c2 <__udivdi3+0x46>
  80288b:	90                   	nop

0080288c <__umoddi3>:
  80288c:	55                   	push   %ebp
  80288d:	57                   	push   %edi
  80288e:	56                   	push   %esi
  80288f:	53                   	push   %ebx
  802890:	83 ec 1c             	sub    $0x1c,%esp
  802893:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802897:	8b 74 24 34          	mov    0x34(%esp),%esi
  80289b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80289f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8028a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8028a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8028ab:	89 f3                	mov    %esi,%ebx
  8028ad:	89 fa                	mov    %edi,%edx
  8028af:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8028b3:	89 34 24             	mov    %esi,(%esp)
  8028b6:	85 c0                	test   %eax,%eax
  8028b8:	75 1a                	jne    8028d4 <__umoddi3+0x48>
  8028ba:	39 f7                	cmp    %esi,%edi
  8028bc:	0f 86 a2 00 00 00    	jbe    802964 <__umoddi3+0xd8>
  8028c2:	89 c8                	mov    %ecx,%eax
  8028c4:	89 f2                	mov    %esi,%edx
  8028c6:	f7 f7                	div    %edi
  8028c8:	89 d0                	mov    %edx,%eax
  8028ca:	31 d2                	xor    %edx,%edx
  8028cc:	83 c4 1c             	add    $0x1c,%esp
  8028cf:	5b                   	pop    %ebx
  8028d0:	5e                   	pop    %esi
  8028d1:	5f                   	pop    %edi
  8028d2:	5d                   	pop    %ebp
  8028d3:	c3                   	ret    
  8028d4:	39 f0                	cmp    %esi,%eax
  8028d6:	0f 87 ac 00 00 00    	ja     802988 <__umoddi3+0xfc>
  8028dc:	0f bd e8             	bsr    %eax,%ebp
  8028df:	83 f5 1f             	xor    $0x1f,%ebp
  8028e2:	0f 84 ac 00 00 00    	je     802994 <__umoddi3+0x108>
  8028e8:	bf 20 00 00 00       	mov    $0x20,%edi
  8028ed:	29 ef                	sub    %ebp,%edi
  8028ef:	89 fe                	mov    %edi,%esi
  8028f1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028f5:	89 e9                	mov    %ebp,%ecx
  8028f7:	d3 e0                	shl    %cl,%eax
  8028f9:	89 d7                	mov    %edx,%edi
  8028fb:	89 f1                	mov    %esi,%ecx
  8028fd:	d3 ef                	shr    %cl,%edi
  8028ff:	09 c7                	or     %eax,%edi
  802901:	89 e9                	mov    %ebp,%ecx
  802903:	d3 e2                	shl    %cl,%edx
  802905:	89 14 24             	mov    %edx,(%esp)
  802908:	89 d8                	mov    %ebx,%eax
  80290a:	d3 e0                	shl    %cl,%eax
  80290c:	89 c2                	mov    %eax,%edx
  80290e:	8b 44 24 08          	mov    0x8(%esp),%eax
  802912:	d3 e0                	shl    %cl,%eax
  802914:	89 44 24 04          	mov    %eax,0x4(%esp)
  802918:	8b 44 24 08          	mov    0x8(%esp),%eax
  80291c:	89 f1                	mov    %esi,%ecx
  80291e:	d3 e8                	shr    %cl,%eax
  802920:	09 d0                	or     %edx,%eax
  802922:	d3 eb                	shr    %cl,%ebx
  802924:	89 da                	mov    %ebx,%edx
  802926:	f7 f7                	div    %edi
  802928:	89 d3                	mov    %edx,%ebx
  80292a:	f7 24 24             	mull   (%esp)
  80292d:	89 c6                	mov    %eax,%esi
  80292f:	89 d1                	mov    %edx,%ecx
  802931:	39 d3                	cmp    %edx,%ebx
  802933:	0f 82 87 00 00 00    	jb     8029c0 <__umoddi3+0x134>
  802939:	0f 84 91 00 00 00    	je     8029d0 <__umoddi3+0x144>
  80293f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802943:	29 f2                	sub    %esi,%edx
  802945:	19 cb                	sbb    %ecx,%ebx
  802947:	89 d8                	mov    %ebx,%eax
  802949:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80294d:	d3 e0                	shl    %cl,%eax
  80294f:	89 e9                	mov    %ebp,%ecx
  802951:	d3 ea                	shr    %cl,%edx
  802953:	09 d0                	or     %edx,%eax
  802955:	89 e9                	mov    %ebp,%ecx
  802957:	d3 eb                	shr    %cl,%ebx
  802959:	89 da                	mov    %ebx,%edx
  80295b:	83 c4 1c             	add    $0x1c,%esp
  80295e:	5b                   	pop    %ebx
  80295f:	5e                   	pop    %esi
  802960:	5f                   	pop    %edi
  802961:	5d                   	pop    %ebp
  802962:	c3                   	ret    
  802963:	90                   	nop
  802964:	89 fd                	mov    %edi,%ebp
  802966:	85 ff                	test   %edi,%edi
  802968:	75 0b                	jne    802975 <__umoddi3+0xe9>
  80296a:	b8 01 00 00 00       	mov    $0x1,%eax
  80296f:	31 d2                	xor    %edx,%edx
  802971:	f7 f7                	div    %edi
  802973:	89 c5                	mov    %eax,%ebp
  802975:	89 f0                	mov    %esi,%eax
  802977:	31 d2                	xor    %edx,%edx
  802979:	f7 f5                	div    %ebp
  80297b:	89 c8                	mov    %ecx,%eax
  80297d:	f7 f5                	div    %ebp
  80297f:	89 d0                	mov    %edx,%eax
  802981:	e9 44 ff ff ff       	jmp    8028ca <__umoddi3+0x3e>
  802986:	66 90                	xchg   %ax,%ax
  802988:	89 c8                	mov    %ecx,%eax
  80298a:	89 f2                	mov    %esi,%edx
  80298c:	83 c4 1c             	add    $0x1c,%esp
  80298f:	5b                   	pop    %ebx
  802990:	5e                   	pop    %esi
  802991:	5f                   	pop    %edi
  802992:	5d                   	pop    %ebp
  802993:	c3                   	ret    
  802994:	3b 04 24             	cmp    (%esp),%eax
  802997:	72 06                	jb     80299f <__umoddi3+0x113>
  802999:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80299d:	77 0f                	ja     8029ae <__umoddi3+0x122>
  80299f:	89 f2                	mov    %esi,%edx
  8029a1:	29 f9                	sub    %edi,%ecx
  8029a3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8029a7:	89 14 24             	mov    %edx,(%esp)
  8029aa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8029ae:	8b 44 24 04          	mov    0x4(%esp),%eax
  8029b2:	8b 14 24             	mov    (%esp),%edx
  8029b5:	83 c4 1c             	add    $0x1c,%esp
  8029b8:	5b                   	pop    %ebx
  8029b9:	5e                   	pop    %esi
  8029ba:	5f                   	pop    %edi
  8029bb:	5d                   	pop    %ebp
  8029bc:	c3                   	ret    
  8029bd:	8d 76 00             	lea    0x0(%esi),%esi
  8029c0:	2b 04 24             	sub    (%esp),%eax
  8029c3:	19 fa                	sbb    %edi,%edx
  8029c5:	89 d1                	mov    %edx,%ecx
  8029c7:	89 c6                	mov    %eax,%esi
  8029c9:	e9 71 ff ff ff       	jmp    80293f <__umoddi3+0xb3>
  8029ce:	66 90                	xchg   %ax,%ax
  8029d0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8029d4:	72 ea                	jb     8029c0 <__umoddi3+0x134>
  8029d6:	89 d9                	mov    %ebx,%ecx
  8029d8:	e9 62 ff ff ff       	jmp    80293f <__umoddi3+0xb3>
