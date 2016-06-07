
obj/user/quicksort_heap:     file format elf32-i386


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
  800031:	e8 ee 05 00 00       	call   800624 <libmain>
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
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	char Line[255] ;
	char Chose ;
	do
	{
		//2012: lock the interrupt
		sys_disable_interrupt();
  800041:	e8 bf 23 00 00       	call   802405 <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 20 2a 80 00       	push   $0x802a20
  80004e:	e8 bd 07 00 00       	call   800810 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 22 2a 80 00       	push   $0x802a22
  80005e:	e8 ad 07 00 00       	call   800810 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   QUICK SORT   !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 3b 2a 80 00       	push   $0x802a3b
  80006e:	e8 9d 07 00 00       	call   800810 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 22 2a 80 00       	push   $0x802a22
  80007e:	e8 8d 07 00 00       	call   800810 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 20 2a 80 00       	push   $0x802a20
  80008e:	e8 7d 07 00 00       	call   800810 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 54 2a 80 00       	push   $0x802a54
  8000a5:	e8 e1 0d 00 00       	call   800e8b <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 31 13 00 00       	call   8013f1 <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 c4 16 00 00       	call   801799 <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 74 2a 80 00       	push   $0x802a74
  8000e3:	e8 28 07 00 00       	call   800810 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 96 2a 80 00       	push   $0x802a96
  8000f3:	e8 18 07 00 00       	call   800810 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 a4 2a 80 00       	push   $0x802aa4
  800103:	e8 08 07 00 00       	call   800810 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 b3 2a 80 00       	push   $0x802ab3
  800113:	e8 f8 06 00 00       	call   800810 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 c3 2a 80 00       	push   $0x802ac3
  800123:	e8 e8 06 00 00       	call   800810 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  80012b:	e8 9c 04 00 00       	call   8005cc <getchar>
  800130:	88 45 ef             	mov    %al,-0x11(%ebp)
		cputchar(Chose);
  800133:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 44 04 00 00       	call   800584 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 37 04 00 00       	call   800584 <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp

		//2012: lock the interrupt
		sys_enable_interrupt();
  800150:	e8 ca 22 00 00       	call   80241f <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  800155:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  800159:	83 f8 62             	cmp    $0x62,%eax
  80015c:	74 1d                	je     80017b <_main+0x143>
  80015e:	83 f8 63             	cmp    $0x63,%eax
  800161:	74 2b                	je     80018e <_main+0x156>
  800163:	83 f8 61             	cmp    $0x61,%eax
  800166:	75 39                	jne    8001a1 <_main+0x169>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  800168:	83 ec 08             	sub    $0x8,%esp
  80016b:	ff 75 f4             	pushl  -0xc(%ebp)
  80016e:	ff 75 f0             	pushl  -0x10(%ebp)
  800171:	e8 d6 02 00 00       	call   80044c <InitializeAscending>
  800176:	83 c4 10             	add    $0x10,%esp
			break ;
  800179:	eb 37                	jmp    8001b2 <_main+0x17a>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80017b:	83 ec 08             	sub    $0x8,%esp
  80017e:	ff 75 f4             	pushl  -0xc(%ebp)
  800181:	ff 75 f0             	pushl  -0x10(%ebp)
  800184:	e8 f4 02 00 00       	call   80047d <InitializeDescending>
  800189:	83 c4 10             	add    $0x10,%esp
			break ;
  80018c:	eb 24                	jmp    8001b2 <_main+0x17a>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  80018e:	83 ec 08             	sub    $0x8,%esp
  800191:	ff 75 f4             	pushl  -0xc(%ebp)
  800194:	ff 75 f0             	pushl  -0x10(%ebp)
  800197:	e8 16 03 00 00       	call   8004b2 <InitializeSemiRandom>
  80019c:	83 c4 10             	add    $0x10,%esp
			break ;
  80019f:	eb 11                	jmp    8001b2 <_main+0x17a>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8001a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001aa:	e8 03 03 00 00       	call   8004b2 <InitializeSemiRandom>
  8001af:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001b2:	83 ec 08             	sub    $0x8,%esp
  8001b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8001b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8001bb:	e8 d1 00 00 00       	call   800291 <QuickSort>
  8001c0:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001c3:	e8 3d 22 00 00       	call   802405 <sys_disable_interrupt>
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001c8:	83 ec 0c             	sub    $0xc,%esp
  8001cb:	68 cc 2a 80 00       	push   $0x802acc
  8001d0:	e8 3b 06 00 00       	call   800810 <cprintf>
  8001d5:	83 c4 10             	add    $0x10,%esp
		//		PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001d8:	e8 42 22 00 00       	call   80241f <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001dd:	83 ec 08             	sub    $0x8,%esp
  8001e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8001e3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001e6:	e8 b7 01 00 00       	call   8003a2 <CheckSorted>
  8001eb:	83 c4 10             	add    $0x10,%esp
  8001ee:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001f1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8001f5:	75 14                	jne    80020b <_main+0x1d3>
  8001f7:	83 ec 04             	sub    $0x4,%esp
  8001fa:	68 00 2b 80 00       	push   $0x802b00
  8001ff:	6a 46                	push   $0x46
  800201:	68 22 2b 80 00       	push   $0x802b22
  800206:	e8 da 04 00 00       	call   8006e5 <_panic>
		else
		{ 
			sys_disable_interrupt();
  80020b:	e8 f5 21 00 00       	call   802405 <sys_disable_interrupt>
			cprintf("\n===============================================\n") ;
  800210:	83 ec 0c             	sub    $0xc,%esp
  800213:	68 38 2b 80 00       	push   $0x802b38
  800218:	e8 f3 05 00 00       	call   800810 <cprintf>
  80021d:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800220:	83 ec 0c             	sub    $0xc,%esp
  800223:	68 6c 2b 80 00       	push   $0x802b6c
  800228:	e8 e3 05 00 00       	call   800810 <cprintf>
  80022d:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800230:	83 ec 0c             	sub    $0xc,%esp
  800233:	68 a0 2b 80 00       	push   $0x802ba0
  800238:	e8 d3 05 00 00       	call   800810 <cprintf>
  80023d:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800240:	e8 da 21 00 00       	call   80241f <sys_enable_interrupt>
		}

		sys_disable_interrupt();
  800245:	e8 bb 21 00 00       	call   802405 <sys_disable_interrupt>
		cprintf("Do you want to repeat (y/n): ") ;
  80024a:	83 ec 0c             	sub    $0xc,%esp
  80024d:	68 d2 2b 80 00       	push   $0x802bd2
  800252:	e8 b9 05 00 00       	call   800810 <cprintf>
  800257:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  80025a:	e8 6d 03 00 00       	call   8005cc <getchar>
  80025f:	88 45 ef             	mov    %al,-0x11(%ebp)
		cputchar(Chose);
  800262:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  800266:	83 ec 0c             	sub    $0xc,%esp
  800269:	50                   	push   %eax
  80026a:	e8 15 03 00 00       	call   800584 <cputchar>
  80026f:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	6a 0a                	push   $0xa
  800277:	e8 08 03 00 00       	call   800584 <cputchar>
  80027c:	83 c4 10             	add    $0x10,%esp
		sys_enable_interrupt();
  80027f:	e8 9b 21 00 00       	call   80241f <sys_enable_interrupt>

	} while (Chose == 'y');
  800284:	80 7d ef 79          	cmpb   $0x79,-0x11(%ebp)
  800288:	0f 84 b3 fd ff ff    	je     800041 <_main+0x9>

}
  80028e:	90                   	nop
  80028f:	c9                   	leave  
  800290:	c3                   	ret    

00800291 <QuickSort>:

///Quick sort 
void QuickSort(int *Elements, int NumOfElements)
{
  800291:	55                   	push   %ebp
  800292:	89 e5                	mov    %esp,%ebp
  800294:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  800297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029a:	48                   	dec    %eax
  80029b:	50                   	push   %eax
  80029c:	6a 00                	push   $0x0
  80029e:	ff 75 0c             	pushl  0xc(%ebp)
  8002a1:	ff 75 08             	pushl  0x8(%ebp)
  8002a4:	e8 06 00 00 00       	call   8002af <QSort>
  8002a9:	83 c4 10             	add    $0x10,%esp
}
  8002ac:	90                   	nop
  8002ad:	c9                   	leave  
  8002ae:	c3                   	ret    

008002af <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002af:	55                   	push   %ebp
  8002b0:	89 e5                	mov    %esp,%ebp
  8002b2:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b8:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002bb:	0f 8d de 00 00 00    	jge    80039f <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c4:	40                   	inc    %eax
  8002c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8002cb:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002ce:	e9 80 00 00 00       	jmp    800353 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  8002d3:	ff 45 f4             	incl   -0xc(%ebp)
  8002d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002d9:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002dc:	7f 2b                	jg     800309 <QSort+0x5a>
  8002de:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002eb:	01 d0                	add    %edx,%eax
  8002ed:	8b 10                	mov    (%eax),%edx
  8002ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002f2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fc:	01 c8                	add    %ecx,%eax
  8002fe:	8b 00                	mov    (%eax),%eax
  800300:	39 c2                	cmp    %eax,%edx
  800302:	7d cf                	jge    8002d3 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800304:	eb 03                	jmp    800309 <QSort+0x5a>
  800306:	ff 4d f0             	decl   -0x10(%ebp)
  800309:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80030c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80030f:	7e 26                	jle    800337 <QSort+0x88>
  800311:	8b 45 10             	mov    0x10(%ebp),%eax
  800314:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80031b:	8b 45 08             	mov    0x8(%ebp),%eax
  80031e:	01 d0                	add    %edx,%eax
  800320:	8b 10                	mov    (%eax),%edx
  800322:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800325:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80032c:	8b 45 08             	mov    0x8(%ebp),%eax
  80032f:	01 c8                	add    %ecx,%eax
  800331:	8b 00                	mov    (%eax),%eax
  800333:	39 c2                	cmp    %eax,%edx
  800335:	7e cf                	jle    800306 <QSort+0x57>

		if (i <= j)
  800337:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80033a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80033d:	7f 14                	jg     800353 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  80033f:	83 ec 04             	sub    $0x4,%esp
  800342:	ff 75 f0             	pushl  -0x10(%ebp)
  800345:	ff 75 f4             	pushl  -0xc(%ebp)
  800348:	ff 75 08             	pushl  0x8(%ebp)
  80034b:	e8 a9 00 00 00       	call   8003f9 <Swap>
  800350:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800353:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800356:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800359:	0f 8e 77 ff ff ff    	jle    8002d6 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	ff 75 f0             	pushl  -0x10(%ebp)
  800365:	ff 75 10             	pushl  0x10(%ebp)
  800368:	ff 75 08             	pushl  0x8(%ebp)
  80036b:	e8 89 00 00 00       	call   8003f9 <Swap>
  800370:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800373:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800376:	48                   	dec    %eax
  800377:	50                   	push   %eax
  800378:	ff 75 10             	pushl  0x10(%ebp)
  80037b:	ff 75 0c             	pushl  0xc(%ebp)
  80037e:	ff 75 08             	pushl  0x8(%ebp)
  800381:	e8 29 ff ff ff       	call   8002af <QSort>
  800386:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  800389:	ff 75 14             	pushl  0x14(%ebp)
  80038c:	ff 75 f4             	pushl  -0xc(%ebp)
  80038f:	ff 75 0c             	pushl  0xc(%ebp)
  800392:	ff 75 08             	pushl  0x8(%ebp)
  800395:	e8 15 ff ff ff       	call   8002af <QSort>
  80039a:	83 c4 10             	add    $0x10,%esp
  80039d:	eb 01                	jmp    8003a0 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  80039f:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003a0:	c9                   	leave  
  8003a1:	c3                   	ret    

008003a2 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003a2:	55                   	push   %ebp
  8003a3:	89 e5                	mov    %esp,%ebp
  8003a5:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003a8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003af:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003b6:	eb 33                	jmp    8003eb <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c5:	01 d0                	add    %edx,%eax
  8003c7:	8b 10                	mov    (%eax),%edx
  8003c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003cc:	40                   	inc    %eax
  8003cd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d7:	01 c8                	add    %ecx,%eax
  8003d9:	8b 00                	mov    (%eax),%eax
  8003db:	39 c2                	cmp    %eax,%edx
  8003dd:	7e 09                	jle    8003e8 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8003e6:	eb 0c                	jmp    8003f4 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003e8:	ff 45 f8             	incl   -0x8(%ebp)
  8003eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ee:	48                   	dec    %eax
  8003ef:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8003f2:	7f c4                	jg     8003b8 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8003f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8003f7:	c9                   	leave  
  8003f8:	c3                   	ret    

008003f9 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  8003f9:	55                   	push   %ebp
  8003fa:	89 e5                	mov    %esp,%ebp
  8003fc:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8003ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800402:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800409:	8b 45 08             	mov    0x8(%ebp),%eax
  80040c:	01 d0                	add    %edx,%eax
  80040e:	8b 00                	mov    (%eax),%eax
  800410:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800413:	8b 45 0c             	mov    0xc(%ebp),%eax
  800416:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80041d:	8b 45 08             	mov    0x8(%ebp),%eax
  800420:	01 c2                	add    %eax,%edx
  800422:	8b 45 10             	mov    0x10(%ebp),%eax
  800425:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80042c:	8b 45 08             	mov    0x8(%ebp),%eax
  80042f:	01 c8                	add    %ecx,%eax
  800431:	8b 00                	mov    (%eax),%eax
  800433:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800435:	8b 45 10             	mov    0x10(%ebp),%eax
  800438:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043f:	8b 45 08             	mov    0x8(%ebp),%eax
  800442:	01 c2                	add    %eax,%edx
  800444:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800447:	89 02                	mov    %eax,(%edx)
}
  800449:	90                   	nop
  80044a:	c9                   	leave  
  80044b:	c3                   	ret    

0080044c <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80044c:	55                   	push   %ebp
  80044d:	89 e5                	mov    %esp,%ebp
  80044f:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800452:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800459:	eb 17                	jmp    800472 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80045b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80045e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800465:	8b 45 08             	mov    0x8(%ebp),%eax
  800468:	01 c2                	add    %eax,%edx
  80046a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80046d:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80046f:	ff 45 fc             	incl   -0x4(%ebp)
  800472:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800475:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800478:	7c e1                	jl     80045b <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80047a:	90                   	nop
  80047b:	c9                   	leave  
  80047c:	c3                   	ret    

0080047d <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80047d:	55                   	push   %ebp
  80047e:	89 e5                	mov    %esp,%ebp
  800480:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800483:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80048a:	eb 1b                	jmp    8004a7 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  80048c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	01 c2                	add    %eax,%edx
  80049b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049e:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004a1:	48                   	dec    %eax
  8004a2:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004a4:	ff 45 fc             	incl   -0x4(%ebp)
  8004a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004aa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004ad:	7c dd                	jl     80048c <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004af:	90                   	nop
  8004b0:	c9                   	leave  
  8004b1:	c3                   	ret    

008004b2 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004b2:	55                   	push   %ebp
  8004b3:	89 e5                	mov    %esp,%ebp
  8004b5:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004bb:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004c0:	f7 e9                	imul   %ecx
  8004c2:	c1 f9 1f             	sar    $0x1f,%ecx
  8004c5:	89 d0                	mov    %edx,%eax
  8004c7:	29 c8                	sub    %ecx,%eax
  8004c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8004cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004d3:	eb 1e                	jmp    8004f3 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8004d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004df:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e2:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8004e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004e8:	99                   	cltd   
  8004e9:	f7 7d f8             	idivl  -0x8(%ebp)
  8004ec:	89 d0                	mov    %edx,%eax
  8004ee:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004f0:	ff 45 fc             	incl   -0x4(%ebp)
  8004f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004f6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004f9:	7c da                	jl     8004d5 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  8004fb:	90                   	nop
  8004fc:	c9                   	leave  
  8004fd:	c3                   	ret    

008004fe <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  8004fe:	55                   	push   %ebp
  8004ff:	89 e5                	mov    %esp,%ebp
  800501:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800504:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80050b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800512:	eb 42                	jmp    800556 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800517:	99                   	cltd   
  800518:	f7 7d f0             	idivl  -0x10(%ebp)
  80051b:	89 d0                	mov    %edx,%eax
  80051d:	85 c0                	test   %eax,%eax
  80051f:	75 10                	jne    800531 <PrintElements+0x33>
			cprintf("\n");
  800521:	83 ec 0c             	sub    $0xc,%esp
  800524:	68 20 2a 80 00       	push   $0x802a20
  800529:	e8 e2 02 00 00       	call   800810 <cprintf>
  80052e:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800534:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	01 d0                	add    %edx,%eax
  800540:	8b 00                	mov    (%eax),%eax
  800542:	83 ec 08             	sub    $0x8,%esp
  800545:	50                   	push   %eax
  800546:	68 f0 2b 80 00       	push   $0x802bf0
  80054b:	e8 c0 02 00 00       	call   800810 <cprintf>
  800550:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800553:	ff 45 f4             	incl   -0xc(%ebp)
  800556:	8b 45 0c             	mov    0xc(%ebp),%eax
  800559:	48                   	dec    %eax
  80055a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80055d:	7f b5                	jg     800514 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80055f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800562:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800569:	8b 45 08             	mov    0x8(%ebp),%eax
  80056c:	01 d0                	add    %edx,%eax
  80056e:	8b 00                	mov    (%eax),%eax
  800570:	83 ec 08             	sub    $0x8,%esp
  800573:	50                   	push   %eax
  800574:	68 f5 2b 80 00       	push   $0x802bf5
  800579:	e8 92 02 00 00       	call   800810 <cprintf>
  80057e:	83 c4 10             	add    $0x10,%esp

}
  800581:	90                   	nop
  800582:	c9                   	leave  
  800583:	c3                   	ret    

00800584 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800584:	55                   	push   %ebp
  800585:	89 e5                	mov    %esp,%ebp
  800587:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80058a:	8b 45 08             	mov    0x8(%ebp),%eax
  80058d:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800590:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800594:	83 ec 0c             	sub    $0xc,%esp
  800597:	50                   	push   %eax
  800598:	e8 9c 1e 00 00       	call   802439 <sys_cputc>
  80059d:	83 c4 10             	add    $0x10,%esp
}
  8005a0:	90                   	nop
  8005a1:	c9                   	leave  
  8005a2:	c3                   	ret    

008005a3 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8005a3:	55                   	push   %ebp
  8005a4:	89 e5                	mov    %esp,%ebp
  8005a6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005a9:	e8 57 1e 00 00       	call   802405 <sys_disable_interrupt>
	char c = ch;
  8005ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b1:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005b4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005b8:	83 ec 0c             	sub    $0xc,%esp
  8005bb:	50                   	push   %eax
  8005bc:	e8 78 1e 00 00       	call   802439 <sys_cputc>
  8005c1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005c4:	e8 56 1e 00 00       	call   80241f <sys_enable_interrupt>
}
  8005c9:	90                   	nop
  8005ca:	c9                   	leave  
  8005cb:	c3                   	ret    

008005cc <getchar>:

