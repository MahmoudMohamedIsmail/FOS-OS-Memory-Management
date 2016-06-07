
obj/user/quicksort_interrupt:     file format elf32-i386


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
  800031:	e8 c4 05 00 00       	call   8005fa <libmain>
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
  800049:	e8 f1 22 00 00       	call   80233f <sys_calculate_free_frames>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	e8 03 23 00 00       	call   802358 <sys_calculate_modified_frames>
  800055:	01 d8                	add    %ebx,%eax
  800057:	89 45 f0             	mov    %eax,-0x10(%ebp)

		Iteration++ ;
  80005a:	ff 45 f4             	incl   -0xc(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

//	sys_disable_interrupt();

		sys_disable_interrupt();
  80005d:	e8 79 23 00 00       	call   8023db <sys_disable_interrupt>
			readline("Enter the number of elements: ", Line);
  800062:	83 ec 08             	sub    $0x8,%esp
  800065:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  80006b:	50                   	push   %eax
  80006c:	68 e0 29 80 00       	push   $0x8029e0
  800071:	e8 eb 0d 00 00       	call   800e61 <readline>
  800076:	83 c4 10             	add    $0x10,%esp
			int NumOfElements = strtol(Line, NULL, 10) ;
  800079:	83 ec 04             	sub    $0x4,%esp
  80007c:	6a 0a                	push   $0xa
  80007e:	6a 00                	push   $0x0
  800080:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800086:	50                   	push   %eax
  800087:	e8 3b 13 00 00       	call   8013c7 <strtol>
  80008c:	83 c4 10             	add    $0x10,%esp
  80008f:	89 45 ec             	mov    %eax,-0x14(%ebp)
			int *Elements = malloc(sizeof(int) * NumOfElements) ;
  800092:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800095:	c1 e0 02             	shl    $0x2,%eax
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	50                   	push   %eax
  80009c:	e8 ce 16 00 00       	call   80176f <malloc>
  8000a1:	83 c4 10             	add    $0x10,%esp
  8000a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			cprintf("Choose the initialization method:\n") ;
  8000a7:	83 ec 0c             	sub    $0xc,%esp
  8000aa:	68 00 2a 80 00       	push   $0x802a00
  8000af:	e8 32 07 00 00       	call   8007e6 <cprintf>
  8000b4:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000b7:	83 ec 0c             	sub    $0xc,%esp
  8000ba:	68 23 2a 80 00       	push   $0x802a23
  8000bf:	e8 22 07 00 00       	call   8007e6 <cprintf>
  8000c4:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000c7:	83 ec 0c             	sub    $0xc,%esp
  8000ca:	68 31 2a 80 00       	push   $0x802a31
  8000cf:	e8 12 07 00 00       	call   8007e6 <cprintf>
  8000d4:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\nSelect: ") ;
  8000d7:	83 ec 0c             	sub    $0xc,%esp
  8000da:	68 40 2a 80 00       	push   $0x802a40
  8000df:	e8 02 07 00 00       	call   8007e6 <cprintf>
  8000e4:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8000e7:	e8 b6 04 00 00       	call   8005a2 <getchar>
  8000ec:	88 45 e7             	mov    %al,-0x19(%ebp)
			cputchar(Chose);
  8000ef:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  8000f3:	83 ec 0c             	sub    $0xc,%esp
  8000f6:	50                   	push   %eax
  8000f7:	e8 5e 04 00 00       	call   80055a <cputchar>
  8000fc:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	6a 0a                	push   $0xa
  800104:	e8 51 04 00 00       	call   80055a <cputchar>
  800109:	83 c4 10             	add    $0x10,%esp
		sys_enable_interrupt();
  80010c:	e8 e4 22 00 00       	call   8023f5 <sys_enable_interrupt>
		//sys_enable_interrupt();
		int  i ;
		switch (Chose)
  800111:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800115:	83 f8 62             	cmp    $0x62,%eax
  800118:	74 1d                	je     800137 <_main+0xff>
  80011a:	83 f8 63             	cmp    $0x63,%eax
  80011d:	74 2b                	je     80014a <_main+0x112>
  80011f:	83 f8 61             	cmp    $0x61,%eax
  800122:	75 39                	jne    80015d <_main+0x125>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  800124:	83 ec 08             	sub    $0x8,%esp
  800127:	ff 75 ec             	pushl  -0x14(%ebp)
  80012a:	ff 75 e8             	pushl  -0x18(%ebp)
  80012d:	e8 e6 02 00 00       	call   800418 <InitializeAscending>
  800132:	83 c4 10             	add    $0x10,%esp
			break ;
  800135:	eb 37                	jmp    80016e <_main+0x136>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  800137:	83 ec 08             	sub    $0x8,%esp
  80013a:	ff 75 ec             	pushl  -0x14(%ebp)
  80013d:	ff 75 e8             	pushl  -0x18(%ebp)
  800140:	e8 04 03 00 00       	call   800449 <InitializeDescending>
  800145:	83 c4 10             	add    $0x10,%esp
			break ;
  800148:	eb 24                	jmp    80016e <_main+0x136>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  80014a:	83 ec 08             	sub    $0x8,%esp
  80014d:	ff 75 ec             	pushl  -0x14(%ebp)
  800150:	ff 75 e8             	pushl  -0x18(%ebp)
  800153:	e8 26 03 00 00       	call   80047e <InitializeSemiRandom>
  800158:	83 c4 10             	add    $0x10,%esp
			break ;
  80015b:	eb 11                	jmp    80016e <_main+0x136>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  80015d:	83 ec 08             	sub    $0x8,%esp
  800160:	ff 75 ec             	pushl  -0x14(%ebp)
  800163:	ff 75 e8             	pushl  -0x18(%ebp)
  800166:	e8 13 03 00 00       	call   80047e <InitializeSemiRandom>
  80016b:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  80016e:	83 ec 08             	sub    $0x8,%esp
  800171:	ff 75 ec             	pushl  -0x14(%ebp)
  800174:	ff 75 e8             	pushl  -0x18(%ebp)
  800177:	e8 e1 00 00 00       	call   80025d <QuickSort>
  80017c:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  80017f:	83 ec 08             	sub    $0x8,%esp
  800182:	ff 75 ec             	pushl  -0x14(%ebp)
  800185:	ff 75 e8             	pushl  -0x18(%ebp)
  800188:	e8 e1 01 00 00       	call   80036e <CheckSorted>
  80018d:	83 c4 10             	add    $0x10,%esp
  800190:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800193:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800197:	75 14                	jne    8001ad <_main+0x175>
  800199:	83 ec 04             	sub    $0x4,%esp
  80019c:	68 58 2a 80 00       	push   $0x802a58
  8001a1:	6a 42                	push   $0x42
  8001a3:	68 7a 2a 80 00       	push   $0x802a7a
  8001a8:	e8 0e 05 00 00       	call   8006bb <_panic>
		else
		{ 
			sys_disable_interrupt();
  8001ad:	e8 29 22 00 00       	call   8023db <sys_disable_interrupt>
				cprintf("\n===============================================\n") ;
  8001b2:	83 ec 0c             	sub    $0xc,%esp
  8001b5:	68 98 2a 80 00       	push   $0x802a98
  8001ba:	e8 27 06 00 00       	call   8007e6 <cprintf>
  8001bf:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  8001c2:	83 ec 0c             	sub    $0xc,%esp
  8001c5:	68 cc 2a 80 00       	push   $0x802acc
  8001ca:	e8 17 06 00 00       	call   8007e6 <cprintf>
  8001cf:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  8001d2:	83 ec 0c             	sub    $0xc,%esp
  8001d5:	68 00 2b 80 00       	push   $0x802b00
  8001da:	e8 07 06 00 00       	call   8007e6 <cprintf>
  8001df:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  8001e2:	e8 0e 22 00 00       	call   8023f5 <sys_enable_interrupt>
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		sys_disable_interrupt();
  8001e7:	e8 ef 21 00 00       	call   8023db <sys_disable_interrupt>
			cprintf("Freeing the Heap...\n\n") ;
  8001ec:	83 ec 0c             	sub    $0xc,%esp
  8001ef:	68 32 2b 80 00       	push   $0x802b32
  8001f4:	e8 ed 05 00 00       	call   8007e6 <cprintf>
  8001f9:	83 c4 10             	add    $0x10,%esp
		sys_enable_interrupt();
  8001fc:	e8 f4 21 00 00       	call   8023f5 <sys_enable_interrupt>

		//freeHeap() ;

		///========================================================================
	//sys_disable_interrupt();
		sys_disable_interrupt();
  800201:	e8 d5 21 00 00       	call   8023db <sys_disable_interrupt>
			cprintf("Do you want to repeat (y/n): ") ;
  800206:	83 ec 0c             	sub    $0xc,%esp
  800209:	68 48 2b 80 00       	push   $0x802b48
  80020e:	e8 d3 05 00 00       	call   8007e6 <cprintf>
  800213:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  800216:	e8 87 03 00 00       	call   8005a2 <getchar>
  80021b:	88 45 e7             	mov    %al,-0x19(%ebp)
			cputchar(Chose);
  80021e:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	50                   	push   %eax
  800226:	e8 2f 03 00 00       	call   80055a <cputchar>
  80022b:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80022e:	83 ec 0c             	sub    $0xc,%esp
  800231:	6a 0a                	push   $0xa
  800233:	e8 22 03 00 00       	call   80055a <cputchar>
  800238:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80023b:	83 ec 0c             	sub    $0xc,%esp
  80023e:	6a 0a                	push   $0xa
  800240:	e8 15 03 00 00       	call   80055a <cputchar>
  800245:	83 c4 10             	add    $0x10,%esp
	//sys_enable_interrupt();
		sys_enable_interrupt();
  800248:	e8 a8 21 00 00       	call   8023f5 <sys_enable_interrupt>

	} while (Chose == 'y');
  80024d:	80 7d e7 79          	cmpb   $0x79,-0x19(%ebp)
  800251:	0f 84 f2 fd ff ff    	je     800049 <_main+0x11>

}
  800257:	90                   	nop
  800258:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80025b:	c9                   	leave  
  80025c:	c3                   	ret    

0080025d <QuickSort>:

///Quick sort 
void QuickSort(int *Elements, int NumOfElements)
{
  80025d:	55                   	push   %ebp
  80025e:	89 e5                	mov    %esp,%ebp
  800260:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  800263:	8b 45 0c             	mov    0xc(%ebp),%eax
  800266:	48                   	dec    %eax
  800267:	50                   	push   %eax
  800268:	6a 00                	push   $0x0
  80026a:	ff 75 0c             	pushl  0xc(%ebp)
  80026d:	ff 75 08             	pushl  0x8(%ebp)
  800270:	e8 06 00 00 00       	call   80027b <QSort>
  800275:	83 c4 10             	add    $0x10,%esp
}
  800278:	90                   	nop
  800279:	c9                   	leave  
  80027a:	c3                   	ret    

0080027b <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  80027b:	55                   	push   %ebp
  80027c:	89 e5                	mov    %esp,%ebp
  80027e:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  800281:	8b 45 10             	mov    0x10(%ebp),%eax
  800284:	3b 45 14             	cmp    0x14(%ebp),%eax
  800287:	0f 8d de 00 00 00    	jge    80036b <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  80028d:	8b 45 10             	mov    0x10(%ebp),%eax
  800290:	40                   	inc    %eax
  800291:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800294:	8b 45 14             	mov    0x14(%ebp),%eax
  800297:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  80029a:	e9 80 00 00 00       	jmp    80031f <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  80029f:	ff 45 f4             	incl   -0xc(%ebp)
  8002a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002a5:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002a8:	7f 2b                	jg     8002d5 <QSort+0x5a>
  8002aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b7:	01 d0                	add    %edx,%eax
  8002b9:	8b 10                	mov    (%eax),%edx
  8002bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002be:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c8:	01 c8                	add    %ecx,%eax
  8002ca:	8b 00                	mov    (%eax),%eax
  8002cc:	39 c2                	cmp    %eax,%edx
  8002ce:	7d cf                	jge    80029f <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002d0:	eb 03                	jmp    8002d5 <QSort+0x5a>
  8002d2:	ff 4d f0             	decl   -0x10(%ebp)
  8002d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002d8:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002db:	7e 26                	jle    800303 <QSort+0x88>
  8002dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ea:	01 d0                	add    %edx,%eax
  8002ec:	8b 10                	mov    (%eax),%edx
  8002ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002f1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fb:	01 c8                	add    %ecx,%eax
  8002fd:	8b 00                	mov    (%eax),%eax
  8002ff:	39 c2                	cmp    %eax,%edx
  800301:	7e cf                	jle    8002d2 <QSort+0x57>

		if (i <= j)
  800303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800306:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800309:	7f 14                	jg     80031f <QSort+0xa4>
		{
			Swap(Elements, i, j);
  80030b:	83 ec 04             	sub    $0x4,%esp
  80030e:	ff 75 f0             	pushl  -0x10(%ebp)
  800311:	ff 75 f4             	pushl  -0xc(%ebp)
  800314:	ff 75 08             	pushl  0x8(%ebp)
  800317:	e8 a9 00 00 00       	call   8003c5 <Swap>
  80031c:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  80031f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800322:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800325:	0f 8e 77 ff ff ff    	jle    8002a2 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80032b:	83 ec 04             	sub    $0x4,%esp
  80032e:	ff 75 f0             	pushl  -0x10(%ebp)
  800331:	ff 75 10             	pushl  0x10(%ebp)
  800334:	ff 75 08             	pushl  0x8(%ebp)
  800337:	e8 89 00 00 00       	call   8003c5 <Swap>
  80033c:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  80033f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800342:	48                   	dec    %eax
  800343:	50                   	push   %eax
  800344:	ff 75 10             	pushl  0x10(%ebp)
  800347:	ff 75 0c             	pushl  0xc(%ebp)
  80034a:	ff 75 08             	pushl  0x8(%ebp)
  80034d:	e8 29 ff ff ff       	call   80027b <QSort>
  800352:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  800355:	ff 75 14             	pushl  0x14(%ebp)
  800358:	ff 75 f4             	pushl  -0xc(%ebp)
  80035b:	ff 75 0c             	pushl  0xc(%ebp)
  80035e:	ff 75 08             	pushl  0x8(%ebp)
  800361:	e8 15 ff ff ff       	call   80027b <QSort>
  800366:	83 c4 10             	add    $0x10,%esp
  800369:	eb 01                	jmp    80036c <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  80036b:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  80036c:	c9                   	leave  
  80036d:	c3                   	ret    

0080036e <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
  800371:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  800374:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80037b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800382:	eb 33                	jmp    8003b7 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  800384:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800387:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80038e:	8b 45 08             	mov    0x8(%ebp),%eax
  800391:	01 d0                	add    %edx,%eax
  800393:	8b 10                	mov    (%eax),%edx
  800395:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800398:	40                   	inc    %eax
  800399:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a3:	01 c8                	add    %ecx,%eax
  8003a5:	8b 00                	mov    (%eax),%eax
  8003a7:	39 c2                	cmp    %eax,%edx
  8003a9:	7e 09                	jle    8003b4 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8003b2:	eb 0c                	jmp    8003c0 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003b4:	ff 45 f8             	incl   -0x8(%ebp)
  8003b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ba:	48                   	dec    %eax
  8003bb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8003be:	7f c4                	jg     800384 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8003c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8003c3:	c9                   	leave  
  8003c4:	c3                   	ret    

008003c5 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  8003c5:	55                   	push   %ebp
  8003c6:	89 e5                	mov    %esp,%ebp
  8003c8:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8003cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d8:	01 d0                	add    %edx,%eax
  8003da:	8b 00                	mov    (%eax),%eax
  8003dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8003df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ec:	01 c2                	add    %eax,%edx
  8003ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8003f1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fb:	01 c8                	add    %ecx,%eax
  8003fd:	8b 00                	mov    (%eax),%eax
  8003ff:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800401:	8b 45 10             	mov    0x10(%ebp),%eax
  800404:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040b:	8b 45 08             	mov    0x8(%ebp),%eax
  80040e:	01 c2                	add    %eax,%edx
  800410:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800413:	89 02                	mov    %eax,(%edx)
}
  800415:	90                   	nop
  800416:	c9                   	leave  
  800417:	c3                   	ret    

00800418 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800418:	55                   	push   %ebp
  800419:	89 e5                	mov    %esp,%ebp
  80041b:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80041e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800425:	eb 17                	jmp    80043e <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800427:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80042a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800431:	8b 45 08             	mov    0x8(%ebp),%eax
  800434:	01 c2                	add    %eax,%edx
  800436:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800439:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80043b:	ff 45 fc             	incl   -0x4(%ebp)
  80043e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800441:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800444:	7c e1                	jl     800427 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  800446:	90                   	nop
  800447:	c9                   	leave  
  800448:	c3                   	ret    

00800449 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  800449:	55                   	push   %ebp
  80044a:	89 e5                	mov    %esp,%ebp
  80044c:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80044f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800456:	eb 1b                	jmp    800473 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800458:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80045b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800462:	8b 45 08             	mov    0x8(%ebp),%eax
  800465:	01 c2                	add    %eax,%edx
  800467:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046a:	2b 45 fc             	sub    -0x4(%ebp),%eax
  80046d:	48                   	dec    %eax
  80046e:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800470:	ff 45 fc             	incl   -0x4(%ebp)
  800473:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800476:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800479:	7c dd                	jl     800458 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  80047b:	90                   	nop
  80047c:	c9                   	leave  
  80047d:	c3                   	ret    

0080047e <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  80047e:	55                   	push   %ebp
  80047f:	89 e5                	mov    %esp,%ebp
  800481:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  800484:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800487:	b8 56 55 55 55       	mov    $0x55555556,%eax
  80048c:	f7 e9                	imul   %ecx
  80048e:	c1 f9 1f             	sar    $0x1f,%ecx
  800491:	89 d0                	mov    %edx,%eax
  800493:	29 c8                	sub    %ecx,%eax
  800495:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800498:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80049f:	eb 1e                	jmp    8004bf <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8004a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ae:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8004b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004b4:	99                   	cltd   
  8004b5:	f7 7d f8             	idivl  -0x8(%ebp)
  8004b8:	89 d0                	mov    %edx,%eax
  8004ba:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004bc:	ff 45 fc             	incl   -0x4(%ebp)
  8004bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004c2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004c5:	7c da                	jl     8004a1 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
	}

}
  8004c7:	90                   	nop
  8004c8:	c9                   	leave  
  8004c9:	c3                   	ret    

008004ca <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  8004ca:	55                   	push   %ebp
  8004cb:	89 e5                	mov    %esp,%ebp
  8004cd:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8004d0:	e8 06 1f 00 00       	call   8023db <sys_disable_interrupt>
		int i ;
		int NumsPerLine = 20 ;
  8004d5:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
		for (i = 0 ; i < NumOfElements-1 ; i++)
  8004dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8004e3:	eb 42                	jmp    800527 <PrintElements+0x5d>
		{
			if (i%NumsPerLine == 0)
  8004e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004e8:	99                   	cltd   
  8004e9:	f7 7d f0             	idivl  -0x10(%ebp)
  8004ec:	89 d0                	mov    %edx,%eax
  8004ee:	85 c0                	test   %eax,%eax
  8004f0:	75 10                	jne    800502 <PrintElements+0x38>
				cprintf("\n");
  8004f2:	83 ec 0c             	sub    $0xc,%esp
  8004f5:	68 66 2b 80 00       	push   $0x802b66
  8004fa:	e8 e7 02 00 00       	call   8007e6 <cprintf>
  8004ff:	83 c4 10             	add    $0x10,%esp
			cprintf("%d, ",Elements[i]);
  800502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800505:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80050c:	8b 45 08             	mov    0x8(%ebp),%eax
  80050f:	01 d0                	add    %edx,%eax
  800511:	8b 00                	mov    (%eax),%eax
  800513:	83 ec 08             	sub    $0x8,%esp
  800516:	50                   	push   %eax
  800517:	68 68 2b 80 00       	push   $0x802b68
  80051c:	e8 c5 02 00 00       	call   8007e6 <cprintf>
  800521:	83 c4 10             	add    $0x10,%esp
void PrintElements(int *Elements, int NumOfElements)
{
	sys_disable_interrupt();
		int i ;
		int NumsPerLine = 20 ;
		for (i = 0 ; i < NumOfElements-1 ; i++)
  800524:	ff 45 f4             	incl   -0xc(%ebp)
  800527:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052a:	48                   	dec    %eax
  80052b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80052e:	7f b5                	jg     8004e5 <PrintElements+0x1b>
		{
			if (i%NumsPerLine == 0)
				cprintf("\n");
			cprintf("%d, ",Elements[i]);
		}
		cprintf("%d\n",Elements[i]);
  800530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800533:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80053a:	8b 45 08             	mov    0x8(%ebp),%eax
  80053d:	01 d0                	add    %edx,%eax
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	83 ec 08             	sub    $0x8,%esp
  800544:	50                   	push   %eax
  800545:	68 6d 2b 80 00       	push   $0x802b6d
  80054a:	e8 97 02 00 00       	call   8007e6 <cprintf>
  80054f:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800552:	e8 9e 1e 00 00       	call   8023f5 <sys_enable_interrupt>
}
  800557:	90                   	nop
  800558:	c9                   	leave  
  800559:	c3                   	ret    

0080055a <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  80055a:	55                   	push   %ebp
  80055b:	89 e5                	mov    %esp,%ebp
  80055d:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800560:	8b 45 08             	mov    0x8(%ebp),%eax
  800563:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800566:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80056a:	83 ec 0c             	sub    $0xc,%esp
  80056d:	50                   	push   %eax
  80056e:	e8 9c 1e 00 00       	call   80240f <sys_cputc>
  800573:	83 c4 10             	add    $0x10,%esp
}
  800576:	90                   	nop
  800577:	c9                   	leave  
  800578:	c3                   	ret    

00800579 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800579:	55                   	push   %ebp
  80057a:	89 e5                	mov    %esp,%ebp
  80057c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80057f:	e8 57 1e 00 00       	call   8023db <sys_disable_interrupt>
	char c = ch;
  800584:	8b 45 08             	mov    0x8(%ebp),%eax
  800587:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80058a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80058e:	83 ec 0c             	sub    $0xc,%esp
  800591:	50                   	push   %eax
  800592:	e8 78 1e 00 00       	call   80240f <sys_cputc>
  800597:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80059a:	e8 56 1e 00 00       	call   8023f5 <sys_enable_interrupt>
}
  80059f:	90                   	nop
  8005a0:	c9                   	leave  
  8005a1:	c3                   	ret    

