
obj/user/quicksort:     file format elf32-i386


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
  800031:	e8 a0 05 00 00       	call   8005d6 <libmain>
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
  800049:	e8 cd 22 00 00       	call   80231b <sys_calculate_free_frames>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	e8 df 22 00 00       	call   802334 <sys_calculate_modified_frames>
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
  80006c:	e8 cc 0d 00 00       	call   800e3d <readline>
  800071:	83 c4 10             	add    $0x10,%esp
			int NumOfElements = strtol(Line, NULL, 10) ;
  800074:	83 ec 04             	sub    $0x4,%esp
  800077:	6a 0a                	push   $0xa
  800079:	6a 00                	push   $0x0
  80007b:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800081:	50                   	push   %eax
  800082:	e8 1c 13 00 00       	call   8013a3 <strtol>
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	89 45 ec             	mov    %eax,-0x14(%ebp)
			int *Elements = malloc(sizeof(int) * NumOfElements) ;
  80008d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800090:	c1 e0 02             	shl    $0x2,%eax
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	50                   	push   %eax
  800097:	e8 af 16 00 00       	call   80174b <malloc>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			cprintf("Choose the initialization method:\n") ;
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	68 e0 29 80 00       	push   $0x8029e0
  8000aa:	e8 13 07 00 00       	call   8007c2 <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000b2:	83 ec 0c             	sub    $0xc,%esp
  8000b5:	68 03 2a 80 00       	push   $0x802a03
  8000ba:	e8 03 07 00 00       	call   8007c2 <cprintf>
  8000bf:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000c2:	83 ec 0c             	sub    $0xc,%esp
  8000c5:	68 11 2a 80 00       	push   $0x802a11
  8000ca:	e8 f3 06 00 00       	call   8007c2 <cprintf>
  8000cf:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\nSelect: ") ;
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 20 2a 80 00       	push   $0x802a20
  8000da:	e8 e3 06 00 00       	call   8007c2 <cprintf>
  8000df:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8000e2:	e8 97 04 00 00       	call   80057e <getchar>
  8000e7:	88 45 e7             	mov    %al,-0x19(%ebp)
			cputchar(Chose);
  8000ea:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	50                   	push   %eax
  8000f2:	e8 3f 04 00 00       	call   800536 <cputchar>
  8000f7:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8000fa:	83 ec 0c             	sub    $0xc,%esp
  8000fd:	6a 0a                	push   $0xa
  8000ff:	e8 32 04 00 00       	call   800536 <cputchar>
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
  800123:	e8 d6 02 00 00       	call   8003fe <InitializeAscending>
  800128:	83 c4 10             	add    $0x10,%esp
			break ;
  80012b:	eb 37                	jmp    800164 <_main+0x12c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80012d:	83 ec 08             	sub    $0x8,%esp
  800130:	ff 75 ec             	pushl  -0x14(%ebp)
  800133:	ff 75 e8             	pushl  -0x18(%ebp)
  800136:	e8 f4 02 00 00       	call   80042f <InitializeDescending>
  80013b:	83 c4 10             	add    $0x10,%esp
			break ;
  80013e:	eb 24                	jmp    800164 <_main+0x12c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800140:	83 ec 08             	sub    $0x8,%esp
  800143:	ff 75 ec             	pushl  -0x14(%ebp)
  800146:	ff 75 e8             	pushl  -0x18(%ebp)
  800149:	e8 16 03 00 00       	call   800464 <InitializeSemiRandom>
  80014e:	83 c4 10             	add    $0x10,%esp
			break ;
  800151:	eb 11                	jmp    800164 <_main+0x12c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  800153:	83 ec 08             	sub    $0x8,%esp
  800156:	ff 75 ec             	pushl  -0x14(%ebp)
  800159:	ff 75 e8             	pushl  -0x18(%ebp)
  80015c:	e8 03 03 00 00       	call   800464 <InitializeSemiRandom>
  800161:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  800164:	83 ec 08             	sub    $0x8,%esp
  800167:	ff 75 ec             	pushl  -0x14(%ebp)
  80016a:	ff 75 e8             	pushl  -0x18(%ebp)
  80016d:	e8 d1 00 00 00       	call   800243 <QuickSort>
  800172:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  800175:	83 ec 08             	sub    $0x8,%esp
  800178:	ff 75 ec             	pushl  -0x14(%ebp)
  80017b:	ff 75 e8             	pushl  -0x18(%ebp)
  80017e:	e8 d1 01 00 00       	call   800354 <CheckSorted>
  800183:	83 c4 10             	add    $0x10,%esp
  800186:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800189:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80018d:	75 14                	jne    8001a3 <_main+0x16b>
  80018f:	83 ec 04             	sub    $0x4,%esp
  800192:	68 38 2a 80 00       	push   $0x802a38
  800197:	6a 41                	push   $0x41
  800199:	68 5a 2a 80 00       	push   $0x802a5a
  80019e:	e8 f4 04 00 00       	call   800697 <_panic>
		else
		{ 
				cprintf("\n===============================================\n") ;
  8001a3:	83 ec 0c             	sub    $0xc,%esp
  8001a6:	68 6c 2a 80 00       	push   $0x802a6c
  8001ab:	e8 12 06 00 00       	call   8007c2 <cprintf>
  8001b0:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	68 a0 2a 80 00       	push   $0x802aa0
  8001bb:	e8 02 06 00 00       	call   8007c2 <cprintf>
  8001c0:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  8001c3:	83 ec 0c             	sub    $0xc,%esp
  8001c6:	68 d4 2a 80 00       	push   $0x802ad4
  8001cb:	e8 f2 05 00 00       	call   8007c2 <cprintf>
  8001d0:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

			cprintf("Freeing the Heap...\n\n") ;
  8001d3:	83 ec 0c             	sub    $0xc,%esp
  8001d6:	68 06 2b 80 00       	push   $0x802b06
  8001db:	e8 e2 05 00 00       	call   8007c2 <cprintf>
  8001e0:	83 c4 10             	add    $0x10,%esp

			free(Elements) ;
  8001e3:	83 ec 0c             	sub    $0xc,%esp
  8001e6:	ff 75 e8             	pushl  -0x18(%ebp)
  8001e9:	e8 ff 1e 00 00       	call   8020ed <free>
  8001ee:	83 c4 10             	add    $0x10,%esp


		///========================================================================
	//sys_disable_interrupt();
			cprintf("Do you want to repeat (y/n): ") ;
  8001f1:	83 ec 0c             	sub    $0xc,%esp
  8001f4:	68 1c 2b 80 00       	push   $0x802b1c
  8001f9:	e8 c4 05 00 00       	call   8007c2 <cprintf>
  8001fe:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  800201:	e8 78 03 00 00       	call   80057e <getchar>
  800206:	88 45 e7             	mov    %al,-0x19(%ebp)
			cputchar(Chose);
  800209:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  80020d:	83 ec 0c             	sub    $0xc,%esp
  800210:	50                   	push   %eax
  800211:	e8 20 03 00 00       	call   800536 <cputchar>
  800216:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	6a 0a                	push   $0xa
  80021e:	e8 13 03 00 00       	call   800536 <cputchar>
  800223:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800226:	83 ec 0c             	sub    $0xc,%esp
  800229:	6a 0a                	push   $0xa
  80022b:	e8 06 03 00 00       	call   800536 <cputchar>
  800230:	83 c4 10             	add    $0x10,%esp
	//sys_enable_interrupt();

	} while (Chose == 'y');
  800233:	80 7d e7 79          	cmpb   $0x79,-0x19(%ebp)
  800237:	0f 84 0c fe ff ff    	je     800049 <_main+0x11>

}
  80023d:	90                   	nop
  80023e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800241:	c9                   	leave  
  800242:	c3                   	ret    

00800243 <QuickSort>:

///Quick sort 
void QuickSort(int *Elements, int NumOfElements)
{
  800243:	55                   	push   %ebp
  800244:	89 e5                	mov    %esp,%ebp
  800246:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  800249:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024c:	48                   	dec    %eax
  80024d:	50                   	push   %eax
  80024e:	6a 00                	push   $0x0
  800250:	ff 75 0c             	pushl  0xc(%ebp)
  800253:	ff 75 08             	pushl  0x8(%ebp)
  800256:	e8 06 00 00 00       	call   800261 <QSort>
  80025b:	83 c4 10             	add    $0x10,%esp
}
  80025e:	90                   	nop
  80025f:	c9                   	leave  
  800260:	c3                   	ret    

00800261 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  800261:	55                   	push   %ebp
  800262:	89 e5                	mov    %esp,%ebp
  800264:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  800267:	8b 45 10             	mov    0x10(%ebp),%eax
  80026a:	3b 45 14             	cmp    0x14(%ebp),%eax
  80026d:	0f 8d de 00 00 00    	jge    800351 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  800273:	8b 45 10             	mov    0x10(%ebp),%eax
  800276:	40                   	inc    %eax
  800277:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80027a:	8b 45 14             	mov    0x14(%ebp),%eax
  80027d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800280:	e9 80 00 00 00       	jmp    800305 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800285:	ff 45 f4             	incl   -0xc(%ebp)
  800288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80028b:	3b 45 14             	cmp    0x14(%ebp),%eax
  80028e:	7f 2b                	jg     8002bb <QSort+0x5a>
  800290:	8b 45 10             	mov    0x10(%ebp),%eax
  800293:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80029a:	8b 45 08             	mov    0x8(%ebp),%eax
  80029d:	01 d0                	add    %edx,%eax
  80029f:	8b 10                	mov    (%eax),%edx
  8002a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002a4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ae:	01 c8                	add    %ecx,%eax
  8002b0:	8b 00                	mov    (%eax),%eax
  8002b2:	39 c2                	cmp    %eax,%edx
  8002b4:	7d cf                	jge    800285 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002b6:	eb 03                	jmp    8002bb <QSort+0x5a>
  8002b8:	ff 4d f0             	decl   -0x10(%ebp)
  8002bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002be:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002c1:	7e 26                	jle    8002e9 <QSort+0x88>
  8002c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d0:	01 d0                	add    %edx,%eax
  8002d2:	8b 10                	mov    (%eax),%edx
  8002d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002d7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002de:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e1:	01 c8                	add    %ecx,%eax
  8002e3:	8b 00                	mov    (%eax),%eax
  8002e5:	39 c2                	cmp    %eax,%edx
  8002e7:	7e cf                	jle    8002b8 <QSort+0x57>

		if (i <= j)
  8002e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002ec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002ef:	7f 14                	jg     800305 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  8002f1:	83 ec 04             	sub    $0x4,%esp
  8002f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8002f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8002fa:	ff 75 08             	pushl  0x8(%ebp)
  8002fd:	e8 a9 00 00 00       	call   8003ab <Swap>
  800302:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800305:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800308:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80030b:	0f 8e 77 ff ff ff    	jle    800288 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800311:	83 ec 04             	sub    $0x4,%esp
  800314:	ff 75 f0             	pushl  -0x10(%ebp)
  800317:	ff 75 10             	pushl  0x10(%ebp)
  80031a:	ff 75 08             	pushl  0x8(%ebp)
  80031d:	e8 89 00 00 00       	call   8003ab <Swap>
  800322:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800325:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800328:	48                   	dec    %eax
  800329:	50                   	push   %eax
  80032a:	ff 75 10             	pushl  0x10(%ebp)
  80032d:	ff 75 0c             	pushl  0xc(%ebp)
  800330:	ff 75 08             	pushl  0x8(%ebp)
  800333:	e8 29 ff ff ff       	call   800261 <QSort>
  800338:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  80033b:	ff 75 14             	pushl  0x14(%ebp)
  80033e:	ff 75 f4             	pushl  -0xc(%ebp)
  800341:	ff 75 0c             	pushl  0xc(%ebp)
  800344:	ff 75 08             	pushl  0x8(%ebp)
  800347:	e8 15 ff ff ff       	call   800261 <QSort>
  80034c:	83 c4 10             	add    $0x10,%esp
  80034f:	eb 01                	jmp    800352 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  800351:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  800352:	c9                   	leave  
  800353:	c3                   	ret    

00800354 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  800354:	55                   	push   %ebp
  800355:	89 e5                	mov    %esp,%ebp
  800357:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  80035a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800361:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800368:	eb 33                	jmp    80039d <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  80036a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80036d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800374:	8b 45 08             	mov    0x8(%ebp),%eax
  800377:	01 d0                	add    %edx,%eax
  800379:	8b 10                	mov    (%eax),%edx
  80037b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80037e:	40                   	inc    %eax
  80037f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800386:	8b 45 08             	mov    0x8(%ebp),%eax
  800389:	01 c8                	add    %ecx,%eax
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	39 c2                	cmp    %eax,%edx
  80038f:	7e 09                	jle    80039a <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800391:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800398:	eb 0c                	jmp    8003a6 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80039a:	ff 45 f8             	incl   -0x8(%ebp)
  80039d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a0:	48                   	dec    %eax
  8003a1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8003a4:	7f c4                	jg     80036a <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8003a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8003a9:	c9                   	leave  
  8003aa:	c3                   	ret    

008003ab <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  8003ab:	55                   	push   %ebp
  8003ac:	89 e5                	mov    %esp,%ebp
  8003ae:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8003b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003be:	01 d0                	add    %edx,%eax
  8003c0:	8b 00                	mov    (%eax),%eax
  8003c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8003c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d2:	01 c2                	add    %eax,%edx
  8003d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8003d7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003de:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e1:	01 c8                	add    %ecx,%eax
  8003e3:	8b 00                	mov    (%eax),%eax
  8003e5:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8003e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8003ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f4:	01 c2                	add    %eax,%edx
  8003f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003f9:	89 02                	mov    %eax,(%edx)
}
  8003fb:	90                   	nop
  8003fc:	c9                   	leave  
  8003fd:	c3                   	ret    

008003fe <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  8003fe:	55                   	push   %ebp
  8003ff:	89 e5                	mov    %esp,%ebp
  800401:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800404:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80040b:	eb 17                	jmp    800424 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80040d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800410:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800417:	8b 45 08             	mov    0x8(%ebp),%eax
  80041a:	01 c2                	add    %eax,%edx
  80041c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80041f:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800421:	ff 45 fc             	incl   -0x4(%ebp)
  800424:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800427:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80042a:	7c e1                	jl     80040d <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80042c:	90                   	nop
  80042d:	c9                   	leave  
  80042e:	c3                   	ret    

0080042f <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80042f:	55                   	push   %ebp
  800430:	89 e5                	mov    %esp,%ebp
  800432:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800435:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80043c:	eb 1b                	jmp    800459 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  80043e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800441:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	01 c2                	add    %eax,%edx
  80044d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800450:	2b 45 fc             	sub    -0x4(%ebp),%eax
  800453:	48                   	dec    %eax
  800454:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800456:	ff 45 fc             	incl   -0x4(%ebp)
  800459:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80045c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80045f:	7c dd                	jl     80043e <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  800461:	90                   	nop
  800462:	c9                   	leave  
  800463:	c3                   	ret    

00800464 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  800464:	55                   	push   %ebp
  800465:	89 e5                	mov    %esp,%ebp
  800467:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  80046a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80046d:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800472:	f7 e9                	imul   %ecx
  800474:	c1 f9 1f             	sar    $0x1f,%ecx
  800477:	89 d0                	mov    %edx,%eax
  800479:	29 c8                	sub    %ecx,%eax
  80047b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  80047e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800485:	eb 1e                	jmp    8004a5 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800487:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80048a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800491:	8b 45 08             	mov    0x8(%ebp),%eax
  800494:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800497:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049a:	99                   	cltd   
  80049b:	f7 7d f8             	idivl  -0x8(%ebp)
  80049e:	89 d0                	mov    %edx,%eax
  8004a0:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004a2:	ff 45 fc             	incl   -0x4(%ebp)
  8004a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004a8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004ab:	7c da                	jl     800487 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
	}

}
  8004ad:	90                   	nop
  8004ae:	c9                   	leave  
  8004af:	c3                   	ret    

008004b0 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  8004b0:	55                   	push   %ebp
  8004b1:	89 e5                	mov    %esp,%ebp
  8004b3:	83 ec 18             	sub    $0x18,%esp
		int i ;
		int NumsPerLine = 20 ;
  8004b6:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
		for (i = 0 ; i < NumOfElements-1 ; i++)
  8004bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8004c4:	eb 42                	jmp    800508 <PrintElements+0x58>
		{
			if (i%NumsPerLine == 0)
  8004c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004c9:	99                   	cltd   
  8004ca:	f7 7d f0             	idivl  -0x10(%ebp)
  8004cd:	89 d0                	mov    %edx,%eax
  8004cf:	85 c0                	test   %eax,%eax
  8004d1:	75 10                	jne    8004e3 <PrintElements+0x33>
				cprintf("\n");
  8004d3:	83 ec 0c             	sub    $0xc,%esp
  8004d6:	68 3a 2b 80 00       	push   $0x802b3a
  8004db:	e8 e2 02 00 00       	call   8007c2 <cprintf>
  8004e0:	83 c4 10             	add    $0x10,%esp
			cprintf("%d, ",Elements[i]);
  8004e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f0:	01 d0                	add    %edx,%eax
  8004f2:	8b 00                	mov    (%eax),%eax
  8004f4:	83 ec 08             	sub    $0x8,%esp
  8004f7:	50                   	push   %eax
  8004f8:	68 3c 2b 80 00       	push   $0x802b3c
  8004fd:	e8 c0 02 00 00       	call   8007c2 <cprintf>
  800502:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
		int i ;
		int NumsPerLine = 20 ;
		for (i = 0 ; i < NumOfElements-1 ; i++)
  800505:	ff 45 f4             	incl   -0xc(%ebp)
  800508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050b:	48                   	dec    %eax
  80050c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80050f:	7f b5                	jg     8004c6 <PrintElements+0x16>
		{
			if (i%NumsPerLine == 0)
				cprintf("\n");
			cprintf("%d, ",Elements[i]);
		}
		cprintf("%d\n",Elements[i]);
  800511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800514:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80051b:	8b 45 08             	mov    0x8(%ebp),%eax
  80051e:	01 d0                	add    %edx,%eax
  800520:	8b 00                	mov    (%eax),%eax
  800522:	83 ec 08             	sub    $0x8,%esp
  800525:	50                   	push   %eax
  800526:	68 41 2b 80 00       	push   $0x802b41
  80052b:	e8 92 02 00 00       	call   8007c2 <cprintf>
  800530:	83 c4 10             	add    $0x10,%esp
}
  800533:	90                   	nop
  800534:	c9                   	leave  
  800535:	c3                   	ret    

00800536 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800536:	55                   	push   %ebp
  800537:	89 e5                	mov    %esp,%ebp
  800539:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80053c:	8b 45 08             	mov    0x8(%ebp),%eax
  80053f:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800542:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800546:	83 ec 0c             	sub    $0xc,%esp
  800549:	50                   	push   %eax
  80054a:	e8 9c 1e 00 00       	call   8023eb <sys_cputc>
  80054f:	83 c4 10             	add    $0x10,%esp
}
  800552:	90                   	nop
  800553:	c9                   	leave  
  800554:	c3                   	ret    

00800555 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800555:	55                   	push   %ebp
  800556:	89 e5                	mov    %esp,%ebp
  800558:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80055b:	e8 57 1e 00 00       	call   8023b7 <sys_disable_interrupt>
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
  80056e:	e8 78 1e 00 00       	call   8023eb <sys_cputc>
  800573:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800576:	e8 56 1e 00 00       	call   8023d1 <sys_enable_interrupt>
}
  80057b:	90                   	nop
  80057c:	c9                   	leave  
  80057d:	c3                   	ret    

0080057e <getchar>:

int
getchar(void)
{
  80057e:	55                   	push   %ebp
  80057f:	89 e5                	mov    %esp,%ebp
  800581:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800584:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80058b:	eb 08                	jmp    800595 <getchar+0x17>
	{
		c = sys_cgetc();
  80058d:	e8 a3 1c 00 00       	call   802235 <sys_cgetc>
  800592:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800595:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800599:	74 f2                	je     80058d <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80059b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80059e:	c9                   	leave  
  80059f:	c3                   	ret    

008005a0 <atomic_getchar>:

int
atomic_getchar(void)
{
  8005a0:	55                   	push   %ebp
  8005a1:	89 e5                	mov    %esp,%ebp
  8005a3:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005a6:	e8 0c 1e 00 00       	call   8023b7 <sys_disable_interrupt>
	int c=0;
  8005ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005b2:	eb 08                	jmp    8005bc <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8005b4:	e8 7c 1c 00 00       	call   802235 <sys_cgetc>
  8005b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8005bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8005c0:	74 f2                	je     8005b4 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8005c2:	e8 0a 1e 00 00       	call   8023d1 <sys_enable_interrupt>
	return c;
  8005c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005ca:	c9                   	leave  
  8005cb:	c3                   	ret    

008005cc <iscons>:

int iscons(int fdnum)
{
  8005cc:	55                   	push   %ebp
  8005cd:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8005cf:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8005d4:	5d                   	pop    %ebp
  8005d5:	c3                   	ret    

008005d6 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005d6:	55                   	push   %ebp
  8005d7:	89 e5                	mov    %esp,%ebp
  8005d9:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005e0:	7e 0a                	jle    8005ec <libmain+0x16>
		binaryname = argv[0];
  8005e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e5:	8b 00                	mov    (%eax),%eax
  8005e7:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8005ec:	83 ec 08             	sub    $0x8,%esp
  8005ef:	ff 75 0c             	pushl  0xc(%ebp)
  8005f2:	ff 75 08             	pushl  0x8(%ebp)
  8005f5:	e8 3e fa ff ff       	call   800038 <_main>
  8005fa:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8005fd:	e8 67 1c 00 00       	call   802269 <sys_getenvid>
  800602:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  800605:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800608:	89 d0                	mov    %edx,%eax
  80060a:	c1 e0 03             	shl    $0x3,%eax
  80060d:	01 d0                	add    %edx,%eax
  80060f:	01 c0                	add    %eax,%eax
  800611:	01 d0                	add    %edx,%eax
  800613:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80061a:	01 d0                	add    %edx,%eax
  80061c:	c1 e0 03             	shl    $0x3,%eax
  80061f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800624:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  800627:	e8 8b 1d 00 00       	call   8023b7 <sys_disable_interrupt>
		cprintf("**************************************\n");
  80062c:	83 ec 0c             	sub    $0xc,%esp
  80062f:	68 60 2b 80 00       	push   $0x802b60
  800634:	e8 89 01 00 00       	call   8007c2 <cprintf>
  800639:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  80063c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80063f:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  800645:	83 ec 08             	sub    $0x8,%esp
  800648:	50                   	push   %eax
  800649:	68 88 2b 80 00       	push   $0x802b88
  80064e:	e8 6f 01 00 00       	call   8007c2 <cprintf>
  800653:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800656:	83 ec 0c             	sub    $0xc,%esp
  800659:	68 60 2b 80 00       	push   $0x802b60
  80065e:	e8 5f 01 00 00       	call   8007c2 <cprintf>
  800663:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800666:	e8 66 1d 00 00       	call   8023d1 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80066b:	e8 19 00 00 00       	call   800689 <exit>
}
  800670:	90                   	nop
  800671:	c9                   	leave  
  800672:	c3                   	ret    

00800673 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800673:	55                   	push   %ebp
  800674:	89 e5                	mov    %esp,%ebp
  800676:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800679:	83 ec 0c             	sub    $0xc,%esp
  80067c:	6a 00                	push   $0x0
  80067e:	e8 cb 1b 00 00       	call   80224e <sys_env_destroy>
  800683:	83 c4 10             	add    $0x10,%esp
}
  800686:	90                   	nop
  800687:	c9                   	leave  
  800688:	c3                   	ret    

00800689 <exit>:

void
exit(void)
{
  800689:	55                   	push   %ebp
  80068a:	89 e5                	mov    %esp,%ebp
  80068c:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80068f:	e8 ee 1b 00 00       	call   802282 <sys_env_exit>
}
  800694:	90                   	nop
  800695:	c9                   	leave  
  800696:	c3                   	ret    

00800697 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800697:	55                   	push   %ebp
  800698:	89 e5                	mov    %esp,%ebp
  80069a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80069d:	8d 45 10             	lea    0x10(%ebp),%eax
  8006a0:	83 c0 04             	add    $0x4,%eax
  8006a3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  8006a6:	a1 70 30 98 00       	mov    0x983070,%eax
  8006ab:	85 c0                	test   %eax,%eax
  8006ad:	74 16                	je     8006c5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006af:	a1 70 30 98 00       	mov    0x983070,%eax
  8006b4:	83 ec 08             	sub    $0x8,%esp
  8006b7:	50                   	push   %eax
  8006b8:	68 a1 2b 80 00       	push   $0x802ba1
  8006bd:	e8 00 01 00 00       	call   8007c2 <cprintf>
  8006c2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006c5:	a1 00 30 80 00       	mov    0x803000,%eax
  8006ca:	ff 75 0c             	pushl  0xc(%ebp)
  8006cd:	ff 75 08             	pushl  0x8(%ebp)
  8006d0:	50                   	push   %eax
  8006d1:	68 a6 2b 80 00       	push   $0x802ba6
  8006d6:	e8 e7 00 00 00       	call   8007c2 <cprintf>
  8006db:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8006de:	8b 45 10             	mov    0x10(%ebp),%eax
  8006e1:	83 ec 08             	sub    $0x8,%esp
  8006e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8006e7:	50                   	push   %eax
  8006e8:	e8 7a 00 00 00       	call   800767 <vcprintf>
  8006ed:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  8006f0:	83 ec 0c             	sub    $0xc,%esp
  8006f3:	68 c2 2b 80 00       	push   $0x802bc2
  8006f8:	e8 c5 00 00 00       	call   8007c2 <cprintf>
  8006fd:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800700:	e8 84 ff ff ff       	call   800689 <exit>

	// should not return here
	while (1) ;
  800705:	eb fe                	jmp    800705 <_panic+0x6e>

00800707 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800707:	55                   	push   %ebp
  800708:	89 e5                	mov    %esp,%ebp
  80070a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80070d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800710:	8b 00                	mov    (%eax),%eax
  800712:	8d 48 01             	lea    0x1(%eax),%ecx
  800715:	8b 55 0c             	mov    0xc(%ebp),%edx
  800718:	89 0a                	mov    %ecx,(%edx)
  80071a:	8b 55 08             	mov    0x8(%ebp),%edx
  80071d:	88 d1                	mov    %dl,%cl
  80071f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800722:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800726:	8b 45 0c             	mov    0xc(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800730:	75 23                	jne    800755 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  800732:	8b 45 0c             	mov    0xc(%ebp),%eax
  800735:	8b 00                	mov    (%eax),%eax
  800737:	89 c2                	mov    %eax,%edx
  800739:	8b 45 0c             	mov    0xc(%ebp),%eax
  80073c:	83 c0 08             	add    $0x8,%eax
  80073f:	83 ec 08             	sub    $0x8,%esp
  800742:	52                   	push   %edx
  800743:	50                   	push   %eax
  800744:	e8 cf 1a 00 00       	call   802218 <sys_cputs>
  800749:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80074c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80074f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800755:	8b 45 0c             	mov    0xc(%ebp),%eax
  800758:	8b 40 04             	mov    0x4(%eax),%eax
  80075b:	8d 50 01             	lea    0x1(%eax),%edx
  80075e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800761:	89 50 04             	mov    %edx,0x4(%eax)
}
  800764:	90                   	nop
  800765:	c9                   	leave  
  800766:	c3                   	ret    

00800767 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800767:	55                   	push   %ebp
  800768:	89 e5                	mov    %esp,%ebp
  80076a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800770:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800777:	00 00 00 
	b.cnt = 0;
  80077a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800781:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800784:	ff 75 0c             	pushl  0xc(%ebp)
  800787:	ff 75 08             	pushl  0x8(%ebp)
  80078a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800790:	50                   	push   %eax
  800791:	68 07 07 80 00       	push   $0x800707
  800796:	e8 fa 01 00 00       	call   800995 <vprintfmt>
  80079b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  80079e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8007a4:	83 ec 08             	sub    $0x8,%esp
  8007a7:	50                   	push   %eax
  8007a8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007ae:	83 c0 08             	add    $0x8,%eax
  8007b1:	50                   	push   %eax
  8007b2:	e8 61 1a 00 00       	call   802218 <sys_cputs>
  8007b7:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  8007ba:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007c0:	c9                   	leave  
  8007c1:	c3                   	ret    

008007c2 <cprintf>:

int cprintf(const char *fmt, ...) {
  8007c2:	55                   	push   %ebp
  8007c3:	89 e5                	mov    %esp,%ebp
  8007c5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007c8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d1:	83 ec 08             	sub    $0x8,%esp
  8007d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d7:	50                   	push   %eax
  8007d8:	e8 8a ff ff ff       	call   800767 <vcprintf>
  8007dd:	83 c4 10             	add    $0x10,%esp
  8007e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007e6:	c9                   	leave  
  8007e7:	c3                   	ret    

008007e8 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007e8:	55                   	push   %ebp
  8007e9:	89 e5                	mov    %esp,%ebp
  8007eb:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007ee:	e8 c4 1b 00 00       	call   8023b7 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007f3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fc:	83 ec 08             	sub    $0x8,%esp
  8007ff:	ff 75 f4             	pushl  -0xc(%ebp)
  800802:	50                   	push   %eax
  800803:	e8 5f ff ff ff       	call   800767 <vcprintf>
  800808:	83 c4 10             	add    $0x10,%esp
  80080b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80080e:	e8 be 1b 00 00       	call   8023d1 <sys_enable_interrupt>
	return cnt;
  800813:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800816:	c9                   	leave  
  800817:	c3                   	ret    

00800818 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800818:	55                   	push   %ebp
  800819:	89 e5                	mov    %esp,%ebp
  80081b:	53                   	push   %ebx
  80081c:	83 ec 14             	sub    $0x14,%esp
  80081f:	8b 45 10             	mov    0x10(%ebp),%eax
  800822:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800825:	8b 45 14             	mov    0x14(%ebp),%eax
  800828:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80082b:	8b 45 18             	mov    0x18(%ebp),%eax
  80082e:	ba 00 00 00 00       	mov    $0x0,%edx
  800833:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800836:	77 55                	ja     80088d <printnum+0x75>
  800838:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80083b:	72 05                	jb     800842 <printnum+0x2a>
  80083d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800840:	77 4b                	ja     80088d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800842:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800845:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800848:	8b 45 18             	mov    0x18(%ebp),%eax
  80084b:	ba 00 00 00 00       	mov    $0x0,%edx
  800850:	52                   	push   %edx
  800851:	50                   	push   %eax
  800852:	ff 75 f4             	pushl  -0xc(%ebp)
  800855:	ff 75 f0             	pushl  -0x10(%ebp)
  800858:	e8 f7 1e 00 00       	call   802754 <__udivdi3>
  80085d:	83 c4 10             	add    $0x10,%esp
  800860:	83 ec 04             	sub    $0x4,%esp
  800863:	ff 75 20             	pushl  0x20(%ebp)
  800866:	53                   	push   %ebx
  800867:	ff 75 18             	pushl  0x18(%ebp)
  80086a:	52                   	push   %edx
  80086b:	50                   	push   %eax
  80086c:	ff 75 0c             	pushl  0xc(%ebp)
  80086f:	ff 75 08             	pushl  0x8(%ebp)
  800872:	e8 a1 ff ff ff       	call   800818 <printnum>
  800877:	83 c4 20             	add    $0x20,%esp
  80087a:	eb 1a                	jmp    800896 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80087c:	83 ec 08             	sub    $0x8,%esp
  80087f:	ff 75 0c             	pushl  0xc(%ebp)
  800882:	ff 75 20             	pushl  0x20(%ebp)
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	ff d0                	call   *%eax
  80088a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80088d:	ff 4d 1c             	decl   0x1c(%ebp)
  800890:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800894:	7f e6                	jg     80087c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800896:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800899:	bb 00 00 00 00       	mov    $0x0,%ebx
  80089e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008a4:	53                   	push   %ebx
  8008a5:	51                   	push   %ecx
  8008a6:	52                   	push   %edx
  8008a7:	50                   	push   %eax
  8008a8:	e8 b7 1f 00 00       	call   802864 <__umoddi3>
  8008ad:	83 c4 10             	add    $0x10,%esp
  8008b0:	05 f4 2d 80 00       	add    $0x802df4,%eax
  8008b5:	8a 00                	mov    (%eax),%al
  8008b7:	0f be c0             	movsbl %al,%eax
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	ff 75 0c             	pushl  0xc(%ebp)
  8008c0:	50                   	push   %eax
  8008c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c4:	ff d0                	call   *%eax
  8008c6:	83 c4 10             	add    $0x10,%esp
}
  8008c9:	90                   	nop
  8008ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008cd:	c9                   	leave  
  8008ce:	c3                   	ret    

008008cf <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008cf:	55                   	push   %ebp
  8008d0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008d2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008d6:	7e 1c                	jle    8008f4 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008db:	8b 00                	mov    (%eax),%eax
  8008dd:	8d 50 08             	lea    0x8(%eax),%edx
  8008e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e3:	89 10                	mov    %edx,(%eax)
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	8b 00                	mov    (%eax),%eax
  8008ea:	83 e8 08             	sub    $0x8,%eax
  8008ed:	8b 50 04             	mov    0x4(%eax),%edx
  8008f0:	8b 00                	mov    (%eax),%eax
  8008f2:	eb 40                	jmp    800934 <getuint+0x65>
	else if (lflag)
  8008f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008f8:	74 1e                	je     800918 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fd:	8b 00                	mov    (%eax),%eax
  8008ff:	8d 50 04             	lea    0x4(%eax),%edx
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
  800905:	89 10                	mov    %edx,(%eax)
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	8b 00                	mov    (%eax),%eax
  80090c:	83 e8 04             	sub    $0x4,%eax
  80090f:	8b 00                	mov    (%eax),%eax
  800911:	ba 00 00 00 00       	mov    $0x0,%edx
  800916:	eb 1c                	jmp    800934 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800918:	8b 45 08             	mov    0x8(%ebp),%eax
  80091b:	8b 00                	mov    (%eax),%eax
  80091d:	8d 50 04             	lea    0x4(%eax),%edx
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	89 10                	mov    %edx,(%eax)
  800925:	8b 45 08             	mov    0x8(%ebp),%eax
  800928:	8b 00                	mov    (%eax),%eax
  80092a:	83 e8 04             	sub    $0x4,%eax
  80092d:	8b 00                	mov    (%eax),%eax
  80092f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800934:	5d                   	pop    %ebp
  800935:	c3                   	ret    

00800936 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800936:	55                   	push   %ebp
  800937:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800939:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80093d:	7e 1c                	jle    80095b <getint+0x25>
		return va_arg(*ap, long long);
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	8b 00                	mov    (%eax),%eax
  800944:	8d 50 08             	lea    0x8(%eax),%edx
  800947:	8b 45 08             	mov    0x8(%ebp),%eax
  80094a:	89 10                	mov    %edx,(%eax)
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	8b 00                	mov    (%eax),%eax
  800951:	83 e8 08             	sub    $0x8,%eax
  800954:	8b 50 04             	mov    0x4(%eax),%edx
  800957:	8b 00                	mov    (%eax),%eax
  800959:	eb 38                	jmp    800993 <getint+0x5d>
	else if (lflag)
  80095b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80095f:	74 1a                	je     80097b <getint+0x45>
		return va_arg(*ap, long);
  800961:	8b 45 08             	mov    0x8(%ebp),%eax
  800964:	8b 00                	mov    (%eax),%eax
  800966:	8d 50 04             	lea    0x4(%eax),%edx
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	89 10                	mov    %edx,(%eax)
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	8b 00                	mov    (%eax),%eax
  800973:	83 e8 04             	sub    $0x4,%eax
  800976:	8b 00                	mov    (%eax),%eax
  800978:	99                   	cltd   
  800979:	eb 18                	jmp    800993 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80097b:	8b 45 08             	mov    0x8(%ebp),%eax
  80097e:	8b 00                	mov    (%eax),%eax
  800980:	8d 50 04             	lea    0x4(%eax),%edx
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	89 10                	mov    %edx,(%eax)
  800988:	8b 45 08             	mov    0x8(%ebp),%eax
  80098b:	8b 00                	mov    (%eax),%eax
  80098d:	83 e8 04             	sub    $0x4,%eax
  800990:	8b 00                	mov    (%eax),%eax
  800992:	99                   	cltd   
}
  800993:	5d                   	pop    %ebp
  800994:	c3                   	ret    

00800995 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
  800998:	56                   	push   %esi
  800999:	53                   	push   %ebx
  80099a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80099d:	eb 17                	jmp    8009b6 <vprintfmt+0x21>
			if (ch == '\0')
  80099f:	85 db                	test   %ebx,%ebx
  8009a1:	0f 84 af 03 00 00    	je     800d56 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8009a7:	83 ec 08             	sub    $0x8,%esp
  8009aa:	ff 75 0c             	pushl  0xc(%ebp)
  8009ad:	53                   	push   %ebx
  8009ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b1:	ff d0                	call   *%eax
  8009b3:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b9:	8d 50 01             	lea    0x1(%eax),%edx
  8009bc:	89 55 10             	mov    %edx,0x10(%ebp)
  8009bf:	8a 00                	mov    (%eax),%al
  8009c1:	0f b6 d8             	movzbl %al,%ebx
  8009c4:	83 fb 25             	cmp    $0x25,%ebx
  8009c7:	75 d6                	jne    80099f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009c9:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009cd:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009d4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009db:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009e2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ec:	8d 50 01             	lea    0x1(%eax),%edx
  8009ef:	89 55 10             	mov    %edx,0x10(%ebp)
  8009f2:	8a 00                	mov    (%eax),%al
  8009f4:	0f b6 d8             	movzbl %al,%ebx
  8009f7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009fa:	83 f8 55             	cmp    $0x55,%eax
  8009fd:	0f 87 2b 03 00 00    	ja     800d2e <vprintfmt+0x399>
  800a03:	8b 04 85 18 2e 80 00 	mov    0x802e18(,%eax,4),%eax
  800a0a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a0c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a10:	eb d7                	jmp    8009e9 <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a12:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a16:	eb d1                	jmp    8009e9 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a18:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a1f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a22:	89 d0                	mov    %edx,%eax
  800a24:	c1 e0 02             	shl    $0x2,%eax
  800a27:	01 d0                	add    %edx,%eax
  800a29:	01 c0                	add    %eax,%eax
  800a2b:	01 d8                	add    %ebx,%eax
  800a2d:	83 e8 30             	sub    $0x30,%eax
  800a30:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a33:	8b 45 10             	mov    0x10(%ebp),%eax
  800a36:	8a 00                	mov    (%eax),%al
  800a38:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a3b:	83 fb 2f             	cmp    $0x2f,%ebx
  800a3e:	7e 3e                	jle    800a7e <vprintfmt+0xe9>
  800a40:	83 fb 39             	cmp    $0x39,%ebx
  800a43:	7f 39                	jg     800a7e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a45:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a48:	eb d5                	jmp    800a1f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4d:	83 c0 04             	add    $0x4,%eax
  800a50:	89 45 14             	mov    %eax,0x14(%ebp)
  800a53:	8b 45 14             	mov    0x14(%ebp),%eax
  800a56:	83 e8 04             	sub    $0x4,%eax
  800a59:	8b 00                	mov    (%eax),%eax
  800a5b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a5e:	eb 1f                	jmp    800a7f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a60:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a64:	79 83                	jns    8009e9 <vprintfmt+0x54>
				width = 0;
  800a66:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a6d:	e9 77 ff ff ff       	jmp    8009e9 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a72:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a79:	e9 6b ff ff ff       	jmp    8009e9 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a7e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a7f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a83:	0f 89 60 ff ff ff    	jns    8009e9 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a8c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a8f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a96:	e9 4e ff ff ff       	jmp    8009e9 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a9b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a9e:	e9 46 ff ff ff       	jmp    8009e9 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800aa3:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa6:	83 c0 04             	add    $0x4,%eax
  800aa9:	89 45 14             	mov    %eax,0x14(%ebp)
  800aac:	8b 45 14             	mov    0x14(%ebp),%eax
  800aaf:	83 e8 04             	sub    $0x4,%eax
  800ab2:	8b 00                	mov    (%eax),%eax
  800ab4:	83 ec 08             	sub    $0x8,%esp
  800ab7:	ff 75 0c             	pushl  0xc(%ebp)
  800aba:	50                   	push   %eax
  800abb:	8b 45 08             	mov    0x8(%ebp),%eax
  800abe:	ff d0                	call   *%eax
  800ac0:	83 c4 10             	add    $0x10,%esp
			break;
  800ac3:	e9 89 02 00 00       	jmp    800d51 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ac8:	8b 45 14             	mov    0x14(%ebp),%eax
  800acb:	83 c0 04             	add    $0x4,%eax
  800ace:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad4:	83 e8 04             	sub    $0x4,%eax
  800ad7:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ad9:	85 db                	test   %ebx,%ebx
  800adb:	79 02                	jns    800adf <vprintfmt+0x14a>
				err = -err;
  800add:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800adf:	83 fb 64             	cmp    $0x64,%ebx
  800ae2:	7f 0b                	jg     800aef <vprintfmt+0x15a>
  800ae4:	8b 34 9d 60 2c 80 00 	mov    0x802c60(,%ebx,4),%esi
  800aeb:	85 f6                	test   %esi,%esi
  800aed:	75 19                	jne    800b08 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aef:	53                   	push   %ebx
  800af0:	68 05 2e 80 00       	push   $0x802e05
  800af5:	ff 75 0c             	pushl  0xc(%ebp)
  800af8:	ff 75 08             	pushl  0x8(%ebp)
  800afb:	e8 5e 02 00 00       	call   800d5e <printfmt>
  800b00:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b03:	e9 49 02 00 00       	jmp    800d51 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b08:	56                   	push   %esi
  800b09:	68 0e 2e 80 00       	push   $0x802e0e
  800b0e:	ff 75 0c             	pushl  0xc(%ebp)
  800b11:	ff 75 08             	pushl  0x8(%ebp)
  800b14:	e8 45 02 00 00       	call   800d5e <printfmt>
  800b19:	83 c4 10             	add    $0x10,%esp
			break;
  800b1c:	e9 30 02 00 00       	jmp    800d51 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b21:	8b 45 14             	mov    0x14(%ebp),%eax
  800b24:	83 c0 04             	add    $0x4,%eax
  800b27:	89 45 14             	mov    %eax,0x14(%ebp)
  800b2a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2d:	83 e8 04             	sub    $0x4,%eax
  800b30:	8b 30                	mov    (%eax),%esi
  800b32:	85 f6                	test   %esi,%esi
  800b34:	75 05                	jne    800b3b <vprintfmt+0x1a6>
				p = "(null)";
  800b36:	be 11 2e 80 00       	mov    $0x802e11,%esi
			if (width > 0 && padc != '-')
  800b3b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b3f:	7e 6d                	jle    800bae <vprintfmt+0x219>
  800b41:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b45:	74 67                	je     800bae <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b47:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b4a:	83 ec 08             	sub    $0x8,%esp
  800b4d:	50                   	push   %eax
  800b4e:	56                   	push   %esi
  800b4f:	e8 12 05 00 00       	call   801066 <strnlen>
  800b54:	83 c4 10             	add    $0x10,%esp
  800b57:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b5a:	eb 16                	jmp    800b72 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b5c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b60:	83 ec 08             	sub    $0x8,%esp
  800b63:	ff 75 0c             	pushl  0xc(%ebp)
  800b66:	50                   	push   %eax
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	ff d0                	call   *%eax
  800b6c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b6f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b72:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b76:	7f e4                	jg     800b5c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b78:	eb 34                	jmp    800bae <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b7a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b7e:	74 1c                	je     800b9c <vprintfmt+0x207>
  800b80:	83 fb 1f             	cmp    $0x1f,%ebx
  800b83:	7e 05                	jle    800b8a <vprintfmt+0x1f5>
  800b85:	83 fb 7e             	cmp    $0x7e,%ebx
  800b88:	7e 12                	jle    800b9c <vprintfmt+0x207>
					putch('?', putdat);
  800b8a:	83 ec 08             	sub    $0x8,%esp
  800b8d:	ff 75 0c             	pushl  0xc(%ebp)
  800b90:	6a 3f                	push   $0x3f
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	ff d0                	call   *%eax
  800b97:	83 c4 10             	add    $0x10,%esp
  800b9a:	eb 0f                	jmp    800bab <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b9c:	83 ec 08             	sub    $0x8,%esp
  800b9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ba2:	53                   	push   %ebx
  800ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba6:	ff d0                	call   *%eax
  800ba8:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bab:	ff 4d e4             	decl   -0x1c(%ebp)
  800bae:	89 f0                	mov    %esi,%eax
  800bb0:	8d 70 01             	lea    0x1(%eax),%esi
  800bb3:	8a 00                	mov    (%eax),%al
  800bb5:	0f be d8             	movsbl %al,%ebx
  800bb8:	85 db                	test   %ebx,%ebx
  800bba:	74 24                	je     800be0 <vprintfmt+0x24b>
  800bbc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bc0:	78 b8                	js     800b7a <vprintfmt+0x1e5>
  800bc2:	ff 4d e0             	decl   -0x20(%ebp)
  800bc5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bc9:	79 af                	jns    800b7a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bcb:	eb 13                	jmp    800be0 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bcd:	83 ec 08             	sub    $0x8,%esp
  800bd0:	ff 75 0c             	pushl  0xc(%ebp)
  800bd3:	6a 20                	push   $0x20
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	ff d0                	call   *%eax
  800bda:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bdd:	ff 4d e4             	decl   -0x1c(%ebp)
  800be0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800be4:	7f e7                	jg     800bcd <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800be6:	e9 66 01 00 00       	jmp    800d51 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800beb:	83 ec 08             	sub    $0x8,%esp
  800bee:	ff 75 e8             	pushl  -0x18(%ebp)
  800bf1:	8d 45 14             	lea    0x14(%ebp),%eax
  800bf4:	50                   	push   %eax
  800bf5:	e8 3c fd ff ff       	call   800936 <getint>
  800bfa:	83 c4 10             	add    $0x10,%esp
  800bfd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c00:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c09:	85 d2                	test   %edx,%edx
  800c0b:	79 23                	jns    800c30 <vprintfmt+0x29b>
				putch('-', putdat);
  800c0d:	83 ec 08             	sub    $0x8,%esp
  800c10:	ff 75 0c             	pushl  0xc(%ebp)
  800c13:	6a 2d                	push   $0x2d
  800c15:	8b 45 08             	mov    0x8(%ebp),%eax
  800c18:	ff d0                	call   *%eax
  800c1a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c23:	f7 d8                	neg    %eax
  800c25:	83 d2 00             	adc    $0x0,%edx
  800c28:	f7 da                	neg    %edx
  800c2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c2d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c30:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c37:	e9 bc 00 00 00       	jmp    800cf8 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c3c:	83 ec 08             	sub    $0x8,%esp
  800c3f:	ff 75 e8             	pushl  -0x18(%ebp)
  800c42:	8d 45 14             	lea    0x14(%ebp),%eax
  800c45:	50                   	push   %eax
  800c46:	e8 84 fc ff ff       	call   8008cf <getuint>
  800c4b:	83 c4 10             	add    $0x10,%esp
  800c4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c51:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c54:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c5b:	e9 98 00 00 00       	jmp    800cf8 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c60:	83 ec 08             	sub    $0x8,%esp
  800c63:	ff 75 0c             	pushl  0xc(%ebp)
  800c66:	6a 58                	push   $0x58
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6b:	ff d0                	call   *%eax
  800c6d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c70:	83 ec 08             	sub    $0x8,%esp
  800c73:	ff 75 0c             	pushl  0xc(%ebp)
  800c76:	6a 58                	push   $0x58
  800c78:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7b:	ff d0                	call   *%eax
  800c7d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c80:	83 ec 08             	sub    $0x8,%esp
  800c83:	ff 75 0c             	pushl  0xc(%ebp)
  800c86:	6a 58                	push   $0x58
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8b:	ff d0                	call   *%eax
  800c8d:	83 c4 10             	add    $0x10,%esp
			break;
  800c90:	e9 bc 00 00 00       	jmp    800d51 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c95:	83 ec 08             	sub    $0x8,%esp
  800c98:	ff 75 0c             	pushl  0xc(%ebp)
  800c9b:	6a 30                	push   $0x30
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	ff d0                	call   *%eax
  800ca2:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ca5:	83 ec 08             	sub    $0x8,%esp
  800ca8:	ff 75 0c             	pushl  0xc(%ebp)
  800cab:	6a 78                	push   $0x78
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	ff d0                	call   *%eax
  800cb2:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cb5:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb8:	83 c0 04             	add    $0x4,%eax
  800cbb:	89 45 14             	mov    %eax,0x14(%ebp)
  800cbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc1:	83 e8 04             	sub    $0x4,%eax
  800cc4:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cd0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cd7:	eb 1f                	jmp    800cf8 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cd9:	83 ec 08             	sub    $0x8,%esp
  800cdc:	ff 75 e8             	pushl  -0x18(%ebp)
  800cdf:	8d 45 14             	lea    0x14(%ebp),%eax
  800ce2:	50                   	push   %eax
  800ce3:	e8 e7 fb ff ff       	call   8008cf <getuint>
  800ce8:	83 c4 10             	add    $0x10,%esp
  800ceb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cee:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cf1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cf8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cfc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cff:	83 ec 04             	sub    $0x4,%esp
  800d02:	52                   	push   %edx
  800d03:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d06:	50                   	push   %eax
  800d07:	ff 75 f4             	pushl  -0xc(%ebp)
  800d0a:	ff 75 f0             	pushl  -0x10(%ebp)
  800d0d:	ff 75 0c             	pushl  0xc(%ebp)
  800d10:	ff 75 08             	pushl  0x8(%ebp)
  800d13:	e8 00 fb ff ff       	call   800818 <printnum>
  800d18:	83 c4 20             	add    $0x20,%esp
			break;
  800d1b:	eb 34                	jmp    800d51 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d1d:	83 ec 08             	sub    $0x8,%esp
  800d20:	ff 75 0c             	pushl  0xc(%ebp)
  800d23:	53                   	push   %ebx
  800d24:	8b 45 08             	mov    0x8(%ebp),%eax
  800d27:	ff d0                	call   *%eax
  800d29:	83 c4 10             	add    $0x10,%esp
			break;
  800d2c:	eb 23                	jmp    800d51 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d2e:	83 ec 08             	sub    $0x8,%esp
  800d31:	ff 75 0c             	pushl  0xc(%ebp)
  800d34:	6a 25                	push   $0x25
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	ff d0                	call   *%eax
  800d3b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d3e:	ff 4d 10             	decl   0x10(%ebp)
  800d41:	eb 03                	jmp    800d46 <vprintfmt+0x3b1>
  800d43:	ff 4d 10             	decl   0x10(%ebp)
  800d46:	8b 45 10             	mov    0x10(%ebp),%eax
  800d49:	48                   	dec    %eax
  800d4a:	8a 00                	mov    (%eax),%al
  800d4c:	3c 25                	cmp    $0x25,%al
  800d4e:	75 f3                	jne    800d43 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d50:	90                   	nop
		}
	}
  800d51:	e9 47 fc ff ff       	jmp    80099d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d56:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d57:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d5a:	5b                   	pop    %ebx
  800d5b:	5e                   	pop    %esi
  800d5c:	5d                   	pop    %ebp
  800d5d:	c3                   	ret    