int
getchar(void)
{
  8005cc:	55                   	push   %ebp
  8005cd:	89 e5                	mov    %esp,%ebp
  8005cf:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8005d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005d9:	eb 08                	jmp    8005e3 <getchar+0x17>
	{
		c = sys_cgetc();
  8005db:	e8 a3 1c 00 00       	call   802283 <sys_cgetc>
  8005e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  8005e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8005e7:	74 f2                	je     8005db <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  8005e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005ec:	c9                   	leave  
  8005ed:	c3                   	ret    

008005ee <atomic_getchar>:

int
atomic_getchar(void)
{
  8005ee:	55                   	push   %ebp
  8005ef:	89 e5                	mov    %esp,%ebp
  8005f1:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005f4:	e8 0c 1e 00 00       	call   802405 <sys_disable_interrupt>
	int c=0;
  8005f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800600:	eb 08                	jmp    80060a <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800602:	e8 7c 1c 00 00       	call   802283 <sys_cgetc>
  800607:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80060a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80060e:	74 f2                	je     800602 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800610:	e8 0a 1e 00 00       	call   80241f <sys_enable_interrupt>
	return c;
  800615:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800618:	c9                   	leave  
  800619:	c3                   	ret    

0080061a <iscons>:

int iscons(int fdnum)
{
  80061a:	55                   	push   %ebp
  80061b:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80061d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800622:	5d                   	pop    %ebp
  800623:	c3                   	ret    

00800624 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800624:	55                   	push   %ebp
  800625:	89 e5                	mov    %esp,%ebp
  800627:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80062a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80062e:	7e 0a                	jle    80063a <libmain+0x16>
		binaryname = argv[0];
  800630:	8b 45 0c             	mov    0xc(%ebp),%eax
  800633:	8b 00                	mov    (%eax),%eax
  800635:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80063a:	83 ec 08             	sub    $0x8,%esp
  80063d:	ff 75 0c             	pushl  0xc(%ebp)
  800640:	ff 75 08             	pushl  0x8(%ebp)
  800643:	e8 f0 f9 ff ff       	call   800038 <_main>
  800648:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  80064b:	e8 67 1c 00 00       	call   8022b7 <sys_getenvid>
  800650:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  800653:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800656:	89 d0                	mov    %edx,%eax
  800658:	c1 e0 03             	shl    $0x3,%eax
  80065b:	01 d0                	add    %edx,%eax
  80065d:	01 c0                	add    %eax,%eax
  80065f:	01 d0                	add    %edx,%eax
  800661:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800668:	01 d0                	add    %edx,%eax
  80066a:	c1 e0 03             	shl    $0x3,%eax
  80066d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800672:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  800675:	e8 8b 1d 00 00       	call   802405 <sys_disable_interrupt>
		cprintf("**************************************\n");
  80067a:	83 ec 0c             	sub    $0xc,%esp
  80067d:	68 14 2c 80 00       	push   $0x802c14
  800682:	e8 89 01 00 00       	call   800810 <cprintf>
  800687:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  80068a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80068d:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  800693:	83 ec 08             	sub    $0x8,%esp
  800696:	50                   	push   %eax
  800697:	68 3c 2c 80 00       	push   $0x802c3c
  80069c:	e8 6f 01 00 00       	call   800810 <cprintf>
  8006a1:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8006a4:	83 ec 0c             	sub    $0xc,%esp
  8006a7:	68 14 2c 80 00       	push   $0x802c14
  8006ac:	e8 5f 01 00 00       	call   800810 <cprintf>
  8006b1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006b4:	e8 66 1d 00 00       	call   80241f <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006b9:	e8 19 00 00 00       	call   8006d7 <exit>
}
  8006be:	90                   	nop
  8006bf:	c9                   	leave  
  8006c0:	c3                   	ret    

008006c1 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006c1:	55                   	push   %ebp
  8006c2:	89 e5                	mov    %esp,%ebp
  8006c4:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8006c7:	83 ec 0c             	sub    $0xc,%esp
  8006ca:	6a 00                	push   $0x0
  8006cc:	e8 cb 1b 00 00       	call   80229c <sys_env_destroy>
  8006d1:	83 c4 10             	add    $0x10,%esp
}
  8006d4:	90                   	nop
  8006d5:	c9                   	leave  
  8006d6:	c3                   	ret    

008006d7 <exit>:

void
exit(void)
{
  8006d7:	55                   	push   %ebp
  8006d8:	89 e5                	mov    %esp,%ebp
  8006da:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8006dd:	e8 ee 1b 00 00       	call   8022d0 <sys_env_exit>
}
  8006e2:	90                   	nop
  8006e3:	c9                   	leave  
  8006e4:	c3                   	ret    

008006e5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006e5:	55                   	push   %ebp
  8006e6:	89 e5                	mov    %esp,%ebp
  8006e8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8006eb:	8d 45 10             	lea    0x10(%ebp),%eax
  8006ee:	83 c0 04             	add    $0x4,%eax
  8006f1:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  8006f4:	a1 70 40 98 00       	mov    0x984070,%eax
  8006f9:	85 c0                	test   %eax,%eax
  8006fb:	74 16                	je     800713 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006fd:	a1 70 40 98 00       	mov    0x984070,%eax
  800702:	83 ec 08             	sub    $0x8,%esp
  800705:	50                   	push   %eax
  800706:	68 55 2c 80 00       	push   $0x802c55
  80070b:	e8 00 01 00 00       	call   800810 <cprintf>
  800710:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800713:	a1 00 40 80 00       	mov    0x804000,%eax
  800718:	ff 75 0c             	pushl  0xc(%ebp)
  80071b:	ff 75 08             	pushl  0x8(%ebp)
  80071e:	50                   	push   %eax
  80071f:	68 5a 2c 80 00       	push   $0x802c5a
  800724:	e8 e7 00 00 00       	call   800810 <cprintf>
  800729:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80072c:	8b 45 10             	mov    0x10(%ebp),%eax
  80072f:	83 ec 08             	sub    $0x8,%esp
  800732:	ff 75 f4             	pushl  -0xc(%ebp)
  800735:	50                   	push   %eax
  800736:	e8 7a 00 00 00       	call   8007b5 <vcprintf>
  80073b:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  80073e:	83 ec 0c             	sub    $0xc,%esp
  800741:	68 76 2c 80 00       	push   $0x802c76
  800746:	e8 c5 00 00 00       	call   800810 <cprintf>
  80074b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80074e:	e8 84 ff ff ff       	call   8006d7 <exit>

	// should not return here
	while (1) ;
  800753:	eb fe                	jmp    800753 <_panic+0x6e>

00800755 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800755:	55                   	push   %ebp
  800756:	89 e5                	mov    %esp,%ebp
  800758:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80075b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80075e:	8b 00                	mov    (%eax),%eax
  800760:	8d 48 01             	lea    0x1(%eax),%ecx
  800763:	8b 55 0c             	mov    0xc(%ebp),%edx
  800766:	89 0a                	mov    %ecx,(%edx)
  800768:	8b 55 08             	mov    0x8(%ebp),%edx
  80076b:	88 d1                	mov    %dl,%cl
  80076d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800770:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800774:	8b 45 0c             	mov    0xc(%ebp),%eax
  800777:	8b 00                	mov    (%eax),%eax
  800779:	3d ff 00 00 00       	cmp    $0xff,%eax
  80077e:	75 23                	jne    8007a3 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  800780:	8b 45 0c             	mov    0xc(%ebp),%eax
  800783:	8b 00                	mov    (%eax),%eax
  800785:	89 c2                	mov    %eax,%edx
  800787:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078a:	83 c0 08             	add    $0x8,%eax
  80078d:	83 ec 08             	sub    $0x8,%esp
  800790:	52                   	push   %edx
  800791:	50                   	push   %eax
  800792:	e8 cf 1a 00 00       	call   802266 <sys_cputs>
  800797:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80079a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80079d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8007a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a6:	8b 40 04             	mov    0x4(%eax),%eax
  8007a9:	8d 50 01             	lea    0x1(%eax),%edx
  8007ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007af:	89 50 04             	mov    %edx,0x4(%eax)
}
  8007b2:	90                   	nop
  8007b3:	c9                   	leave  
  8007b4:	c3                   	ret    

008007b5 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8007b5:	55                   	push   %ebp
  8007b6:	89 e5                	mov    %esp,%ebp
  8007b8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8007be:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007c5:	00 00 00 
	b.cnt = 0;
  8007c8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007cf:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007d2:	ff 75 0c             	pushl  0xc(%ebp)
  8007d5:	ff 75 08             	pushl  0x8(%ebp)
  8007d8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007de:	50                   	push   %eax
  8007df:	68 55 07 80 00       	push   $0x800755
  8007e4:	e8 fa 01 00 00       	call   8009e3 <vprintfmt>
  8007e9:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  8007ec:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8007f2:	83 ec 08             	sub    $0x8,%esp
  8007f5:	50                   	push   %eax
  8007f6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007fc:	83 c0 08             	add    $0x8,%eax
  8007ff:	50                   	push   %eax
  800800:	e8 61 1a 00 00       	call   802266 <sys_cputs>
  800805:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  800808:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80080e:	c9                   	leave  
  80080f:	c3                   	ret    

00800810 <cprintf>:

int cprintf(const char *fmt, ...) {
  800810:	55                   	push   %ebp
  800811:	89 e5                	mov    %esp,%ebp
  800813:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800816:	8d 45 0c             	lea    0xc(%ebp),%eax
  800819:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80081c:	8b 45 08             	mov    0x8(%ebp),%eax
  80081f:	83 ec 08             	sub    $0x8,%esp
  800822:	ff 75 f4             	pushl  -0xc(%ebp)
  800825:	50                   	push   %eax
  800826:	e8 8a ff ff ff       	call   8007b5 <vcprintf>
  80082b:	83 c4 10             	add    $0x10,%esp
  80082e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800831:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800834:	c9                   	leave  
  800835:	c3                   	ret    

00800836 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800836:	55                   	push   %ebp
  800837:	89 e5                	mov    %esp,%ebp
  800839:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80083c:	e8 c4 1b 00 00       	call   802405 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800841:	8d 45 0c             	lea    0xc(%ebp),%eax
  800844:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800847:	8b 45 08             	mov    0x8(%ebp),%eax
  80084a:	83 ec 08             	sub    $0x8,%esp
  80084d:	ff 75 f4             	pushl  -0xc(%ebp)
  800850:	50                   	push   %eax
  800851:	e8 5f ff ff ff       	call   8007b5 <vcprintf>
  800856:	83 c4 10             	add    $0x10,%esp
  800859:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80085c:	e8 be 1b 00 00       	call   80241f <sys_enable_interrupt>
	return cnt;
  800861:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800864:	c9                   	leave  
  800865:	c3                   	ret    

00800866 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800866:	55                   	push   %ebp
  800867:	89 e5                	mov    %esp,%ebp
  800869:	53                   	push   %ebx
  80086a:	83 ec 14             	sub    $0x14,%esp
  80086d:	8b 45 10             	mov    0x10(%ebp),%eax
  800870:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800879:	8b 45 18             	mov    0x18(%ebp),%eax
  80087c:	ba 00 00 00 00       	mov    $0x0,%edx
  800881:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800884:	77 55                	ja     8008db <printnum+0x75>
  800886:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800889:	72 05                	jb     800890 <printnum+0x2a>
  80088b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80088e:	77 4b                	ja     8008db <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800890:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800893:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800896:	8b 45 18             	mov    0x18(%ebp),%eax
  800899:	ba 00 00 00 00       	mov    $0x0,%edx
  80089e:	52                   	push   %edx
  80089f:	50                   	push   %eax
  8008a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8008a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8008a6:	e8 f9 1e 00 00       	call   8027a4 <__udivdi3>
  8008ab:	83 c4 10             	add    $0x10,%esp
  8008ae:	83 ec 04             	sub    $0x4,%esp
  8008b1:	ff 75 20             	pushl  0x20(%ebp)
  8008b4:	53                   	push   %ebx
  8008b5:	ff 75 18             	pushl  0x18(%ebp)
  8008b8:	52                   	push   %edx
  8008b9:	50                   	push   %eax
  8008ba:	ff 75 0c             	pushl  0xc(%ebp)
  8008bd:	ff 75 08             	pushl  0x8(%ebp)
  8008c0:	e8 a1 ff ff ff       	call   800866 <printnum>
  8008c5:	83 c4 20             	add    $0x20,%esp
  8008c8:	eb 1a                	jmp    8008e4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008ca:	83 ec 08             	sub    $0x8,%esp
  8008cd:	ff 75 0c             	pushl  0xc(%ebp)
  8008d0:	ff 75 20             	pushl  0x20(%ebp)
  8008d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d6:	ff d0                	call   *%eax
  8008d8:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008db:	ff 4d 1c             	decl   0x1c(%ebp)
  8008de:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008e2:	7f e6                	jg     8008ca <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008e4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008e7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008f2:	53                   	push   %ebx
  8008f3:	51                   	push   %ecx
  8008f4:	52                   	push   %edx
  8008f5:	50                   	push   %eax
  8008f6:	e8 b9 1f 00 00       	call   8028b4 <__umoddi3>
  8008fb:	83 c4 10             	add    $0x10,%esp
  8008fe:	05 94 2e 80 00       	add    $0x802e94,%eax
  800903:	8a 00                	mov    (%eax),%al
  800905:	0f be c0             	movsbl %al,%eax
  800908:	83 ec 08             	sub    $0x8,%esp
  80090b:	ff 75 0c             	pushl  0xc(%ebp)
  80090e:	50                   	push   %eax
  80090f:	8b 45 08             	mov    0x8(%ebp),%eax
  800912:	ff d0                	call   *%eax
  800914:	83 c4 10             	add    $0x10,%esp
}
  800917:	90                   	nop
  800918:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80091b:	c9                   	leave  
  80091c:	c3                   	ret    

0080091d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80091d:	55                   	push   %ebp
  80091e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800920:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800924:	7e 1c                	jle    800942 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800926:	8b 45 08             	mov    0x8(%ebp),%eax
  800929:	8b 00                	mov    (%eax),%eax
  80092b:	8d 50 08             	lea    0x8(%eax),%edx
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	89 10                	mov    %edx,(%eax)
  800933:	8b 45 08             	mov    0x8(%ebp),%eax
  800936:	8b 00                	mov    (%eax),%eax
  800938:	83 e8 08             	sub    $0x8,%eax
  80093b:	8b 50 04             	mov    0x4(%eax),%edx
  80093e:	8b 00                	mov    (%eax),%eax
  800940:	eb 40                	jmp    800982 <getuint+0x65>
	else if (lflag)
  800942:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800946:	74 1e                	je     800966 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800948:	8b 45 08             	mov    0x8(%ebp),%eax
  80094b:	8b 00                	mov    (%eax),%eax
  80094d:	8d 50 04             	lea    0x4(%eax),%edx
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	89 10                	mov    %edx,(%eax)
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	8b 00                	mov    (%eax),%eax
  80095a:	83 e8 04             	sub    $0x4,%eax
  80095d:	8b 00                	mov    (%eax),%eax
  80095f:	ba 00 00 00 00       	mov    $0x0,%edx
  800964:	eb 1c                	jmp    800982 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	8d 50 04             	lea    0x4(%eax),%edx
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	89 10                	mov    %edx,(%eax)
  800973:	8b 45 08             	mov    0x8(%ebp),%eax
  800976:	8b 00                	mov    (%eax),%eax
  800978:	83 e8 04             	sub    $0x4,%eax
  80097b:	8b 00                	mov    (%eax),%eax
  80097d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800982:	5d                   	pop    %ebp
  800983:	c3                   	ret    

00800984 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800987:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80098b:	7e 1c                	jle    8009a9 <getint+0x25>
		return va_arg(*ap, long long);
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	8b 00                	mov    (%eax),%eax
  800992:	8d 50 08             	lea    0x8(%eax),%edx
  800995:	8b 45 08             	mov    0x8(%ebp),%eax
  800998:	89 10                	mov    %edx,(%eax)
  80099a:	8b 45 08             	mov    0x8(%ebp),%eax
  80099d:	8b 00                	mov    (%eax),%eax
  80099f:	83 e8 08             	sub    $0x8,%eax
  8009a2:	8b 50 04             	mov    0x4(%eax),%edx
  8009a5:	8b 00                	mov    (%eax),%eax
  8009a7:	eb 38                	jmp    8009e1 <getint+0x5d>
	else if (lflag)
  8009a9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009ad:	74 1a                	je     8009c9 <getint+0x45>
		return va_arg(*ap, long);
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	8b 00                	mov    (%eax),%eax
  8009b4:	8d 50 04             	lea    0x4(%eax),%edx
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	89 10                	mov    %edx,(%eax)
  8009bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bf:	8b 00                	mov    (%eax),%eax
  8009c1:	83 e8 04             	sub    $0x4,%eax
  8009c4:	8b 00                	mov    (%eax),%eax
  8009c6:	99                   	cltd   
  8009c7:	eb 18                	jmp    8009e1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cc:	8b 00                	mov    (%eax),%eax
  8009ce:	8d 50 04             	lea    0x4(%eax),%edx
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	89 10                	mov    %edx,(%eax)
  8009d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d9:	8b 00                	mov    (%eax),%eax
  8009db:	83 e8 04             	sub    $0x4,%eax
  8009de:	8b 00                	mov    (%eax),%eax
  8009e0:	99                   	cltd   
}
  8009e1:	5d                   	pop    %ebp
  8009e2:	c3                   	ret    