008005a2 <getchar>:

int
getchar(void)
{
  8005a2:	55                   	push   %ebp
  8005a3:	89 e5                	mov    %esp,%ebp
  8005a5:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8005a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005af:	eb 08                	jmp    8005b9 <getchar+0x17>
	{
		c = sys_cgetc();
  8005b1:	e8 a3 1c 00 00       	call   802259 <sys_cgetc>
  8005b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  8005b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8005bd:	74 f2                	je     8005b1 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  8005bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005c2:	c9                   	leave  
  8005c3:	c3                   	ret    

008005c4 <atomic_getchar>:

int
atomic_getchar(void)
{
  8005c4:	55                   	push   %ebp
  8005c5:	89 e5                	mov    %esp,%ebp
  8005c7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005ca:	e8 0c 1e 00 00       	call   8023db <sys_disable_interrupt>
	int c=0;
  8005cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005d6:	eb 08                	jmp    8005e0 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8005d8:	e8 7c 1c 00 00       	call   802259 <sys_cgetc>
  8005dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8005e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8005e4:	74 f2                	je     8005d8 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8005e6:	e8 0a 1e 00 00       	call   8023f5 <sys_enable_interrupt>
	return c;
  8005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005ee:	c9                   	leave  
  8005ef:	c3                   	ret    

008005f0 <iscons>:

int iscons(int fdnum)
{
  8005f0:	55                   	push   %ebp
  8005f1:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8005f3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8005f8:	5d                   	pop    %ebp
  8005f9:	c3                   	ret    

008005fa <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005fa:	55                   	push   %ebp
  8005fb:	89 e5                	mov    %esp,%ebp
  8005fd:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800600:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800604:	7e 0a                	jle    800610 <libmain+0x16>
		binaryname = argv[0];
  800606:	8b 45 0c             	mov    0xc(%ebp),%eax
  800609:	8b 00                	mov    (%eax),%eax
  80060b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800610:	83 ec 08             	sub    $0x8,%esp
  800613:	ff 75 0c             	pushl  0xc(%ebp)
  800616:	ff 75 08             	pushl  0x8(%ebp)
  800619:	e8 1a fa ff ff       	call   800038 <_main>
  80061e:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  800621:	e8 67 1c 00 00       	call   80228d <sys_getenvid>
  800626:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  800629:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80062c:	89 d0                	mov    %edx,%eax
  80062e:	c1 e0 03             	shl    $0x3,%eax
  800631:	01 d0                	add    %edx,%eax
  800633:	01 c0                	add    %eax,%eax
  800635:	01 d0                	add    %edx,%eax
  800637:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80063e:	01 d0                	add    %edx,%eax
  800640:	c1 e0 03             	shl    $0x3,%eax
  800643:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800648:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  80064b:	e8 8b 1d 00 00       	call   8023db <sys_disable_interrupt>
		cprintf("**************************************\n");
  800650:	83 ec 0c             	sub    $0xc,%esp
  800653:	68 8c 2b 80 00       	push   $0x802b8c
  800658:	e8 89 01 00 00       	call   8007e6 <cprintf>
  80065d:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  800660:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800663:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  800669:	83 ec 08             	sub    $0x8,%esp
  80066c:	50                   	push   %eax
  80066d:	68 b4 2b 80 00       	push   $0x802bb4
  800672:	e8 6f 01 00 00       	call   8007e6 <cprintf>
  800677:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80067a:	83 ec 0c             	sub    $0xc,%esp
  80067d:	68 8c 2b 80 00       	push   $0x802b8c
  800682:	e8 5f 01 00 00       	call   8007e6 <cprintf>
  800687:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80068a:	e8 66 1d 00 00       	call   8023f5 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80068f:	e8 19 00 00 00       	call   8006ad <exit>
}
  800694:	90                   	nop
  800695:	c9                   	leave  
  800696:	c3                   	ret    

00800697 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800697:	55                   	push   %ebp
  800698:	89 e5                	mov    %esp,%ebp
  80069a:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80069d:	83 ec 0c             	sub    $0xc,%esp
  8006a0:	6a 00                	push   $0x0
  8006a2:	e8 cb 1b 00 00       	call   802272 <sys_env_destroy>
  8006a7:	83 c4 10             	add    $0x10,%esp
}
  8006aa:	90                   	nop
  8006ab:	c9                   	leave  
  8006ac:	c3                   	ret    

008006ad <exit>:

void
exit(void)
{
  8006ad:	55                   	push   %ebp
  8006ae:	89 e5                	mov    %esp,%ebp
  8006b0:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8006b3:	e8 ee 1b 00 00       	call   8022a6 <sys_env_exit>
}
  8006b8:	90                   	nop
  8006b9:	c9                   	leave  
  8006ba:	c3                   	ret    

008006bb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006bb:	55                   	push   %ebp
  8006bc:	89 e5                	mov    %esp,%ebp
  8006be:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8006c1:	8d 45 10             	lea    0x10(%ebp),%eax
  8006c4:	83 c0 04             	add    $0x4,%eax
  8006c7:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  8006ca:	a1 70 30 98 00       	mov    0x983070,%eax
  8006cf:	85 c0                	test   %eax,%eax
  8006d1:	74 16                	je     8006e9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006d3:	a1 70 30 98 00       	mov    0x983070,%eax
  8006d8:	83 ec 08             	sub    $0x8,%esp
  8006db:	50                   	push   %eax
  8006dc:	68 cd 2b 80 00       	push   $0x802bcd
  8006e1:	e8 00 01 00 00       	call   8007e6 <cprintf>
  8006e6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006e9:	a1 00 30 80 00       	mov    0x803000,%eax
  8006ee:	ff 75 0c             	pushl  0xc(%ebp)
  8006f1:	ff 75 08             	pushl  0x8(%ebp)
  8006f4:	50                   	push   %eax
  8006f5:	68 d2 2b 80 00       	push   $0x802bd2
  8006fa:	e8 e7 00 00 00       	call   8007e6 <cprintf>
  8006ff:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800702:	8b 45 10             	mov    0x10(%ebp),%eax
  800705:	83 ec 08             	sub    $0x8,%esp
  800708:	ff 75 f4             	pushl  -0xc(%ebp)
  80070b:	50                   	push   %eax
  80070c:	e8 7a 00 00 00       	call   80078b <vcprintf>
  800711:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  800714:	83 ec 0c             	sub    $0xc,%esp
  800717:	68 ee 2b 80 00       	push   $0x802bee
  80071c:	e8 c5 00 00 00       	call   8007e6 <cprintf>
  800721:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800724:	e8 84 ff ff ff       	call   8006ad <exit>

	// should not return here
	while (1) ;
  800729:	eb fe                	jmp    800729 <_panic+0x6e>

0080072b <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80072b:	55                   	push   %ebp
  80072c:	89 e5                	mov    %esp,%ebp
  80072e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800731:	8b 45 0c             	mov    0xc(%ebp),%eax
  800734:	8b 00                	mov    (%eax),%eax
  800736:	8d 48 01             	lea    0x1(%eax),%ecx
  800739:	8b 55 0c             	mov    0xc(%ebp),%edx
  80073c:	89 0a                	mov    %ecx,(%edx)
  80073e:	8b 55 08             	mov    0x8(%ebp),%edx
  800741:	88 d1                	mov    %dl,%cl
  800743:	8b 55 0c             	mov    0xc(%ebp),%edx
  800746:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80074a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80074d:	8b 00                	mov    (%eax),%eax
  80074f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800754:	75 23                	jne    800779 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  800756:	8b 45 0c             	mov    0xc(%ebp),%eax
  800759:	8b 00                	mov    (%eax),%eax
  80075b:	89 c2                	mov    %eax,%edx
  80075d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800760:	83 c0 08             	add    $0x8,%eax
  800763:	83 ec 08             	sub    $0x8,%esp
  800766:	52                   	push   %edx
  800767:	50                   	push   %eax
  800768:	e8 cf 1a 00 00       	call   80223c <sys_cputs>
  80076d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800770:	8b 45 0c             	mov    0xc(%ebp),%eax
  800773:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800779:	8b 45 0c             	mov    0xc(%ebp),%eax
  80077c:	8b 40 04             	mov    0x4(%eax),%eax
  80077f:	8d 50 01             	lea    0x1(%eax),%edx
  800782:	8b 45 0c             	mov    0xc(%ebp),%eax
  800785:	89 50 04             	mov    %edx,0x4(%eax)
}
  800788:	90                   	nop
  800789:	c9                   	leave  
  80078a:	c3                   	ret    

0080078b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80078b:	55                   	push   %ebp
  80078c:	89 e5                	mov    %esp,%ebp
  80078e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800794:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80079b:	00 00 00 
	b.cnt = 0;
  80079e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007a5:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007a8:	ff 75 0c             	pushl  0xc(%ebp)
  8007ab:	ff 75 08             	pushl  0x8(%ebp)
  8007ae:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007b4:	50                   	push   %eax
  8007b5:	68 2b 07 80 00       	push   $0x80072b
  8007ba:	e8 fa 01 00 00       	call   8009b9 <vprintfmt>
  8007bf:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  8007c2:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8007c8:	83 ec 08             	sub    $0x8,%esp
  8007cb:	50                   	push   %eax
  8007cc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007d2:	83 c0 08             	add    $0x8,%eax
  8007d5:	50                   	push   %eax
  8007d6:	e8 61 1a 00 00       	call   80223c <sys_cputs>
  8007db:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  8007de:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007e4:	c9                   	leave  
  8007e5:	c3                   	ret    

008007e6 <cprintf>:

int cprintf(const char *fmt, ...) {
  8007e6:	55                   	push   %ebp
  8007e7:	89 e5                	mov    %esp,%ebp
  8007e9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007ec:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	83 ec 08             	sub    $0x8,%esp
  8007f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8007fb:	50                   	push   %eax
  8007fc:	e8 8a ff ff ff       	call   80078b <vcprintf>
  800801:	83 c4 10             	add    $0x10,%esp
  800804:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800807:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80080a:	c9                   	leave  
  80080b:	c3                   	ret    

0080080c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80080c:	55                   	push   %ebp
  80080d:	89 e5                	mov    %esp,%ebp
  80080f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800812:	e8 c4 1b 00 00       	call   8023db <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800817:	8d 45 0c             	lea    0xc(%ebp),%eax
  80081a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80081d:	8b 45 08             	mov    0x8(%ebp),%eax
  800820:	83 ec 08             	sub    $0x8,%esp
  800823:	ff 75 f4             	pushl  -0xc(%ebp)
  800826:	50                   	push   %eax
  800827:	e8 5f ff ff ff       	call   80078b <vcprintf>
  80082c:	83 c4 10             	add    $0x10,%esp
  80082f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800832:	e8 be 1b 00 00       	call   8023f5 <sys_enable_interrupt>
	return cnt;
  800837:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80083a:	c9                   	leave  
  80083b:	c3                   	ret    

0080083c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80083c:	55                   	push   %ebp
  80083d:	89 e5                	mov    %esp,%ebp
  80083f:	53                   	push   %ebx
  800840:	83 ec 14             	sub    $0x14,%esp
  800843:	8b 45 10             	mov    0x10(%ebp),%eax
  800846:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800849:	8b 45 14             	mov    0x14(%ebp),%eax
  80084c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80084f:	8b 45 18             	mov    0x18(%ebp),%eax
  800852:	ba 00 00 00 00       	mov    $0x0,%edx
  800857:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80085a:	77 55                	ja     8008b1 <printnum+0x75>
  80085c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80085f:	72 05                	jb     800866 <printnum+0x2a>
  800861:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800864:	77 4b                	ja     8008b1 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800866:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800869:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80086c:	8b 45 18             	mov    0x18(%ebp),%eax
  80086f:	ba 00 00 00 00       	mov    $0x0,%edx
  800874:	52                   	push   %edx
  800875:	50                   	push   %eax
  800876:	ff 75 f4             	pushl  -0xc(%ebp)
  800879:	ff 75 f0             	pushl  -0x10(%ebp)
  80087c:	e8 f7 1e 00 00       	call   802778 <__udivdi3>
  800881:	83 c4 10             	add    $0x10,%esp
  800884:	83 ec 04             	sub    $0x4,%esp
  800887:	ff 75 20             	pushl  0x20(%ebp)
  80088a:	53                   	push   %ebx
  80088b:	ff 75 18             	pushl  0x18(%ebp)
  80088e:	52                   	push   %edx
  80088f:	50                   	push   %eax
  800890:	ff 75 0c             	pushl  0xc(%ebp)
  800893:	ff 75 08             	pushl  0x8(%ebp)
  800896:	e8 a1 ff ff ff       	call   80083c <printnum>
  80089b:	83 c4 20             	add    $0x20,%esp
  80089e:	eb 1a                	jmp    8008ba <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008a0:	83 ec 08             	sub    $0x8,%esp
  8008a3:	ff 75 0c             	pushl  0xc(%ebp)
  8008a6:	ff 75 20             	pushl  0x20(%ebp)
  8008a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ac:	ff d0                	call   *%eax
  8008ae:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008b1:	ff 4d 1c             	decl   0x1c(%ebp)
  8008b4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008b8:	7f e6                	jg     8008a0 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008ba:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008bd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008c8:	53                   	push   %ebx
  8008c9:	51                   	push   %ecx
  8008ca:	52                   	push   %edx
  8008cb:	50                   	push   %eax
  8008cc:	e8 b7 1f 00 00       	call   802888 <__umoddi3>
  8008d1:	83 c4 10             	add    $0x10,%esp
  8008d4:	05 14 2e 80 00       	add    $0x802e14,%eax
  8008d9:	8a 00                	mov    (%eax),%al
  8008db:	0f be c0             	movsbl %al,%eax
  8008de:	83 ec 08             	sub    $0x8,%esp
  8008e1:	ff 75 0c             	pushl  0xc(%ebp)
  8008e4:	50                   	push   %eax
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	ff d0                	call   *%eax
  8008ea:	83 c4 10             	add    $0x10,%esp
}
  8008ed:	90                   	nop
  8008ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008f1:	c9                   	leave  
  8008f2:	c3                   	ret    

008008f3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008f3:	55                   	push   %ebp
  8008f4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008f6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008fa:	7e 1c                	jle    800918 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	8b 00                	mov    (%eax),%eax
  800901:	8d 50 08             	lea    0x8(%eax),%edx
  800904:	8b 45 08             	mov    0x8(%ebp),%eax
  800907:	89 10                	mov    %edx,(%eax)
  800909:	8b 45 08             	mov    0x8(%ebp),%eax
  80090c:	8b 00                	mov    (%eax),%eax
  80090e:	83 e8 08             	sub    $0x8,%eax
  800911:	8b 50 04             	mov    0x4(%eax),%edx
  800914:	8b 00                	mov    (%eax),%eax
  800916:	eb 40                	jmp    800958 <getuint+0x65>
	else if (lflag)
  800918:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80091c:	74 1e                	je     80093c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	8b 00                	mov    (%eax),%eax
  800923:	8d 50 04             	lea    0x4(%eax),%edx
  800926:	8b 45 08             	mov    0x8(%ebp),%eax
  800929:	89 10                	mov    %edx,(%eax)
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	8b 00                	mov    (%eax),%eax
  800930:	83 e8 04             	sub    $0x4,%eax
  800933:	8b 00                	mov    (%eax),%eax
  800935:	ba 00 00 00 00       	mov    $0x0,%edx
  80093a:	eb 1c                	jmp    800958 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	8b 00                	mov    (%eax),%eax
  800941:	8d 50 04             	lea    0x4(%eax),%edx
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	89 10                	mov    %edx,(%eax)
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	8b 00                	mov    (%eax),%eax
  80094e:	83 e8 04             	sub    $0x4,%eax
  800951:	8b 00                	mov    (%eax),%eax
  800953:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800958:	5d                   	pop    %ebp
  800959:	c3                   	ret    

0080095a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80095d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800961:	7e 1c                	jle    80097f <getint+0x25>
		return va_arg(*ap, long long);
  800963:	8b 45 08             	mov    0x8(%ebp),%eax
  800966:	8b 00                	mov    (%eax),%eax
  800968:	8d 50 08             	lea    0x8(%eax),%edx
  80096b:	8b 45 08             	mov    0x8(%ebp),%eax
  80096e:	89 10                	mov    %edx,(%eax)
  800970:	8b 45 08             	mov    0x8(%ebp),%eax
  800973:	8b 00                	mov    (%eax),%eax
  800975:	83 e8 08             	sub    $0x8,%eax
  800978:	8b 50 04             	mov    0x4(%eax),%edx
  80097b:	8b 00                	mov    (%eax),%eax
  80097d:	eb 38                	jmp    8009b7 <getint+0x5d>
	else if (lflag)
  80097f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800983:	74 1a                	je     80099f <getint+0x45>
		return va_arg(*ap, long);
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	8b 00                	mov    (%eax),%eax
  80098a:	8d 50 04             	lea    0x4(%eax),%edx
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	89 10                	mov    %edx,(%eax)
  800992:	8b 45 08             	mov    0x8(%ebp),%eax
  800995:	8b 00                	mov    (%eax),%eax
  800997:	83 e8 04             	sub    $0x4,%eax
  80099a:	8b 00                	mov    (%eax),%eax
  80099c:	99                   	cltd   
  80099d:	eb 18                	jmp    8009b7 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80099f:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a2:	8b 00                	mov    (%eax),%eax
  8009a4:	8d 50 04             	lea    0x4(%eax),%edx
  8009a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009aa:	89 10                	mov    %edx,(%eax)
  8009ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8009af:	8b 00                	mov    (%eax),%eax
  8009b1:	83 e8 04             	sub    $0x4,%eax
  8009b4:	8b 00                	mov    (%eax),%eax
  8009b6:	99                   	cltd   
}
  8009b7:	5d                   	pop    %ebp
  8009b8:	c3                   	ret    