00800d5e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d64:	8d 45 10             	lea    0x10(%ebp),%eax
  800d67:	83 c0 04             	add    $0x4,%eax
  800d6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d70:	ff 75 f4             	pushl  -0xc(%ebp)
  800d73:	50                   	push   %eax
  800d74:	ff 75 0c             	pushl  0xc(%ebp)
  800d77:	ff 75 08             	pushl  0x8(%ebp)
  800d7a:	e8 16 fc ff ff       	call   800995 <vprintfmt>
  800d7f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d82:	90                   	nop
  800d83:	c9                   	leave  
  800d84:	c3                   	ret    

00800d85 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8b:	8b 40 08             	mov    0x8(%eax),%eax
  800d8e:	8d 50 01             	lea    0x1(%eax),%edx
  800d91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d94:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9a:	8b 10                	mov    (%eax),%edx
  800d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9f:	8b 40 04             	mov    0x4(%eax),%eax
  800da2:	39 c2                	cmp    %eax,%edx
  800da4:	73 12                	jae    800db8 <sprintputch+0x33>
		*b->buf++ = ch;
  800da6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da9:	8b 00                	mov    (%eax),%eax
  800dab:	8d 48 01             	lea    0x1(%eax),%ecx
  800dae:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db1:	89 0a                	mov    %ecx,(%edx)
  800db3:	8b 55 08             	mov    0x8(%ebp),%edx
  800db6:	88 10                	mov    %dl,(%eax)
}
  800db8:	90                   	nop
  800db9:	5d                   	pop    %ebp
  800dba:	c3                   	ret    

00800dbb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dbb:	55                   	push   %ebp
  800dbc:	89 e5                	mov    %esp,%ebp
  800dbe:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dca:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	01 d0                	add    %edx,%eax
  800dd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dd5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ddc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800de0:	74 06                	je     800de8 <vsnprintf+0x2d>
  800de2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800de6:	7f 07                	jg     800def <vsnprintf+0x34>
		return -E_INVAL;
  800de8:	b8 03 00 00 00       	mov    $0x3,%eax
  800ded:	eb 20                	jmp    800e0f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800def:	ff 75 14             	pushl  0x14(%ebp)
  800df2:	ff 75 10             	pushl  0x10(%ebp)
  800df5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800df8:	50                   	push   %eax
  800df9:	68 85 0d 80 00       	push   $0x800d85
  800dfe:	e8 92 fb ff ff       	call   800995 <vprintfmt>
  800e03:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e09:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e0f:	c9                   	leave  
  800e10:	c3                   	ret    

00800e11 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e11:	55                   	push   %ebp
  800e12:	89 e5                	mov    %esp,%ebp
  800e14:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e17:	8d 45 10             	lea    0x10(%ebp),%eax
  800e1a:	83 c0 04             	add    $0x4,%eax
  800e1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e20:	8b 45 10             	mov    0x10(%ebp),%eax
  800e23:	ff 75 f4             	pushl  -0xc(%ebp)
  800e26:	50                   	push   %eax
  800e27:	ff 75 0c             	pushl  0xc(%ebp)
  800e2a:	ff 75 08             	pushl  0x8(%ebp)
  800e2d:	e8 89 ff ff ff       	call   800dbb <vsnprintf>
  800e32:	83 c4 10             	add    $0x10,%esp
  800e35:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e38:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e3b:	c9                   	leave  
  800e3c:	c3                   	ret    

00800e3d <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  800e43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e47:	74 13                	je     800e5c <readline+0x1f>
		cprintf("%s", prompt);
  800e49:	83 ec 08             	sub    $0x8,%esp
  800e4c:	ff 75 08             	pushl  0x8(%ebp)
  800e4f:	68 70 2f 80 00       	push   $0x802f70
  800e54:	e8 69 f9 ff ff       	call   8007c2 <cprintf>
  800e59:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800e5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800e63:	83 ec 0c             	sub    $0xc,%esp
  800e66:	6a 00                	push   $0x0
  800e68:	e8 5f f7 ff ff       	call   8005cc <iscons>
  800e6d:	83 c4 10             	add    $0x10,%esp
  800e70:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800e73:	e8 06 f7 ff ff       	call   80057e <getchar>
  800e78:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800e7b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e7f:	79 22                	jns    800ea3 <readline+0x66>
			if (c != -E_EOF)
  800e81:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800e85:	0f 84 ad 00 00 00    	je     800f38 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800e8b:	83 ec 08             	sub    $0x8,%esp
  800e8e:	ff 75 ec             	pushl  -0x14(%ebp)
  800e91:	68 73 2f 80 00       	push   $0x802f73
  800e96:	e8 27 f9 ff ff       	call   8007c2 <cprintf>
  800e9b:	83 c4 10             	add    $0x10,%esp
			return;
  800e9e:	e9 95 00 00 00       	jmp    800f38 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800ea3:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800ea7:	7e 34                	jle    800edd <readline+0xa0>
  800ea9:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800eb0:	7f 2b                	jg     800edd <readline+0xa0>
			if (echoing)
  800eb2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800eb6:	74 0e                	je     800ec6 <readline+0x89>
				cputchar(c);
  800eb8:	83 ec 0c             	sub    $0xc,%esp
  800ebb:	ff 75 ec             	pushl  -0x14(%ebp)
  800ebe:	e8 73 f6 ff ff       	call   800536 <cputchar>
  800ec3:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ec9:	8d 50 01             	lea    0x1(%eax),%edx
  800ecc:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800ecf:	89 c2                	mov    %eax,%edx
  800ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed4:	01 d0                	add    %edx,%eax
  800ed6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ed9:	88 10                	mov    %dl,(%eax)
  800edb:	eb 56                	jmp    800f33 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800edd:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800ee1:	75 1f                	jne    800f02 <readline+0xc5>
  800ee3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800ee7:	7e 19                	jle    800f02 <readline+0xc5>
			if (echoing)
  800ee9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800eed:	74 0e                	je     800efd <readline+0xc0>
				cputchar(c);
  800eef:	83 ec 0c             	sub    $0xc,%esp
  800ef2:	ff 75 ec             	pushl  -0x14(%ebp)
  800ef5:	e8 3c f6 ff ff       	call   800536 <cputchar>
  800efa:	83 c4 10             	add    $0x10,%esp

			i--;
  800efd:	ff 4d f4             	decl   -0xc(%ebp)
  800f00:	eb 31                	jmp    800f33 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800f02:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800f06:	74 0a                	je     800f12 <readline+0xd5>
  800f08:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800f0c:	0f 85 61 ff ff ff    	jne    800e73 <readline+0x36>
			if (echoing)
  800f12:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f16:	74 0e                	je     800f26 <readline+0xe9>
				cputchar(c);
  800f18:	83 ec 0c             	sub    $0xc,%esp
  800f1b:	ff 75 ec             	pushl  -0x14(%ebp)
  800f1e:	e8 13 f6 ff ff       	call   800536 <cputchar>
  800f23:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800f26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2c:	01 d0                	add    %edx,%eax
  800f2e:	c6 00 00             	movb   $0x0,(%eax)
			return;
  800f31:	eb 06                	jmp    800f39 <readline+0xfc>
		}
	}
  800f33:	e9 3b ff ff ff       	jmp    800e73 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  800f38:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  800f39:	c9                   	leave  
  800f3a:	c3                   	ret    

00800f3b <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800f3b:	55                   	push   %ebp
  800f3c:	89 e5                	mov    %esp,%ebp
  800f3e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f41:	e8 71 14 00 00       	call   8023b7 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  800f46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f4a:	74 13                	je     800f5f <atomic_readline+0x24>
		cprintf("%s", prompt);
  800f4c:	83 ec 08             	sub    $0x8,%esp
  800f4f:	ff 75 08             	pushl  0x8(%ebp)
  800f52:	68 70 2f 80 00       	push   $0x802f70
  800f57:	e8 66 f8 ff ff       	call   8007c2 <cprintf>
  800f5c:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800f5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800f66:	83 ec 0c             	sub    $0xc,%esp
  800f69:	6a 00                	push   $0x0
  800f6b:	e8 5c f6 ff ff       	call   8005cc <iscons>
  800f70:	83 c4 10             	add    $0x10,%esp
  800f73:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800f76:	e8 03 f6 ff ff       	call   80057e <getchar>
  800f7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800f7e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800f82:	79 23                	jns    800fa7 <atomic_readline+0x6c>
			if (c != -E_EOF)
  800f84:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800f88:	74 13                	je     800f9d <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  800f8a:	83 ec 08             	sub    $0x8,%esp
  800f8d:	ff 75 ec             	pushl  -0x14(%ebp)
  800f90:	68 73 2f 80 00       	push   $0x802f73
  800f95:	e8 28 f8 ff ff       	call   8007c2 <cprintf>
  800f9a:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800f9d:	e8 2f 14 00 00       	call   8023d1 <sys_enable_interrupt>
			return;
  800fa2:	e9 9a 00 00 00       	jmp    801041 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800fa7:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800fab:	7e 34                	jle    800fe1 <atomic_readline+0xa6>
  800fad:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800fb4:	7f 2b                	jg     800fe1 <atomic_readline+0xa6>
			if (echoing)
  800fb6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fba:	74 0e                	je     800fca <atomic_readline+0x8f>
				cputchar(c);
  800fbc:	83 ec 0c             	sub    $0xc,%esp
  800fbf:	ff 75 ec             	pushl  -0x14(%ebp)
  800fc2:	e8 6f f5 ff ff       	call   800536 <cputchar>
  800fc7:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fcd:	8d 50 01             	lea    0x1(%eax),%edx
  800fd0:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800fd3:	89 c2                	mov    %eax,%edx
  800fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd8:	01 d0                	add    %edx,%eax
  800fda:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fdd:	88 10                	mov    %dl,(%eax)
  800fdf:	eb 5b                	jmp    80103c <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  800fe1:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800fe5:	75 1f                	jne    801006 <atomic_readline+0xcb>
  800fe7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800feb:	7e 19                	jle    801006 <atomic_readline+0xcb>
			if (echoing)
  800fed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ff1:	74 0e                	je     801001 <atomic_readline+0xc6>
				cputchar(c);
  800ff3:	83 ec 0c             	sub    $0xc,%esp
  800ff6:	ff 75 ec             	pushl  -0x14(%ebp)
  800ff9:	e8 38 f5 ff ff       	call   800536 <cputchar>
  800ffe:	83 c4 10             	add    $0x10,%esp
			i--;
  801001:	ff 4d f4             	decl   -0xc(%ebp)
  801004:	eb 36                	jmp    80103c <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801006:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80100a:	74 0a                	je     801016 <atomic_readline+0xdb>
  80100c:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801010:	0f 85 60 ff ff ff    	jne    800f76 <atomic_readline+0x3b>
			if (echoing)
  801016:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80101a:	74 0e                	je     80102a <atomic_readline+0xef>
				cputchar(c);
  80101c:	83 ec 0c             	sub    $0xc,%esp
  80101f:	ff 75 ec             	pushl  -0x14(%ebp)
  801022:	e8 0f f5 ff ff       	call   800536 <cputchar>
  801027:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  80102a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80102d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801030:	01 d0                	add    %edx,%eax
  801032:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  801035:	e8 97 13 00 00       	call   8023d1 <sys_enable_interrupt>
			return;
  80103a:	eb 05                	jmp    801041 <atomic_readline+0x106>
		}
	}
  80103c:	e9 35 ff ff ff       	jmp    800f76 <atomic_readline+0x3b>
}
  801041:	c9                   	leave  
  801042:	c3                   	ret    

00801043 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801043:	55                   	push   %ebp
  801044:	89 e5                	mov    %esp,%ebp
  801046:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801049:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801050:	eb 06                	jmp    801058 <strlen+0x15>
		n++;
  801052:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801055:	ff 45 08             	incl   0x8(%ebp)
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	84 c0                	test   %al,%al
  80105f:	75 f1                	jne    801052 <strlen+0xf>
		n++;
	return n;
  801061:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80106c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801073:	eb 09                	jmp    80107e <strnlen+0x18>
		n++;
  801075:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801078:	ff 45 08             	incl   0x8(%ebp)
  80107b:	ff 4d 0c             	decl   0xc(%ebp)
  80107e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801082:	74 09                	je     80108d <strnlen+0x27>
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	8a 00                	mov    (%eax),%al
  801089:	84 c0                	test   %al,%al
  80108b:	75 e8                	jne    801075 <strnlen+0xf>
		n++;
	return n;
  80108d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801090:	c9                   	leave  
  801091:	c3                   	ret    

00801092 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801092:	55                   	push   %ebp
  801093:	89 e5                	mov    %esp,%ebp
  801095:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80109e:	90                   	nop
  80109f:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a2:	8d 50 01             	lea    0x1(%eax),%edx
  8010a5:	89 55 08             	mov    %edx,0x8(%ebp)
  8010a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ab:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ae:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010b1:	8a 12                	mov    (%edx),%dl
  8010b3:	88 10                	mov    %dl,(%eax)
  8010b5:	8a 00                	mov    (%eax),%al
  8010b7:	84 c0                	test   %al,%al
  8010b9:	75 e4                	jne    80109f <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010be:	c9                   	leave  
  8010bf:	c3                   	ret    