008009e3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009e3:	55                   	push   %ebp
  8009e4:	89 e5                	mov    %esp,%ebp
  8009e6:	56                   	push   %esi
  8009e7:	53                   	push   %ebx
  8009e8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009eb:	eb 17                	jmp    800a04 <vprintfmt+0x21>
			if (ch == '\0')
  8009ed:	85 db                	test   %ebx,%ebx
  8009ef:	0f 84 af 03 00 00    	je     800da4 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8009f5:	83 ec 08             	sub    $0x8,%esp
  8009f8:	ff 75 0c             	pushl  0xc(%ebp)
  8009fb:	53                   	push   %ebx
  8009fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ff:	ff d0                	call   *%eax
  800a01:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a04:	8b 45 10             	mov    0x10(%ebp),%eax
  800a07:	8d 50 01             	lea    0x1(%eax),%edx
  800a0a:	89 55 10             	mov    %edx,0x10(%ebp)
  800a0d:	8a 00                	mov    (%eax),%al
  800a0f:	0f b6 d8             	movzbl %al,%ebx
  800a12:	83 fb 25             	cmp    $0x25,%ebx
  800a15:	75 d6                	jne    8009ed <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a17:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a1b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a22:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a29:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a30:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a37:	8b 45 10             	mov    0x10(%ebp),%eax
  800a3a:	8d 50 01             	lea    0x1(%eax),%edx
  800a3d:	89 55 10             	mov    %edx,0x10(%ebp)
  800a40:	8a 00                	mov    (%eax),%al
  800a42:	0f b6 d8             	movzbl %al,%ebx
  800a45:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a48:	83 f8 55             	cmp    $0x55,%eax
  800a4b:	0f 87 2b 03 00 00    	ja     800d7c <vprintfmt+0x399>
  800a51:	8b 04 85 b8 2e 80 00 	mov    0x802eb8(,%eax,4),%eax
  800a58:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a5a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a5e:	eb d7                	jmp    800a37 <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a60:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a64:	eb d1                	jmp    800a37 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a66:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a6d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a70:	89 d0                	mov    %edx,%eax
  800a72:	c1 e0 02             	shl    $0x2,%eax
  800a75:	01 d0                	add    %edx,%eax
  800a77:	01 c0                	add    %eax,%eax
  800a79:	01 d8                	add    %ebx,%eax
  800a7b:	83 e8 30             	sub    $0x30,%eax
  800a7e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a81:	8b 45 10             	mov    0x10(%ebp),%eax
  800a84:	8a 00                	mov    (%eax),%al
  800a86:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a89:	83 fb 2f             	cmp    $0x2f,%ebx
  800a8c:	7e 3e                	jle    800acc <vprintfmt+0xe9>
  800a8e:	83 fb 39             	cmp    $0x39,%ebx
  800a91:	7f 39                	jg     800acc <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a93:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a96:	eb d5                	jmp    800a6d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a98:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9b:	83 c0 04             	add    $0x4,%eax
  800a9e:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa1:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa4:	83 e8 04             	sub    $0x4,%eax
  800aa7:	8b 00                	mov    (%eax),%eax
  800aa9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800aac:	eb 1f                	jmp    800acd <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800aae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ab2:	79 83                	jns    800a37 <vprintfmt+0x54>
				width = 0;
  800ab4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800abb:	e9 77 ff ff ff       	jmp    800a37 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ac0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ac7:	e9 6b ff ff ff       	jmp    800a37 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800acc:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800acd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad1:	0f 89 60 ff ff ff    	jns    800a37 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ad7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ada:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800add:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ae4:	e9 4e ff ff ff       	jmp    800a37 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ae9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800aec:	e9 46 ff ff ff       	jmp    800a37 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800af1:	8b 45 14             	mov    0x14(%ebp),%eax
  800af4:	83 c0 04             	add    $0x4,%eax
  800af7:	89 45 14             	mov    %eax,0x14(%ebp)
  800afa:	8b 45 14             	mov    0x14(%ebp),%eax
  800afd:	83 e8 04             	sub    $0x4,%eax
  800b00:	8b 00                	mov    (%eax),%eax
  800b02:	83 ec 08             	sub    $0x8,%esp
  800b05:	ff 75 0c             	pushl  0xc(%ebp)
  800b08:	50                   	push   %eax
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	ff d0                	call   *%eax
  800b0e:	83 c4 10             	add    $0x10,%esp
			break;
  800b11:	e9 89 02 00 00       	jmp    800d9f <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b16:	8b 45 14             	mov    0x14(%ebp),%eax
  800b19:	83 c0 04             	add    $0x4,%eax
  800b1c:	89 45 14             	mov    %eax,0x14(%ebp)
  800b1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b22:	83 e8 04             	sub    $0x4,%eax
  800b25:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b27:	85 db                	test   %ebx,%ebx
  800b29:	79 02                	jns    800b2d <vprintfmt+0x14a>
				err = -err;
  800b2b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b2d:	83 fb 64             	cmp    $0x64,%ebx
  800b30:	7f 0b                	jg     800b3d <vprintfmt+0x15a>
  800b32:	8b 34 9d 00 2d 80 00 	mov    0x802d00(,%ebx,4),%esi
  800b39:	85 f6                	test   %esi,%esi
  800b3b:	75 19                	jne    800b56 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b3d:	53                   	push   %ebx
  800b3e:	68 a5 2e 80 00       	push   $0x802ea5
  800b43:	ff 75 0c             	pushl  0xc(%ebp)
  800b46:	ff 75 08             	pushl  0x8(%ebp)
  800b49:	e8 5e 02 00 00       	call   800dac <printfmt>
  800b4e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b51:	e9 49 02 00 00       	jmp    800d9f <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b56:	56                   	push   %esi
  800b57:	68 ae 2e 80 00       	push   $0x802eae
  800b5c:	ff 75 0c             	pushl  0xc(%ebp)
  800b5f:	ff 75 08             	pushl  0x8(%ebp)
  800b62:	e8 45 02 00 00       	call   800dac <printfmt>
  800b67:	83 c4 10             	add    $0x10,%esp
			break;
  800b6a:	e9 30 02 00 00       	jmp    800d9f <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b72:	83 c0 04             	add    $0x4,%eax
  800b75:	89 45 14             	mov    %eax,0x14(%ebp)
  800b78:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7b:	83 e8 04             	sub    $0x4,%eax
  800b7e:	8b 30                	mov    (%eax),%esi
  800b80:	85 f6                	test   %esi,%esi
  800b82:	75 05                	jne    800b89 <vprintfmt+0x1a6>
				p = "(null)";
  800b84:	be b1 2e 80 00       	mov    $0x802eb1,%esi
			if (width > 0 && padc != '-')
  800b89:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b8d:	7e 6d                	jle    800bfc <vprintfmt+0x219>
  800b8f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b93:	74 67                	je     800bfc <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b95:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b98:	83 ec 08             	sub    $0x8,%esp
  800b9b:	50                   	push   %eax
  800b9c:	56                   	push   %esi
  800b9d:	e8 12 05 00 00       	call   8010b4 <strnlen>
  800ba2:	83 c4 10             	add    $0x10,%esp
  800ba5:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ba8:	eb 16                	jmp    800bc0 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800baa:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800bae:	83 ec 08             	sub    $0x8,%esp
  800bb1:	ff 75 0c             	pushl  0xc(%ebp)
  800bb4:	50                   	push   %eax
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	ff d0                	call   *%eax
  800bba:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bbd:	ff 4d e4             	decl   -0x1c(%ebp)
  800bc0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bc4:	7f e4                	jg     800baa <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bc6:	eb 34                	jmp    800bfc <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800bc8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800bcc:	74 1c                	je     800bea <vprintfmt+0x207>
  800bce:	83 fb 1f             	cmp    $0x1f,%ebx
  800bd1:	7e 05                	jle    800bd8 <vprintfmt+0x1f5>
  800bd3:	83 fb 7e             	cmp    $0x7e,%ebx
  800bd6:	7e 12                	jle    800bea <vprintfmt+0x207>
					putch('?', putdat);
  800bd8:	83 ec 08             	sub    $0x8,%esp
  800bdb:	ff 75 0c             	pushl  0xc(%ebp)
  800bde:	6a 3f                	push   $0x3f
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	ff d0                	call   *%eax
  800be5:	83 c4 10             	add    $0x10,%esp
  800be8:	eb 0f                	jmp    800bf9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800bea:	83 ec 08             	sub    $0x8,%esp
  800bed:	ff 75 0c             	pushl  0xc(%ebp)
  800bf0:	53                   	push   %ebx
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	ff d0                	call   *%eax
  800bf6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bf9:	ff 4d e4             	decl   -0x1c(%ebp)
  800bfc:	89 f0                	mov    %esi,%eax
  800bfe:	8d 70 01             	lea    0x1(%eax),%esi
  800c01:	8a 00                	mov    (%eax),%al
  800c03:	0f be d8             	movsbl %al,%ebx
  800c06:	85 db                	test   %ebx,%ebx
  800c08:	74 24                	je     800c2e <vprintfmt+0x24b>
  800c0a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c0e:	78 b8                	js     800bc8 <vprintfmt+0x1e5>
  800c10:	ff 4d e0             	decl   -0x20(%ebp)
  800c13:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c17:	79 af                	jns    800bc8 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c19:	eb 13                	jmp    800c2e <vprintfmt+0x24b>
				putch(' ', putdat);
  800c1b:	83 ec 08             	sub    $0x8,%esp
  800c1e:	ff 75 0c             	pushl  0xc(%ebp)
  800c21:	6a 20                	push   $0x20
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	ff d0                	call   *%eax
  800c28:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c2b:	ff 4d e4             	decl   -0x1c(%ebp)
  800c2e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c32:	7f e7                	jg     800c1b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c34:	e9 66 01 00 00       	jmp    800d9f <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c39:	83 ec 08             	sub    $0x8,%esp
  800c3c:	ff 75 e8             	pushl  -0x18(%ebp)
  800c3f:	8d 45 14             	lea    0x14(%ebp),%eax
  800c42:	50                   	push   %eax
  800c43:	e8 3c fd ff ff       	call   800984 <getint>
  800c48:	83 c4 10             	add    $0x10,%esp
  800c4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c57:	85 d2                	test   %edx,%edx
  800c59:	79 23                	jns    800c7e <vprintfmt+0x29b>
				putch('-', putdat);
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	ff 75 0c             	pushl  0xc(%ebp)
  800c61:	6a 2d                	push   $0x2d
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	ff d0                	call   *%eax
  800c68:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c71:	f7 d8                	neg    %eax
  800c73:	83 d2 00             	adc    $0x0,%edx
  800c76:	f7 da                	neg    %edx
  800c78:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c7b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c7e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c85:	e9 bc 00 00 00       	jmp    800d46 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c8a:	83 ec 08             	sub    $0x8,%esp
  800c8d:	ff 75 e8             	pushl  -0x18(%ebp)
  800c90:	8d 45 14             	lea    0x14(%ebp),%eax
  800c93:	50                   	push   %eax
  800c94:	e8 84 fc ff ff       	call   80091d <getuint>
  800c99:	83 c4 10             	add    $0x10,%esp
  800c9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c9f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ca2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ca9:	e9 98 00 00 00       	jmp    800d46 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800cae:	83 ec 08             	sub    $0x8,%esp
  800cb1:	ff 75 0c             	pushl  0xc(%ebp)
  800cb4:	6a 58                	push   $0x58
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	ff d0                	call   *%eax
  800cbb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cbe:	83 ec 08             	sub    $0x8,%esp
  800cc1:	ff 75 0c             	pushl  0xc(%ebp)
  800cc4:	6a 58                	push   $0x58
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	ff d0                	call   *%eax
  800ccb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cce:	83 ec 08             	sub    $0x8,%esp
  800cd1:	ff 75 0c             	pushl  0xc(%ebp)
  800cd4:	6a 58                	push   $0x58
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	ff d0                	call   *%eax
  800cdb:	83 c4 10             	add    $0x10,%esp
			break;
  800cde:	e9 bc 00 00 00       	jmp    800d9f <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ce3:	83 ec 08             	sub    $0x8,%esp
  800ce6:	ff 75 0c             	pushl  0xc(%ebp)
  800ce9:	6a 30                	push   $0x30
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	ff d0                	call   *%eax
  800cf0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800cf3:	83 ec 08             	sub    $0x8,%esp
  800cf6:	ff 75 0c             	pushl  0xc(%ebp)
  800cf9:	6a 78                	push   $0x78
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfe:	ff d0                	call   *%eax
  800d00:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d03:	8b 45 14             	mov    0x14(%ebp),%eax
  800d06:	83 c0 04             	add    $0x4,%eax
  800d09:	89 45 14             	mov    %eax,0x14(%ebp)
  800d0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d0f:	83 e8 04             	sub    $0x4,%eax
  800d12:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d1e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d25:	eb 1f                	jmp    800d46 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d27:	83 ec 08             	sub    $0x8,%esp
  800d2a:	ff 75 e8             	pushl  -0x18(%ebp)
  800d2d:	8d 45 14             	lea    0x14(%ebp),%eax
  800d30:	50                   	push   %eax
  800d31:	e8 e7 fb ff ff       	call   80091d <getuint>
  800d36:	83 c4 10             	add    $0x10,%esp
  800d39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d3c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d3f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d46:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d4d:	83 ec 04             	sub    $0x4,%esp
  800d50:	52                   	push   %edx
  800d51:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d54:	50                   	push   %eax
  800d55:	ff 75 f4             	pushl  -0xc(%ebp)
  800d58:	ff 75 f0             	pushl  -0x10(%ebp)
  800d5b:	ff 75 0c             	pushl  0xc(%ebp)
  800d5e:	ff 75 08             	pushl  0x8(%ebp)
  800d61:	e8 00 fb ff ff       	call   800866 <printnum>
  800d66:	83 c4 20             	add    $0x20,%esp
			break;
  800d69:	eb 34                	jmp    800d9f <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d6b:	83 ec 08             	sub    $0x8,%esp
  800d6e:	ff 75 0c             	pushl  0xc(%ebp)
  800d71:	53                   	push   %ebx
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	ff d0                	call   *%eax
  800d77:	83 c4 10             	add    $0x10,%esp
			break;
  800d7a:	eb 23                	jmp    800d9f <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d7c:	83 ec 08             	sub    $0x8,%esp
  800d7f:	ff 75 0c             	pushl  0xc(%ebp)
  800d82:	6a 25                	push   $0x25
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	ff d0                	call   *%eax
  800d89:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d8c:	ff 4d 10             	decl   0x10(%ebp)
  800d8f:	eb 03                	jmp    800d94 <vprintfmt+0x3b1>
  800d91:	ff 4d 10             	decl   0x10(%ebp)
  800d94:	8b 45 10             	mov    0x10(%ebp),%eax
  800d97:	48                   	dec    %eax
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	3c 25                	cmp    $0x25,%al
  800d9c:	75 f3                	jne    800d91 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d9e:	90                   	nop
		}
	}
  800d9f:	e9 47 fc ff ff       	jmp    8009eb <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800da4:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800da5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800da8:	5b                   	pop    %ebx
  800da9:	5e                   	pop    %esi
  800daa:	5d                   	pop    %ebp
  800dab:	c3                   	ret    

00800dac <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
  800daf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800db2:	8d 45 10             	lea    0x10(%ebp),%eax
  800db5:	83 c0 04             	add    $0x4,%eax
  800db8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800dbb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbe:	ff 75 f4             	pushl  -0xc(%ebp)
  800dc1:	50                   	push   %eax
  800dc2:	ff 75 0c             	pushl  0xc(%ebp)
  800dc5:	ff 75 08             	pushl  0x8(%ebp)
  800dc8:	e8 16 fc ff ff       	call   8009e3 <vprintfmt>
  800dcd:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800dd0:	90                   	nop
  800dd1:	c9                   	leave  
  800dd2:	c3                   	ret    

00800dd3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd9:	8b 40 08             	mov    0x8(%eax),%eax
  800ddc:	8d 50 01             	lea    0x1(%eax),%edx
  800ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800de5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de8:	8b 10                	mov    (%eax),%edx
  800dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ded:	8b 40 04             	mov    0x4(%eax),%eax
  800df0:	39 c2                	cmp    %eax,%edx
  800df2:	73 12                	jae    800e06 <sprintputch+0x33>
		*b->buf++ = ch;
  800df4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df7:	8b 00                	mov    (%eax),%eax
  800df9:	8d 48 01             	lea    0x1(%eax),%ecx
  800dfc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dff:	89 0a                	mov    %ecx,(%edx)
  800e01:	8b 55 08             	mov    0x8(%ebp),%edx
  800e04:	88 10                	mov    %dl,(%eax)
}
  800e06:	90                   	nop
  800e07:	5d                   	pop    %ebp
  800e08:	c3                   	ret    

00800e09 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e09:	55                   	push   %ebp
  800e0a:	89 e5                	mov    %esp,%ebp
  800e0c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e18:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	01 d0                	add    %edx,%eax
  800e20:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e2a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e2e:	74 06                	je     800e36 <vsnprintf+0x2d>
  800e30:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e34:	7f 07                	jg     800e3d <vsnprintf+0x34>
		return -E_INVAL;
  800e36:	b8 03 00 00 00       	mov    $0x3,%eax
  800e3b:	eb 20                	jmp    800e5d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e3d:	ff 75 14             	pushl  0x14(%ebp)
  800e40:	ff 75 10             	pushl  0x10(%ebp)
  800e43:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e46:	50                   	push   %eax
  800e47:	68 d3 0d 80 00       	push   $0x800dd3
  800e4c:	e8 92 fb ff ff       	call   8009e3 <vprintfmt>
  800e51:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e57:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e5d:	c9                   	leave  
  800e5e:	c3                   	ret    

00800e5f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e5f:	55                   	push   %ebp
  800e60:	89 e5                	mov    %esp,%ebp
  800e62:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e65:	8d 45 10             	lea    0x10(%ebp),%eax
  800e68:	83 c0 04             	add    $0x4,%eax
  800e6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e71:	ff 75 f4             	pushl  -0xc(%ebp)
  800e74:	50                   	push   %eax
  800e75:	ff 75 0c             	pushl  0xc(%ebp)
  800e78:	ff 75 08             	pushl  0x8(%ebp)
  800e7b:	e8 89 ff ff ff       	call   800e09 <vsnprintf>
  800e80:	83 c4 10             	add    $0x10,%esp
  800e83:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e86:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e89:	c9                   	leave  
  800e8a:	c3                   	ret    

00800e8b <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800e8b:	55                   	push   %ebp
  800e8c:	89 e5                	mov    %esp,%ebp
  800e8e:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  800e91:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e95:	74 13                	je     800eaa <readline+0x1f>
		cprintf("%s", prompt);
  800e97:	83 ec 08             	sub    $0x8,%esp
  800e9a:	ff 75 08             	pushl  0x8(%ebp)
  800e9d:	68 10 30 80 00       	push   $0x803010
  800ea2:	e8 69 f9 ff ff       	call   800810 <cprintf>
  800ea7:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800eaa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800eb1:	83 ec 0c             	sub    $0xc,%esp
  800eb4:	6a 00                	push   $0x0
  800eb6:	e8 5f f7 ff ff       	call   80061a <iscons>
  800ebb:	83 c4 10             	add    $0x10,%esp
  800ebe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800ec1:	e8 06 f7 ff ff       	call   8005cc <getchar>
  800ec6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800ec9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ecd:	79 22                	jns    800ef1 <readline+0x66>
			if (c != -E_EOF)
  800ecf:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800ed3:	0f 84 ad 00 00 00    	je     800f86 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800ed9:	83 ec 08             	sub    $0x8,%esp
  800edc:	ff 75 ec             	pushl  -0x14(%ebp)
  800edf:	68 13 30 80 00       	push   $0x803013
  800ee4:	e8 27 f9 ff ff       	call   800810 <cprintf>
  800ee9:	83 c4 10             	add    $0x10,%esp
			return;
  800eec:	e9 95 00 00 00       	jmp    800f86 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800ef1:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800ef5:	7e 34                	jle    800f2b <readline+0xa0>
  800ef7:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800efe:	7f 2b                	jg     800f2b <readline+0xa0>
			if (echoing)
  800f00:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f04:	74 0e                	je     800f14 <readline+0x89>
				cputchar(c);
  800f06:	83 ec 0c             	sub    $0xc,%esp
  800f09:	ff 75 ec             	pushl  -0x14(%ebp)
  800f0c:	e8 73 f6 ff ff       	call   800584 <cputchar>
  800f11:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f17:	8d 50 01             	lea    0x1(%eax),%edx
  800f1a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800f1d:	89 c2                	mov    %eax,%edx
  800f1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f22:	01 d0                	add    %edx,%eax
  800f24:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f27:	88 10                	mov    %dl,(%eax)
  800f29:	eb 56                	jmp    800f81 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800f2b:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800f2f:	75 1f                	jne    800f50 <readline+0xc5>
  800f31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800f35:	7e 19                	jle    800f50 <readline+0xc5>
			if (echoing)
  800f37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f3b:	74 0e                	je     800f4b <readline+0xc0>
				cputchar(c);
  800f3d:	83 ec 0c             	sub    $0xc,%esp
  800f40:	ff 75 ec             	pushl  -0x14(%ebp)
  800f43:	e8 3c f6 ff ff       	call   800584 <cputchar>
  800f48:	83 c4 10             	add    $0x10,%esp

			i--;
  800f4b:	ff 4d f4             	decl   -0xc(%ebp)
  800f4e:	eb 31                	jmp    800f81 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800f50:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800f54:	74 0a                	je     800f60 <readline+0xd5>
  800f56:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800f5a:	0f 85 61 ff ff ff    	jne    800ec1 <readline+0x36>
			if (echoing)
  800f60:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f64:	74 0e                	je     800f74 <readline+0xe9>
				cputchar(c);
  800f66:	83 ec 0c             	sub    $0xc,%esp
  800f69:	ff 75 ec             	pushl  -0x14(%ebp)
  800f6c:	e8 13 f6 ff ff       	call   800584 <cputchar>
  800f71:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800f74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7a:	01 d0                	add    %edx,%eax
  800f7c:	c6 00 00             	movb   $0x0,(%eax)
			return;
  800f7f:	eb 06                	jmp    800f87 <readline+0xfc>
		}
	}
  800f81:	e9 3b ff ff ff       	jmp    800ec1 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  800f86:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  800f87:	c9                   	leave  
  800f88:	c3                   	ret    

00800f89 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800f89:	55                   	push   %ebp
  800f8a:	89 e5                	mov    %esp,%ebp
  800f8c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f8f:	e8 71 14 00 00       	call   802405 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  800f94:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f98:	74 13                	je     800fad <atomic_readline+0x24>
		cprintf("%s", prompt);
  800f9a:	83 ec 08             	sub    $0x8,%esp
  800f9d:	ff 75 08             	pushl  0x8(%ebp)
  800fa0:	68 10 30 80 00       	push   $0x803010
  800fa5:	e8 66 f8 ff ff       	call   800810 <cprintf>
  800faa:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800fad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800fb4:	83 ec 0c             	sub    $0xc,%esp
  800fb7:	6a 00                	push   $0x0
  800fb9:	e8 5c f6 ff ff       	call   80061a <iscons>
  800fbe:	83 c4 10             	add    $0x10,%esp
  800fc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800fc4:	e8 03 f6 ff ff       	call   8005cc <getchar>
  800fc9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800fcc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800fd0:	79 23                	jns    800ff5 <atomic_readline+0x6c>
			if (c != -E_EOF)
  800fd2:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800fd6:	74 13                	je     800feb <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  800fd8:	83 ec 08             	sub    $0x8,%esp
  800fdb:	ff 75 ec             	pushl  -0x14(%ebp)
  800fde:	68 13 30 80 00       	push   $0x803013
  800fe3:	e8 28 f8 ff ff       	call   800810 <cprintf>
  800fe8:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800feb:	e8 2f 14 00 00       	call   80241f <sys_enable_interrupt>
			return;
  800ff0:	e9 9a 00 00 00       	jmp    80108f <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800ff5:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800ff9:	7e 34                	jle    80102f <atomic_readline+0xa6>
  800ffb:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801002:	7f 2b                	jg     80102f <atomic_readline+0xa6>
			if (echoing)
  801004:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801008:	74 0e                	je     801018 <atomic_readline+0x8f>
				cputchar(c);
  80100a:	83 ec 0c             	sub    $0xc,%esp
  80100d:	ff 75 ec             	pushl  -0x14(%ebp)
  801010:	e8 6f f5 ff ff       	call   800584 <cputchar>
  801015:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801018:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80101b:	8d 50 01             	lea    0x1(%eax),%edx
  80101e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801021:	89 c2                	mov    %eax,%edx
  801023:	8b 45 0c             	mov    0xc(%ebp),%eax
  801026:	01 d0                	add    %edx,%eax
  801028:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80102b:	88 10                	mov    %dl,(%eax)
  80102d:	eb 5b                	jmp    80108a <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80102f:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801033:	75 1f                	jne    801054 <atomic_readline+0xcb>
  801035:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801039:	7e 19                	jle    801054 <atomic_readline+0xcb>
			if (echoing)
  80103b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80103f:	74 0e                	je     80104f <atomic_readline+0xc6>
				cputchar(c);
  801041:	83 ec 0c             	sub    $0xc,%esp
  801044:	ff 75 ec             	pushl  -0x14(%ebp)
  801047:	e8 38 f5 ff ff       	call   800584 <cputchar>
  80104c:	83 c4 10             	add    $0x10,%esp
			i--;
  80104f:	ff 4d f4             	decl   -0xc(%ebp)
  801052:	eb 36                	jmp    80108a <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801054:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801058:	74 0a                	je     801064 <atomic_readline+0xdb>
  80105a:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80105e:	0f 85 60 ff ff ff    	jne    800fc4 <atomic_readline+0x3b>
			if (echoing)
  801064:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801068:	74 0e                	je     801078 <atomic_readline+0xef>
				cputchar(c);
  80106a:	83 ec 0c             	sub    $0xc,%esp
  80106d:	ff 75 ec             	pushl  -0x14(%ebp)
  801070:	e8 0f f5 ff ff       	call   800584 <cputchar>
  801075:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  801078:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80107b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107e:	01 d0                	add    %edx,%eax
  801080:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  801083:	e8 97 13 00 00       	call   80241f <sys_enable_interrupt>
			return;
  801088:	eb 05                	jmp    80108f <atomic_readline+0x106>
		}
	}
  80108a:	e9 35 ff ff ff       	jmp    800fc4 <atomic_readline+0x3b>
}
  80108f:	c9                   	leave  
  801090:	c3                   	ret    

00801091 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801091:	55                   	push   %ebp
  801092:	89 e5                	mov    %esp,%ebp
  801094:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801097:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80109e:	eb 06                	jmp    8010a6 <strlen+0x15>
		n++;
  8010a0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010a3:	ff 45 08             	incl   0x8(%ebp)
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	8a 00                	mov    (%eax),%al
  8010ab:	84 c0                	test   %al,%al
  8010ad:	75 f1                	jne    8010a0 <strlen+0xf>
		n++;
	return n;
  8010af:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010b2:	c9                   	leave  
  8010b3:	c3                   	ret    

