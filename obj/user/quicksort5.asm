
obj/user/quicksort5:     file format elf32-i386


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
  800031:	e8 54 06 00 00       	call   80068a <libmain>
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
  80003c:	81 ec c4 63 00 00    	sub    $0x63c4,%esp
	//int InitFreeFrames = sys_calculate_free_frames() ;
	char Line[25500] ;
	char Chose ;
	int Iteration = 0 ;
  800042:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	sys_createSemaphore("1", 1);
  800049:	83 ec 08             	sub    $0x8,%esp
  80004c:	6a 01                	push   $0x1
  80004e:	68 80 2a 80 00       	push   $0x802a80
  800053:	e8 87 24 00 00       	call   8024df <sys_createSemaphore>
  800058:	83 c4 10             	add    $0x10,%esp
	do
	{
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames();
  80005b:	e8 6f 23 00 00       	call   8023cf <sys_calculate_free_frames>
  800060:	89 c3                	mov    %eax,%ebx
  800062:	e8 81 23 00 00       	call   8023e8 <sys_calculate_modified_frames>
  800067:	01 d8                	add    %ebx,%eax
  800069:	89 45 e8             	mov    %eax,-0x18(%ebp)

		Iteration++ ;
  80006c:	ff 45 f4             	incl   -0xc(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

//	sys_disable_interrupt();
		sys_waitSemaphore("1");
  80006f:	83 ec 0c             	sub    $0xc,%esp
  800072:	68 80 2a 80 00       	push   $0x802a80
  800077:	e8 9a 24 00 00       	call   802516 <sys_waitSemaphore>
  80007c:	83 c4 10             	add    $0x10,%esp
		readline("Enter the number of elements: ", Line);
  80007f:	83 ec 08             	sub    $0x8,%esp
  800082:	8d 85 3c 9c ff ff    	lea    -0x63c4(%ebp),%eax
  800088:	50                   	push   %eax
  800089:	68 84 2a 80 00       	push   $0x802a84
  80008e:	e8 5e 0e 00 00       	call   800ef1 <readline>
  800093:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  800096:	83 ec 04             	sub    $0x4,%esp
  800099:	6a 0a                	push   $0xa
  80009b:	6a 00                	push   $0x0
  80009d:	8d 85 3c 9c ff ff    	lea    -0x63c4(%ebp),%eax
  8000a3:	50                   	push   %eax
  8000a4:	e8 ae 13 00 00       	call   801457 <strtol>
  8000a9:	83 c4 10             	add    $0x10,%esp
  8000ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000b2:	c1 e0 02             	shl    $0x2,%eax
  8000b5:	83 ec 0c             	sub    $0xc,%esp
  8000b8:	50                   	push   %eax
  8000b9:	e8 41 17 00 00       	call   8017ff <malloc>
  8000be:	83 c4 10             	add    $0x10,%esp
  8000c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		//		cprintf("Free Frames After Allocation = %d\n", sys_calculate_free_frames()) ;
		cprintf("Choose the initialization method:\n") ;
  8000c4:	83 ec 0c             	sub    $0xc,%esp
  8000c7:	68 a4 2a 80 00       	push   $0x802aa4
  8000cc:	e8 a5 07 00 00       	call   800876 <cprintf>
  8000d1:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	68 c7 2a 80 00       	push   $0x802ac7
  8000dc:	e8 95 07 00 00       	call   800876 <cprintf>
  8000e1:	83 c4 10             	add    $0x10,%esp
		int ii, j = 0 ;
  8000e4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (ii = 0 ; ii < 100000; ii++)
  8000eb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000f2:	eb 09                	jmp    8000fd <_main+0xc5>
		{
			j+= ii;
  8000f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000f7:	01 45 ec             	add    %eax,-0x14(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
		//		cprintf("Free Frames After Allocation = %d\n", sys_calculate_free_frames()) ;
		cprintf("Choose the initialization method:\n") ;
		cprintf("a) Ascending\n") ;
		int ii, j = 0 ;
		for (ii = 0 ; ii < 100000; ii++)
  8000fa:	ff 45 f0             	incl   -0x10(%ebp)
  8000fd:	81 7d f0 9f 86 01 00 	cmpl   $0x1869f,-0x10(%ebp)
  800104:	7e ee                	jle    8000f4 <_main+0xbc>
		{
			j+= ii;
		}
		cprintf("b) Descending\n") ;
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	68 d5 2a 80 00       	push   $0x802ad5
  80010e:	e8 63 07 00 00       	call   800876 <cprintf>
  800113:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\nSelect: ") ;
  800116:	83 ec 0c             	sub    $0xc,%esp
  800119:	68 e4 2a 80 00       	push   $0x802ae4
  80011e:	e8 53 07 00 00       	call   800876 <cprintf>
  800123:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  800126:	e8 07 05 00 00       	call   800632 <getchar>
  80012b:	88 45 df             	mov    %al,-0x21(%ebp)
		cputchar(Chose);
  80012e:	0f be 45 df          	movsbl -0x21(%ebp),%eax
  800132:	83 ec 0c             	sub    $0xc,%esp
  800135:	50                   	push   %eax
  800136:	e8 af 04 00 00       	call   8005ea <cputchar>
  80013b:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  80013e:	83 ec 0c             	sub    $0xc,%esp
  800141:	6a 0a                	push   $0xa
  800143:	e8 a2 04 00 00       	call   8005ea <cputchar>
  800148:	83 c4 10             	add    $0x10,%esp
		sys_signalSemaphore("1");
  80014b:	83 ec 0c             	sub    $0xc,%esp
  80014e:	68 80 2a 80 00       	push   $0x802a80
  800153:	e8 da 23 00 00       	call   802532 <sys_signalSemaphore>
  800158:	83 c4 10             	add    $0x10,%esp
		//sys_enable_interrupt();
		int  i ;
		switch (Chose)
  80015b:	0f be 45 df          	movsbl -0x21(%ebp),%eax
  80015f:	83 f8 62             	cmp    $0x62,%eax
  800162:	74 1d                	je     800181 <_main+0x149>
  800164:	83 f8 63             	cmp    $0x63,%eax
  800167:	74 2b                	je     800194 <_main+0x15c>
  800169:	83 f8 61             	cmp    $0x61,%eax
  80016c:	75 39                	jne    8001a7 <_main+0x16f>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80016e:	83 ec 08             	sub    $0x8,%esp
  800171:	ff 75 e4             	pushl  -0x1c(%ebp)
  800174:	ff 75 e0             	pushl  -0x20(%ebp)
  800177:	e8 36 03 00 00       	call   8004b2 <InitializeAscending>
  80017c:	83 c4 10             	add    $0x10,%esp
			break ;
  80017f:	eb 37                	jmp    8001b8 <_main+0x180>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  800181:	83 ec 08             	sub    $0x8,%esp
  800184:	ff 75 e4             	pushl  -0x1c(%ebp)
  800187:	ff 75 e0             	pushl  -0x20(%ebp)
  80018a:	e8 54 03 00 00       	call   8004e3 <InitializeDescending>
  80018f:	83 c4 10             	add    $0x10,%esp
			break ;
  800192:	eb 24                	jmp    8001b8 <_main+0x180>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800194:	83 ec 08             	sub    $0x8,%esp
  800197:	ff 75 e4             	pushl  -0x1c(%ebp)
  80019a:	ff 75 e0             	pushl  -0x20(%ebp)
  80019d:	e8 76 03 00 00       	call   800518 <InitializeSemiRandom>
  8001a2:	83 c4 10             	add    $0x10,%esp
			break ;
  8001a5:	eb 11                	jmp    8001b8 <_main+0x180>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001a7:	83 ec 08             	sub    $0x8,%esp
  8001aa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ad:	ff 75 e0             	pushl  -0x20(%ebp)
  8001b0:	e8 63 03 00 00       	call   800518 <InitializeSemiRandom>
  8001b5:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001b8:	83 ec 08             	sub    $0x8,%esp
  8001bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001be:	ff 75 e0             	pushl  -0x20(%ebp)
  8001c1:	e8 31 01 00 00       	call   8002f7 <QuickSort>
  8001c6:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001c9:	83 ec 08             	sub    $0x8,%esp
  8001cc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001cf:	ff 75 e0             	pushl  -0x20(%ebp)
  8001d2:	e8 31 02 00 00       	call   800408 <CheckSorted>
  8001d7:	83 c4 10             	add    $0x10,%esp
  8001da:	89 45 d8             	mov    %eax,-0x28(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001dd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8001e1:	75 14                	jne    8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 fc 2a 80 00       	push   $0x802afc
  8001eb:	6a 4a                	push   $0x4a
  8001ed:	68 1e 2b 80 00       	push   $0x802b1e
  8001f2:	e8 54 05 00 00       	call   80074b <_panic>
		else
		{ 
			sys_waitSemaphore("1");
  8001f7:	83 ec 0c             	sub    $0xc,%esp
  8001fa:	68 80 2a 80 00       	push   $0x802a80
  8001ff:	e8 12 23 00 00       	call   802516 <sys_waitSemaphore>
  800204:	83 c4 10             	add    $0x10,%esp
			cprintf("\n===============================================\n") ;
  800207:	83 ec 0c             	sub    $0xc,%esp
  80020a:	68 30 2b 80 00       	push   $0x802b30
  80020f:	e8 62 06 00 00       	call   800876 <cprintf>
  800214:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800217:	83 ec 0c             	sub    $0xc,%esp
  80021a:	68 64 2b 80 00       	push   $0x802b64
  80021f:	e8 52 06 00 00       	call   800876 <cprintf>
  800224:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800227:	83 ec 0c             	sub    $0xc,%esp
  80022a:	68 98 2b 80 00       	push   $0x802b98
  80022f:	e8 42 06 00 00       	call   800876 <cprintf>
  800234:	83 c4 10             	add    $0x10,%esp
			sys_signalSemaphore("1");
  800237:	83 ec 0c             	sub    $0xc,%esp
  80023a:	68 80 2a 80 00       	push   $0x802a80
  80023f:	e8 ee 22 00 00       	call   802532 <sys_signalSemaphore>
  800244:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		sys_waitSemaphore("1");
  800247:	83 ec 0c             	sub    $0xc,%esp
  80024a:	68 80 2a 80 00       	push   $0x802a80
  80024f:	e8 c2 22 00 00       	call   802516 <sys_waitSemaphore>
  800254:	83 c4 10             	add    $0x10,%esp
		cprintf("Freeing the Heap...\n\n") ;
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	68 ca 2b 80 00       	push   $0x802bca
  80025f:	e8 12 06 00 00       	call   800876 <cprintf>
  800264:	83 c4 10             	add    $0x10,%esp
		sys_signalSemaphore("1");
  800267:	83 ec 0c             	sub    $0xc,%esp
  80026a:	68 80 2a 80 00       	push   $0x802a80
  80026f:	e8 be 22 00 00       	call   802532 <sys_signalSemaphore>
  800274:	83 c4 10             	add    $0x10,%esp
		free(Elements) ;
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	ff 75 e0             	pushl  -0x20(%ebp)
  80027d:	e8 1f 1f 00 00       	call   8021a1 <free>
  800282:	83 c4 10             	add    $0x10,%esp


		///========================================================================
	//sys_disable_interrupt();
		sys_waitSemaphore("1");
  800285:	83 ec 0c             	sub    $0xc,%esp
  800288:	68 80 2a 80 00       	push   $0x802a80
  80028d:	e8 84 22 00 00       	call   802516 <sys_waitSemaphore>
  800292:	83 c4 10             	add    $0x10,%esp
		cprintf("Do you want to repeat (y/n): ") ;
  800295:	83 ec 0c             	sub    $0xc,%esp
  800298:	68 e0 2b 80 00       	push   $0x802be0
  80029d:	e8 d4 05 00 00       	call   800876 <cprintf>
  8002a2:	83 c4 10             	add    $0x10,%esp

		Chose = getchar() ;
  8002a5:	e8 88 03 00 00       	call   800632 <getchar>
  8002aa:	88 45 df             	mov    %al,-0x21(%ebp)
		cputchar(Chose);
  8002ad:	0f be 45 df          	movsbl -0x21(%ebp),%eax
  8002b1:	83 ec 0c             	sub    $0xc,%esp
  8002b4:	50                   	push   %eax
  8002b5:	e8 30 03 00 00       	call   8005ea <cputchar>
  8002ba:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  8002bd:	83 ec 0c             	sub    $0xc,%esp
  8002c0:	6a 0a                	push   $0xa
  8002c2:	e8 23 03 00 00       	call   8005ea <cputchar>
  8002c7:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  8002ca:	83 ec 0c             	sub    $0xc,%esp
  8002cd:	6a 0a                	push   $0xa
  8002cf:	e8 16 03 00 00       	call   8005ea <cputchar>
  8002d4:	83 c4 10             	add    $0x10,%esp
	//sys_enable_interrupt();
		sys_signalSemaphore("1");
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	68 80 2a 80 00       	push   $0x802a80
  8002df:	e8 4e 22 00 00       	call   802532 <sys_signalSemaphore>
  8002e4:	83 c4 10             	add    $0x10,%esp

	} while (Chose == 'y');
  8002e7:	80 7d df 79          	cmpb   $0x79,-0x21(%ebp)
  8002eb:	0f 84 6a fd ff ff    	je     80005b <_main+0x23>

}
  8002f1:	90                   	nop
  8002f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002f5:	c9                   	leave  
  8002f6:	c3                   	ret    

008002f7 <QuickSort>:

///Quick sort 
void QuickSort(int *Elements, int NumOfElements)
{
  8002f7:	55                   	push   %ebp
  8002f8:	89 e5                	mov    %esp,%ebp
  8002fa:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800300:	48                   	dec    %eax
  800301:	50                   	push   %eax
  800302:	6a 00                	push   $0x0
  800304:	ff 75 0c             	pushl  0xc(%ebp)
  800307:	ff 75 08             	pushl  0x8(%ebp)
  80030a:	e8 06 00 00 00       	call   800315 <QSort>
  80030f:	83 c4 10             	add    $0x10,%esp
}
  800312:	90                   	nop
  800313:	c9                   	leave  
  800314:	c3                   	ret    

00800315 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  800315:	55                   	push   %ebp
  800316:	89 e5                	mov    %esp,%ebp
  800318:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  80031b:	8b 45 10             	mov    0x10(%ebp),%eax
  80031e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800321:	0f 8d de 00 00 00    	jge    800405 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  800327:	8b 45 10             	mov    0x10(%ebp),%eax
  80032a:	40                   	inc    %eax
  80032b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80032e:	8b 45 14             	mov    0x14(%ebp),%eax
  800331:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800334:	e9 80 00 00 00       	jmp    8003b9 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800339:	ff 45 f4             	incl   -0xc(%ebp)
  80033c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80033f:	3b 45 14             	cmp    0x14(%ebp),%eax
  800342:	7f 2b                	jg     80036f <QSort+0x5a>
  800344:	8b 45 10             	mov    0x10(%ebp),%eax
  800347:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034e:	8b 45 08             	mov    0x8(%ebp),%eax
  800351:	01 d0                	add    %edx,%eax
  800353:	8b 10                	mov    (%eax),%edx
  800355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800358:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80035f:	8b 45 08             	mov    0x8(%ebp),%eax
  800362:	01 c8                	add    %ecx,%eax
  800364:	8b 00                	mov    (%eax),%eax
  800366:	39 c2                	cmp    %eax,%edx
  800368:	7d cf                	jge    800339 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  80036a:	eb 03                	jmp    80036f <QSort+0x5a>
  80036c:	ff 4d f0             	decl   -0x10(%ebp)
  80036f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800372:	3b 45 10             	cmp    0x10(%ebp),%eax
  800375:	7e 26                	jle    80039d <QSort+0x88>
  800377:	8b 45 10             	mov    0x10(%ebp),%eax
  80037a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800381:	8b 45 08             	mov    0x8(%ebp),%eax
  800384:	01 d0                	add    %edx,%eax
  800386:	8b 10                	mov    (%eax),%edx
  800388:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80038b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800392:	8b 45 08             	mov    0x8(%ebp),%eax
  800395:	01 c8                	add    %ecx,%eax
  800397:	8b 00                	mov    (%eax),%eax
  800399:	39 c2                	cmp    %eax,%edx
  80039b:	7e cf                	jle    80036c <QSort+0x57>

		if (i <= j)
  80039d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003a0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003a3:	7f 14                	jg     8003b9 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  8003a5:	83 ec 04             	sub    $0x4,%esp
  8003a8:	ff 75 f0             	pushl  -0x10(%ebp)
  8003ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ae:	ff 75 08             	pushl  0x8(%ebp)
  8003b1:	e8 a9 00 00 00       	call   80045f <Swap>
  8003b6:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  8003b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003bc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003bf:	0f 8e 77 ff ff ff    	jle    80033c <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  8003c5:	83 ec 04             	sub    $0x4,%esp
  8003c8:	ff 75 f0             	pushl  -0x10(%ebp)
  8003cb:	ff 75 10             	pushl  0x10(%ebp)
  8003ce:	ff 75 08             	pushl  0x8(%ebp)
  8003d1:	e8 89 00 00 00       	call   80045f <Swap>
  8003d6:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8003d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003dc:	48                   	dec    %eax
  8003dd:	50                   	push   %eax
  8003de:	ff 75 10             	pushl  0x10(%ebp)
  8003e1:	ff 75 0c             	pushl  0xc(%ebp)
  8003e4:	ff 75 08             	pushl  0x8(%ebp)
  8003e7:	e8 29 ff ff ff       	call   800315 <QSort>
  8003ec:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003ef:	ff 75 14             	pushl  0x14(%ebp)
  8003f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8003f5:	ff 75 0c             	pushl  0xc(%ebp)
  8003f8:	ff 75 08             	pushl  0x8(%ebp)
  8003fb:	e8 15 ff ff ff       	call   800315 <QSort>
  800400:	83 c4 10             	add    $0x10,%esp
  800403:	eb 01                	jmp    800406 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  800405:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  800406:	c9                   	leave  
  800407:	c3                   	ret    

00800408 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  800408:	55                   	push   %ebp
  800409:	89 e5                	mov    %esp,%ebp
  80040b:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  80040e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800415:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80041c:	eb 33                	jmp    800451 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  80041e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800421:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800428:	8b 45 08             	mov    0x8(%ebp),%eax
  80042b:	01 d0                	add    %edx,%eax
  80042d:	8b 10                	mov    (%eax),%edx
  80042f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800432:	40                   	inc    %eax
  800433:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	01 c8                	add    %ecx,%eax
  80043f:	8b 00                	mov    (%eax),%eax
  800441:	39 c2                	cmp    %eax,%edx
  800443:	7e 09                	jle    80044e <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800445:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  80044c:	eb 0c                	jmp    80045a <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80044e:	ff 45 f8             	incl   -0x8(%ebp)
  800451:	8b 45 0c             	mov    0xc(%ebp),%eax
  800454:	48                   	dec    %eax
  800455:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800458:	7f c4                	jg     80041e <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  80045a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80045d:	c9                   	leave  
  80045e:	c3                   	ret    

0080045f <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80045f:	55                   	push   %ebp
  800460:	89 e5                	mov    %esp,%ebp
  800462:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800465:	8b 45 0c             	mov    0xc(%ebp),%eax
  800468:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80046f:	8b 45 08             	mov    0x8(%ebp),%eax
  800472:	01 d0                	add    %edx,%eax
  800474:	8b 00                	mov    (%eax),%eax
  800476:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800479:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800483:	8b 45 08             	mov    0x8(%ebp),%eax
  800486:	01 c2                	add    %eax,%edx
  800488:	8b 45 10             	mov    0x10(%ebp),%eax
  80048b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800492:	8b 45 08             	mov    0x8(%ebp),%eax
  800495:	01 c8                	add    %ecx,%eax
  800497:	8b 00                	mov    (%eax),%eax
  800499:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  80049b:	8b 45 10             	mov    0x10(%ebp),%eax
  80049e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	01 c2                	add    %eax,%edx
  8004aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ad:	89 02                	mov    %eax,(%edx)
}
  8004af:	90                   	nop
  8004b0:	c9                   	leave  
  8004b1:	c3                   	ret    

008004b2 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  8004b2:	55                   	push   %ebp
  8004b3:	89 e5                	mov    %esp,%ebp
  8004b5:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004bf:	eb 17                	jmp    8004d8 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  8004c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ce:	01 c2                	add    %eax,%edx
  8004d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004d3:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004d5:	ff 45 fc             	incl   -0x4(%ebp)
  8004d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004db:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004de:	7c e1                	jl     8004c1 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8004e0:	90                   	nop
  8004e1:	c9                   	leave  
  8004e2:	c3                   	ret    

008004e3 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8004e3:	55                   	push   %ebp
  8004e4:	89 e5                	mov    %esp,%ebp
  8004e6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004f0:	eb 1b                	jmp    80050d <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004f5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ff:	01 c2                	add    %eax,%edx
  800501:	8b 45 0c             	mov    0xc(%ebp),%eax
  800504:	2b 45 fc             	sub    -0x4(%ebp),%eax
  800507:	48                   	dec    %eax
  800508:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80050a:	ff 45 fc             	incl   -0x4(%ebp)
  80050d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800510:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800513:	7c dd                	jl     8004f2 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  800515:	90                   	nop
  800516:	c9                   	leave  
  800517:	c3                   	ret    

00800518 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  800518:	55                   	push   %ebp
  800519:	89 e5                	mov    %esp,%ebp
  80051b:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  80051e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800521:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800526:	f7 e9                	imul   %ecx
  800528:	c1 f9 1f             	sar    $0x1f,%ecx
  80052b:	89 d0                	mov    %edx,%eax
  80052d:	29 c8                	sub    %ecx,%eax
  80052f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800532:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800539:	eb 1e                	jmp    800559 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  80053b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80053e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800545:	8b 45 08             	mov    0x8(%ebp),%eax
  800548:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80054b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80054e:	99                   	cltd   
  80054f:	f7 7d f8             	idivl  -0x8(%ebp)
  800552:	89 d0                	mov    %edx,%eax
  800554:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800556:	ff 45 fc             	incl   -0x4(%ebp)
  800559:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80055c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80055f:	7c da                	jl     80053b <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
	}

}
  800561:	90                   	nop
  800562:	c9                   	leave  
  800563:	c3                   	ret    

00800564 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800564:	55                   	push   %ebp
  800565:	89 e5                	mov    %esp,%ebp
  800567:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  80056a:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800571:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800578:	eb 42                	jmp    8005bc <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  80057a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80057d:	99                   	cltd   
  80057e:	f7 7d f0             	idivl  -0x10(%ebp)
  800581:	89 d0                	mov    %edx,%eax
  800583:	85 c0                	test   %eax,%eax
  800585:	75 10                	jne    800597 <PrintElements+0x33>
			cprintf("\n");
  800587:	83 ec 0c             	sub    $0xc,%esp
  80058a:	68 fe 2b 80 00       	push   $0x802bfe
  80058f:	e8 e2 02 00 00       	call   800876 <cprintf>
  800594:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80059a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a4:	01 d0                	add    %edx,%eax
  8005a6:	8b 00                	mov    (%eax),%eax
  8005a8:	83 ec 08             	sub    $0x8,%esp
  8005ab:	50                   	push   %eax
  8005ac:	68 00 2c 80 00       	push   $0x802c00
  8005b1:	e8 c0 02 00 00       	call   800876 <cprintf>
  8005b6:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8005b9:	ff 45 f4             	incl   -0xc(%ebp)
  8005bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005bf:	48                   	dec    %eax
  8005c0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8005c3:	7f b5                	jg     80057a <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8005c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d2:	01 d0                	add    %edx,%eax
  8005d4:	8b 00                	mov    (%eax),%eax
  8005d6:	83 ec 08             	sub    $0x8,%esp
  8005d9:	50                   	push   %eax
  8005da:	68 05 2c 80 00       	push   $0x802c05
  8005df:	e8 92 02 00 00       	call   800876 <cprintf>
  8005e4:	83 c4 10             	add    $0x10,%esp

}
  8005e7:	90                   	nop
  8005e8:	c9                   	leave  
  8005e9:	c3                   	ret    