008009b9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009b9:	55                   	push   %ebp
  8009ba:	89 e5                	mov    %esp,%ebp
  8009bc:	56                   	push   %esi
  8009bd:	53                   	push   %ebx
  8009be:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009c1:	eb 17                	jmp    8009da <vprintfmt+0x21>
			if (ch == '\0')
  8009c3:	85 db                	test   %ebx,%ebx
  8009c5:	0f 84 af 03 00 00    	je     800d7a <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8009cb:	83 ec 08             	sub    $0x8,%esp
  8009ce:	ff 75 0c             	pushl  0xc(%ebp)
  8009d1:	53                   	push   %ebx
  8009d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d5:	ff d0                	call   *%eax
  8009d7:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009da:	8b 45 10             	mov    0x10(%ebp),%eax
  8009dd:	8d 50 01             	lea    0x1(%eax),%edx
  8009e0:	89 55 10             	mov    %edx,0x10(%ebp)
  8009e3:	8a 00                	mov    (%eax),%al
  8009e5:	0f b6 d8             	movzbl %al,%ebx
  8009e8:	83 fb 25             	cmp    $0x25,%ebx
  8009eb:	75 d6                	jne    8009c3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009ed:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009f1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009f8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009ff:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a06:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800a10:	8d 50 01             	lea    0x1(%eax),%edx
  800a13:	89 55 10             	mov    %edx,0x10(%ebp)
  800a16:	8a 00                	mov    (%eax),%al
  800a18:	0f b6 d8             	movzbl %al,%ebx
  800a1b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a1e:	83 f8 55             	cmp    $0x55,%eax
  800a21:	0f 87 2b 03 00 00    	ja     800d52 <vprintfmt+0x399>
  800a27:	8b 04 85 38 2e 80 00 	mov    0x802e38(,%eax,4),%eax
  800a2e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a30:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a34:	eb d7                	jmp    800a0d <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a36:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a3a:	eb d1                	jmp    800a0d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a3c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a43:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a46:	89 d0                	mov    %edx,%eax
  800a48:	c1 e0 02             	shl    $0x2,%eax
  800a4b:	01 d0                	add    %edx,%eax
  800a4d:	01 c0                	add    %eax,%eax
  800a4f:	01 d8                	add    %ebx,%eax
  800a51:	83 e8 30             	sub    $0x30,%eax
  800a54:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a57:	8b 45 10             	mov    0x10(%ebp),%eax
  800a5a:	8a 00                	mov    (%eax),%al
  800a5c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a5f:	83 fb 2f             	cmp    $0x2f,%ebx
  800a62:	7e 3e                	jle    800aa2 <vprintfmt+0xe9>
  800a64:	83 fb 39             	cmp    $0x39,%ebx
  800a67:	7f 39                	jg     800aa2 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a69:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a6c:	eb d5                	jmp    800a43 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a71:	83 c0 04             	add    $0x4,%eax
  800a74:	89 45 14             	mov    %eax,0x14(%ebp)
  800a77:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7a:	83 e8 04             	sub    $0x4,%eax
  800a7d:	8b 00                	mov    (%eax),%eax
  800a7f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a82:	eb 1f                	jmp    800aa3 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a84:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a88:	79 83                	jns    800a0d <vprintfmt+0x54>
				width = 0;
  800a8a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a91:	e9 77 ff ff ff       	jmp    800a0d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a96:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a9d:	e9 6b ff ff ff       	jmp    800a0d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800aa2:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800aa3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aa7:	0f 89 60 ff ff ff    	jns    800a0d <vprintfmt+0x54>
				width = precision, precision = -1;
  800aad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ab0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ab3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800aba:	e9 4e ff ff ff       	jmp    800a0d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800abf:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ac2:	e9 46 ff ff ff       	jmp    800a0d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ac7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aca:	83 c0 04             	add    $0x4,%eax
  800acd:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad3:	83 e8 04             	sub    $0x4,%eax
  800ad6:	8b 00                	mov    (%eax),%eax
  800ad8:	83 ec 08             	sub    $0x8,%esp
  800adb:	ff 75 0c             	pushl  0xc(%ebp)
  800ade:	50                   	push   %eax
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	ff d0                	call   *%eax
  800ae4:	83 c4 10             	add    $0x10,%esp
			break;
  800ae7:	e9 89 02 00 00       	jmp    800d75 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800aec:	8b 45 14             	mov    0x14(%ebp),%eax
  800aef:	83 c0 04             	add    $0x4,%eax
  800af2:	89 45 14             	mov    %eax,0x14(%ebp)
  800af5:	8b 45 14             	mov    0x14(%ebp),%eax
  800af8:	83 e8 04             	sub    $0x4,%eax
  800afb:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800afd:	85 db                	test   %ebx,%ebx
  800aff:	79 02                	jns    800b03 <vprintfmt+0x14a>
				err = -err;
  800b01:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b03:	83 fb 64             	cmp    $0x64,%ebx
  800b06:	7f 0b                	jg     800b13 <vprintfmt+0x15a>
  800b08:	8b 34 9d 80 2c 80 00 	mov    0x802c80(,%ebx,4),%esi
  800b0f:	85 f6                	test   %esi,%esi
  800b11:	75 19                	jne    800b2c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b13:	53                   	push   %ebx
  800b14:	68 25 2e 80 00       	push   $0x802e25
  800b19:	ff 75 0c             	pushl  0xc(%ebp)
  800b1c:	ff 75 08             	pushl  0x8(%ebp)
  800b1f:	e8 5e 02 00 00       	call   800d82 <printfmt>
  800b24:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b27:	e9 49 02 00 00       	jmp    800d75 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b2c:	56                   	push   %esi
  800b2d:	68 2e 2e 80 00       	push   $0x802e2e
  800b32:	ff 75 0c             	pushl  0xc(%ebp)
  800b35:	ff 75 08             	pushl  0x8(%ebp)
  800b38:	e8 45 02 00 00       	call   800d82 <printfmt>
  800b3d:	83 c4 10             	add    $0x10,%esp
			break;
  800b40:	e9 30 02 00 00       	jmp    800d75 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b45:	8b 45 14             	mov    0x14(%ebp),%eax
  800b48:	83 c0 04             	add    $0x4,%eax
  800b4b:	89 45 14             	mov    %eax,0x14(%ebp)
  800b4e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b51:	83 e8 04             	sub    $0x4,%eax
  800b54:	8b 30                	mov    (%eax),%esi
  800b56:	85 f6                	test   %esi,%esi
  800b58:	75 05                	jne    800b5f <vprintfmt+0x1a6>
				p = "(null)";
  800b5a:	be 31 2e 80 00       	mov    $0x802e31,%esi
			if (width > 0 && padc != '-')
  800b5f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b63:	7e 6d                	jle    800bd2 <vprintfmt+0x219>
  800b65:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b69:	74 67                	je     800bd2 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b6e:	83 ec 08             	sub    $0x8,%esp
  800b71:	50                   	push   %eax
  800b72:	56                   	push   %esi
  800b73:	e8 12 05 00 00       	call   80108a <strnlen>
  800b78:	83 c4 10             	add    $0x10,%esp
  800b7b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b7e:	eb 16                	jmp    800b96 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b80:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b84:	83 ec 08             	sub    $0x8,%esp
  800b87:	ff 75 0c             	pushl  0xc(%ebp)
  800b8a:	50                   	push   %eax
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	ff d0                	call   *%eax
  800b90:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b93:	ff 4d e4             	decl   -0x1c(%ebp)
  800b96:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b9a:	7f e4                	jg     800b80 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b9c:	eb 34                	jmp    800bd2 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b9e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ba2:	74 1c                	je     800bc0 <vprintfmt+0x207>
  800ba4:	83 fb 1f             	cmp    $0x1f,%ebx
  800ba7:	7e 05                	jle    800bae <vprintfmt+0x1f5>
  800ba9:	83 fb 7e             	cmp    $0x7e,%ebx
  800bac:	7e 12                	jle    800bc0 <vprintfmt+0x207>
					putch('?', putdat);
  800bae:	83 ec 08             	sub    $0x8,%esp
  800bb1:	ff 75 0c             	pushl  0xc(%ebp)
  800bb4:	6a 3f                	push   $0x3f
  800bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb9:	ff d0                	call   *%eax
  800bbb:	83 c4 10             	add    $0x10,%esp
  800bbe:	eb 0f                	jmp    800bcf <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800bc0:	83 ec 08             	sub    $0x8,%esp
  800bc3:	ff 75 0c             	pushl  0xc(%ebp)
  800bc6:	53                   	push   %ebx
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bca:	ff d0                	call   *%eax
  800bcc:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bcf:	ff 4d e4             	decl   -0x1c(%ebp)
  800bd2:	89 f0                	mov    %esi,%eax
  800bd4:	8d 70 01             	lea    0x1(%eax),%esi
  800bd7:	8a 00                	mov    (%eax),%al
  800bd9:	0f be d8             	movsbl %al,%ebx
  800bdc:	85 db                	test   %ebx,%ebx
  800bde:	74 24                	je     800c04 <vprintfmt+0x24b>
  800be0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800be4:	78 b8                	js     800b9e <vprintfmt+0x1e5>
  800be6:	ff 4d e0             	decl   -0x20(%ebp)
  800be9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bed:	79 af                	jns    800b9e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bef:	eb 13                	jmp    800c04 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bf1:	83 ec 08             	sub    $0x8,%esp
  800bf4:	ff 75 0c             	pushl  0xc(%ebp)
  800bf7:	6a 20                	push   $0x20
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	ff d0                	call   *%eax
  800bfe:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c01:	ff 4d e4             	decl   -0x1c(%ebp)
  800c04:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c08:	7f e7                	jg     800bf1 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c0a:	e9 66 01 00 00       	jmp    800d75 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c0f:	83 ec 08             	sub    $0x8,%esp
  800c12:	ff 75 e8             	pushl  -0x18(%ebp)
  800c15:	8d 45 14             	lea    0x14(%ebp),%eax
  800c18:	50                   	push   %eax
  800c19:	e8 3c fd ff ff       	call   80095a <getint>
  800c1e:	83 c4 10             	add    $0x10,%esp
  800c21:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c24:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c2d:	85 d2                	test   %edx,%edx
  800c2f:	79 23                	jns    800c54 <vprintfmt+0x29b>
				putch('-', putdat);
  800c31:	83 ec 08             	sub    $0x8,%esp
  800c34:	ff 75 0c             	pushl  0xc(%ebp)
  800c37:	6a 2d                	push   $0x2d
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	ff d0                	call   *%eax
  800c3e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c47:	f7 d8                	neg    %eax
  800c49:	83 d2 00             	adc    $0x0,%edx
  800c4c:	f7 da                	neg    %edx
  800c4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c51:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c54:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c5b:	e9 bc 00 00 00       	jmp    800d1c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c60:	83 ec 08             	sub    $0x8,%esp
  800c63:	ff 75 e8             	pushl  -0x18(%ebp)
  800c66:	8d 45 14             	lea    0x14(%ebp),%eax
  800c69:	50                   	push   %eax
  800c6a:	e8 84 fc ff ff       	call   8008f3 <getuint>
  800c6f:	83 c4 10             	add    $0x10,%esp
  800c72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c75:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c78:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c7f:	e9 98 00 00 00       	jmp    800d1c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c84:	83 ec 08             	sub    $0x8,%esp
  800c87:	ff 75 0c             	pushl  0xc(%ebp)
  800c8a:	6a 58                	push   $0x58
  800c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8f:	ff d0                	call   *%eax
  800c91:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c94:	83 ec 08             	sub    $0x8,%esp
  800c97:	ff 75 0c             	pushl  0xc(%ebp)
  800c9a:	6a 58                	push   $0x58
  800c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9f:	ff d0                	call   *%eax
  800ca1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ca4:	83 ec 08             	sub    $0x8,%esp
  800ca7:	ff 75 0c             	pushl  0xc(%ebp)
  800caa:	6a 58                	push   $0x58
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	ff d0                	call   *%eax
  800cb1:	83 c4 10             	add    $0x10,%esp
			break;
  800cb4:	e9 bc 00 00 00       	jmp    800d75 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800cb9:	83 ec 08             	sub    $0x8,%esp
  800cbc:	ff 75 0c             	pushl  0xc(%ebp)
  800cbf:	6a 30                	push   $0x30
  800cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc4:	ff d0                	call   *%eax
  800cc6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800cc9:	83 ec 08             	sub    $0x8,%esp
  800ccc:	ff 75 0c             	pushl  0xc(%ebp)
  800ccf:	6a 78                	push   $0x78
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	ff d0                	call   *%eax
  800cd6:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cd9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cdc:	83 c0 04             	add    $0x4,%eax
  800cdf:	89 45 14             	mov    %eax,0x14(%ebp)
  800ce2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce5:	83 e8 04             	sub    $0x4,%eax
  800ce8:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ced:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cf4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cfb:	eb 1f                	jmp    800d1c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cfd:	83 ec 08             	sub    $0x8,%esp
  800d00:	ff 75 e8             	pushl  -0x18(%ebp)
  800d03:	8d 45 14             	lea    0x14(%ebp),%eax
  800d06:	50                   	push   %eax
  800d07:	e8 e7 fb ff ff       	call   8008f3 <getuint>
  800d0c:	83 c4 10             	add    $0x10,%esp
  800d0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d12:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d15:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d1c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d23:	83 ec 04             	sub    $0x4,%esp
  800d26:	52                   	push   %edx
  800d27:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d2a:	50                   	push   %eax
  800d2b:	ff 75 f4             	pushl  -0xc(%ebp)
  800d2e:	ff 75 f0             	pushl  -0x10(%ebp)
  800d31:	ff 75 0c             	pushl  0xc(%ebp)
  800d34:	ff 75 08             	pushl  0x8(%ebp)
  800d37:	e8 00 fb ff ff       	call   80083c <printnum>
  800d3c:	83 c4 20             	add    $0x20,%esp
			break;
  800d3f:	eb 34                	jmp    800d75 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d41:	83 ec 08             	sub    $0x8,%esp
  800d44:	ff 75 0c             	pushl  0xc(%ebp)
  800d47:	53                   	push   %ebx
  800d48:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4b:	ff d0                	call   *%eax
  800d4d:	83 c4 10             	add    $0x10,%esp
			break;
  800d50:	eb 23                	jmp    800d75 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d52:	83 ec 08             	sub    $0x8,%esp
  800d55:	ff 75 0c             	pushl  0xc(%ebp)
  800d58:	6a 25                	push   $0x25
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	ff d0                	call   *%eax
  800d5f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d62:	ff 4d 10             	decl   0x10(%ebp)
  800d65:	eb 03                	jmp    800d6a <vprintfmt+0x3b1>
  800d67:	ff 4d 10             	decl   0x10(%ebp)
  800d6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6d:	48                   	dec    %eax
  800d6e:	8a 00                	mov    (%eax),%al
  800d70:	3c 25                	cmp    $0x25,%al
  800d72:	75 f3                	jne    800d67 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d74:	90                   	nop
		}
	}
  800d75:	e9 47 fc ff ff       	jmp    8009c1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d7a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d7b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d7e:	5b                   	pop    %ebx
  800d7f:	5e                   	pop    %esi
  800d80:	5d                   	pop    %ebp
  800d81:	c3                   	ret    

00800d82 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d88:	8d 45 10             	lea    0x10(%ebp),%eax
  800d8b:	83 c0 04             	add    $0x4,%eax
  800d8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d91:	8b 45 10             	mov    0x10(%ebp),%eax
  800d94:	ff 75 f4             	pushl  -0xc(%ebp)
  800d97:	50                   	push   %eax
  800d98:	ff 75 0c             	pushl  0xc(%ebp)
  800d9b:	ff 75 08             	pushl  0x8(%ebp)
  800d9e:	e8 16 fc ff ff       	call   8009b9 <vprintfmt>
  800da3:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800da6:	90                   	nop
  800da7:	c9                   	leave  
  800da8:	c3                   	ret    

00800da9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800da9:	55                   	push   %ebp
  800daa:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800dac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800daf:	8b 40 08             	mov    0x8(%eax),%eax
  800db2:	8d 50 01             	lea    0x1(%eax),%edx
  800db5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db8:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbe:	8b 10                	mov    (%eax),%edx
  800dc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc3:	8b 40 04             	mov    0x4(%eax),%eax
  800dc6:	39 c2                	cmp    %eax,%edx
  800dc8:	73 12                	jae    800ddc <sprintputch+0x33>
		*b->buf++ = ch;
  800dca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcd:	8b 00                	mov    (%eax),%eax
  800dcf:	8d 48 01             	lea    0x1(%eax),%ecx
  800dd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd5:	89 0a                	mov    %ecx,(%edx)
  800dd7:	8b 55 08             	mov    0x8(%ebp),%edx
  800dda:	88 10                	mov    %dl,(%eax)
}
  800ddc:	90                   	nop
  800ddd:	5d                   	pop    %ebp
  800dde:	c3                   	ret    

00800ddf <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
  800de2:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
  800de8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800deb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dee:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
  800df4:	01 d0                	add    %edx,%eax
  800df6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800df9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e04:	74 06                	je     800e0c <vsnprintf+0x2d>
  800e06:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e0a:	7f 07                	jg     800e13 <vsnprintf+0x34>
		return -E_INVAL;
  800e0c:	b8 03 00 00 00       	mov    $0x3,%eax
  800e11:	eb 20                	jmp    800e33 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e13:	ff 75 14             	pushl  0x14(%ebp)
  800e16:	ff 75 10             	pushl  0x10(%ebp)
  800e19:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e1c:	50                   	push   %eax
  800e1d:	68 a9 0d 80 00       	push   $0x800da9
  800e22:	e8 92 fb ff ff       	call   8009b9 <vprintfmt>
  800e27:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e2d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e33:	c9                   	leave  
  800e34:	c3                   	ret    

00800e35 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e35:	55                   	push   %ebp
  800e36:	89 e5                	mov    %esp,%ebp
  800e38:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e3b:	8d 45 10             	lea    0x10(%ebp),%eax
  800e3e:	83 c0 04             	add    $0x4,%eax
  800e41:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e44:	8b 45 10             	mov    0x10(%ebp),%eax
  800e47:	ff 75 f4             	pushl  -0xc(%ebp)
  800e4a:	50                   	push   %eax
  800e4b:	ff 75 0c             	pushl  0xc(%ebp)
  800e4e:	ff 75 08             	pushl  0x8(%ebp)
  800e51:	e8 89 ff ff ff       	call   800ddf <vsnprintf>
  800e56:	83 c4 10             	add    $0x10,%esp
  800e59:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e5f:	c9                   	leave  
  800e60:	c3                   	ret    

00800e61 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800e61:	55                   	push   %ebp
  800e62:	89 e5                	mov    %esp,%ebp
  800e64:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  800e67:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e6b:	74 13                	je     800e80 <readline+0x1f>
		cprintf("%s", prompt);
  800e6d:	83 ec 08             	sub    $0x8,%esp
  800e70:	ff 75 08             	pushl  0x8(%ebp)
  800e73:	68 90 2f 80 00       	push   $0x802f90
  800e78:	e8 69 f9 ff ff       	call   8007e6 <cprintf>
  800e7d:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800e80:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800e87:	83 ec 0c             	sub    $0xc,%esp
  800e8a:	6a 00                	push   $0x0
  800e8c:	e8 5f f7 ff ff       	call   8005f0 <iscons>
  800e91:	83 c4 10             	add    $0x10,%esp
  800e94:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800e97:	e8 06 f7 ff ff       	call   8005a2 <getchar>
  800e9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800e9f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ea3:	79 22                	jns    800ec7 <readline+0x66>
			if (c != -E_EOF)
  800ea5:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800ea9:	0f 84 ad 00 00 00    	je     800f5c <readline+0xfb>
				cprintf("read error: %e\n", c);
  800eaf:	83 ec 08             	sub    $0x8,%esp
  800eb2:	ff 75 ec             	pushl  -0x14(%ebp)
  800eb5:	68 93 2f 80 00       	push   $0x802f93
  800eba:	e8 27 f9 ff ff       	call   8007e6 <cprintf>
  800ebf:	83 c4 10             	add    $0x10,%esp
			return;
  800ec2:	e9 95 00 00 00       	jmp    800f5c <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800ec7:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800ecb:	7e 34                	jle    800f01 <readline+0xa0>
  800ecd:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800ed4:	7f 2b                	jg     800f01 <readline+0xa0>
			if (echoing)
  800ed6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800eda:	74 0e                	je     800eea <readline+0x89>
				cputchar(c);
  800edc:	83 ec 0c             	sub    $0xc,%esp
  800edf:	ff 75 ec             	pushl  -0x14(%ebp)
  800ee2:	e8 73 f6 ff ff       	call   80055a <cputchar>
  800ee7:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eed:	8d 50 01             	lea    0x1(%eax),%edx
  800ef0:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800ef3:	89 c2                	mov    %eax,%edx
  800ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef8:	01 d0                	add    %edx,%eax
  800efa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800efd:	88 10                	mov    %dl,(%eax)
  800eff:	eb 56                	jmp    800f57 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800f01:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800f05:	75 1f                	jne    800f26 <readline+0xc5>
  800f07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800f0b:	7e 19                	jle    800f26 <readline+0xc5>
			if (echoing)
  800f0d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f11:	74 0e                	je     800f21 <readline+0xc0>
				cputchar(c);
  800f13:	83 ec 0c             	sub    $0xc,%esp
  800f16:	ff 75 ec             	pushl  -0x14(%ebp)
  800f19:	e8 3c f6 ff ff       	call   80055a <cputchar>
  800f1e:	83 c4 10             	add    $0x10,%esp

			i--;
  800f21:	ff 4d f4             	decl   -0xc(%ebp)
  800f24:	eb 31                	jmp    800f57 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800f26:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800f2a:	74 0a                	je     800f36 <readline+0xd5>
  800f2c:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800f30:	0f 85 61 ff ff ff    	jne    800e97 <readline+0x36>
			if (echoing)
  800f36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f3a:	74 0e                	je     800f4a <readline+0xe9>
				cputchar(c);
  800f3c:	83 ec 0c             	sub    $0xc,%esp
  800f3f:	ff 75 ec             	pushl  -0x14(%ebp)
  800f42:	e8 13 f6 ff ff       	call   80055a <cputchar>
  800f47:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800f4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f50:	01 d0                	add    %edx,%eax
  800f52:	c6 00 00             	movb   $0x0,(%eax)
			return;
  800f55:	eb 06                	jmp    800f5d <readline+0xfc>
		}
	}
  800f57:	e9 3b ff ff ff       	jmp    800e97 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  800f5c:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  800f5d:	c9                   	leave  
  800f5e:	c3                   	ret    

00800f5f <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
  800f62:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f65:	e8 71 14 00 00       	call   8023db <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  800f6a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f6e:	74 13                	je     800f83 <atomic_readline+0x24>
		cprintf("%s", prompt);
  800f70:	83 ec 08             	sub    $0x8,%esp
  800f73:	ff 75 08             	pushl  0x8(%ebp)
  800f76:	68 90 2f 80 00       	push   $0x802f90
  800f7b:	e8 66 f8 ff ff       	call   8007e6 <cprintf>
  800f80:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800f83:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800f8a:	83 ec 0c             	sub    $0xc,%esp
  800f8d:	6a 00                	push   $0x0
  800f8f:	e8 5c f6 ff ff       	call   8005f0 <iscons>
  800f94:	83 c4 10             	add    $0x10,%esp
  800f97:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800f9a:	e8 03 f6 ff ff       	call   8005a2 <getchar>
  800f9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800fa2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800fa6:	79 23                	jns    800fcb <atomic_readline+0x6c>
			if (c != -E_EOF)
  800fa8:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800fac:	74 13                	je     800fc1 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  800fae:	83 ec 08             	sub    $0x8,%esp
  800fb1:	ff 75 ec             	pushl  -0x14(%ebp)
  800fb4:	68 93 2f 80 00       	push   $0x802f93
  800fb9:	e8 28 f8 ff ff       	call   8007e6 <cprintf>
  800fbe:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800fc1:	e8 2f 14 00 00       	call   8023f5 <sys_enable_interrupt>
			return;
  800fc6:	e9 9a 00 00 00       	jmp    801065 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800fcb:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800fcf:	7e 34                	jle    801005 <atomic_readline+0xa6>
  800fd1:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800fd8:	7f 2b                	jg     801005 <atomic_readline+0xa6>
			if (echoing)
  800fda:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fde:	74 0e                	je     800fee <atomic_readline+0x8f>
				cputchar(c);
  800fe0:	83 ec 0c             	sub    $0xc,%esp
  800fe3:	ff 75 ec             	pushl  -0x14(%ebp)
  800fe6:	e8 6f f5 ff ff       	call   80055a <cputchar>
  800feb:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff1:	8d 50 01             	lea    0x1(%eax),%edx
  800ff4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800ff7:	89 c2                	mov    %eax,%edx
  800ff9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffc:	01 d0                	add    %edx,%eax
  800ffe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801001:	88 10                	mov    %dl,(%eax)
  801003:	eb 5b                	jmp    801060 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  801005:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801009:	75 1f                	jne    80102a <atomic_readline+0xcb>
  80100b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80100f:	7e 19                	jle    80102a <atomic_readline+0xcb>
			if (echoing)
  801011:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801015:	74 0e                	je     801025 <atomic_readline+0xc6>
				cputchar(c);
  801017:	83 ec 0c             	sub    $0xc,%esp
  80101a:	ff 75 ec             	pushl  -0x14(%ebp)
  80101d:	e8 38 f5 ff ff       	call   80055a <cputchar>
  801022:	83 c4 10             	add    $0x10,%esp
			i--;
  801025:	ff 4d f4             	decl   -0xc(%ebp)
  801028:	eb 36                	jmp    801060 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  80102a:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80102e:	74 0a                	je     80103a <atomic_readline+0xdb>
  801030:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801034:	0f 85 60 ff ff ff    	jne    800f9a <atomic_readline+0x3b>
			if (echoing)
  80103a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80103e:	74 0e                	je     80104e <atomic_readline+0xef>
				cputchar(c);
  801040:	83 ec 0c             	sub    $0xc,%esp
  801043:	ff 75 ec             	pushl  -0x14(%ebp)
  801046:	e8 0f f5 ff ff       	call   80055a <cputchar>
  80104b:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  80104e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	01 d0                	add    %edx,%eax
  801056:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  801059:	e8 97 13 00 00       	call   8023f5 <sys_enable_interrupt>
			return;
  80105e:	eb 05                	jmp    801065 <atomic_readline+0x106>
		}
	}
  801060:	e9 35 ff ff ff       	jmp    800f9a <atomic_readline+0x3b>
}
  801065:	c9                   	leave  
  801066:	c3                   	ret    