008010b4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8010b4:	55                   	push   %ebp
  8010b5:	89 e5                	mov    %esp,%ebp
  8010b7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010c1:	eb 09                	jmp    8010cc <strnlen+0x18>
		n++;
  8010c3:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010c6:	ff 45 08             	incl   0x8(%ebp)
  8010c9:	ff 4d 0c             	decl   0xc(%ebp)
  8010cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010d0:	74 09                	je     8010db <strnlen+0x27>
  8010d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d5:	8a 00                	mov    (%eax),%al
  8010d7:	84 c0                	test   %al,%al
  8010d9:	75 e8                	jne    8010c3 <strnlen+0xf>
		n++;
	return n;
  8010db:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010de:	c9                   	leave  
  8010df:	c3                   	ret    

008010e0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
  8010e3:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010ec:	90                   	nop
  8010ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f0:	8d 50 01             	lea    0x1(%eax),%edx
  8010f3:	89 55 08             	mov    %edx,0x8(%ebp)
  8010f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010fc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010ff:	8a 12                	mov    (%edx),%dl
  801101:	88 10                	mov    %dl,(%eax)
  801103:	8a 00                	mov    (%eax),%al
  801105:	84 c0                	test   %al,%al
  801107:	75 e4                	jne    8010ed <strcpy+0xd>
		/* do nothing */;
	return ret;
  801109:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80110c:	c9                   	leave  
  80110d:	c3                   	ret    

0080110e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80110e:	55                   	push   %ebp
  80110f:	89 e5                	mov    %esp,%ebp
  801111:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801114:	8b 45 08             	mov    0x8(%ebp),%eax
  801117:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80111a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801121:	eb 1f                	jmp    801142 <strncpy+0x34>
		*dst++ = *src;
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	8d 50 01             	lea    0x1(%eax),%edx
  801129:	89 55 08             	mov    %edx,0x8(%ebp)
  80112c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80112f:	8a 12                	mov    (%edx),%dl
  801131:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801133:	8b 45 0c             	mov    0xc(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	84 c0                	test   %al,%al
  80113a:	74 03                	je     80113f <strncpy+0x31>
			src++;
  80113c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80113f:	ff 45 fc             	incl   -0x4(%ebp)
  801142:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801145:	3b 45 10             	cmp    0x10(%ebp),%eax
  801148:	72 d9                	jb     801123 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80114a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80114d:	c9                   	leave  
  80114e:	c3                   	ret    

0080114f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80114f:	55                   	push   %ebp
  801150:	89 e5                	mov    %esp,%ebp
  801152:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801155:	8b 45 08             	mov    0x8(%ebp),%eax
  801158:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80115b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115f:	74 30                	je     801191 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801161:	eb 16                	jmp    801179 <strlcpy+0x2a>
			*dst++ = *src++;
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	8d 50 01             	lea    0x1(%eax),%edx
  801169:	89 55 08             	mov    %edx,0x8(%ebp)
  80116c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80116f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801172:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801175:	8a 12                	mov    (%edx),%dl
  801177:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801179:	ff 4d 10             	decl   0x10(%ebp)
  80117c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801180:	74 09                	je     80118b <strlcpy+0x3c>
  801182:	8b 45 0c             	mov    0xc(%ebp),%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	84 c0                	test   %al,%al
  801189:	75 d8                	jne    801163 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80118b:	8b 45 08             	mov    0x8(%ebp),%eax
  80118e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801191:	8b 55 08             	mov    0x8(%ebp),%edx
  801194:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801197:	29 c2                	sub    %eax,%edx
  801199:	89 d0                	mov    %edx,%eax
}
  80119b:	c9                   	leave  
  80119c:	c3                   	ret    

0080119d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80119d:	55                   	push   %ebp
  80119e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8011a0:	eb 06                	jmp    8011a8 <strcmp+0xb>
		p++, q++;
  8011a2:	ff 45 08             	incl   0x8(%ebp)
  8011a5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	8a 00                	mov    (%eax),%al
  8011ad:	84 c0                	test   %al,%al
  8011af:	74 0e                	je     8011bf <strcmp+0x22>
  8011b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b4:	8a 10                	mov    (%eax),%dl
  8011b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b9:	8a 00                	mov    (%eax),%al
  8011bb:	38 c2                	cmp    %al,%dl
  8011bd:	74 e3                	je     8011a2 <strcmp+0x5>
		p++, q++;
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

008011d5 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8011d5:	55                   	push   %ebp
  8011d6:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8011d8:	eb 09                	jmp    8011e3 <strncmp+0xe>
		n--, p++, q++;
  8011da:	ff 4d 10             	decl   0x10(%ebp)
  8011dd:	ff 45 08             	incl   0x8(%ebp)
  8011e0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8011e3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e7:	74 17                	je     801200 <strncmp+0x2b>
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	8a 00                	mov    (%eax),%al
  8011ee:	84 c0                	test   %al,%al
  8011f0:	74 0e                	je     801200 <strncmp+0x2b>
  8011f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f5:	8a 10                	mov    (%eax),%dl
  8011f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fa:	8a 00                	mov    (%eax),%al
  8011fc:	38 c2                	cmp    %al,%dl
  8011fe:	74 da                	je     8011da <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801200:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801204:	75 07                	jne    80120d <strncmp+0x38>
		return 0;
  801206:	b8 00 00 00 00       	mov    $0x0,%eax
  80120b:	eb 14                	jmp    801221 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80120d:	8b 45 08             	mov    0x8(%ebp),%eax
  801210:	8a 00                	mov    (%eax),%al
  801212:	0f b6 d0             	movzbl %al,%edx
  801215:	8b 45 0c             	mov    0xc(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	0f b6 c0             	movzbl %al,%eax
  80121d:	29 c2                	sub    %eax,%edx
  80121f:	89 d0                	mov    %edx,%eax
}
  801221:	5d                   	pop    %ebp
  801222:	c3                   	ret    

00801223 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801223:	55                   	push   %ebp
  801224:	89 e5                	mov    %esp,%ebp
  801226:	83 ec 04             	sub    $0x4,%esp
  801229:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80122f:	eb 12                	jmp    801243 <strchr+0x20>
		if (*s == c)
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801239:	75 05                	jne    801240 <strchr+0x1d>
			return (char *) s;
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	eb 11                	jmp    801251 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801240:	ff 45 08             	incl   0x8(%ebp)
  801243:	8b 45 08             	mov    0x8(%ebp),%eax
  801246:	8a 00                	mov    (%eax),%al
  801248:	84 c0                	test   %al,%al
  80124a:	75 e5                	jne    801231 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80124c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801251:	c9                   	leave  
  801252:	c3                   	ret    

00801253 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801253:	55                   	push   %ebp
  801254:	89 e5                	mov    %esp,%ebp
  801256:	83 ec 04             	sub    $0x4,%esp
  801259:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80125f:	eb 0d                	jmp    80126e <strfind+0x1b>
		if (*s == c)
  801261:	8b 45 08             	mov    0x8(%ebp),%eax
  801264:	8a 00                	mov    (%eax),%al
  801266:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801269:	74 0e                	je     801279 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80126b:	ff 45 08             	incl   0x8(%ebp)
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	8a 00                	mov    (%eax),%al
  801273:	84 c0                	test   %al,%al
  801275:	75 ea                	jne    801261 <strfind+0xe>
  801277:	eb 01                	jmp    80127a <strfind+0x27>
		if (*s == c)
			break;
  801279:	90                   	nop
	return (char *) s;
  80127a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80127d:	c9                   	leave  
  80127e:	c3                   	ret    

0080127f <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
  801282:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801285:	8b 45 08             	mov    0x8(%ebp),%eax
  801288:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80128b:	8b 45 10             	mov    0x10(%ebp),%eax
  80128e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801291:	eb 0e                	jmp    8012a1 <memset+0x22>
		*p++ = c;
  801293:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801296:	8d 50 01             	lea    0x1(%eax),%edx
  801299:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80129c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129f:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8012a1:	ff 4d f8             	decl   -0x8(%ebp)
  8012a4:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8012a8:	79 e9                	jns    801293 <memset+0x14>
		*p++ = c;

	return v;
  8012aa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012ad:	c9                   	leave  
  8012ae:	c3                   	ret    

008012af <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012af:	55                   	push   %ebp
  8012b0:	89 e5                	mov    %esp,%ebp
  8012b2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012be:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8012c1:	eb 16                	jmp    8012d9 <memcpy+0x2a>
		*d++ = *s++;
  8012c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c6:	8d 50 01             	lea    0x1(%eax),%edx
  8012c9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cf:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012d2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012d5:	8a 12                	mov    (%edx),%dl
  8012d7:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8012d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012dc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012df:	89 55 10             	mov    %edx,0x10(%ebp)
  8012e2:	85 c0                	test   %eax,%eax
  8012e4:	75 dd                	jne    8012c3 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012e9:	c9                   	leave  
  8012ea:	c3                   	ret    

008012eb <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012eb:	55                   	push   %ebp
  8012ec:	89 e5                	mov    %esp,%ebp
  8012ee:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  8012f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801300:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801303:	73 50                	jae    801355 <memmove+0x6a>
  801305:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801308:	8b 45 10             	mov    0x10(%ebp),%eax
  80130b:	01 d0                	add    %edx,%eax
  80130d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801310:	76 43                	jbe    801355 <memmove+0x6a>
		s += n;
  801312:	8b 45 10             	mov    0x10(%ebp),%eax
  801315:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801318:	8b 45 10             	mov    0x10(%ebp),%eax
  80131b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80131e:	eb 10                	jmp    801330 <memmove+0x45>
			*--d = *--s;
  801320:	ff 4d f8             	decl   -0x8(%ebp)
  801323:	ff 4d fc             	decl   -0x4(%ebp)
  801326:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801329:	8a 10                	mov    (%eax),%dl
  80132b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80132e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801330:	8b 45 10             	mov    0x10(%ebp),%eax
  801333:	8d 50 ff             	lea    -0x1(%eax),%edx
  801336:	89 55 10             	mov    %edx,0x10(%ebp)
  801339:	85 c0                	test   %eax,%eax
  80133b:	75 e3                	jne    801320 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80133d:	eb 23                	jmp    801362 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80133f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801342:	8d 50 01             	lea    0x1(%eax),%edx
  801345:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801348:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80134b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80134e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801351:	8a 12                	mov    (%edx),%dl
  801353:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801355:	8b 45 10             	mov    0x10(%ebp),%eax
  801358:	8d 50 ff             	lea    -0x1(%eax),%edx
  80135b:	89 55 10             	mov    %edx,0x10(%ebp)
  80135e:	85 c0                	test   %eax,%eax
  801360:	75 dd                	jne    80133f <memmove+0x54>
			*d++ = *s++;

	return dst;
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801365:	c9                   	leave  
  801366:	c3                   	ret    

00801367 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801367:	55                   	push   %ebp
  801368:	89 e5                	mov    %esp,%ebp
  80136a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80136d:	8b 45 08             	mov    0x8(%ebp),%eax
  801370:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801373:	8b 45 0c             	mov    0xc(%ebp),%eax
  801376:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801379:	eb 2a                	jmp    8013a5 <memcmp+0x3e>
		if (*s1 != *s2)
  80137b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80137e:	8a 10                	mov    (%eax),%dl
  801380:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801383:	8a 00                	mov    (%eax),%al
  801385:	38 c2                	cmp    %al,%dl
  801387:	74 16                	je     80139f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801389:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80138c:	8a 00                	mov    (%eax),%al
  80138e:	0f b6 d0             	movzbl %al,%edx
  801391:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801394:	8a 00                	mov    (%eax),%al
  801396:	0f b6 c0             	movzbl %al,%eax
  801399:	29 c2                	sub    %eax,%edx
  80139b:	89 d0                	mov    %edx,%eax
  80139d:	eb 18                	jmp    8013b7 <memcmp+0x50>
		s1++, s2++;
  80139f:	ff 45 fc             	incl   -0x4(%ebp)
  8013a2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8013a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013ab:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ae:	85 c0                	test   %eax,%eax
  8013b0:	75 c9                	jne    80137b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013b7:	c9                   	leave  
  8013b8:	c3                   	ret    

008013b9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013b9:	55                   	push   %ebp
  8013ba:	89 e5                	mov    %esp,%ebp
  8013bc:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8013c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c5:	01 d0                	add    %edx,%eax
  8013c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8013ca:	eb 15                	jmp    8013e1 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cf:	8a 00                	mov    (%eax),%al
  8013d1:	0f b6 d0             	movzbl %al,%edx
  8013d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d7:	0f b6 c0             	movzbl %al,%eax
  8013da:	39 c2                	cmp    %eax,%edx
  8013dc:	74 0d                	je     8013eb <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013de:	ff 45 08             	incl   0x8(%ebp)
  8013e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013e7:	72 e3                	jb     8013cc <memfind+0x13>
  8013e9:	eb 01                	jmp    8013ec <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013eb:	90                   	nop
	return (void *) s;
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013ef:	c9                   	leave  
  8013f0:	c3                   	ret    

008013f1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013f1:	55                   	push   %ebp
  8013f2:	89 e5                	mov    %esp,%ebp
  8013f4:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013fe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801405:	eb 03                	jmp    80140a <strtol+0x19>
		s++;
  801407:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80140a:	8b 45 08             	mov    0x8(%ebp),%eax
  80140d:	8a 00                	mov    (%eax),%al
  80140f:	3c 20                	cmp    $0x20,%al
  801411:	74 f4                	je     801407 <strtol+0x16>
  801413:	8b 45 08             	mov    0x8(%ebp),%eax
  801416:	8a 00                	mov    (%eax),%al
  801418:	3c 09                	cmp    $0x9,%al
  80141a:	74 eb                	je     801407 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80141c:	8b 45 08             	mov    0x8(%ebp),%eax
  80141f:	8a 00                	mov    (%eax),%al
  801421:	3c 2b                	cmp    $0x2b,%al
  801423:	75 05                	jne    80142a <strtol+0x39>
		s++;
  801425:	ff 45 08             	incl   0x8(%ebp)
  801428:	eb 13                	jmp    80143d <strtol+0x4c>
	else if (*s == '-')
  80142a:	8b 45 08             	mov    0x8(%ebp),%eax
  80142d:	8a 00                	mov    (%eax),%al
  80142f:	3c 2d                	cmp    $0x2d,%al
  801431:	75 0a                	jne    80143d <strtol+0x4c>
		s++, neg = 1;
  801433:	ff 45 08             	incl   0x8(%ebp)
  801436:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80143d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801441:	74 06                	je     801449 <strtol+0x58>
  801443:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801447:	75 20                	jne    801469 <strtol+0x78>
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	3c 30                	cmp    $0x30,%al
  801450:	75 17                	jne    801469 <strtol+0x78>
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	40                   	inc    %eax
  801456:	8a 00                	mov    (%eax),%al
  801458:	3c 78                	cmp    $0x78,%al
  80145a:	75 0d                	jne    801469 <strtol+0x78>
		s += 2, base = 16;
  80145c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801460:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801467:	eb 28                	jmp    801491 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801469:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80146d:	75 15                	jne    801484 <strtol+0x93>
  80146f:	8b 45 08             	mov    0x8(%ebp),%eax
  801472:	8a 00                	mov    (%eax),%al
  801474:	3c 30                	cmp    $0x30,%al
  801476:	75 0c                	jne    801484 <strtol+0x93>
		s++, base = 8;
  801478:	ff 45 08             	incl   0x8(%ebp)
  80147b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801482:	eb 0d                	jmp    801491 <strtol+0xa0>
	else if (base == 0)
  801484:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801488:	75 07                	jne    801491 <strtol+0xa0>
		base = 10;
  80148a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801491:	8b 45 08             	mov    0x8(%ebp),%eax
  801494:	8a 00                	mov    (%eax),%al
  801496:	3c 2f                	cmp    $0x2f,%al
  801498:	7e 19                	jle    8014b3 <strtol+0xc2>
  80149a:	8b 45 08             	mov    0x8(%ebp),%eax
  80149d:	8a 00                	mov    (%eax),%al
  80149f:	3c 39                	cmp    $0x39,%al
  8014a1:	7f 10                	jg     8014b3 <strtol+0xc2>
			dig = *s - '0';
  8014a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a6:	8a 00                	mov    (%eax),%al
  8014a8:	0f be c0             	movsbl %al,%eax
  8014ab:	83 e8 30             	sub    $0x30,%eax
  8014ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014b1:	eb 42                	jmp    8014f5 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b6:	8a 00                	mov    (%eax),%al
  8014b8:	3c 60                	cmp    $0x60,%al
  8014ba:	7e 19                	jle    8014d5 <strtol+0xe4>
  8014bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bf:	8a 00                	mov    (%eax),%al
  8014c1:	3c 7a                	cmp    $0x7a,%al
  8014c3:	7f 10                	jg     8014d5 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8014c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c8:	8a 00                	mov    (%eax),%al
  8014ca:	0f be c0             	movsbl %al,%eax
  8014cd:	83 e8 57             	sub    $0x57,%eax
  8014d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014d3:	eb 20                	jmp    8014f5 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8014d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d8:	8a 00                	mov    (%eax),%al
  8014da:	3c 40                	cmp    $0x40,%al
  8014dc:	7e 39                	jle    801517 <strtol+0x126>
  8014de:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e1:	8a 00                	mov    (%eax),%al
  8014e3:	3c 5a                	cmp    $0x5a,%al
  8014e5:	7f 30                	jg     801517 <strtol+0x126>
			dig = *s - 'A' + 10;
  8014e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ea:	8a 00                	mov    (%eax),%al
  8014ec:	0f be c0             	movsbl %al,%eax
  8014ef:	83 e8 37             	sub    $0x37,%eax
  8014f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f8:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014fb:	7d 19                	jge    801516 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014fd:	ff 45 08             	incl   0x8(%ebp)
  801500:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801503:	0f af 45 10          	imul   0x10(%ebp),%eax
  801507:	89 c2                	mov    %eax,%edx
  801509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80150c:	01 d0                	add    %edx,%eax
  80150e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801511:	e9 7b ff ff ff       	jmp    801491 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801516:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801517:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80151b:	74 08                	je     801525 <strtol+0x134>
		*endptr = (char *) s;
  80151d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801520:	8b 55 08             	mov    0x8(%ebp),%edx
  801523:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801525:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801529:	74 07                	je     801532 <strtol+0x141>
  80152b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152e:	f7 d8                	neg    %eax
  801530:	eb 03                	jmp    801535 <strtol+0x144>
  801532:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801535:	c9                   	leave  
  801536:	c3                   	ret    

00801537 <ltostr>:

void
ltostr(long value, char *str)
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
  80153a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80153d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801544:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80154b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80154f:	79 13                	jns    801564 <ltostr+0x2d>
	{
		neg = 1;
  801551:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801558:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80155e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801561:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80156c:	99                   	cltd   
  80156d:	f7 f9                	idiv   %ecx
  80156f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801572:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801575:	8d 50 01             	lea    0x1(%eax),%edx
  801578:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80157b:	89 c2                	mov    %eax,%edx
  80157d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801580:	01 d0                	add    %edx,%eax
  801582:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801585:	83 c2 30             	add    $0x30,%edx
  801588:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80158a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80158d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801592:	f7 e9                	imul   %ecx
  801594:	c1 fa 02             	sar    $0x2,%edx
  801597:	89 c8                	mov    %ecx,%eax
  801599:	c1 f8 1f             	sar    $0x1f,%eax
  80159c:	29 c2                	sub    %eax,%edx
  80159e:	89 d0                	mov    %edx,%eax
  8015a0:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8015a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015a6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015ab:	f7 e9                	imul   %ecx
  8015ad:	c1 fa 02             	sar    $0x2,%edx
  8015b0:	89 c8                	mov    %ecx,%eax
  8015b2:	c1 f8 1f             	sar    $0x1f,%eax
  8015b5:	29 c2                	sub    %eax,%edx
  8015b7:	89 d0                	mov    %edx,%eax
  8015b9:	c1 e0 02             	shl    $0x2,%eax
  8015bc:	01 d0                	add    %edx,%eax
  8015be:	01 c0                	add    %eax,%eax
  8015c0:	29 c1                	sub    %eax,%ecx
  8015c2:	89 ca                	mov    %ecx,%edx
  8015c4:	85 d2                	test   %edx,%edx
  8015c6:	75 9c                	jne    801564 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8015c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8015cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d2:	48                   	dec    %eax
  8015d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8015d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015da:	74 3d                	je     801619 <ltostr+0xe2>
		start = 1 ;
  8015dc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015e3:	eb 34                	jmp    801619 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8015e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015eb:	01 d0                	add    %edx,%eax
  8015ed:	8a 00                	mov    (%eax),%al
  8015ef:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f8:	01 c2                	add    %eax,%edx
  8015fa:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801600:	01 c8                	add    %ecx,%eax
  801602:	8a 00                	mov    (%eax),%al
  801604:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801606:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801609:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160c:	01 c2                	add    %eax,%edx
  80160e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801611:	88 02                	mov    %al,(%edx)
		start++ ;
  801613:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801616:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80161f:	7c c4                	jl     8015e5 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801621:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801624:	8b 45 0c             	mov    0xc(%ebp),%eax
  801627:	01 d0                	add    %edx,%eax
  801629:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80162c:	90                   	nop
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
  801632:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801635:	ff 75 08             	pushl  0x8(%ebp)
  801638:	e8 54 fa ff ff       	call   801091 <strlen>
  80163d:	83 c4 04             	add    $0x4,%esp
  801640:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801643:	ff 75 0c             	pushl  0xc(%ebp)
  801646:	e8 46 fa ff ff       	call   801091 <strlen>
  80164b:	83 c4 04             	add    $0x4,%esp
  80164e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801651:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801658:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80165f:	eb 17                	jmp    801678 <strcconcat+0x49>
		final[s] = str1[s] ;
  801661:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801664:	8b 45 10             	mov    0x10(%ebp),%eax
  801667:	01 c2                	add    %eax,%edx
  801669:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80166c:	8b 45 08             	mov    0x8(%ebp),%eax
  80166f:	01 c8                	add    %ecx,%eax
  801671:	8a 00                	mov    (%eax),%al
  801673:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801675:	ff 45 fc             	incl   -0x4(%ebp)
  801678:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80167b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80167e:	7c e1                	jl     801661 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801680:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801687:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80168e:	eb 1f                	jmp    8016af <strcconcat+0x80>
		final[s++] = str2[i] ;
  801690:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801693:	8d 50 01             	lea    0x1(%eax),%edx
  801696:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801699:	89 c2                	mov    %eax,%edx
  80169b:	8b 45 10             	mov    0x10(%ebp),%eax
  80169e:	01 c2                	add    %eax,%edx
  8016a0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a6:	01 c8                	add    %ecx,%eax
  8016a8:	8a 00                	mov    (%eax),%al
  8016aa:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016ac:	ff 45 f8             	incl   -0x8(%ebp)
  8016af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016b5:	7c d9                	jl     801690 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bd:	01 d0                	add    %edx,%eax
  8016bf:	c6 00 00             	movb   $0x0,(%eax)
}
  8016c2:	90                   	nop
  8016c3:	c9                   	leave  
  8016c4:	c3                   	ret    