008005ea <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005ea:	55                   	push   %ebp
  8005eb:	89 e5                	mov    %esp,%ebp
  8005ed:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f3:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005f6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005fa:	83 ec 0c             	sub    $0xc,%esp
  8005fd:	50                   	push   %eax
  8005fe:	e8 9c 1e 00 00       	call   80249f <sys_cputc>
  800603:	83 c4 10             	add    $0x10,%esp
}
  800606:	90                   	nop
  800607:	c9                   	leave  
  800608:	c3                   	ret    

00800609 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800609:	55                   	push   %ebp
  80060a:	89 e5                	mov    %esp,%ebp
  80060c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80060f:	e8 57 1e 00 00       	call   80246b <sys_disable_interrupt>
	char c = ch;
  800614:	8b 45 08             	mov    0x8(%ebp),%eax
  800617:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80061a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80061e:	83 ec 0c             	sub    $0xc,%esp
  800621:	50                   	push   %eax
  800622:	e8 78 1e 00 00       	call   80249f <sys_cputc>
  800627:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80062a:	e8 56 1e 00 00       	call   802485 <sys_enable_interrupt>
}
  80062f:	90                   	nop
  800630:	c9                   	leave  
  800631:	c3                   	ret    

00800632 <getchar>:

int
getchar(void)
{
  800632:	55                   	push   %ebp
  800633:	89 e5                	mov    %esp,%ebp
  800635:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800638:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80063f:	eb 08                	jmp    800649 <getchar+0x17>
	{
		c = sys_cgetc();
  800641:	e8 a3 1c 00 00       	call   8022e9 <sys_cgetc>
  800646:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800649:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80064d:	74 f2                	je     800641 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80064f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800652:	c9                   	leave  
  800653:	c3                   	ret    

00800654 <atomic_getchar>:

int
atomic_getchar(void)
{
  800654:	55                   	push   %ebp
  800655:	89 e5                	mov    %esp,%ebp
  800657:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80065a:	e8 0c 1e 00 00       	call   80246b <sys_disable_interrupt>
	int c=0;
  80065f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800666:	eb 08                	jmp    800670 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800668:	e8 7c 1c 00 00       	call   8022e9 <sys_cgetc>
  80066d:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  800670:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800674:	74 f2                	je     800668 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800676:	e8 0a 1e 00 00       	call   802485 <sys_enable_interrupt>
	return c;
  80067b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80067e:	c9                   	leave  
  80067f:	c3                   	ret    

00800680 <iscons>:

int iscons(int fdnum)
{
  800680:	55                   	push   %ebp
  800681:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800683:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800688:	5d                   	pop    %ebp
  800689:	c3                   	ret    

0080068a <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80068a:	55                   	push   %ebp
  80068b:	89 e5                	mov    %esp,%ebp
  80068d:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800690:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800694:	7e 0a                	jle    8006a0 <libmain+0x16>
		binaryname = argv[0];
  800696:	8b 45 0c             	mov    0xc(%ebp),%eax
  800699:	8b 00                	mov    (%eax),%eax
  80069b:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8006a0:	83 ec 08             	sub    $0x8,%esp
  8006a3:	ff 75 0c             	pushl  0xc(%ebp)
  8006a6:	ff 75 08             	pushl  0x8(%ebp)
  8006a9:	e8 8a f9 ff ff       	call   800038 <_main>
  8006ae:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8006b1:	e8 67 1c 00 00       	call   80231d <sys_getenvid>
  8006b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  8006b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006bc:	89 d0                	mov    %edx,%eax
  8006be:	c1 e0 03             	shl    $0x3,%eax
  8006c1:	01 d0                	add    %edx,%eax
  8006c3:	01 c0                	add    %eax,%eax
  8006c5:	01 d0                	add    %edx,%eax
  8006c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ce:	01 d0                	add    %edx,%eax
  8006d0:	c1 e0 03             	shl    $0x3,%eax
  8006d3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006d8:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  8006db:	e8 8b 1d 00 00       	call   80246b <sys_disable_interrupt>
		cprintf("**************************************\n");
  8006e0:	83 ec 0c             	sub    $0xc,%esp
  8006e3:	68 24 2c 80 00       	push   $0x802c24
  8006e8:	e8 89 01 00 00       	call   800876 <cprintf>
  8006ed:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  8006f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006f3:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  8006f9:	83 ec 08             	sub    $0x8,%esp
  8006fc:	50                   	push   %eax
  8006fd:	68 4c 2c 80 00       	push   $0x802c4c
  800702:	e8 6f 01 00 00       	call   800876 <cprintf>
  800707:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80070a:	83 ec 0c             	sub    $0xc,%esp
  80070d:	68 24 2c 80 00       	push   $0x802c24
  800712:	e8 5f 01 00 00       	call   800876 <cprintf>
  800717:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80071a:	e8 66 1d 00 00       	call   802485 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80071f:	e8 19 00 00 00       	call   80073d <exit>
}
  800724:	90                   	nop
  800725:	c9                   	leave  
  800726:	c3                   	ret    

00800727 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800727:	55                   	push   %ebp
  800728:	89 e5                	mov    %esp,%ebp
  80072a:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80072d:	83 ec 0c             	sub    $0xc,%esp
  800730:	6a 00                	push   $0x0
  800732:	e8 cb 1b 00 00       	call   802302 <sys_env_destroy>
  800737:	83 c4 10             	add    $0x10,%esp
}
  80073a:	90                   	nop
  80073b:	c9                   	leave  
  80073c:	c3                   	ret    

0080073d <exit>:

void
exit(void)
{
  80073d:	55                   	push   %ebp
  80073e:	89 e5                	mov    %esp,%ebp
  800740:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800743:	e8 ee 1b 00 00       	call   802336 <sys_env_exit>
}
  800748:	90                   	nop
  800749:	c9                   	leave  
  80074a:	c3                   	ret    

0080074b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80074b:	55                   	push   %ebp
  80074c:	89 e5                	mov    %esp,%ebp
  80074e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800751:	8d 45 10             	lea    0x10(%ebp),%eax
  800754:	83 c0 04             	add    $0x4,%eax
  800757:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  80075a:	a1 70 40 98 00       	mov    0x984070,%eax
  80075f:	85 c0                	test   %eax,%eax
  800761:	74 16                	je     800779 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800763:	a1 70 40 98 00       	mov    0x984070,%eax
  800768:	83 ec 08             	sub    $0x8,%esp
  80076b:	50                   	push   %eax
  80076c:	68 65 2c 80 00       	push   $0x802c65
  800771:	e8 00 01 00 00       	call   800876 <cprintf>
  800776:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800779:	a1 00 40 80 00       	mov    0x804000,%eax
  80077e:	ff 75 0c             	pushl  0xc(%ebp)
  800781:	ff 75 08             	pushl  0x8(%ebp)
  800784:	50                   	push   %eax
  800785:	68 6a 2c 80 00       	push   $0x802c6a
  80078a:	e8 e7 00 00 00       	call   800876 <cprintf>
  80078f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800792:	8b 45 10             	mov    0x10(%ebp),%eax
  800795:	83 ec 08             	sub    $0x8,%esp
  800798:	ff 75 f4             	pushl  -0xc(%ebp)
  80079b:	50                   	push   %eax
  80079c:	e8 7a 00 00 00       	call   80081b <vcprintf>
  8007a1:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  8007a4:	83 ec 0c             	sub    $0xc,%esp
  8007a7:	68 86 2c 80 00       	push   $0x802c86
  8007ac:	e8 c5 00 00 00       	call   800876 <cprintf>
  8007b1:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007b4:	e8 84 ff ff ff       	call   80073d <exit>

	// should not return here
	while (1) ;
  8007b9:	eb fe                	jmp    8007b9 <_panic+0x6e>

008007bb <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8007bb:	55                   	push   %ebp
  8007bc:	89 e5                	mov    %esp,%ebp
  8007be:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8007c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c4:	8b 00                	mov    (%eax),%eax
  8007c6:	8d 48 01             	lea    0x1(%eax),%ecx
  8007c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007cc:	89 0a                	mov    %ecx,(%edx)
  8007ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8007d1:	88 d1                	mov    %dl,%cl
  8007d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007d6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8007da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007e4:	75 23                	jne    800809 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  8007e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e9:	8b 00                	mov    (%eax),%eax
  8007eb:	89 c2                	mov    %eax,%edx
  8007ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007f0:	83 c0 08             	add    $0x8,%eax
  8007f3:	83 ec 08             	sub    $0x8,%esp
  8007f6:	52                   	push   %edx
  8007f7:	50                   	push   %eax
  8007f8:	e8 cf 1a 00 00       	call   8022cc <sys_cputs>
  8007fd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800800:	8b 45 0c             	mov    0xc(%ebp),%eax
  800803:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800809:	8b 45 0c             	mov    0xc(%ebp),%eax
  80080c:	8b 40 04             	mov    0x4(%eax),%eax
  80080f:	8d 50 01             	lea    0x1(%eax),%edx
  800812:	8b 45 0c             	mov    0xc(%ebp),%eax
  800815:	89 50 04             	mov    %edx,0x4(%eax)
}
  800818:	90                   	nop
  800819:	c9                   	leave  
  80081a:	c3                   	ret    

0080081b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80081b:	55                   	push   %ebp
  80081c:	89 e5                	mov    %esp,%ebp
  80081e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800824:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80082b:	00 00 00 
	b.cnt = 0;
  80082e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800835:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800838:	ff 75 0c             	pushl  0xc(%ebp)
  80083b:	ff 75 08             	pushl  0x8(%ebp)
  80083e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800844:	50                   	push   %eax
  800845:	68 bb 07 80 00       	push   $0x8007bb
  80084a:	e8 fa 01 00 00       	call   800a49 <vprintfmt>
  80084f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  800852:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800858:	83 ec 08             	sub    $0x8,%esp
  80085b:	50                   	push   %eax
  80085c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800862:	83 c0 08             	add    $0x8,%eax
  800865:	50                   	push   %eax
  800866:	e8 61 1a 00 00       	call   8022cc <sys_cputs>
  80086b:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  80086e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800874:	c9                   	leave  
  800875:	c3                   	ret    

00800876 <cprintf>:

int cprintf(const char *fmt, ...) {
  800876:	55                   	push   %ebp
  800877:	89 e5                	mov    %esp,%ebp
  800879:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80087c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80087f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800882:	8b 45 08             	mov    0x8(%ebp),%eax
  800885:	83 ec 08             	sub    $0x8,%esp
  800888:	ff 75 f4             	pushl  -0xc(%ebp)
  80088b:	50                   	push   %eax
  80088c:	e8 8a ff ff ff       	call   80081b <vcprintf>
  800891:	83 c4 10             	add    $0x10,%esp
  800894:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800897:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80089a:	c9                   	leave  
  80089b:	c3                   	ret    

0080089c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80089c:	55                   	push   %ebp
  80089d:	89 e5                	mov    %esp,%ebp
  80089f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8008a2:	e8 c4 1b 00 00       	call   80246b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8008a7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8008aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8008ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b0:	83 ec 08             	sub    $0x8,%esp
  8008b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8008b6:	50                   	push   %eax
  8008b7:	e8 5f ff ff ff       	call   80081b <vcprintf>
  8008bc:	83 c4 10             	add    $0x10,%esp
  8008bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8008c2:	e8 be 1b 00 00       	call   802485 <sys_enable_interrupt>
	return cnt;
  8008c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008ca:	c9                   	leave  
  8008cb:	c3                   	ret    

008008cc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008cc:	55                   	push   %ebp
  8008cd:	89 e5                	mov    %esp,%ebp
  8008cf:	53                   	push   %ebx
  8008d0:	83 ec 14             	sub    $0x14,%esp
  8008d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008df:	8b 45 18             	mov    0x18(%ebp),%eax
  8008e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008ea:	77 55                	ja     800941 <printnum+0x75>
  8008ec:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008ef:	72 05                	jb     8008f6 <printnum+0x2a>
  8008f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8008f4:	77 4b                	ja     800941 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008f6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8008f9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008fc:	8b 45 18             	mov    0x18(%ebp),%eax
  8008ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800904:	52                   	push   %edx
  800905:	50                   	push   %eax
  800906:	ff 75 f4             	pushl  -0xc(%ebp)
  800909:	ff 75 f0             	pushl  -0x10(%ebp)
  80090c:	e8 f7 1e 00 00       	call   802808 <__udivdi3>
  800911:	83 c4 10             	add    $0x10,%esp
  800914:	83 ec 04             	sub    $0x4,%esp
  800917:	ff 75 20             	pushl  0x20(%ebp)
  80091a:	53                   	push   %ebx
  80091b:	ff 75 18             	pushl  0x18(%ebp)
  80091e:	52                   	push   %edx
  80091f:	50                   	push   %eax
  800920:	ff 75 0c             	pushl  0xc(%ebp)
  800923:	ff 75 08             	pushl  0x8(%ebp)
  800926:	e8 a1 ff ff ff       	call   8008cc <printnum>
  80092b:	83 c4 20             	add    $0x20,%esp
  80092e:	eb 1a                	jmp    80094a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800930:	83 ec 08             	sub    $0x8,%esp
  800933:	ff 75 0c             	pushl  0xc(%ebp)
  800936:	ff 75 20             	pushl  0x20(%ebp)
  800939:	8b 45 08             	mov    0x8(%ebp),%eax
  80093c:	ff d0                	call   *%eax
  80093e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800941:	ff 4d 1c             	decl   0x1c(%ebp)
  800944:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800948:	7f e6                	jg     800930 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80094a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80094d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800952:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800955:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800958:	53                   	push   %ebx
  800959:	51                   	push   %ecx
  80095a:	52                   	push   %edx
  80095b:	50                   	push   %eax
  80095c:	e8 b7 1f 00 00       	call   802918 <__umoddi3>
  800961:	83 c4 10             	add    $0x10,%esp
  800964:	05 b4 2e 80 00       	add    $0x802eb4,%eax
  800969:	8a 00                	mov    (%eax),%al
  80096b:	0f be c0             	movsbl %al,%eax
  80096e:	83 ec 08             	sub    $0x8,%esp
  800971:	ff 75 0c             	pushl  0xc(%ebp)
  800974:	50                   	push   %eax
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	ff d0                	call   *%eax
  80097a:	83 c4 10             	add    $0x10,%esp
}
  80097d:	90                   	nop
  80097e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800981:	c9                   	leave  
  800982:	c3                   	ret    

00800983 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800983:	55                   	push   %ebp
  800984:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800986:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80098a:	7e 1c                	jle    8009a8 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80098c:	8b 45 08             	mov    0x8(%ebp),%eax
  80098f:	8b 00                	mov    (%eax),%eax
  800991:	8d 50 08             	lea    0x8(%eax),%edx
  800994:	8b 45 08             	mov    0x8(%ebp),%eax
  800997:	89 10                	mov    %edx,(%eax)
  800999:	8b 45 08             	mov    0x8(%ebp),%eax
  80099c:	8b 00                	mov    (%eax),%eax
  80099e:	83 e8 08             	sub    $0x8,%eax
  8009a1:	8b 50 04             	mov    0x4(%eax),%edx
  8009a4:	8b 00                	mov    (%eax),%eax
  8009a6:	eb 40                	jmp    8009e8 <getuint+0x65>
	else if (lflag)
  8009a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009ac:	74 1e                	je     8009cc <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8009ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b1:	8b 00                	mov    (%eax),%eax
  8009b3:	8d 50 04             	lea    0x4(%eax),%edx
  8009b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b9:	89 10                	mov    %edx,(%eax)
  8009bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009be:	8b 00                	mov    (%eax),%eax
  8009c0:	83 e8 04             	sub    $0x4,%eax
  8009c3:	8b 00                	mov    (%eax),%eax
  8009c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ca:	eb 1c                	jmp    8009e8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	8b 00                	mov    (%eax),%eax
  8009d1:	8d 50 04             	lea    0x4(%eax),%edx
  8009d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d7:	89 10                	mov    %edx,(%eax)
  8009d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dc:	8b 00                	mov    (%eax),%eax
  8009de:	83 e8 04             	sub    $0x4,%eax
  8009e1:	8b 00                	mov    (%eax),%eax
  8009e3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8009e8:	5d                   	pop    %ebp
  8009e9:	c3                   	ret    

008009ea <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009ed:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009f1:	7e 1c                	jle    800a0f <getint+0x25>
		return va_arg(*ap, long long);
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	8b 00                	mov    (%eax),%eax
  8009f8:	8d 50 08             	lea    0x8(%eax),%edx
  8009fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fe:	89 10                	mov    %edx,(%eax)
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	8b 00                	mov    (%eax),%eax
  800a05:	83 e8 08             	sub    $0x8,%eax
  800a08:	8b 50 04             	mov    0x4(%eax),%edx
  800a0b:	8b 00                	mov    (%eax),%eax
  800a0d:	eb 38                	jmp    800a47 <getint+0x5d>
	else if (lflag)
  800a0f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a13:	74 1a                	je     800a2f <getint+0x45>
		return va_arg(*ap, long);
  800a15:	8b 45 08             	mov    0x8(%ebp),%eax
  800a18:	8b 00                	mov    (%eax),%eax
  800a1a:	8d 50 04             	lea    0x4(%eax),%edx
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	89 10                	mov    %edx,(%eax)
  800a22:	8b 45 08             	mov    0x8(%ebp),%eax
  800a25:	8b 00                	mov    (%eax),%eax
  800a27:	83 e8 04             	sub    $0x4,%eax
  800a2a:	8b 00                	mov    (%eax),%eax
  800a2c:	99                   	cltd   
  800a2d:	eb 18                	jmp    800a47 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	8b 00                	mov    (%eax),%eax
  800a34:	8d 50 04             	lea    0x4(%eax),%edx
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	89 10                	mov    %edx,(%eax)
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	8b 00                	mov    (%eax),%eax
  800a41:	83 e8 04             	sub    $0x4,%eax
  800a44:	8b 00                	mov    (%eax),%eax
  800a46:	99                   	cltd   
}
  800a47:	5d                   	pop    %ebp
  800a48:	c3                   	ret    