008010c0 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010c0:	55                   	push   %ebp
  8010c1:	89 e5                	mov    %esp,%ebp
  8010c3:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010d3:	eb 1f                	jmp    8010f4 <strncpy+0x34>
		*dst++ = *src;
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d8:	8d 50 01             	lea    0x1(%eax),%edx
  8010db:	89 55 08             	mov    %edx,0x8(%ebp)
  8010de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010e1:	8a 12                	mov    (%edx),%dl
  8010e3:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e8:	8a 00                	mov    (%eax),%al
  8010ea:	84 c0                	test   %al,%al
  8010ec:	74 03                	je     8010f1 <strncpy+0x31>
			src++;
  8010ee:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010f1:	ff 45 fc             	incl   -0x4(%ebp)
  8010f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010fa:	72 d9                	jb     8010d5 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010ff:	c9                   	leave  
  801100:	c3                   	ret    

00801101 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801101:	55                   	push   %ebp
  801102:	89 e5                	mov    %esp,%ebp
  801104:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80110d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801111:	74 30                	je     801143 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801113:	eb 16                	jmp    80112b <strlcpy+0x2a>
			*dst++ = *src++;
  801115:	8b 45 08             	mov    0x8(%ebp),%eax
  801118:	8d 50 01             	lea    0x1(%eax),%edx
  80111b:	89 55 08             	mov    %edx,0x8(%ebp)
  80111e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801121:	8d 4a 01             	lea    0x1(%edx),%ecx
  801124:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801127:	8a 12                	mov    (%edx),%dl
  801129:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80112b:	ff 4d 10             	decl   0x10(%ebp)
  80112e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801132:	74 09                	je     80113d <strlcpy+0x3c>
  801134:	8b 45 0c             	mov    0xc(%ebp),%eax
  801137:	8a 00                	mov    (%eax),%al
  801139:	84 c0                	test   %al,%al
  80113b:	75 d8                	jne    801115 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80113d:	8b 45 08             	mov    0x8(%ebp),%eax
  801140:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801143:	8b 55 08             	mov    0x8(%ebp),%edx
  801146:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801149:	29 c2                	sub    %eax,%edx
  80114b:	89 d0                	mov    %edx,%eax
}
  80114d:	c9                   	leave  
  80114e:	c3                   	ret    

0080114f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80114f:	55                   	push   %ebp
  801150:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801152:	eb 06                	jmp    80115a <strcmp+0xb>
		p++, q++;
  801154:	ff 45 08             	incl   0x8(%ebp)
  801157:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	84 c0                	test   %al,%al
  801161:	74 0e                	je     801171 <strcmp+0x22>
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	8a 10                	mov    (%eax),%dl
  801168:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	38 c2                	cmp    %al,%dl
  80116f:	74 e3                	je     801154 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	8a 00                	mov    (%eax),%al
  801176:	0f b6 d0             	movzbl %al,%edx
  801179:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117c:	8a 00                	mov    (%eax),%al
  80117e:	0f b6 c0             	movzbl %al,%eax
  801181:	29 c2                	sub    %eax,%edx
  801183:	89 d0                	mov    %edx,%eax
}
  801185:	5d                   	pop    %ebp
  801186:	c3                   	ret    

00801187 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801187:	55                   	push   %ebp
  801188:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80118a:	eb 09                	jmp    801195 <strncmp+0xe>
		n--, p++, q++;
  80118c:	ff 4d 10             	decl   0x10(%ebp)
  80118f:	ff 45 08             	incl   0x8(%ebp)
  801192:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801195:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801199:	74 17                	je     8011b2 <strncmp+0x2b>
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
  80119e:	8a 00                	mov    (%eax),%al
  8011a0:	84 c0                	test   %al,%al
  8011a2:	74 0e                	je     8011b2 <strncmp+0x2b>
  8011a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a7:	8a 10                	mov    (%eax),%dl
  8011a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ac:	8a 00                	mov    (%eax),%al
  8011ae:	38 c2                	cmp    %al,%dl
  8011b0:	74 da                	je     80118c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b6:	75 07                	jne    8011bf <strncmp+0x38>
		return 0;
  8011b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8011bd:	eb 14                	jmp    8011d3 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c2:	8a 00                	mov    (%eax),%al
  8011c4:	0f b6 d0             	movzbl %al,%edx
  8011c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ca:	8a 00                	mov    (%eax),%al
  8011cc:	0f b6 c0             	movzbl %al,%eax
  8011cf:	29 c2                	sub    %eax,%edx
  8011d1:	89 d0                	mov    %edx,%eax
}
  8011d3:	5d                   	pop    %ebp
  8011d4:	c3                   	ret    

008011d5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011d5:	55                   	push   %ebp
  8011d6:	89 e5                	mov    %esp,%ebp
  8011d8:	83 ec 04             	sub    $0x4,%esp
  8011db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011de:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011e1:	eb 12                	jmp    8011f5 <strchr+0x20>
		if (*s == c)
  8011e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e6:	8a 00                	mov    (%eax),%al
  8011e8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011eb:	75 05                	jne    8011f2 <strchr+0x1d>
			return (char *) s;
  8011ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f0:	eb 11                	jmp    801203 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011f2:	ff 45 08             	incl   0x8(%ebp)
  8011f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f8:	8a 00                	mov    (%eax),%al
  8011fa:	84 c0                	test   %al,%al
  8011fc:	75 e5                	jne    8011e3 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801203:	c9                   	leave  
  801204:	c3                   	ret    

00801205 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
  801208:	83 ec 04             	sub    $0x4,%esp
  80120b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801211:	eb 0d                	jmp    801220 <strfind+0x1b>
		if (*s == c)
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	8a 00                	mov    (%eax),%al
  801218:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80121b:	74 0e                	je     80122b <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80121d:	ff 45 08             	incl   0x8(%ebp)
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	8a 00                	mov    (%eax),%al
  801225:	84 c0                	test   %al,%al
  801227:	75 ea                	jne    801213 <strfind+0xe>
  801229:	eb 01                	jmp    80122c <strfind+0x27>
		if (*s == c)
			break;
  80122b:	90                   	nop
	return (char *) s;
  80122c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80122f:	c9                   	leave  
  801230:	c3                   	ret    

00801231 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801231:	55                   	push   %ebp
  801232:	89 e5                	mov    %esp,%ebp
  801234:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80123d:	8b 45 10             	mov    0x10(%ebp),%eax
  801240:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801243:	eb 0e                	jmp    801253 <memset+0x22>
		*p++ = c;
  801245:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801248:	8d 50 01             	lea    0x1(%eax),%edx
  80124b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80124e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801251:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801253:	ff 4d f8             	decl   -0x8(%ebp)
  801256:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80125a:	79 e9                	jns    801245 <memset+0x14>
		*p++ = c;

	return v;
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80125f:	c9                   	leave  
  801260:	c3                   	ret    

00801261 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801261:	55                   	push   %ebp
  801262:	89 e5                	mov    %esp,%ebp
  801264:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801267:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
  801270:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801273:	eb 16                	jmp    80128b <memcpy+0x2a>
		*d++ = *s++;
  801275:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801278:	8d 50 01             	lea    0x1(%eax),%edx
  80127b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80127e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801281:	8d 4a 01             	lea    0x1(%edx),%ecx
  801284:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801287:	8a 12                	mov    (%edx),%dl
  801289:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80128b:	8b 45 10             	mov    0x10(%ebp),%eax
  80128e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801291:	89 55 10             	mov    %edx,0x10(%ebp)
  801294:	85 c0                	test   %eax,%eax
  801296:	75 dd                	jne    801275 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801298:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80129b:	c9                   	leave  
  80129c:	c3                   	ret    

0080129d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80129d:	55                   	push   %ebp
  80129e:	89 e5                	mov    %esp,%ebp
  8012a0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  8012a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ac:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012b5:	73 50                	jae    801307 <memmove+0x6a>
  8012b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bd:	01 d0                	add    %edx,%eax
  8012bf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012c2:	76 43                	jbe    801307 <memmove+0x6a>
		s += n;
  8012c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c7:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8012ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cd:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012d0:	eb 10                	jmp    8012e2 <memmove+0x45>
			*--d = *--s;
  8012d2:	ff 4d f8             	decl   -0x8(%ebp)
  8012d5:	ff 4d fc             	decl   -0x4(%ebp)
  8012d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012db:	8a 10                	mov    (%eax),%dl
  8012dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e0:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012e8:	89 55 10             	mov    %edx,0x10(%ebp)
  8012eb:	85 c0                	test   %eax,%eax
  8012ed:	75 e3                	jne    8012d2 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012ef:	eb 23                	jmp    801314 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f4:	8d 50 01             	lea    0x1(%eax),%edx
  8012f7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012fd:	8d 4a 01             	lea    0x1(%edx),%ecx
  801300:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801303:	8a 12                	mov    (%edx),%dl
  801305:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801307:	8b 45 10             	mov    0x10(%ebp),%eax
  80130a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80130d:	89 55 10             	mov    %edx,0x10(%ebp)
  801310:	85 c0                	test   %eax,%eax
  801312:	75 dd                	jne    8012f1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801317:	c9                   	leave  
  801318:	c3                   	ret    

00801319 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801319:	55                   	push   %ebp
  80131a:	89 e5                	mov    %esp,%ebp
  80131c:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801325:	8b 45 0c             	mov    0xc(%ebp),%eax
  801328:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80132b:	eb 2a                	jmp    801357 <memcmp+0x3e>
		if (*s1 != *s2)
  80132d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801330:	8a 10                	mov    (%eax),%dl
  801332:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801335:	8a 00                	mov    (%eax),%al
  801337:	38 c2                	cmp    %al,%dl
  801339:	74 16                	je     801351 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80133b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80133e:	8a 00                	mov    (%eax),%al
  801340:	0f b6 d0             	movzbl %al,%edx
  801343:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801346:	8a 00                	mov    (%eax),%al
  801348:	0f b6 c0             	movzbl %al,%eax
  80134b:	29 c2                	sub    %eax,%edx
  80134d:	89 d0                	mov    %edx,%eax
  80134f:	eb 18                	jmp    801369 <memcmp+0x50>
		s1++, s2++;
  801351:	ff 45 fc             	incl   -0x4(%ebp)
  801354:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801357:	8b 45 10             	mov    0x10(%ebp),%eax
  80135a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80135d:	89 55 10             	mov    %edx,0x10(%ebp)
  801360:	85 c0                	test   %eax,%eax
  801362:	75 c9                	jne    80132d <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801364:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801369:	c9                   	leave  
  80136a:	c3                   	ret    

0080136b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80136b:	55                   	push   %ebp
  80136c:	89 e5                	mov    %esp,%ebp
  80136e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801371:	8b 55 08             	mov    0x8(%ebp),%edx
  801374:	8b 45 10             	mov    0x10(%ebp),%eax
  801377:	01 d0                	add    %edx,%eax
  801379:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80137c:	eb 15                	jmp    801393 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80137e:	8b 45 08             	mov    0x8(%ebp),%eax
  801381:	8a 00                	mov    (%eax),%al
  801383:	0f b6 d0             	movzbl %al,%edx
  801386:	8b 45 0c             	mov    0xc(%ebp),%eax
  801389:	0f b6 c0             	movzbl %al,%eax
  80138c:	39 c2                	cmp    %eax,%edx
  80138e:	74 0d                	je     80139d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801390:	ff 45 08             	incl   0x8(%ebp)
  801393:	8b 45 08             	mov    0x8(%ebp),%eax
  801396:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801399:	72 e3                	jb     80137e <memfind+0x13>
  80139b:	eb 01                	jmp    80139e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80139d:	90                   	nop
	return (void *) s;
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013a1:	c9                   	leave  
  8013a2:	c3                   	ret    

008013a3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013a3:	55                   	push   %ebp
  8013a4:	89 e5                	mov    %esp,%ebp
  8013a6:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013b0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013b7:	eb 03                	jmp    8013bc <strtol+0x19>
		s++;
  8013b9:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bf:	8a 00                	mov    (%eax),%al
  8013c1:	3c 20                	cmp    $0x20,%al
  8013c3:	74 f4                	je     8013b9 <strtol+0x16>
  8013c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c8:	8a 00                	mov    (%eax),%al
  8013ca:	3c 09                	cmp    $0x9,%al
  8013cc:	74 eb                	je     8013b9 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d1:	8a 00                	mov    (%eax),%al
  8013d3:	3c 2b                	cmp    $0x2b,%al
  8013d5:	75 05                	jne    8013dc <strtol+0x39>
		s++;
  8013d7:	ff 45 08             	incl   0x8(%ebp)
  8013da:	eb 13                	jmp    8013ef <strtol+0x4c>
	else if (*s == '-')
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	8a 00                	mov    (%eax),%al
  8013e1:	3c 2d                	cmp    $0x2d,%al
  8013e3:	75 0a                	jne    8013ef <strtol+0x4c>
		s++, neg = 1;
  8013e5:	ff 45 08             	incl   0x8(%ebp)
  8013e8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013f3:	74 06                	je     8013fb <strtol+0x58>
  8013f5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013f9:	75 20                	jne    80141b <strtol+0x78>
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	8a 00                	mov    (%eax),%al
  801400:	3c 30                	cmp    $0x30,%al
  801402:	75 17                	jne    80141b <strtol+0x78>
  801404:	8b 45 08             	mov    0x8(%ebp),%eax
  801407:	40                   	inc    %eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	3c 78                	cmp    $0x78,%al
  80140c:	75 0d                	jne    80141b <strtol+0x78>
		s += 2, base = 16;
  80140e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801412:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801419:	eb 28                	jmp    801443 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80141b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80141f:	75 15                	jne    801436 <strtol+0x93>
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	8a 00                	mov    (%eax),%al
  801426:	3c 30                	cmp    $0x30,%al
  801428:	75 0c                	jne    801436 <strtol+0x93>
		s++, base = 8;
  80142a:	ff 45 08             	incl   0x8(%ebp)
  80142d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801434:	eb 0d                	jmp    801443 <strtol+0xa0>
	else if (base == 0)
  801436:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80143a:	75 07                	jne    801443 <strtol+0xa0>
		base = 10;
  80143c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801443:	8b 45 08             	mov    0x8(%ebp),%eax
  801446:	8a 00                	mov    (%eax),%al
  801448:	3c 2f                	cmp    $0x2f,%al
  80144a:	7e 19                	jle    801465 <strtol+0xc2>
  80144c:	8b 45 08             	mov    0x8(%ebp),%eax
  80144f:	8a 00                	mov    (%eax),%al
  801451:	3c 39                	cmp    $0x39,%al
  801453:	7f 10                	jg     801465 <strtol+0xc2>
			dig = *s - '0';
  801455:	8b 45 08             	mov    0x8(%ebp),%eax
  801458:	8a 00                	mov    (%eax),%al
  80145a:	0f be c0             	movsbl %al,%eax
  80145d:	83 e8 30             	sub    $0x30,%eax
  801460:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801463:	eb 42                	jmp    8014a7 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801465:	8b 45 08             	mov    0x8(%ebp),%eax
  801468:	8a 00                	mov    (%eax),%al
  80146a:	3c 60                	cmp    $0x60,%al
  80146c:	7e 19                	jle    801487 <strtol+0xe4>
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	8a 00                	mov    (%eax),%al
  801473:	3c 7a                	cmp    $0x7a,%al
  801475:	7f 10                	jg     801487 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	8a 00                	mov    (%eax),%al
  80147c:	0f be c0             	movsbl %al,%eax
  80147f:	83 e8 57             	sub    $0x57,%eax
  801482:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801485:	eb 20                	jmp    8014a7 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801487:	8b 45 08             	mov    0x8(%ebp),%eax
  80148a:	8a 00                	mov    (%eax),%al
  80148c:	3c 40                	cmp    $0x40,%al
  80148e:	7e 39                	jle    8014c9 <strtol+0x126>
  801490:	8b 45 08             	mov    0x8(%ebp),%eax
  801493:	8a 00                	mov    (%eax),%al
  801495:	3c 5a                	cmp    $0x5a,%al
  801497:	7f 30                	jg     8014c9 <strtol+0x126>
			dig = *s - 'A' + 10;
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	8a 00                	mov    (%eax),%al
  80149e:	0f be c0             	movsbl %al,%eax
  8014a1:	83 e8 37             	sub    $0x37,%eax
  8014a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014aa:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014ad:	7d 19                	jge    8014c8 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014af:	ff 45 08             	incl   0x8(%ebp)
  8014b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014b5:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014b9:	89 c2                	mov    %eax,%edx
  8014bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014be:	01 d0                	add    %edx,%eax
  8014c0:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8014c3:	e9 7b ff ff ff       	jmp    801443 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014c8:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014cd:	74 08                	je     8014d7 <strtol+0x134>
		*endptr = (char *) s;
  8014cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d5:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014db:	74 07                	je     8014e4 <strtol+0x141>
  8014dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014e0:	f7 d8                	neg    %eax
  8014e2:	eb 03                	jmp    8014e7 <strtol+0x144>
  8014e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014e7:	c9                   	leave  
  8014e8:	c3                   	ret    

008014e9 <ltostr>:

void
ltostr(long value, char *str)
{
  8014e9:	55                   	push   %ebp
  8014ea:	89 e5                	mov    %esp,%ebp
  8014ec:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014f6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801501:	79 13                	jns    801516 <ltostr+0x2d>
	{
		neg = 1;
  801503:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80150a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150d:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801510:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801513:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801516:	8b 45 08             	mov    0x8(%ebp),%eax
  801519:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80151e:	99                   	cltd   
  80151f:	f7 f9                	idiv   %ecx
  801521:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801524:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801527:	8d 50 01             	lea    0x1(%eax),%edx
  80152a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80152d:	89 c2                	mov    %eax,%edx
  80152f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801532:	01 d0                	add    %edx,%eax
  801534:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801537:	83 c2 30             	add    $0x30,%edx
  80153a:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80153c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80153f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801544:	f7 e9                	imul   %ecx
  801546:	c1 fa 02             	sar    $0x2,%edx
  801549:	89 c8                	mov    %ecx,%eax
  80154b:	c1 f8 1f             	sar    $0x1f,%eax
  80154e:	29 c2                	sub    %eax,%edx
  801550:	89 d0                	mov    %edx,%eax
  801552:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801555:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801558:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80155d:	f7 e9                	imul   %ecx
  80155f:	c1 fa 02             	sar    $0x2,%edx
  801562:	89 c8                	mov    %ecx,%eax
  801564:	c1 f8 1f             	sar    $0x1f,%eax
  801567:	29 c2                	sub    %eax,%edx
  801569:	89 d0                	mov    %edx,%eax
  80156b:	c1 e0 02             	shl    $0x2,%eax
  80156e:	01 d0                	add    %edx,%eax
  801570:	01 c0                	add    %eax,%eax
  801572:	29 c1                	sub    %eax,%ecx
  801574:	89 ca                	mov    %ecx,%edx
  801576:	85 d2                	test   %edx,%edx
  801578:	75 9c                	jne    801516 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80157a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801581:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801584:	48                   	dec    %eax
  801585:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801588:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80158c:	74 3d                	je     8015cb <ltostr+0xe2>
		start = 1 ;
  80158e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801595:	eb 34                	jmp    8015cb <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801597:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80159a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159d:	01 d0                	add    %edx,%eax
  80159f:	8a 00                	mov    (%eax),%al
  8015a1:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015aa:	01 c2                	add    %eax,%edx
  8015ac:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b2:	01 c8                	add    %ecx,%eax
  8015b4:	8a 00                	mov    (%eax),%al
  8015b6:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015be:	01 c2                	add    %eax,%edx
  8015c0:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015c3:	88 02                	mov    %al,(%edx)
		start++ ;
  8015c5:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015c8:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ce:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015d1:	7c c4                	jl     801597 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015d3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d9:	01 d0                	add    %edx,%eax
  8015db:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015de:	90                   	nop
  8015df:	c9                   	leave  
  8015e0:	c3                   	ret    

008015e1 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015e1:	55                   	push   %ebp
  8015e2:	89 e5                	mov    %esp,%ebp
  8015e4:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015e7:	ff 75 08             	pushl  0x8(%ebp)
  8015ea:	e8 54 fa ff ff       	call   801043 <strlen>
  8015ef:	83 c4 04             	add    $0x4,%esp
  8015f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015f5:	ff 75 0c             	pushl  0xc(%ebp)
  8015f8:	e8 46 fa ff ff       	call   801043 <strlen>
  8015fd:	83 c4 04             	add    $0x4,%esp
  801600:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801603:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80160a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801611:	eb 17                	jmp    80162a <strcconcat+0x49>
		final[s] = str1[s] ;
  801613:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801616:	8b 45 10             	mov    0x10(%ebp),%eax
  801619:	01 c2                	add    %eax,%edx
  80161b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80161e:	8b 45 08             	mov    0x8(%ebp),%eax
  801621:	01 c8                	add    %ecx,%eax
  801623:	8a 00                	mov    (%eax),%al
  801625:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801627:	ff 45 fc             	incl   -0x4(%ebp)
  80162a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80162d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801630:	7c e1                	jl     801613 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801632:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801639:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801640:	eb 1f                	jmp    801661 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801642:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801645:	8d 50 01             	lea    0x1(%eax),%edx
  801648:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80164b:	89 c2                	mov    %eax,%edx
  80164d:	8b 45 10             	mov    0x10(%ebp),%eax
  801650:	01 c2                	add    %eax,%edx
  801652:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801655:	8b 45 0c             	mov    0xc(%ebp),%eax
  801658:	01 c8                	add    %ecx,%eax
  80165a:	8a 00                	mov    (%eax),%al
  80165c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80165e:	ff 45 f8             	incl   -0x8(%ebp)
  801661:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801664:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801667:	7c d9                	jl     801642 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801669:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80166c:	8b 45 10             	mov    0x10(%ebp),%eax
  80166f:	01 d0                	add    %edx,%eax
  801671:	c6 00 00             	movb   $0x0,(%eax)
}
  801674:	90                   	nop
  801675:	c9                   	leave  
  801676:	c3                   	ret    

00801677 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80167a:	8b 45 14             	mov    0x14(%ebp),%eax
  80167d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801683:	8b 45 14             	mov    0x14(%ebp),%eax
  801686:	8b 00                	mov    (%eax),%eax
  801688:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80168f:	8b 45 10             	mov    0x10(%ebp),%eax
  801692:	01 d0                	add    %edx,%eax
  801694:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80169a:	eb 0c                	jmp    8016a8 <strsplit+0x31>
			*string++ = 0;
  80169c:	8b 45 08             	mov    0x8(%ebp),%eax
  80169f:	8d 50 01             	lea    0x1(%eax),%edx
  8016a2:	89 55 08             	mov    %edx,0x8(%ebp)
  8016a5:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ab:	8a 00                	mov    (%eax),%al
  8016ad:	84 c0                	test   %al,%al
  8016af:	74 18                	je     8016c9 <strsplit+0x52>
  8016b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b4:	8a 00                	mov    (%eax),%al
  8016b6:	0f be c0             	movsbl %al,%eax
  8016b9:	50                   	push   %eax
  8016ba:	ff 75 0c             	pushl  0xc(%ebp)
  8016bd:	e8 13 fb ff ff       	call   8011d5 <strchr>
  8016c2:	83 c4 08             	add    $0x8,%esp
  8016c5:	85 c0                	test   %eax,%eax
  8016c7:	75 d3                	jne    80169c <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  8016c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cc:	8a 00                	mov    (%eax),%al
  8016ce:	84 c0                	test   %al,%al
  8016d0:	74 5a                	je     80172c <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  8016d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d5:	8b 00                	mov    (%eax),%eax
  8016d7:	83 f8 0f             	cmp    $0xf,%eax
  8016da:	75 07                	jne    8016e3 <strsplit+0x6c>
		{
			return 0;
  8016dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e1:	eb 66                	jmp    801749 <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e6:	8b 00                	mov    (%eax),%eax
  8016e8:	8d 48 01             	lea    0x1(%eax),%ecx
  8016eb:	8b 55 14             	mov    0x14(%ebp),%edx
  8016ee:	89 0a                	mov    %ecx,(%edx)
  8016f0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fa:	01 c2                	add    %eax,%edx
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801701:	eb 03                	jmp    801706 <strsplit+0x8f>
			string++;
  801703:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801706:	8b 45 08             	mov    0x8(%ebp),%eax
  801709:	8a 00                	mov    (%eax),%al
  80170b:	84 c0                	test   %al,%al
  80170d:	74 8b                	je     80169a <strsplit+0x23>
  80170f:	8b 45 08             	mov    0x8(%ebp),%eax
  801712:	8a 00                	mov    (%eax),%al
  801714:	0f be c0             	movsbl %al,%eax
  801717:	50                   	push   %eax
  801718:	ff 75 0c             	pushl  0xc(%ebp)
  80171b:	e8 b5 fa ff ff       	call   8011d5 <strchr>
  801720:	83 c4 08             	add    $0x8,%esp
  801723:	85 c0                	test   %eax,%eax
  801725:	74 dc                	je     801703 <strsplit+0x8c>
			string++;
	}
  801727:	e9 6e ff ff ff       	jmp    80169a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80172c:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80172d:	8b 45 14             	mov    0x14(%ebp),%eax
  801730:	8b 00                	mov    (%eax),%eax
  801732:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801739:	8b 45 10             	mov    0x10(%ebp),%eax
  80173c:	01 d0                	add    %edx,%eax
  80173e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801744:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801749:	c9                   	leave  
  80174a:	c3                   	ret    

0080174b <malloc>:
int cnt_mem = 0;
int heap_mem[size_uhmem] = { 0 };
struct hmem heap_size[size_uhmem] = { 0 };
int check = 0;

void* malloc(uint32 size) {
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
  80174e:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyNEXTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	//NEXT FIT
	if (sys_isUHeapPlacementStrategyNEXTFIT()) {
  801754:	e8 7d 0f 00 00       	call   8026d6 <sys_isUHeapPlacementStrategyNEXTFIT>
  801759:	85 c0                	test   %eax,%eax
  80175b:	0f 84 6f 03 00 00    	je     801ad0 <malloc+0x385>
		size = ROUNDUP(size, PAGE_SIZE);
  801761:	c7 45 84 00 10 00 00 	movl   $0x1000,-0x7c(%ebp)
  801768:	8b 55 08             	mov    0x8(%ebp),%edx
  80176b:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80176e:	01 d0                	add    %edx,%eax
  801770:	48                   	dec    %eax
  801771:	89 45 80             	mov    %eax,-0x80(%ebp)
  801774:	8b 45 80             	mov    -0x80(%ebp),%eax
  801777:	ba 00 00 00 00       	mov    $0x0,%edx
  80177c:	f7 75 84             	divl   -0x7c(%ebp)
  80177f:	8b 45 80             	mov    -0x80(%ebp),%eax
  801782:	29 d0                	sub    %edx,%eax
  801784:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801787:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80178b:	74 09                	je     801796 <malloc+0x4b>
  80178d:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801794:	76 0a                	jbe    8017a0 <malloc+0x55>
			return NULL;
  801796:	b8 00 00 00 00       	mov    $0x0,%eax
  80179b:	e9 4b 09 00 00       	jmp    8020eb <malloc+0x9a0>
		}
		// first we can allocate by " Strategy Continues "
		if (ptr_uheap + size <= (uint32) USER_HEAP_MAX && !check) {
  8017a0:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8017a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a9:	01 d0                	add    %edx,%eax
  8017ab:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8017b0:	0f 87 a2 00 00 00    	ja     801858 <malloc+0x10d>
  8017b6:	a1 60 30 98 00       	mov    0x983060,%eax
  8017bb:	85 c0                	test   %eax,%eax
  8017bd:	0f 85 95 00 00 00    	jne    801858 <malloc+0x10d>

			void* ret = (void *) ptr_uheap;
  8017c3:	a1 04 30 80 00       	mov    0x803004,%eax
  8017c8:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			sys_allocateMem(ptr_uheap, size);
  8017ce:	a1 04 30 80 00       	mov    0x803004,%eax
  8017d3:	83 ec 08             	sub    $0x8,%esp
  8017d6:	ff 75 08             	pushl  0x8(%ebp)
  8017d9:	50                   	push   %eax
  8017da:	e8 a3 0b 00 00       	call   802382 <sys_allocateMem>
  8017df:	83 c4 10             	add    $0x10,%esp

			heap_size[cnt_mem].size = size;
  8017e2:	a1 40 30 80 00       	mov    0x803040,%eax
  8017e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8017ea:	89 14 c5 64 30 88 00 	mov    %edx,0x883064(,%eax,8)
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8017f1:	a1 40 30 80 00       	mov    0x803040,%eax
  8017f6:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8017fc:	89 14 c5 60 30 88 00 	mov    %edx,0x883060(,%eax,8)
			cnt_mem++;
  801803:	a1 40 30 80 00       	mov    0x803040,%eax
  801808:	40                   	inc    %eax
  801809:	a3 40 30 80 00       	mov    %eax,0x803040
			int i = 0;
  80180e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  801815:	eb 2e                	jmp    801845 <malloc+0xfa>
			{

				heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801817:	a1 04 30 80 00       	mov    0x803004,%eax
  80181c:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] = 1;
  801821:	c1 e8 0c             	shr    $0xc,%eax
  801824:	c7 04 85 60 30 80 00 	movl   $0x1,0x803060(,%eax,4)
  80182b:	01 00 00 00 

				ptr_uheap += (uint32) PAGE_SIZE;
  80182f:	a1 04 30 80 00       	mov    0x803004,%eax
  801834:	05 00 10 00 00       	add    $0x1000,%eax
  801839:	a3 04 30 80 00       	mov    %eax,0x803004
			heap_size[cnt_mem].size = size;
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
			cnt_mem++;
			int i = 0;
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  80183e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801845:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801848:	3b 45 08             	cmp    0x8(%ebp),%eax
  80184b:	72 ca                	jb     801817 <malloc+0xcc>
						/ (uint32) PAGE_SIZE)] = 1;

				ptr_uheap += (uint32) PAGE_SIZE;
			}

			return ret;
  80184d:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  801853:	e9 93 08 00 00       	jmp    8020eb <malloc+0x9a0>

		} else {
			// second we can allocate by " Strategy NEXTFIT "
			void* temp_end = NULL;
  801858:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

			int check_start = 0;
  80185f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			// check first that we used " Strategy Continues " before and not do it again and turn to NEXTFIT
			if (!check) {
  801866:	a1 60 30 98 00       	mov    0x983060,%eax
  80186b:	85 c0                	test   %eax,%eax
  80186d:	75 1d                	jne    80188c <malloc+0x141>
				ptr_uheap = (uint32) USER_HEAP_START;
  80186f:	c7 05 04 30 80 00 00 	movl   $0x80000000,0x803004
  801876:	00 00 80 
				check = 1;
  801879:	c7 05 60 30 98 00 01 	movl   $0x1,0x983060
  801880:	00 00 00 
				check_start = 1;// to dont use second loop CZ ptr_uheap start from USER_HEAP_START
  801883:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  80188a:	eb 08                	jmp    801894 <malloc+0x149>
			} else {
				temp_end = (void*) ptr_uheap;
  80188c:	a1 04 30 80 00       	mov    0x803004,%eax
  801891:	89 45 f0             	mov    %eax,-0x10(%ebp)

			}

			uint32 sz = 0;
  801894:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
			int f = 0;
  80189b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			uint32 ptr = ptr_uheap;
  8018a2:	a1 04 30 80 00       	mov    0x803004,%eax
  8018a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  8018aa:	eb 4d                	jmp    8018f9 <malloc+0x1ae>
				if (sz == size) {
  8018ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018af:	3b 45 08             	cmp    0x8(%ebp),%eax
  8018b2:	75 09                	jne    8018bd <malloc+0x172>
					f = 1;
  8018b4:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  8018bb:	eb 45                	jmp    801902 <malloc+0x1b7>
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  8018bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018c0:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] == 0) {
  8018c5:	c1 e8 0c             	shr    $0xc,%eax
			while (ptr < (uint32) USER_HEAP_MAX) {
				if (sz == size) {
					f = 1;
					break;
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  8018c8:	8b 04 85 60 30 80 00 	mov    0x803060(,%eax,4),%eax
  8018cf:	85 c0                	test   %eax,%eax
  8018d1:	75 10                	jne    8018e3 <malloc+0x198>
						/ (uint32) PAGE_SIZE)] == 0) {

					sz += PAGE_SIZE;
  8018d3:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
					ptr += PAGE_SIZE;
  8018da:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  8018e1:	eb 16                	jmp    8018f9 <malloc+0x1ae>
				} else {
					sz = 0;
  8018e3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
					ptr += PAGE_SIZE;
  8018ea:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
					ptr_uheap = ptr;
  8018f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018f4:	a3 04 30 80 00       	mov    %eax,0x803004

			uint32 sz = 0;
			int f = 0;
			uint32 ptr = ptr_uheap;
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  8018f9:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  801900:	76 aa                	jbe    8018ac <malloc+0x161>
					ptr_uheap = ptr;
				}

			}

			if (f) {
  801902:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801906:	0f 84 95 00 00 00    	je     8019a1 <malloc+0x256>

				void* ret = (void *) ptr_uheap;
  80190c:	a1 04 30 80 00       	mov    0x803004,%eax
  801911:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

				sys_allocateMem(ptr_uheap, size);
  801917:	a1 04 30 80 00       	mov    0x803004,%eax
  80191c:	83 ec 08             	sub    $0x8,%esp
  80191f:	ff 75 08             	pushl  0x8(%ebp)
  801922:	50                   	push   %eax
  801923:	e8 5a 0a 00 00       	call   802382 <sys_allocateMem>
  801928:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  80192b:	a1 40 30 80 00       	mov    0x803040,%eax
  801930:	8b 55 08             	mov    0x8(%ebp),%edx
  801933:	89 14 c5 64 30 88 00 	mov    %edx,0x883064(,%eax,8)
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
  80193a:	a1 40 30 80 00       	mov    0x803040,%eax
  80193f:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801945:	89 14 c5 60 30 88 00 	mov    %edx,0x883060(,%eax,8)
				cnt_mem++;
  80194c:	a1 40 30 80 00       	mov    0x803040,%eax
  801951:	40                   	inc    %eax
  801952:	a3 40 30 80 00       	mov    %eax,0x803040
				int i = 0;
  801957:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  80195e:	eb 2e                	jmp    80198e <malloc+0x243>
				{

					heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801960:	a1 04 30 80 00       	mov    0x803004,%eax
  801965:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  80196a:	c1 e8 0c             	shr    $0xc,%eax
  80196d:	c7 04 85 60 30 80 00 	movl   $0x1,0x803060(,%eax,4)
  801974:	01 00 00 00 

					ptr_uheap += (uint32) PAGE_SIZE;
  801978:	a1 04 30 80 00       	mov    0x803004,%eax
  80197d:	05 00 10 00 00       	add    $0x1000,%eax
  801982:	a3 04 30 80 00       	mov    %eax,0x803004
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
				cnt_mem++;
				int i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801987:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  80198e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801991:	3b 45 08             	cmp    0x8(%ebp),%eax
  801994:	72 ca                	jb     801960 <malloc+0x215>
							/ (uint32) PAGE_SIZE)] = 1;

					ptr_uheap += (uint32) PAGE_SIZE;
				}

				return ret;
  801996:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80199c:	e9 4a 07 00 00       	jmp    8020eb <malloc+0x9a0>

			} else {

				if (check_start) {
  8019a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019a5:	74 0a                	je     8019b1 <malloc+0x266>

					return NULL;
  8019a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ac:	e9 3a 07 00 00       	jmp    8020eb <malloc+0x9a0>
				}

//////////////back loop////////////////

				uint32 sz = 0;
  8019b1:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
				int f = 0;
  8019b8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				uint32 ptr = USER_HEAP_START;
  8019bf:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
				ptr_uheap = USER_HEAP_START;
  8019c6:	c7 05 04 30 80 00 00 	movl   $0x80000000,0x803004
  8019cd:	00 00 80 
				while (ptr < (uint32) temp_end) {
  8019d0:	eb 4d                	jmp    801a1f <malloc+0x2d4>
					if (sz == size) {
  8019d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019d5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8019d8:	75 09                	jne    8019e3 <malloc+0x298>
						f = 1;
  8019da:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
						break;
  8019e1:	eb 44                	jmp    801a27 <malloc+0x2dc>
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  8019e3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8019e6:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] == 0) {
  8019eb:	c1 e8 0c             	shr    $0xc,%eax
				while (ptr < (uint32) temp_end) {
					if (sz == size) {
						f = 1;
						break;
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  8019ee:	8b 04 85 60 30 80 00 	mov    0x803060(,%eax,4),%eax
  8019f5:	85 c0                	test   %eax,%eax
  8019f7:	75 10                	jne    801a09 <malloc+0x2be>
							/ (uint32) PAGE_SIZE)] == 0) {

						sz += PAGE_SIZE;
  8019f9:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801a00:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
  801a07:	eb 16                	jmp    801a1f <malloc+0x2d4>
					} else {
						sz = 0;
  801a09:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801a10:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
						ptr_uheap = ptr;
  801a17:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801a1a:	a3 04 30 80 00       	mov    %eax,0x803004

				uint32 sz = 0;
				int f = 0;
				uint32 ptr = USER_HEAP_START;
				ptr_uheap = USER_HEAP_START;
				while (ptr < (uint32) temp_end) {
  801a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a22:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801a25:	72 ab                	jb     8019d2 <malloc+0x287>
						ptr_uheap = ptr;
					}

				}

				if (f) {
  801a27:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801a2b:	0f 84 95 00 00 00    	je     801ac6 <malloc+0x37b>

					void* ret = (void *) ptr_uheap;
  801a31:	a1 04 30 80 00       	mov    0x803004,%eax
  801a36:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

					sys_allocateMem(ptr_uheap, size);
  801a3c:	a1 04 30 80 00       	mov    0x803004,%eax
  801a41:	83 ec 08             	sub    $0x8,%esp
  801a44:	ff 75 08             	pushl  0x8(%ebp)
  801a47:	50                   	push   %eax
  801a48:	e8 35 09 00 00       	call   802382 <sys_allocateMem>
  801a4d:	83 c4 10             	add    $0x10,%esp

					heap_size[cnt_mem].size = size;
  801a50:	a1 40 30 80 00       	mov    0x803040,%eax
  801a55:	8b 55 08             	mov    0x8(%ebp),%edx
  801a58:	89 14 c5 64 30 88 00 	mov    %edx,0x883064(,%eax,8)
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801a5f:	a1 40 30 80 00       	mov    0x803040,%eax
  801a64:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801a6a:	89 14 c5 60 30 88 00 	mov    %edx,0x883060(,%eax,8)
					cnt_mem++;
  801a71:	a1 40 30 80 00       	mov    0x803040,%eax
  801a76:	40                   	inc    %eax
  801a77:	a3 40 30 80 00       	mov    %eax,0x803040
					int i = 0;
  801a7c:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

					for (; i < size; i += PAGE_SIZE)
  801a83:	eb 2e                	jmp    801ab3 <malloc+0x368>
					{

						heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801a85:	a1 04 30 80 00       	mov    0x803004,%eax
  801a8a:	05 00 00 00 80       	add    $0x80000000,%eax
								/ (uint32) PAGE_SIZE)] = 1;
  801a8f:	c1 e8 0c             	shr    $0xc,%eax
  801a92:	c7 04 85 60 30 80 00 	movl   $0x1,0x803060(,%eax,4)
  801a99:	01 00 00 00 

						ptr_uheap += (uint32) PAGE_SIZE;
  801a9d:	a1 04 30 80 00       	mov    0x803004,%eax
  801aa2:	05 00 10 00 00       	add    $0x1000,%eax
  801aa7:	a3 04 30 80 00       	mov    %eax,0x803004
					heap_size[cnt_mem].size = size;
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
					cnt_mem++;
					int i = 0;

					for (; i < size; i += PAGE_SIZE)
  801aac:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  801ab3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801ab6:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ab9:	72 ca                	jb     801a85 <malloc+0x33a>
								/ (uint32) PAGE_SIZE)] = 1;

						ptr_uheap += (uint32) PAGE_SIZE;
					}

					return ret;
  801abb:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801ac1:	e9 25 06 00 00       	jmp    8020eb <malloc+0x9a0>

				} else {

					return NULL;
  801ac6:	b8 00 00 00 00       	mov    $0x0,%eax
  801acb:	e9 1b 06 00 00       	jmp    8020eb <malloc+0x9a0>

		}

	}

	else if (sys_isUHeapPlacementStrategyBESTFIT()) {
  801ad0:	e8 d0 0b 00 00       	call   8026a5 <sys_isUHeapPlacementStrategyBESTFIT>
  801ad5:	85 c0                	test   %eax,%eax
  801ad7:	0f 84 ba 01 00 00    	je     801c97 <malloc+0x54c>

		size = ROUNDUP(size, PAGE_SIZE);
  801add:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  801ae4:	10 00 00 
  801ae7:	8b 55 08             	mov    0x8(%ebp),%edx
  801aea:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  801af0:	01 d0                	add    %edx,%eax
  801af2:	48                   	dec    %eax
  801af3:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  801af9:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801aff:	ba 00 00 00 00       	mov    $0x0,%edx
  801b04:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  801b0a:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801b10:	29 d0                	sub    %edx,%eax
  801b12:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801b15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b19:	74 09                	je     801b24 <malloc+0x3d9>
  801b1b:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801b22:	76 0a                	jbe    801b2e <malloc+0x3e3>
			return NULL;
  801b24:	b8 00 00 00 00       	mov    $0x0,%eax
  801b29:	e9 bd 05 00 00       	jmp    8020eb <malloc+0x9a0>
		}
		uint32 ptr = (uint32) USER_HEAP_START;
  801b2e:	c7 45 c8 00 00 00 80 	movl   $0x80000000,-0x38(%ebp)
		uint32 temp = 0;
  801b35:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		uint32 min_sz = size_uhmem + 1;
  801b3c:	c7 45 c0 01 00 02 00 	movl   $0x20001,-0x40(%ebp)
		uint32 count = 0;
  801b43:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
		int i = 0;
  801b4a:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801b51:	8b 45 08             	mov    0x8(%ebp),%eax
  801b54:	c1 e8 0c             	shr    $0xc,%eax
  801b57:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801b5d:	e9 80 00 00 00       	jmp    801be2 <malloc+0x497>

			if (heap_mem[i] == 0) {
  801b62:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801b65:	8b 04 85 60 30 80 00 	mov    0x803060(,%eax,4),%eax
  801b6c:	85 c0                	test   %eax,%eax
  801b6e:	75 0c                	jne    801b7c <malloc+0x431>

				count++;
  801b70:	ff 45 bc             	incl   -0x44(%ebp)
				ptr += PAGE_SIZE;
  801b73:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801b7a:	eb 2d                	jmp    801ba9 <malloc+0x45e>
			} else {
				if (num_p <= count && min_sz > count) {
  801b7c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801b82:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801b85:	77 14                	ja     801b9b <malloc+0x450>
  801b87:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801b8a:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801b8d:	76 0c                	jbe    801b9b <malloc+0x450>

					min_sz = count;
  801b8f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801b92:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801b95:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801b98:	89 45 c4             	mov    %eax,-0x3c(%ebp)

				}
				count = 0;
  801b9b:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
				ptr += PAGE_SIZE;
  801ba2:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
			}

			if (i == size_uhmem - 1) {
  801ba9:	81 7d b8 ff ff 01 00 	cmpl   $0x1ffff,-0x48(%ebp)
  801bb0:	75 2d                	jne    801bdf <malloc+0x494>

				if (num_p <= count && min_sz > count) {
  801bb2:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801bb8:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801bbb:	77 22                	ja     801bdf <malloc+0x494>
  801bbd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801bc0:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801bc3:	76 1a                	jbe    801bdf <malloc+0x494>

					min_sz = count;
  801bc5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801bc8:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801bcb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801bce:	89 45 c4             	mov    %eax,-0x3c(%ebp)
					count = 0;
  801bd1:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
					ptr += PAGE_SIZE;
  801bd8:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801bdf:	ff 45 b8             	incl   -0x48(%ebp)
  801be2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801be5:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801bea:	0f 86 72 ff ff ff    	jbe    801b62 <malloc+0x417>

			}

		}

		if (num_p > min_sz || temp == 0) {
  801bf0:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801bf6:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  801bf9:	77 06                	ja     801c01 <malloc+0x4b6>
  801bfb:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801bff:	75 0a                	jne    801c0b <malloc+0x4c0>
			return NULL;
  801c01:	b8 00 00 00 00       	mov    $0x0,%eax
  801c06:	e9 e0 04 00 00       	jmp    8020eb <malloc+0x9a0>

		}

		temp = temp - (PAGE_SIZE * min_sz);
  801c0b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c0e:	c1 e0 0c             	shl    $0xc,%eax
  801c11:	29 45 c4             	sub    %eax,-0x3c(%ebp)
		void* ret = (void*) temp;
  801c14:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801c17:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)

		sys_allocateMem(temp, size);
  801c1d:	83 ec 08             	sub    $0x8,%esp
  801c20:	ff 75 08             	pushl  0x8(%ebp)
  801c23:	ff 75 c4             	pushl  -0x3c(%ebp)
  801c26:	e8 57 07 00 00       	call   802382 <sys_allocateMem>
  801c2b:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801c2e:	a1 40 30 80 00       	mov    0x803040,%eax
  801c33:	8b 55 08             	mov    0x8(%ebp),%edx
  801c36:	89 14 c5 64 30 88 00 	mov    %edx,0x883064(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801c3d:	a1 40 30 80 00       	mov    0x803040,%eax
  801c42:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801c45:	89 14 c5 60 30 88 00 	mov    %edx,0x883060(,%eax,8)
		cnt_mem++;
  801c4c:	a1 40 30 80 00       	mov    0x803040,%eax
  801c51:	40                   	inc    %eax
  801c52:	a3 40 30 80 00       	mov    %eax,0x803040
		i = 0;
  801c57:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801c5e:	eb 24                	jmp    801c84 <malloc+0x539>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801c60:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801c63:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801c68:	c1 e8 0c             	shr    $0xc,%eax
  801c6b:	c7 04 85 60 30 80 00 	movl   $0x1,0x803060(,%eax,4)
  801c72:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801c76:	81 45 c4 00 10 00 00 	addl   $0x1000,-0x3c(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801c7d:	81 45 b8 00 10 00 00 	addl   $0x1000,-0x48(%ebp)
  801c84:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801c87:	3b 45 08             	cmp    0x8(%ebp),%eax
  801c8a:	72 d4                	jb     801c60 <malloc+0x515>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801c8c:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801c92:	e9 54 04 00 00       	jmp    8020eb <malloc+0x9a0>

	} else if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801c97:	e8 d8 09 00 00       	call   802674 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c9c:	85 c0                	test   %eax,%eax
  801c9e:	0f 84 88 01 00 00    	je     801e2c <malloc+0x6e1>

		size = ROUNDUP(size, PAGE_SIZE);
  801ca4:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  801cab:	10 00 00 
  801cae:	8b 55 08             	mov    0x8(%ebp),%edx
  801cb1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  801cb7:	01 d0                	add    %edx,%eax
  801cb9:	48                   	dec    %eax
  801cba:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  801cc0:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801cc6:	ba 00 00 00 00       	mov    $0x0,%edx
  801ccb:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  801cd1:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801cd7:	29 d0                	sub    %edx,%eax
  801cd9:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801cdc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ce0:	74 09                	je     801ceb <malloc+0x5a0>
  801ce2:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801ce9:	76 0a                	jbe    801cf5 <malloc+0x5aa>
			return NULL;
  801ceb:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf0:	e9 f6 03 00 00       	jmp    8020eb <malloc+0x9a0>
		}

		uint32 ptr = (uint32) USER_HEAP_START;
  801cf5:	c7 45 b4 00 00 00 80 	movl   $0x80000000,-0x4c(%ebp)
		uint32 temp = 0;
  801cfc:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
		uint32 found = 0;
  801d03:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		uint32 count = 0;
  801d0a:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
		int i = 0;
  801d11:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801d18:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1b:	c1 e8 0c             	shr    $0xc,%eax
  801d1e:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

		for (; i < size_uhmem; i++) {
  801d24:	eb 5a                	jmp    801d80 <malloc+0x635>

			if (heap_mem[i] == 0) {
  801d26:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801d29:	8b 04 85 60 30 80 00 	mov    0x803060(,%eax,4),%eax
  801d30:	85 c0                	test   %eax,%eax
  801d32:	75 0c                	jne    801d40 <malloc+0x5f5>

				count++;
  801d34:	ff 45 a8             	incl   -0x58(%ebp)
				ptr += PAGE_SIZE;
  801d37:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
  801d3e:	eb 22                	jmp    801d62 <malloc+0x617>
			} else {
				if (num_p <= count) {
  801d40:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801d46:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801d49:	77 09                	ja     801d54 <malloc+0x609>

					found = 1;
  801d4b:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)

					break;
  801d52:	eb 36                	jmp    801d8a <malloc+0x63f>
				}
				count = 0;
  801d54:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
				ptr += PAGE_SIZE;
  801d5b:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
			}

			if (i == size_uhmem - 1) {
  801d62:	81 7d a4 ff ff 01 00 	cmpl   $0x1ffff,-0x5c(%ebp)
  801d69:	75 12                	jne    801d7d <malloc+0x632>

				if (num_p <= count) {
  801d6b:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801d71:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801d74:	77 07                	ja     801d7d <malloc+0x632>

					found = 1;
  801d76:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
		uint32 found = 0;
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		for (; i < size_uhmem; i++) {
  801d7d:	ff 45 a4             	incl   -0x5c(%ebp)
  801d80:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801d83:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801d88:	76 9c                	jbe    801d26 <malloc+0x5db>

			}

		}

		if (!found) {
  801d8a:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  801d8e:	75 0a                	jne    801d9a <malloc+0x64f>
			return NULL;
  801d90:	b8 00 00 00 00       	mov    $0x0,%eax
  801d95:	e9 51 03 00 00       	jmp    8020eb <malloc+0x9a0>

		}

		temp = ptr;
  801d9a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801d9d:	89 45 b0             	mov    %eax,-0x50(%ebp)
		temp = temp - (PAGE_SIZE * count);
  801da0:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801da3:	c1 e0 0c             	shl    $0xc,%eax
  801da6:	29 45 b0             	sub    %eax,-0x50(%ebp)
		void* ret = (void*) temp;
  801da9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801dac:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)

		sys_allocateMem(temp, size);
  801db2:	83 ec 08             	sub    $0x8,%esp
  801db5:	ff 75 08             	pushl  0x8(%ebp)
  801db8:	ff 75 b0             	pushl  -0x50(%ebp)
  801dbb:	e8 c2 05 00 00       	call   802382 <sys_allocateMem>
  801dc0:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801dc3:	a1 40 30 80 00       	mov    0x803040,%eax
  801dc8:	8b 55 08             	mov    0x8(%ebp),%edx
  801dcb:	89 14 c5 64 30 88 00 	mov    %edx,0x883064(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801dd2:	a1 40 30 80 00       	mov    0x803040,%eax
  801dd7:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801dda:	89 14 c5 60 30 88 00 	mov    %edx,0x883060(,%eax,8)
		cnt_mem++;
  801de1:	a1 40 30 80 00       	mov    0x803040,%eax
  801de6:	40                   	inc    %eax
  801de7:	a3 40 30 80 00       	mov    %eax,0x803040
		i = 0;
  801dec:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801df3:	eb 24                	jmp    801e19 <malloc+0x6ce>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801df5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801df8:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801dfd:	c1 e8 0c             	shr    $0xc,%eax
  801e00:	c7 04 85 60 30 80 00 	movl   $0x1,0x803060(,%eax,4)
  801e07:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801e0b:	81 45 b0 00 10 00 00 	addl   $0x1000,-0x50(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801e12:	81 45 a4 00 10 00 00 	addl   $0x1000,-0x5c(%ebp)
  801e19:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801e1c:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e1f:	72 d4                	jb     801df5 <malloc+0x6aa>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801e21:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  801e27:	e9 bf 02 00 00       	jmp    8020eb <malloc+0x9a0>

	}
	else if(sys_isUHeapPlacementStrategyWORSTFIT())
  801e2c:	e8 d6 08 00 00       	call   802707 <sys_isUHeapPlacementStrategyWORSTFIT>
  801e31:	85 c0                	test   %eax,%eax
  801e33:	0f 84 ba 01 00 00    	je     801ff3 <malloc+0x8a8>
	{
		size = ROUNDUP(size, PAGE_SIZE);
  801e39:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  801e40:	10 00 00 
  801e43:	8b 55 08             	mov    0x8(%ebp),%edx
  801e46:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  801e4c:	01 d0                	add    %edx,%eax
  801e4e:	48                   	dec    %eax
  801e4f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  801e55:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  801e5b:	ba 00 00 00 00       	mov    $0x0,%edx
  801e60:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  801e66:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  801e6c:	29 d0                	sub    %edx,%eax
  801e6e:	89 45 08             	mov    %eax,0x8(%ebp)

				if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801e71:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e75:	74 09                	je     801e80 <malloc+0x735>
  801e77:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801e7e:	76 0a                	jbe    801e8a <malloc+0x73f>
					return NULL;
  801e80:	b8 00 00 00 00       	mov    $0x0,%eax
  801e85:	e9 61 02 00 00       	jmp    8020eb <malloc+0x9a0>
				}
				uint32 ptr = (uint32) USER_HEAP_START;
  801e8a:	c7 45 a0 00 00 00 80 	movl   $0x80000000,-0x60(%ebp)
				uint32 temp = 0;
  801e91:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
				uint32 max_sz = -1;
  801e98:	c7 45 98 ff ff ff ff 	movl   $0xffffffff,-0x68(%ebp)
				uint32 count = 0;
  801e9f:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
				int i = 0;
  801ea6:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				uint32 num_p = size / PAGE_SIZE;
  801ead:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb0:	c1 e8 0c             	shr    $0xc,%eax
  801eb3:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  801eb9:	e9 80 00 00 00       	jmp    801f3e <malloc+0x7f3>

					if (heap_mem[i] == 0) {
  801ebe:	8b 45 90             	mov    -0x70(%ebp),%eax
  801ec1:	8b 04 85 60 30 80 00 	mov    0x803060(,%eax,4),%eax
  801ec8:	85 c0                	test   %eax,%eax
  801eca:	75 0c                	jne    801ed8 <malloc+0x78d>

						count++;
  801ecc:	ff 45 94             	incl   -0x6c(%ebp)
						ptr += PAGE_SIZE;
  801ecf:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
  801ed6:	eb 2d                	jmp    801f05 <malloc+0x7ba>
					} else {
						if (num_p <= count && max_sz < count) {
  801ed8:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801ede:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801ee1:	77 14                	ja     801ef7 <malloc+0x7ac>
  801ee3:	8b 45 98             	mov    -0x68(%ebp),%eax
  801ee6:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801ee9:	73 0c                	jae    801ef7 <malloc+0x7ac>

							max_sz = count;
  801eeb:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801eee:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  801ef1:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801ef4:	89 45 9c             	mov    %eax,-0x64(%ebp)

						}
						count = 0;
  801ef7:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
						ptr += PAGE_SIZE;
  801efe:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
					}

					if (i == size_uhmem - 1) {
  801f05:	81 7d 90 ff ff 01 00 	cmpl   $0x1ffff,-0x70(%ebp)
  801f0c:	75 2d                	jne    801f3b <malloc+0x7f0>

						if (num_p <= count && max_sz > count) {
  801f0e:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801f14:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801f17:	77 22                	ja     801f3b <malloc+0x7f0>
  801f19:	8b 45 98             	mov    -0x68(%ebp),%eax
  801f1c:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801f1f:	76 1a                	jbe    801f3b <malloc+0x7f0>

							max_sz = count;
  801f21:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801f24:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  801f27:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801f2a:	89 45 9c             	mov    %eax,-0x64(%ebp)
							count = 0;
  801f2d:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
							ptr += PAGE_SIZE;
  801f34:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
				uint32 count = 0;
				int i = 0;
				uint32 num_p = size / PAGE_SIZE;

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  801f3b:	ff 45 90             	incl   -0x70(%ebp)
  801f3e:	8b 45 90             	mov    -0x70(%ebp),%eax
  801f41:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801f46:	0f 86 72 ff ff ff    	jbe    801ebe <malloc+0x773>

					}

				}

				if (num_p > max_sz || temp == 0) {
  801f4c:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801f52:	3b 45 98             	cmp    -0x68(%ebp),%eax
  801f55:	77 06                	ja     801f5d <malloc+0x812>
  801f57:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  801f5b:	75 0a                	jne    801f67 <malloc+0x81c>
					return NULL;
  801f5d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f62:	e9 84 01 00 00       	jmp    8020eb <malloc+0x9a0>

				}

				temp = temp - (PAGE_SIZE * max_sz);
  801f67:	8b 45 98             	mov    -0x68(%ebp),%eax
  801f6a:	c1 e0 0c             	shl    $0xc,%eax
  801f6d:	29 45 9c             	sub    %eax,-0x64(%ebp)
				void* ret = (void*) temp;
  801f70:	8b 45 9c             	mov    -0x64(%ebp),%eax
  801f73:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

				sys_allocateMem(temp, size);
  801f79:	83 ec 08             	sub    $0x8,%esp
  801f7c:	ff 75 08             	pushl  0x8(%ebp)
  801f7f:	ff 75 9c             	pushl  -0x64(%ebp)
  801f82:	e8 fb 03 00 00       	call   802382 <sys_allocateMem>
  801f87:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  801f8a:	a1 40 30 80 00       	mov    0x803040,%eax
  801f8f:	8b 55 08             	mov    0x8(%ebp),%edx
  801f92:	89 14 c5 64 30 88 00 	mov    %edx,0x883064(,%eax,8)
				heap_size[cnt_mem].vir = (void*) temp;
  801f99:	a1 40 30 80 00       	mov    0x803040,%eax
  801f9e:	8b 55 9c             	mov    -0x64(%ebp),%edx
  801fa1:	89 14 c5 60 30 88 00 	mov    %edx,0x883060(,%eax,8)
				cnt_mem++;
  801fa8:	a1 40 30 80 00       	mov    0x803040,%eax
  801fad:	40                   	inc    %eax
  801fae:	a3 40 30 80 00       	mov    %eax,0x803040
				i = 0;
  801fb3:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801fba:	eb 24                	jmp    801fe0 <malloc+0x895>
				{

					heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801fbc:	8b 45 9c             	mov    -0x64(%ebp),%eax
  801fbf:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  801fc4:	c1 e8 0c             	shr    $0xc,%eax
  801fc7:	c7 04 85 60 30 80 00 	movl   $0x1,0x803060(,%eax,4)
  801fce:	01 00 00 00 

					temp += (uint32) PAGE_SIZE;
  801fd2:	81 45 9c 00 10 00 00 	addl   $0x1000,-0x64(%ebp)
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) temp;
				cnt_mem++;
				i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801fd9:	81 45 90 00 10 00 00 	addl   $0x1000,-0x70(%ebp)
  801fe0:	8b 45 90             	mov    -0x70(%ebp),%eax
  801fe3:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fe6:	72 d4                	jb     801fbc <malloc+0x871>

					temp += (uint32) PAGE_SIZE;
				}

				//cprintf("\n size = %d.........vir= %d  \n",num_p,((uint32) ret-USER_HEAP_START)/PAGE_SIZE);
				return ret;
  801fe8:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  801fee:	e9 f8 00 00 00       	jmp    8020eb <malloc+0x9a0>

	}