008016c5 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8016c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8016cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8016d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d4:	8b 00                	mov    (%eax),%eax
  8016d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e0:	01 d0                	add    %edx,%eax
  8016e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016e8:	eb 0c                	jmp    8016f6 <strsplit+0x31>
			*string++ = 0;
  8016ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ed:	8d 50 01             	lea    0x1(%eax),%edx
  8016f0:	89 55 08             	mov    %edx,0x8(%ebp)
  8016f3:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	8a 00                	mov    (%eax),%al
  8016fb:	84 c0                	test   %al,%al
  8016fd:	74 18                	je     801717 <strsplit+0x52>
  8016ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801702:	8a 00                	mov    (%eax),%al
  801704:	0f be c0             	movsbl %al,%eax
  801707:	50                   	push   %eax
  801708:	ff 75 0c             	pushl  0xc(%ebp)
  80170b:	e8 13 fb ff ff       	call   801223 <strchr>
  801710:	83 c4 08             	add    $0x8,%esp
  801713:	85 c0                	test   %eax,%eax
  801715:	75 d3                	jne    8016ea <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	8a 00                	mov    (%eax),%al
  80171c:	84 c0                	test   %al,%al
  80171e:	74 5a                	je     80177a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  801720:	8b 45 14             	mov    0x14(%ebp),%eax
  801723:	8b 00                	mov    (%eax),%eax
  801725:	83 f8 0f             	cmp    $0xf,%eax
  801728:	75 07                	jne    801731 <strsplit+0x6c>
		{
			return 0;
  80172a:	b8 00 00 00 00       	mov    $0x0,%eax
  80172f:	eb 66                	jmp    801797 <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801731:	8b 45 14             	mov    0x14(%ebp),%eax
  801734:	8b 00                	mov    (%eax),%eax
  801736:	8d 48 01             	lea    0x1(%eax),%ecx
  801739:	8b 55 14             	mov    0x14(%ebp),%edx
  80173c:	89 0a                	mov    %ecx,(%edx)
  80173e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801745:	8b 45 10             	mov    0x10(%ebp),%eax
  801748:	01 c2                	add    %eax,%edx
  80174a:	8b 45 08             	mov    0x8(%ebp),%eax
  80174d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80174f:	eb 03                	jmp    801754 <strsplit+0x8f>
			string++;
  801751:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801754:	8b 45 08             	mov    0x8(%ebp),%eax
  801757:	8a 00                	mov    (%eax),%al
  801759:	84 c0                	test   %al,%al
  80175b:	74 8b                	je     8016e8 <strsplit+0x23>
  80175d:	8b 45 08             	mov    0x8(%ebp),%eax
  801760:	8a 00                	mov    (%eax),%al
  801762:	0f be c0             	movsbl %al,%eax
  801765:	50                   	push   %eax
  801766:	ff 75 0c             	pushl  0xc(%ebp)
  801769:	e8 b5 fa ff ff       	call   801223 <strchr>
  80176e:	83 c4 08             	add    $0x8,%esp
  801771:	85 c0                	test   %eax,%eax
  801773:	74 dc                	je     801751 <strsplit+0x8c>
			string++;
	}
  801775:	e9 6e ff ff ff       	jmp    8016e8 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80177a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80177b:	8b 45 14             	mov    0x14(%ebp),%eax
  80177e:	8b 00                	mov    (%eax),%eax
  801780:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801787:	8b 45 10             	mov    0x10(%ebp),%eax
  80178a:	01 d0                	add    %edx,%eax
  80178c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801792:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801797:	c9                   	leave  
  801798:	c3                   	ret    

00801799 <malloc>:
int cnt_mem = 0;
int heap_mem[size_uhmem] = { 0 };
struct hmem heap_size[size_uhmem] = { 0 };
int check = 0;

void* malloc(uint32 size) {
  801799:	55                   	push   %ebp
  80179a:	89 e5                	mov    %esp,%ebp
  80179c:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyNEXTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	//NEXT FIT
	if (sys_isUHeapPlacementStrategyNEXTFIT()) {
  8017a2:	e8 7d 0f 00 00       	call   802724 <sys_isUHeapPlacementStrategyNEXTFIT>
  8017a7:	85 c0                	test   %eax,%eax
  8017a9:	0f 84 6f 03 00 00    	je     801b1e <malloc+0x385>
		size = ROUNDUP(size, PAGE_SIZE);
  8017af:	c7 45 84 00 10 00 00 	movl   $0x1000,-0x7c(%ebp)
  8017b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8017b9:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8017bc:	01 d0                	add    %edx,%eax
  8017be:	48                   	dec    %eax
  8017bf:	89 45 80             	mov    %eax,-0x80(%ebp)
  8017c2:	8b 45 80             	mov    -0x80(%ebp),%eax
  8017c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ca:	f7 75 84             	divl   -0x7c(%ebp)
  8017cd:	8b 45 80             	mov    -0x80(%ebp),%eax
  8017d0:	29 d0                	sub    %edx,%eax
  8017d2:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  8017d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017d9:	74 09                	je     8017e4 <malloc+0x4b>
  8017db:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8017e2:	76 0a                	jbe    8017ee <malloc+0x55>
			return NULL;
  8017e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e9:	e9 4b 09 00 00       	jmp    802139 <malloc+0x9a0>
		}
		// first we can allocate by " Strategy Continues "
		if (ptr_uheap + size <= (uint32) USER_HEAP_MAX && !check) {
  8017ee:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8017f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f7:	01 d0                	add    %edx,%eax
  8017f9:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8017fe:	0f 87 a2 00 00 00    	ja     8018a6 <malloc+0x10d>
  801804:	a1 60 40 98 00       	mov    0x984060,%eax
  801809:	85 c0                	test   %eax,%eax
  80180b:	0f 85 95 00 00 00    	jne    8018a6 <malloc+0x10d>

			void* ret = (void *) ptr_uheap;
  801811:	a1 04 40 80 00       	mov    0x804004,%eax
  801816:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			sys_allocateMem(ptr_uheap, size);
  80181c:	a1 04 40 80 00       	mov    0x804004,%eax
  801821:	83 ec 08             	sub    $0x8,%esp
  801824:	ff 75 08             	pushl  0x8(%ebp)
  801827:	50                   	push   %eax
  801828:	e8 a3 0b 00 00       	call   8023d0 <sys_allocateMem>
  80182d:	83 c4 10             	add    $0x10,%esp

			heap_size[cnt_mem].size = size;
  801830:	a1 40 40 80 00       	mov    0x804040,%eax
  801835:	8b 55 08             	mov    0x8(%ebp),%edx
  801838:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
  80183f:	a1 40 40 80 00       	mov    0x804040,%eax
  801844:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80184a:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
			cnt_mem++;
  801851:	a1 40 40 80 00       	mov    0x804040,%eax
  801856:	40                   	inc    %eax
  801857:	a3 40 40 80 00       	mov    %eax,0x804040
			int i = 0;
  80185c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  801863:	eb 2e                	jmp    801893 <malloc+0xfa>
			{

				heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801865:	a1 04 40 80 00       	mov    0x804004,%eax
  80186a:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] = 1;
  80186f:	c1 e8 0c             	shr    $0xc,%eax
  801872:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  801879:	01 00 00 00 

				ptr_uheap += (uint32) PAGE_SIZE;
  80187d:	a1 04 40 80 00       	mov    0x804004,%eax
  801882:	05 00 10 00 00       	add    $0x1000,%eax
  801887:	a3 04 40 80 00       	mov    %eax,0x804004
			heap_size[cnt_mem].size = size;
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
			cnt_mem++;
			int i = 0;
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  80188c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801896:	3b 45 08             	cmp    0x8(%ebp),%eax
  801899:	72 ca                	jb     801865 <malloc+0xcc>
						/ (uint32) PAGE_SIZE)] = 1;

				ptr_uheap += (uint32) PAGE_SIZE;
			}

			return ret;
  80189b:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8018a1:	e9 93 08 00 00       	jmp    802139 <malloc+0x9a0>

		} else {
			// second we can allocate by " Strategy NEXTFIT "
			void* temp_end = NULL;
  8018a6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

			int check_start = 0;
  8018ad:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			// check first that we used " Strategy Continues " before and not do it again and turn to NEXTFIT
			if (!check) {
  8018b4:	a1 60 40 98 00       	mov    0x984060,%eax
  8018b9:	85 c0                	test   %eax,%eax
  8018bb:	75 1d                	jne    8018da <malloc+0x141>
				ptr_uheap = (uint32) USER_HEAP_START;
  8018bd:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  8018c4:	00 00 80 
				check = 1;
  8018c7:	c7 05 60 40 98 00 01 	movl   $0x1,0x984060
  8018ce:	00 00 00 
				check_start = 1;// to dont use second loop CZ ptr_uheap start from USER_HEAP_START
  8018d1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  8018d8:	eb 08                	jmp    8018e2 <malloc+0x149>
			} else {
				temp_end = (void*) ptr_uheap;
  8018da:	a1 04 40 80 00       	mov    0x804004,%eax
  8018df:	89 45 f0             	mov    %eax,-0x10(%ebp)

			}

			uint32 sz = 0;
  8018e2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
			int f = 0;
  8018e9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			uint32 ptr = ptr_uheap;
  8018f0:	a1 04 40 80 00       	mov    0x804004,%eax
  8018f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  8018f8:	eb 4d                	jmp    801947 <malloc+0x1ae>
				if (sz == size) {
  8018fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018fd:	3b 45 08             	cmp    0x8(%ebp),%eax
  801900:	75 09                	jne    80190b <malloc+0x172>
					f = 1;
  801902:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  801909:	eb 45                	jmp    801950 <malloc+0x1b7>
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  80190b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80190e:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] == 0) {
  801913:	c1 e8 0c             	shr    $0xc,%eax
			while (ptr < (uint32) USER_HEAP_MAX) {
				if (sz == size) {
					f = 1;
					break;
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801916:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  80191d:	85 c0                	test   %eax,%eax
  80191f:	75 10                	jne    801931 <malloc+0x198>
						/ (uint32) PAGE_SIZE)] == 0) {

					sz += PAGE_SIZE;
  801921:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
					ptr += PAGE_SIZE;
  801928:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  80192f:	eb 16                	jmp    801947 <malloc+0x1ae>
				} else {
					sz = 0;
  801931:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
					ptr += PAGE_SIZE;
  801938:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
					ptr_uheap = ptr;
  80193f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801942:	a3 04 40 80 00       	mov    %eax,0x804004

			uint32 sz = 0;
			int f = 0;
			uint32 ptr = ptr_uheap;
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  801947:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  80194e:	76 aa                	jbe    8018fa <malloc+0x161>
					ptr_uheap = ptr;
				}

			}

			if (f) {
  801950:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801954:	0f 84 95 00 00 00    	je     8019ef <malloc+0x256>

				void* ret = (void *) ptr_uheap;
  80195a:	a1 04 40 80 00       	mov    0x804004,%eax
  80195f:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

				sys_allocateMem(ptr_uheap, size);
  801965:	a1 04 40 80 00       	mov    0x804004,%eax
  80196a:	83 ec 08             	sub    $0x8,%esp
  80196d:	ff 75 08             	pushl  0x8(%ebp)
  801970:	50                   	push   %eax
  801971:	e8 5a 0a 00 00       	call   8023d0 <sys_allocateMem>
  801976:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  801979:	a1 40 40 80 00       	mov    0x804040,%eax
  80197e:	8b 55 08             	mov    0x8(%ebp),%edx
  801981:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801988:	a1 40 40 80 00       	mov    0x804040,%eax
  80198d:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801993:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
				cnt_mem++;
  80199a:	a1 40 40 80 00       	mov    0x804040,%eax
  80199f:	40                   	inc    %eax
  8019a0:	a3 40 40 80 00       	mov    %eax,0x804040
				int i = 0;
  8019a5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  8019ac:	eb 2e                	jmp    8019dc <malloc+0x243>
				{

					heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8019ae:	a1 04 40 80 00       	mov    0x804004,%eax
  8019b3:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  8019b8:	c1 e8 0c             	shr    $0xc,%eax
  8019bb:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  8019c2:	01 00 00 00 

					ptr_uheap += (uint32) PAGE_SIZE;
  8019c6:	a1 04 40 80 00       	mov    0x804004,%eax
  8019cb:	05 00 10 00 00       	add    $0x1000,%eax
  8019d0:	a3 04 40 80 00       	mov    %eax,0x804004
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
				cnt_mem++;
				int i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  8019d5:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  8019dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019df:	3b 45 08             	cmp    0x8(%ebp),%eax
  8019e2:	72 ca                	jb     8019ae <malloc+0x215>
							/ (uint32) PAGE_SIZE)] = 1;

					ptr_uheap += (uint32) PAGE_SIZE;
				}

				return ret;
  8019e4:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8019ea:	e9 4a 07 00 00       	jmp    802139 <malloc+0x9a0>

			} else {

				if (check_start) {
  8019ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019f3:	74 0a                	je     8019ff <malloc+0x266>

					return NULL;
  8019f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8019fa:	e9 3a 07 00 00       	jmp    802139 <malloc+0x9a0>
				}

//////////////back loop////////////////

				uint32 sz = 0;
  8019ff:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
				int f = 0;
  801a06:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				uint32 ptr = USER_HEAP_START;
  801a0d:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
				ptr_uheap = USER_HEAP_START;
  801a14:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  801a1b:	00 00 80 
				while (ptr < (uint32) temp_end) {
  801a1e:	eb 4d                	jmp    801a6d <malloc+0x2d4>
					if (sz == size) {
  801a20:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a23:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a26:	75 09                	jne    801a31 <malloc+0x298>
						f = 1;
  801a28:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
						break;
  801a2f:	eb 44                	jmp    801a75 <malloc+0x2dc>
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801a31:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801a34:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] == 0) {
  801a39:	c1 e8 0c             	shr    $0xc,%eax
				while (ptr < (uint32) temp_end) {
					if (sz == size) {
						f = 1;
						break;
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801a3c:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  801a43:	85 c0                	test   %eax,%eax
  801a45:	75 10                	jne    801a57 <malloc+0x2be>
							/ (uint32) PAGE_SIZE)] == 0) {

						sz += PAGE_SIZE;
  801a47:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801a4e:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
  801a55:	eb 16                	jmp    801a6d <malloc+0x2d4>
					} else {
						sz = 0;
  801a57:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801a5e:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
						ptr_uheap = ptr;
  801a65:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801a68:	a3 04 40 80 00       	mov    %eax,0x804004

				uint32 sz = 0;
				int f = 0;
				uint32 ptr = USER_HEAP_START;
				ptr_uheap = USER_HEAP_START;
				while (ptr < (uint32) temp_end) {
  801a6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a70:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801a73:	72 ab                	jb     801a20 <malloc+0x287>
						ptr_uheap = ptr;
					}

				}

				if (f) {
  801a75:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801a79:	0f 84 95 00 00 00    	je     801b14 <malloc+0x37b>

					void* ret = (void *) ptr_uheap;
  801a7f:	a1 04 40 80 00       	mov    0x804004,%eax
  801a84:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

					sys_allocateMem(ptr_uheap, size);
  801a8a:	a1 04 40 80 00       	mov    0x804004,%eax
  801a8f:	83 ec 08             	sub    $0x8,%esp
  801a92:	ff 75 08             	pushl  0x8(%ebp)
  801a95:	50                   	push   %eax
  801a96:	e8 35 09 00 00       	call   8023d0 <sys_allocateMem>
  801a9b:	83 c4 10             	add    $0x10,%esp

					heap_size[cnt_mem].size = size;
  801a9e:	a1 40 40 80 00       	mov    0x804040,%eax
  801aa3:	8b 55 08             	mov    0x8(%ebp),%edx
  801aa6:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801aad:	a1 40 40 80 00       	mov    0x804040,%eax
  801ab2:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801ab8:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
					cnt_mem++;
  801abf:	a1 40 40 80 00       	mov    0x804040,%eax
  801ac4:	40                   	inc    %eax
  801ac5:	a3 40 40 80 00       	mov    %eax,0x804040
					int i = 0;
  801aca:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

					for (; i < size; i += PAGE_SIZE)
  801ad1:	eb 2e                	jmp    801b01 <malloc+0x368>
					{

						heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801ad3:	a1 04 40 80 00       	mov    0x804004,%eax
  801ad8:	05 00 00 00 80       	add    $0x80000000,%eax
								/ (uint32) PAGE_SIZE)] = 1;
  801add:	c1 e8 0c             	shr    $0xc,%eax
  801ae0:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  801ae7:	01 00 00 00 

						ptr_uheap += (uint32) PAGE_SIZE;
  801aeb:	a1 04 40 80 00       	mov    0x804004,%eax
  801af0:	05 00 10 00 00       	add    $0x1000,%eax
  801af5:	a3 04 40 80 00       	mov    %eax,0x804004
					heap_size[cnt_mem].size = size;
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
					cnt_mem++;
					int i = 0;

					for (; i < size; i += PAGE_SIZE)
  801afa:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  801b01:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801b04:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b07:	72 ca                	jb     801ad3 <malloc+0x33a>
								/ (uint32) PAGE_SIZE)] = 1;

						ptr_uheap += (uint32) PAGE_SIZE;
					}

					return ret;
  801b09:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801b0f:	e9 25 06 00 00       	jmp    802139 <malloc+0x9a0>

				} else {

					return NULL;
  801b14:	b8 00 00 00 00       	mov    $0x0,%eax
  801b19:	e9 1b 06 00 00       	jmp    802139 <malloc+0x9a0>

		}

	}

	else if (sys_isUHeapPlacementStrategyBESTFIT()) {
  801b1e:	e8 d0 0b 00 00       	call   8026f3 <sys_isUHeapPlacementStrategyBESTFIT>
  801b23:	85 c0                	test   %eax,%eax
  801b25:	0f 84 ba 01 00 00    	je     801ce5 <malloc+0x54c>

		size = ROUNDUP(size, PAGE_SIZE);
  801b2b:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  801b32:	10 00 00 
  801b35:	8b 55 08             	mov    0x8(%ebp),%edx
  801b38:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  801b3e:	01 d0                	add    %edx,%eax
  801b40:	48                   	dec    %eax
  801b41:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  801b47:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801b4d:	ba 00 00 00 00       	mov    $0x0,%edx
  801b52:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  801b58:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801b5e:	29 d0                	sub    %edx,%eax
  801b60:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801b63:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b67:	74 09                	je     801b72 <malloc+0x3d9>
  801b69:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801b70:	76 0a                	jbe    801b7c <malloc+0x3e3>
			return NULL;
  801b72:	b8 00 00 00 00       	mov    $0x0,%eax
  801b77:	e9 bd 05 00 00       	jmp    802139 <malloc+0x9a0>
		}
		uint32 ptr = (uint32) USER_HEAP_START;
  801b7c:	c7 45 c8 00 00 00 80 	movl   $0x80000000,-0x38(%ebp)
		uint32 temp = 0;
  801b83:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		uint32 min_sz = size_uhmem + 1;
  801b8a:	c7 45 c0 01 00 02 00 	movl   $0x20001,-0x40(%ebp)
		uint32 count = 0;
  801b91:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
		int i = 0;
  801b98:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba2:	c1 e8 0c             	shr    $0xc,%eax
  801ba5:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801bab:	e9 80 00 00 00       	jmp    801c30 <malloc+0x497>

			if (heap_mem[i] == 0) {
  801bb0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801bb3:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  801bba:	85 c0                	test   %eax,%eax
  801bbc:	75 0c                	jne    801bca <malloc+0x431>

				count++;
  801bbe:	ff 45 bc             	incl   -0x44(%ebp)
				ptr += PAGE_SIZE;
  801bc1:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801bc8:	eb 2d                	jmp    801bf7 <malloc+0x45e>
			} else {
				if (num_p <= count && min_sz > count) {
  801bca:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801bd0:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801bd3:	77 14                	ja     801be9 <malloc+0x450>
  801bd5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801bd8:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801bdb:	76 0c                	jbe    801be9 <malloc+0x450>

					min_sz = count;
  801bdd:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801be0:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801be3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801be6:	89 45 c4             	mov    %eax,-0x3c(%ebp)

				}
				count = 0;
  801be9:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
				ptr += PAGE_SIZE;
  801bf0:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
			}

			if (i == size_uhmem - 1) {
  801bf7:	81 7d b8 ff ff 01 00 	cmpl   $0x1ffff,-0x48(%ebp)
  801bfe:	75 2d                	jne    801c2d <malloc+0x494>

				if (num_p <= count && min_sz > count) {
  801c00:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801c06:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801c09:	77 22                	ja     801c2d <malloc+0x494>
  801c0b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c0e:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801c11:	76 1a                	jbe    801c2d <malloc+0x494>

					min_sz = count;
  801c13:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801c16:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801c19:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c1c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
					count = 0;
  801c1f:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
					ptr += PAGE_SIZE;
  801c26:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801c2d:	ff 45 b8             	incl   -0x48(%ebp)
  801c30:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801c33:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801c38:	0f 86 72 ff ff ff    	jbe    801bb0 <malloc+0x417>

			}

		}

		if (num_p > min_sz || temp == 0) {
  801c3e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801c44:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  801c47:	77 06                	ja     801c4f <malloc+0x4b6>
  801c49:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801c4d:	75 0a                	jne    801c59 <malloc+0x4c0>
			return NULL;
  801c4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c54:	e9 e0 04 00 00       	jmp    802139 <malloc+0x9a0>

		}

		temp = temp - (PAGE_SIZE * min_sz);
  801c59:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c5c:	c1 e0 0c             	shl    $0xc,%eax
  801c5f:	29 45 c4             	sub    %eax,-0x3c(%ebp)
		void* ret = (void*) temp;
  801c62:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801c65:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)

		sys_allocateMem(temp, size);
  801c6b:	83 ec 08             	sub    $0x8,%esp
  801c6e:	ff 75 08             	pushl  0x8(%ebp)
  801c71:	ff 75 c4             	pushl  -0x3c(%ebp)
  801c74:	e8 57 07 00 00       	call   8023d0 <sys_allocateMem>
  801c79:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801c7c:	a1 40 40 80 00       	mov    0x804040,%eax
  801c81:	8b 55 08             	mov    0x8(%ebp),%edx
  801c84:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801c8b:	a1 40 40 80 00       	mov    0x804040,%eax
  801c90:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801c93:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
		cnt_mem++;
  801c9a:	a1 40 40 80 00       	mov    0x804040,%eax
  801c9f:	40                   	inc    %eax
  801ca0:	a3 40 40 80 00       	mov    %eax,0x804040
		i = 0;
  801ca5:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801cac:	eb 24                	jmp    801cd2 <malloc+0x539>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801cae:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801cb1:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801cb6:	c1 e8 0c             	shr    $0xc,%eax
  801cb9:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  801cc0:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801cc4:	81 45 c4 00 10 00 00 	addl   $0x1000,-0x3c(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801ccb:	81 45 b8 00 10 00 00 	addl   $0x1000,-0x48(%ebp)
  801cd2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801cd5:	3b 45 08             	cmp    0x8(%ebp),%eax
  801cd8:	72 d4                	jb     801cae <malloc+0x515>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801cda:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801ce0:	e9 54 04 00 00       	jmp    802139 <malloc+0x9a0>

	} else if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801ce5:	e8 d8 09 00 00       	call   8026c2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801cea:	85 c0                	test   %eax,%eax
  801cec:	0f 84 88 01 00 00    	je     801e7a <malloc+0x6e1>

		size = ROUNDUP(size, PAGE_SIZE);
  801cf2:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  801cf9:	10 00 00 
  801cfc:	8b 55 08             	mov    0x8(%ebp),%edx
  801cff:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  801d05:	01 d0                	add    %edx,%eax
  801d07:	48                   	dec    %eax
  801d08:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  801d0e:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801d14:	ba 00 00 00 00       	mov    $0x0,%edx
  801d19:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  801d1f:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801d25:	29 d0                	sub    %edx,%eax
  801d27:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801d2a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d2e:	74 09                	je     801d39 <malloc+0x5a0>
  801d30:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801d37:	76 0a                	jbe    801d43 <malloc+0x5aa>
			return NULL;
  801d39:	b8 00 00 00 00       	mov    $0x0,%eax
  801d3e:	e9 f6 03 00 00       	jmp    802139 <malloc+0x9a0>
		}

		uint32 ptr = (uint32) USER_HEAP_START;
  801d43:	c7 45 b4 00 00 00 80 	movl   $0x80000000,-0x4c(%ebp)
		uint32 temp = 0;
  801d4a:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
		uint32 found = 0;
  801d51:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		uint32 count = 0;
  801d58:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
		int i = 0;
  801d5f:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801d66:	8b 45 08             	mov    0x8(%ebp),%eax
  801d69:	c1 e8 0c             	shr    $0xc,%eax
  801d6c:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

		for (; i < size_uhmem; i++) {
  801d72:	eb 5a                	jmp    801dce <malloc+0x635>

			if (heap_mem[i] == 0) {
  801d74:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801d77:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  801d7e:	85 c0                	test   %eax,%eax
  801d80:	75 0c                	jne    801d8e <malloc+0x5f5>

				count++;
  801d82:	ff 45 a8             	incl   -0x58(%ebp)
				ptr += PAGE_SIZE;
  801d85:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
  801d8c:	eb 22                	jmp    801db0 <malloc+0x617>
			} else {
				if (num_p <= count) {
  801d8e:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801d94:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801d97:	77 09                	ja     801da2 <malloc+0x609>

					found = 1;
  801d99:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)

					break;
  801da0:	eb 36                	jmp    801dd8 <malloc+0x63f>
				}
				count = 0;
  801da2:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
				ptr += PAGE_SIZE;
  801da9:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
			}

			if (i == size_uhmem - 1) {
  801db0:	81 7d a4 ff ff 01 00 	cmpl   $0x1ffff,-0x5c(%ebp)
  801db7:	75 12                	jne    801dcb <malloc+0x632>

				if (num_p <= count) {
  801db9:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801dbf:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801dc2:	77 07                	ja     801dcb <malloc+0x632>

					found = 1;
  801dc4:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
		uint32 found = 0;
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		for (; i < size_uhmem; i++) {
  801dcb:	ff 45 a4             	incl   -0x5c(%ebp)
  801dce:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801dd1:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801dd6:	76 9c                	jbe    801d74 <malloc+0x5db>

			}

		}

		if (!found) {
  801dd8:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  801ddc:	75 0a                	jne    801de8 <malloc+0x64f>
			return NULL;
  801dde:	b8 00 00 00 00       	mov    $0x0,%eax
  801de3:	e9 51 03 00 00       	jmp    802139 <malloc+0x9a0>

		}

		temp = ptr;
  801de8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801deb:	89 45 b0             	mov    %eax,-0x50(%ebp)
		temp = temp - (PAGE_SIZE * count);
  801dee:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801df1:	c1 e0 0c             	shl    $0xc,%eax
  801df4:	29 45 b0             	sub    %eax,-0x50(%ebp)
		void* ret = (void*) temp;
  801df7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801dfa:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)

		sys_allocateMem(temp, size);
  801e00:	83 ec 08             	sub    $0x8,%esp
  801e03:	ff 75 08             	pushl  0x8(%ebp)
  801e06:	ff 75 b0             	pushl  -0x50(%ebp)
  801e09:	e8 c2 05 00 00       	call   8023d0 <sys_allocateMem>
  801e0e:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801e11:	a1 40 40 80 00       	mov    0x804040,%eax
  801e16:	8b 55 08             	mov    0x8(%ebp),%edx
  801e19:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801e20:	a1 40 40 80 00       	mov    0x804040,%eax
  801e25:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801e28:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
		cnt_mem++;
  801e2f:	a1 40 40 80 00       	mov    0x804040,%eax
  801e34:	40                   	inc    %eax
  801e35:	a3 40 40 80 00       	mov    %eax,0x804040
		i = 0;
  801e3a:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801e41:	eb 24                	jmp    801e67 <malloc+0x6ce>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801e43:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801e46:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801e4b:	c1 e8 0c             	shr    $0xc,%eax
  801e4e:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  801e55:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801e59:	81 45 b0 00 10 00 00 	addl   $0x1000,-0x50(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801e60:	81 45 a4 00 10 00 00 	addl   $0x1000,-0x5c(%ebp)
  801e67:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801e6a:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e6d:	72 d4                	jb     801e43 <malloc+0x6aa>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801e6f:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  801e75:	e9 bf 02 00 00       	jmp    802139 <malloc+0x9a0>

	}
	else if(sys_isUHeapPlacementStrategyWORSTFIT())
  801e7a:	e8 d6 08 00 00       	call   802755 <sys_isUHeapPlacementStrategyWORSTFIT>
  801e7f:	85 c0                	test   %eax,%eax
  801e81:	0f 84 ba 01 00 00    	je     802041 <malloc+0x8a8>
	{
		size = ROUNDUP(size, PAGE_SIZE);
  801e87:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  801e8e:	10 00 00 
  801e91:	8b 55 08             	mov    0x8(%ebp),%edx
  801e94:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  801e9a:	01 d0                	add    %edx,%eax
  801e9c:	48                   	dec    %eax
  801e9d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  801ea3:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  801ea9:	ba 00 00 00 00       	mov    $0x0,%edx
  801eae:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  801eb4:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  801eba:	29 d0                	sub    %edx,%eax
  801ebc:	89 45 08             	mov    %eax,0x8(%ebp)

				if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801ebf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ec3:	74 09                	je     801ece <malloc+0x735>
  801ec5:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801ecc:	76 0a                	jbe    801ed8 <malloc+0x73f>
					return NULL;
  801ece:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed3:	e9 61 02 00 00       	jmp    802139 <malloc+0x9a0>
				}
				uint32 ptr = (uint32) USER_HEAP_START;
  801ed8:	c7 45 a0 00 00 00 80 	movl   $0x80000000,-0x60(%ebp)
				uint32 temp = 0;
  801edf:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
				uint32 max_sz = -1;
  801ee6:	c7 45 98 ff ff ff ff 	movl   $0xffffffff,-0x68(%ebp)
				uint32 count = 0;
  801eed:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
				int i = 0;
  801ef4:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				uint32 num_p = size / PAGE_SIZE;
  801efb:	8b 45 08             	mov    0x8(%ebp),%eax
  801efe:	c1 e8 0c             	shr    $0xc,%eax
  801f01:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  801f07:	e9 80 00 00 00       	jmp    801f8c <malloc+0x7f3>

					if (heap_mem[i] == 0) {
  801f0c:	8b 45 90             	mov    -0x70(%ebp),%eax
  801f0f:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  801f16:	85 c0                	test   %eax,%eax
  801f18:	75 0c                	jne    801f26 <malloc+0x78d>

						count++;
  801f1a:	ff 45 94             	incl   -0x6c(%ebp)
						ptr += PAGE_SIZE;
  801f1d:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
  801f24:	eb 2d                	jmp    801f53 <malloc+0x7ba>
					} else {
						if (num_p <= count && max_sz < count) {
  801f26:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801f2c:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801f2f:	77 14                	ja     801f45 <malloc+0x7ac>
  801f31:	8b 45 98             	mov    -0x68(%ebp),%eax
  801f34:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801f37:	73 0c                	jae    801f45 <malloc+0x7ac>

							max_sz = count;
  801f39:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801f3c:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  801f3f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801f42:	89 45 9c             	mov    %eax,-0x64(%ebp)

						}
						count = 0;
  801f45:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
						ptr += PAGE_SIZE;
  801f4c:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
					}

					if (i == size_uhmem - 1) {
  801f53:	81 7d 90 ff ff 01 00 	cmpl   $0x1ffff,-0x70(%ebp)
  801f5a:	75 2d                	jne    801f89 <malloc+0x7f0>

						if (num_p <= count && max_sz > count) {
  801f5c:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801f62:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801f65:	77 22                	ja     801f89 <malloc+0x7f0>
  801f67:	8b 45 98             	mov    -0x68(%ebp),%eax
  801f6a:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801f6d:	76 1a                	jbe    801f89 <malloc+0x7f0>

							max_sz = count;
  801f6f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801f72:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  801f75:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801f78:	89 45 9c             	mov    %eax,-0x64(%ebp)
							count = 0;
  801f7b:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
							ptr += PAGE_SIZE;
  801f82:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
				uint32 count = 0;
				int i = 0;
				uint32 num_p = size / PAGE_SIZE;

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  801f89:	ff 45 90             	incl   -0x70(%ebp)
  801f8c:	8b 45 90             	mov    -0x70(%ebp),%eax
  801f8f:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801f94:	0f 86 72 ff ff ff    	jbe    801f0c <malloc+0x773>

					}

				}

				if (num_p > max_sz || temp == 0) {
  801f9a:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801fa0:	3b 45 98             	cmp    -0x68(%ebp),%eax
  801fa3:	77 06                	ja     801fab <malloc+0x812>
  801fa5:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  801fa9:	75 0a                	jne    801fb5 <malloc+0x81c>
					return NULL;
  801fab:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb0:	e9 84 01 00 00       	jmp    802139 <malloc+0x9a0>

				}

				temp = temp - (PAGE_SIZE * max_sz);
  801fb5:	8b 45 98             	mov    -0x68(%ebp),%eax
  801fb8:	c1 e0 0c             	shl    $0xc,%eax
  801fbb:	29 45 9c             	sub    %eax,-0x64(%ebp)
				void* ret = (void*) temp;
  801fbe:	8b 45 9c             	mov    -0x64(%ebp),%eax
  801fc1:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

				sys_allocateMem(temp, size);
  801fc7:	83 ec 08             	sub    $0x8,%esp
  801fca:	ff 75 08             	pushl  0x8(%ebp)
  801fcd:	ff 75 9c             	pushl  -0x64(%ebp)
  801fd0:	e8 fb 03 00 00       	call   8023d0 <sys_allocateMem>
  801fd5:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  801fd8:	a1 40 40 80 00       	mov    0x804040,%eax
  801fdd:	8b 55 08             	mov    0x8(%ebp),%edx
  801fe0:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
				heap_size[cnt_mem].vir = (void*) temp;
  801fe7:	a1 40 40 80 00       	mov    0x804040,%eax
  801fec:	8b 55 9c             	mov    -0x64(%ebp),%edx
  801fef:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
				cnt_mem++;
  801ff6:	a1 40 40 80 00       	mov    0x804040,%eax
  801ffb:	40                   	inc    %eax
  801ffc:	a3 40 40 80 00       	mov    %eax,0x804040
				i = 0;
  802001:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  802008:	eb 24                	jmp    80202e <malloc+0x895>
				{

					heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  80200a:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80200d:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  802012:	c1 e8 0c             	shr    $0xc,%eax
  802015:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  80201c:	01 00 00 00 

					temp += (uint32) PAGE_SIZE;
  802020:	81 45 9c 00 10 00 00 	addl   $0x1000,-0x64(%ebp)
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) temp;
				cnt_mem++;
				i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  802027:	81 45 90 00 10 00 00 	addl   $0x1000,-0x70(%ebp)
  80202e:	8b 45 90             	mov    -0x70(%ebp),%eax
  802031:	3b 45 08             	cmp    0x8(%ebp),%eax
  802034:	72 d4                	jb     80200a <malloc+0x871>

					temp += (uint32) PAGE_SIZE;
				}

				//cprintf("\n size = %d.........vir= %d  \n",num_p,((uint32) ret-USER_HEAP_START)/PAGE_SIZE);
				return ret;
  802036:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  80203c:	e9 f8 00 00 00       	jmp    802139 <malloc+0x9a0>

	}