00800a49 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a49:	55                   	push   %ebp
  800a4a:	89 e5                	mov    %esp,%ebp
  800a4c:	56                   	push   %esi
  800a4d:	53                   	push   %ebx
  800a4e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a51:	eb 17                	jmp    800a6a <vprintfmt+0x21>
			if (ch == '\0')
  800a53:	85 db                	test   %ebx,%ebx
  800a55:	0f 84 af 03 00 00    	je     800e0a <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800a5b:	83 ec 08             	sub    $0x8,%esp
  800a5e:	ff 75 0c             	pushl  0xc(%ebp)
  800a61:	53                   	push   %ebx
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	ff d0                	call   *%eax
  800a67:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a6d:	8d 50 01             	lea    0x1(%eax),%edx
  800a70:	89 55 10             	mov    %edx,0x10(%ebp)
  800a73:	8a 00                	mov    (%eax),%al
  800a75:	0f b6 d8             	movzbl %al,%ebx
  800a78:	83 fb 25             	cmp    $0x25,%ebx
  800a7b:	75 d6                	jne    800a53 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a7d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a81:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a88:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a8f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a96:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800aa0:	8d 50 01             	lea    0x1(%eax),%edx
  800aa3:	89 55 10             	mov    %edx,0x10(%ebp)
  800aa6:	8a 00                	mov    (%eax),%al
  800aa8:	0f b6 d8             	movzbl %al,%ebx
  800aab:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800aae:	83 f8 55             	cmp    $0x55,%eax
  800ab1:	0f 87 2b 03 00 00    	ja     800de2 <vprintfmt+0x399>
  800ab7:	8b 04 85 d8 2e 80 00 	mov    0x802ed8(,%eax,4),%eax
  800abe:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ac0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ac4:	eb d7                	jmp    800a9d <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ac6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800aca:	eb d1                	jmp    800a9d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800acc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ad3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ad6:	89 d0                	mov    %edx,%eax
  800ad8:	c1 e0 02             	shl    $0x2,%eax
  800adb:	01 d0                	add    %edx,%eax
  800add:	01 c0                	add    %eax,%eax
  800adf:	01 d8                	add    %ebx,%eax
  800ae1:	83 e8 30             	sub    $0x30,%eax
  800ae4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ae7:	8b 45 10             	mov    0x10(%ebp),%eax
  800aea:	8a 00                	mov    (%eax),%al
  800aec:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800aef:	83 fb 2f             	cmp    $0x2f,%ebx
  800af2:	7e 3e                	jle    800b32 <vprintfmt+0xe9>
  800af4:	83 fb 39             	cmp    $0x39,%ebx
  800af7:	7f 39                	jg     800b32 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800af9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800afc:	eb d5                	jmp    800ad3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800afe:	8b 45 14             	mov    0x14(%ebp),%eax
  800b01:	83 c0 04             	add    $0x4,%eax
  800b04:	89 45 14             	mov    %eax,0x14(%ebp)
  800b07:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0a:	83 e8 04             	sub    $0x4,%eax
  800b0d:	8b 00                	mov    (%eax),%eax
  800b0f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800b12:	eb 1f                	jmp    800b33 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800b14:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b18:	79 83                	jns    800a9d <vprintfmt+0x54>
				width = 0;
  800b1a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800b21:	e9 77 ff ff ff       	jmp    800a9d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800b26:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b2d:	e9 6b ff ff ff       	jmp    800a9d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b32:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b33:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b37:	0f 89 60 ff ff ff    	jns    800a9d <vprintfmt+0x54>
				width = precision, precision = -1;
  800b3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b43:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b4a:	e9 4e ff ff ff       	jmp    800a9d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b4f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b52:	e9 46 ff ff ff       	jmp    800a9d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b57:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5a:	83 c0 04             	add    $0x4,%eax
  800b5d:	89 45 14             	mov    %eax,0x14(%ebp)
  800b60:	8b 45 14             	mov    0x14(%ebp),%eax
  800b63:	83 e8 04             	sub    $0x4,%eax
  800b66:	8b 00                	mov    (%eax),%eax
  800b68:	83 ec 08             	sub    $0x8,%esp
  800b6b:	ff 75 0c             	pushl  0xc(%ebp)
  800b6e:	50                   	push   %eax
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	ff d0                	call   *%eax
  800b74:	83 c4 10             	add    $0x10,%esp
			break;
  800b77:	e9 89 02 00 00       	jmp    800e05 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7f:	83 c0 04             	add    $0x4,%eax
  800b82:	89 45 14             	mov    %eax,0x14(%ebp)
  800b85:	8b 45 14             	mov    0x14(%ebp),%eax
  800b88:	83 e8 04             	sub    $0x4,%eax
  800b8b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b8d:	85 db                	test   %ebx,%ebx
  800b8f:	79 02                	jns    800b93 <vprintfmt+0x14a>
				err = -err;
  800b91:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b93:	83 fb 64             	cmp    $0x64,%ebx
  800b96:	7f 0b                	jg     800ba3 <vprintfmt+0x15a>
  800b98:	8b 34 9d 20 2d 80 00 	mov    0x802d20(,%ebx,4),%esi
  800b9f:	85 f6                	test   %esi,%esi
  800ba1:	75 19                	jne    800bbc <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ba3:	53                   	push   %ebx
  800ba4:	68 c5 2e 80 00       	push   $0x802ec5
  800ba9:	ff 75 0c             	pushl  0xc(%ebp)
  800bac:	ff 75 08             	pushl  0x8(%ebp)
  800baf:	e8 5e 02 00 00       	call   800e12 <printfmt>
  800bb4:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800bb7:	e9 49 02 00 00       	jmp    800e05 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800bbc:	56                   	push   %esi
  800bbd:	68 ce 2e 80 00       	push   $0x802ece
  800bc2:	ff 75 0c             	pushl  0xc(%ebp)
  800bc5:	ff 75 08             	pushl  0x8(%ebp)
  800bc8:	e8 45 02 00 00       	call   800e12 <printfmt>
  800bcd:	83 c4 10             	add    $0x10,%esp
			break;
  800bd0:	e9 30 02 00 00       	jmp    800e05 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800bd5:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd8:	83 c0 04             	add    $0x4,%eax
  800bdb:	89 45 14             	mov    %eax,0x14(%ebp)
  800bde:	8b 45 14             	mov    0x14(%ebp),%eax
  800be1:	83 e8 04             	sub    $0x4,%eax
  800be4:	8b 30                	mov    (%eax),%esi
  800be6:	85 f6                	test   %esi,%esi
  800be8:	75 05                	jne    800bef <vprintfmt+0x1a6>
				p = "(null)";
  800bea:	be d1 2e 80 00       	mov    $0x802ed1,%esi
			if (width > 0 && padc != '-')
  800bef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bf3:	7e 6d                	jle    800c62 <vprintfmt+0x219>
  800bf5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800bf9:	74 67                	je     800c62 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bfb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bfe:	83 ec 08             	sub    $0x8,%esp
  800c01:	50                   	push   %eax
  800c02:	56                   	push   %esi
  800c03:	e8 12 05 00 00       	call   80111a <strnlen>
  800c08:	83 c4 10             	add    $0x10,%esp
  800c0b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800c0e:	eb 16                	jmp    800c26 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800c10:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800c14:	83 ec 08             	sub    $0x8,%esp
  800c17:	ff 75 0c             	pushl  0xc(%ebp)
  800c1a:	50                   	push   %eax
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	ff d0                	call   *%eax
  800c20:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c23:	ff 4d e4             	decl   -0x1c(%ebp)
  800c26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c2a:	7f e4                	jg     800c10 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c2c:	eb 34                	jmp    800c62 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c2e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c32:	74 1c                	je     800c50 <vprintfmt+0x207>
  800c34:	83 fb 1f             	cmp    $0x1f,%ebx
  800c37:	7e 05                	jle    800c3e <vprintfmt+0x1f5>
  800c39:	83 fb 7e             	cmp    $0x7e,%ebx
  800c3c:	7e 12                	jle    800c50 <vprintfmt+0x207>
					putch('?', putdat);
  800c3e:	83 ec 08             	sub    $0x8,%esp
  800c41:	ff 75 0c             	pushl  0xc(%ebp)
  800c44:	6a 3f                	push   $0x3f
  800c46:	8b 45 08             	mov    0x8(%ebp),%eax
  800c49:	ff d0                	call   *%eax
  800c4b:	83 c4 10             	add    $0x10,%esp
  800c4e:	eb 0f                	jmp    800c5f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c50:	83 ec 08             	sub    $0x8,%esp
  800c53:	ff 75 0c             	pushl  0xc(%ebp)
  800c56:	53                   	push   %ebx
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	ff d0                	call   *%eax
  800c5c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c5f:	ff 4d e4             	decl   -0x1c(%ebp)
  800c62:	89 f0                	mov    %esi,%eax
  800c64:	8d 70 01             	lea    0x1(%eax),%esi
  800c67:	8a 00                	mov    (%eax),%al
  800c69:	0f be d8             	movsbl %al,%ebx
  800c6c:	85 db                	test   %ebx,%ebx
  800c6e:	74 24                	je     800c94 <vprintfmt+0x24b>
  800c70:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c74:	78 b8                	js     800c2e <vprintfmt+0x1e5>
  800c76:	ff 4d e0             	decl   -0x20(%ebp)
  800c79:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c7d:	79 af                	jns    800c2e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c7f:	eb 13                	jmp    800c94 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c81:	83 ec 08             	sub    $0x8,%esp
  800c84:	ff 75 0c             	pushl  0xc(%ebp)
  800c87:	6a 20                	push   $0x20
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	ff d0                	call   *%eax
  800c8e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c91:	ff 4d e4             	decl   -0x1c(%ebp)
  800c94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c98:	7f e7                	jg     800c81 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c9a:	e9 66 01 00 00       	jmp    800e05 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c9f:	83 ec 08             	sub    $0x8,%esp
  800ca2:	ff 75 e8             	pushl  -0x18(%ebp)
  800ca5:	8d 45 14             	lea    0x14(%ebp),%eax
  800ca8:	50                   	push   %eax
  800ca9:	e8 3c fd ff ff       	call   8009ea <getint>
  800cae:	83 c4 10             	add    $0x10,%esp
  800cb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800cb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cbd:	85 d2                	test   %edx,%edx
  800cbf:	79 23                	jns    800ce4 <vprintfmt+0x29b>
				putch('-', putdat);
  800cc1:	83 ec 08             	sub    $0x8,%esp
  800cc4:	ff 75 0c             	pushl  0xc(%ebp)
  800cc7:	6a 2d                	push   $0x2d
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	ff d0                	call   *%eax
  800cce:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800cd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cd7:	f7 d8                	neg    %eax
  800cd9:	83 d2 00             	adc    $0x0,%edx
  800cdc:	f7 da                	neg    %edx
  800cde:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ce4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ceb:	e9 bc 00 00 00       	jmp    800dac <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800cf0:	83 ec 08             	sub    $0x8,%esp
  800cf3:	ff 75 e8             	pushl  -0x18(%ebp)
  800cf6:	8d 45 14             	lea    0x14(%ebp),%eax
  800cf9:	50                   	push   %eax
  800cfa:	e8 84 fc ff ff       	call   800983 <getuint>
  800cff:	83 c4 10             	add    $0x10,%esp
  800d02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d05:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800d08:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d0f:	e9 98 00 00 00       	jmp    800dac <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
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
			putch('X', putdat);
  800d34:	83 ec 08             	sub    $0x8,%esp
  800d37:	ff 75 0c             	pushl  0xc(%ebp)
  800d3a:	6a 58                	push   $0x58
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	ff d0                	call   *%eax
  800d41:	83 c4 10             	add    $0x10,%esp
			break;
  800d44:	e9 bc 00 00 00       	jmp    800e05 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800d49:	83 ec 08             	sub    $0x8,%esp
  800d4c:	ff 75 0c             	pushl  0xc(%ebp)
  800d4f:	6a 30                	push   $0x30
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	ff d0                	call   *%eax
  800d56:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d59:	83 ec 08             	sub    $0x8,%esp
  800d5c:	ff 75 0c             	pushl  0xc(%ebp)
  800d5f:	6a 78                	push   $0x78
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	ff d0                	call   *%eax
  800d66:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d69:	8b 45 14             	mov    0x14(%ebp),%eax
  800d6c:	83 c0 04             	add    $0x4,%eax
  800d6f:	89 45 14             	mov    %eax,0x14(%ebp)
  800d72:	8b 45 14             	mov    0x14(%ebp),%eax
  800d75:	83 e8 04             	sub    $0x4,%eax
  800d78:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d84:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d8b:	eb 1f                	jmp    800dac <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d8d:	83 ec 08             	sub    $0x8,%esp
  800d90:	ff 75 e8             	pushl  -0x18(%ebp)
  800d93:	8d 45 14             	lea    0x14(%ebp),%eax
  800d96:	50                   	push   %eax
  800d97:	e8 e7 fb ff ff       	call   800983 <getuint>
  800d9c:	83 c4 10             	add    $0x10,%esp
  800d9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800da2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800da5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800dac:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800db0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800db3:	83 ec 04             	sub    $0x4,%esp
  800db6:	52                   	push   %edx
  800db7:	ff 75 e4             	pushl  -0x1c(%ebp)
  800dba:	50                   	push   %eax
  800dbb:	ff 75 f4             	pushl  -0xc(%ebp)
  800dbe:	ff 75 f0             	pushl  -0x10(%ebp)
  800dc1:	ff 75 0c             	pushl  0xc(%ebp)
  800dc4:	ff 75 08             	pushl  0x8(%ebp)
  800dc7:	e8 00 fb ff ff       	call   8008cc <printnum>
  800dcc:	83 c4 20             	add    $0x20,%esp
			break;
  800dcf:	eb 34                	jmp    800e05 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800dd1:	83 ec 08             	sub    $0x8,%esp
  800dd4:	ff 75 0c             	pushl  0xc(%ebp)
  800dd7:	53                   	push   %ebx
  800dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddb:	ff d0                	call   *%eax
  800ddd:	83 c4 10             	add    $0x10,%esp
			break;
  800de0:	eb 23                	jmp    800e05 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800de2:	83 ec 08             	sub    $0x8,%esp
  800de5:	ff 75 0c             	pushl  0xc(%ebp)
  800de8:	6a 25                	push   $0x25
  800dea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ded:	ff d0                	call   *%eax
  800def:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800df2:	ff 4d 10             	decl   0x10(%ebp)
  800df5:	eb 03                	jmp    800dfa <vprintfmt+0x3b1>
  800df7:	ff 4d 10             	decl   0x10(%ebp)
  800dfa:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfd:	48                   	dec    %eax
  800dfe:	8a 00                	mov    (%eax),%al
  800e00:	3c 25                	cmp    $0x25,%al
  800e02:	75 f3                	jne    800df7 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800e04:	90                   	nop
		}
	}
  800e05:	e9 47 fc ff ff       	jmp    800a51 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800e0a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800e0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e0e:	5b                   	pop    %ebx
  800e0f:	5e                   	pop    %esi
  800e10:	5d                   	pop    %ebp
  800e11:	c3                   	ret    

00800e12 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
  800e15:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800e18:	8d 45 10             	lea    0x10(%ebp),%eax
  800e1b:	83 c0 04             	add    $0x4,%eax
  800e1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e21:	8b 45 10             	mov    0x10(%ebp),%eax
  800e24:	ff 75 f4             	pushl  -0xc(%ebp)
  800e27:	50                   	push   %eax
  800e28:	ff 75 0c             	pushl  0xc(%ebp)
  800e2b:	ff 75 08             	pushl  0x8(%ebp)
  800e2e:	e8 16 fc ff ff       	call   800a49 <vprintfmt>
  800e33:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e36:	90                   	nop
  800e37:	c9                   	leave  
  800e38:	c3                   	ret    

00800e39 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3f:	8b 40 08             	mov    0x8(%eax),%eax
  800e42:	8d 50 01             	lea    0x1(%eax),%edx
  800e45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e48:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4e:	8b 10                	mov    (%eax),%edx
  800e50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e53:	8b 40 04             	mov    0x4(%eax),%eax
  800e56:	39 c2                	cmp    %eax,%edx
  800e58:	73 12                	jae    800e6c <sprintputch+0x33>
		*b->buf++ = ch;
  800e5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5d:	8b 00                	mov    (%eax),%eax
  800e5f:	8d 48 01             	lea    0x1(%eax),%ecx
  800e62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e65:	89 0a                	mov    %ecx,(%edx)
  800e67:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6a:	88 10                	mov    %dl,(%eax)
}
  800e6c:	90                   	nop
  800e6d:	5d                   	pop    %ebp
  800e6e:	c3                   	ret    

00800e6f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e6f:	55                   	push   %ebp
  800e70:	89 e5                	mov    %esp,%ebp
  800e72:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	01 d0                	add    %edx,%eax
  800e86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e94:	74 06                	je     800e9c <vsnprintf+0x2d>
  800e96:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e9a:	7f 07                	jg     800ea3 <vsnprintf+0x34>
		return -E_INVAL;
  800e9c:	b8 03 00 00 00       	mov    $0x3,%eax
  800ea1:	eb 20                	jmp    800ec3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ea3:	ff 75 14             	pushl  0x14(%ebp)
  800ea6:	ff 75 10             	pushl  0x10(%ebp)
  800ea9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800eac:	50                   	push   %eax
  800ead:	68 39 0e 80 00       	push   $0x800e39
  800eb2:	e8 92 fb ff ff       	call   800a49 <vprintfmt>
  800eb7:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800eba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ebd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ec3:	c9                   	leave  
  800ec4:	c3                   	ret    

00800ec5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ec5:	55                   	push   %ebp
  800ec6:	89 e5                	mov    %esp,%ebp
  800ec8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ecb:	8d 45 10             	lea    0x10(%ebp),%eax
  800ece:	83 c0 04             	add    $0x4,%eax
  800ed1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ed4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed7:	ff 75 f4             	pushl  -0xc(%ebp)
  800eda:	50                   	push   %eax
  800edb:	ff 75 0c             	pushl  0xc(%ebp)
  800ede:	ff 75 08             	pushl  0x8(%ebp)
  800ee1:	e8 89 ff ff ff       	call   800e6f <vsnprintf>
  800ee6:	83 c4 10             	add    $0x10,%esp
  800ee9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800eec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800eef:	c9                   	leave  
  800ef0:	c3                   	ret    

00800ef1 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  800ef7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800efb:	74 13                	je     800f10 <readline+0x1f>
		cprintf("%s", prompt);
  800efd:	83 ec 08             	sub    $0x8,%esp
  800f00:	ff 75 08             	pushl  0x8(%ebp)
  800f03:	68 30 30 80 00       	push   $0x803030
  800f08:	e8 69 f9 ff ff       	call   800876 <cprintf>
  800f0d:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800f10:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800f17:	83 ec 0c             	sub    $0xc,%esp
  800f1a:	6a 00                	push   $0x0
  800f1c:	e8 5f f7 ff ff       	call   800680 <iscons>
  800f21:	83 c4 10             	add    $0x10,%esp
  800f24:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800f27:	e8 06 f7 ff ff       	call   800632 <getchar>
  800f2c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800f2f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800f33:	79 22                	jns    800f57 <readline+0x66>
			if (c != -E_EOF)
  800f35:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800f39:	0f 84 ad 00 00 00    	je     800fec <readline+0xfb>
				cprintf("read error: %e\n", c);
  800f3f:	83 ec 08             	sub    $0x8,%esp
  800f42:	ff 75 ec             	pushl  -0x14(%ebp)
  800f45:	68 33 30 80 00       	push   $0x803033
  800f4a:	e8 27 f9 ff ff       	call   800876 <cprintf>
  800f4f:	83 c4 10             	add    $0x10,%esp
			return;
  800f52:	e9 95 00 00 00       	jmp    800fec <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800f57:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800f5b:	7e 34                	jle    800f91 <readline+0xa0>
  800f5d:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800f64:	7f 2b                	jg     800f91 <readline+0xa0>
			if (echoing)
  800f66:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f6a:	74 0e                	je     800f7a <readline+0x89>
				cputchar(c);
  800f6c:	83 ec 0c             	sub    $0xc,%esp
  800f6f:	ff 75 ec             	pushl  -0x14(%ebp)
  800f72:	e8 73 f6 ff ff       	call   8005ea <cputchar>
  800f77:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f7d:	8d 50 01             	lea    0x1(%eax),%edx
  800f80:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800f83:	89 c2                	mov    %eax,%edx
  800f85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f88:	01 d0                	add    %edx,%eax
  800f8a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f8d:	88 10                	mov    %dl,(%eax)
  800f8f:	eb 56                	jmp    800fe7 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800f91:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800f95:	75 1f                	jne    800fb6 <readline+0xc5>
  800f97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800f9b:	7e 19                	jle    800fb6 <readline+0xc5>
			if (echoing)
  800f9d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fa1:	74 0e                	je     800fb1 <readline+0xc0>
				cputchar(c);
  800fa3:	83 ec 0c             	sub    $0xc,%esp
  800fa6:	ff 75 ec             	pushl  -0x14(%ebp)
  800fa9:	e8 3c f6 ff ff       	call   8005ea <cputchar>
  800fae:	83 c4 10             	add    $0x10,%esp

			i--;
  800fb1:	ff 4d f4             	decl   -0xc(%ebp)
  800fb4:	eb 31                	jmp    800fe7 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800fb6:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800fba:	74 0a                	je     800fc6 <readline+0xd5>
  800fbc:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800fc0:	0f 85 61 ff ff ff    	jne    800f27 <readline+0x36>
			if (echoing)
  800fc6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fca:	74 0e                	je     800fda <readline+0xe9>
				cputchar(c);
  800fcc:	83 ec 0c             	sub    $0xc,%esp
  800fcf:	ff 75 ec             	pushl  -0x14(%ebp)
  800fd2:	e8 13 f6 ff ff       	call   8005ea <cputchar>
  800fd7:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800fda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe0:	01 d0                	add    %edx,%eax
  800fe2:	c6 00 00             	movb   $0x0,(%eax)
			return;
  800fe5:	eb 06                	jmp    800fed <readline+0xfc>
		}
	}
  800fe7:	e9 3b ff ff ff       	jmp    800f27 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  800fec:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  800fed:	c9                   	leave  
  800fee:	c3                   	ret    

00800fef <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800fef:	55                   	push   %ebp
  800ff0:	89 e5                	mov    %esp,%ebp
  800ff2:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800ff5:	e8 71 14 00 00       	call   80246b <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  800ffa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ffe:	74 13                	je     801013 <atomic_readline+0x24>
		cprintf("%s", prompt);
  801000:	83 ec 08             	sub    $0x8,%esp
  801003:	ff 75 08             	pushl  0x8(%ebp)
  801006:	68 30 30 80 00       	push   $0x803030
  80100b:	e8 66 f8 ff ff       	call   800876 <cprintf>
  801010:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801013:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  80101a:	83 ec 0c             	sub    $0xc,%esp
  80101d:	6a 00                	push   $0x0
  80101f:	e8 5c f6 ff ff       	call   800680 <iscons>
  801024:	83 c4 10             	add    $0x10,%esp
  801027:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80102a:	e8 03 f6 ff ff       	call   800632 <getchar>
  80102f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801032:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801036:	79 23                	jns    80105b <atomic_readline+0x6c>
			if (c != -E_EOF)
  801038:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80103c:	74 13                	je     801051 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  80103e:	83 ec 08             	sub    $0x8,%esp
  801041:	ff 75 ec             	pushl  -0x14(%ebp)
  801044:	68 33 30 80 00       	push   $0x803033
  801049:	e8 28 f8 ff ff       	call   800876 <cprintf>
  80104e:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801051:	e8 2f 14 00 00       	call   802485 <sys_enable_interrupt>
			return;
  801056:	e9 9a 00 00 00       	jmp    8010f5 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80105b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80105f:	7e 34                	jle    801095 <atomic_readline+0xa6>
  801061:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801068:	7f 2b                	jg     801095 <atomic_readline+0xa6>
			if (echoing)
  80106a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80106e:	74 0e                	je     80107e <atomic_readline+0x8f>
				cputchar(c);
  801070:	83 ec 0c             	sub    $0xc,%esp
  801073:	ff 75 ec             	pushl  -0x14(%ebp)
  801076:	e8 6f f5 ff ff       	call   8005ea <cputchar>
  80107b:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80107e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801081:	8d 50 01             	lea    0x1(%eax),%edx
  801084:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801087:	89 c2                	mov    %eax,%edx
  801089:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108c:	01 d0                	add    %edx,%eax
  80108e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801091:	88 10                	mov    %dl,(%eax)
  801093:	eb 5b                	jmp    8010f0 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  801095:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801099:	75 1f                	jne    8010ba <atomic_readline+0xcb>
  80109b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80109f:	7e 19                	jle    8010ba <atomic_readline+0xcb>
			if (echoing)
  8010a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8010a5:	74 0e                	je     8010b5 <atomic_readline+0xc6>
				cputchar(c);
  8010a7:	83 ec 0c             	sub    $0xc,%esp
  8010aa:	ff 75 ec             	pushl  -0x14(%ebp)
  8010ad:	e8 38 f5 ff ff       	call   8005ea <cputchar>
  8010b2:	83 c4 10             	add    $0x10,%esp
			i--;
  8010b5:	ff 4d f4             	decl   -0xc(%ebp)
  8010b8:	eb 36                	jmp    8010f0 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  8010ba:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8010be:	74 0a                	je     8010ca <atomic_readline+0xdb>
  8010c0:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8010c4:	0f 85 60 ff ff ff    	jne    80102a <atomic_readline+0x3b>
			if (echoing)
  8010ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8010ce:	74 0e                	je     8010de <atomic_readline+0xef>
				cputchar(c);
  8010d0:	83 ec 0c             	sub    $0xc,%esp
  8010d3:	ff 75 ec             	pushl  -0x14(%ebp)
  8010d6:	e8 0f f5 ff ff       	call   8005ea <cputchar>
  8010db:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8010de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e4:	01 d0                	add    %edx,%eax
  8010e6:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8010e9:	e8 97 13 00 00       	call   802485 <sys_enable_interrupt>
			return;
  8010ee:	eb 05                	jmp    8010f5 <atomic_readline+0x106>
		}
	}
  8010f0:	e9 35 ff ff ff       	jmp    80102a <atomic_readline+0x3b>
}
  8010f5:	c9                   	leave  
  8010f6:	c3                   	ret    