// this is to make malloc is work
	void* ret = NULL;
  801ff3:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
	size = ROUNDUP(size, PAGE_SIZE);
  801ffa:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  802001:	10 00 00 
  802004:	8b 55 08             	mov    0x8(%ebp),%edx
  802007:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  80200d:	01 d0                	add    %edx,%eax
  80200f:	48                   	dec    %eax
  802010:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  802016:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  80201c:	ba 00 00 00 00       	mov    $0x0,%edx
  802021:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  802027:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  80202d:	29 d0                	sub    %edx,%eax
  80202f:	89 45 08             	mov    %eax,0x8(%ebp)

	if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  802032:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802036:	74 09                	je     802041 <malloc+0x8f6>
  802038:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80203f:	76 0a                	jbe    80204b <malloc+0x900>
		return NULL;
  802041:	b8 00 00 00 00       	mov    $0x0,%eax
  802046:	e9 a0 00 00 00       	jmp    8020eb <malloc+0x9a0>
	}

	if (ptr_uheap + size <= (uint32) USER_HEAP_MAX) {
  80204b:	8b 15 04 30 80 00    	mov    0x803004,%edx
  802051:	8b 45 08             	mov    0x8(%ebp),%eax
  802054:	01 d0                	add    %edx,%eax
  802056:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80205b:	0f 87 87 00 00 00    	ja     8020e8 <malloc+0x99d>

		ret = (void *) ptr_uheap;
  802061:	a1 04 30 80 00       	mov    0x803004,%eax
  802066:	89 45 8c             	mov    %eax,-0x74(%ebp)
		sys_allocateMem(ptr_uheap, size);
  802069:	a1 04 30 80 00       	mov    0x803004,%eax
  80206e:	83 ec 08             	sub    $0x8,%esp
  802071:	ff 75 08             	pushl  0x8(%ebp)
  802074:	50                   	push   %eax
  802075:	e8 08 03 00 00       	call   802382 <sys_allocateMem>
  80207a:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  80207d:	a1 40 30 80 00       	mov    0x803040,%eax
  802082:	8b 55 08             	mov    0x8(%ebp),%edx
  802085:	89 14 c5 64 30 88 00 	mov    %edx,0x883064(,%eax,8)
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
  80208c:	a1 40 30 80 00       	mov    0x803040,%eax
  802091:	8b 15 04 30 80 00    	mov    0x803004,%edx
  802097:	89 14 c5 60 30 88 00 	mov    %edx,0x883060(,%eax,8)
		cnt_mem++;
  80209e:	a1 40 30 80 00       	mov    0x803040,%eax
  8020a3:	40                   	inc    %eax
  8020a4:	a3 40 30 80 00       	mov    %eax,0x803040
		int i = 0;
  8020a9:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)

		for (; i < size; i += PAGE_SIZE)
  8020b0:	eb 2e                	jmp    8020e0 <malloc+0x995>
		{

			heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8020b2:	a1 04 30 80 00       	mov    0x803004,%eax
  8020b7:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  8020bc:	c1 e8 0c             	shr    $0xc,%eax
  8020bf:	c7 04 85 60 30 80 00 	movl   $0x1,0x803060(,%eax,4)
  8020c6:	01 00 00 00 

			ptr_uheap += (uint32) PAGE_SIZE;
  8020ca:	a1 04 30 80 00       	mov    0x803004,%eax
  8020cf:	05 00 10 00 00       	add    $0x1000,%eax
  8020d4:	a3 04 30 80 00       	mov    %eax,0x803004
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
		cnt_mem++;
		int i = 0;

		for (; i < size; i += PAGE_SIZE)
  8020d9:	81 45 88 00 10 00 00 	addl   $0x1000,-0x78(%ebp)
  8020e0:	8b 45 88             	mov    -0x78(%ebp),%eax
  8020e3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020e6:	72 ca                	jb     8020b2 <malloc+0x967>
					/ (uint32) PAGE_SIZE)] = 1;

			ptr_uheap += (uint32) PAGE_SIZE;
		}
	}
	return ret;
  8020e8:	8b 45 8c             	mov    -0x74(%ebp),%eax

	//TODO: [PROJECT 2016 - BONUS2] Apply FIRST FIT and WORST FIT policies

//return 0;

}
  8020eb:	c9                   	leave  
  8020ec:	c3                   	ret    