// this is to make malloc is work
	void* ret = NULL;
  802041:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
	size = ROUNDUP(size, PAGE_SIZE);
  802048:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  80204f:	10 00 00 
  802052:	8b 55 08             	mov    0x8(%ebp),%edx
  802055:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  80205b:	01 d0                	add    %edx,%eax
  80205d:	48                   	dec    %eax
  80205e:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  802064:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  80206a:	ba 00 00 00 00       	mov    $0x0,%edx
  80206f:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  802075:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  80207b:	29 d0                	sub    %edx,%eax
  80207d:	89 45 08             	mov    %eax,0x8(%ebp)

	if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  802080:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802084:	74 09                	je     80208f <malloc+0x8f6>
  802086:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80208d:	76 0a                	jbe    802099 <malloc+0x900>
		return NULL;
  80208f:	b8 00 00 00 00       	mov    $0x0,%eax
  802094:	e9 a0 00 00 00       	jmp    802139 <malloc+0x9a0>
	}

	if (ptr_uheap + size <= (uint32) USER_HEAP_MAX) {
  802099:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80209f:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a2:	01 d0                	add    %edx,%eax
  8020a4:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8020a9:	0f 87 87 00 00 00    	ja     802136 <malloc+0x99d>

		ret = (void *) ptr_uheap;
  8020af:	a1 04 40 80 00       	mov    0x804004,%eax
  8020b4:	89 45 8c             	mov    %eax,-0x74(%ebp)
		sys_allocateMem(ptr_uheap, size);
  8020b7:	a1 04 40 80 00       	mov    0x804004,%eax
  8020bc:	83 ec 08             	sub    $0x8,%esp
  8020bf:	ff 75 08             	pushl  0x8(%ebp)
  8020c2:	50                   	push   %eax
  8020c3:	e8 08 03 00 00       	call   8023d0 <sys_allocateMem>
  8020c8:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  8020cb:	a1 40 40 80 00       	mov    0x804040,%eax
  8020d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8020d3:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8020da:	a1 40 40 80 00       	mov    0x804040,%eax
  8020df:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8020e5:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
		cnt_mem++;
  8020ec:	a1 40 40 80 00       	mov    0x804040,%eax
  8020f1:	40                   	inc    %eax
  8020f2:	a3 40 40 80 00       	mov    %eax,0x804040
		int i = 0;
  8020f7:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)

		for (; i < size; i += PAGE_SIZE)
  8020fe:	eb 2e                	jmp    80212e <malloc+0x995>
		{

			heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  802100:	a1 04 40 80 00       	mov    0x804004,%eax
  802105:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  80210a:	c1 e8 0c             	shr    $0xc,%eax
  80210d:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  802114:	01 00 00 00 

			ptr_uheap += (uint32) PAGE_SIZE;
  802118:	a1 04 40 80 00       	mov    0x804004,%eax
  80211d:	05 00 10 00 00       	add    $0x1000,%eax
  802122:	a3 04 40 80 00       	mov    %eax,0x804004
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
		cnt_mem++;
		int i = 0;

		for (; i < size; i += PAGE_SIZE)
  802127:	81 45 88 00 10 00 00 	addl   $0x1000,-0x78(%ebp)
  80212e:	8b 45 88             	mov    -0x78(%ebp),%eax
  802131:	3b 45 08             	cmp    0x8(%ebp),%eax
  802134:	72 ca                	jb     802100 <malloc+0x967>
					/ (uint32) PAGE_SIZE)] = 1;

			ptr_uheap += (uint32) PAGE_SIZE;
		}
	}
	return ret;
  802136:	8b 45 8c             	mov    -0x74(%ebp),%eax

	//TODO: [PROJECT 2016 - BONUS2] Apply FIRST FIT and WORST FIT policies

//return 0;

}
  802139:	c9                   	leave  
  80213a:	c3                   	ret    