008010f7 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8010f7:	55                   	push   %ebp
  8010f8:	89 e5                	mov    %esp,%ebp
  8010fa:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8010fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801104:	eb 06                	jmp    80110c <strlen+0x15>
		n++;
  801106:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801109:	ff 45 08             	incl   0x8(%ebp)
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	8a 00                	mov    (%eax),%al
  801111:	84 c0                	test   %al,%al
  801113:	75 f1                	jne    801106 <strlen+0xf>
		n++;
	return n;
  801115:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801118:	c9                   	leave  
  801119:	c3                   	ret    

0080111a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80111a:	55                   	push   %ebp
  80111b:	89 e5                	mov    %esp,%ebp
  80111d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801120:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801127:	eb 09                	jmp    801132 <strnlen+0x18>
		n++;
  801129:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80112c:	ff 45 08             	incl   0x8(%ebp)
  80112f:	ff 4d 0c             	decl   0xc(%ebp)
  801132:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801136:	74 09                	je     801141 <strnlen+0x27>
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	8a 00                	mov    (%eax),%al
  80113d:	84 c0                	test   %al,%al
  80113f:	75 e8                	jne    801129 <strnlen+0xf>
		n++;
	return n;
  801141:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801144:	c9                   	leave  
  801145:	c3                   	ret    

00801146 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801146:	55                   	push   %ebp
  801147:	89 e5                	mov    %esp,%ebp
  801149:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801152:	90                   	nop
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	8d 50 01             	lea    0x1(%eax),%edx
  801159:	89 55 08             	mov    %edx,0x8(%ebp)
  80115c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80115f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801162:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801165:	8a 12                	mov    (%edx),%dl
  801167:	88 10                	mov    %dl,(%eax)
  801169:	8a 00                	mov    (%eax),%al
  80116b:	84 c0                	test   %al,%al
  80116d:	75 e4                	jne    801153 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80116f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801172:	c9                   	leave  
  801173:	c3                   	ret    

00801174 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801174:	55                   	push   %ebp
  801175:	89 e5                	mov    %esp,%ebp
  801177:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80117a:	8b 45 08             	mov    0x8(%ebp),%eax
  80117d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801180:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801187:	eb 1f                	jmp    8011a8 <strncpy+0x34>
		*dst++ = *src;
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	8d 50 01             	lea    0x1(%eax),%edx
  80118f:	89 55 08             	mov    %edx,0x8(%ebp)
  801192:	8b 55 0c             	mov    0xc(%ebp),%edx
  801195:	8a 12                	mov    (%edx),%dl
  801197:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801199:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119c:	8a 00                	mov    (%eax),%al
  80119e:	84 c0                	test   %al,%al
  8011a0:	74 03                	je     8011a5 <strncpy+0x31>
			src++;
  8011a2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011a5:	ff 45 fc             	incl   -0x4(%ebp)
  8011a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ab:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011ae:	72 d9                	jb     801189 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011b3:	c9                   	leave  
  8011b4:	c3                   	ret    

008011b5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8011b5:	55                   	push   %ebp
  8011b6:	89 e5                	mov    %esp,%ebp
  8011b8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8011c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c5:	74 30                	je     8011f7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8011c7:	eb 16                	jmp    8011df <strlcpy+0x2a>
			*dst++ = *src++;
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cc:	8d 50 01             	lea    0x1(%eax),%edx
  8011cf:	89 55 08             	mov    %edx,0x8(%ebp)
  8011d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011d5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011d8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011db:	8a 12                	mov    (%edx),%dl
  8011dd:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011df:	ff 4d 10             	decl   0x10(%ebp)
  8011e2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e6:	74 09                	je     8011f1 <strlcpy+0x3c>
  8011e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011eb:	8a 00                	mov    (%eax),%al
  8011ed:	84 c0                	test   %al,%al
  8011ef:	75 d8                	jne    8011c9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8011f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8011fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011fd:	29 c2                	sub    %eax,%edx
  8011ff:	89 d0                	mov    %edx,%eax
}
  801201:	c9                   	leave  
  801202:	c3                   	ret    

00801203 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801203:	55                   	push   %ebp
  801204:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801206:	eb 06                	jmp    80120e <strcmp+0xb>
		p++, q++;
  801208:	ff 45 08             	incl   0x8(%ebp)
  80120b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80120e:	8b 45 08             	mov    0x8(%ebp),%eax
  801211:	8a 00                	mov    (%eax),%al
  801213:	84 c0                	test   %al,%al
  801215:	74 0e                	je     801225 <strcmp+0x22>
  801217:	8b 45 08             	mov    0x8(%ebp),%eax
  80121a:	8a 10                	mov    (%eax),%dl
  80121c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121f:	8a 00                	mov    (%eax),%al
  801221:	38 c2                	cmp    %al,%dl
  801223:	74 e3                	je     801208 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	8a 00                	mov    (%eax),%al
  80122a:	0f b6 d0             	movzbl %al,%edx
  80122d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801230:	8a 00                	mov    (%eax),%al
  801232:	0f b6 c0             	movzbl %al,%eax
  801235:	29 c2                	sub    %eax,%edx
  801237:	89 d0                	mov    %edx,%eax
}
  801239:	5d                   	pop    %ebp
  80123a:	c3                   	ret    

0080123b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80123e:	eb 09                	jmp    801249 <strncmp+0xe>
		n--, p++, q++;
  801240:	ff 4d 10             	decl   0x10(%ebp)
  801243:	ff 45 08             	incl   0x8(%ebp)
  801246:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801249:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80124d:	74 17                	je     801266 <strncmp+0x2b>
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	8a 00                	mov    (%eax),%al
  801254:	84 c0                	test   %al,%al
  801256:	74 0e                	je     801266 <strncmp+0x2b>
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	8a 10                	mov    (%eax),%dl
  80125d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801260:	8a 00                	mov    (%eax),%al
  801262:	38 c2                	cmp    %al,%dl
  801264:	74 da                	je     801240 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801266:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80126a:	75 07                	jne    801273 <strncmp+0x38>
		return 0;
  80126c:	b8 00 00 00 00       	mov    $0x0,%eax
  801271:	eb 14                	jmp    801287 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801273:	8b 45 08             	mov    0x8(%ebp),%eax
  801276:	8a 00                	mov    (%eax),%al
  801278:	0f b6 d0             	movzbl %al,%edx
  80127b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127e:	8a 00                	mov    (%eax),%al
  801280:	0f b6 c0             	movzbl %al,%eax
  801283:	29 c2                	sub    %eax,%edx
  801285:	89 d0                	mov    %edx,%eax
}
  801287:	5d                   	pop    %ebp
  801288:	c3                   	ret    

00801289 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801289:	55                   	push   %ebp
  80128a:	89 e5                	mov    %esp,%ebp
  80128c:	83 ec 04             	sub    $0x4,%esp
  80128f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801292:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801295:	eb 12                	jmp    8012a9 <strchr+0x20>
		if (*s == c)
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	8a 00                	mov    (%eax),%al
  80129c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80129f:	75 05                	jne    8012a6 <strchr+0x1d>
			return (char *) s;
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	eb 11                	jmp    8012b7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012a6:	ff 45 08             	incl   0x8(%ebp)
  8012a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ac:	8a 00                	mov    (%eax),%al
  8012ae:	84 c0                	test   %al,%al
  8012b0:	75 e5                	jne    801297 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8012b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012b7:	c9                   	leave  
  8012b8:	c3                   	ret    

008012b9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012b9:	55                   	push   %ebp
  8012ba:	89 e5                	mov    %esp,%ebp
  8012bc:	83 ec 04             	sub    $0x4,%esp
  8012bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012c5:	eb 0d                	jmp    8012d4 <strfind+0x1b>
		if (*s == c)
  8012c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ca:	8a 00                	mov    (%eax),%al
  8012cc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012cf:	74 0e                	je     8012df <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012d1:	ff 45 08             	incl   0x8(%ebp)
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	8a 00                	mov    (%eax),%al
  8012d9:	84 c0                	test   %al,%al
  8012db:	75 ea                	jne    8012c7 <strfind+0xe>
  8012dd:	eb 01                	jmp    8012e0 <strfind+0x27>
		if (*s == c)
			break;
  8012df:	90                   	nop
	return (char *) s;
  8012e0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012e3:	c9                   	leave  
  8012e4:	c3                   	ret    

008012e5 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
  8012e8:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8012eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8012f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8012f7:	eb 0e                	jmp    801307 <memset+0x22>
		*p++ = c;
  8012f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012fc:	8d 50 01             	lea    0x1(%eax),%edx
  8012ff:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801302:	8b 55 0c             	mov    0xc(%ebp),%edx
  801305:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801307:	ff 4d f8             	decl   -0x8(%ebp)
  80130a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80130e:	79 e9                	jns    8012f9 <memset+0x14>
		*p++ = c;

	return v;
  801310:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801313:	c9                   	leave  
  801314:	c3                   	ret    

00801315 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801315:	55                   	push   %ebp
  801316:	89 e5                	mov    %esp,%ebp
  801318:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80131b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801321:	8b 45 08             	mov    0x8(%ebp),%eax
  801324:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801327:	eb 16                	jmp    80133f <memcpy+0x2a>
		*d++ = *s++;
  801329:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80132c:	8d 50 01             	lea    0x1(%eax),%edx
  80132f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801332:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801335:	8d 4a 01             	lea    0x1(%edx),%ecx
  801338:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80133b:	8a 12                	mov    (%edx),%dl
  80133d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80133f:	8b 45 10             	mov    0x10(%ebp),%eax
  801342:	8d 50 ff             	lea    -0x1(%eax),%edx
  801345:	89 55 10             	mov    %edx,0x10(%ebp)
  801348:	85 c0                	test   %eax,%eax
  80134a:	75 dd                	jne    801329 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80134c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80134f:	c9                   	leave  
  801350:	c3                   	ret    

00801351 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801351:	55                   	push   %ebp
  801352:	89 e5                	mov    %esp,%ebp
  801354:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  801357:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80135d:	8b 45 08             	mov    0x8(%ebp),%eax
  801360:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801363:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801366:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801369:	73 50                	jae    8013bb <memmove+0x6a>
  80136b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80136e:	8b 45 10             	mov    0x10(%ebp),%eax
  801371:	01 d0                	add    %edx,%eax
  801373:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801376:	76 43                	jbe    8013bb <memmove+0x6a>
		s += n;
  801378:	8b 45 10             	mov    0x10(%ebp),%eax
  80137b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80137e:	8b 45 10             	mov    0x10(%ebp),%eax
  801381:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801384:	eb 10                	jmp    801396 <memmove+0x45>
			*--d = *--s;
  801386:	ff 4d f8             	decl   -0x8(%ebp)
  801389:	ff 4d fc             	decl   -0x4(%ebp)
  80138c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80138f:	8a 10                	mov    (%eax),%dl
  801391:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801394:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801396:	8b 45 10             	mov    0x10(%ebp),%eax
  801399:	8d 50 ff             	lea    -0x1(%eax),%edx
  80139c:	89 55 10             	mov    %edx,0x10(%ebp)
  80139f:	85 c0                	test   %eax,%eax
  8013a1:	75 e3                	jne    801386 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8013a3:	eb 23                	jmp    8013c8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8013a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a8:	8d 50 01             	lea    0x1(%eax),%edx
  8013ab:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013b1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013b4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013b7:	8a 12                	mov    (%edx),%dl
  8013b9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8013bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013be:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013c1:	89 55 10             	mov    %edx,0x10(%ebp)
  8013c4:	85 c0                	test   %eax,%eax
  8013c6:	75 dd                	jne    8013a5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8013c8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013cb:	c9                   	leave  
  8013cc:	c3                   	ret    

008013cd <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013cd:	55                   	push   %ebp
  8013ce:	89 e5                	mov    %esp,%ebp
  8013d0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dc:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8013df:	eb 2a                	jmp    80140b <memcmp+0x3e>
		if (*s1 != *s2)
  8013e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013e4:	8a 10                	mov    (%eax),%dl
  8013e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e9:	8a 00                	mov    (%eax),%al
  8013eb:	38 c2                	cmp    %al,%dl
  8013ed:	74 16                	je     801405 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8013ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f2:	8a 00                	mov    (%eax),%al
  8013f4:	0f b6 d0             	movzbl %al,%edx
  8013f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013fa:	8a 00                	mov    (%eax),%al
  8013fc:	0f b6 c0             	movzbl %al,%eax
  8013ff:	29 c2                	sub    %eax,%edx
  801401:	89 d0                	mov    %edx,%eax
  801403:	eb 18                	jmp    80141d <memcmp+0x50>
		s1++, s2++;
  801405:	ff 45 fc             	incl   -0x4(%ebp)
  801408:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80140b:	8b 45 10             	mov    0x10(%ebp),%eax
  80140e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801411:	89 55 10             	mov    %edx,0x10(%ebp)
  801414:	85 c0                	test   %eax,%eax
  801416:	75 c9                	jne    8013e1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801418:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80141d:	c9                   	leave  
  80141e:	c3                   	ret    

0080141f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80141f:	55                   	push   %ebp
  801420:	89 e5                	mov    %esp,%ebp
  801422:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801425:	8b 55 08             	mov    0x8(%ebp),%edx
  801428:	8b 45 10             	mov    0x10(%ebp),%eax
  80142b:	01 d0                	add    %edx,%eax
  80142d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801430:	eb 15                	jmp    801447 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	8a 00                	mov    (%eax),%al
  801437:	0f b6 d0             	movzbl %al,%edx
  80143a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143d:	0f b6 c0             	movzbl %al,%eax
  801440:	39 c2                	cmp    %eax,%edx
  801442:	74 0d                	je     801451 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801444:	ff 45 08             	incl   0x8(%ebp)
  801447:	8b 45 08             	mov    0x8(%ebp),%eax
  80144a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80144d:	72 e3                	jb     801432 <memfind+0x13>
  80144f:	eb 01                	jmp    801452 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801451:	90                   	nop
	return (void *) s;
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801455:	c9                   	leave  
  801456:	c3                   	ret    

00801457 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
  80145a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80145d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801464:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80146b:	eb 03                	jmp    801470 <strtol+0x19>
		s++;
  80146d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801470:	8b 45 08             	mov    0x8(%ebp),%eax
  801473:	8a 00                	mov    (%eax),%al
  801475:	3c 20                	cmp    $0x20,%al
  801477:	74 f4                	je     80146d <strtol+0x16>
  801479:	8b 45 08             	mov    0x8(%ebp),%eax
  80147c:	8a 00                	mov    (%eax),%al
  80147e:	3c 09                	cmp    $0x9,%al
  801480:	74 eb                	je     80146d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	8a 00                	mov    (%eax),%al
  801487:	3c 2b                	cmp    $0x2b,%al
  801489:	75 05                	jne    801490 <strtol+0x39>
		s++;
  80148b:	ff 45 08             	incl   0x8(%ebp)
  80148e:	eb 13                	jmp    8014a3 <strtol+0x4c>
	else if (*s == '-')
  801490:	8b 45 08             	mov    0x8(%ebp),%eax
  801493:	8a 00                	mov    (%eax),%al
  801495:	3c 2d                	cmp    $0x2d,%al
  801497:	75 0a                	jne    8014a3 <strtol+0x4c>
		s++, neg = 1;
  801499:	ff 45 08             	incl   0x8(%ebp)
  80149c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014a7:	74 06                	je     8014af <strtol+0x58>
  8014a9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8014ad:	75 20                	jne    8014cf <strtol+0x78>
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	8a 00                	mov    (%eax),%al
  8014b4:	3c 30                	cmp    $0x30,%al
  8014b6:	75 17                	jne    8014cf <strtol+0x78>
  8014b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bb:	40                   	inc    %eax
  8014bc:	8a 00                	mov    (%eax),%al
  8014be:	3c 78                	cmp    $0x78,%al
  8014c0:	75 0d                	jne    8014cf <strtol+0x78>
		s += 2, base = 16;
  8014c2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014c6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014cd:	eb 28                	jmp    8014f7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014d3:	75 15                	jne    8014ea <strtol+0x93>
  8014d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d8:	8a 00                	mov    (%eax),%al
  8014da:	3c 30                	cmp    $0x30,%al
  8014dc:	75 0c                	jne    8014ea <strtol+0x93>
		s++, base = 8;
  8014de:	ff 45 08             	incl   0x8(%ebp)
  8014e1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8014e8:	eb 0d                	jmp    8014f7 <strtol+0xa0>
	else if (base == 0)
  8014ea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014ee:	75 07                	jne    8014f7 <strtol+0xa0>
		base = 10;
  8014f0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fa:	8a 00                	mov    (%eax),%al
  8014fc:	3c 2f                	cmp    $0x2f,%al
  8014fe:	7e 19                	jle    801519 <strtol+0xc2>
  801500:	8b 45 08             	mov    0x8(%ebp),%eax
  801503:	8a 00                	mov    (%eax),%al
  801505:	3c 39                	cmp    $0x39,%al
  801507:	7f 10                	jg     801519 <strtol+0xc2>
			dig = *s - '0';
  801509:	8b 45 08             	mov    0x8(%ebp),%eax
  80150c:	8a 00                	mov    (%eax),%al
  80150e:	0f be c0             	movsbl %al,%eax
  801511:	83 e8 30             	sub    $0x30,%eax
  801514:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801517:	eb 42                	jmp    80155b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801519:	8b 45 08             	mov    0x8(%ebp),%eax
  80151c:	8a 00                	mov    (%eax),%al
  80151e:	3c 60                	cmp    $0x60,%al
  801520:	7e 19                	jle    80153b <strtol+0xe4>
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
  801525:	8a 00                	mov    (%eax),%al
  801527:	3c 7a                	cmp    $0x7a,%al
  801529:	7f 10                	jg     80153b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80152b:	8b 45 08             	mov    0x8(%ebp),%eax
  80152e:	8a 00                	mov    (%eax),%al
  801530:	0f be c0             	movsbl %al,%eax
  801533:	83 e8 57             	sub    $0x57,%eax
  801536:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801539:	eb 20                	jmp    80155b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80153b:	8b 45 08             	mov    0x8(%ebp),%eax
  80153e:	8a 00                	mov    (%eax),%al
  801540:	3c 40                	cmp    $0x40,%al
  801542:	7e 39                	jle    80157d <strtol+0x126>
  801544:	8b 45 08             	mov    0x8(%ebp),%eax
  801547:	8a 00                	mov    (%eax),%al
  801549:	3c 5a                	cmp    $0x5a,%al
  80154b:	7f 30                	jg     80157d <strtol+0x126>
			dig = *s - 'A' + 10;
  80154d:	8b 45 08             	mov    0x8(%ebp),%eax
  801550:	8a 00                	mov    (%eax),%al
  801552:	0f be c0             	movsbl %al,%eax
  801555:	83 e8 37             	sub    $0x37,%eax
  801558:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80155b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801561:	7d 19                	jge    80157c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801563:	ff 45 08             	incl   0x8(%ebp)
  801566:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801569:	0f af 45 10          	imul   0x10(%ebp),%eax
  80156d:	89 c2                	mov    %eax,%edx
  80156f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801572:	01 d0                	add    %edx,%eax
  801574:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801577:	e9 7b ff ff ff       	jmp    8014f7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80157c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80157d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801581:	74 08                	je     80158b <strtol+0x134>
		*endptr = (char *) s;
  801583:	8b 45 0c             	mov    0xc(%ebp),%eax
  801586:	8b 55 08             	mov    0x8(%ebp),%edx
  801589:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80158b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80158f:	74 07                	je     801598 <strtol+0x141>
  801591:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801594:	f7 d8                	neg    %eax
  801596:	eb 03                	jmp    80159b <strtol+0x144>
  801598:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80159b:	c9                   	leave  
  80159c:	c3                   	ret    

0080159d <ltostr>:

void
ltostr(long value, char *str)
{
  80159d:	55                   	push   %ebp
  80159e:	89 e5                	mov    %esp,%ebp
  8015a0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8015a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8015aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8015b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015b5:	79 13                	jns    8015ca <ltostr+0x2d>
	{
		neg = 1;
  8015b7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8015be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8015c4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015c7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015d2:	99                   	cltd   
  8015d3:	f7 f9                	idiv   %ecx
  8015d5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015db:	8d 50 01             	lea    0x1(%eax),%edx
  8015de:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015e1:	89 c2                	mov    %eax,%edx
  8015e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e6:	01 d0                	add    %edx,%eax
  8015e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015eb:	83 c2 30             	add    $0x30,%edx
  8015ee:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8015f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015f3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015f8:	f7 e9                	imul   %ecx
  8015fa:	c1 fa 02             	sar    $0x2,%edx
  8015fd:	89 c8                	mov    %ecx,%eax
  8015ff:	c1 f8 1f             	sar    $0x1f,%eax
  801602:	29 c2                	sub    %eax,%edx
  801604:	89 d0                	mov    %edx,%eax
  801606:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801609:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80160c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801611:	f7 e9                	imul   %ecx
  801613:	c1 fa 02             	sar    $0x2,%edx
  801616:	89 c8                	mov    %ecx,%eax
  801618:	c1 f8 1f             	sar    $0x1f,%eax
  80161b:	29 c2                	sub    %eax,%edx
  80161d:	89 d0                	mov    %edx,%eax
  80161f:	c1 e0 02             	shl    $0x2,%eax
  801622:	01 d0                	add    %edx,%eax
  801624:	01 c0                	add    %eax,%eax
  801626:	29 c1                	sub    %eax,%ecx
  801628:	89 ca                	mov    %ecx,%edx
  80162a:	85 d2                	test   %edx,%edx
  80162c:	75 9c                	jne    8015ca <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80162e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801635:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801638:	48                   	dec    %eax
  801639:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80163c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801640:	74 3d                	je     80167f <ltostr+0xe2>
		start = 1 ;
  801642:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801649:	eb 34                	jmp    80167f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80164b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80164e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801651:	01 d0                	add    %edx,%eax
  801653:	8a 00                	mov    (%eax),%al
  801655:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801658:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80165b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165e:	01 c2                	add    %eax,%edx
  801660:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801663:	8b 45 0c             	mov    0xc(%ebp),%eax
  801666:	01 c8                	add    %ecx,%eax
  801668:	8a 00                	mov    (%eax),%al
  80166a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80166c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80166f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801672:	01 c2                	add    %eax,%edx
  801674:	8a 45 eb             	mov    -0x15(%ebp),%al
  801677:	88 02                	mov    %al,(%edx)
		start++ ;
  801679:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80167c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80167f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801682:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801685:	7c c4                	jl     80164b <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801687:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80168a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168d:	01 d0                	add    %edx,%eax
  80168f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801692:	90                   	nop
  801693:	c9                   	leave  
  801694:	c3                   	ret    

00801695 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
  801698:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80169b:	ff 75 08             	pushl  0x8(%ebp)
  80169e:	e8 54 fa ff ff       	call   8010f7 <strlen>
  8016a3:	83 c4 04             	add    $0x4,%esp
  8016a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8016a9:	ff 75 0c             	pushl  0xc(%ebp)
  8016ac:	e8 46 fa ff ff       	call   8010f7 <strlen>
  8016b1:	83 c4 04             	add    $0x4,%esp
  8016b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8016b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8016be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016c5:	eb 17                	jmp    8016de <strcconcat+0x49>
		final[s] = str1[s] ;
  8016c7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8016cd:	01 c2                	add    %eax,%edx
  8016cf:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	01 c8                	add    %ecx,%eax
  8016d7:	8a 00                	mov    (%eax),%al
  8016d9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016db:	ff 45 fc             	incl   -0x4(%ebp)
  8016de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016e4:	7c e1                	jl     8016c7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016e6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016ed:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016f4:	eb 1f                	jmp    801715 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016f9:	8d 50 01             	lea    0x1(%eax),%edx
  8016fc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016ff:	89 c2                	mov    %eax,%edx
  801701:	8b 45 10             	mov    0x10(%ebp),%eax
  801704:	01 c2                	add    %eax,%edx
  801706:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801709:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170c:	01 c8                	add    %ecx,%eax
  80170e:	8a 00                	mov    (%eax),%al
  801710:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801712:	ff 45 f8             	incl   -0x8(%ebp)
  801715:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801718:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80171b:	7c d9                	jl     8016f6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80171d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801720:	8b 45 10             	mov    0x10(%ebp),%eax
  801723:	01 d0                	add    %edx,%eax
  801725:	c6 00 00             	movb   $0x0,(%eax)
}
  801728:	90                   	nop
  801729:	c9                   	leave  
  80172a:	c3                   	ret    

0080172b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80172e:	8b 45 14             	mov    0x14(%ebp),%eax
  801731:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801737:	8b 45 14             	mov    0x14(%ebp),%eax
  80173a:	8b 00                	mov    (%eax),%eax
  80173c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801743:	8b 45 10             	mov    0x10(%ebp),%eax
  801746:	01 d0                	add    %edx,%eax
  801748:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80174e:	eb 0c                	jmp    80175c <strsplit+0x31>
			*string++ = 0;
  801750:	8b 45 08             	mov    0x8(%ebp),%eax
  801753:	8d 50 01             	lea    0x1(%eax),%edx
  801756:	89 55 08             	mov    %edx,0x8(%ebp)
  801759:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80175c:	8b 45 08             	mov    0x8(%ebp),%eax
  80175f:	8a 00                	mov    (%eax),%al
  801761:	84 c0                	test   %al,%al
  801763:	74 18                	je     80177d <strsplit+0x52>
  801765:	8b 45 08             	mov    0x8(%ebp),%eax
  801768:	8a 00                	mov    (%eax),%al
  80176a:	0f be c0             	movsbl %al,%eax
  80176d:	50                   	push   %eax
  80176e:	ff 75 0c             	pushl  0xc(%ebp)
  801771:	e8 13 fb ff ff       	call   801289 <strchr>
  801776:	83 c4 08             	add    $0x8,%esp
  801779:	85 c0                	test   %eax,%eax
  80177b:	75 d3                	jne    801750 <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  80177d:	8b 45 08             	mov    0x8(%ebp),%eax
  801780:	8a 00                	mov    (%eax),%al
  801782:	84 c0                	test   %al,%al
  801784:	74 5a                	je     8017e0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  801786:	8b 45 14             	mov    0x14(%ebp),%eax
  801789:	8b 00                	mov    (%eax),%eax
  80178b:	83 f8 0f             	cmp    $0xf,%eax
  80178e:	75 07                	jne    801797 <strsplit+0x6c>
		{
			return 0;
  801790:	b8 00 00 00 00       	mov    $0x0,%eax
  801795:	eb 66                	jmp    8017fd <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801797:	8b 45 14             	mov    0x14(%ebp),%eax
  80179a:	8b 00                	mov    (%eax),%eax
  80179c:	8d 48 01             	lea    0x1(%eax),%ecx
  80179f:	8b 55 14             	mov    0x14(%ebp),%edx
  8017a2:	89 0a                	mov    %ecx,(%edx)
  8017a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ae:	01 c2                	add    %eax,%edx
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017b5:	eb 03                	jmp    8017ba <strsplit+0x8f>
			string++;
  8017b7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	8a 00                	mov    (%eax),%al
  8017bf:	84 c0                	test   %al,%al
  8017c1:	74 8b                	je     80174e <strsplit+0x23>
  8017c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c6:	8a 00                	mov    (%eax),%al
  8017c8:	0f be c0             	movsbl %al,%eax
  8017cb:	50                   	push   %eax
  8017cc:	ff 75 0c             	pushl  0xc(%ebp)
  8017cf:	e8 b5 fa ff ff       	call   801289 <strchr>
  8017d4:	83 c4 08             	add    $0x8,%esp
  8017d7:	85 c0                	test   %eax,%eax
  8017d9:	74 dc                	je     8017b7 <strsplit+0x8c>
			string++;
	}
  8017db:	e9 6e ff ff ff       	jmp    80174e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017e0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8017e4:	8b 00                	mov    (%eax),%eax
  8017e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f0:	01 d0                	add    %edx,%eax
  8017f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017f8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017fd:	c9                   	leave  
  8017fe:	c3                   	ret    

008017ff <malloc>:
int cnt_mem = 0;
int heap_mem[size_uhmem] = { 0 };
struct hmem heap_size[size_uhmem] = { 0 };
int check = 0;

void* malloc(uint32 size) {
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
  801802:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyNEXTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	//NEXT FIT
	if (sys_isUHeapPlacementStrategyNEXTFIT()) {
  801808:	e8 7d 0f 00 00       	call   80278a <sys_isUHeapPlacementStrategyNEXTFIT>
  80180d:	85 c0                	test   %eax,%eax
  80180f:	0f 84 6f 03 00 00    	je     801b84 <malloc+0x385>
		size = ROUNDUP(size, PAGE_SIZE);
  801815:	c7 45 84 00 10 00 00 	movl   $0x1000,-0x7c(%ebp)
  80181c:	8b 55 08             	mov    0x8(%ebp),%edx
  80181f:	8b 45 84             	mov    -0x7c(%ebp),%eax
  801822:	01 d0                	add    %edx,%eax
  801824:	48                   	dec    %eax
  801825:	89 45 80             	mov    %eax,-0x80(%ebp)
  801828:	8b 45 80             	mov    -0x80(%ebp),%eax
  80182b:	ba 00 00 00 00       	mov    $0x0,%edx
  801830:	f7 75 84             	divl   -0x7c(%ebp)
  801833:	8b 45 80             	mov    -0x80(%ebp),%eax
  801836:	29 d0                	sub    %edx,%eax
  801838:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  80183b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80183f:	74 09                	je     80184a <malloc+0x4b>
  801841:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801848:	76 0a                	jbe    801854 <malloc+0x55>
			return NULL;
  80184a:	b8 00 00 00 00       	mov    $0x0,%eax
  80184f:	e9 4b 09 00 00       	jmp    80219f <malloc+0x9a0>
		}
		// first we can allocate by " Strategy Continues "
		if (ptr_uheap + size <= (uint32) USER_HEAP_MAX && !check) {
  801854:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80185a:	8b 45 08             	mov    0x8(%ebp),%eax
  80185d:	01 d0                	add    %edx,%eax
  80185f:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801864:	0f 87 a2 00 00 00    	ja     80190c <malloc+0x10d>
  80186a:	a1 60 40 98 00       	mov    0x984060,%eax
  80186f:	85 c0                	test   %eax,%eax
  801871:	0f 85 95 00 00 00    	jne    80190c <malloc+0x10d>

			void* ret = (void *) ptr_uheap;
  801877:	a1 04 40 80 00       	mov    0x804004,%eax
  80187c:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			sys_allocateMem(ptr_uheap, size);
  801882:	a1 04 40 80 00       	mov    0x804004,%eax
  801887:	83 ec 08             	sub    $0x8,%esp
  80188a:	ff 75 08             	pushl  0x8(%ebp)
  80188d:	50                   	push   %eax
  80188e:	e8 a3 0b 00 00       	call   802436 <sys_allocateMem>
  801893:	83 c4 10             	add    $0x10,%esp

			heap_size[cnt_mem].size = size;
  801896:	a1 40 40 80 00       	mov    0x804040,%eax
  80189b:	8b 55 08             	mov    0x8(%ebp),%edx
  80189e:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8018a5:	a1 40 40 80 00       	mov    0x804040,%eax
  8018aa:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8018b0:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
			cnt_mem++;
  8018b7:	a1 40 40 80 00       	mov    0x804040,%eax
  8018bc:	40                   	inc    %eax
  8018bd:	a3 40 40 80 00       	mov    %eax,0x804040
			int i = 0;
  8018c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  8018c9:	eb 2e                	jmp    8018f9 <malloc+0xfa>
			{

				heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8018cb:	a1 04 40 80 00       	mov    0x804004,%eax
  8018d0:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] = 1;
  8018d5:	c1 e8 0c             	shr    $0xc,%eax
  8018d8:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  8018df:	01 00 00 00 

				ptr_uheap += (uint32) PAGE_SIZE;
  8018e3:	a1 04 40 80 00       	mov    0x804004,%eax
  8018e8:	05 00 10 00 00       	add    $0x1000,%eax
  8018ed:	a3 04 40 80 00       	mov    %eax,0x804004
			heap_size[cnt_mem].size = size;
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
			cnt_mem++;
			int i = 0;
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  8018f2:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  8018f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018fc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8018ff:	72 ca                	jb     8018cb <malloc+0xcc>
						/ (uint32) PAGE_SIZE)] = 1;

				ptr_uheap += (uint32) PAGE_SIZE;
			}

			return ret;
  801901:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  801907:	e9 93 08 00 00       	jmp    80219f <malloc+0x9a0>

		} else {
			// second we can allocate by " Strategy NEXTFIT "
			void* temp_end = NULL;
  80190c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

			int check_start = 0;
  801913:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			// check first that we used " Strategy Continues " before and not do it again and turn to NEXTFIT
			if (!check) {
  80191a:	a1 60 40 98 00       	mov    0x984060,%eax
  80191f:	85 c0                	test   %eax,%eax
  801921:	75 1d                	jne    801940 <malloc+0x141>
				ptr_uheap = (uint32) USER_HEAP_START;
  801923:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  80192a:	00 00 80 
				check = 1;
  80192d:	c7 05 60 40 98 00 01 	movl   $0x1,0x984060
  801934:	00 00 00 
				check_start = 1;// to dont use second loop CZ ptr_uheap start from USER_HEAP_START
  801937:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  80193e:	eb 08                	jmp    801948 <malloc+0x149>
			} else {
				temp_end = (void*) ptr_uheap;
  801940:	a1 04 40 80 00       	mov    0x804004,%eax
  801945:	89 45 f0             	mov    %eax,-0x10(%ebp)

			}

			uint32 sz = 0;
  801948:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
			int f = 0;
  80194f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			uint32 ptr = ptr_uheap;
  801956:	a1 04 40 80 00       	mov    0x804004,%eax
  80195b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  80195e:	eb 4d                	jmp    8019ad <malloc+0x1ae>
				if (sz == size) {
  801960:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801963:	3b 45 08             	cmp    0x8(%ebp),%eax
  801966:	75 09                	jne    801971 <malloc+0x172>
					f = 1;
  801968:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  80196f:	eb 45                	jmp    8019b6 <malloc+0x1b7>
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801971:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801974:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] == 0) {
  801979:	c1 e8 0c             	shr    $0xc,%eax
			while (ptr < (uint32) USER_HEAP_MAX) {
				if (sz == size) {
					f = 1;
					break;
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  80197c:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  801983:	85 c0                	test   %eax,%eax
  801985:	75 10                	jne    801997 <malloc+0x198>
						/ (uint32) PAGE_SIZE)] == 0) {

					sz += PAGE_SIZE;
  801987:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
					ptr += PAGE_SIZE;
  80198e:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  801995:	eb 16                	jmp    8019ad <malloc+0x1ae>
				} else {
					sz = 0;
  801997:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
					ptr += PAGE_SIZE;
  80199e:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
					ptr_uheap = ptr;
  8019a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019a8:	a3 04 40 80 00       	mov    %eax,0x804004

			uint32 sz = 0;
			int f = 0;
			uint32 ptr = ptr_uheap;
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  8019ad:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  8019b4:	76 aa                	jbe    801960 <malloc+0x161>
					ptr_uheap = ptr;
				}

			}

			if (f) {
  8019b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8019ba:	0f 84 95 00 00 00    	je     801a55 <malloc+0x256>

				void* ret = (void *) ptr_uheap;
  8019c0:	a1 04 40 80 00       	mov    0x804004,%eax
  8019c5:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

				sys_allocateMem(ptr_uheap, size);
  8019cb:	a1 04 40 80 00       	mov    0x804004,%eax
  8019d0:	83 ec 08             	sub    $0x8,%esp
  8019d3:	ff 75 08             	pushl  0x8(%ebp)
  8019d6:	50                   	push   %eax
  8019d7:	e8 5a 0a 00 00       	call   802436 <sys_allocateMem>
  8019dc:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  8019df:	a1 40 40 80 00       	mov    0x804040,%eax
  8019e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8019e7:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8019ee:	a1 40 40 80 00       	mov    0x804040,%eax
  8019f3:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8019f9:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
				cnt_mem++;
  801a00:	a1 40 40 80 00       	mov    0x804040,%eax
  801a05:	40                   	inc    %eax
  801a06:	a3 40 40 80 00       	mov    %eax,0x804040
				int i = 0;
  801a0b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801a12:	eb 2e                	jmp    801a42 <malloc+0x243>
				{

					heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801a14:	a1 04 40 80 00       	mov    0x804004,%eax
  801a19:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  801a1e:	c1 e8 0c             	shr    $0xc,%eax
  801a21:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  801a28:	01 00 00 00 

					ptr_uheap += (uint32) PAGE_SIZE;
  801a2c:	a1 04 40 80 00       	mov    0x804004,%eax
  801a31:	05 00 10 00 00       	add    $0x1000,%eax
  801a36:	a3 04 40 80 00       	mov    %eax,0x804004
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
				cnt_mem++;
				int i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801a3b:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801a42:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a45:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a48:	72 ca                	jb     801a14 <malloc+0x215>
							/ (uint32) PAGE_SIZE)] = 1;

					ptr_uheap += (uint32) PAGE_SIZE;
				}

				return ret;
  801a4a:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  801a50:	e9 4a 07 00 00       	jmp    80219f <malloc+0x9a0>

			} else {

				if (check_start) {
  801a55:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a59:	74 0a                	je     801a65 <malloc+0x266>

					return NULL;
  801a5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801a60:	e9 3a 07 00 00       	jmp    80219f <malloc+0x9a0>
				}

//////////////back loop////////////////

				uint32 sz = 0;
  801a65:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
				int f = 0;
  801a6c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				uint32 ptr = USER_HEAP_START;
  801a73:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
				ptr_uheap = USER_HEAP_START;
  801a7a:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  801a81:	00 00 80 
				while (ptr < (uint32) temp_end) {
  801a84:	eb 4d                	jmp    801ad3 <malloc+0x2d4>
					if (sz == size) {
  801a86:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a89:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a8c:	75 09                	jne    801a97 <malloc+0x298>
						f = 1;
  801a8e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
						break;
  801a95:	eb 44                	jmp    801adb <malloc+0x2dc>
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801a97:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801a9a:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] == 0) {
  801a9f:	c1 e8 0c             	shr    $0xc,%eax
				while (ptr < (uint32) temp_end) {
					if (sz == size) {
						f = 1;
						break;
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801aa2:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  801aa9:	85 c0                	test   %eax,%eax
  801aab:	75 10                	jne    801abd <malloc+0x2be>
							/ (uint32) PAGE_SIZE)] == 0) {

						sz += PAGE_SIZE;
  801aad:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801ab4:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
  801abb:	eb 16                	jmp    801ad3 <malloc+0x2d4>
					} else {
						sz = 0;
  801abd:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801ac4:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
						ptr_uheap = ptr;
  801acb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ace:	a3 04 40 80 00       	mov    %eax,0x804004

				uint32 sz = 0;
				int f = 0;
				uint32 ptr = USER_HEAP_START;
				ptr_uheap = USER_HEAP_START;
				while (ptr < (uint32) temp_end) {
  801ad3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad6:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801ad9:	72 ab                	jb     801a86 <malloc+0x287>
						ptr_uheap = ptr;
					}

				}

				if (f) {
  801adb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801adf:	0f 84 95 00 00 00    	je     801b7a <malloc+0x37b>

					void* ret = (void *) ptr_uheap;
  801ae5:	a1 04 40 80 00       	mov    0x804004,%eax
  801aea:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

					sys_allocateMem(ptr_uheap, size);
  801af0:	a1 04 40 80 00       	mov    0x804004,%eax
  801af5:	83 ec 08             	sub    $0x8,%esp
  801af8:	ff 75 08             	pushl  0x8(%ebp)
  801afb:	50                   	push   %eax
  801afc:	e8 35 09 00 00       	call   802436 <sys_allocateMem>
  801b01:	83 c4 10             	add    $0x10,%esp

					heap_size[cnt_mem].size = size;
  801b04:	a1 40 40 80 00       	mov    0x804040,%eax
  801b09:	8b 55 08             	mov    0x8(%ebp),%edx
  801b0c:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801b13:	a1 40 40 80 00       	mov    0x804040,%eax
  801b18:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b1e:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
					cnt_mem++;
  801b25:	a1 40 40 80 00       	mov    0x804040,%eax
  801b2a:	40                   	inc    %eax
  801b2b:	a3 40 40 80 00       	mov    %eax,0x804040
					int i = 0;
  801b30:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

					for (; i < size; i += PAGE_SIZE)
  801b37:	eb 2e                	jmp    801b67 <malloc+0x368>
					{

						heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801b39:	a1 04 40 80 00       	mov    0x804004,%eax
  801b3e:	05 00 00 00 80       	add    $0x80000000,%eax
								/ (uint32) PAGE_SIZE)] = 1;
  801b43:	c1 e8 0c             	shr    $0xc,%eax
  801b46:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  801b4d:	01 00 00 00 

						ptr_uheap += (uint32) PAGE_SIZE;
  801b51:	a1 04 40 80 00       	mov    0x804004,%eax
  801b56:	05 00 10 00 00       	add    $0x1000,%eax
  801b5b:	a3 04 40 80 00       	mov    %eax,0x804004
					heap_size[cnt_mem].size = size;
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
					cnt_mem++;
					int i = 0;

					for (; i < size; i += PAGE_SIZE)
  801b60:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  801b67:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801b6a:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b6d:	72 ca                	jb     801b39 <malloc+0x33a>
								/ (uint32) PAGE_SIZE)] = 1;

						ptr_uheap += (uint32) PAGE_SIZE;
					}

					return ret;
  801b6f:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801b75:	e9 25 06 00 00       	jmp    80219f <malloc+0x9a0>

				} else {

					return NULL;
  801b7a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7f:	e9 1b 06 00 00       	jmp    80219f <malloc+0x9a0>

		}

	}

	else if (sys_isUHeapPlacementStrategyBESTFIT()) {
  801b84:	e8 d0 0b 00 00       	call   802759 <sys_isUHeapPlacementStrategyBESTFIT>
  801b89:	85 c0                	test   %eax,%eax
  801b8b:	0f 84 ba 01 00 00    	je     801d4b <malloc+0x54c>

		size = ROUNDUP(size, PAGE_SIZE);
  801b91:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  801b98:	10 00 00 
  801b9b:	8b 55 08             	mov    0x8(%ebp),%edx
  801b9e:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  801ba4:	01 d0                	add    %edx,%eax
  801ba6:	48                   	dec    %eax
  801ba7:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  801bad:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801bb3:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb8:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  801bbe:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801bc4:	29 d0                	sub    %edx,%eax
  801bc6:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801bc9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bcd:	74 09                	je     801bd8 <malloc+0x3d9>
  801bcf:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801bd6:	76 0a                	jbe    801be2 <malloc+0x3e3>
			return NULL;
  801bd8:	b8 00 00 00 00       	mov    $0x0,%eax
  801bdd:	e9 bd 05 00 00       	jmp    80219f <malloc+0x9a0>
		}
		uint32 ptr = (uint32) USER_HEAP_START;
  801be2:	c7 45 c8 00 00 00 80 	movl   $0x80000000,-0x38(%ebp)
		uint32 temp = 0;
  801be9:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		uint32 min_sz = size_uhmem + 1;
  801bf0:	c7 45 c0 01 00 02 00 	movl   $0x20001,-0x40(%ebp)
		uint32 count = 0;
  801bf7:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
		int i = 0;
  801bfe:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801c05:	8b 45 08             	mov    0x8(%ebp),%eax
  801c08:	c1 e8 0c             	shr    $0xc,%eax
  801c0b:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801c11:	e9 80 00 00 00       	jmp    801c96 <malloc+0x497>

			if (heap_mem[i] == 0) {
  801c16:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801c19:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  801c20:	85 c0                	test   %eax,%eax
  801c22:	75 0c                	jne    801c30 <malloc+0x431>

				count++;
  801c24:	ff 45 bc             	incl   -0x44(%ebp)
				ptr += PAGE_SIZE;
  801c27:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801c2e:	eb 2d                	jmp    801c5d <malloc+0x45e>
			} else {
				if (num_p <= count && min_sz > count) {
  801c30:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801c36:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801c39:	77 14                	ja     801c4f <malloc+0x450>
  801c3b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c3e:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801c41:	76 0c                	jbe    801c4f <malloc+0x450>

					min_sz = count;
  801c43:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801c46:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801c49:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c4c:	89 45 c4             	mov    %eax,-0x3c(%ebp)

				}
				count = 0;
  801c4f:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
				ptr += PAGE_SIZE;
  801c56:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
			}

			if (i == size_uhmem - 1) {
  801c5d:	81 7d b8 ff ff 01 00 	cmpl   $0x1ffff,-0x48(%ebp)
  801c64:	75 2d                	jne    801c93 <malloc+0x494>

				if (num_p <= count && min_sz > count) {
  801c66:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801c6c:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801c6f:	77 22                	ja     801c93 <malloc+0x494>
  801c71:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c74:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801c77:	76 1a                	jbe    801c93 <malloc+0x494>

					min_sz = count;
  801c79:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801c7c:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801c7f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c82:	89 45 c4             	mov    %eax,-0x3c(%ebp)
					count = 0;
  801c85:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
					ptr += PAGE_SIZE;
  801c8c:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801c93:	ff 45 b8             	incl   -0x48(%ebp)
  801c96:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801c99:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801c9e:	0f 86 72 ff ff ff    	jbe    801c16 <malloc+0x417>

			}

		}

		if (num_p > min_sz || temp == 0) {
  801ca4:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801caa:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  801cad:	77 06                	ja     801cb5 <malloc+0x4b6>
  801caf:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801cb3:	75 0a                	jne    801cbf <malloc+0x4c0>
			return NULL;
  801cb5:	b8 00 00 00 00       	mov    $0x0,%eax
  801cba:	e9 e0 04 00 00       	jmp    80219f <malloc+0x9a0>

		}

		temp = temp - (PAGE_SIZE * min_sz);
  801cbf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801cc2:	c1 e0 0c             	shl    $0xc,%eax
  801cc5:	29 45 c4             	sub    %eax,-0x3c(%ebp)
		void* ret = (void*) temp;
  801cc8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801ccb:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)

		sys_allocateMem(temp, size);
  801cd1:	83 ec 08             	sub    $0x8,%esp
  801cd4:	ff 75 08             	pushl  0x8(%ebp)
  801cd7:	ff 75 c4             	pushl  -0x3c(%ebp)
  801cda:	e8 57 07 00 00       	call   802436 <sys_allocateMem>
  801cdf:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801ce2:	a1 40 40 80 00       	mov    0x804040,%eax
  801ce7:	8b 55 08             	mov    0x8(%ebp),%edx
  801cea:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801cf1:	a1 40 40 80 00       	mov    0x804040,%eax
  801cf6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801cf9:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
		cnt_mem++;
  801d00:	a1 40 40 80 00       	mov    0x804040,%eax
  801d05:	40                   	inc    %eax
  801d06:	a3 40 40 80 00       	mov    %eax,0x804040
		i = 0;
  801d0b:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801d12:	eb 24                	jmp    801d38 <malloc+0x539>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801d14:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801d17:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801d1c:	c1 e8 0c             	shr    $0xc,%eax
  801d1f:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  801d26:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801d2a:	81 45 c4 00 10 00 00 	addl   $0x1000,-0x3c(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801d31:	81 45 b8 00 10 00 00 	addl   $0x1000,-0x48(%ebp)
  801d38:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801d3b:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d3e:	72 d4                	jb     801d14 <malloc+0x515>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801d40:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801d46:	e9 54 04 00 00       	jmp    80219f <malloc+0x9a0>

	} else if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801d4b:	e8 d8 09 00 00       	call   802728 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d50:	85 c0                	test   %eax,%eax
  801d52:	0f 84 88 01 00 00    	je     801ee0 <malloc+0x6e1>

		size = ROUNDUP(size, PAGE_SIZE);
  801d58:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  801d5f:	10 00 00 
  801d62:	8b 55 08             	mov    0x8(%ebp),%edx
  801d65:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  801d6b:	01 d0                	add    %edx,%eax
  801d6d:	48                   	dec    %eax
  801d6e:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  801d74:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801d7a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d7f:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  801d85:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801d8b:	29 d0                	sub    %edx,%eax
  801d8d:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801d90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d94:	74 09                	je     801d9f <malloc+0x5a0>
  801d96:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801d9d:	76 0a                	jbe    801da9 <malloc+0x5aa>
			return NULL;
  801d9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801da4:	e9 f6 03 00 00       	jmp    80219f <malloc+0x9a0>
		}

		uint32 ptr = (uint32) USER_HEAP_START;
  801da9:	c7 45 b4 00 00 00 80 	movl   $0x80000000,-0x4c(%ebp)
		uint32 temp = 0;
  801db0:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
		uint32 found = 0;
  801db7:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		uint32 count = 0;
  801dbe:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
		int i = 0;
  801dc5:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcf:	c1 e8 0c             	shr    $0xc,%eax
  801dd2:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

		for (; i < size_uhmem; i++) {
  801dd8:	eb 5a                	jmp    801e34 <malloc+0x635>

			if (heap_mem[i] == 0) {
  801dda:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801ddd:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  801de4:	85 c0                	test   %eax,%eax
  801de6:	75 0c                	jne    801df4 <malloc+0x5f5>

				count++;
  801de8:	ff 45 a8             	incl   -0x58(%ebp)
				ptr += PAGE_SIZE;
  801deb:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
  801df2:	eb 22                	jmp    801e16 <malloc+0x617>
			} else {
				if (num_p <= count) {
  801df4:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801dfa:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801dfd:	77 09                	ja     801e08 <malloc+0x609>

					found = 1;
  801dff:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)

					break;
  801e06:	eb 36                	jmp    801e3e <malloc+0x63f>
				}
				count = 0;
  801e08:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
				ptr += PAGE_SIZE;
  801e0f:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
			}

			if (i == size_uhmem - 1) {
  801e16:	81 7d a4 ff ff 01 00 	cmpl   $0x1ffff,-0x5c(%ebp)
  801e1d:	75 12                	jne    801e31 <malloc+0x632>

				if (num_p <= count) {
  801e1f:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801e25:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801e28:	77 07                	ja     801e31 <malloc+0x632>

					found = 1;
  801e2a:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
		uint32 found = 0;
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		for (; i < size_uhmem; i++) {
  801e31:	ff 45 a4             	incl   -0x5c(%ebp)
  801e34:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801e37:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801e3c:	76 9c                	jbe    801dda <malloc+0x5db>

			}

		}

		if (!found) {
  801e3e:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  801e42:	75 0a                	jne    801e4e <malloc+0x64f>
			return NULL;
  801e44:	b8 00 00 00 00       	mov    $0x0,%eax
  801e49:	e9 51 03 00 00       	jmp    80219f <malloc+0x9a0>

		}

		temp = ptr;
  801e4e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801e51:	89 45 b0             	mov    %eax,-0x50(%ebp)
		temp = temp - (PAGE_SIZE * count);
  801e54:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801e57:	c1 e0 0c             	shl    $0xc,%eax
  801e5a:	29 45 b0             	sub    %eax,-0x50(%ebp)
		void* ret = (void*) temp;
  801e5d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801e60:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)

		sys_allocateMem(temp, size);
  801e66:	83 ec 08             	sub    $0x8,%esp
  801e69:	ff 75 08             	pushl  0x8(%ebp)
  801e6c:	ff 75 b0             	pushl  -0x50(%ebp)
  801e6f:	e8 c2 05 00 00       	call   802436 <sys_allocateMem>
  801e74:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801e77:	a1 40 40 80 00       	mov    0x804040,%eax
  801e7c:	8b 55 08             	mov    0x8(%ebp),%edx
  801e7f:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801e86:	a1 40 40 80 00       	mov    0x804040,%eax
  801e8b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801e8e:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
		cnt_mem++;
  801e95:	a1 40 40 80 00       	mov    0x804040,%eax
  801e9a:	40                   	inc    %eax
  801e9b:	a3 40 40 80 00       	mov    %eax,0x804040
		i = 0;
  801ea0:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801ea7:	eb 24                	jmp    801ecd <malloc+0x6ce>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801ea9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801eac:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801eb1:	c1 e8 0c             	shr    $0xc,%eax
  801eb4:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  801ebb:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801ebf:	81 45 b0 00 10 00 00 	addl   $0x1000,-0x50(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801ec6:	81 45 a4 00 10 00 00 	addl   $0x1000,-0x5c(%ebp)
  801ecd:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801ed0:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ed3:	72 d4                	jb     801ea9 <malloc+0x6aa>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801ed5:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  801edb:	e9 bf 02 00 00       	jmp    80219f <malloc+0x9a0>

	}
	else if(sys_isUHeapPlacementStrategyWORSTFIT())
  801ee0:	e8 d6 08 00 00       	call   8027bb <sys_isUHeapPlacementStrategyWORSTFIT>
  801ee5:	85 c0                	test   %eax,%eax
  801ee7:	0f 84 ba 01 00 00    	je     8020a7 <malloc+0x8a8>
	{
		size = ROUNDUP(size, PAGE_SIZE);
  801eed:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  801ef4:	10 00 00 
  801ef7:	8b 55 08             	mov    0x8(%ebp),%edx
  801efa:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  801f00:	01 d0                	add    %edx,%eax
  801f02:	48                   	dec    %eax
  801f03:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  801f09:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  801f0f:	ba 00 00 00 00       	mov    $0x0,%edx
  801f14:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  801f1a:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  801f20:	29 d0                	sub    %edx,%eax
  801f22:	89 45 08             	mov    %eax,0x8(%ebp)

				if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801f25:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f29:	74 09                	je     801f34 <malloc+0x735>
  801f2b:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801f32:	76 0a                	jbe    801f3e <malloc+0x73f>
					return NULL;
  801f34:	b8 00 00 00 00       	mov    $0x0,%eax
  801f39:	e9 61 02 00 00       	jmp    80219f <malloc+0x9a0>
				}
				uint32 ptr = (uint32) USER_HEAP_START;
  801f3e:	c7 45 a0 00 00 00 80 	movl   $0x80000000,-0x60(%ebp)
				uint32 temp = 0;
  801f45:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
				uint32 max_sz = -1;
  801f4c:	c7 45 98 ff ff ff ff 	movl   $0xffffffff,-0x68(%ebp)
				uint32 count = 0;
  801f53:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
				int i = 0;
  801f5a:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				uint32 num_p = size / PAGE_SIZE;
  801f61:	8b 45 08             	mov    0x8(%ebp),%eax
  801f64:	c1 e8 0c             	shr    $0xc,%eax
  801f67:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  801f6d:	e9 80 00 00 00       	jmp    801ff2 <malloc+0x7f3>

					if (heap_mem[i] == 0) {
  801f72:	8b 45 90             	mov    -0x70(%ebp),%eax
  801f75:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  801f7c:	85 c0                	test   %eax,%eax
  801f7e:	75 0c                	jne    801f8c <malloc+0x78d>

						count++;
  801f80:	ff 45 94             	incl   -0x6c(%ebp)
						ptr += PAGE_SIZE;
  801f83:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
  801f8a:	eb 2d                	jmp    801fb9 <malloc+0x7ba>
					} else {
						if (num_p <= count && max_sz < count) {
  801f8c:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801f92:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801f95:	77 14                	ja     801fab <malloc+0x7ac>
  801f97:	8b 45 98             	mov    -0x68(%ebp),%eax
  801f9a:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801f9d:	73 0c                	jae    801fab <malloc+0x7ac>

							max_sz = count;
  801f9f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801fa2:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  801fa5:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801fa8:	89 45 9c             	mov    %eax,-0x64(%ebp)

						}
						count = 0;
  801fab:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
						ptr += PAGE_SIZE;
  801fb2:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
					}

					if (i == size_uhmem - 1) {
  801fb9:	81 7d 90 ff ff 01 00 	cmpl   $0x1ffff,-0x70(%ebp)
  801fc0:	75 2d                	jne    801fef <malloc+0x7f0>

						if (num_p <= count && max_sz > count) {
  801fc2:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801fc8:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801fcb:	77 22                	ja     801fef <malloc+0x7f0>
  801fcd:	8b 45 98             	mov    -0x68(%ebp),%eax
  801fd0:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801fd3:	76 1a                	jbe    801fef <malloc+0x7f0>

							max_sz = count;
  801fd5:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801fd8:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  801fdb:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801fde:	89 45 9c             	mov    %eax,-0x64(%ebp)
							count = 0;
  801fe1:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
							ptr += PAGE_SIZE;
  801fe8:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
				uint32 count = 0;
				int i = 0;
				uint32 num_p = size / PAGE_SIZE;

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  801fef:	ff 45 90             	incl   -0x70(%ebp)
  801ff2:	8b 45 90             	mov    -0x70(%ebp),%eax
  801ff5:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801ffa:	0f 86 72 ff ff ff    	jbe    801f72 <malloc+0x773>

					}

				}

				if (num_p > max_sz || temp == 0) {
  802000:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  802006:	3b 45 98             	cmp    -0x68(%ebp),%eax
  802009:	77 06                	ja     802011 <malloc+0x812>
  80200b:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  80200f:	75 0a                	jne    80201b <malloc+0x81c>
					return NULL;
  802011:	b8 00 00 00 00       	mov    $0x0,%eax
  802016:	e9 84 01 00 00       	jmp    80219f <malloc+0x9a0>

				}

				temp = temp - (PAGE_SIZE * max_sz);
  80201b:	8b 45 98             	mov    -0x68(%ebp),%eax
  80201e:	c1 e0 0c             	shl    $0xc,%eax
  802021:	29 45 9c             	sub    %eax,-0x64(%ebp)
				void* ret = (void*) temp;
  802024:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802027:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

				sys_allocateMem(temp, size);
  80202d:	83 ec 08             	sub    $0x8,%esp
  802030:	ff 75 08             	pushl  0x8(%ebp)
  802033:	ff 75 9c             	pushl  -0x64(%ebp)
  802036:	e8 fb 03 00 00       	call   802436 <sys_allocateMem>
  80203b:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  80203e:	a1 40 40 80 00       	mov    0x804040,%eax
  802043:	8b 55 08             	mov    0x8(%ebp),%edx
  802046:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
				heap_size[cnt_mem].vir = (void*) temp;
  80204d:	a1 40 40 80 00       	mov    0x804040,%eax
  802052:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802055:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
				cnt_mem++;
  80205c:	a1 40 40 80 00       	mov    0x804040,%eax
  802061:	40                   	inc    %eax
  802062:	a3 40 40 80 00       	mov    %eax,0x804040
				i = 0;
  802067:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  80206e:	eb 24                	jmp    802094 <malloc+0x895>
				{

					heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  802070:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802073:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  802078:	c1 e8 0c             	shr    $0xc,%eax
  80207b:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  802082:	01 00 00 00 

					temp += (uint32) PAGE_SIZE;
  802086:	81 45 9c 00 10 00 00 	addl   $0x1000,-0x64(%ebp)
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) temp;
				cnt_mem++;
				i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  80208d:	81 45 90 00 10 00 00 	addl   $0x1000,-0x70(%ebp)
  802094:	8b 45 90             	mov    -0x70(%ebp),%eax
  802097:	3b 45 08             	cmp    0x8(%ebp),%eax
  80209a:	72 d4                	jb     802070 <malloc+0x871>

					temp += (uint32) PAGE_SIZE;
				}

				//cprintf("\n size = %d.........vir= %d  \n",num_p,((uint32) ret-USER_HEAP_START)/PAGE_SIZE);
				return ret;
  80209c:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  8020a2:	e9 f8 00 00 00       	jmp    80219f <malloc+0x9a0>

	}