00801067 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801067:	55                   	push   %ebp
  801068:	89 e5                	mov    %esp,%ebp
  80106a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80106d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801074:	eb 06                	jmp    80107c <strlen+0x15>
		n++;
  801076:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801079:	ff 45 08             	incl   0x8(%ebp)
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	8a 00                	mov    (%eax),%al
  801081:	84 c0                	test   %al,%al
  801083:	75 f1                	jne    801076 <strlen+0xf>
		n++;
	return n;
  801085:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801088:	c9                   	leave  
  801089:	c3                   	ret    

0080108a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801090:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801097:	eb 09                	jmp    8010a2 <strnlen+0x18>
		n++;
  801099:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80109c:	ff 45 08             	incl   0x8(%ebp)
  80109f:	ff 4d 0c             	decl   0xc(%ebp)
  8010a2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010a6:	74 09                	je     8010b1 <strnlen+0x27>
  8010a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ab:	8a 00                	mov    (%eax),%al
  8010ad:	84 c0                	test   %al,%al
  8010af:	75 e8                	jne    801099 <strnlen+0xf>
		n++;
	return n;
  8010b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010b4:	c9                   	leave  
  8010b5:	c3                   	ret    

008010b6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
  8010b9:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010c2:	90                   	nop
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8d 50 01             	lea    0x1(%eax),%edx
  8010c9:	89 55 08             	mov    %edx,0x8(%ebp)
  8010cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010cf:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010d2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010d5:	8a 12                	mov    (%edx),%dl
  8010d7:	88 10                	mov    %dl,(%eax)
  8010d9:	8a 00                	mov    (%eax),%al
  8010db:	84 c0                	test   %al,%al
  8010dd:	75 e4                	jne    8010c3 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010df:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010e2:	c9                   	leave  
  8010e3:	c3                   	ret    

008010e4 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010e4:	55                   	push   %ebp
  8010e5:	89 e5                	mov    %esp,%ebp
  8010e7:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ed:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010f7:	eb 1f                	jmp    801118 <strncpy+0x34>
		*dst++ = *src;
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fc:	8d 50 01             	lea    0x1(%eax),%edx
  8010ff:	89 55 08             	mov    %edx,0x8(%ebp)
  801102:	8b 55 0c             	mov    0xc(%ebp),%edx
  801105:	8a 12                	mov    (%edx),%dl
  801107:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110c:	8a 00                	mov    (%eax),%al
  80110e:	84 c0                	test   %al,%al
  801110:	74 03                	je     801115 <strncpy+0x31>
			src++;
  801112:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801115:	ff 45 fc             	incl   -0x4(%ebp)
  801118:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80111e:	72 d9                	jb     8010f9 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801120:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801123:	c9                   	leave  
  801124:	c3                   	ret    

00801125 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801125:	55                   	push   %ebp
  801126:	89 e5                	mov    %esp,%ebp
  801128:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801131:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801135:	74 30                	je     801167 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801137:	eb 16                	jmp    80114f <strlcpy+0x2a>
			*dst++ = *src++;
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	8d 50 01             	lea    0x1(%eax),%edx
  80113f:	89 55 08             	mov    %edx,0x8(%ebp)
  801142:	8b 55 0c             	mov    0xc(%ebp),%edx
  801145:	8d 4a 01             	lea    0x1(%edx),%ecx
  801148:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80114b:	8a 12                	mov    (%edx),%dl
  80114d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80114f:	ff 4d 10             	decl   0x10(%ebp)
  801152:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801156:	74 09                	je     801161 <strlcpy+0x3c>
  801158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115b:	8a 00                	mov    (%eax),%al
  80115d:	84 c0                	test   %al,%al
  80115f:	75 d8                	jne    801139 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801167:	8b 55 08             	mov    0x8(%ebp),%edx
  80116a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116d:	29 c2                	sub    %eax,%edx
  80116f:	89 d0                	mov    %edx,%eax
}
  801171:	c9                   	leave  
  801172:	c3                   	ret    

00801173 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801173:	55                   	push   %ebp
  801174:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801176:	eb 06                	jmp    80117e <strcmp+0xb>
		p++, q++;
  801178:	ff 45 08             	incl   0x8(%ebp)
  80117b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80117e:	8b 45 08             	mov    0x8(%ebp),%eax
  801181:	8a 00                	mov    (%eax),%al
  801183:	84 c0                	test   %al,%al
  801185:	74 0e                	je     801195 <strcmp+0x22>
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	8a 10                	mov    (%eax),%dl
  80118c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118f:	8a 00                	mov    (%eax),%al
  801191:	38 c2                	cmp    %al,%dl
  801193:	74 e3                	je     801178 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	0f b6 d0             	movzbl %al,%edx
  80119d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a0:	8a 00                	mov    (%eax),%al
  8011a2:	0f b6 c0             	movzbl %al,%eax
  8011a5:	29 c2                	sub    %eax,%edx
  8011a7:	89 d0                	mov    %edx,%eax
}
  8011a9:	5d                   	pop    %ebp
  8011aa:	c3                   	ret    

008011ab <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8011ae:	eb 09                	jmp    8011b9 <strncmp+0xe>
		n--, p++, q++;
  8011b0:	ff 4d 10             	decl   0x10(%ebp)
  8011b3:	ff 45 08             	incl   0x8(%ebp)
  8011b6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8011b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011bd:	74 17                	je     8011d6 <strncmp+0x2b>
  8011bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c2:	8a 00                	mov    (%eax),%al
  8011c4:	84 c0                	test   %al,%al
  8011c6:	74 0e                	je     8011d6 <strncmp+0x2b>
  8011c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cb:	8a 10                	mov    (%eax),%dl
  8011cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d0:	8a 00                	mov    (%eax),%al
  8011d2:	38 c2                	cmp    %al,%dl
  8011d4:	74 da                	je     8011b0 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011da:	75 07                	jne    8011e3 <strncmp+0x38>
		return 0;
  8011dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8011e1:	eb 14                	jmp    8011f7 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e6:	8a 00                	mov    (%eax),%al
  8011e8:	0f b6 d0             	movzbl %al,%edx
  8011eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ee:	8a 00                	mov    (%eax),%al
  8011f0:	0f b6 c0             	movzbl %al,%eax
  8011f3:	29 c2                	sub    %eax,%edx
  8011f5:	89 d0                	mov    %edx,%eax
}
  8011f7:	5d                   	pop    %ebp
  8011f8:	c3                   	ret    

008011f9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011f9:	55                   	push   %ebp
  8011fa:	89 e5                	mov    %esp,%ebp
  8011fc:	83 ec 04             	sub    $0x4,%esp
  8011ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801202:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801205:	eb 12                	jmp    801219 <strchr+0x20>
		if (*s == c)
  801207:	8b 45 08             	mov    0x8(%ebp),%eax
  80120a:	8a 00                	mov    (%eax),%al
  80120c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80120f:	75 05                	jne    801216 <strchr+0x1d>
			return (char *) s;
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	eb 11                	jmp    801227 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801216:	ff 45 08             	incl   0x8(%ebp)
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	8a 00                	mov    (%eax),%al
  80121e:	84 c0                	test   %al,%al
  801220:	75 e5                	jne    801207 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801222:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801227:	c9                   	leave  
  801228:	c3                   	ret    

00801229 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801229:	55                   	push   %ebp
  80122a:	89 e5                	mov    %esp,%ebp
  80122c:	83 ec 04             	sub    $0x4,%esp
  80122f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801232:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801235:	eb 0d                	jmp    801244 <strfind+0x1b>
		if (*s == c)
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	8a 00                	mov    (%eax),%al
  80123c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80123f:	74 0e                	je     80124f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801241:	ff 45 08             	incl   0x8(%ebp)
  801244:	8b 45 08             	mov    0x8(%ebp),%eax
  801247:	8a 00                	mov    (%eax),%al
  801249:	84 c0                	test   %al,%al
  80124b:	75 ea                	jne    801237 <strfind+0xe>
  80124d:	eb 01                	jmp    801250 <strfind+0x27>
		if (*s == c)
			break;
  80124f:	90                   	nop
	return (char *) s;
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801253:	c9                   	leave  
  801254:	c3                   	ret    

00801255 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801255:	55                   	push   %ebp
  801256:	89 e5                	mov    %esp,%ebp
  801258:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80125b:	8b 45 08             	mov    0x8(%ebp),%eax
  80125e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801261:	8b 45 10             	mov    0x10(%ebp),%eax
  801264:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801267:	eb 0e                	jmp    801277 <memset+0x22>
		*p++ = c;
  801269:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80126c:	8d 50 01             	lea    0x1(%eax),%edx
  80126f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801272:	8b 55 0c             	mov    0xc(%ebp),%edx
  801275:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801277:	ff 4d f8             	decl   -0x8(%ebp)
  80127a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80127e:	79 e9                	jns    801269 <memset+0x14>
		*p++ = c;

	return v;
  801280:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801283:	c9                   	leave  
  801284:	c3                   	ret    

00801285 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801285:	55                   	push   %ebp
  801286:	89 e5                	mov    %esp,%ebp
  801288:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80128b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801291:	8b 45 08             	mov    0x8(%ebp),%eax
  801294:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801297:	eb 16                	jmp    8012af <memcpy+0x2a>
		*d++ = *s++;
  801299:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80129c:	8d 50 01             	lea    0x1(%eax),%edx
  80129f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012a5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012a8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012ab:	8a 12                	mov    (%edx),%dl
  8012ad:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8012af:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012b5:	89 55 10             	mov    %edx,0x10(%ebp)
  8012b8:	85 c0                	test   %eax,%eax
  8012ba:	75 dd                	jne    801299 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8012bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012bf:	c9                   	leave  
  8012c0:	c3                   	ret    

008012c1 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012c1:	55                   	push   %ebp
  8012c2:	89 e5                	mov    %esp,%ebp
  8012c4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  8012c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012d9:	73 50                	jae    80132b <memmove+0x6a>
  8012db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012de:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e1:	01 d0                	add    %edx,%eax
  8012e3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012e6:	76 43                	jbe    80132b <memmove+0x6a>
		s += n;
  8012e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012eb:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8012ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f1:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012f4:	eb 10                	jmp    801306 <memmove+0x45>
			*--d = *--s;
  8012f6:	ff 4d f8             	decl   -0x8(%ebp)
  8012f9:	ff 4d fc             	decl   -0x4(%ebp)
  8012fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ff:	8a 10                	mov    (%eax),%dl
  801301:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801304:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801306:	8b 45 10             	mov    0x10(%ebp),%eax
  801309:	8d 50 ff             	lea    -0x1(%eax),%edx
  80130c:	89 55 10             	mov    %edx,0x10(%ebp)
  80130f:	85 c0                	test   %eax,%eax
  801311:	75 e3                	jne    8012f6 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801313:	eb 23                	jmp    801338 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801315:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801318:	8d 50 01             	lea    0x1(%eax),%edx
  80131b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80131e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801321:	8d 4a 01             	lea    0x1(%edx),%ecx
  801324:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801327:	8a 12                	mov    (%edx),%dl
  801329:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80132b:	8b 45 10             	mov    0x10(%ebp),%eax
  80132e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801331:	89 55 10             	mov    %edx,0x10(%ebp)
  801334:	85 c0                	test   %eax,%eax
  801336:	75 dd                	jne    801315 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801338:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80133b:	c9                   	leave  
  80133c:	c3                   	ret    

0080133d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
  801340:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801343:	8b 45 08             	mov    0x8(%ebp),%eax
  801346:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801349:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80134f:	eb 2a                	jmp    80137b <memcmp+0x3e>
		if (*s1 != *s2)
  801351:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801354:	8a 10                	mov    (%eax),%dl
  801356:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801359:	8a 00                	mov    (%eax),%al
  80135b:	38 c2                	cmp    %al,%dl
  80135d:	74 16                	je     801375 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80135f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801362:	8a 00                	mov    (%eax),%al
  801364:	0f b6 d0             	movzbl %al,%edx
  801367:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80136a:	8a 00                	mov    (%eax),%al
  80136c:	0f b6 c0             	movzbl %al,%eax
  80136f:	29 c2                	sub    %eax,%edx
  801371:	89 d0                	mov    %edx,%eax
  801373:	eb 18                	jmp    80138d <memcmp+0x50>
		s1++, s2++;
  801375:	ff 45 fc             	incl   -0x4(%ebp)
  801378:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80137b:	8b 45 10             	mov    0x10(%ebp),%eax
  80137e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801381:	89 55 10             	mov    %edx,0x10(%ebp)
  801384:	85 c0                	test   %eax,%eax
  801386:	75 c9                	jne    801351 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801388:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80138d:	c9                   	leave  
  80138e:	c3                   	ret    

0080138f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80138f:	55                   	push   %ebp
  801390:	89 e5                	mov    %esp,%ebp
  801392:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801395:	8b 55 08             	mov    0x8(%ebp),%edx
  801398:	8b 45 10             	mov    0x10(%ebp),%eax
  80139b:	01 d0                	add    %edx,%eax
  80139d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8013a0:	eb 15                	jmp    8013b7 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	8a 00                	mov    (%eax),%al
  8013a7:	0f b6 d0             	movzbl %al,%edx
  8013aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ad:	0f b6 c0             	movzbl %al,%eax
  8013b0:	39 c2                	cmp    %eax,%edx
  8013b2:	74 0d                	je     8013c1 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013b4:	ff 45 08             	incl   0x8(%ebp)
  8013b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ba:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013bd:	72 e3                	jb     8013a2 <memfind+0x13>
  8013bf:	eb 01                	jmp    8013c2 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013c1:	90                   	nop
	return (void *) s;
  8013c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013c5:	c9                   	leave  
  8013c6:	c3                   	ret    

008013c7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013c7:	55                   	push   %ebp
  8013c8:	89 e5                	mov    %esp,%ebp
  8013ca:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013d4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013db:	eb 03                	jmp    8013e0 <strtol+0x19>
		s++;
  8013dd:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e3:	8a 00                	mov    (%eax),%al
  8013e5:	3c 20                	cmp    $0x20,%al
  8013e7:	74 f4                	je     8013dd <strtol+0x16>
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	8a 00                	mov    (%eax),%al
  8013ee:	3c 09                	cmp    $0x9,%al
  8013f0:	74 eb                	je     8013dd <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	3c 2b                	cmp    $0x2b,%al
  8013f9:	75 05                	jne    801400 <strtol+0x39>
		s++;
  8013fb:	ff 45 08             	incl   0x8(%ebp)
  8013fe:	eb 13                	jmp    801413 <strtol+0x4c>
	else if (*s == '-')
  801400:	8b 45 08             	mov    0x8(%ebp),%eax
  801403:	8a 00                	mov    (%eax),%al
  801405:	3c 2d                	cmp    $0x2d,%al
  801407:	75 0a                	jne    801413 <strtol+0x4c>
		s++, neg = 1;
  801409:	ff 45 08             	incl   0x8(%ebp)
  80140c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801413:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801417:	74 06                	je     80141f <strtol+0x58>
  801419:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80141d:	75 20                	jne    80143f <strtol+0x78>
  80141f:	8b 45 08             	mov    0x8(%ebp),%eax
  801422:	8a 00                	mov    (%eax),%al
  801424:	3c 30                	cmp    $0x30,%al
  801426:	75 17                	jne    80143f <strtol+0x78>
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	40                   	inc    %eax
  80142c:	8a 00                	mov    (%eax),%al
  80142e:	3c 78                	cmp    $0x78,%al
  801430:	75 0d                	jne    80143f <strtol+0x78>
		s += 2, base = 16;
  801432:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801436:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80143d:	eb 28                	jmp    801467 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80143f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801443:	75 15                	jne    80145a <strtol+0x93>
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	8a 00                	mov    (%eax),%al
  80144a:	3c 30                	cmp    $0x30,%al
  80144c:	75 0c                	jne    80145a <strtol+0x93>
		s++, base = 8;
  80144e:	ff 45 08             	incl   0x8(%ebp)
  801451:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801458:	eb 0d                	jmp    801467 <strtol+0xa0>
	else if (base == 0)
  80145a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80145e:	75 07                	jne    801467 <strtol+0xa0>
		base = 10;
  801460:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801467:	8b 45 08             	mov    0x8(%ebp),%eax
  80146a:	8a 00                	mov    (%eax),%al
  80146c:	3c 2f                	cmp    $0x2f,%al
  80146e:	7e 19                	jle    801489 <strtol+0xc2>
  801470:	8b 45 08             	mov    0x8(%ebp),%eax
  801473:	8a 00                	mov    (%eax),%al
  801475:	3c 39                	cmp    $0x39,%al
  801477:	7f 10                	jg     801489 <strtol+0xc2>
			dig = *s - '0';
  801479:	8b 45 08             	mov    0x8(%ebp),%eax
  80147c:	8a 00                	mov    (%eax),%al
  80147e:	0f be c0             	movsbl %al,%eax
  801481:	83 e8 30             	sub    $0x30,%eax
  801484:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801487:	eb 42                	jmp    8014cb <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	8a 00                	mov    (%eax),%al
  80148e:	3c 60                	cmp    $0x60,%al
  801490:	7e 19                	jle    8014ab <strtol+0xe4>
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	8a 00                	mov    (%eax),%al
  801497:	3c 7a                	cmp    $0x7a,%al
  801499:	7f 10                	jg     8014ab <strtol+0xe4>
			dig = *s - 'a' + 10;
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	8a 00                	mov    (%eax),%al
  8014a0:	0f be c0             	movsbl %al,%eax
  8014a3:	83 e8 57             	sub    $0x57,%eax
  8014a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014a9:	eb 20                	jmp    8014cb <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	8a 00                	mov    (%eax),%al
  8014b0:	3c 40                	cmp    $0x40,%al
  8014b2:	7e 39                	jle    8014ed <strtol+0x126>
  8014b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b7:	8a 00                	mov    (%eax),%al
  8014b9:	3c 5a                	cmp    $0x5a,%al
  8014bb:	7f 30                	jg     8014ed <strtol+0x126>
			dig = *s - 'A' + 10;
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	8a 00                	mov    (%eax),%al
  8014c2:	0f be c0             	movsbl %al,%eax
  8014c5:	83 e8 37             	sub    $0x37,%eax
  8014c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ce:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014d1:	7d 19                	jge    8014ec <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014d3:	ff 45 08             	incl   0x8(%ebp)
  8014d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014d9:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014dd:	89 c2                	mov    %eax,%edx
  8014df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014e2:	01 d0                	add    %edx,%eax
  8014e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8014e7:	e9 7b ff ff ff       	jmp    801467 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014ec:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014f1:	74 08                	je     8014fb <strtol+0x134>
		*endptr = (char *) s;
  8014f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f9:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014ff:	74 07                	je     801508 <strtol+0x141>
  801501:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801504:	f7 d8                	neg    %eax
  801506:	eb 03                	jmp    80150b <strtol+0x144>
  801508:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80150b:	c9                   	leave  
  80150c:	c3                   	ret    

0080150d <ltostr>:

void
ltostr(long value, char *str)
{
  80150d:	55                   	push   %ebp
  80150e:	89 e5                	mov    %esp,%ebp
  801510:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801513:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80151a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801521:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801525:	79 13                	jns    80153a <ltostr+0x2d>
	{
		neg = 1;
  801527:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80152e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801531:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801534:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801537:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801542:	99                   	cltd   
  801543:	f7 f9                	idiv   %ecx
  801545:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801548:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80154b:	8d 50 01             	lea    0x1(%eax),%edx
  80154e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801551:	89 c2                	mov    %eax,%edx
  801553:	8b 45 0c             	mov    0xc(%ebp),%eax
  801556:	01 d0                	add    %edx,%eax
  801558:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80155b:	83 c2 30             	add    $0x30,%edx
  80155e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801560:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801563:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801568:	f7 e9                	imul   %ecx
  80156a:	c1 fa 02             	sar    $0x2,%edx
  80156d:	89 c8                	mov    %ecx,%eax
  80156f:	c1 f8 1f             	sar    $0x1f,%eax
  801572:	29 c2                	sub    %eax,%edx
  801574:	89 d0                	mov    %edx,%eax
  801576:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801579:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80157c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801581:	f7 e9                	imul   %ecx
  801583:	c1 fa 02             	sar    $0x2,%edx
  801586:	89 c8                	mov    %ecx,%eax
  801588:	c1 f8 1f             	sar    $0x1f,%eax
  80158b:	29 c2                	sub    %eax,%edx
  80158d:	89 d0                	mov    %edx,%eax
  80158f:	c1 e0 02             	shl    $0x2,%eax
  801592:	01 d0                	add    %edx,%eax
  801594:	01 c0                	add    %eax,%eax
  801596:	29 c1                	sub    %eax,%ecx
  801598:	89 ca                	mov    %ecx,%edx
  80159a:	85 d2                	test   %edx,%edx
  80159c:	75 9c                	jne    80153a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80159e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8015a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015a8:	48                   	dec    %eax
  8015a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8015ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015b0:	74 3d                	je     8015ef <ltostr+0xe2>
		start = 1 ;
  8015b2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015b9:	eb 34                	jmp    8015ef <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8015bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c1:	01 d0                	add    %edx,%eax
  8015c3:	8a 00                	mov    (%eax),%al
  8015c5:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ce:	01 c2                	add    %eax,%edx
  8015d0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d6:	01 c8                	add    %ecx,%eax
  8015d8:	8a 00                	mov    (%eax),%al
  8015da:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e2:	01 c2                	add    %eax,%edx
  8015e4:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015e7:	88 02                	mov    %al,(%edx)
		start++ ;
  8015e9:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015ec:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015f5:	7c c4                	jl     8015bb <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015f7:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fd:	01 d0                	add    %edx,%eax
  8015ff:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801602:	90                   	nop
  801603:	c9                   	leave  
  801604:	c3                   	ret    

00801605 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
  801608:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80160b:	ff 75 08             	pushl  0x8(%ebp)
  80160e:	e8 54 fa ff ff       	call   801067 <strlen>
  801613:	83 c4 04             	add    $0x4,%esp
  801616:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801619:	ff 75 0c             	pushl  0xc(%ebp)
  80161c:	e8 46 fa ff ff       	call   801067 <strlen>
  801621:	83 c4 04             	add    $0x4,%esp
  801624:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801627:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80162e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801635:	eb 17                	jmp    80164e <strcconcat+0x49>
		final[s] = str1[s] ;
  801637:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80163a:	8b 45 10             	mov    0x10(%ebp),%eax
  80163d:	01 c2                	add    %eax,%edx
  80163f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801642:	8b 45 08             	mov    0x8(%ebp),%eax
  801645:	01 c8                	add    %ecx,%eax
  801647:	8a 00                	mov    (%eax),%al
  801649:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80164b:	ff 45 fc             	incl   -0x4(%ebp)
  80164e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801651:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801654:	7c e1                	jl     801637 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801656:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80165d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801664:	eb 1f                	jmp    801685 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801666:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801669:	8d 50 01             	lea    0x1(%eax),%edx
  80166c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80166f:	89 c2                	mov    %eax,%edx
  801671:	8b 45 10             	mov    0x10(%ebp),%eax
  801674:	01 c2                	add    %eax,%edx
  801676:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801679:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167c:	01 c8                	add    %ecx,%eax
  80167e:	8a 00                	mov    (%eax),%al
  801680:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801682:	ff 45 f8             	incl   -0x8(%ebp)
  801685:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801688:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80168b:	7c d9                	jl     801666 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80168d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801690:	8b 45 10             	mov    0x10(%ebp),%eax
  801693:	01 d0                	add    %edx,%eax
  801695:	c6 00 00             	movb   $0x0,(%eax)
}
  801698:	90                   	nop
  801699:	c9                   	leave  
  80169a:	c3                   	ret    

0080169b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80169e:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8016a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8016aa:	8b 00                	mov    (%eax),%eax
  8016ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b6:	01 d0                	add    %edx,%eax
  8016b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016be:	eb 0c                	jmp    8016cc <strsplit+0x31>
			*string++ = 0;
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	8d 50 01             	lea    0x1(%eax),%edx
  8016c6:	89 55 08             	mov    %edx,0x8(%ebp)
  8016c9:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cf:	8a 00                	mov    (%eax),%al
  8016d1:	84 c0                	test   %al,%al
  8016d3:	74 18                	je     8016ed <strsplit+0x52>
  8016d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d8:	8a 00                	mov    (%eax),%al
  8016da:	0f be c0             	movsbl %al,%eax
  8016dd:	50                   	push   %eax
  8016de:	ff 75 0c             	pushl  0xc(%ebp)
  8016e1:	e8 13 fb ff ff       	call   8011f9 <strchr>
  8016e6:	83 c4 08             	add    $0x8,%esp
  8016e9:	85 c0                	test   %eax,%eax
  8016eb:	75 d3                	jne    8016c0 <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  8016ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f0:	8a 00                	mov    (%eax),%al
  8016f2:	84 c0                	test   %al,%al
  8016f4:	74 5a                	je     801750 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  8016f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f9:	8b 00                	mov    (%eax),%eax
  8016fb:	83 f8 0f             	cmp    $0xf,%eax
  8016fe:	75 07                	jne    801707 <strsplit+0x6c>
		{
			return 0;
  801700:	b8 00 00 00 00       	mov    $0x0,%eax
  801705:	eb 66                	jmp    80176d <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801707:	8b 45 14             	mov    0x14(%ebp),%eax
  80170a:	8b 00                	mov    (%eax),%eax
  80170c:	8d 48 01             	lea    0x1(%eax),%ecx
  80170f:	8b 55 14             	mov    0x14(%ebp),%edx
  801712:	89 0a                	mov    %ecx,(%edx)
  801714:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80171b:	8b 45 10             	mov    0x10(%ebp),%eax
  80171e:	01 c2                	add    %eax,%edx
  801720:	8b 45 08             	mov    0x8(%ebp),%eax
  801723:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801725:	eb 03                	jmp    80172a <strsplit+0x8f>
			string++;
  801727:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80172a:	8b 45 08             	mov    0x8(%ebp),%eax
  80172d:	8a 00                	mov    (%eax),%al
  80172f:	84 c0                	test   %al,%al
  801731:	74 8b                	je     8016be <strsplit+0x23>
  801733:	8b 45 08             	mov    0x8(%ebp),%eax
  801736:	8a 00                	mov    (%eax),%al
  801738:	0f be c0             	movsbl %al,%eax
  80173b:	50                   	push   %eax
  80173c:	ff 75 0c             	pushl  0xc(%ebp)
  80173f:	e8 b5 fa ff ff       	call   8011f9 <strchr>
  801744:	83 c4 08             	add    $0x8,%esp
  801747:	85 c0                	test   %eax,%eax
  801749:	74 dc                	je     801727 <strsplit+0x8c>
			string++;
	}
  80174b:	e9 6e ff ff ff       	jmp    8016be <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801750:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801751:	8b 45 14             	mov    0x14(%ebp),%eax
  801754:	8b 00                	mov    (%eax),%eax
  801756:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80175d:	8b 45 10             	mov    0x10(%ebp),%eax
  801760:	01 d0                	add    %edx,%eax
  801762:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801768:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80176d:	c9                   	leave  
  80176e:	c3                   	ret    

0080176f <malloc>:
int cnt_mem = 0;
int heap_mem[size_uhmem] = { 0 };
struct hmem heap_size[size_uhmem] = { 0 };
int check = 0;

void* malloc(uint32 size) {
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
  801772:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyNEXTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	//NEXT FIT
	if (sys_isUHeapPlacementStrategyNEXTFIT()) {
  801778:	e8 7d 0f 00 00       	call   8026fa <sys_isUHeapPlacementStrategyNEXTFIT>
  80177d:	85 c0                	test   %eax,%eax
  80177f:	0f 84 6f 03 00 00    	je     801af4 <malloc+0x385>
		size = ROUNDUP(size, PAGE_SIZE);
  801785:	c7 45 84 00 10 00 00 	movl   $0x1000,-0x7c(%ebp)
  80178c:	8b 55 08             	mov    0x8(%ebp),%edx
  80178f:	8b 45 84             	mov    -0x7c(%ebp),%eax
  801792:	01 d0                	add    %edx,%eax
  801794:	48                   	dec    %eax
  801795:	89 45 80             	mov    %eax,-0x80(%ebp)
  801798:	8b 45 80             	mov    -0x80(%ebp),%eax
  80179b:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a0:	f7 75 84             	divl   -0x7c(%ebp)
  8017a3:	8b 45 80             	mov    -0x80(%ebp),%eax
  8017a6:	29 d0                	sub    %edx,%eax
  8017a8:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  8017ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017af:	74 09                	je     8017ba <malloc+0x4b>
  8017b1:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8017b8:	76 0a                	jbe    8017c4 <malloc+0x55>
			return NULL;
  8017ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8017bf:	e9 4b 09 00 00       	jmp    80210f <malloc+0x9a0>
		}
		// first we can allocate by " Strategy Continues "
		if (ptr_uheap + size <= (uint32) USER_HEAP_MAX && !check) {
  8017c4:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8017ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cd:	01 d0                	add    %edx,%eax
  8017cf:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8017d4:	0f 87 a2 00 00 00    	ja     80187c <malloc+0x10d>
  8017da:	a1 60 30 98 00       	mov    0x983060,%eax
  8017df:	85 c0                	test   %eax,%eax
  8017e1:	0f 85 95 00 00 00    	jne    80187c <malloc+0x10d>

			void* ret = (void *) ptr_uheap;
  8017e7:	a1 04 30 80 00       	mov    0x803004,%eax
  8017ec:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			sys_allocateMem(ptr_uheap, size);
  8017f2:	a1 04 30 80 00       	mov    0x803004,%eax
  8017f7:	83 ec 08             	sub    $0x8,%esp
  8017fa:	ff 75 08             	pushl  0x8(%ebp)
  8017fd:	50                   	push   %eax
  8017fe:	e8 a3 0b 00 00       	call   8023a6 <sys_allocateMem>
  801803:	83 c4 10             	add    $0x10,%esp

			heap_size[cnt_mem].size = size;
  801806:	a1 40 30 80 00       	mov    0x803040,%eax
  80180b:	8b 55 08             	mov    0x8(%ebp),%edx
  80180e:	89 14 c5 64 30 88 00 	mov    %edx,0x883064(,%eax,8)
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801815:	a1 40 30 80 00       	mov    0x803040,%eax
  80181a:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801820:	89 14 c5 60 30 88 00 	mov    %edx,0x883060(,%eax,8)
			cnt_mem++;
  801827:	a1 40 30 80 00       	mov    0x803040,%eax
  80182c:	40                   	inc    %eax
  80182d:	a3 40 30 80 00       	mov    %eax,0x803040
			int i = 0;
  801832:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  801839:	eb 2e                	jmp    801869 <malloc+0xfa>
			{

				heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  80183b:	a1 04 30 80 00       	mov    0x803004,%eax
  801840:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] = 1;
  801845:	c1 e8 0c             	shr    $0xc,%eax
  801848:	c7 04 85 60 30 80 00 	movl   $0x1,0x803060(,%eax,4)
  80184f:	01 00 00 00 

				ptr_uheap += (uint32) PAGE_SIZE;
  801853:	a1 04 30 80 00       	mov    0x803004,%eax
  801858:	05 00 10 00 00       	add    $0x1000,%eax
  80185d:	a3 04 30 80 00       	mov    %eax,0x803004
			heap_size[cnt_mem].size = size;
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
			cnt_mem++;
			int i = 0;
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  801862:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80186c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80186f:	72 ca                	jb     80183b <malloc+0xcc>
						/ (uint32) PAGE_SIZE)] = 1;

				ptr_uheap += (uint32) PAGE_SIZE;
			}

			return ret;
  801871:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  801877:	e9 93 08 00 00       	jmp    80210f <malloc+0x9a0>

		} else {
			// second we can allocate by " Strategy NEXTFIT "
			void* temp_end = NULL;
  80187c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

			int check_start = 0;
  801883:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			// check first that we used " Strategy Continues " before and not do it again and turn to NEXTFIT
			if (!check) {
  80188a:	a1 60 30 98 00       	mov    0x983060,%eax
  80188f:	85 c0                	test   %eax,%eax
  801891:	75 1d                	jne    8018b0 <malloc+0x141>
				ptr_uheap = (uint32) USER_HEAP_START;
  801893:	c7 05 04 30 80 00 00 	movl   $0x80000000,0x803004
  80189a:	00 00 80 
				check = 1;
  80189d:	c7 05 60 30 98 00 01 	movl   $0x1,0x983060
  8018a4:	00 00 00 
				check_start = 1;// to dont use second loop CZ ptr_uheap start from USER_HEAP_START
  8018a7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  8018ae:	eb 08                	jmp    8018b8 <malloc+0x149>
			} else {
				temp_end = (void*) ptr_uheap;
  8018b0:	a1 04 30 80 00       	mov    0x803004,%eax
  8018b5:	89 45 f0             	mov    %eax,-0x10(%ebp)

			}

			uint32 sz = 0;
  8018b8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
			int f = 0;
  8018bf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			uint32 ptr = ptr_uheap;
  8018c6:	a1 04 30 80 00       	mov    0x803004,%eax
  8018cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  8018ce:	eb 4d                	jmp    80191d <malloc+0x1ae>
				if (sz == size) {
  8018d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018d3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8018d6:	75 09                	jne    8018e1 <malloc+0x172>
					f = 1;
  8018d8:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  8018df:	eb 45                	jmp    801926 <malloc+0x1b7>
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  8018e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018e4:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] == 0) {
  8018e9:	c1 e8 0c             	shr    $0xc,%eax
			while (ptr < (uint32) USER_HEAP_MAX) {
				if (sz == size) {
					f = 1;
					break;
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  8018ec:	8b 04 85 60 30 80 00 	mov    0x803060(,%eax,4),%eax
  8018f3:	85 c0                	test   %eax,%eax
  8018f5:	75 10                	jne    801907 <malloc+0x198>
						/ (uint32) PAGE_SIZE)] == 0) {

					sz += PAGE_SIZE;
  8018f7:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
					ptr += PAGE_SIZE;
  8018fe:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  801905:	eb 16                	jmp    80191d <malloc+0x1ae>
				} else {
					sz = 0;
  801907:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
					ptr += PAGE_SIZE;
  80190e:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
					ptr_uheap = ptr;
  801915:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801918:	a3 04 30 80 00       	mov    %eax,0x803004

			uint32 sz = 0;
			int f = 0;
			uint32 ptr = ptr_uheap;
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  80191d:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  801924:	76 aa                	jbe    8018d0 <malloc+0x161>
					ptr_uheap = ptr;
				}

			}

			if (f) {
  801926:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80192a:	0f 84 95 00 00 00    	je     8019c5 <malloc+0x256>

				void* ret = (void *) ptr_uheap;
  801930:	a1 04 30 80 00       	mov    0x803004,%eax
  801935:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

				sys_allocateMem(ptr_uheap, size);
  80193b:	a1 04 30 80 00       	mov    0x803004,%eax
  801940:	83 ec 08             	sub    $0x8,%esp
  801943:	ff 75 08             	pushl  0x8(%ebp)
  801946:	50                   	push   %eax
  801947:	e8 5a 0a 00 00       	call   8023a6 <sys_allocateMem>
  80194c:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  80194f:	a1 40 30 80 00       	mov    0x803040,%eax
  801954:	8b 55 08             	mov    0x8(%ebp),%edx
  801957:	89 14 c5 64 30 88 00 	mov    %edx,0x883064(,%eax,8)
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
  80195e:	a1 40 30 80 00       	mov    0x803040,%eax
  801963:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801969:	89 14 c5 60 30 88 00 	mov    %edx,0x883060(,%eax,8)
				cnt_mem++;
  801970:	a1 40 30 80 00       	mov    0x803040,%eax
  801975:	40                   	inc    %eax
  801976:	a3 40 30 80 00       	mov    %eax,0x803040
				int i = 0;
  80197b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801982:	eb 2e                	jmp    8019b2 <malloc+0x243>
				{

					heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801984:	a1 04 30 80 00       	mov    0x803004,%eax
  801989:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  80198e:	c1 e8 0c             	shr    $0xc,%eax
  801991:	c7 04 85 60 30 80 00 	movl   $0x1,0x803060(,%eax,4)
  801998:	01 00 00 00 

					ptr_uheap += (uint32) PAGE_SIZE;
  80199c:	a1 04 30 80 00       	mov    0x803004,%eax
  8019a1:	05 00 10 00 00       	add    $0x1000,%eax
  8019a6:	a3 04 30 80 00       	mov    %eax,0x803004
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
				cnt_mem++;
				int i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  8019ab:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  8019b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019b5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8019b8:	72 ca                	jb     801984 <malloc+0x215>
							/ (uint32) PAGE_SIZE)] = 1;

					ptr_uheap += (uint32) PAGE_SIZE;
				}

				return ret;
  8019ba:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8019c0:	e9 4a 07 00 00       	jmp    80210f <malloc+0x9a0>

			} else {

				if (check_start) {
  8019c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019c9:	74 0a                	je     8019d5 <malloc+0x266>

					return NULL;
  8019cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d0:	e9 3a 07 00 00       	jmp    80210f <malloc+0x9a0>
				}

//////////////back loop////////////////

				uint32 sz = 0;
  8019d5:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
				int f = 0;
  8019dc:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				uint32 ptr = USER_HEAP_START;
  8019e3:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
				ptr_uheap = USER_HEAP_START;
  8019ea:	c7 05 04 30 80 00 00 	movl   $0x80000000,0x803004
  8019f1:	00 00 80 
				while (ptr < (uint32) temp_end) {
  8019f4:	eb 4d                	jmp    801a43 <malloc+0x2d4>
					if (sz == size) {
  8019f6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019f9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8019fc:	75 09                	jne    801a07 <malloc+0x298>
						f = 1;
  8019fe:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
						break;
  801a05:	eb 44                	jmp    801a4b <malloc+0x2dc>
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801a07:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801a0a:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] == 0) {
  801a0f:	c1 e8 0c             	shr    $0xc,%eax
				while (ptr < (uint32) temp_end) {
					if (sz == size) {
						f = 1;
						break;
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801a12:	8b 04 85 60 30 80 00 	mov    0x803060(,%eax,4),%eax
  801a19:	85 c0                	test   %eax,%eax
  801a1b:	75 10                	jne    801a2d <malloc+0x2be>
							/ (uint32) PAGE_SIZE)] == 0) {

						sz += PAGE_SIZE;
  801a1d:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801a24:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
  801a2b:	eb 16                	jmp    801a43 <malloc+0x2d4>
					} else {
						sz = 0;
  801a2d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801a34:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
						ptr_uheap = ptr;
  801a3b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801a3e:	a3 04 30 80 00       	mov    %eax,0x803004

				uint32 sz = 0;
				int f = 0;
				uint32 ptr = USER_HEAP_START;
				ptr_uheap = USER_HEAP_START;
				while (ptr < (uint32) temp_end) {
  801a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a46:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801a49:	72 ab                	jb     8019f6 <malloc+0x287>
						ptr_uheap = ptr;
					}

				}

				if (f) {
  801a4b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801a4f:	0f 84 95 00 00 00    	je     801aea <malloc+0x37b>

					void* ret = (void *) ptr_uheap;
  801a55:	a1 04 30 80 00       	mov    0x803004,%eax
  801a5a:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

					sys_allocateMem(ptr_uheap, size);
  801a60:	a1 04 30 80 00       	mov    0x803004,%eax
  801a65:	83 ec 08             	sub    $0x8,%esp
  801a68:	ff 75 08             	pushl  0x8(%ebp)
  801a6b:	50                   	push   %eax
  801a6c:	e8 35 09 00 00       	call   8023a6 <sys_allocateMem>
  801a71:	83 c4 10             	add    $0x10,%esp

					heap_size[cnt_mem].size = size;
  801a74:	a1 40 30 80 00       	mov    0x803040,%eax
  801a79:	8b 55 08             	mov    0x8(%ebp),%edx
  801a7c:	89 14 c5 64 30 88 00 	mov    %edx,0x883064(,%eax,8)
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801a83:	a1 40 30 80 00       	mov    0x803040,%eax
  801a88:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801a8e:	89 14 c5 60 30 88 00 	mov    %edx,0x883060(,%eax,8)
					cnt_mem++;
  801a95:	a1 40 30 80 00       	mov    0x803040,%eax
  801a9a:	40                   	inc    %eax
  801a9b:	a3 40 30 80 00       	mov    %eax,0x803040
					int i = 0;
  801aa0:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

					for (; i < size; i += PAGE_SIZE)
  801aa7:	eb 2e                	jmp    801ad7 <malloc+0x368>
					{

						heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801aa9:	a1 04 30 80 00       	mov    0x803004,%eax
  801aae:	05 00 00 00 80       	add    $0x80000000,%eax
								/ (uint32) PAGE_SIZE)] = 1;
  801ab3:	c1 e8 0c             	shr    $0xc,%eax
  801ab6:	c7 04 85 60 30 80 00 	movl   $0x1,0x803060(,%eax,4)
  801abd:	01 00 00 00 

						ptr_uheap += (uint32) PAGE_SIZE;
  801ac1:	a1 04 30 80 00       	mov    0x803004,%eax
  801ac6:	05 00 10 00 00       	add    $0x1000,%eax
  801acb:	a3 04 30 80 00       	mov    %eax,0x803004
					heap_size[cnt_mem].size = size;
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
					cnt_mem++;
					int i = 0;

					for (; i < size; i += PAGE_SIZE)
  801ad0:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  801ad7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801ada:	3b 45 08             	cmp    0x8(%ebp),%eax
  801add:	72 ca                	jb     801aa9 <malloc+0x33a>
								/ (uint32) PAGE_SIZE)] = 1;

						ptr_uheap += (uint32) PAGE_SIZE;
					}

					return ret;
  801adf:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801ae5:	e9 25 06 00 00       	jmp    80210f <malloc+0x9a0>

				} else {

					return NULL;
  801aea:	b8 00 00 00 00       	mov    $0x0,%eax
  801aef:	e9 1b 06 00 00       	jmp    80210f <malloc+0x9a0>

		}

	}

	else if (sys_isUHeapPlacementStrategyBESTFIT()) {
  801af4:	e8 d0 0b 00 00       	call   8026c9 <sys_isUHeapPlacementStrategyBESTFIT>
  801af9:	85 c0                	test   %eax,%eax
  801afb:	0f 84 ba 01 00 00    	je     801cbb <malloc+0x54c>

		size = ROUNDUP(size, PAGE_SIZE);
  801b01:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  801b08:	10 00 00 
  801b0b:	8b 55 08             	mov    0x8(%ebp),%edx
  801b0e:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  801b14:	01 d0                	add    %edx,%eax
  801b16:	48                   	dec    %eax
  801b17:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  801b1d:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801b23:	ba 00 00 00 00       	mov    $0x0,%edx
  801b28:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  801b2e:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801b34:	29 d0                	sub    %edx,%eax
  801b36:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801b39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b3d:	74 09                	je     801b48 <malloc+0x3d9>
  801b3f:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801b46:	76 0a                	jbe    801b52 <malloc+0x3e3>
			return NULL;
  801b48:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4d:	e9 bd 05 00 00       	jmp    80210f <malloc+0x9a0>
		}
		uint32 ptr = (uint32) USER_HEAP_START;
  801b52:	c7 45 c8 00 00 00 80 	movl   $0x80000000,-0x38(%ebp)
		uint32 temp = 0;
  801b59:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		uint32 min_sz = size_uhmem + 1;
  801b60:	c7 45 c0 01 00 02 00 	movl   $0x20001,-0x40(%ebp)
		uint32 count = 0;
  801b67:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
		int i = 0;
  801b6e:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801b75:	8b 45 08             	mov    0x8(%ebp),%eax
  801b78:	c1 e8 0c             	shr    $0xc,%eax
  801b7b:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801b81:	e9 80 00 00 00       	jmp    801c06 <malloc+0x497>

			if (heap_mem[i] == 0) {
  801b86:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801b89:	8b 04 85 60 30 80 00 	mov    0x803060(,%eax,4),%eax
  801b90:	85 c0                	test   %eax,%eax
  801b92:	75 0c                	jne    801ba0 <malloc+0x431>

				count++;
  801b94:	ff 45 bc             	incl   -0x44(%ebp)
				ptr += PAGE_SIZE;
  801b97:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801b9e:	eb 2d                	jmp    801bcd <malloc+0x45e>
			} else {
				if (num_p <= count && min_sz > count) {
  801ba0:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801ba6:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801ba9:	77 14                	ja     801bbf <malloc+0x450>
  801bab:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801bae:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801bb1:	76 0c                	jbe    801bbf <malloc+0x450>

					min_sz = count;
  801bb3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801bb6:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801bb9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801bbc:	89 45 c4             	mov    %eax,-0x3c(%ebp)

				}
				count = 0;
  801bbf:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
				ptr += PAGE_SIZE;
  801bc6:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
			}

			if (i == size_uhmem - 1) {
  801bcd:	81 7d b8 ff ff 01 00 	cmpl   $0x1ffff,-0x48(%ebp)
  801bd4:	75 2d                	jne    801c03 <malloc+0x494>

				if (num_p <= count && min_sz > count) {
  801bd6:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801bdc:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801bdf:	77 22                	ja     801c03 <malloc+0x494>
  801be1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801be4:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801be7:	76 1a                	jbe    801c03 <malloc+0x494>

					min_sz = count;
  801be9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801bec:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801bef:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801bf2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
					count = 0;
  801bf5:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
					ptr += PAGE_SIZE;
  801bfc:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801c03:	ff 45 b8             	incl   -0x48(%ebp)
  801c06:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801c09:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801c0e:	0f 86 72 ff ff ff    	jbe    801b86 <malloc+0x417>

			}

		}

		if (num_p > min_sz || temp == 0) {
  801c14:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801c1a:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  801c1d:	77 06                	ja     801c25 <malloc+0x4b6>
  801c1f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801c23:	75 0a                	jne    801c2f <malloc+0x4c0>
			return NULL;
  801c25:	b8 00 00 00 00       	mov    $0x0,%eax
  801c2a:	e9 e0 04 00 00       	jmp    80210f <malloc+0x9a0>

		}

		temp = temp - (PAGE_SIZE * min_sz);
  801c2f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c32:	c1 e0 0c             	shl    $0xc,%eax
  801c35:	29 45 c4             	sub    %eax,-0x3c(%ebp)
		void* ret = (void*) temp;
  801c38:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801c3b:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)

		sys_allocateMem(temp, size);
  801c41:	83 ec 08             	sub    $0x8,%esp
  801c44:	ff 75 08             	pushl  0x8(%ebp)
  801c47:	ff 75 c4             	pushl  -0x3c(%ebp)
  801c4a:	e8 57 07 00 00       	call   8023a6 <sys_allocateMem>
  801c4f:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801c52:	a1 40 30 80 00       	mov    0x803040,%eax
  801c57:	8b 55 08             	mov    0x8(%ebp),%edx
  801c5a:	89 14 c5 64 30 88 00 	mov    %edx,0x883064(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801c61:	a1 40 30 80 00       	mov    0x803040,%eax
  801c66:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801c69:	89 14 c5 60 30 88 00 	mov    %edx,0x883060(,%eax,8)
		cnt_mem++;
  801c70:	a1 40 30 80 00       	mov    0x803040,%eax
  801c75:	40                   	inc    %eax
  801c76:	a3 40 30 80 00       	mov    %eax,0x803040
		i = 0;
  801c7b:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801c82:	eb 24                	jmp    801ca8 <malloc+0x539>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801c84:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801c87:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801c8c:	c1 e8 0c             	shr    $0xc,%eax
  801c8f:	c7 04 85 60 30 80 00 	movl   $0x1,0x803060(,%eax,4)
  801c96:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801c9a:	81 45 c4 00 10 00 00 	addl   $0x1000,-0x3c(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801ca1:	81 45 b8 00 10 00 00 	addl   $0x1000,-0x48(%ebp)
  801ca8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801cab:	3b 45 08             	cmp    0x8(%ebp),%eax
  801cae:	72 d4                	jb     801c84 <malloc+0x515>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801cb0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801cb6:	e9 54 04 00 00       	jmp    80210f <malloc+0x9a0>

	} else if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801cbb:	e8 d8 09 00 00       	call   802698 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801cc0:	85 c0                	test   %eax,%eax
  801cc2:	0f 84 88 01 00 00    	je     801e50 <malloc+0x6e1>

		size = ROUNDUP(size, PAGE_SIZE);
  801cc8:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  801ccf:	10 00 00 
  801cd2:	8b 55 08             	mov    0x8(%ebp),%edx
  801cd5:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  801cdb:	01 d0                	add    %edx,%eax
  801cdd:	48                   	dec    %eax
  801cde:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  801ce4:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801cea:	ba 00 00 00 00       	mov    $0x0,%edx
  801cef:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  801cf5:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801cfb:	29 d0                	sub    %edx,%eax
  801cfd:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801d00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d04:	74 09                	je     801d0f <malloc+0x5a0>
  801d06:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801d0d:	76 0a                	jbe    801d19 <malloc+0x5aa>
			return NULL;
  801d0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d14:	e9 f6 03 00 00       	jmp    80210f <malloc+0x9a0>
		}

		uint32 ptr = (uint32) USER_HEAP_START;
  801d19:	c7 45 b4 00 00 00 80 	movl   $0x80000000,-0x4c(%ebp)
		uint32 temp = 0;
  801d20:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
		uint32 found = 0;
  801d27:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		uint32 count = 0;
  801d2e:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
		int i = 0;
  801d35:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3f:	c1 e8 0c             	shr    $0xc,%eax
  801d42:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

		for (; i < size_uhmem; i++) {
  801d48:	eb 5a                	jmp    801da4 <malloc+0x635>

			if (heap_mem[i] == 0) {
  801d4a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801d4d:	8b 04 85 60 30 80 00 	mov    0x803060(,%eax,4),%eax
  801d54:	85 c0                	test   %eax,%eax
  801d56:	75 0c                	jne    801d64 <malloc+0x5f5>

				count++;
  801d58:	ff 45 a8             	incl   -0x58(%ebp)
				ptr += PAGE_SIZE;
  801d5b:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
  801d62:	eb 22                	jmp    801d86 <malloc+0x617>
			} else {
				if (num_p <= count) {
  801d64:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801d6a:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801d6d:	77 09                	ja     801d78 <malloc+0x609>

					found = 1;
  801d6f:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)

					break;
  801d76:	eb 36                	jmp    801dae <malloc+0x63f>
				}
				count = 0;
  801d78:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
				ptr += PAGE_SIZE;
  801d7f:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
			}

			if (i == size_uhmem - 1) {
  801d86:	81 7d a4 ff ff 01 00 	cmpl   $0x1ffff,-0x5c(%ebp)
  801d8d:	75 12                	jne    801da1 <malloc+0x632>

				if (num_p <= count) {
  801d8f:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801d95:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801d98:	77 07                	ja     801da1 <malloc+0x632>

					found = 1;
  801d9a:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
		uint32 found = 0;
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		for (; i < size_uhmem; i++) {
  801da1:	ff 45 a4             	incl   -0x5c(%ebp)
  801da4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801da7:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801dac:	76 9c                	jbe    801d4a <malloc+0x5db>

			}

		}

		if (!found) {
  801dae:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  801db2:	75 0a                	jne    801dbe <malloc+0x64f>
			return NULL;
  801db4:	b8 00 00 00 00       	mov    $0x0,%eax
  801db9:	e9 51 03 00 00       	jmp    80210f <malloc+0x9a0>

		}

		temp = ptr;
  801dbe:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801dc1:	89 45 b0             	mov    %eax,-0x50(%ebp)
		temp = temp - (PAGE_SIZE * count);
  801dc4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801dc7:	c1 e0 0c             	shl    $0xc,%eax
  801dca:	29 45 b0             	sub    %eax,-0x50(%ebp)
		void* ret = (void*) temp;
  801dcd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801dd0:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)

		sys_allocateMem(temp, size);
  801dd6:	83 ec 08             	sub    $0x8,%esp
  801dd9:	ff 75 08             	pushl  0x8(%ebp)
  801ddc:	ff 75 b0             	pushl  -0x50(%ebp)
  801ddf:	e8 c2 05 00 00       	call   8023a6 <sys_allocateMem>
  801de4:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801de7:	a1 40 30 80 00       	mov    0x803040,%eax
  801dec:	8b 55 08             	mov    0x8(%ebp),%edx
  801def:	89 14 c5 64 30 88 00 	mov    %edx,0x883064(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801df6:	a1 40 30 80 00       	mov    0x803040,%eax
  801dfb:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801dfe:	89 14 c5 60 30 88 00 	mov    %edx,0x883060(,%eax,8)
		cnt_mem++;
  801e05:	a1 40 30 80 00       	mov    0x803040,%eax
  801e0a:	40                   	inc    %eax
  801e0b:	a3 40 30 80 00       	mov    %eax,0x803040
		i = 0;
  801e10:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801e17:	eb 24                	jmp    801e3d <malloc+0x6ce>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801e19:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801e1c:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801e21:	c1 e8 0c             	shr    $0xc,%eax
  801e24:	c7 04 85 60 30 80 00 	movl   $0x1,0x803060(,%eax,4)
  801e2b:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801e2f:	81 45 b0 00 10 00 00 	addl   $0x1000,-0x50(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801e36:	81 45 a4 00 10 00 00 	addl   $0x1000,-0x5c(%ebp)
  801e3d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801e40:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e43:	72 d4                	jb     801e19 <malloc+0x6aa>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801e45:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  801e4b:	e9 bf 02 00 00       	jmp    80210f <malloc+0x9a0>

	}
	else if(sys_isUHeapPlacementStrategyWORSTFIT())
  801e50:	e8 d6 08 00 00       	call   80272b <sys_isUHeapPlacementStrategyWORSTFIT>
  801e55:	85 c0                	test   %eax,%eax
  801e57:	0f 84 ba 01 00 00    	je     802017 <malloc+0x8a8>
	{
		size = ROUNDUP(size, PAGE_SIZE);
  801e5d:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  801e64:	10 00 00 
  801e67:	8b 55 08             	mov    0x8(%ebp),%edx
  801e6a:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  801e70:	01 d0                	add    %edx,%eax
  801e72:	48                   	dec    %eax
  801e73:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  801e79:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  801e7f:	ba 00 00 00 00       	mov    $0x0,%edx
  801e84:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  801e8a:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  801e90:	29 d0                	sub    %edx,%eax
  801e92:	89 45 08             	mov    %eax,0x8(%ebp)

				if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801e95:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e99:	74 09                	je     801ea4 <malloc+0x735>
  801e9b:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801ea2:	76 0a                	jbe    801eae <malloc+0x73f>
					return NULL;
  801ea4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea9:	e9 61 02 00 00       	jmp    80210f <malloc+0x9a0>
				}
				uint32 ptr = (uint32) USER_HEAP_START;
  801eae:	c7 45 a0 00 00 00 80 	movl   $0x80000000,-0x60(%ebp)
				uint32 temp = 0;
  801eb5:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
				uint32 max_sz = -1;
  801ebc:	c7 45 98 ff ff ff ff 	movl   $0xffffffff,-0x68(%ebp)
				uint32 count = 0;
  801ec3:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
				int i = 0;
  801eca:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				uint32 num_p = size / PAGE_SIZE;
  801ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed4:	c1 e8 0c             	shr    $0xc,%eax
  801ed7:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  801edd:	e9 80 00 00 00       	jmp    801f62 <malloc+0x7f3>

					if (heap_mem[i] == 0) {
  801ee2:	8b 45 90             	mov    -0x70(%ebp),%eax
  801ee5:	8b 04 85 60 30 80 00 	mov    0x803060(,%eax,4),%eax
  801eec:	85 c0                	test   %eax,%eax
  801eee:	75 0c                	jne    801efc <malloc+0x78d>

						count++;
  801ef0:	ff 45 94             	incl   -0x6c(%ebp)
						ptr += PAGE_SIZE;
  801ef3:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
  801efa:	eb 2d                	jmp    801f29 <malloc+0x7ba>
					} else {
						if (num_p <= count && max_sz < count) {
  801efc:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801f02:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801f05:	77 14                	ja     801f1b <malloc+0x7ac>
  801f07:	8b 45 98             	mov    -0x68(%ebp),%eax
  801f0a:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801f0d:	73 0c                	jae    801f1b <malloc+0x7ac>

							max_sz = count;
  801f0f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801f12:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  801f15:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801f18:	89 45 9c             	mov    %eax,-0x64(%ebp)

						}
						count = 0;
  801f1b:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
						ptr += PAGE_SIZE;
  801f22:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
					}

					if (i == size_uhmem - 1) {
  801f29:	81 7d 90 ff ff 01 00 	cmpl   $0x1ffff,-0x70(%ebp)
  801f30:	75 2d                	jne    801f5f <malloc+0x7f0>

						if (num_p <= count && max_sz > count) {
  801f32:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801f38:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801f3b:	77 22                	ja     801f5f <malloc+0x7f0>
  801f3d:	8b 45 98             	mov    -0x68(%ebp),%eax
  801f40:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801f43:	76 1a                	jbe    801f5f <malloc+0x7f0>

							max_sz = count;
  801f45:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801f48:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  801f4b:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801f4e:	89 45 9c             	mov    %eax,-0x64(%ebp)
							count = 0;
  801f51:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
							ptr += PAGE_SIZE;
  801f58:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
				uint32 count = 0;
				int i = 0;
				uint32 num_p = size / PAGE_SIZE;

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  801f5f:	ff 45 90             	incl   -0x70(%ebp)
  801f62:	8b 45 90             	mov    -0x70(%ebp),%eax
  801f65:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801f6a:	0f 86 72 ff ff ff    	jbe    801ee2 <malloc+0x773>

					}

				}

				if (num_p > max_sz || temp == 0) {
  801f70:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801f76:	3b 45 98             	cmp    -0x68(%ebp),%eax
  801f79:	77 06                	ja     801f81 <malloc+0x812>
  801f7b:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  801f7f:	75 0a                	jne    801f8b <malloc+0x81c>
					return NULL;
  801f81:	b8 00 00 00 00       	mov    $0x0,%eax
  801f86:	e9 84 01 00 00       	jmp    80210f <malloc+0x9a0>

				}

				temp = temp - (PAGE_SIZE * max_sz);
  801f8b:	8b 45 98             	mov    -0x68(%ebp),%eax
  801f8e:	c1 e0 0c             	shl    $0xc,%eax
  801f91:	29 45 9c             	sub    %eax,-0x64(%ebp)
				void* ret = (void*) temp;
  801f94:	8b 45 9c             	mov    -0x64(%ebp),%eax
  801f97:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

				sys_allocateMem(temp, size);
  801f9d:	83 ec 08             	sub    $0x8,%esp
  801fa0:	ff 75 08             	pushl  0x8(%ebp)
  801fa3:	ff 75 9c             	pushl  -0x64(%ebp)
  801fa6:	e8 fb 03 00 00       	call   8023a6 <sys_allocateMem>
  801fab:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  801fae:	a1 40 30 80 00       	mov    0x803040,%eax
  801fb3:	8b 55 08             	mov    0x8(%ebp),%edx
  801fb6:	89 14 c5 64 30 88 00 	mov    %edx,0x883064(,%eax,8)
				heap_size[cnt_mem].vir = (void*) temp;
  801fbd:	a1 40 30 80 00       	mov    0x803040,%eax
  801fc2:	8b 55 9c             	mov    -0x64(%ebp),%edx
  801fc5:	89 14 c5 60 30 88 00 	mov    %edx,0x883060(,%eax,8)
				cnt_mem++;
  801fcc:	a1 40 30 80 00       	mov    0x803040,%eax
  801fd1:	40                   	inc    %eax
  801fd2:	a3 40 30 80 00       	mov    %eax,0x803040
				i = 0;
  801fd7:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801fde:	eb 24                	jmp    802004 <malloc+0x895>
				{

					heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801fe0:	8b 45 9c             	mov    -0x64(%ebp),%eax
  801fe3:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  801fe8:	c1 e8 0c             	shr    $0xc,%eax
  801feb:	c7 04 85 60 30 80 00 	movl   $0x1,0x803060(,%eax,4)
  801ff2:	01 00 00 00 

					temp += (uint32) PAGE_SIZE;
  801ff6:	81 45 9c 00 10 00 00 	addl   $0x1000,-0x64(%ebp)
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) temp;
				cnt_mem++;
				i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801ffd:	81 45 90 00 10 00 00 	addl   $0x1000,-0x70(%ebp)
  802004:	8b 45 90             	mov    -0x70(%ebp),%eax
  802007:	3b 45 08             	cmp    0x8(%ebp),%eax
  80200a:	72 d4                	jb     801fe0 <malloc+0x871>

					temp += (uint32) PAGE_SIZE;
				}

				//cprintf("\n size = %d.........vir= %d  \n",num_p,((uint32) ret-USER_HEAP_START)/PAGE_SIZE);
				return ret;
  80200c:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  802012:	e9 f8 00 00 00       	jmp    80210f <malloc+0x9a0>

	}