0080213b <free>:
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address) {
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
  80213e:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
  802141:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; inx < cnt_mem; inx++) {
  802148:	e9 c1 00 00 00       	jmp    80220e <free+0xd3>
		if (heap_size[inx].vir == virtual_address) {
  80214d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802150:	8b 04 c5 60 40 88 00 	mov    0x884060(,%eax,8),%eax
  802157:	3b 45 08             	cmp    0x8(%ebp),%eax
  80215a:	0f 85 ab 00 00 00    	jne    80220b <free+0xd0>

			if (heap_size[inx].size == 0) {
  802160:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802163:	8b 04 c5 64 40 88 00 	mov    0x884064(,%eax,8),%eax
  80216a:	85 c0                	test   %eax,%eax
  80216c:	75 21                	jne    80218f <free+0x54>
				heap_size[inx].size = 0;
  80216e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802171:	c7 04 c5 64 40 88 00 	movl   $0x0,0x884064(,%eax,8)
  802178:	00 00 00 00 
				heap_size[inx].vir = NULL;
  80217c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217f:	c7 04 c5 60 40 88 00 	movl   $0x0,0x884060(,%eax,8)
  802186:	00 00 00 00 
				return;
  80218a:	e9 8d 00 00 00       	jmp    80221c <free+0xe1>

			}

			sys_freeMem((uint32) virtual_address, heap_size[inx].size);
  80218f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802192:	8b 14 c5 64 40 88 00 	mov    0x884064(,%eax,8),%edx
  802199:	8b 45 08             	mov    0x8(%ebp),%eax
  80219c:	83 ec 08             	sub    $0x8,%esp
  80219f:	52                   	push   %edx
  8021a0:	50                   	push   %eax
  8021a1:	e8 0e 02 00 00       	call   8023b4 <sys_freeMem>
  8021a6:	83 c4 10             	add    $0x10,%esp

			int i = 0;
  8021a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
  8021b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  8021b6:	eb 24                	jmp    8021dc <free+0xa1>
			{
				heap_mem[(int) (((uint32) va - USER_HEAP_START) / PAGE_SIZE)] =
  8021b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021bb:	05 00 00 00 80       	add    $0x80000000,%eax
  8021c0:	c1 e8 0c             	shr    $0xc,%eax
  8021c3:	c7 04 85 60 40 80 00 	movl   $0x0,0x804060(,%eax,4)
  8021ca:	00 00 00 00 
						0;

				va += PAGE_SIZE;
  8021ce:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
			sys_freeMem((uint32) virtual_address, heap_size[inx].size);

			int i = 0;
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  8021d5:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  8021dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021df:	8b 14 c5 64 40 88 00 	mov    0x884064(,%eax,8),%edx
  8021e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e9:	39 c2                	cmp    %eax,%edx
  8021eb:	77 cb                	ja     8021b8 <free+0x7d>

				va += PAGE_SIZE;

			}

			heap_size[inx].size = 0;
  8021ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f0:	c7 04 c5 64 40 88 00 	movl   $0x0,0x884064(,%eax,8)
  8021f7:	00 00 00 00 
			heap_size[inx].vir = NULL;
  8021fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fe:	c7 04 c5 60 40 88 00 	movl   $0x0,0x884060(,%eax,8)
  802205:	00 00 00 00 
			break;
  802209:	eb 11                	jmp    80221c <free+0xe1>
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
	for (; inx < cnt_mem; inx++) {
  80220b:	ff 45 f4             	incl   -0xc(%ebp)
  80220e:	a1 40 40 80 00       	mov    0x804040,%eax
  802213:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  802216:	0f 8c 31 ff ff ff    	jl     80214d <free+0x12>
	}

	//get the size of the given allocation using its address
	//you need to call sys_freeMem()

}
  80221c:	c9                   	leave  
  80221d:	c3                   	ret    

0080221e <realloc>:
//  Hint: you may need to use the sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size) {
  80221e:	55                   	push   %ebp
  80221f:	89 e5                	mov    %esp,%ebp
  802221:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2016 - BONUS4] realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802224:	83 ec 04             	sub    $0x4,%esp
  802227:	68 24 30 80 00       	push   $0x803024
  80222c:	68 1c 02 00 00       	push   $0x21c
  802231:	68 4a 30 80 00       	push   $0x80304a
  802236:	e8 aa e4 ff ff       	call   8006e5 <_panic>

0080223b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80223b:	55                   	push   %ebp
  80223c:	89 e5                	mov    %esp,%ebp
  80223e:	57                   	push   %edi
  80223f:	56                   	push   %esi
  802240:	53                   	push   %ebx
  802241:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802244:	8b 45 08             	mov    0x8(%ebp),%eax
  802247:	8b 55 0c             	mov    0xc(%ebp),%edx
  80224a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80224d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802250:	8b 7d 18             	mov    0x18(%ebp),%edi
  802253:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802256:	cd 30                	int    $0x30
  802258:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80225b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80225e:	83 c4 10             	add    $0x10,%esp
  802261:	5b                   	pop    %ebx
  802262:	5e                   	pop    %esi
  802263:	5f                   	pop    %edi
  802264:	5d                   	pop    %ebp
  802265:	c3                   	ret    

00802266 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  802266:	55                   	push   %ebp
  802267:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  802269:	8b 45 08             	mov    0x8(%ebp),%eax
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	ff 75 0c             	pushl  0xc(%ebp)
  802275:	50                   	push   %eax
  802276:	6a 00                	push   $0x0
  802278:	e8 be ff ff ff       	call   80223b <syscall>
  80227d:	83 c4 18             	add    $0x18,%esp
}
  802280:	90                   	nop
  802281:	c9                   	leave  
  802282:	c3                   	ret    

00802283 <sys_cgetc>:

int
sys_cgetc(void)
{
  802283:	55                   	push   %ebp
  802284:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	6a 00                	push   $0x0
  802290:	6a 01                	push   $0x1
  802292:	e8 a4 ff ff ff       	call   80223b <syscall>
  802297:	83 c4 18             	add    $0x18,%esp
}
  80229a:	c9                   	leave  
  80229b:	c3                   	ret    

0080229c <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  80229c:	55                   	push   %ebp
  80229d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80229f:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	6a 00                	push   $0x0
  8022aa:	50                   	push   %eax
  8022ab:	6a 03                	push   $0x3
  8022ad:	e8 89 ff ff ff       	call   80223b <syscall>
  8022b2:	83 c4 18             	add    $0x18,%esp
}
  8022b5:	c9                   	leave  
  8022b6:	c3                   	ret    

008022b7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8022b7:	55                   	push   %ebp
  8022b8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 02                	push   $0x2
  8022c6:	e8 70 ff ff ff       	call   80223b <syscall>
  8022cb:	83 c4 18             	add    $0x18,%esp
}
  8022ce:	c9                   	leave  
  8022cf:	c3                   	ret    

008022d0 <sys_env_exit>:

void sys_env_exit(void)
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 04                	push   $0x4
  8022df:	e8 57 ff ff ff       	call   80223b <syscall>
  8022e4:	83 c4 18             	add    $0x18,%esp
}
  8022e7:	90                   	nop
  8022e8:	c9                   	leave  
  8022e9:	c3                   	ret    

008022ea <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8022ea:	55                   	push   %ebp
  8022eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8022ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f3:	6a 00                	push   $0x0
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 00                	push   $0x0
  8022f9:	52                   	push   %edx
  8022fa:	50                   	push   %eax
  8022fb:	6a 05                	push   $0x5
  8022fd:	e8 39 ff ff ff       	call   80223b <syscall>
  802302:	83 c4 18             	add    $0x18,%esp
}
  802305:	c9                   	leave  
  802306:	c3                   	ret    

00802307 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802307:	55                   	push   %ebp
  802308:	89 e5                	mov    %esp,%ebp
  80230a:	56                   	push   %esi
  80230b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80230c:	8b 75 18             	mov    0x18(%ebp),%esi
  80230f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802312:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802315:	8b 55 0c             	mov    0xc(%ebp),%edx
  802318:	8b 45 08             	mov    0x8(%ebp),%eax
  80231b:	56                   	push   %esi
  80231c:	53                   	push   %ebx
  80231d:	51                   	push   %ecx
  80231e:	52                   	push   %edx
  80231f:	50                   	push   %eax
  802320:	6a 06                	push   $0x6
  802322:	e8 14 ff ff ff       	call   80223b <syscall>
  802327:	83 c4 18             	add    $0x18,%esp
}
  80232a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80232d:	5b                   	pop    %ebx
  80232e:	5e                   	pop    %esi
  80232f:	5d                   	pop    %ebp
  802330:	c3                   	ret    

00802331 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802331:	55                   	push   %ebp
  802332:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802334:	8b 55 0c             	mov    0xc(%ebp),%edx
  802337:	8b 45 08             	mov    0x8(%ebp),%eax
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	52                   	push   %edx
  802341:	50                   	push   %eax
  802342:	6a 07                	push   $0x7
  802344:	e8 f2 fe ff ff       	call   80223b <syscall>
  802349:	83 c4 18             	add    $0x18,%esp
}
  80234c:	c9                   	leave  
  80234d:	c3                   	ret    

0080234e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80234e:	55                   	push   %ebp
  80234f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802351:	6a 00                	push   $0x0
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	ff 75 0c             	pushl  0xc(%ebp)
  80235a:	ff 75 08             	pushl  0x8(%ebp)
  80235d:	6a 08                	push   $0x8
  80235f:	e8 d7 fe ff ff       	call   80223b <syscall>
  802364:	83 c4 18             	add    $0x18,%esp
}
  802367:	c9                   	leave  
  802368:	c3                   	ret    

00802369 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802369:	55                   	push   %ebp
  80236a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80236c:	6a 00                	push   $0x0
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	6a 09                	push   $0x9
  802378:	e8 be fe ff ff       	call   80223b <syscall>
  80237d:	83 c4 18             	add    $0x18,%esp
}
  802380:	c9                   	leave  
  802381:	c3                   	ret    

00802382 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802382:	55                   	push   %ebp
  802383:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802385:	6a 00                	push   $0x0
  802387:	6a 00                	push   $0x0
  802389:	6a 00                	push   $0x0
  80238b:	6a 00                	push   $0x0
  80238d:	6a 00                	push   $0x0
  80238f:	6a 0a                	push   $0xa
  802391:	e8 a5 fe ff ff       	call   80223b <syscall>
  802396:	83 c4 18             	add    $0x18,%esp
}
  802399:	c9                   	leave  
  80239a:	c3                   	ret    

0080239b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80239b:	55                   	push   %ebp
  80239c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 00                	push   $0x0
  8023a6:	6a 00                	push   $0x0
  8023a8:	6a 0b                	push   $0xb
  8023aa:	e8 8c fe ff ff       	call   80223b <syscall>
  8023af:	83 c4 18             	add    $0x18,%esp
}
  8023b2:	c9                   	leave  
  8023b3:	c3                   	ret    

008023b4 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8023b4:	55                   	push   %ebp
  8023b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	ff 75 0c             	pushl  0xc(%ebp)
  8023c0:	ff 75 08             	pushl  0x8(%ebp)
  8023c3:	6a 0d                	push   $0xd
  8023c5:	e8 71 fe ff ff       	call   80223b <syscall>
  8023ca:	83 c4 18             	add    $0x18,%esp
	return;
  8023cd:	90                   	nop
}
  8023ce:	c9                   	leave  
  8023cf:	c3                   	ret    

008023d0 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8023d0:	55                   	push   %ebp
  8023d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 00                	push   $0x0
  8023d9:	ff 75 0c             	pushl  0xc(%ebp)
  8023dc:	ff 75 08             	pushl  0x8(%ebp)
  8023df:	6a 0e                	push   $0xe
  8023e1:	e8 55 fe ff ff       	call   80223b <syscall>
  8023e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8023e9:	90                   	nop
}
  8023ea:	c9                   	leave  
  8023eb:	c3                   	ret    

008023ec <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8023ec:	55                   	push   %ebp
  8023ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 00                	push   $0x0
  8023f7:	6a 00                	push   $0x0
  8023f9:	6a 0c                	push   $0xc
  8023fb:	e8 3b fe ff ff       	call   80223b <syscall>
  802400:	83 c4 18             	add    $0x18,%esp
}
  802403:	c9                   	leave  
  802404:	c3                   	ret    

00802405 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802405:	55                   	push   %ebp
  802406:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	6a 00                	push   $0x0
  802410:	6a 00                	push   $0x0
  802412:	6a 10                	push   $0x10
  802414:	e8 22 fe ff ff       	call   80223b <syscall>
  802419:	83 c4 18             	add    $0x18,%esp
}
  80241c:	90                   	nop
  80241d:	c9                   	leave  
  80241e:	c3                   	ret    

0080241f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80241f:	55                   	push   %ebp
  802420:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802422:	6a 00                	push   $0x0
  802424:	6a 00                	push   $0x0
  802426:	6a 00                	push   $0x0
  802428:	6a 00                	push   $0x0
  80242a:	6a 00                	push   $0x0
  80242c:	6a 11                	push   $0x11
  80242e:	e8 08 fe ff ff       	call   80223b <syscall>
  802433:	83 c4 18             	add    $0x18,%esp
}
  802436:	90                   	nop
  802437:	c9                   	leave  
  802438:	c3                   	ret    

00802439 <sys_cputc>:


void
sys_cputc(const char c)
{
  802439:	55                   	push   %ebp
  80243a:	89 e5                	mov    %esp,%ebp
  80243c:	83 ec 04             	sub    $0x4,%esp
  80243f:	8b 45 08             	mov    0x8(%ebp),%eax
  802442:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802445:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	6a 00                	push   $0x0
  80244f:	6a 00                	push   $0x0
  802451:	50                   	push   %eax
  802452:	6a 12                	push   $0x12
  802454:	e8 e2 fd ff ff       	call   80223b <syscall>
  802459:	83 c4 18             	add    $0x18,%esp
}
  80245c:	90                   	nop
  80245d:	c9                   	leave  
  80245e:	c3                   	ret    

0080245f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80245f:	55                   	push   %ebp
  802460:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802462:	6a 00                	push   $0x0
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	6a 13                	push   $0x13
  80246e:	e8 c8 fd ff ff       	call   80223b <syscall>
  802473:	83 c4 18             	add    $0x18,%esp
}
  802476:	90                   	nop
  802477:	c9                   	leave  
  802478:	c3                   	ret    

00802479 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802479:	55                   	push   %ebp
  80247a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80247c:	8b 45 08             	mov    0x8(%ebp),%eax
  80247f:	6a 00                	push   $0x0
  802481:	6a 00                	push   $0x0
  802483:	6a 00                	push   $0x0
  802485:	ff 75 0c             	pushl  0xc(%ebp)
  802488:	50                   	push   %eax
  802489:	6a 14                	push   $0x14
  80248b:	e8 ab fd ff ff       	call   80223b <syscall>
  802490:	83 c4 18             	add    $0x18,%esp
}
  802493:	c9                   	leave  
  802494:	c3                   	ret    

00802495 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  802495:	55                   	push   %ebp
  802496:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  802498:	8b 45 08             	mov    0x8(%ebp),%eax
  80249b:	6a 00                	push   $0x0
  80249d:	6a 00                	push   $0x0
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 00                	push   $0x0
  8024a3:	50                   	push   %eax
  8024a4:	6a 17                	push   $0x17
  8024a6:	e8 90 fd ff ff       	call   80223b <syscall>
  8024ab:	83 c4 18             	add    $0x18,%esp
}
  8024ae:	c9                   	leave  
  8024af:	c3                   	ret    

008024b0 <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  8024b0:	55                   	push   %ebp
  8024b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  8024b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b6:	6a 00                	push   $0x0
  8024b8:	6a 00                	push   $0x0
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 00                	push   $0x0
  8024be:	50                   	push   %eax
  8024bf:	6a 15                	push   $0x15
  8024c1:	e8 75 fd ff ff       	call   80223b <syscall>
  8024c6:	83 c4 18             	add    $0x18,%esp
}
  8024c9:	90                   	nop
  8024ca:	c9                   	leave  
  8024cb:	c3                   	ret    

008024cc <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  8024cc:	55                   	push   %ebp
  8024cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  8024cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d2:	6a 00                	push   $0x0
  8024d4:	6a 00                	push   $0x0
  8024d6:	6a 00                	push   $0x0
  8024d8:	6a 00                	push   $0x0
  8024da:	50                   	push   %eax
  8024db:	6a 16                	push   $0x16
  8024dd:	e8 59 fd ff ff       	call   80223b <syscall>
  8024e2:	83 c4 18             	add    $0x18,%esp
}
  8024e5:	90                   	nop
  8024e6:	c9                   	leave  
  8024e7:	c3                   	ret    

008024e8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  8024e8:	55                   	push   %ebp
  8024e9:	89 e5                	mov    %esp,%ebp
  8024eb:	83 ec 04             	sub    $0x4,%esp
  8024ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8024f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  8024f4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8024f7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8024fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fe:	6a 00                	push   $0x0
  802500:	51                   	push   %ecx
  802501:	52                   	push   %edx
  802502:	ff 75 0c             	pushl  0xc(%ebp)
  802505:	50                   	push   %eax
  802506:	6a 18                	push   $0x18
  802508:	e8 2e fd ff ff       	call   80223b <syscall>
  80250d:	83 c4 18             	add    $0x18,%esp
}
  802510:	c9                   	leave  
  802511:	c3                   	ret    

00802512 <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  802512:	55                   	push   %ebp
  802513:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  802515:	8b 55 0c             	mov    0xc(%ebp),%edx
  802518:	8b 45 08             	mov    0x8(%ebp),%eax
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	6a 00                	push   $0x0
  802521:	52                   	push   %edx
  802522:	50                   	push   %eax
  802523:	6a 19                	push   $0x19
  802525:	e8 11 fd ff ff       	call   80223b <syscall>
  80252a:	83 c4 18             	add    $0x18,%esp
}
  80252d:	c9                   	leave  
  80252e:	c3                   	ret    

0080252f <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  80252f:	55                   	push   %ebp
  802530:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  802532:	8b 45 08             	mov    0x8(%ebp),%eax
  802535:	6a 00                	push   $0x0
  802537:	6a 00                	push   $0x0
  802539:	6a 00                	push   $0x0
  80253b:	6a 00                	push   $0x0
  80253d:	50                   	push   %eax
  80253e:	6a 1a                	push   $0x1a
  802540:	e8 f6 fc ff ff       	call   80223b <syscall>
  802545:	83 c4 18             	add    $0x18,%esp
}
  802548:	c9                   	leave  
  802549:	c3                   	ret    

0080254a <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  80254a:	55                   	push   %ebp
  80254b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  80254d:	6a 00                	push   $0x0
  80254f:	6a 00                	push   $0x0
  802551:	6a 00                	push   $0x0
  802553:	6a 00                	push   $0x0
  802555:	6a 00                	push   $0x0
  802557:	6a 1b                	push   $0x1b
  802559:	e8 dd fc ff ff       	call   80223b <syscall>
  80255e:	83 c4 18             	add    $0x18,%esp
}
  802561:	c9                   	leave  
  802562:	c3                   	ret    

00802563 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802563:	55                   	push   %ebp
  802564:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802566:	6a 00                	push   $0x0
  802568:	6a 00                	push   $0x0
  80256a:	6a 00                	push   $0x0
  80256c:	6a 00                	push   $0x0
  80256e:	6a 00                	push   $0x0
  802570:	6a 1c                	push   $0x1c
  802572:	e8 c4 fc ff ff       	call   80223b <syscall>
  802577:	83 c4 18             	add    $0x18,%esp
}
  80257a:	c9                   	leave  
  80257b:	c3                   	ret    

0080257c <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  80257c:	55                   	push   %ebp
  80257d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  80257f:	8b 45 08             	mov    0x8(%ebp),%eax
  802582:	6a 00                	push   $0x0
  802584:	6a 00                	push   $0x0
  802586:	6a 00                	push   $0x0
  802588:	ff 75 0c             	pushl  0xc(%ebp)
  80258b:	50                   	push   %eax
  80258c:	6a 1d                	push   $0x1d
  80258e:	e8 a8 fc ff ff       	call   80223b <syscall>
  802593:	83 c4 18             	add    $0x18,%esp
}
  802596:	c9                   	leave  
  802597:	c3                   	ret    

00802598 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802598:	55                   	push   %ebp
  802599:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80259b:	8b 45 08             	mov    0x8(%ebp),%eax
  80259e:	6a 00                	push   $0x0
  8025a0:	6a 00                	push   $0x0
  8025a2:	6a 00                	push   $0x0
  8025a4:	6a 00                	push   $0x0
  8025a6:	50                   	push   %eax
  8025a7:	6a 1e                	push   $0x1e
  8025a9:	e8 8d fc ff ff       	call   80223b <syscall>
  8025ae:	83 c4 18             	add    $0x18,%esp
}
  8025b1:	90                   	nop
  8025b2:	c9                   	leave  
  8025b3:	c3                   	ret    

008025b4 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8025b4:	55                   	push   %ebp
  8025b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8025b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ba:	6a 00                	push   $0x0
  8025bc:	6a 00                	push   $0x0
  8025be:	6a 00                	push   $0x0
  8025c0:	6a 00                	push   $0x0
  8025c2:	50                   	push   %eax
  8025c3:	6a 1f                	push   $0x1f
  8025c5:	e8 71 fc ff ff       	call   80223b <syscall>
  8025ca:	83 c4 18             	add    $0x18,%esp
}
  8025cd:	90                   	nop
  8025ce:	c9                   	leave  
  8025cf:	c3                   	ret    

008025d0 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8025d0:	55                   	push   %ebp
  8025d1:	89 e5                	mov    %esp,%ebp
  8025d3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8025d6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8025d9:	8d 50 04             	lea    0x4(%eax),%edx
  8025dc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8025df:	6a 00                	push   $0x0
  8025e1:	6a 00                	push   $0x0
  8025e3:	6a 00                	push   $0x0
  8025e5:	52                   	push   %edx
  8025e6:	50                   	push   %eax
  8025e7:	6a 20                	push   $0x20
  8025e9:	e8 4d fc ff ff       	call   80223b <syscall>
  8025ee:	83 c4 18             	add    $0x18,%esp
	return result;
  8025f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8025fa:	89 01                	mov    %eax,(%ecx)
  8025fc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8025ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802602:	c9                   	leave  
  802603:	c2 04 00             	ret    $0x4

00802606 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802606:	55                   	push   %ebp
  802607:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802609:	6a 00                	push   $0x0
  80260b:	6a 00                	push   $0x0
  80260d:	ff 75 10             	pushl  0x10(%ebp)
  802610:	ff 75 0c             	pushl  0xc(%ebp)
  802613:	ff 75 08             	pushl  0x8(%ebp)
  802616:	6a 0f                	push   $0xf
  802618:	e8 1e fc ff ff       	call   80223b <syscall>
  80261d:	83 c4 18             	add    $0x18,%esp
	return ;
  802620:	90                   	nop
}
  802621:	c9                   	leave  
  802622:	c3                   	ret    