008020ed <free>:
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address) {
  8020ed:	55                   	push   %ebp
  8020ee:	89 e5                	mov    %esp,%ebp
  8020f0:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
  8020f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; inx < cnt_mem; inx++) {
  8020fa:	e9 c1 00 00 00       	jmp    8021c0 <free+0xd3>
		if (heap_size[inx].vir == virtual_address) {
  8020ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802102:	8b 04 c5 60 30 88 00 	mov    0x883060(,%eax,8),%eax
  802109:	3b 45 08             	cmp    0x8(%ebp),%eax
  80210c:	0f 85 ab 00 00 00    	jne    8021bd <free+0xd0>

			if (heap_size[inx].size == 0) {
  802112:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802115:	8b 04 c5 64 30 88 00 	mov    0x883064(,%eax,8),%eax
  80211c:	85 c0                	test   %eax,%eax
  80211e:	75 21                	jne    802141 <free+0x54>
				heap_size[inx].size = 0;
  802120:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802123:	c7 04 c5 64 30 88 00 	movl   $0x0,0x883064(,%eax,8)
  80212a:	00 00 00 00 
				heap_size[inx].vir = NULL;
  80212e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802131:	c7 04 c5 60 30 88 00 	movl   $0x0,0x883060(,%eax,8)
  802138:	00 00 00 00 
				return;
  80213c:	e9 8d 00 00 00       	jmp    8021ce <free+0xe1>

			}

			sys_freeMem((uint32) virtual_address, heap_size[inx].size);
  802141:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802144:	8b 14 c5 64 30 88 00 	mov    0x883064(,%eax,8),%edx
  80214b:	8b 45 08             	mov    0x8(%ebp),%eax
  80214e:	83 ec 08             	sub    $0x8,%esp
  802151:	52                   	push   %edx
  802152:	50                   	push   %eax
  802153:	e8 0e 02 00 00       	call   802366 <sys_freeMem>
  802158:	83 c4 10             	add    $0x10,%esp

			int i = 0;
  80215b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
  802162:	8b 45 08             	mov    0x8(%ebp),%eax
  802165:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  802168:	eb 24                	jmp    80218e <free+0xa1>
			{
				heap_mem[(int) (((uint32) va - USER_HEAP_START) / PAGE_SIZE)] =
  80216a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80216d:	05 00 00 00 80       	add    $0x80000000,%eax
  802172:	c1 e8 0c             	shr    $0xc,%eax
  802175:	c7 04 85 60 30 80 00 	movl   $0x0,0x803060(,%eax,4)
  80217c:	00 00 00 00 
						0;

				va += PAGE_SIZE;
  802180:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
			sys_freeMem((uint32) virtual_address, heap_size[inx].size);

			int i = 0;
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  802187:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  80218e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802191:	8b 14 c5 64 30 88 00 	mov    0x883064(,%eax,8),%edx
  802198:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80219b:	39 c2                	cmp    %eax,%edx
  80219d:	77 cb                	ja     80216a <free+0x7d>

				va += PAGE_SIZE;

			}

			heap_size[inx].size = 0;
  80219f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a2:	c7 04 c5 64 30 88 00 	movl   $0x0,0x883064(,%eax,8)
  8021a9:	00 00 00 00 
			heap_size[inx].vir = NULL;
  8021ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b0:	c7 04 c5 60 30 88 00 	movl   $0x0,0x883060(,%eax,8)
  8021b7:	00 00 00 00 
			break;
  8021bb:	eb 11                	jmp    8021ce <free+0xe1>
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
	for (; inx < cnt_mem; inx++) {
  8021bd:	ff 45 f4             	incl   -0xc(%ebp)
  8021c0:	a1 40 30 80 00       	mov    0x803040,%eax
  8021c5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  8021c8:	0f 8c 31 ff ff ff    	jl     8020ff <free+0x12>
	}

	//get the size of the given allocation using its address
	//you need to call sys_freeMem()

}
  8021ce:	c9                   	leave  
  8021cf:	c3                   	ret    

008021d0 <realloc>:
//  Hint: you may need to use the sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size) {
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
  8021d3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2016 - BONUS4] realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8021d6:	83 ec 04             	sub    $0x4,%esp
  8021d9:	68 84 2f 80 00       	push   $0x802f84
  8021de:	68 1c 02 00 00       	push   $0x21c
  8021e3:	68 aa 2f 80 00       	push   $0x802faa
  8021e8:	e8 aa e4 ff ff       	call   800697 <_panic>

008021ed <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
  8021f0:	57                   	push   %edi
  8021f1:	56                   	push   %esi
  8021f2:	53                   	push   %ebx
  8021f3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8021f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021fc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021ff:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802202:	8b 7d 18             	mov    0x18(%ebp),%edi
  802205:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802208:	cd 30                	int    $0x30
  80220a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80220d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802210:	83 c4 10             	add    $0x10,%esp
  802213:	5b                   	pop    %ebx
  802214:	5e                   	pop    %esi
  802215:	5f                   	pop    %edi
  802216:	5d                   	pop    %ebp
  802217:	c3                   	ret    

00802218 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  80221b:	8b 45 08             	mov    0x8(%ebp),%eax
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	ff 75 0c             	pushl  0xc(%ebp)
  802227:	50                   	push   %eax
  802228:	6a 00                	push   $0x0
  80222a:	e8 be ff ff ff       	call   8021ed <syscall>
  80222f:	83 c4 18             	add    $0x18,%esp
}
  802232:	90                   	nop
  802233:	c9                   	leave  
  802234:	c3                   	ret    

00802235 <sys_cgetc>:

int
sys_cgetc(void)
{
  802235:	55                   	push   %ebp
  802236:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 01                	push   $0x1
  802244:	e8 a4 ff ff ff       	call   8021ed <syscall>
  802249:	83 c4 18             	add    $0x18,%esp
}
  80224c:	c9                   	leave  
  80224d:	c3                   	ret    

0080224e <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  80224e:	55                   	push   %ebp
  80224f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  802251:	8b 45 08             	mov    0x8(%ebp),%eax
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	6a 00                	push   $0x0
  80225c:	50                   	push   %eax
  80225d:	6a 03                	push   $0x3
  80225f:	e8 89 ff ff ff       	call   8021ed <syscall>
  802264:	83 c4 18             	add    $0x18,%esp
}
  802267:	c9                   	leave  
  802268:	c3                   	ret    

00802269 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802269:	55                   	push   %ebp
  80226a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	6a 02                	push   $0x2
  802278:	e8 70 ff ff ff       	call   8021ed <syscall>
  80227d:	83 c4 18             	add    $0x18,%esp
}
  802280:	c9                   	leave  
  802281:	c3                   	ret    

00802282 <sys_env_exit>:

void sys_env_exit(void)
{
  802282:	55                   	push   %ebp
  802283:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	6a 00                	push   $0x0
  80228b:	6a 00                	push   $0x0
  80228d:	6a 00                	push   $0x0
  80228f:	6a 04                	push   $0x4
  802291:	e8 57 ff ff ff       	call   8021ed <syscall>
  802296:	83 c4 18             	add    $0x18,%esp
}
  802299:	90                   	nop
  80229a:	c9                   	leave  
  80229b:	c3                   	ret    

0080229c <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  80229c:	55                   	push   %ebp
  80229d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80229f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 00                	push   $0x0
  8022a9:	6a 00                	push   $0x0
  8022ab:	52                   	push   %edx
  8022ac:	50                   	push   %eax
  8022ad:	6a 05                	push   $0x5
  8022af:	e8 39 ff ff ff       	call   8021ed <syscall>
  8022b4:	83 c4 18             	add    $0x18,%esp
}
  8022b7:	c9                   	leave  
  8022b8:	c3                   	ret    

008022b9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8022b9:	55                   	push   %ebp
  8022ba:	89 e5                	mov    %esp,%ebp
  8022bc:	56                   	push   %esi
  8022bd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8022be:	8b 75 18             	mov    0x18(%ebp),%esi
  8022c1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022c4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cd:	56                   	push   %esi
  8022ce:	53                   	push   %ebx
  8022cf:	51                   	push   %ecx
  8022d0:	52                   	push   %edx
  8022d1:	50                   	push   %eax
  8022d2:	6a 06                	push   $0x6
  8022d4:	e8 14 ff ff ff       	call   8021ed <syscall>
  8022d9:	83 c4 18             	add    $0x18,%esp
}
  8022dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022df:	5b                   	pop    %ebx
  8022e0:	5e                   	pop    %esi
  8022e1:	5d                   	pop    %ebp
  8022e2:	c3                   	ret    

008022e3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8022e3:	55                   	push   %ebp
  8022e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8022e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	52                   	push   %edx
  8022f3:	50                   	push   %eax
  8022f4:	6a 07                	push   $0x7
  8022f6:	e8 f2 fe ff ff       	call   8021ed <syscall>
  8022fb:	83 c4 18             	add    $0x18,%esp
}
  8022fe:	c9                   	leave  
  8022ff:	c3                   	ret    

00802300 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802303:	6a 00                	push   $0x0
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	ff 75 0c             	pushl  0xc(%ebp)
  80230c:	ff 75 08             	pushl  0x8(%ebp)
  80230f:	6a 08                	push   $0x8
  802311:	e8 d7 fe ff ff       	call   8021ed <syscall>
  802316:	83 c4 18             	add    $0x18,%esp
}
  802319:	c9                   	leave  
  80231a:	c3                   	ret    

0080231b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80231b:	55                   	push   %ebp
  80231c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80231e:	6a 00                	push   $0x0
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	6a 00                	push   $0x0
  802326:	6a 00                	push   $0x0
  802328:	6a 09                	push   $0x9
  80232a:	e8 be fe ff ff       	call   8021ed <syscall>
  80232f:	83 c4 18             	add    $0x18,%esp
}
  802332:	c9                   	leave  
  802333:	c3                   	ret    

00802334 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802334:	55                   	push   %ebp
  802335:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802337:	6a 00                	push   $0x0
  802339:	6a 00                	push   $0x0
  80233b:	6a 00                	push   $0x0
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	6a 0a                	push   $0xa
  802343:	e8 a5 fe ff ff       	call   8021ed <syscall>
  802348:	83 c4 18             	add    $0x18,%esp
}
  80234b:	c9                   	leave  
  80234c:	c3                   	ret    

0080234d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80234d:	55                   	push   %ebp
  80234e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802350:	6a 00                	push   $0x0
  802352:	6a 00                	push   $0x0
  802354:	6a 00                	push   $0x0
  802356:	6a 00                	push   $0x0
  802358:	6a 00                	push   $0x0
  80235a:	6a 0b                	push   $0xb
  80235c:	e8 8c fe ff ff       	call   8021ed <syscall>
  802361:	83 c4 18             	add    $0x18,%esp
}
  802364:	c9                   	leave  
  802365:	c3                   	ret    

00802366 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  802366:	55                   	push   %ebp
  802367:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  802369:	6a 00                	push   $0x0
  80236b:	6a 00                	push   $0x0
  80236d:	6a 00                	push   $0x0
  80236f:	ff 75 0c             	pushl  0xc(%ebp)
  802372:	ff 75 08             	pushl  0x8(%ebp)
  802375:	6a 0d                	push   $0xd
  802377:	e8 71 fe ff ff       	call   8021ed <syscall>
  80237c:	83 c4 18             	add    $0x18,%esp
	return;
  80237f:	90                   	nop
}
  802380:	c9                   	leave  
  802381:	c3                   	ret    

00802382 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  802382:	55                   	push   %ebp
  802383:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  802385:	6a 00                	push   $0x0
  802387:	6a 00                	push   $0x0
  802389:	6a 00                	push   $0x0
  80238b:	ff 75 0c             	pushl  0xc(%ebp)
  80238e:	ff 75 08             	pushl  0x8(%ebp)
  802391:	6a 0e                	push   $0xe
  802393:	e8 55 fe ff ff       	call   8021ed <syscall>
  802398:	83 c4 18             	add    $0x18,%esp
	return ;
  80239b:	90                   	nop
}
  80239c:	c9                   	leave  
  80239d:	c3                   	ret    

0080239e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80239e:	55                   	push   %ebp
  80239f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 00                	push   $0x0
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 0c                	push   $0xc
  8023ad:	e8 3b fe ff ff       	call   8021ed <syscall>
  8023b2:	83 c4 18             	add    $0x18,%esp
}
  8023b5:	c9                   	leave  
  8023b6:	c3                   	ret    

008023b7 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8023b7:	55                   	push   %ebp
  8023b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8023ba:	6a 00                	push   $0x0
  8023bc:	6a 00                	push   $0x0
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 10                	push   $0x10
  8023c6:	e8 22 fe ff ff       	call   8021ed <syscall>
  8023cb:	83 c4 18             	add    $0x18,%esp
}
  8023ce:	90                   	nop
  8023cf:	c9                   	leave  
  8023d0:	c3                   	ret    

008023d1 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8023d1:	55                   	push   %ebp
  8023d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 00                	push   $0x0
  8023dc:	6a 00                	push   $0x0
  8023de:	6a 11                	push   $0x11
  8023e0:	e8 08 fe ff ff       	call   8021ed <syscall>
  8023e5:	83 c4 18             	add    $0x18,%esp
}
  8023e8:	90                   	nop
  8023e9:	c9                   	leave  
  8023ea:	c3                   	ret    

008023eb <sys_cputc>:


void
sys_cputc(const char c)
{
  8023eb:	55                   	push   %ebp
  8023ec:	89 e5                	mov    %esp,%ebp
  8023ee:	83 ec 04             	sub    $0x4,%esp
  8023f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8023f7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023fb:	6a 00                	push   $0x0
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 00                	push   $0x0
  802403:	50                   	push   %eax
  802404:	6a 12                	push   $0x12
  802406:	e8 e2 fd ff ff       	call   8021ed <syscall>
  80240b:	83 c4 18             	add    $0x18,%esp
}
  80240e:	90                   	nop
  80240f:	c9                   	leave  
  802410:	c3                   	ret    

00802411 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802411:	55                   	push   %ebp
  802412:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802414:	6a 00                	push   $0x0
  802416:	6a 00                	push   $0x0
  802418:	6a 00                	push   $0x0
  80241a:	6a 00                	push   $0x0
  80241c:	6a 00                	push   $0x0
  80241e:	6a 13                	push   $0x13
  802420:	e8 c8 fd ff ff       	call   8021ed <syscall>
  802425:	83 c4 18             	add    $0x18,%esp
}
  802428:	90                   	nop
  802429:	c9                   	leave  
  80242a:	c3                   	ret    

0080242b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80242b:	55                   	push   %ebp
  80242c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80242e:	8b 45 08             	mov    0x8(%ebp),%eax
  802431:	6a 00                	push   $0x0
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	ff 75 0c             	pushl  0xc(%ebp)
  80243a:	50                   	push   %eax
  80243b:	6a 14                	push   $0x14
  80243d:	e8 ab fd ff ff       	call   8021ed <syscall>
  802442:	83 c4 18             	add    $0x18,%esp
}
  802445:	c9                   	leave  
  802446:	c3                   	ret    

00802447 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  802447:	55                   	push   %ebp
  802448:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  80244a:	8b 45 08             	mov    0x8(%ebp),%eax
  80244d:	6a 00                	push   $0x0
  80244f:	6a 00                	push   $0x0
  802451:	6a 00                	push   $0x0
  802453:	6a 00                	push   $0x0
  802455:	50                   	push   %eax
  802456:	6a 17                	push   $0x17
  802458:	e8 90 fd ff ff       	call   8021ed <syscall>
  80245d:	83 c4 18             	add    $0x18,%esp
}
  802460:	c9                   	leave  
  802461:	c3                   	ret    

00802462 <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  802462:	55                   	push   %ebp
  802463:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  802465:	8b 45 08             	mov    0x8(%ebp),%eax
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	6a 00                	push   $0x0
  80246e:	6a 00                	push   $0x0
  802470:	50                   	push   %eax
  802471:	6a 15                	push   $0x15
  802473:	e8 75 fd ff ff       	call   8021ed <syscall>
  802478:	83 c4 18             	add    $0x18,%esp
}
  80247b:	90                   	nop
  80247c:	c9                   	leave  
  80247d:	c3                   	ret    

0080247e <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  80247e:	55                   	push   %ebp
  80247f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  802481:	8b 45 08             	mov    0x8(%ebp),%eax
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	6a 00                	push   $0x0
  80248c:	50                   	push   %eax
  80248d:	6a 16                	push   $0x16
  80248f:	e8 59 fd ff ff       	call   8021ed <syscall>
  802494:	83 c4 18             	add    $0x18,%esp
}
  802497:	90                   	nop
  802498:	c9                   	leave  
  802499:	c3                   	ret    

0080249a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  80249a:	55                   	push   %ebp
  80249b:	89 e5                	mov    %esp,%ebp
  80249d:	83 ec 04             	sub    $0x4,%esp
  8024a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8024a3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  8024a6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8024a9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8024ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b0:	6a 00                	push   $0x0
  8024b2:	51                   	push   %ecx
  8024b3:	52                   	push   %edx
  8024b4:	ff 75 0c             	pushl  0xc(%ebp)
  8024b7:	50                   	push   %eax
  8024b8:	6a 18                	push   $0x18
  8024ba:	e8 2e fd ff ff       	call   8021ed <syscall>
  8024bf:	83 c4 18             	add    $0x18,%esp
}
  8024c2:	c9                   	leave  
  8024c3:	c3                   	ret    

008024c4 <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  8024c4:	55                   	push   %ebp
  8024c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  8024c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cd:	6a 00                	push   $0x0
  8024cf:	6a 00                	push   $0x0
  8024d1:	6a 00                	push   $0x0
  8024d3:	52                   	push   %edx
  8024d4:	50                   	push   %eax
  8024d5:	6a 19                	push   $0x19
  8024d7:	e8 11 fd ff ff       	call   8021ed <syscall>
  8024dc:	83 c4 18             	add    $0x18,%esp
}
  8024df:	c9                   	leave  
  8024e0:	c3                   	ret    

008024e1 <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  8024e1:	55                   	push   %ebp
  8024e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  8024e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e7:	6a 00                	push   $0x0
  8024e9:	6a 00                	push   $0x0
  8024eb:	6a 00                	push   $0x0
  8024ed:	6a 00                	push   $0x0
  8024ef:	50                   	push   %eax
  8024f0:	6a 1a                	push   $0x1a
  8024f2:	e8 f6 fc ff ff       	call   8021ed <syscall>
  8024f7:	83 c4 18             	add    $0x18,%esp
}
  8024fa:	c9                   	leave  
  8024fb:	c3                   	ret    

008024fc <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  8024fc:	55                   	push   %ebp
  8024fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  8024ff:	6a 00                	push   $0x0
  802501:	6a 00                	push   $0x0
  802503:	6a 00                	push   $0x0
  802505:	6a 00                	push   $0x0
  802507:	6a 00                	push   $0x0
  802509:	6a 1b                	push   $0x1b
  80250b:	e8 dd fc ff ff       	call   8021ed <syscall>
  802510:	83 c4 18             	add    $0x18,%esp
}
  802513:	c9                   	leave  
  802514:	c3                   	ret    

00802515 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802515:	55                   	push   %ebp
  802516:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802518:	6a 00                	push   $0x0
  80251a:	6a 00                	push   $0x0
  80251c:	6a 00                	push   $0x0
  80251e:	6a 00                	push   $0x0
  802520:	6a 00                	push   $0x0
  802522:	6a 1c                	push   $0x1c
  802524:	e8 c4 fc ff ff       	call   8021ed <syscall>
  802529:	83 c4 18             	add    $0x18,%esp
}
  80252c:	c9                   	leave  
  80252d:	c3                   	ret    

0080252e <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  80252e:	55                   	push   %ebp
  80252f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  802531:	8b 45 08             	mov    0x8(%ebp),%eax
  802534:	6a 00                	push   $0x0
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	ff 75 0c             	pushl  0xc(%ebp)
  80253d:	50                   	push   %eax
  80253e:	6a 1d                	push   $0x1d
  802540:	e8 a8 fc ff ff       	call   8021ed <syscall>
  802545:	83 c4 18             	add    $0x18,%esp
}
  802548:	c9                   	leave  
  802549:	c3                   	ret    

0080254a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80254a:	55                   	push   %ebp
  80254b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80254d:	8b 45 08             	mov    0x8(%ebp),%eax
  802550:	6a 00                	push   $0x0
  802552:	6a 00                	push   $0x0
  802554:	6a 00                	push   $0x0
  802556:	6a 00                	push   $0x0
  802558:	50                   	push   %eax
  802559:	6a 1e                	push   $0x1e
  80255b:	e8 8d fc ff ff       	call   8021ed <syscall>
  802560:	83 c4 18             	add    $0x18,%esp
}
  802563:	90                   	nop
  802564:	c9                   	leave  
  802565:	c3                   	ret    

00802566 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  802566:	55                   	push   %ebp
  802567:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  802569:	8b 45 08             	mov    0x8(%ebp),%eax
  80256c:	6a 00                	push   $0x0
  80256e:	6a 00                	push   $0x0
  802570:	6a 00                	push   $0x0
  802572:	6a 00                	push   $0x0
  802574:	50                   	push   %eax
  802575:	6a 1f                	push   $0x1f
  802577:	e8 71 fc ff ff       	call   8021ed <syscall>
  80257c:	83 c4 18             	add    $0x18,%esp
}
  80257f:	90                   	nop
  802580:	c9                   	leave  
  802581:	c3                   	ret    

00802582 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  802582:	55                   	push   %ebp
  802583:	89 e5                	mov    %esp,%ebp
  802585:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802588:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80258b:	8d 50 04             	lea    0x4(%eax),%edx
  80258e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802591:	6a 00                	push   $0x0
  802593:	6a 00                	push   $0x0
  802595:	6a 00                	push   $0x0
  802597:	52                   	push   %edx
  802598:	50                   	push   %eax
  802599:	6a 20                	push   $0x20
  80259b:	e8 4d fc ff ff       	call   8021ed <syscall>
  8025a0:	83 c4 18             	add    $0x18,%esp
	return result;
  8025a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8025ac:	89 01                	mov    %eax,(%ecx)
  8025ae:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8025b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b4:	c9                   	leave  
  8025b5:	c2 04 00             	ret    $0x4

008025b8 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8025b8:	55                   	push   %ebp
  8025b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8025bb:	6a 00                	push   $0x0
  8025bd:	6a 00                	push   $0x0
  8025bf:	ff 75 10             	pushl  0x10(%ebp)
  8025c2:	ff 75 0c             	pushl  0xc(%ebp)
  8025c5:	ff 75 08             	pushl  0x8(%ebp)
  8025c8:	6a 0f                	push   $0xf
  8025ca:	e8 1e fc ff ff       	call   8021ed <syscall>
  8025cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8025d2:	90                   	nop
}
  8025d3:	c9                   	leave  
  8025d4:	c3                   	ret    