// this is to make malloc is work
	void* ret = NULL;
  802017:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
	size = ROUNDUP(size, PAGE_SIZE);
  80201e:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  802025:	10 00 00 
  802028:	8b 55 08             	mov    0x8(%ebp),%edx
  80202b:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  802031:	01 d0                	add    %edx,%eax
  802033:	48                   	dec    %eax
  802034:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  80203a:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  802040:	ba 00 00 00 00       	mov    $0x0,%edx
  802045:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  80204b:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  802051:	29 d0                	sub    %edx,%eax
  802053:	89 45 08             	mov    %eax,0x8(%ebp)

	if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  802056:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80205a:	74 09                	je     802065 <malloc+0x8f6>
  80205c:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  802063:	76 0a                	jbe    80206f <malloc+0x900>
		return NULL;
  802065:	b8 00 00 00 00       	mov    $0x0,%eax
  80206a:	e9 a0 00 00 00       	jmp    80210f <malloc+0x9a0>
	}

	if (ptr_uheap + size <= (uint32) USER_HEAP_MAX) {
  80206f:	8b 15 04 30 80 00    	mov    0x803004,%edx
  802075:	8b 45 08             	mov    0x8(%ebp),%eax
  802078:	01 d0                	add    %edx,%eax
  80207a:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80207f:	0f 87 87 00 00 00    	ja     80210c <malloc+0x99d>

		ret = (void *) ptr_uheap;
  802085:	a1 04 30 80 00       	mov    0x803004,%eax
  80208a:	89 45 8c             	mov    %eax,-0x74(%ebp)
		sys_allocateMem(ptr_uheap, size);
  80208d:	a1 04 30 80 00       	mov    0x803004,%eax
  802092:	83 ec 08             	sub    $0x8,%esp
  802095:	ff 75 08             	pushl  0x8(%ebp)
  802098:	50                   	push   %eax
  802099:	e8 08 03 00 00       	call   8023a6 <sys_allocateMem>
  80209e:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  8020a1:	a1 40 30 80 00       	mov    0x803040,%eax
  8020a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8020a9:	89 14 c5 64 30 88 00 	mov    %edx,0x883064(,%eax,8)
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8020b0:	a1 40 30 80 00       	mov    0x803040,%eax
  8020b5:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8020bb:	89 14 c5 60 30 88 00 	mov    %edx,0x883060(,%eax,8)
		cnt_mem++;
  8020c2:	a1 40 30 80 00       	mov    0x803040,%eax
  8020c7:	40                   	inc    %eax
  8020c8:	a3 40 30 80 00       	mov    %eax,0x803040
		int i = 0;
  8020cd:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)

		for (; i < size; i += PAGE_SIZE)
  8020d4:	eb 2e                	jmp    802104 <malloc+0x995>
		{

			heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8020d6:	a1 04 30 80 00       	mov    0x803004,%eax
  8020db:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  8020e0:	c1 e8 0c             	shr    $0xc,%eax
  8020e3:	c7 04 85 60 30 80 00 	movl   $0x1,0x803060(,%eax,4)
  8020ea:	01 00 00 00 

			ptr_uheap += (uint32) PAGE_SIZE;
  8020ee:	a1 04 30 80 00       	mov    0x803004,%eax
  8020f3:	05 00 10 00 00       	add    $0x1000,%eax
  8020f8:	a3 04 30 80 00       	mov    %eax,0x803004
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
		cnt_mem++;
		int i = 0;

		for (; i < size; i += PAGE_SIZE)
  8020fd:	81 45 88 00 10 00 00 	addl   $0x1000,-0x78(%ebp)
  802104:	8b 45 88             	mov    -0x78(%ebp),%eax
  802107:	3b 45 08             	cmp    0x8(%ebp),%eax
  80210a:	72 ca                	jb     8020d6 <malloc+0x967>
					/ (uint32) PAGE_SIZE)] = 1;

			ptr_uheap += (uint32) PAGE_SIZE;
		}
	}
	return ret;
  80210c:	8b 45 8c             	mov    -0x74(%ebp),%eax

	//TODO: [PROJECT 2016 - BONUS2] Apply FIRST FIT and WORST FIT policies