00802623 <sys_rcr2>:
uint32 sys_rcr2()
{
  802623:	55                   	push   %ebp
  802624:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802626:	6a 00                	push   $0x0
  802628:	6a 00                	push   $0x0
  80262a:	6a 00                	push   $0x0
  80262c:	6a 00                	push   $0x0
  80262e:	6a 00                	push   $0x0
  802630:	6a 21                	push   $0x21
  802632:	e8 04 fc ff ff       	call   80223b <syscall>
  802637:	83 c4 18             	add    $0x18,%esp
}
  80263a:	c9                   	leave  
  80263b:	c3                   	ret    

0080263c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80263c:	55                   	push   %ebp
  80263d:	89 e5                	mov    %esp,%ebp
  80263f:	83 ec 04             	sub    $0x4,%esp
  802642:	8b 45 08             	mov    0x8(%ebp),%eax
  802645:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802648:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80264c:	6a 00                	push   $0x0
  80264e:	6a 00                	push   $0x0
  802650:	6a 00                	push   $0x0
  802652:	6a 00                	push   $0x0
  802654:	50                   	push   %eax
  802655:	6a 22                	push   $0x22
  802657:	e8 df fb ff ff       	call   80223b <syscall>
  80265c:	83 c4 18             	add    $0x18,%esp
	return ;
  80265f:	90                   	nop
}
  802660:	c9                   	leave  
  802661:	c3                   	ret    

00802662 <rsttst>:
void rsttst()
{
  802662:	55                   	push   %ebp
  802663:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802665:	6a 00                	push   $0x0
  802667:	6a 00                	push   $0x0
  802669:	6a 00                	push   $0x0
  80266b:	6a 00                	push   $0x0
  80266d:	6a 00                	push   $0x0
  80266f:	6a 24                	push   $0x24
  802671:	e8 c5 fb ff ff       	call   80223b <syscall>
  802676:	83 c4 18             	add    $0x18,%esp
	return ;
  802679:	90                   	nop
}
  80267a:	c9                   	leave  
  80267b:	c3                   	ret    

0080267c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80267c:	55                   	push   %ebp
  80267d:	89 e5                	mov    %esp,%ebp
  80267f:	83 ec 04             	sub    $0x4,%esp
  802682:	8b 45 14             	mov    0x14(%ebp),%eax
  802685:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802688:	8b 55 18             	mov    0x18(%ebp),%edx
  80268b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80268f:	52                   	push   %edx
  802690:	50                   	push   %eax
  802691:	ff 75 10             	pushl  0x10(%ebp)
  802694:	ff 75 0c             	pushl  0xc(%ebp)
  802697:	ff 75 08             	pushl  0x8(%ebp)
  80269a:	6a 23                	push   $0x23
  80269c:	e8 9a fb ff ff       	call   80223b <syscall>
  8026a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8026a4:	90                   	nop
}
  8026a5:	c9                   	leave  
  8026a6:	c3                   	ret    

008026a7 <chktst>:
void chktst(uint32 n)
{
  8026a7:	55                   	push   %ebp
  8026a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8026aa:	6a 00                	push   $0x0
  8026ac:	6a 00                	push   $0x0
  8026ae:	6a 00                	push   $0x0
  8026b0:	6a 00                	push   $0x0
  8026b2:	ff 75 08             	pushl  0x8(%ebp)
  8026b5:	6a 25                	push   $0x25
  8026b7:	e8 7f fb ff ff       	call   80223b <syscall>
  8026bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8026bf:	90                   	nop
}
  8026c0:	c9                   	leave  
  8026c1:	c3                   	ret    

008026c2 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8026c2:	55                   	push   %ebp
  8026c3:	89 e5                	mov    %esp,%ebp
  8026c5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026c8:	6a 00                	push   $0x0
  8026ca:	6a 00                	push   $0x0
  8026cc:	6a 00                	push   $0x0
  8026ce:	6a 00                	push   $0x0
  8026d0:	6a 00                	push   $0x0
  8026d2:	6a 26                	push   $0x26
  8026d4:	e8 62 fb ff ff       	call   80223b <syscall>
  8026d9:	83 c4 18             	add    $0x18,%esp
  8026dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8026df:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8026e3:	75 07                	jne    8026ec <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8026e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8026ea:	eb 05                	jmp    8026f1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8026ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026f1:	c9                   	leave  
  8026f2:	c3                   	ret    

008026f3 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8026f3:	55                   	push   %ebp
  8026f4:	89 e5                	mov    %esp,%ebp
  8026f6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026f9:	6a 00                	push   $0x0
  8026fb:	6a 00                	push   $0x0
  8026fd:	6a 00                	push   $0x0
  8026ff:	6a 00                	push   $0x0
  802701:	6a 00                	push   $0x0
  802703:	6a 26                	push   $0x26
  802705:	e8 31 fb ff ff       	call   80223b <syscall>
  80270a:	83 c4 18             	add    $0x18,%esp
  80270d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802710:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802714:	75 07                	jne    80271d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802716:	b8 01 00 00 00       	mov    $0x1,%eax
  80271b:	eb 05                	jmp    802722 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80271d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802722:	c9                   	leave  
  802723:	c3                   	ret    

00802724 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802724:	55                   	push   %ebp
  802725:	89 e5                	mov    %esp,%ebp
  802727:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80272a:	6a 00                	push   $0x0
  80272c:	6a 00                	push   $0x0
  80272e:	6a 00                	push   $0x0
  802730:	6a 00                	push   $0x0
  802732:	6a 00                	push   $0x0
  802734:	6a 26                	push   $0x26
  802736:	e8 00 fb ff ff       	call   80223b <syscall>
  80273b:	83 c4 18             	add    $0x18,%esp
  80273e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802741:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802745:	75 07                	jne    80274e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802747:	b8 01 00 00 00       	mov    $0x1,%eax
  80274c:	eb 05                	jmp    802753 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80274e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802753:	c9                   	leave  
  802754:	c3                   	ret    

00802755 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802755:	55                   	push   %ebp
  802756:	89 e5                	mov    %esp,%ebp
  802758:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80275b:	6a 00                	push   $0x0
  80275d:	6a 00                	push   $0x0
  80275f:	6a 00                	push   $0x0
  802761:	6a 00                	push   $0x0
  802763:	6a 00                	push   $0x0
  802765:	6a 26                	push   $0x26
  802767:	e8 cf fa ff ff       	call   80223b <syscall>
  80276c:	83 c4 18             	add    $0x18,%esp
  80276f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802772:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802776:	75 07                	jne    80277f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802778:	b8 01 00 00 00       	mov    $0x1,%eax
  80277d:	eb 05                	jmp    802784 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80277f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802784:	c9                   	leave  
  802785:	c3                   	ret    

00802786 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802786:	55                   	push   %ebp
  802787:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802789:	6a 00                	push   $0x0
  80278b:	6a 00                	push   $0x0
  80278d:	6a 00                	push   $0x0
  80278f:	6a 00                	push   $0x0
  802791:	ff 75 08             	pushl  0x8(%ebp)
  802794:	6a 27                	push   $0x27
  802796:	e8 a0 fa ff ff       	call   80223b <syscall>
  80279b:	83 c4 18             	add    $0x18,%esp
	return ;
  80279e:	90                   	nop
}
  80279f:	c9                   	leave  
  8027a0:	c3                   	ret    
  8027a1:	66 90                	xchg   %ax,%ax
  8027a3:	90                   	nop

008027a4 <__udivdi3>:
  8027a4:	55                   	push   %ebp
  8027a5:	57                   	push   %edi
  8027a6:	56                   	push   %esi
  8027a7:	53                   	push   %ebx
  8027a8:	83 ec 1c             	sub    $0x1c,%esp
  8027ab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8027af:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8027b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8027b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8027bb:	89 ca                	mov    %ecx,%edx
  8027bd:	89 f8                	mov    %edi,%eax
  8027bf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8027c3:	85 f6                	test   %esi,%esi
  8027c5:	75 2d                	jne    8027f4 <__udivdi3+0x50>
  8027c7:	39 cf                	cmp    %ecx,%edi
  8027c9:	77 65                	ja     802830 <__udivdi3+0x8c>
  8027cb:	89 fd                	mov    %edi,%ebp
  8027cd:	85 ff                	test   %edi,%edi
  8027cf:	75 0b                	jne    8027dc <__udivdi3+0x38>
  8027d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8027d6:	31 d2                	xor    %edx,%edx
  8027d8:	f7 f7                	div    %edi
  8027da:	89 c5                	mov    %eax,%ebp
  8027dc:	31 d2                	xor    %edx,%edx
  8027de:	89 c8                	mov    %ecx,%eax
  8027e0:	f7 f5                	div    %ebp
  8027e2:	89 c1                	mov    %eax,%ecx
  8027e4:	89 d8                	mov    %ebx,%eax
  8027e6:	f7 f5                	div    %ebp
  8027e8:	89 cf                	mov    %ecx,%edi
  8027ea:	89 fa                	mov    %edi,%edx
  8027ec:	83 c4 1c             	add    $0x1c,%esp
  8027ef:	5b                   	pop    %ebx
  8027f0:	5e                   	pop    %esi
  8027f1:	5f                   	pop    %edi
  8027f2:	5d                   	pop    %ebp
  8027f3:	c3                   	ret    
  8027f4:	39 ce                	cmp    %ecx,%esi
  8027f6:	77 28                	ja     802820 <__udivdi3+0x7c>
  8027f8:	0f bd fe             	bsr    %esi,%edi
  8027fb:	83 f7 1f             	xor    $0x1f,%edi
  8027fe:	75 40                	jne    802840 <__udivdi3+0x9c>
  802800:	39 ce                	cmp    %ecx,%esi
  802802:	72 0a                	jb     80280e <__udivdi3+0x6a>
  802804:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802808:	0f 87 9e 00 00 00    	ja     8028ac <__udivdi3+0x108>
  80280e:	b8 01 00 00 00       	mov    $0x1,%eax
  802813:	89 fa                	mov    %edi,%edx
  802815:	83 c4 1c             	add    $0x1c,%esp
  802818:	5b                   	pop    %ebx
  802819:	5e                   	pop    %esi
  80281a:	5f                   	pop    %edi
  80281b:	5d                   	pop    %ebp
  80281c:	c3                   	ret    
  80281d:	8d 76 00             	lea    0x0(%esi),%esi
  802820:	31 ff                	xor    %edi,%edi
  802822:	31 c0                	xor    %eax,%eax
  802824:	89 fa                	mov    %edi,%edx
  802826:	83 c4 1c             	add    $0x1c,%esp
  802829:	5b                   	pop    %ebx
  80282a:	5e                   	pop    %esi
  80282b:	5f                   	pop    %edi
  80282c:	5d                   	pop    %ebp
  80282d:	c3                   	ret    
  80282e:	66 90                	xchg   %ax,%ax
  802830:	89 d8                	mov    %ebx,%eax
  802832:	f7 f7                	div    %edi
  802834:	31 ff                	xor    %edi,%edi
  802836:	89 fa                	mov    %edi,%edx
  802838:	83 c4 1c             	add    $0x1c,%esp
  80283b:	5b                   	pop    %ebx
  80283c:	5e                   	pop    %esi
  80283d:	5f                   	pop    %edi
  80283e:	5d                   	pop    %ebp
  80283f:	c3                   	ret    
  802840:	bd 20 00 00 00       	mov    $0x20,%ebp
  802845:	89 eb                	mov    %ebp,%ebx
  802847:	29 fb                	sub    %edi,%ebx
  802849:	89 f9                	mov    %edi,%ecx
  80284b:	d3 e6                	shl    %cl,%esi
  80284d:	89 c5                	mov    %eax,%ebp
  80284f:	88 d9                	mov    %bl,%cl
  802851:	d3 ed                	shr    %cl,%ebp
  802853:	89 e9                	mov    %ebp,%ecx
  802855:	09 f1                	or     %esi,%ecx
  802857:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80285b:	89 f9                	mov    %edi,%ecx
  80285d:	d3 e0                	shl    %cl,%eax
  80285f:	89 c5                	mov    %eax,%ebp
  802861:	89 d6                	mov    %edx,%esi
  802863:	88 d9                	mov    %bl,%cl
  802865:	d3 ee                	shr    %cl,%esi
  802867:	89 f9                	mov    %edi,%ecx
  802869:	d3 e2                	shl    %cl,%edx
  80286b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80286f:	88 d9                	mov    %bl,%cl
  802871:	d3 e8                	shr    %cl,%eax
  802873:	09 c2                	or     %eax,%edx
  802875:	89 d0                	mov    %edx,%eax
  802877:	89 f2                	mov    %esi,%edx
  802879:	f7 74 24 0c          	divl   0xc(%esp)
  80287d:	89 d6                	mov    %edx,%esi
  80287f:	89 c3                	mov    %eax,%ebx
  802881:	f7 e5                	mul    %ebp
  802883:	39 d6                	cmp    %edx,%esi
  802885:	72 19                	jb     8028a0 <__udivdi3+0xfc>
  802887:	74 0b                	je     802894 <__udivdi3+0xf0>
  802889:	89 d8                	mov    %ebx,%eax
  80288b:	31 ff                	xor    %edi,%edi
  80288d:	e9 58 ff ff ff       	jmp    8027ea <__udivdi3+0x46>
  802892:	66 90                	xchg   %ax,%ax
  802894:	8b 54 24 08          	mov    0x8(%esp),%edx
  802898:	89 f9                	mov    %edi,%ecx
  80289a:	d3 e2                	shl    %cl,%edx
  80289c:	39 c2                	cmp    %eax,%edx
  80289e:	73 e9                	jae    802889 <__udivdi3+0xe5>
  8028a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8028a3:	31 ff                	xor    %edi,%edi
  8028a5:	e9 40 ff ff ff       	jmp    8027ea <__udivdi3+0x46>
  8028aa:	66 90                	xchg   %ax,%ax
  8028ac:	31 c0                	xor    %eax,%eax
  8028ae:	e9 37 ff ff ff       	jmp    8027ea <__udivdi3+0x46>
  8028b3:	90                   	nop

008028b4 <__umoddi3>:
  8028b4:	55                   	push   %ebp
  8028b5:	57                   	push   %edi
  8028b6:	56                   	push   %esi
  8028b7:	53                   	push   %ebx
  8028b8:	83 ec 1c             	sub    $0x1c,%esp
  8028bb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8028bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8028c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8028c7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8028cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8028cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8028d3:	89 f3                	mov    %esi,%ebx
  8028d5:	89 fa                	mov    %edi,%edx
  8028d7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8028db:	89 34 24             	mov    %esi,(%esp)
  8028de:	85 c0                	test   %eax,%eax
  8028e0:	75 1a                	jne    8028fc <__umoddi3+0x48>
  8028e2:	39 f7                	cmp    %esi,%edi
  8028e4:	0f 86 a2 00 00 00    	jbe    80298c <__umoddi3+0xd8>
  8028ea:	89 c8                	mov    %ecx,%eax
  8028ec:	89 f2                	mov    %esi,%edx
  8028ee:	f7 f7                	div    %edi
  8028f0:	89 d0                	mov    %edx,%eax
  8028f2:	31 d2                	xor    %edx,%edx
  8028f4:	83 c4 1c             	add    $0x1c,%esp
  8028f7:	5b                   	pop    %ebx
  8028f8:	5e                   	pop    %esi
  8028f9:	5f                   	pop    %edi
  8028fa:	5d                   	pop    %ebp
  8028fb:	c3                   	ret    
  8028fc:	39 f0                	cmp    %esi,%eax
  8028fe:	0f 87 ac 00 00 00    	ja     8029b0 <__umoddi3+0xfc>
  802904:	0f bd e8             	bsr    %eax,%ebp
  802907:	83 f5 1f             	xor    $0x1f,%ebp
  80290a:	0f 84 ac 00 00 00    	je     8029bc <__umoddi3+0x108>
  802910:	bf 20 00 00 00       	mov    $0x20,%edi
  802915:	29 ef                	sub    %ebp,%edi
  802917:	89 fe                	mov    %edi,%esi
  802919:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80291d:	89 e9                	mov    %ebp,%ecx
  80291f:	d3 e0                	shl    %cl,%eax
  802921:	89 d7                	mov    %edx,%edi
  802923:	89 f1                	mov    %esi,%ecx
  802925:	d3 ef                	shr    %cl,%edi
  802927:	09 c7                	or     %eax,%edi
  802929:	89 e9                	mov    %ebp,%ecx
  80292b:	d3 e2                	shl    %cl,%edx
  80292d:	89 14 24             	mov    %edx,(%esp)
  802930:	89 d8                	mov    %ebx,%eax
  802932:	d3 e0                	shl    %cl,%eax
  802934:	89 c2                	mov    %eax,%edx
  802936:	8b 44 24 08          	mov    0x8(%esp),%eax
  80293a:	d3 e0                	shl    %cl,%eax
  80293c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802940:	8b 44 24 08          	mov    0x8(%esp),%eax
  802944:	89 f1                	mov    %esi,%ecx
  802946:	d3 e8                	shr    %cl,%eax
  802948:	09 d0                	or     %edx,%eax
  80294a:	d3 eb                	shr    %cl,%ebx
  80294c:	89 da                	mov    %ebx,%edx
  80294e:	f7 f7                	div    %edi
  802950:	89 d3                	mov    %edx,%ebx
  802952:	f7 24 24             	mull   (%esp)
  802955:	89 c6                	mov    %eax,%esi
  802957:	89 d1                	mov    %edx,%ecx
  802959:	39 d3                	cmp    %edx,%ebx
  80295b:	0f 82 87 00 00 00    	jb     8029e8 <__umoddi3+0x134>
  802961:	0f 84 91 00 00 00    	je     8029f8 <__umoddi3+0x144>
  802967:	8b 54 24 04          	mov    0x4(%esp),%edx
  80296b:	29 f2                	sub    %esi,%edx
  80296d:	19 cb                	sbb    %ecx,%ebx
  80296f:	89 d8                	mov    %ebx,%eax
  802971:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802975:	d3 e0                	shl    %cl,%eax
  802977:	89 e9                	mov    %ebp,%ecx
  802979:	d3 ea                	shr    %cl,%edx
  80297b:	09 d0                	or     %edx,%eax
  80297d:	89 e9                	mov    %ebp,%ecx
  80297f:	d3 eb                	shr    %cl,%ebx
  802981:	89 da                	mov    %ebx,%edx
  802983:	83 c4 1c             	add    $0x1c,%esp
  802986:	5b                   	pop    %ebx
  802987:	5e                   	pop    %esi
  802988:	5f                   	pop    %edi
  802989:	5d                   	pop    %ebp
  80298a:	c3                   	ret    
  80298b:	90                   	nop
  80298c:	89 fd                	mov    %edi,%ebp
  80298e:	85 ff                	test   %edi,%edi
  802990:	75 0b                	jne    80299d <__umoddi3+0xe9>
  802992:	b8 01 00 00 00       	mov    $0x1,%eax
  802997:	31 d2                	xor    %edx,%edx
  802999:	f7 f7                	div    %edi
  80299b:	89 c5                	mov    %eax,%ebp
  80299d:	89 f0                	mov    %esi,%eax
  80299f:	31 d2                	xor    %edx,%edx
  8029a1:	f7 f5                	div    %ebp
  8029a3:	89 c8                	mov    %ecx,%eax
  8029a5:	f7 f5                	div    %ebp
  8029a7:	89 d0                	mov    %edx,%eax
  8029a9:	e9 44 ff ff ff       	jmp    8028f2 <__umoddi3+0x3e>
  8029ae:	66 90                	xchg   %ax,%ax
  8029b0:	89 c8                	mov    %ecx,%eax
  8029b2:	89 f2                	mov    %esi,%edx
  8029b4:	83 c4 1c             	add    $0x1c,%esp
  8029b7:	5b                   	pop    %ebx
  8029b8:	5e                   	pop    %esi
  8029b9:	5f                   	pop    %edi
  8029ba:	5d                   	pop    %ebp
  8029bb:	c3                   	ret    
  8029bc:	3b 04 24             	cmp    (%esp),%eax
  8029bf:	72 06                	jb     8029c7 <__umoddi3+0x113>
  8029c1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8029c5:	77 0f                	ja     8029d6 <__umoddi3+0x122>
  8029c7:	89 f2                	mov    %esi,%edx
  8029c9:	29 f9                	sub    %edi,%ecx
  8029cb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8029cf:	89 14 24             	mov    %edx,(%esp)
  8029d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8029d6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8029da:	8b 14 24             	mov    (%esp),%edx
  8029dd:	83 c4 1c             	add    $0x1c,%esp
  8029e0:	5b                   	pop    %ebx
  8029e1:	5e                   	pop    %esi
  8029e2:	5f                   	pop    %edi
  8029e3:	5d                   	pop    %ebp
  8029e4:	c3                   	ret    
  8029e5:	8d 76 00             	lea    0x0(%esi),%esi
  8029e8:	2b 04 24             	sub    (%esp),%eax
  8029eb:	19 fa                	sbb    %edi,%edx
  8029ed:	89 d1                	mov    %edx,%ecx
  8029ef:	89 c6                	mov    %eax,%esi
  8029f1:	e9 71 ff ff ff       	jmp    802967 <__umoddi3+0xb3>
  8029f6:	66 90                	xchg   %ax,%ax
  8029f8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8029fc:	72 ea                	jb     8029e8 <__umoddi3+0x134>
  8029fe:	89 d9                	mov    %ebx,%ecx
  802a00:	e9 62 ff ff ff       	jmp    802967 <__umoddi3+0xb3>