008025d5 <sys_rcr2>:
uint32 sys_rcr2()
{
  8025d5:	55                   	push   %ebp
  8025d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8025d8:	6a 00                	push   $0x0
  8025da:	6a 00                	push   $0x0
  8025dc:	6a 00                	push   $0x0
  8025de:	6a 00                	push   $0x0
  8025e0:	6a 00                	push   $0x0
  8025e2:	6a 21                	push   $0x21
  8025e4:	e8 04 fc ff ff       	call   8021ed <syscall>
  8025e9:	83 c4 18             	add    $0x18,%esp
}
  8025ec:	c9                   	leave  
  8025ed:	c3                   	ret    

008025ee <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8025ee:	55                   	push   %ebp
  8025ef:	89 e5                	mov    %esp,%ebp
  8025f1:	83 ec 04             	sub    $0x4,%esp
  8025f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8025fa:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8025fe:	6a 00                	push   $0x0
  802600:	6a 00                	push   $0x0
  802602:	6a 00                	push   $0x0
  802604:	6a 00                	push   $0x0
  802606:	50                   	push   %eax
  802607:	6a 22                	push   $0x22
  802609:	e8 df fb ff ff       	call   8021ed <syscall>
  80260e:	83 c4 18             	add    $0x18,%esp
	return ;
  802611:	90                   	nop
}
  802612:	c9                   	leave  
  802613:	c3                   	ret    

00802614 <rsttst>:
void rsttst()
{
  802614:	55                   	push   %ebp
  802615:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802617:	6a 00                	push   $0x0
  802619:	6a 00                	push   $0x0
  80261b:	6a 00                	push   $0x0
  80261d:	6a 00                	push   $0x0
  80261f:	6a 00                	push   $0x0
  802621:	6a 24                	push   $0x24
  802623:	e8 c5 fb ff ff       	call   8021ed <syscall>
  802628:	83 c4 18             	add    $0x18,%esp
	return ;
  80262b:	90                   	nop
}
  80262c:	c9                   	leave  
  80262d:	c3                   	ret    

0080262e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80262e:	55                   	push   %ebp
  80262f:	89 e5                	mov    %esp,%ebp
  802631:	83 ec 04             	sub    $0x4,%esp
  802634:	8b 45 14             	mov    0x14(%ebp),%eax
  802637:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80263a:	8b 55 18             	mov    0x18(%ebp),%edx
  80263d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802641:	52                   	push   %edx
  802642:	50                   	push   %eax
  802643:	ff 75 10             	pushl  0x10(%ebp)
  802646:	ff 75 0c             	pushl  0xc(%ebp)
  802649:	ff 75 08             	pushl  0x8(%ebp)
  80264c:	6a 23                	push   $0x23
  80264e:	e8 9a fb ff ff       	call   8021ed <syscall>
  802653:	83 c4 18             	add    $0x18,%esp
	return ;
  802656:	90                   	nop
}
  802657:	c9                   	leave  
  802658:	c3                   	ret    

00802659 <chktst>:
void chktst(uint32 n)
{
  802659:	55                   	push   %ebp
  80265a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80265c:	6a 00                	push   $0x0
  80265e:	6a 00                	push   $0x0
  802660:	6a 00                	push   $0x0
  802662:	6a 00                	push   $0x0
  802664:	ff 75 08             	pushl  0x8(%ebp)
  802667:	6a 25                	push   $0x25
  802669:	e8 7f fb ff ff       	call   8021ed <syscall>
  80266e:	83 c4 18             	add    $0x18,%esp
	return ;
  802671:	90                   	nop
}
  802672:	c9                   	leave  
  802673:	c3                   	ret    

00802674 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802674:	55                   	push   %ebp
  802675:	89 e5                	mov    %esp,%ebp
  802677:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80267a:	6a 00                	push   $0x0
  80267c:	6a 00                	push   $0x0
  80267e:	6a 00                	push   $0x0
  802680:	6a 00                	push   $0x0
  802682:	6a 00                	push   $0x0
  802684:	6a 26                	push   $0x26
  802686:	e8 62 fb ff ff       	call   8021ed <syscall>
  80268b:	83 c4 18             	add    $0x18,%esp
  80268e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802691:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802695:	75 07                	jne    80269e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802697:	b8 01 00 00 00       	mov    $0x1,%eax
  80269c:	eb 05                	jmp    8026a3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80269e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026a3:	c9                   	leave  
  8026a4:	c3                   	ret    

008026a5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8026a5:	55                   	push   %ebp
  8026a6:	89 e5                	mov    %esp,%ebp
  8026a8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026ab:	6a 00                	push   $0x0
  8026ad:	6a 00                	push   $0x0
  8026af:	6a 00                	push   $0x0
  8026b1:	6a 00                	push   $0x0
  8026b3:	6a 00                	push   $0x0
  8026b5:	6a 26                	push   $0x26
  8026b7:	e8 31 fb ff ff       	call   8021ed <syscall>
  8026bc:	83 c4 18             	add    $0x18,%esp
  8026bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8026c2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8026c6:	75 07                	jne    8026cf <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8026c8:	b8 01 00 00 00       	mov    $0x1,%eax
  8026cd:	eb 05                	jmp    8026d4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8026cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026d4:	c9                   	leave  
  8026d5:	c3                   	ret    

008026d6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8026d6:	55                   	push   %ebp
  8026d7:	89 e5                	mov    %esp,%ebp
  8026d9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026dc:	6a 00                	push   $0x0
  8026de:	6a 00                	push   $0x0
  8026e0:	6a 00                	push   $0x0
  8026e2:	6a 00                	push   $0x0
  8026e4:	6a 00                	push   $0x0
  8026e6:	6a 26                	push   $0x26
  8026e8:	e8 00 fb ff ff       	call   8021ed <syscall>
  8026ed:	83 c4 18             	add    $0x18,%esp
  8026f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8026f3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8026f7:	75 07                	jne    802700 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8026f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8026fe:	eb 05                	jmp    802705 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802700:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802705:	c9                   	leave  
  802706:	c3                   	ret    

00802707 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802707:	55                   	push   %ebp
  802708:	89 e5                	mov    %esp,%ebp
  80270a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80270d:	6a 00                	push   $0x0
  80270f:	6a 00                	push   $0x0
  802711:	6a 00                	push   $0x0
  802713:	6a 00                	push   $0x0
  802715:	6a 00                	push   $0x0
  802717:	6a 26                	push   $0x26
  802719:	e8 cf fa ff ff       	call   8021ed <syscall>
  80271e:	83 c4 18             	add    $0x18,%esp
  802721:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802724:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802728:	75 07                	jne    802731 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80272a:	b8 01 00 00 00       	mov    $0x1,%eax
  80272f:	eb 05                	jmp    802736 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802731:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802736:	c9                   	leave  
  802737:	c3                   	ret    

00802738 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802738:	55                   	push   %ebp
  802739:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80273b:	6a 00                	push   $0x0
  80273d:	6a 00                	push   $0x0
  80273f:	6a 00                	push   $0x0
  802741:	6a 00                	push   $0x0
  802743:	ff 75 08             	pushl  0x8(%ebp)
  802746:	6a 27                	push   $0x27
  802748:	e8 a0 fa ff ff       	call   8021ed <syscall>
  80274d:	83 c4 18             	add    $0x18,%esp
	return ;
  802750:	90                   	nop
}
  802751:	c9                   	leave  
  802752:	c3                   	ret    
  802753:	90                   	nop

00802754 <__udivdi3>:
  802754:	55                   	push   %ebp
  802755:	57                   	push   %edi
  802756:	56                   	push   %esi
  802757:	53                   	push   %ebx
  802758:	83 ec 1c             	sub    $0x1c,%esp
  80275b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80275f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802763:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802767:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80276b:	89 ca                	mov    %ecx,%edx
  80276d:	89 f8                	mov    %edi,%eax
  80276f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802773:	85 f6                	test   %esi,%esi
  802775:	75 2d                	jne    8027a4 <__udivdi3+0x50>
  802777:	39 cf                	cmp    %ecx,%edi
  802779:	77 65                	ja     8027e0 <__udivdi3+0x8c>
  80277b:	89 fd                	mov    %edi,%ebp
  80277d:	85 ff                	test   %edi,%edi
  80277f:	75 0b                	jne    80278c <__udivdi3+0x38>
  802781:	b8 01 00 00 00       	mov    $0x1,%eax
  802786:	31 d2                	xor    %edx,%edx
  802788:	f7 f7                	div    %edi
  80278a:	89 c5                	mov    %eax,%ebp
  80278c:	31 d2                	xor    %edx,%edx
  80278e:	89 c8                	mov    %ecx,%eax
  802790:	f7 f5                	div    %ebp
  802792:	89 c1                	mov    %eax,%ecx
  802794:	89 d8                	mov    %ebx,%eax
  802796:	f7 f5                	div    %ebp
  802798:	89 cf                	mov    %ecx,%edi
  80279a:	89 fa                	mov    %edi,%edx
  80279c:	83 c4 1c             	add    $0x1c,%esp
  80279f:	5b                   	pop    %ebx
  8027a0:	5e                   	pop    %esi
  8027a1:	5f                   	pop    %edi
  8027a2:	5d                   	pop    %ebp
  8027a3:	c3                   	ret    
  8027a4:	39 ce                	cmp    %ecx,%esi
  8027a6:	77 28                	ja     8027d0 <__udivdi3+0x7c>
  8027a8:	0f bd fe             	bsr    %esi,%edi
  8027ab:	83 f7 1f             	xor    $0x1f,%edi
  8027ae:	75 40                	jne    8027f0 <__udivdi3+0x9c>
  8027b0:	39 ce                	cmp    %ecx,%esi
  8027b2:	72 0a                	jb     8027be <__udivdi3+0x6a>
  8027b4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8027b8:	0f 87 9e 00 00 00    	ja     80285c <__udivdi3+0x108>
  8027be:	b8 01 00 00 00       	mov    $0x1,%eax
  8027c3:	89 fa                	mov    %edi,%edx
  8027c5:	83 c4 1c             	add    $0x1c,%esp
  8027c8:	5b                   	pop    %ebx
  8027c9:	5e                   	pop    %esi
  8027ca:	5f                   	pop    %edi
  8027cb:	5d                   	pop    %ebp
  8027cc:	c3                   	ret    
  8027cd:	8d 76 00             	lea    0x0(%esi),%esi
  8027d0:	31 ff                	xor    %edi,%edi
  8027d2:	31 c0                	xor    %eax,%eax
  8027d4:	89 fa                	mov    %edi,%edx
  8027d6:	83 c4 1c             	add    $0x1c,%esp
  8027d9:	5b                   	pop    %ebx
  8027da:	5e                   	pop    %esi
  8027db:	5f                   	pop    %edi
  8027dc:	5d                   	pop    %ebp
  8027dd:	c3                   	ret    
  8027de:	66 90                	xchg   %ax,%ax
  8027e0:	89 d8                	mov    %ebx,%eax
  8027e2:	f7 f7                	div    %edi
  8027e4:	31 ff                	xor    %edi,%edi
  8027e6:	89 fa                	mov    %edi,%edx
  8027e8:	83 c4 1c             	add    $0x1c,%esp
  8027eb:	5b                   	pop    %ebx
  8027ec:	5e                   	pop    %esi
  8027ed:	5f                   	pop    %edi
  8027ee:	5d                   	pop    %ebp
  8027ef:	c3                   	ret    
  8027f0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8027f5:	89 eb                	mov    %ebp,%ebx
  8027f7:	29 fb                	sub    %edi,%ebx
  8027f9:	89 f9                	mov    %edi,%ecx
  8027fb:	d3 e6                	shl    %cl,%esi
  8027fd:	89 c5                	mov    %eax,%ebp
  8027ff:	88 d9                	mov    %bl,%cl
  802801:	d3 ed                	shr    %cl,%ebp
  802803:	89 e9                	mov    %ebp,%ecx
  802805:	09 f1                	or     %esi,%ecx
  802807:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80280b:	89 f9                	mov    %edi,%ecx
  80280d:	d3 e0                	shl    %cl,%eax
  80280f:	89 c5                	mov    %eax,%ebp
  802811:	89 d6                	mov    %edx,%esi
  802813:	88 d9                	mov    %bl,%cl
  802815:	d3 ee                	shr    %cl,%esi
  802817:	89 f9                	mov    %edi,%ecx
  802819:	d3 e2                	shl    %cl,%edx
  80281b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80281f:	88 d9                	mov    %bl,%cl
  802821:	d3 e8                	shr    %cl,%eax
  802823:	09 c2                	or     %eax,%edx
  802825:	89 d0                	mov    %edx,%eax
  802827:	89 f2                	mov    %esi,%edx
  802829:	f7 74 24 0c          	divl   0xc(%esp)
  80282d:	89 d6                	mov    %edx,%esi
  80282f:	89 c3                	mov    %eax,%ebx
  802831:	f7 e5                	mul    %ebp
  802833:	39 d6                	cmp    %edx,%esi
  802835:	72 19                	jb     802850 <__udivdi3+0xfc>
  802837:	74 0b                	je     802844 <__udivdi3+0xf0>
  802839:	89 d8                	mov    %ebx,%eax
  80283b:	31 ff                	xor    %edi,%edi
  80283d:	e9 58 ff ff ff       	jmp    80279a <__udivdi3+0x46>
  802842:	66 90                	xchg   %ax,%ax
  802844:	8b 54 24 08          	mov    0x8(%esp),%edx
  802848:	89 f9                	mov    %edi,%ecx
  80284a:	d3 e2                	shl    %cl,%edx
  80284c:	39 c2                	cmp    %eax,%edx
  80284e:	73 e9                	jae    802839 <__udivdi3+0xe5>
  802850:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802853:	31 ff                	xor    %edi,%edi
  802855:	e9 40 ff ff ff       	jmp    80279a <__udivdi3+0x46>
  80285a:	66 90                	xchg   %ax,%ax
  80285c:	31 c0                	xor    %eax,%eax
  80285e:	e9 37 ff ff ff       	jmp    80279a <__udivdi3+0x46>
  802863:	90                   	nop

00802864 <__umoddi3>:
  802864:	55                   	push   %ebp
  802865:	57                   	push   %edi
  802866:	56                   	push   %esi
  802867:	53                   	push   %ebx
  802868:	83 ec 1c             	sub    $0x1c,%esp
  80286b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80286f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802873:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802877:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80287b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80287f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802883:	89 f3                	mov    %esi,%ebx
  802885:	89 fa                	mov    %edi,%edx
  802887:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80288b:	89 34 24             	mov    %esi,(%esp)
  80288e:	85 c0                	test   %eax,%eax
  802890:	75 1a                	jne    8028ac <__umoddi3+0x48>
  802892:	39 f7                	cmp    %esi,%edi
  802894:	0f 86 a2 00 00 00    	jbe    80293c <__umoddi3+0xd8>
  80289a:	89 c8                	mov    %ecx,%eax
  80289c:	89 f2                	mov    %esi,%edx
  80289e:	f7 f7                	div    %edi
  8028a0:	89 d0                	mov    %edx,%eax
  8028a2:	31 d2                	xor    %edx,%edx
  8028a4:	83 c4 1c             	add    $0x1c,%esp
  8028a7:	5b                   	pop    %ebx
  8028a8:	5e                   	pop    %esi
  8028a9:	5f                   	pop    %edi
  8028aa:	5d                   	pop    %ebp
  8028ab:	c3                   	ret    
  8028ac:	39 f0                	cmp    %esi,%eax
  8028ae:	0f 87 ac 00 00 00    	ja     802960 <__umoddi3+0xfc>
  8028b4:	0f bd e8             	bsr    %eax,%ebp
  8028b7:	83 f5 1f             	xor    $0x1f,%ebp
  8028ba:	0f 84 ac 00 00 00    	je     80296c <__umoddi3+0x108>
  8028c0:	bf 20 00 00 00       	mov    $0x20,%edi
  8028c5:	29 ef                	sub    %ebp,%edi
  8028c7:	89 fe                	mov    %edi,%esi
  8028c9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028cd:	89 e9                	mov    %ebp,%ecx
  8028cf:	d3 e0                	shl    %cl,%eax
  8028d1:	89 d7                	mov    %edx,%edi
  8028d3:	89 f1                	mov    %esi,%ecx
  8028d5:	d3 ef                	shr    %cl,%edi
  8028d7:	09 c7                	or     %eax,%edi
  8028d9:	89 e9                	mov    %ebp,%ecx
  8028db:	d3 e2                	shl    %cl,%edx
  8028dd:	89 14 24             	mov    %edx,(%esp)
  8028e0:	89 d8                	mov    %ebx,%eax
  8028e2:	d3 e0                	shl    %cl,%eax
  8028e4:	89 c2                	mov    %eax,%edx
  8028e6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8028ea:	d3 e0                	shl    %cl,%eax
  8028ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028f0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8028f4:	89 f1                	mov    %esi,%ecx
  8028f6:	d3 e8                	shr    %cl,%eax
  8028f8:	09 d0                	or     %edx,%eax
  8028fa:	d3 eb                	shr    %cl,%ebx
  8028fc:	89 da                	mov    %ebx,%edx
  8028fe:	f7 f7                	div    %edi
  802900:	89 d3                	mov    %edx,%ebx
  802902:	f7 24 24             	mull   (%esp)
  802905:	89 c6                	mov    %eax,%esi
  802907:	89 d1                	mov    %edx,%ecx
  802909:	39 d3                	cmp    %edx,%ebx
  80290b:	0f 82 87 00 00 00    	jb     802998 <__umoddi3+0x134>
  802911:	0f 84 91 00 00 00    	je     8029a8 <__umoddi3+0x144>
  802917:	8b 54 24 04          	mov    0x4(%esp),%edx
  80291b:	29 f2                	sub    %esi,%edx
  80291d:	19 cb                	sbb    %ecx,%ebx
  80291f:	89 d8                	mov    %ebx,%eax
  802921:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802925:	d3 e0                	shl    %cl,%eax
  802927:	89 e9                	mov    %ebp,%ecx
  802929:	d3 ea                	shr    %cl,%edx
  80292b:	09 d0                	or     %edx,%eax
  80292d:	89 e9                	mov    %ebp,%ecx
  80292f:	d3 eb                	shr    %cl,%ebx
  802931:	89 da                	mov    %ebx,%edx
  802933:	83 c4 1c             	add    $0x1c,%esp
  802936:	5b                   	pop    %ebx
  802937:	5e                   	pop    %esi
  802938:	5f                   	pop    %edi
  802939:	5d                   	pop    %ebp
  80293a:	c3                   	ret    
  80293b:	90                   	nop
  80293c:	89 fd                	mov    %edi,%ebp
  80293e:	85 ff                	test   %edi,%edi
  802940:	75 0b                	jne    80294d <__umoddi3+0xe9>
  802942:	b8 01 00 00 00       	mov    $0x1,%eax
  802947:	31 d2                	xor    %edx,%edx
  802949:	f7 f7                	div    %edi
  80294b:	89 c5                	mov    %eax,%ebp
  80294d:	89 f0                	mov    %esi,%eax
  80294f:	31 d2                	xor    %edx,%edx
  802951:	f7 f5                	div    %ebp
  802953:	89 c8                	mov    %ecx,%eax
  802955:	f7 f5                	div    %ebp
  802957:	89 d0                	mov    %edx,%eax
  802959:	e9 44 ff ff ff       	jmp    8028a2 <__umoddi3+0x3e>
  80295e:	66 90                	xchg   %ax,%ax
  802960:	89 c8                	mov    %ecx,%eax
  802962:	89 f2                	mov    %esi,%edx
  802964:	83 c4 1c             	add    $0x1c,%esp
  802967:	5b                   	pop    %ebx
  802968:	5e                   	pop    %esi
  802969:	5f                   	pop    %edi
  80296a:	5d                   	pop    %ebp
  80296b:	c3                   	ret    
  80296c:	3b 04 24             	cmp    (%esp),%eax
  80296f:	72 06                	jb     802977 <__umoddi3+0x113>
  802971:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802975:	77 0f                	ja     802986 <__umoddi3+0x122>
  802977:	89 f2                	mov    %esi,%edx
  802979:	29 f9                	sub    %edi,%ecx
  80297b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80297f:	89 14 24             	mov    %edx,(%esp)
  802982:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802986:	8b 44 24 04          	mov    0x4(%esp),%eax
  80298a:	8b 14 24             	mov    (%esp),%edx
  80298d:	83 c4 1c             	add    $0x1c,%esp
  802990:	5b                   	pop    %ebx
  802991:	5e                   	pop    %esi
  802992:	5f                   	pop    %edi
  802993:	5d                   	pop    %ebp
  802994:	c3                   	ret    
  802995:	8d 76 00             	lea    0x0(%esi),%esi
  802998:	2b 04 24             	sub    (%esp),%eax
  80299b:	19 fa                	sbb    %edi,%edx
  80299d:	89 d1                	mov    %edx,%ecx
  80299f:	89 c6                	mov    %eax,%esi
  8029a1:	e9 71 ff ff ff       	jmp    802917 <__umoddi3+0xb3>
  8029a6:	66 90                	xchg   %ax,%ax
  8029a8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8029ac:	72 ea                	jb     802998 <__umoddi3+0x134>
  8029ae:	89 d9                	mov    %ebx,%ecx
  8029b0:	e9 62 ff ff ff       	jmp    802917 <__umoddi3+0xb3>