//return 0;

}
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <free>:
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address) {
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
  802114:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
  802117:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; inx < cnt_mem; inx++) {
  80211e:	e9 c1 00 00 00       	jmp    8021e4 <free+0xd3>
		if (heap_size[inx].vir == virtual_address) {
  802123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802126:	8b 04 c5 60 30 88 00 	mov    0x883060(,%eax,8),%eax
  80212d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802130:	0f 85 ab 00 00 00    	jne    8021e1 <free+0xd0>

			if (heap_size[inx].size == 0) {
  802136:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802139:	8b 04 c5 64 30 88 00 	mov    0x883064(,%eax,8),%eax
  802140:	85 c0                	test   %eax,%eax
  802142:	75 21                	jne    802165 <free+0x54>
				heap_size[inx].size = 0;
  802144:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802147:	c7 04 c5 64 30 88 00 	movl   $0x0,0x883064(,%eax,8)
  80214e:	00 00 00 00 
				heap_size[inx].vir = NULL;
  802152:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802155:	c7 04 c5 60 30 88 00 	movl   $0x0,0x883060(,%eax,8)
  80215c:	00 00 00 00 
				return;
  802160:	e9 8d 00 00 00       	jmp    8021f2 <free+0xe1>

			}

			sys_freeMem((uint32) virtual_address, heap_size[inx].size);
  802165:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802168:	8b 14 c5 64 30 88 00 	mov    0x883064(,%eax,8),%edx
  80216f:	8b 45 08             	mov    0x8(%ebp),%eax
  802172:	83 ec 08             	sub    $0x8,%esp
  802175:	52                   	push   %edx
  802176:	50                   	push   %eax
  802177:	e8 0e 02 00 00       	call   80238a <sys_freeMem>
  80217c:	83 c4 10             	add    $0x10,%esp

			int i = 0;
  80217f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
  802186:	8b 45 08             	mov    0x8(%ebp),%eax
  802189:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  80218c:	eb 24                	jmp    8021b2 <free+0xa1>
			{
				heap_mem[(int) (((uint32) va - USER_HEAP_START) / PAGE_SIZE)] =
  80218e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802191:	05 00 00 00 80       	add    $0x80000000,%eax
  802196:	c1 e8 0c             	shr    $0xc,%eax
  802199:	c7 04 85 60 30 80 00 	movl   $0x0,0x803060(,%eax,4)
  8021a0:	00 00 00 00 
						0;

				va += PAGE_SIZE;
  8021a4:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
			sys_freeMem((uint32) virtual_address, heap_size[inx].size);

			int i = 0;
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  8021ab:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  8021b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b5:	8b 14 c5 64 30 88 00 	mov    0x883064(,%eax,8),%edx
  8021bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021bf:	39 c2                	cmp    %eax,%edx
  8021c1:	77 cb                	ja     80218e <free+0x7d>

				va += PAGE_SIZE;

			}

			heap_size[inx].size = 0;
  8021c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c6:	c7 04 c5 64 30 88 00 	movl   $0x0,0x883064(,%eax,8)
  8021cd:	00 00 00 00 
			heap_size[inx].vir = NULL;
  8021d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d4:	c7 04 c5 60 30 88 00 	movl   $0x0,0x883060(,%eax,8)
  8021db:	00 00 00 00 
			break;
  8021df:	eb 11                	jmp    8021f2 <free+0xe1>
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
	for (; inx < cnt_mem; inx++) {
  8021e1:	ff 45 f4             	incl   -0xc(%ebp)
  8021e4:	a1 40 30 80 00       	mov    0x803040,%eax
  8021e9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  8021ec:	0f 8c 31 ff ff ff    	jl     802123 <free+0x12>
	}

	//get the size of the given allocation using its address
	//you need to call sys_freeMem()

}
  8021f2:	c9                   	leave  
  8021f3:	c3                   	ret    

008021f4 <realloc>:
//  Hint: you may need to use the sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size) {
  8021f4:	55                   	push   %ebp
  8021f5:	89 e5                	mov    %esp,%ebp
  8021f7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2016 - BONUS4] realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8021fa:	83 ec 04             	sub    $0x4,%esp
  8021fd:	68 a4 2f 80 00       	push   $0x802fa4
  802202:	68 1c 02 00 00       	push   $0x21c
  802207:	68 ca 2f 80 00       	push   $0x802fca
  80220c:	e8 aa e4 ff ff       	call   8006bb <_panic>

00802211 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802211:	55                   	push   %ebp
  802212:	89 e5                	mov    %esp,%ebp
  802214:	57                   	push   %edi
  802215:	56                   	push   %esi
  802216:	53                   	push   %ebx
  802217:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80221a:	8b 45 08             	mov    0x8(%ebp),%eax
  80221d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802220:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802223:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802226:	8b 7d 18             	mov    0x18(%ebp),%edi
  802229:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80222c:	cd 30                	int    $0x30
  80222e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802231:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802234:	83 c4 10             	add    $0x10,%esp
  802237:	5b                   	pop    %ebx
  802238:	5e                   	pop    %esi
  802239:	5f                   	pop    %edi
  80223a:	5d                   	pop    %ebp
  80223b:	c3                   	ret    

0080223c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  80223c:	55                   	push   %ebp
  80223d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  80223f:	8b 45 08             	mov    0x8(%ebp),%eax
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	ff 75 0c             	pushl  0xc(%ebp)
  80224b:	50                   	push   %eax
  80224c:	6a 00                	push   $0x0
  80224e:	e8 be ff ff ff       	call   802211 <syscall>
  802253:	83 c4 18             	add    $0x18,%esp
}
  802256:	90                   	nop
  802257:	c9                   	leave  
  802258:	c3                   	ret    

00802259 <sys_cgetc>:

int
sys_cgetc(void)
{
  802259:	55                   	push   %ebp
  80225a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 01                	push   $0x1
  802268:	e8 a4 ff ff ff       	call   802211 <syscall>
  80226d:	83 c4 18             	add    $0x18,%esp
}
  802270:	c9                   	leave  
  802271:	c3                   	ret    

00802272 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  802272:	55                   	push   %ebp
  802273:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  802275:	8b 45 08             	mov    0x8(%ebp),%eax
  802278:	6a 00                	push   $0x0
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	50                   	push   %eax
  802281:	6a 03                	push   $0x3
  802283:	e8 89 ff ff ff       	call   802211 <syscall>
  802288:	83 c4 18             	add    $0x18,%esp
}
  80228b:	c9                   	leave  
  80228c:	c3                   	ret    

0080228d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80228d:	55                   	push   %ebp
  80228e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802290:	6a 00                	push   $0x0
  802292:	6a 00                	push   $0x0
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 02                	push   $0x2
  80229c:	e8 70 ff ff ff       	call   802211 <syscall>
  8022a1:	83 c4 18             	add    $0x18,%esp
}
  8022a4:	c9                   	leave  
  8022a5:	c3                   	ret    

008022a6 <sys_env_exit>:

void sys_env_exit(void)
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 00                	push   $0x0
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 04                	push   $0x4
  8022b5:	e8 57 ff ff ff       	call   802211 <syscall>
  8022ba:	83 c4 18             	add    $0x18,%esp
}
  8022bd:	90                   	nop
  8022be:	c9                   	leave  
  8022bf:	c3                   	ret    

008022c0 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8022c0:	55                   	push   %ebp
  8022c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8022c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	6a 00                	push   $0x0
  8022cf:	52                   	push   %edx
  8022d0:	50                   	push   %eax
  8022d1:	6a 05                	push   $0x5
  8022d3:	e8 39 ff ff ff       	call   802211 <syscall>
  8022d8:	83 c4 18             	add    $0x18,%esp
}
  8022db:	c9                   	leave  
  8022dc:	c3                   	ret    

008022dd <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8022dd:	55                   	push   %ebp
  8022de:	89 e5                	mov    %esp,%ebp
  8022e0:	56                   	push   %esi
  8022e1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8022e2:	8b 75 18             	mov    0x18(%ebp),%esi
  8022e5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f1:	56                   	push   %esi
  8022f2:	53                   	push   %ebx
  8022f3:	51                   	push   %ecx
  8022f4:	52                   	push   %edx
  8022f5:	50                   	push   %eax
  8022f6:	6a 06                	push   $0x6
  8022f8:	e8 14 ff ff ff       	call   802211 <syscall>
  8022fd:	83 c4 18             	add    $0x18,%esp
}
  802300:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802303:	5b                   	pop    %ebx
  802304:	5e                   	pop    %esi
  802305:	5d                   	pop    %ebp
  802306:	c3                   	ret    

00802307 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802307:	55                   	push   %ebp
  802308:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80230a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80230d:	8b 45 08             	mov    0x8(%ebp),%eax
  802310:	6a 00                	push   $0x0
  802312:	6a 00                	push   $0x0
  802314:	6a 00                	push   $0x0
  802316:	52                   	push   %edx
  802317:	50                   	push   %eax
  802318:	6a 07                	push   $0x7
  80231a:	e8 f2 fe ff ff       	call   802211 <syscall>
  80231f:	83 c4 18             	add    $0x18,%esp
}
  802322:	c9                   	leave  
  802323:	c3                   	ret    

00802324 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802324:	55                   	push   %ebp
  802325:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802327:	6a 00                	push   $0x0
  802329:	6a 00                	push   $0x0
  80232b:	6a 00                	push   $0x0
  80232d:	ff 75 0c             	pushl  0xc(%ebp)
  802330:	ff 75 08             	pushl  0x8(%ebp)
  802333:	6a 08                	push   $0x8
  802335:	e8 d7 fe ff ff       	call   802211 <syscall>
  80233a:	83 c4 18             	add    $0x18,%esp
}
  80233d:	c9                   	leave  
  80233e:	c3                   	ret    

0080233f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80233f:	55                   	push   %ebp
  802340:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	6a 00                	push   $0x0
  802348:	6a 00                	push   $0x0
  80234a:	6a 00                	push   $0x0
  80234c:	6a 09                	push   $0x9
  80234e:	e8 be fe ff ff       	call   802211 <syscall>
  802353:	83 c4 18             	add    $0x18,%esp
}
  802356:	c9                   	leave  
  802357:	c3                   	ret    

00802358 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802358:	55                   	push   %ebp
  802359:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80235b:	6a 00                	push   $0x0
  80235d:	6a 00                	push   $0x0
  80235f:	6a 00                	push   $0x0
  802361:	6a 00                	push   $0x0
  802363:	6a 00                	push   $0x0
  802365:	6a 0a                	push   $0xa
  802367:	e8 a5 fe ff ff       	call   802211 <syscall>
  80236c:	83 c4 18             	add    $0x18,%esp
}
  80236f:	c9                   	leave  
  802370:	c3                   	ret    

00802371 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802371:	55                   	push   %ebp
  802372:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802374:	6a 00                	push   $0x0
  802376:	6a 00                	push   $0x0
  802378:	6a 00                	push   $0x0
  80237a:	6a 00                	push   $0x0
  80237c:	6a 00                	push   $0x0
  80237e:	6a 0b                	push   $0xb
  802380:	e8 8c fe ff ff       	call   802211 <syscall>
  802385:	83 c4 18             	add    $0x18,%esp
}
  802388:	c9                   	leave  
  802389:	c3                   	ret    

0080238a <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  80238a:	55                   	push   %ebp
  80238b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  80238d:	6a 00                	push   $0x0
  80238f:	6a 00                	push   $0x0
  802391:	6a 00                	push   $0x0
  802393:	ff 75 0c             	pushl  0xc(%ebp)
  802396:	ff 75 08             	pushl  0x8(%ebp)
  802399:	6a 0d                	push   $0xd
  80239b:	e8 71 fe ff ff       	call   802211 <syscall>
  8023a0:	83 c4 18             	add    $0x18,%esp
	return;
  8023a3:	90                   	nop
}
  8023a4:	c9                   	leave  
  8023a5:	c3                   	ret    

008023a6 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8023a6:	55                   	push   %ebp
  8023a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	ff 75 0c             	pushl  0xc(%ebp)
  8023b2:	ff 75 08             	pushl  0x8(%ebp)
  8023b5:	6a 0e                	push   $0xe
  8023b7:	e8 55 fe ff ff       	call   802211 <syscall>
  8023bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8023bf:	90                   	nop
}
  8023c0:	c9                   	leave  
  8023c1:	c3                   	ret    

008023c2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8023c2:	55                   	push   %ebp
  8023c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8023c5:	6a 00                	push   $0x0
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 00                	push   $0x0
  8023cb:	6a 00                	push   $0x0
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 0c                	push   $0xc
  8023d1:	e8 3b fe ff ff       	call   802211 <syscall>
  8023d6:	83 c4 18             	add    $0x18,%esp
}
  8023d9:	c9                   	leave  
  8023da:	c3                   	ret    

008023db <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8023db:	55                   	push   %ebp
  8023dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 00                	push   $0x0
  8023e8:	6a 10                	push   $0x10
  8023ea:	e8 22 fe ff ff       	call   802211 <syscall>
  8023ef:	83 c4 18             	add    $0x18,%esp
}
  8023f2:	90                   	nop
  8023f3:	c9                   	leave  
  8023f4:	c3                   	ret    

008023f5 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8023f5:	55                   	push   %ebp
  8023f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	6a 11                	push   $0x11
  802404:	e8 08 fe ff ff       	call   802211 <syscall>
  802409:	83 c4 18             	add    $0x18,%esp
}
  80240c:	90                   	nop
  80240d:	c9                   	leave  
  80240e:	c3                   	ret    

0080240f <sys_cputc>:


void
sys_cputc(const char c)
{
  80240f:	55                   	push   %ebp
  802410:	89 e5                	mov    %esp,%ebp
  802412:	83 ec 04             	sub    $0x4,%esp
  802415:	8b 45 08             	mov    0x8(%ebp),%eax
  802418:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80241b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80241f:	6a 00                	push   $0x0
  802421:	6a 00                	push   $0x0
  802423:	6a 00                	push   $0x0
  802425:	6a 00                	push   $0x0
  802427:	50                   	push   %eax
  802428:	6a 12                	push   $0x12
  80242a:	e8 e2 fd ff ff       	call   802211 <syscall>
  80242f:	83 c4 18             	add    $0x18,%esp
}
  802432:	90                   	nop
  802433:	c9                   	leave  
  802434:	c3                   	ret    

00802435 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802435:	55                   	push   %ebp
  802436:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802438:	6a 00                	push   $0x0
  80243a:	6a 00                	push   $0x0
  80243c:	6a 00                	push   $0x0
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	6a 13                	push   $0x13
  802444:	e8 c8 fd ff ff       	call   802211 <syscall>
  802449:	83 c4 18             	add    $0x18,%esp
}
  80244c:	90                   	nop
  80244d:	c9                   	leave  
  80244e:	c3                   	ret    

0080244f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80244f:	55                   	push   %ebp
  802450:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802452:	8b 45 08             	mov    0x8(%ebp),%eax
  802455:	6a 00                	push   $0x0
  802457:	6a 00                	push   $0x0
  802459:	6a 00                	push   $0x0
  80245b:	ff 75 0c             	pushl  0xc(%ebp)
  80245e:	50                   	push   %eax
  80245f:	6a 14                	push   $0x14
  802461:	e8 ab fd ff ff       	call   802211 <syscall>
  802466:	83 c4 18             	add    $0x18,%esp
}
  802469:	c9                   	leave  
  80246a:	c3                   	ret    

0080246b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  80246b:	55                   	push   %ebp
  80246c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  80246e:	8b 45 08             	mov    0x8(%ebp),%eax
  802471:	6a 00                	push   $0x0
  802473:	6a 00                	push   $0x0
  802475:	6a 00                	push   $0x0
  802477:	6a 00                	push   $0x0
  802479:	50                   	push   %eax
  80247a:	6a 17                	push   $0x17
  80247c:	e8 90 fd ff ff       	call   802211 <syscall>
  802481:	83 c4 18             	add    $0x18,%esp
}
  802484:	c9                   	leave  
  802485:	c3                   	ret    

00802486 <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  802486:	55                   	push   %ebp
  802487:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  802489:	8b 45 08             	mov    0x8(%ebp),%eax
  80248c:	6a 00                	push   $0x0
  80248e:	6a 00                	push   $0x0
  802490:	6a 00                	push   $0x0
  802492:	6a 00                	push   $0x0
  802494:	50                   	push   %eax
  802495:	6a 15                	push   $0x15
  802497:	e8 75 fd ff ff       	call   802211 <syscall>
  80249c:	83 c4 18             	add    $0x18,%esp
}
  80249f:	90                   	nop
  8024a0:	c9                   	leave  
  8024a1:	c3                   	ret    

008024a2 <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  8024a2:	55                   	push   %ebp
  8024a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  8024a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a8:	6a 00                	push   $0x0
  8024aa:	6a 00                	push   $0x0
  8024ac:	6a 00                	push   $0x0
  8024ae:	6a 00                	push   $0x0
  8024b0:	50                   	push   %eax
  8024b1:	6a 16                	push   $0x16
  8024b3:	e8 59 fd ff ff       	call   802211 <syscall>
  8024b8:	83 c4 18             	add    $0x18,%esp
}
  8024bb:	90                   	nop
  8024bc:	c9                   	leave  
  8024bd:	c3                   	ret    

008024be <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  8024be:	55                   	push   %ebp
  8024bf:	89 e5                	mov    %esp,%ebp
  8024c1:	83 ec 04             	sub    $0x4,%esp
  8024c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8024c7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  8024ca:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8024cd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8024d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d4:	6a 00                	push   $0x0
  8024d6:	51                   	push   %ecx
  8024d7:	52                   	push   %edx
  8024d8:	ff 75 0c             	pushl  0xc(%ebp)
  8024db:	50                   	push   %eax
  8024dc:	6a 18                	push   $0x18
  8024de:	e8 2e fd ff ff       	call   802211 <syscall>
  8024e3:	83 c4 18             	add    $0x18,%esp
}
  8024e6:	c9                   	leave  
  8024e7:	c3                   	ret    

008024e8 <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  8024e8:	55                   	push   %ebp
  8024e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  8024eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f1:	6a 00                	push   $0x0
  8024f3:	6a 00                	push   $0x0
  8024f5:	6a 00                	push   $0x0
  8024f7:	52                   	push   %edx
  8024f8:	50                   	push   %eax
  8024f9:	6a 19                	push   $0x19
  8024fb:	e8 11 fd ff ff       	call   802211 <syscall>
  802500:	83 c4 18             	add    $0x18,%esp
}
  802503:	c9                   	leave  
  802504:	c3                   	ret    

00802505 <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  802505:	55                   	push   %ebp
  802506:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  802508:	8b 45 08             	mov    0x8(%ebp),%eax
  80250b:	6a 00                	push   $0x0
  80250d:	6a 00                	push   $0x0
  80250f:	6a 00                	push   $0x0
  802511:	6a 00                	push   $0x0
  802513:	50                   	push   %eax
  802514:	6a 1a                	push   $0x1a
  802516:	e8 f6 fc ff ff       	call   802211 <syscall>
  80251b:	83 c4 18             	add    $0x18,%esp
}
  80251e:	c9                   	leave  
  80251f:	c3                   	ret    

00802520 <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  802520:	55                   	push   %ebp
  802521:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  802523:	6a 00                	push   $0x0
  802525:	6a 00                	push   $0x0
  802527:	6a 00                	push   $0x0
  802529:	6a 00                	push   $0x0
  80252b:	6a 00                	push   $0x0
  80252d:	6a 1b                	push   $0x1b
  80252f:	e8 dd fc ff ff       	call   802211 <syscall>
  802534:	83 c4 18             	add    $0x18,%esp
}
  802537:	c9                   	leave  
  802538:	c3                   	ret    

00802539 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802539:	55                   	push   %ebp
  80253a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80253c:	6a 00                	push   $0x0
  80253e:	6a 00                	push   $0x0
  802540:	6a 00                	push   $0x0
  802542:	6a 00                	push   $0x0
  802544:	6a 00                	push   $0x0
  802546:	6a 1c                	push   $0x1c
  802548:	e8 c4 fc ff ff       	call   802211 <syscall>
  80254d:	83 c4 18             	add    $0x18,%esp
}
  802550:	c9                   	leave  
  802551:	c3                   	ret    

00802552 <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  802552:	55                   	push   %ebp
  802553:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  802555:	8b 45 08             	mov    0x8(%ebp),%eax
  802558:	6a 00                	push   $0x0
  80255a:	6a 00                	push   $0x0
  80255c:	6a 00                	push   $0x0
  80255e:	ff 75 0c             	pushl  0xc(%ebp)
  802561:	50                   	push   %eax
  802562:	6a 1d                	push   $0x1d
  802564:	e8 a8 fc ff ff       	call   802211 <syscall>
  802569:	83 c4 18             	add    $0x18,%esp
}
  80256c:	c9                   	leave  
  80256d:	c3                   	ret    

0080256e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80256e:	55                   	push   %ebp
  80256f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802571:	8b 45 08             	mov    0x8(%ebp),%eax
  802574:	6a 00                	push   $0x0
  802576:	6a 00                	push   $0x0
  802578:	6a 00                	push   $0x0
  80257a:	6a 00                	push   $0x0
  80257c:	50                   	push   %eax
  80257d:	6a 1e                	push   $0x1e
  80257f:	e8 8d fc ff ff       	call   802211 <syscall>
  802584:	83 c4 18             	add    $0x18,%esp
}
  802587:	90                   	nop
  802588:	c9                   	leave  
  802589:	c3                   	ret    

0080258a <sys_free_env>:

void
sys_free_env(int32 envId)
{
  80258a:	55                   	push   %ebp
  80258b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  80258d:	8b 45 08             	mov    0x8(%ebp),%eax
  802590:	6a 00                	push   $0x0
  802592:	6a 00                	push   $0x0
  802594:	6a 00                	push   $0x0
  802596:	6a 00                	push   $0x0
  802598:	50                   	push   %eax
  802599:	6a 1f                	push   $0x1f
  80259b:	e8 71 fc ff ff       	call   802211 <syscall>
  8025a0:	83 c4 18             	add    $0x18,%esp
}
  8025a3:	90                   	nop
  8025a4:	c9                   	leave  
  8025a5:	c3                   	ret    

008025a6 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8025a6:	55                   	push   %ebp
  8025a7:	89 e5                	mov    %esp,%ebp
  8025a9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8025ac:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8025af:	8d 50 04             	lea    0x4(%eax),%edx
  8025b2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8025b5:	6a 00                	push   $0x0
  8025b7:	6a 00                	push   $0x0
  8025b9:	6a 00                	push   $0x0
  8025bb:	52                   	push   %edx
  8025bc:	50                   	push   %eax
  8025bd:	6a 20                	push   $0x20
  8025bf:	e8 4d fc ff ff       	call   802211 <syscall>
  8025c4:	83 c4 18             	add    $0x18,%esp
	return result;
  8025c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8025d0:	89 01                	mov    %eax,(%ecx)
  8025d2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8025d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d8:	c9                   	leave  
  8025d9:	c2 04 00             	ret    $0x4