// this is to make malloc is work
	void* ret = NULL;
  8020a7:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
	size = ROUNDUP(size, PAGE_SIZE);
  8020ae:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  8020b5:	10 00 00 
  8020b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8020bb:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  8020c1:	01 d0                	add    %edx,%eax
  8020c3:	48                   	dec    %eax
  8020c4:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  8020ca:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  8020d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8020d5:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  8020db:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  8020e1:	29 d0                	sub    %edx,%eax
  8020e3:	89 45 08             	mov    %eax,0x8(%ebp)

	if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  8020e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020ea:	74 09                	je     8020f5 <malloc+0x8f6>
  8020ec:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8020f3:	76 0a                	jbe    8020ff <malloc+0x900>
		return NULL;
  8020f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020fa:	e9 a0 00 00 00       	jmp    80219f <malloc+0x9a0>
	}

	if (ptr_uheap + size <= (uint32) USER_HEAP_MAX) {
  8020ff:	8b 15 04 40 80 00    	mov    0x804004,%edx
  802105:	8b 45 08             	mov    0x8(%ebp),%eax
  802108:	01 d0                	add    %edx,%eax
  80210a:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80210f:	0f 87 87 00 00 00    	ja     80219c <malloc+0x99d>

		ret = (void *) ptr_uheap;
  802115:	a1 04 40 80 00       	mov    0x804004,%eax
  80211a:	89 45 8c             	mov    %eax,-0x74(%ebp)
		sys_allocateMem(ptr_uheap, size);
  80211d:	a1 04 40 80 00       	mov    0x804004,%eax
  802122:	83 ec 08             	sub    $0x8,%esp
  802125:	ff 75 08             	pushl  0x8(%ebp)
  802128:	50                   	push   %eax
  802129:	e8 08 03 00 00       	call   802436 <sys_allocateMem>
  80212e:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  802131:	a1 40 40 80 00       	mov    0x804040,%eax
  802136:	8b 55 08             	mov    0x8(%ebp),%edx
  802139:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
  802140:	a1 40 40 80 00       	mov    0x804040,%eax
  802145:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80214b:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
		cnt_mem++;
  802152:	a1 40 40 80 00       	mov    0x804040,%eax
  802157:	40                   	inc    %eax
  802158:	a3 40 40 80 00       	mov    %eax,0x804040
		int i = 0;
  80215d:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)

		for (; i < size; i += PAGE_SIZE)
  802164:	eb 2e                	jmp    802194 <malloc+0x995>
		{

			heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  802166:	a1 04 40 80 00       	mov    0x804004,%eax
  80216b:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  802170:	c1 e8 0c             	shr    $0xc,%eax
  802173:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  80217a:	01 00 00 00 

			ptr_uheap += (uint32) PAGE_SIZE;
  80217e:	a1 04 40 80 00       	mov    0x804004,%eax
  802183:	05 00 10 00 00       	add    $0x1000,%eax
  802188:	a3 04 40 80 00       	mov    %eax,0x804004
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
		cnt_mem++;
		int i = 0;

		for (; i < size; i += PAGE_SIZE)
  80218d:	81 45 88 00 10 00 00 	addl   $0x1000,-0x78(%ebp)
  802194:	8b 45 88             	mov    -0x78(%ebp),%eax
  802197:	3b 45 08             	cmp    0x8(%ebp),%eax
  80219a:	72 ca                	jb     802166 <malloc+0x967>
					/ (uint32) PAGE_SIZE)] = 1;

			ptr_uheap += (uint32) PAGE_SIZE;
		}
	}
	return ret;
  80219c:	8b 45 8c             	mov    -0x74(%ebp),%eax

	//TODO: [PROJECT 2016 - BONUS2] Apply FIRST FIT and WORST FIT policies

//return 0;

}
  80219f:	c9                   	leave  
  8021a0:	c3                   	ret    

008021a1 <free>:
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address) {
  8021a1:	55                   	push   %ebp
  8021a2:	89 e5                	mov    %esp,%ebp
  8021a4:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
  8021a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; inx < cnt_mem; inx++) {
  8021ae:	e9 c1 00 00 00       	jmp    802274 <free+0xd3>
		if (heap_size[inx].vir == virtual_address) {
  8021b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b6:	8b 04 c5 60 40 88 00 	mov    0x884060(,%eax,8),%eax
  8021bd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021c0:	0f 85 ab 00 00 00    	jne    802271 <free+0xd0>

			if (heap_size[inx].size == 0) {
  8021c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c9:	8b 04 c5 64 40 88 00 	mov    0x884064(,%eax,8),%eax
  8021d0:	85 c0                	test   %eax,%eax
  8021d2:	75 21                	jne    8021f5 <free+0x54>
				heap_size[inx].size = 0;
  8021d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d7:	c7 04 c5 64 40 88 00 	movl   $0x0,0x884064(,%eax,8)
  8021de:	00 00 00 00 
				heap_size[inx].vir = NULL;
  8021e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e5:	c7 04 c5 60 40 88 00 	movl   $0x0,0x884060(,%eax,8)
  8021ec:	00 00 00 00 
				return;
  8021f0:	e9 8d 00 00 00       	jmp    802282 <free+0xe1>

			}

			sys_freeMem((uint32) virtual_address, heap_size[inx].size);
  8021f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f8:	8b 14 c5 64 40 88 00 	mov    0x884064(,%eax,8),%edx
  8021ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802202:	83 ec 08             	sub    $0x8,%esp
  802205:	52                   	push   %edx
  802206:	50                   	push   %eax
  802207:	e8 0e 02 00 00       	call   80241a <sys_freeMem>
  80220c:	83 c4 10             	add    $0x10,%esp

			int i = 0;
  80220f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
  802216:	8b 45 08             	mov    0x8(%ebp),%eax
  802219:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  80221c:	eb 24                	jmp    802242 <free+0xa1>
			{
				heap_mem[(int) (((uint32) va - USER_HEAP_START) / PAGE_SIZE)] =
  80221e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802221:	05 00 00 00 80       	add    $0x80000000,%eax
  802226:	c1 e8 0c             	shr    $0xc,%eax
  802229:	c7 04 85 60 40 80 00 	movl   $0x0,0x804060(,%eax,4)
  802230:	00 00 00 00 
						0;

				va += PAGE_SIZE;
  802234:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
			sys_freeMem((uint32) virtual_address, heap_size[inx].size);

			int i = 0;
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  80223b:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  802242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802245:	8b 14 c5 64 40 88 00 	mov    0x884064(,%eax,8),%edx
  80224c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80224f:	39 c2                	cmp    %eax,%edx
  802251:	77 cb                	ja     80221e <free+0x7d>

				va += PAGE_SIZE;

			}

			heap_size[inx].size = 0;
  802253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802256:	c7 04 c5 64 40 88 00 	movl   $0x0,0x884064(,%eax,8)
  80225d:	00 00 00 00 
			heap_size[inx].vir = NULL;
  802261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802264:	c7 04 c5 60 40 88 00 	movl   $0x0,0x884060(,%eax,8)
  80226b:	00 00 00 00 
			break;
  80226f:	eb 11                	jmp    802282 <free+0xe1>
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
	for (; inx < cnt_mem; inx++) {
  802271:	ff 45 f4             	incl   -0xc(%ebp)
  802274:	a1 40 40 80 00       	mov    0x804040,%eax
  802279:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  80227c:	0f 8c 31 ff ff ff    	jl     8021b3 <free+0x12>
	}

	//get the size of the given allocation using its address
	//you need to call sys_freeMem()

}
  802282:	c9                   	leave  
  802283:	c3                   	ret    

00802284 <realloc>:
//  Hint: you may need to use the sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size) {
  802284:	55                   	push   %ebp
  802285:	89 e5                	mov    %esp,%ebp
  802287:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2016 - BONUS4] realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80228a:	83 ec 04             	sub    $0x4,%esp
  80228d:	68 44 30 80 00       	push   $0x803044
  802292:	68 1c 02 00 00       	push   $0x21c
  802297:	68 6a 30 80 00       	push   $0x80306a
  80229c:	e8 aa e4 ff ff       	call   80074b <_panic>

008022a1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8022a1:	55                   	push   %ebp
  8022a2:	89 e5                	mov    %esp,%ebp
  8022a4:	57                   	push   %edi
  8022a5:	56                   	push   %esi
  8022a6:	53                   	push   %ebx
  8022a7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8022aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022b3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022b6:	8b 7d 18             	mov    0x18(%ebp),%edi
  8022b9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8022bc:	cd 30                	int    $0x30
  8022be:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8022c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8022c4:	83 c4 10             	add    $0x10,%esp
  8022c7:	5b                   	pop    %ebx
  8022c8:	5e                   	pop    %esi
  8022c9:	5f                   	pop    %edi
  8022ca:	5d                   	pop    %ebp
  8022cb:	c3                   	ret    

008022cc <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  8022cc:	55                   	push   %ebp
  8022cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  8022cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	ff 75 0c             	pushl  0xc(%ebp)
  8022db:	50                   	push   %eax
  8022dc:	6a 00                	push   $0x0
  8022de:	e8 be ff ff ff       	call   8022a1 <syscall>
  8022e3:	83 c4 18             	add    $0x18,%esp
}
  8022e6:	90                   	nop
  8022e7:	c9                   	leave  
  8022e8:	c3                   	ret    

008022e9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8022e9:	55                   	push   %ebp
  8022ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 00                	push   $0x0
  8022f6:	6a 01                	push   $0x1
  8022f8:	e8 a4 ff ff ff       	call   8022a1 <syscall>
  8022fd:	83 c4 18             	add    $0x18,%esp
}
  802300:	c9                   	leave  
  802301:	c3                   	ret    

00802302 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  802302:	55                   	push   %ebp
  802303:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	6a 00                	push   $0x0
  80230e:	6a 00                	push   $0x0
  802310:	50                   	push   %eax
  802311:	6a 03                	push   $0x3
  802313:	e8 89 ff ff ff       	call   8022a1 <syscall>
  802318:	83 c4 18             	add    $0x18,%esp
}
  80231b:	c9                   	leave  
  80231c:	c3                   	ret    

0080231d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80231d:	55                   	push   %ebp
  80231e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	6a 00                	push   $0x0
  802326:	6a 00                	push   $0x0
  802328:	6a 00                	push   $0x0
  80232a:	6a 02                	push   $0x2
  80232c:	e8 70 ff ff ff       	call   8022a1 <syscall>
  802331:	83 c4 18             	add    $0x18,%esp
}
  802334:	c9                   	leave  
  802335:	c3                   	ret    

00802336 <sys_env_exit>:

void sys_env_exit(void)
{
  802336:	55                   	push   %ebp
  802337:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  802339:	6a 00                	push   $0x0
  80233b:	6a 00                	push   $0x0
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	6a 00                	push   $0x0
  802343:	6a 04                	push   $0x4
  802345:	e8 57 ff ff ff       	call   8022a1 <syscall>
  80234a:	83 c4 18             	add    $0x18,%esp
}
  80234d:	90                   	nop
  80234e:	c9                   	leave  
  80234f:	c3                   	ret    

00802350 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  802350:	55                   	push   %ebp
  802351:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802353:	8b 55 0c             	mov    0xc(%ebp),%edx
  802356:	8b 45 08             	mov    0x8(%ebp),%eax
  802359:	6a 00                	push   $0x0
  80235b:	6a 00                	push   $0x0
  80235d:	6a 00                	push   $0x0
  80235f:	52                   	push   %edx
  802360:	50                   	push   %eax
  802361:	6a 05                	push   $0x5
  802363:	e8 39 ff ff ff       	call   8022a1 <syscall>
  802368:	83 c4 18             	add    $0x18,%esp
}
  80236b:	c9                   	leave  
  80236c:	c3                   	ret    

0080236d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80236d:	55                   	push   %ebp
  80236e:	89 e5                	mov    %esp,%ebp
  802370:	56                   	push   %esi
  802371:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802372:	8b 75 18             	mov    0x18(%ebp),%esi
  802375:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802378:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80237b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80237e:	8b 45 08             	mov    0x8(%ebp),%eax
  802381:	56                   	push   %esi
  802382:	53                   	push   %ebx
  802383:	51                   	push   %ecx
  802384:	52                   	push   %edx
  802385:	50                   	push   %eax
  802386:	6a 06                	push   $0x6
  802388:	e8 14 ff ff ff       	call   8022a1 <syscall>
  80238d:	83 c4 18             	add    $0x18,%esp
}
  802390:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802393:	5b                   	pop    %ebx
  802394:	5e                   	pop    %esi
  802395:	5d                   	pop    %ebp
  802396:	c3                   	ret    

00802397 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802397:	55                   	push   %ebp
  802398:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80239a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80239d:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 00                	push   $0x0
  8023a6:	52                   	push   %edx
  8023a7:	50                   	push   %eax
  8023a8:	6a 07                	push   $0x7
  8023aa:	e8 f2 fe ff ff       	call   8022a1 <syscall>
  8023af:	83 c4 18             	add    $0x18,%esp
}
  8023b2:	c9                   	leave  
  8023b3:	c3                   	ret    

008023b4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8023b4:	55                   	push   %ebp
  8023b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	ff 75 0c             	pushl  0xc(%ebp)
  8023c0:	ff 75 08             	pushl  0x8(%ebp)
  8023c3:	6a 08                	push   $0x8
  8023c5:	e8 d7 fe ff ff       	call   8022a1 <syscall>
  8023ca:	83 c4 18             	add    $0x18,%esp
}
  8023cd:	c9                   	leave  
  8023ce:	c3                   	ret    

008023cf <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8023cf:	55                   	push   %ebp
  8023d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 00                	push   $0x0
  8023dc:	6a 09                	push   $0x9
  8023de:	e8 be fe ff ff       	call   8022a1 <syscall>
  8023e3:	83 c4 18             	add    $0x18,%esp
}
  8023e6:	c9                   	leave  
  8023e7:	c3                   	ret    

008023e8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8023e8:	55                   	push   %ebp
  8023e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 0a                	push   $0xa
  8023f7:	e8 a5 fe ff ff       	call   8022a1 <syscall>
  8023fc:	83 c4 18             	add    $0x18,%esp
}
  8023ff:	c9                   	leave  
  802400:	c3                   	ret    

00802401 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802401:	55                   	push   %ebp
  802402:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	6a 0b                	push   $0xb
  802410:	e8 8c fe ff ff       	call   8022a1 <syscall>
  802415:	83 c4 18             	add    $0x18,%esp
}
  802418:	c9                   	leave  
  802419:	c3                   	ret    

0080241a <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  80241a:	55                   	push   %ebp
  80241b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  80241d:	6a 00                	push   $0x0
  80241f:	6a 00                	push   $0x0
  802421:	6a 00                	push   $0x0
  802423:	ff 75 0c             	pushl  0xc(%ebp)
  802426:	ff 75 08             	pushl  0x8(%ebp)
  802429:	6a 0d                	push   $0xd
  80242b:	e8 71 fe ff ff       	call   8022a1 <syscall>
  802430:	83 c4 18             	add    $0x18,%esp
	return;
  802433:	90                   	nop
}
  802434:	c9                   	leave  
  802435:	c3                   	ret    

00802436 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  802436:	55                   	push   %ebp
  802437:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  802439:	6a 00                	push   $0x0
  80243b:	6a 00                	push   $0x0
  80243d:	6a 00                	push   $0x0
  80243f:	ff 75 0c             	pushl  0xc(%ebp)
  802442:	ff 75 08             	pushl  0x8(%ebp)
  802445:	6a 0e                	push   $0xe
  802447:	e8 55 fe ff ff       	call   8022a1 <syscall>
  80244c:	83 c4 18             	add    $0x18,%esp
	return ;
  80244f:	90                   	nop
}
  802450:	c9                   	leave  
  802451:	c3                   	ret    

00802452 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802452:	55                   	push   %ebp
  802453:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802455:	6a 00                	push   $0x0
  802457:	6a 00                	push   $0x0
  802459:	6a 00                	push   $0x0
  80245b:	6a 00                	push   $0x0
  80245d:	6a 00                	push   $0x0
  80245f:	6a 0c                	push   $0xc
  802461:	e8 3b fe ff ff       	call   8022a1 <syscall>
  802466:	83 c4 18             	add    $0x18,%esp
}
  802469:	c9                   	leave  
  80246a:	c3                   	ret    

0080246b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80246b:	55                   	push   %ebp
  80246c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80246e:	6a 00                	push   $0x0
  802470:	6a 00                	push   $0x0
  802472:	6a 00                	push   $0x0
  802474:	6a 00                	push   $0x0
  802476:	6a 00                	push   $0x0
  802478:	6a 10                	push   $0x10
  80247a:	e8 22 fe ff ff       	call   8022a1 <syscall>
  80247f:	83 c4 18             	add    $0x18,%esp
}
  802482:	90                   	nop
  802483:	c9                   	leave  
  802484:	c3                   	ret    

00802485 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802485:	55                   	push   %ebp
  802486:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802488:	6a 00                	push   $0x0
  80248a:	6a 00                	push   $0x0
  80248c:	6a 00                	push   $0x0
  80248e:	6a 00                	push   $0x0
  802490:	6a 00                	push   $0x0
  802492:	6a 11                	push   $0x11
  802494:	e8 08 fe ff ff       	call   8022a1 <syscall>
  802499:	83 c4 18             	add    $0x18,%esp
}
  80249c:	90                   	nop
  80249d:	c9                   	leave  
  80249e:	c3                   	ret    

0080249f <sys_cputc>:


void
sys_cputc(const char c)
{
  80249f:	55                   	push   %ebp
  8024a0:	89 e5                	mov    %esp,%ebp
  8024a2:	83 ec 04             	sub    $0x4,%esp
  8024a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8024ab:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 00                	push   $0x0
  8024b3:	6a 00                	push   $0x0
  8024b5:	6a 00                	push   $0x0
  8024b7:	50                   	push   %eax
  8024b8:	6a 12                	push   $0x12
  8024ba:	e8 e2 fd ff ff       	call   8022a1 <syscall>
  8024bf:	83 c4 18             	add    $0x18,%esp
}
  8024c2:	90                   	nop
  8024c3:	c9                   	leave  
  8024c4:	c3                   	ret    

008024c5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8024c5:	55                   	push   %ebp
  8024c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8024c8:	6a 00                	push   $0x0
  8024ca:	6a 00                	push   $0x0
  8024cc:	6a 00                	push   $0x0
  8024ce:	6a 00                	push   $0x0
  8024d0:	6a 00                	push   $0x0
  8024d2:	6a 13                	push   $0x13
  8024d4:	e8 c8 fd ff ff       	call   8022a1 <syscall>
  8024d9:	83 c4 18             	add    $0x18,%esp
}
  8024dc:	90                   	nop
  8024dd:	c9                   	leave  
  8024de:	c3                   	ret    

008024df <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8024df:	55                   	push   %ebp
  8024e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8024e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e5:	6a 00                	push   $0x0
  8024e7:	6a 00                	push   $0x0
  8024e9:	6a 00                	push   $0x0
  8024eb:	ff 75 0c             	pushl  0xc(%ebp)
  8024ee:	50                   	push   %eax
  8024ef:	6a 14                	push   $0x14
  8024f1:	e8 ab fd ff ff       	call   8022a1 <syscall>
  8024f6:	83 c4 18             	add    $0x18,%esp
}
  8024f9:	c9                   	leave  
  8024fa:	c3                   	ret    

008024fb <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  8024fb:	55                   	push   %ebp
  8024fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  8024fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802501:	6a 00                	push   $0x0
  802503:	6a 00                	push   $0x0
  802505:	6a 00                	push   $0x0
  802507:	6a 00                	push   $0x0
  802509:	50                   	push   %eax
  80250a:	6a 17                	push   $0x17
  80250c:	e8 90 fd ff ff       	call   8022a1 <syscall>
  802511:	83 c4 18             	add    $0x18,%esp
}
  802514:	c9                   	leave  
  802515:	c3                   	ret    

00802516 <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  802516:	55                   	push   %ebp
  802517:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  802519:	8b 45 08             	mov    0x8(%ebp),%eax
  80251c:	6a 00                	push   $0x0
  80251e:	6a 00                	push   $0x0
  802520:	6a 00                	push   $0x0
  802522:	6a 00                	push   $0x0
  802524:	50                   	push   %eax
  802525:	6a 15                	push   $0x15
  802527:	e8 75 fd ff ff       	call   8022a1 <syscall>
  80252c:	83 c4 18             	add    $0x18,%esp
}
  80252f:	90                   	nop
  802530:	c9                   	leave  
  802531:	c3                   	ret    

00802532 <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  802532:	55                   	push   %ebp
  802533:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  802535:	8b 45 08             	mov    0x8(%ebp),%eax
  802538:	6a 00                	push   $0x0
  80253a:	6a 00                	push   $0x0
  80253c:	6a 00                	push   $0x0
  80253e:	6a 00                	push   $0x0
  802540:	50                   	push   %eax
  802541:	6a 16                	push   $0x16
  802543:	e8 59 fd ff ff       	call   8022a1 <syscall>
  802548:	83 c4 18             	add    $0x18,%esp
}
  80254b:	90                   	nop
  80254c:	c9                   	leave  
  80254d:	c3                   	ret    

0080254e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  80254e:	55                   	push   %ebp
  80254f:	89 e5                	mov    %esp,%ebp
  802551:	83 ec 04             	sub    $0x4,%esp
  802554:	8b 45 10             	mov    0x10(%ebp),%eax
  802557:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  80255a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80255d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802561:	8b 45 08             	mov    0x8(%ebp),%eax
  802564:	6a 00                	push   $0x0
  802566:	51                   	push   %ecx
  802567:	52                   	push   %edx
  802568:	ff 75 0c             	pushl  0xc(%ebp)
  80256b:	50                   	push   %eax
  80256c:	6a 18                	push   $0x18
  80256e:	e8 2e fd ff ff       	call   8022a1 <syscall>
  802573:	83 c4 18             	add    $0x18,%esp
}
  802576:	c9                   	leave  
  802577:	c3                   	ret    

00802578 <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  802578:	55                   	push   %ebp
  802579:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  80257b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80257e:	8b 45 08             	mov    0x8(%ebp),%eax
  802581:	6a 00                	push   $0x0
  802583:	6a 00                	push   $0x0
  802585:	6a 00                	push   $0x0
  802587:	52                   	push   %edx
  802588:	50                   	push   %eax
  802589:	6a 19                	push   $0x19
  80258b:	e8 11 fd ff ff       	call   8022a1 <syscall>
  802590:	83 c4 18             	add    $0x18,%esp
}
  802593:	c9                   	leave  
  802594:	c3                   	ret    

00802595 <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  802595:	55                   	push   %ebp
  802596:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  802598:	8b 45 08             	mov    0x8(%ebp),%eax
  80259b:	6a 00                	push   $0x0
  80259d:	6a 00                	push   $0x0
  80259f:	6a 00                	push   $0x0
  8025a1:	6a 00                	push   $0x0
  8025a3:	50                   	push   %eax
  8025a4:	6a 1a                	push   $0x1a
  8025a6:	e8 f6 fc ff ff       	call   8022a1 <syscall>
  8025ab:	83 c4 18             	add    $0x18,%esp
}
  8025ae:	c9                   	leave  
  8025af:	c3                   	ret    

008025b0 <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  8025b0:	55                   	push   %ebp
  8025b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  8025b3:	6a 00                	push   $0x0
  8025b5:	6a 00                	push   $0x0
  8025b7:	6a 00                	push   $0x0
  8025b9:	6a 00                	push   $0x0
  8025bb:	6a 00                	push   $0x0
  8025bd:	6a 1b                	push   $0x1b
  8025bf:	e8 dd fc ff ff       	call   8022a1 <syscall>
  8025c4:	83 c4 18             	add    $0x18,%esp
}
  8025c7:	c9                   	leave  
  8025c8:	c3                   	ret    

008025c9 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8025c9:	55                   	push   %ebp
  8025ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8025cc:	6a 00                	push   $0x0
  8025ce:	6a 00                	push   $0x0
  8025d0:	6a 00                	push   $0x0
  8025d2:	6a 00                	push   $0x0
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 1c                	push   $0x1c
  8025d8:	e8 c4 fc ff ff       	call   8022a1 <syscall>
  8025dd:	83 c4 18             	add    $0x18,%esp
}
  8025e0:	c9                   	leave  
  8025e1:	c3                   	ret    

008025e2 <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  8025e2:	55                   	push   %ebp
  8025e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  8025e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e8:	6a 00                	push   $0x0
  8025ea:	6a 00                	push   $0x0
  8025ec:	6a 00                	push   $0x0
  8025ee:	ff 75 0c             	pushl  0xc(%ebp)
  8025f1:	50                   	push   %eax
  8025f2:	6a 1d                	push   $0x1d
  8025f4:	e8 a8 fc ff ff       	call   8022a1 <syscall>
  8025f9:	83 c4 18             	add    $0x18,%esp
}
  8025fc:	c9                   	leave  
  8025fd:	c3                   	ret    

008025fe <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8025fe:	55                   	push   %ebp
  8025ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802601:	8b 45 08             	mov    0x8(%ebp),%eax
  802604:	6a 00                	push   $0x0
  802606:	6a 00                	push   $0x0
  802608:	6a 00                	push   $0x0
  80260a:	6a 00                	push   $0x0
  80260c:	50                   	push   %eax
  80260d:	6a 1e                	push   $0x1e
  80260f:	e8 8d fc ff ff       	call   8022a1 <syscall>
  802614:	83 c4 18             	add    $0x18,%esp
}
  802617:	90                   	nop
  802618:	c9                   	leave  
  802619:	c3                   	ret    

0080261a <sys_free_env>:

void
sys_free_env(int32 envId)
{
  80261a:	55                   	push   %ebp
  80261b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  80261d:	8b 45 08             	mov    0x8(%ebp),%eax
  802620:	6a 00                	push   $0x0
  802622:	6a 00                	push   $0x0
  802624:	6a 00                	push   $0x0
  802626:	6a 00                	push   $0x0
  802628:	50                   	push   %eax
  802629:	6a 1f                	push   $0x1f
  80262b:	e8 71 fc ff ff       	call   8022a1 <syscall>
  802630:	83 c4 18             	add    $0x18,%esp
}
  802633:	90                   	nop
  802634:	c9                   	leave  
  802635:	c3                   	ret    

00802636 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  802636:	55                   	push   %ebp
  802637:	89 e5                	mov    %esp,%ebp
  802639:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80263c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80263f:	8d 50 04             	lea    0x4(%eax),%edx
  802642:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802645:	6a 00                	push   $0x0
  802647:	6a 00                	push   $0x0
  802649:	6a 00                	push   $0x0
  80264b:	52                   	push   %edx
  80264c:	50                   	push   %eax
  80264d:	6a 20                	push   $0x20
  80264f:	e8 4d fc ff ff       	call   8022a1 <syscall>
  802654:	83 c4 18             	add    $0x18,%esp
	return result;
  802657:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80265a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80265d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802660:	89 01                	mov    %eax,(%ecx)
  802662:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802665:	8b 45 08             	mov    0x8(%ebp),%eax
  802668:	c9                   	leave  
  802669:	c2 04 00             	ret    $0x4