008025dc <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8025dc:	55                   	push   %ebp
  8025dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8025df:	6a 00                	push   $0x0
  8025e1:	6a 00                	push   $0x0
  8025e3:	ff 75 10             	pushl  0x10(%ebp)
  8025e6:	ff 75 0c             	pushl  0xc(%ebp)
  8025e9:	ff 75 08             	pushl  0x8(%ebp)
  8025ec:	6a 0f                	push   $0xf
  8025ee:	e8 1e fc ff ff       	call   802211 <syscall>
  8025f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8025f6:	90                   	nop
}
  8025f7:	c9                   	leave  
  8025f8:	c3                   	ret    

008025f9 <sys_rcr2>:
uint32 sys_rcr2()
{
  8025f9:	55                   	push   %ebp
  8025fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8025fc:	6a 00                	push   $0x0
  8025fe:	6a 00                	push   $0x0
  802600:	6a 00                	push   $0x0
  802602:	6a 00                	push   $0x0
  802604:	6a 00                	push   $0x0
  802606:	6a 21                	push   $0x21
  802608:	e8 04 fc ff ff       	call   802211 <syscall>
  80260d:	83 c4 18             	add    $0x18,%esp
}
  802610:	c9                   	leave  
  802611:	c3                   	ret    

00802612 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802612:	55                   	push   %ebp
  802613:	89 e5                	mov    %esp,%ebp
  802615:	83 ec 04             	sub    $0x4,%esp
  802618:	8b 45 08             	mov    0x8(%ebp),%eax
  80261b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80261e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802622:	6a 00                	push   $0x0
  802624:	6a 00                	push   $0x0
  802626:	6a 00                	push   $0x0
  802628:	6a 00                	push   $0x0
  80262a:	50                   	push   %eax
  80262b:	6a 22                	push   $0x22
  80262d:	e8 df fb ff ff       	call   802211 <syscall>
  802632:	83 c4 18             	add    $0x18,%esp
	return ;
  802635:	90                   	nop
}
  802636:	c9                   	leave  
  802637:	c3                   	ret    

00802638 <rsttst>:
void rsttst()
{
  802638:	55                   	push   %ebp
  802639:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80263b:	6a 00                	push   $0x0
  80263d:	6a 00                	push   $0x0
  80263f:	6a 00                	push   $0x0
  802641:	6a 00                	push   $0x0
  802643:	6a 00                	push   $0x0
  802645:	6a 24                	push   $0x24
  802647:	e8 c5 fb ff ff       	call   802211 <syscall>
  80264c:	83 c4 18             	add    $0x18,%esp
	return ;
  80264f:	90                   	nop
}
  802650:	c9                   	leave  
  802651:	c3                   	ret    

00802652 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802652:	55                   	push   %ebp
  802653:	89 e5                	mov    %esp,%ebp
  802655:	83 ec 04             	sub    $0x4,%esp
  802658:	8b 45 14             	mov    0x14(%ebp),%eax
  80265b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80265e:	8b 55 18             	mov    0x18(%ebp),%edx
  802661:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802665:	52                   	push   %edx
  802666:	50                   	push   %eax
  802667:	ff 75 10             	pushl  0x10(%ebp)
  80266a:	ff 75 0c             	pushl  0xc(%ebp)
  80266d:	ff 75 08             	pushl  0x8(%ebp)
  802670:	6a 23                	push   $0x23
  802672:	e8 9a fb ff ff       	call   802211 <syscall>
  802677:	83 c4 18             	add    $0x18,%esp
	return ;
  80267a:	90                   	nop
}
  80267b:	c9                   	leave  
  80267c:	c3                   	ret    

0080267d <chktst>:
void chktst(uint32 n)
{
  80267d:	55                   	push   %ebp
  80267e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802680:	6a 00                	push   $0x0
  802682:	6a 00                	push   $0x0
  802684:	6a 00                	push   $0x0
  802686:	6a 00                	push   $0x0
  802688:	ff 75 08             	pushl  0x8(%ebp)
  80268b:	6a 25                	push   $0x25
  80268d:	e8 7f fb ff ff       	call   802211 <syscall>
  802692:	83 c4 18             	add    $0x18,%esp
	return ;
  802695:	90                   	nop
}
  802696:	c9                   	leave  
  802697:	c3                   	ret    

00802698 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802698:	55                   	push   %ebp
  802699:	89 e5                	mov    %esp,%ebp
  80269b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80269e:	6a 00                	push   $0x0
  8026a0:	6a 00                	push   $0x0
  8026a2:	6a 00                	push   $0x0
  8026a4:	6a 00                	push   $0x0
  8026a6:	6a 00                	push   $0x0
  8026a8:	6a 26                	push   $0x26
  8026aa:	e8 62 fb ff ff       	call   802211 <syscall>
  8026af:	83 c4 18             	add    $0x18,%esp
  8026b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8026b5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8026b9:	75 07                	jne    8026c2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8026bb:	b8 01 00 00 00       	mov    $0x1,%eax
  8026c0:	eb 05                	jmp    8026c7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8026c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026c7:	c9                   	leave  
  8026c8:	c3                   	ret    

008026c9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8026c9:	55                   	push   %ebp
  8026ca:	89 e5                	mov    %esp,%ebp
  8026cc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026cf:	6a 00                	push   $0x0
  8026d1:	6a 00                	push   $0x0
  8026d3:	6a 00                	push   $0x0
  8026d5:	6a 00                	push   $0x0
  8026d7:	6a 00                	push   $0x0
  8026d9:	6a 26                	push   $0x26
  8026db:	e8 31 fb ff ff       	call   802211 <syscall>
  8026e0:	83 c4 18             	add    $0x18,%esp
  8026e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8026e6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8026ea:	75 07                	jne    8026f3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8026ec:	b8 01 00 00 00       	mov    $0x1,%eax
  8026f1:	eb 05                	jmp    8026f8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8026f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026f8:	c9                   	leave  
  8026f9:	c3                   	ret    

008026fa <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8026fa:	55                   	push   %ebp
  8026fb:	89 e5                	mov    %esp,%ebp
  8026fd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802700:	6a 00                	push   $0x0
  802702:	6a 00                	push   $0x0
  802704:	6a 00                	push   $0x0
  802706:	6a 00                	push   $0x0
  802708:	6a 00                	push   $0x0
  80270a:	6a 26                	push   $0x26
  80270c:	e8 00 fb ff ff       	call   802211 <syscall>
  802711:	83 c4 18             	add    $0x18,%esp
  802714:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802717:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80271b:	75 07                	jne    802724 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80271d:	b8 01 00 00 00       	mov    $0x1,%eax
  802722:	eb 05                	jmp    802729 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802724:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802729:	c9                   	leave  
  80272a:	c3                   	ret    

0080272b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80272b:	55                   	push   %ebp
  80272c:	89 e5                	mov    %esp,%ebp
  80272e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802731:	6a 00                	push   $0x0
  802733:	6a 00                	push   $0x0
  802735:	6a 00                	push   $0x0
  802737:	6a 00                	push   $0x0
  802739:	6a 00                	push   $0x0
  80273b:	6a 26                	push   $0x26
  80273d:	e8 cf fa ff ff       	call   802211 <syscall>
  802742:	83 c4 18             	add    $0x18,%esp
  802745:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802748:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80274c:	75 07                	jne    802755 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80274e:	b8 01 00 00 00       	mov    $0x1,%eax
  802753:	eb 05                	jmp    80275a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802755:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80275a:	c9                   	leave  
  80275b:	c3                   	ret    

0080275c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80275c:	55                   	push   %ebp
  80275d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80275f:	6a 00                	push   $0x0
  802761:	6a 00                	push   $0x0
  802763:	6a 00                	push   $0x0
  802765:	6a 00                	push   $0x0
  802767:	ff 75 08             	pushl  0x8(%ebp)
  80276a:	6a 27                	push   $0x27
  80276c:	e8 a0 fa ff ff       	call   802211 <syscall>
  802771:	83 c4 18             	add    $0x18,%esp
	return ;
  802774:	90                   	nop
}
  802775:	c9                   	leave  
  802776:	c3                   	ret    
  802777:	90                   	nop

00802778 <__udivdi3>:
  802778:	55                   	push   %ebp
  802779:	57                   	push   %edi
  80277a:	56                   	push   %esi
  80277b:	53                   	push   %ebx
  80277c:	83 ec 1c             	sub    $0x1c,%esp
  80277f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802783:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802787:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80278b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80278f:	89 ca                	mov    %ecx,%edx
  802791:	89 f8                	mov    %edi,%eax
  802793:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802797:	85 f6                	test   %esi,%esi
  802799:	75 2d                	jne    8027c8 <__udivdi3+0x50>
  80279b:	39 cf                	cmp    %ecx,%edi
  80279d:	77 65                	ja     802804 <__udivdi3+0x8c>
  80279f:	89 fd                	mov    %edi,%ebp
  8027a1:	85 ff                	test   %edi,%edi
  8027a3:	75 0b                	jne    8027b0 <__udivdi3+0x38>
  8027a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8027aa:	31 d2                	xor    %edx,%edx
  8027ac:	f7 f7                	div    %edi
  8027ae:	89 c5                	mov    %eax,%ebp
  8027b0:	31 d2                	xor    %edx,%edx
  8027b2:	89 c8                	mov    %ecx,%eax
  8027b4:	f7 f5                	div    %ebp
  8027b6:	89 c1                	mov    %eax,%ecx
  8027b8:	89 d8                	mov    %ebx,%eax
  8027ba:	f7 f5                	div    %ebp
  8027bc:	89 cf                	mov    %ecx,%edi
  8027be:	89 fa                	mov    %edi,%edx
  8027c0:	83 c4 1c             	add    $0x1c,%esp
  8027c3:	5b                   	pop    %ebx
  8027c4:	5e                   	pop    %esi
  8027c5:	5f                   	pop    %edi
  8027c6:	5d                   	pop    %ebp
  8027c7:	c3                   	ret    
  8027c8:	39 ce                	cmp    %ecx,%esi
  8027ca:	77 28                	ja     8027f4 <__udivdi3+0x7c>
  8027cc:	0f bd fe             	bsr    %esi,%edi
  8027cf:	83 f7 1f             	xor    $0x1f,%edi
  8027d2:	75 40                	jne    802814 <__udivdi3+0x9c>
  8027d4:	39 ce                	cmp    %ecx,%esi
  8027d6:	72 0a                	jb     8027e2 <__udivdi3+0x6a>
  8027d8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8027dc:	0f 87 9e 00 00 00    	ja     802880 <__udivdi3+0x108>
  8027e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8027e7:	89 fa                	mov    %edi,%edx
  8027e9:	83 c4 1c             	add    $0x1c,%esp
  8027ec:	5b                   	pop    %ebx
  8027ed:	5e                   	pop    %esi
  8027ee:	5f                   	pop    %edi
  8027ef:	5d                   	pop    %ebp
  8027f0:	c3                   	ret    
  8027f1:	8d 76 00             	lea    0x0(%esi),%esi
  8027f4:	31 ff                	xor    %edi,%edi
  8027f6:	31 c0                	xor    %eax,%eax
  8027f8:	89 fa                	mov    %edi,%edx
  8027fa:	83 c4 1c             	add    $0x1c,%esp
  8027fd:	5b                   	pop    %ebx
  8027fe:	5e                   	pop    %esi
  8027ff:	5f                   	pop    %edi
  802800:	5d                   	pop    %ebp
  802801:	c3                   	ret    
  802802:	66 90                	xchg   %ax,%ax
  802804:	89 d8                	mov    %ebx,%eax
  802806:	f7 f7                	div    %edi
  802808:	31 ff                	xor    %edi,%edi
  80280a:	89 fa                	mov    %edi,%edx
  80280c:	83 c4 1c             	add    $0x1c,%esp
  80280f:	5b                   	pop    %ebx
  802810:	5e                   	pop    %esi
  802811:	5f                   	pop    %edi
  802812:	5d                   	pop    %ebp
  802813:	c3                   	ret    
  802814:	bd 20 00 00 00       	mov    $0x20,%ebp
  802819:	89 eb                	mov    %ebp,%ebx
  80281b:	29 fb                	sub    %edi,%ebx
  80281d:	89 f9                	mov    %edi,%ecx
  80281f:	d3 e6                	shl    %cl,%esi
  802821:	89 c5                	mov    %eax,%ebp
  802823:	88 d9                	mov    %bl,%cl
  802825:	d3 ed                	shr    %cl,%ebp
  802827:	89 e9                	mov    %ebp,%ecx
  802829:	09 f1                	or     %esi,%ecx
  80282b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80282f:	89 f9                	mov    %edi,%ecx
  802831:	d3 e0                	shl    %cl,%eax
  802833:	89 c5                	mov    %eax,%ebp
  802835:	89 d6                	mov    %edx,%esi
  802837:	88 d9                	mov    %bl,%cl
  802839:	d3 ee                	shr    %cl,%esi
  80283b:	89 f9                	mov    %edi,%ecx
  80283d:	d3 e2                	shl    %cl,%edx
  80283f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802843:	88 d9                	mov    %bl,%cl
  802845:	d3 e8                	shr    %cl,%eax
  802847:	09 c2                	or     %eax,%edx
  802849:	89 d0                	mov    %edx,%eax
  80284b:	89 f2                	mov    %esi,%edx
  80284d:	f7 74 24 0c          	divl   0xc(%esp)
  802851:	89 d6                	mov    %edx,%esi
  802853:	89 c3                	mov    %eax,%ebx
  802855:	f7 e5                	mul    %ebp
  802857:	39 d6                	cmp    %edx,%esi
  802859:	72 19                	jb     802874 <__udivdi3+0xfc>
  80285b:	74 0b                	je     802868 <__udivdi3+0xf0>
  80285d:	89 d8                	mov    %ebx,%eax
  80285f:	31 ff                	xor    %edi,%edi
  802861:	e9 58 ff ff ff       	jmp    8027be <__udivdi3+0x46>
  802866:	66 90                	xchg   %ax,%ax
  802868:	8b 54 24 08          	mov    0x8(%esp),%edx
  80286c:	89 f9                	mov    %edi,%ecx
  80286e:	d3 e2                	shl    %cl,%edx
  802870:	39 c2                	cmp    %eax,%edx
  802872:	73 e9                	jae    80285d <__udivdi3+0xe5>
  802874:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802877:	31 ff                	xor    %edi,%edi
  802879:	e9 40 ff ff ff       	jmp    8027be <__udivdi3+0x46>
  80287e:	66 90                	xchg   %ax,%ax
  802880:	31 c0                	xor    %eax,%eax
  802882:	e9 37 ff ff ff       	jmp    8027be <__udivdi3+0x46>
  802887:	90                   	nop

00802888 <__umoddi3>:
  802888:	55                   	push   %ebp
  802889:	57                   	push   %edi
  80288a:	56                   	push   %esi
  80288b:	53                   	push   %ebx
  80288c:	83 ec 1c             	sub    $0x1c,%esp
  80288f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802893:	8b 74 24 34          	mov    0x34(%esp),%esi
  802897:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80289b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80289f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8028a3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8028a7:	89 f3                	mov    %esi,%ebx
  8028a9:	89 fa                	mov    %edi,%edx
  8028ab:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8028af:	89 34 24             	mov    %esi,(%esp)
  8028b2:	85 c0                	test   %eax,%eax
  8028b4:	75 1a                	jne    8028d0 <__umoddi3+0x48>
  8028b6:	39 f7                	cmp    %esi,%edi
  8028b8:	0f 86 a2 00 00 00    	jbe    802960 <__umoddi3+0xd8>
  8028be:	89 c8                	mov    %ecx,%eax
  8028c0:	89 f2                	mov    %esi,%edx
  8028c2:	f7 f7                	div    %edi
  8028c4:	89 d0                	mov    %edx,%eax
  8028c6:	31 d2                	xor    %edx,%edx
  8028c8:	83 c4 1c             	add    $0x1c,%esp
  8028cb:	5b                   	pop    %ebx
  8028cc:	5e                   	pop    %esi
  8028cd:	5f                   	pop    %edi
  8028ce:	5d                   	pop    %ebp
  8028cf:	c3                   	ret    
  8028d0:	39 f0                	cmp    %esi,%eax
  8028d2:	0f 87 ac 00 00 00    	ja     802984 <__umoddi3+0xfc>
  8028d8:	0f bd e8             	bsr    %eax,%ebp
  8028db:	83 f5 1f             	xor    $0x1f,%ebp
  8028de:	0f 84 ac 00 00 00    	je     802990 <__umoddi3+0x108>
  8028e4:	bf 20 00 00 00       	mov    $0x20,%edi
  8028e9:	29 ef                	sub    %ebp,%edi
  8028eb:	89 fe                	mov    %edi,%esi
  8028ed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028f1:	89 e9                	mov    %ebp,%ecx
  8028f3:	d3 e0                	shl    %cl,%eax
  8028f5:	89 d7                	mov    %edx,%edi
  8028f7:	89 f1                	mov    %esi,%ecx
  8028f9:	d3 ef                	shr    %cl,%edi
  8028fb:	09 c7                	or     %eax,%edi
  8028fd:	89 e9                	mov    %ebp,%ecx
  8028ff:	d3 e2                	shl    %cl,%edx
  802901:	89 14 24             	mov    %edx,(%esp)
  802904:	89 d8                	mov    %ebx,%eax
  802906:	d3 e0                	shl    %cl,%eax
  802908:	89 c2                	mov    %eax,%edx
  80290a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80290e:	d3 e0                	shl    %cl,%eax
  802910:	89 44 24 04          	mov    %eax,0x4(%esp)
  802914:	8b 44 24 08          	mov    0x8(%esp),%eax
  802918:	89 f1                	mov    %esi,%ecx
  80291a:	d3 e8                	shr    %cl,%eax
  80291c:	09 d0                	or     %edx,%eax
  80291e:	d3 eb                	shr    %cl,%ebx
  802920:	89 da                	mov    %ebx,%edx
  802922:	f7 f7                	div    %edi
  802924:	89 d3                	mov    %edx,%ebx
  802926:	f7 24 24             	mull   (%esp)
  802929:	89 c6                	mov    %eax,%esi
  80292b:	89 d1                	mov    %edx,%ecx
  80292d:	39 d3                	cmp    %edx,%ebx
  80292f:	0f 82 87 00 00 00    	jb     8029bc <__umoddi3+0x134>
  802935:	0f 84 91 00 00 00    	je     8029cc <__umoddi3+0x144>
  80293b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80293f:	29 f2                	sub    %esi,%edx
  802941:	19 cb                	sbb    %ecx,%ebx
  802943:	89 d8                	mov    %ebx,%eax
  802945:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802949:	d3 e0                	shl    %cl,%eax
  80294b:	89 e9                	mov    %ebp,%ecx
  80294d:	d3 ea                	shr    %cl,%edx
  80294f:	09 d0                	or     %edx,%eax
  802951:	89 e9                	mov    %ebp,%ecx
  802953:	d3 eb                	shr    %cl,%ebx
  802955:	89 da                	mov    %ebx,%edx
  802957:	83 c4 1c             	add    $0x1c,%esp
  80295a:	5b                   	pop    %ebx
  80295b:	5e                   	pop    %esi
  80295c:	5f                   	pop    %edi
  80295d:	5d                   	pop    %ebp
  80295e:	c3                   	ret    
  80295f:	90                   	nop
  802960:	89 fd                	mov    %edi,%ebp
  802962:	85 ff                	test   %edi,%edi
  802964:	75 0b                	jne    802971 <__umoddi3+0xe9>
  802966:	b8 01 00 00 00       	mov    $0x1,%eax
  80296b:	31 d2                	xor    %edx,%edx
  80296d:	f7 f7                	div    %edi
  80296f:	89 c5                	mov    %eax,%ebp
  802971:	89 f0                	mov    %esi,%eax
  802973:	31 d2                	xor    %edx,%edx
  802975:	f7 f5                	div    %ebp
  802977:	89 c8                	mov    %ecx,%eax
  802979:	f7 f5                	div    %ebp
  80297b:	89 d0                	mov    %edx,%eax
  80297d:	e9 44 ff ff ff       	jmp    8028c6 <__umoddi3+0x3e>
  802982:	66 90                	xchg   %ax,%ax
  802984:	89 c8                	mov    %ecx,%eax
  802986:	89 f2                	mov    %esi,%edx
  802988:	83 c4 1c             	add    $0x1c,%esp
  80298b:	5b                   	pop    %ebx
  80298c:	5e                   	pop    %esi
  80298d:	5f                   	pop    %edi
  80298e:	5d                   	pop    %ebp
  80298f:	c3                   	ret    
  802990:	3b 04 24             	cmp    (%esp),%eax
  802993:	72 06                	jb     80299b <__umoddi3+0x113>
  802995:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802999:	77 0f                	ja     8029aa <__umoddi3+0x122>
  80299b:	89 f2                	mov    %esi,%edx
  80299d:	29 f9                	sub    %edi,%ecx
  80299f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8029a3:	89 14 24             	mov    %edx,(%esp)
  8029a6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8029aa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8029ae:	8b 14 24             	mov    (%esp),%edx
  8029b1:	83 c4 1c             	add    $0x1c,%esp
  8029b4:	5b                   	pop    %ebx
  8029b5:	5e                   	pop    %esi
  8029b6:	5f                   	pop    %edi
  8029b7:	5d                   	pop    %ebp
  8029b8:	c3                   	ret    
  8029b9:	8d 76 00             	lea    0x0(%esi),%esi
  8029bc:	2b 04 24             	sub    (%esp),%eax
  8029bf:	19 fa                	sbb    %edi,%edx
  8029c1:	89 d1                	mov    %edx,%ecx
  8029c3:	89 c6                	mov    %eax,%esi
  8029c5:	e9 71 ff ff ff       	jmp    80293b <__umoddi3+0xb3>
  8029ca:	66 90                	xchg   %ax,%ax
  8029cc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8029d0:	72 ea                	jb     8029bc <__umoddi3+0x134>
  8029d2:	89 d9                	mov    %ebx,%ecx
  8029d4:	e9 62 ff ff ff       	jmp    80293b <__umoddi3+0xb3>