0080266c <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80266c:	55                   	push   %ebp
  80266d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80266f:	6a 00                	push   $0x0
  802671:	6a 00                	push   $0x0
  802673:	ff 75 10             	pushl  0x10(%ebp)
  802676:	ff 75 0c             	pushl  0xc(%ebp)
  802679:	ff 75 08             	pushl  0x8(%ebp)
  80267c:	6a 0f                	push   $0xf
  80267e:	e8 1e fc ff ff       	call   8022a1 <syscall>
  802683:	83 c4 18             	add    $0x18,%esp
	return ;
  802686:	90                   	nop
}
  802687:	c9                   	leave  
  802688:	c3                   	ret    

00802689 <sys_rcr2>:
uint32 sys_rcr2()
{
  802689:	55                   	push   %ebp
  80268a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80268c:	6a 00                	push   $0x0
  80268e:	6a 00                	push   $0x0
  802690:	6a 00                	push   $0x0
  802692:	6a 00                	push   $0x0
  802694:	6a 00                	push   $0x0
  802696:	6a 21                	push   $0x21
  802698:	e8 04 fc ff ff       	call   8022a1 <syscall>
  80269d:	83 c4 18             	add    $0x18,%esp
}
  8026a0:	c9                   	leave  
  8026a1:	c3                   	ret    

008026a2 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8026a2:	55                   	push   %ebp
  8026a3:	89 e5                	mov    %esp,%ebp
  8026a5:	83 ec 04             	sub    $0x4,%esp
  8026a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ab:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8026ae:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8026b2:	6a 00                	push   $0x0
  8026b4:	6a 00                	push   $0x0
  8026b6:	6a 00                	push   $0x0
  8026b8:	6a 00                	push   $0x0
  8026ba:	50                   	push   %eax
  8026bb:	6a 22                	push   $0x22
  8026bd:	e8 df fb ff ff       	call   8022a1 <syscall>
  8026c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8026c5:	90                   	nop
}
  8026c6:	c9                   	leave  
  8026c7:	c3                   	ret    

008026c8 <rsttst>:
void rsttst()
{
  8026c8:	55                   	push   %ebp
  8026c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8026cb:	6a 00                	push   $0x0
  8026cd:	6a 00                	push   $0x0
  8026cf:	6a 00                	push   $0x0
  8026d1:	6a 00                	push   $0x0
  8026d3:	6a 00                	push   $0x0
  8026d5:	6a 24                	push   $0x24
  8026d7:	e8 c5 fb ff ff       	call   8022a1 <syscall>
  8026dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8026df:	90                   	nop
}
  8026e0:	c9                   	leave  
  8026e1:	c3                   	ret    

008026e2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8026e2:	55                   	push   %ebp
  8026e3:	89 e5                	mov    %esp,%ebp
  8026e5:	83 ec 04             	sub    $0x4,%esp
  8026e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8026eb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8026ee:	8b 55 18             	mov    0x18(%ebp),%edx
  8026f1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8026f5:	52                   	push   %edx
  8026f6:	50                   	push   %eax
  8026f7:	ff 75 10             	pushl  0x10(%ebp)
  8026fa:	ff 75 0c             	pushl  0xc(%ebp)
  8026fd:	ff 75 08             	pushl  0x8(%ebp)
  802700:	6a 23                	push   $0x23
  802702:	e8 9a fb ff ff       	call   8022a1 <syscall>
  802707:	83 c4 18             	add    $0x18,%esp
	return ;
  80270a:	90                   	nop
}
  80270b:	c9                   	leave  
  80270c:	c3                   	ret    

0080270d <chktst>:
void chktst(uint32 n)
{
  80270d:	55                   	push   %ebp
  80270e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802710:	6a 00                	push   $0x0
  802712:	6a 00                	push   $0x0
  802714:	6a 00                	push   $0x0
  802716:	6a 00                	push   $0x0
  802718:	ff 75 08             	pushl  0x8(%ebp)
  80271b:	6a 25                	push   $0x25
  80271d:	e8 7f fb ff ff       	call   8022a1 <syscall>
  802722:	83 c4 18             	add    $0x18,%esp
	return ;
  802725:	90                   	nop
}
  802726:	c9                   	leave  
  802727:	c3                   	ret    

00802728 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802728:	55                   	push   %ebp
  802729:	89 e5                	mov    %esp,%ebp
  80272b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80272e:	6a 00                	push   $0x0
  802730:	6a 00                	push   $0x0
  802732:	6a 00                	push   $0x0
  802734:	6a 00                	push   $0x0
  802736:	6a 00                	push   $0x0
  802738:	6a 26                	push   $0x26
  80273a:	e8 62 fb ff ff       	call   8022a1 <syscall>
  80273f:	83 c4 18             	add    $0x18,%esp
  802742:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802745:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802749:	75 07                	jne    802752 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80274b:	b8 01 00 00 00       	mov    $0x1,%eax
  802750:	eb 05                	jmp    802757 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802752:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802757:	c9                   	leave  
  802758:	c3                   	ret    

00802759 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802759:	55                   	push   %ebp
  80275a:	89 e5                	mov    %esp,%ebp
  80275c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80275f:	6a 00                	push   $0x0
  802761:	6a 00                	push   $0x0
  802763:	6a 00                	push   $0x0
  802765:	6a 00                	push   $0x0
  802767:	6a 00                	push   $0x0
  802769:	6a 26                	push   $0x26
  80276b:	e8 31 fb ff ff       	call   8022a1 <syscall>
  802770:	83 c4 18             	add    $0x18,%esp
  802773:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802776:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80277a:	75 07                	jne    802783 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80277c:	b8 01 00 00 00       	mov    $0x1,%eax
  802781:	eb 05                	jmp    802788 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802783:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802788:	c9                   	leave  
  802789:	c3                   	ret    

0080278a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80278a:	55                   	push   %ebp
  80278b:	89 e5                	mov    %esp,%ebp
  80278d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802790:	6a 00                	push   $0x0
  802792:	6a 00                	push   $0x0
  802794:	6a 00                	push   $0x0
  802796:	6a 00                	push   $0x0
  802798:	6a 00                	push   $0x0
  80279a:	6a 26                	push   $0x26
  80279c:	e8 00 fb ff ff       	call   8022a1 <syscall>
  8027a1:	83 c4 18             	add    $0x18,%esp
  8027a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8027a7:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8027ab:	75 07                	jne    8027b4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8027ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8027b2:	eb 05                	jmp    8027b9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8027b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027b9:	c9                   	leave  
  8027ba:	c3                   	ret    

008027bb <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8027bb:	55                   	push   %ebp
  8027bc:	89 e5                	mov    %esp,%ebp
  8027be:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027c1:	6a 00                	push   $0x0
  8027c3:	6a 00                	push   $0x0
  8027c5:	6a 00                	push   $0x0
  8027c7:	6a 00                	push   $0x0
  8027c9:	6a 00                	push   $0x0
  8027cb:	6a 26                	push   $0x26
  8027cd:	e8 cf fa ff ff       	call   8022a1 <syscall>
  8027d2:	83 c4 18             	add    $0x18,%esp
  8027d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8027d8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8027dc:	75 07                	jne    8027e5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8027de:	b8 01 00 00 00       	mov    $0x1,%eax
  8027e3:	eb 05                	jmp    8027ea <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8027e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027ea:	c9                   	leave  
  8027eb:	c3                   	ret    

008027ec <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8027ec:	55                   	push   %ebp
  8027ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8027ef:	6a 00                	push   $0x0
  8027f1:	6a 00                	push   $0x0
  8027f3:	6a 00                	push   $0x0
  8027f5:	6a 00                	push   $0x0
  8027f7:	ff 75 08             	pushl  0x8(%ebp)
  8027fa:	6a 27                	push   $0x27
  8027fc:	e8 a0 fa ff ff       	call   8022a1 <syscall>
  802801:	83 c4 18             	add    $0x18,%esp
	return ;
  802804:	90                   	nop
}
  802805:	c9                   	leave  
  802806:	c3                   	ret    
  802807:	90                   	nop

00802808 <__udivdi3>:
  802808:	55                   	push   %ebp
  802809:	57                   	push   %edi
  80280a:	56                   	push   %esi
  80280b:	53                   	push   %ebx
  80280c:	83 ec 1c             	sub    $0x1c,%esp
  80280f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802813:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802817:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80281b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80281f:	89 ca                	mov    %ecx,%edx
  802821:	89 f8                	mov    %edi,%eax
  802823:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802827:	85 f6                	test   %esi,%esi
  802829:	75 2d                	jne    802858 <__udivdi3+0x50>
  80282b:	39 cf                	cmp    %ecx,%edi
  80282d:	77 65                	ja     802894 <__udivdi3+0x8c>
  80282f:	89 fd                	mov    %edi,%ebp
  802831:	85 ff                	test   %edi,%edi
  802833:	75 0b                	jne    802840 <__udivdi3+0x38>
  802835:	b8 01 00 00 00       	mov    $0x1,%eax
  80283a:	31 d2                	xor    %edx,%edx
  80283c:	f7 f7                	div    %edi
  80283e:	89 c5                	mov    %eax,%ebp
  802840:	31 d2                	xor    %edx,%edx
  802842:	89 c8                	mov    %ecx,%eax
  802844:	f7 f5                	div    %ebp
  802846:	89 c1                	mov    %eax,%ecx
  802848:	89 d8                	mov    %ebx,%eax
  80284a:	f7 f5                	div    %ebp
  80284c:	89 cf                	mov    %ecx,%edi
  80284e:	89 fa                	mov    %edi,%edx
  802850:	83 c4 1c             	add    $0x1c,%esp
  802853:	5b                   	pop    %ebx
  802854:	5e                   	pop    %esi
  802855:	5f                   	pop    %edi
  802856:	5d                   	pop    %ebp
  802857:	c3                   	ret    
  802858:	39 ce                	cmp    %ecx,%esi
  80285a:	77 28                	ja     802884 <__udivdi3+0x7c>
  80285c:	0f bd fe             	bsr    %esi,%edi
  80285f:	83 f7 1f             	xor    $0x1f,%edi
  802862:	75 40                	jne    8028a4 <__udivdi3+0x9c>
  802864:	39 ce                	cmp    %ecx,%esi
  802866:	72 0a                	jb     802872 <__udivdi3+0x6a>
  802868:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80286c:	0f 87 9e 00 00 00    	ja     802910 <__udivdi3+0x108>
  802872:	b8 01 00 00 00       	mov    $0x1,%eax
  802877:	89 fa                	mov    %edi,%edx
  802879:	83 c4 1c             	add    $0x1c,%esp
  80287c:	5b                   	pop    %ebx
  80287d:	5e                   	pop    %esi
  80287e:	5f                   	pop    %edi
  80287f:	5d                   	pop    %ebp
  802880:	c3                   	ret    
  802881:	8d 76 00             	lea    0x0(%esi),%esi
  802884:	31 ff                	xor    %edi,%edi
  802886:	31 c0                	xor    %eax,%eax
  802888:	89 fa                	mov    %edi,%edx
  80288a:	83 c4 1c             	add    $0x1c,%esp
  80288d:	5b                   	pop    %ebx
  80288e:	5e                   	pop    %esi
  80288f:	5f                   	pop    %edi
  802890:	5d                   	pop    %ebp
  802891:	c3                   	ret    
  802892:	66 90                	xchg   %ax,%ax
  802894:	89 d8                	mov    %ebx,%eax
  802896:	f7 f7                	div    %edi
  802898:	31 ff                	xor    %edi,%edi
  80289a:	89 fa                	mov    %edi,%edx
  80289c:	83 c4 1c             	add    $0x1c,%esp
  80289f:	5b                   	pop    %ebx
  8028a0:	5e                   	pop    %esi
  8028a1:	5f                   	pop    %edi
  8028a2:	5d                   	pop    %ebp
  8028a3:	c3                   	ret    
  8028a4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8028a9:	89 eb                	mov    %ebp,%ebx
  8028ab:	29 fb                	sub    %edi,%ebx
  8028ad:	89 f9                	mov    %edi,%ecx
  8028af:	d3 e6                	shl    %cl,%esi
  8028b1:	89 c5                	mov    %eax,%ebp
  8028b3:	88 d9                	mov    %bl,%cl
  8028b5:	d3 ed                	shr    %cl,%ebp
  8028b7:	89 e9                	mov    %ebp,%ecx
  8028b9:	09 f1                	or     %esi,%ecx
  8028bb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8028bf:	89 f9                	mov    %edi,%ecx
  8028c1:	d3 e0                	shl    %cl,%eax
  8028c3:	89 c5                	mov    %eax,%ebp
  8028c5:	89 d6                	mov    %edx,%esi
  8028c7:	88 d9                	mov    %bl,%cl
  8028c9:	d3 ee                	shr    %cl,%esi
  8028cb:	89 f9                	mov    %edi,%ecx
  8028cd:	d3 e2                	shl    %cl,%edx
  8028cf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8028d3:	88 d9                	mov    %bl,%cl
  8028d5:	d3 e8                	shr    %cl,%eax
  8028d7:	09 c2                	or     %eax,%edx
  8028d9:	89 d0                	mov    %edx,%eax
  8028db:	89 f2                	mov    %esi,%edx
  8028dd:	f7 74 24 0c          	divl   0xc(%esp)
  8028e1:	89 d6                	mov    %edx,%esi
  8028e3:	89 c3                	mov    %eax,%ebx
  8028e5:	f7 e5                	mul    %ebp
  8028e7:	39 d6                	cmp    %edx,%esi
  8028e9:	72 19                	jb     802904 <__udivdi3+0xfc>
  8028eb:	74 0b                	je     8028f8 <__udivdi3+0xf0>
  8028ed:	89 d8                	mov    %ebx,%eax
  8028ef:	31 ff                	xor    %edi,%edi
  8028f1:	e9 58 ff ff ff       	jmp    80284e <__udivdi3+0x46>
  8028f6:	66 90                	xchg   %ax,%ax
  8028f8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8028fc:	89 f9                	mov    %edi,%ecx
  8028fe:	d3 e2                	shl    %cl,%edx
  802900:	39 c2                	cmp    %eax,%edx
  802902:	73 e9                	jae    8028ed <__udivdi3+0xe5>
  802904:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802907:	31 ff                	xor    %edi,%edi
  802909:	e9 40 ff ff ff       	jmp    80284e <__udivdi3+0x46>
  80290e:	66 90                	xchg   %ax,%ax
  802910:	31 c0                	xor    %eax,%eax
  802912:	e9 37 ff ff ff       	jmp    80284e <__udivdi3+0x46>
  802917:	90                   	nop

00802918 <__umoddi3>:
  802918:	55                   	push   %ebp
  802919:	57                   	push   %edi
  80291a:	56                   	push   %esi
  80291b:	53                   	push   %ebx
  80291c:	83 ec 1c             	sub    $0x1c,%esp
  80291f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802923:	8b 74 24 34          	mov    0x34(%esp),%esi
  802927:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80292b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80292f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802933:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802937:	89 f3                	mov    %esi,%ebx
  802939:	89 fa                	mov    %edi,%edx
  80293b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80293f:	89 34 24             	mov    %esi,(%esp)
  802942:	85 c0                	test   %eax,%eax
  802944:	75 1a                	jne    802960 <__umoddi3+0x48>
  802946:	39 f7                	cmp    %esi,%edi
  802948:	0f 86 a2 00 00 00    	jbe    8029f0 <__umoddi3+0xd8>
  80294e:	89 c8                	mov    %ecx,%eax
  802950:	89 f2                	mov    %esi,%edx
  802952:	f7 f7                	div    %edi
  802954:	89 d0                	mov    %edx,%eax
  802956:	31 d2                	xor    %edx,%edx
  802958:	83 c4 1c             	add    $0x1c,%esp
  80295b:	5b                   	pop    %ebx
  80295c:	5e                   	pop    %esi
  80295d:	5f                   	pop    %edi
  80295e:	5d                   	pop    %ebp
  80295f:	c3                   	ret    
  802960:	39 f0                	cmp    %esi,%eax
  802962:	0f 87 ac 00 00 00    	ja     802a14 <__umoddi3+0xfc>
  802968:	0f bd e8             	bsr    %eax,%ebp
  80296b:	83 f5 1f             	xor    $0x1f,%ebp
  80296e:	0f 84 ac 00 00 00    	je     802a20 <__umoddi3+0x108>
  802974:	bf 20 00 00 00       	mov    $0x20,%edi
  802979:	29 ef                	sub    %ebp,%edi
  80297b:	89 fe                	mov    %edi,%esi
  80297d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802981:	89 e9                	mov    %ebp,%ecx
  802983:	d3 e0                	shl    %cl,%eax
  802985:	89 d7                	mov    %edx,%edi
  802987:	89 f1                	mov    %esi,%ecx
  802989:	d3 ef                	shr    %cl,%edi
  80298b:	09 c7                	or     %eax,%edi
  80298d:	89 e9                	mov    %ebp,%ecx
  80298f:	d3 e2                	shl    %cl,%edx
  802991:	89 14 24             	mov    %edx,(%esp)
  802994:	89 d8                	mov    %ebx,%eax
  802996:	d3 e0                	shl    %cl,%eax
  802998:	89 c2                	mov    %eax,%edx
  80299a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80299e:	d3 e0                	shl    %cl,%eax
  8029a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029a4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8029a8:	89 f1                	mov    %esi,%ecx
  8029aa:	d3 e8                	shr    %cl,%eax
  8029ac:	09 d0                	or     %edx,%eax
  8029ae:	d3 eb                	shr    %cl,%ebx
  8029b0:	89 da                	mov    %ebx,%edx
  8029b2:	f7 f7                	div    %edi
  8029b4:	89 d3                	mov    %edx,%ebx
  8029b6:	f7 24 24             	mull   (%esp)
  8029b9:	89 c6                	mov    %eax,%esi
  8029bb:	89 d1                	mov    %edx,%ecx
  8029bd:	39 d3                	cmp    %edx,%ebx
  8029bf:	0f 82 87 00 00 00    	jb     802a4c <__umoddi3+0x134>
  8029c5:	0f 84 91 00 00 00    	je     802a5c <__umoddi3+0x144>
  8029cb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8029cf:	29 f2                	sub    %esi,%edx
  8029d1:	19 cb                	sbb    %ecx,%ebx
  8029d3:	89 d8                	mov    %ebx,%eax
  8029d5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8029d9:	d3 e0                	shl    %cl,%eax
  8029db:	89 e9                	mov    %ebp,%ecx
  8029dd:	d3 ea                	shr    %cl,%edx
  8029df:	09 d0                	or     %edx,%eax
  8029e1:	89 e9                	mov    %ebp,%ecx
  8029e3:	d3 eb                	shr    %cl,%ebx
  8029e5:	89 da                	mov    %ebx,%edx
  8029e7:	83 c4 1c             	add    $0x1c,%esp
  8029ea:	5b                   	pop    %ebx
  8029eb:	5e                   	pop    %esi
  8029ec:	5f                   	pop    %edi
  8029ed:	5d                   	pop    %ebp
  8029ee:	c3                   	ret    
  8029ef:	90                   	nop
  8029f0:	89 fd                	mov    %edi,%ebp
  8029f2:	85 ff                	test   %edi,%edi
  8029f4:	75 0b                	jne    802a01 <__umoddi3+0xe9>
  8029f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8029fb:	31 d2                	xor    %edx,%edx
  8029fd:	f7 f7                	div    %edi
  8029ff:	89 c5                	mov    %eax,%ebp
  802a01:	89 f0                	mov    %esi,%eax
  802a03:	31 d2                	xor    %edx,%edx
  802a05:	f7 f5                	div    %ebp
  802a07:	89 c8                	mov    %ecx,%eax
  802a09:	f7 f5                	div    %ebp
  802a0b:	89 d0                	mov    %edx,%eax
  802a0d:	e9 44 ff ff ff       	jmp    802956 <__umoddi3+0x3e>
  802a12:	66 90                	xchg   %ax,%ax
  802a14:	89 c8                	mov    %ecx,%eax
  802a16:	89 f2                	mov    %esi,%edx
  802a18:	83 c4 1c             	add    $0x1c,%esp
  802a1b:	5b                   	pop    %ebx
  802a1c:	5e                   	pop    %esi
  802a1d:	5f                   	pop    %edi
  802a1e:	5d                   	pop    %ebp
  802a1f:	c3                   	ret    
  802a20:	3b 04 24             	cmp    (%esp),%eax
  802a23:	72 06                	jb     802a2b <__umoddi3+0x113>
  802a25:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802a29:	77 0f                	ja     802a3a <__umoddi3+0x122>
  802a2b:	89 f2                	mov    %esi,%edx
  802a2d:	29 f9                	sub    %edi,%ecx
  802a2f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802a33:	89 14 24             	mov    %edx,(%esp)
  802a36:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802a3a:	8b 44 24 04          	mov    0x4(%esp),%eax
  802a3e:	8b 14 24             	mov    (%esp),%edx
  802a41:	83 c4 1c             	add    $0x1c,%esp
  802a44:	5b                   	pop    %ebx
  802a45:	5e                   	pop    %esi
  802a46:	5f                   	pop    %edi
  802a47:	5d                   	pop    %ebp
  802a48:	c3                   	ret    
  802a49:	8d 76 00             	lea    0x0(%esi),%esi
  802a4c:	2b 04 24             	sub    (%esp),%eax
  802a4f:	19 fa                	sbb    %edi,%edx
  802a51:	89 d1                	mov    %edx,%ecx
  802a53:	89 c6                	mov    %eax,%esi
  802a55:	e9 71 ff ff ff       	jmp    8029cb <__umoddi3+0xb3>
  802a5a:	66 90                	xchg   %ax,%ax
  802a5c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802a60:	72 ea                	jb     802a4c <__umoddi3+0x134>
  802a62:	89 d9                	mov    %ebx,%ecx
  802a64:	e9 62 ff ff ff       	jmp    8029cb <__umoddi3+0xb3>
