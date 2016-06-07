
obj/user/quicksort_noleakage:     file format elf32-i386


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
  800031:	e8 fc 05 00 00       	call   800632 <libmain>
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
  800041:	e8 cd 23 00 00       	call   802413 <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 20 2a 80 00       	push   $0x802a20
  80004e:	e8 cb 07 00 00       	call   80081e <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 22 2a 80 00       	push   $0x802a22
  80005e:	e8 bb 07 00 00       	call   80081e <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 3b 2a 80 00       	push   $0x802a3b
  80006e:	e8 ab 07 00 00       	call   80081e <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 22 2a 80 00       	push   $0x802a22
  80007e:	e8 9b 07 00 00       	call   80081e <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 20 2a 80 00       	push   $0x802a20
  80008e:	e8 8b 07 00 00       	call   80081e <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 54 2a 80 00       	push   $0x802a54
  8000a5:	e8 ef 0d 00 00       	call   800e99 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 3f 13 00 00       	call   8013ff <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 d2 16 00 00       	call   8017a7 <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 74 2a 80 00       	push   $0x802a74
  8000e3:	e8 36 07 00 00       	call   80081e <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 96 2a 80 00       	push   $0x802a96
  8000f3:	e8 26 07 00 00       	call   80081e <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 a4 2a 80 00       	push   $0x802aa4
  800103:	e8 16 07 00 00       	call   80081e <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 b3 2a 80 00       	push   $0x802ab3
  800113:	e8 06 07 00 00       	call   80081e <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 c3 2a 80 00       	push   $0x802ac3
  800123:	e8 f6 06 00 00       	call   80081e <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  80012b:	e8 aa 04 00 00       	call   8005da <getchar>
  800130:	88 45 ef             	mov    %al,-0x11(%ebp)
		cputchar(Chose);
  800133:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 52 04 00 00       	call   800592 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 45 04 00 00       	call   800592 <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp

		//2012: lock the interrupt
		sys_enable_interrupt();
  800150:	e8 d8 22 00 00       	call   80242d <sys_enable_interrupt>

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
  800171:	e8 e4 02 00 00       	call   80045a <InitializeAscending>
  800176:	83 c4 10             	add    $0x10,%esp
			break ;
  800179:	eb 37                	jmp    8001b2 <_main+0x17a>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80017b:	83 ec 08             	sub    $0x8,%esp
  80017e:	ff 75 f4             	pushl  -0xc(%ebp)
  800181:	ff 75 f0             	pushl  -0x10(%ebp)
  800184:	e8 02 03 00 00       	call   80048b <InitializeDescending>
  800189:	83 c4 10             	add    $0x10,%esp
			break ;
  80018c:	eb 24                	jmp    8001b2 <_main+0x17a>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  80018e:	83 ec 08             	sub    $0x8,%esp
  800191:	ff 75 f4             	pushl  -0xc(%ebp)
  800194:	ff 75 f0             	pushl  -0x10(%ebp)
  800197:	e8 24 03 00 00       	call   8004c0 <InitializeSemiRandom>
  80019c:	83 c4 10             	add    $0x10,%esp
			break ;
  80019f:	eb 11                	jmp    8001b2 <_main+0x17a>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8001a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001aa:	e8 11 03 00 00       	call   8004c0 <InitializeSemiRandom>
  8001af:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001b2:	83 ec 08             	sub    $0x8,%esp
  8001b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8001b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8001bb:	e8 df 00 00 00       	call   80029f <QuickSort>
  8001c0:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001c3:	e8 4b 22 00 00       	call   802413 <sys_disable_interrupt>
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001c8:	83 ec 0c             	sub    $0xc,%esp
  8001cb:	68 cc 2a 80 00       	push   $0x802acc
  8001d0:	e8 49 06 00 00       	call   80081e <cprintf>
  8001d5:	83 c4 10             	add    $0x10,%esp
		//		PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001d8:	e8 50 22 00 00       	call   80242d <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001dd:	83 ec 08             	sub    $0x8,%esp
  8001e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8001e3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001e6:	e8 c5 01 00 00       	call   8003b0 <CheckSorted>
  8001eb:	83 c4 10             	add    $0x10,%esp
  8001ee:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001f1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8001f5:	75 14                	jne    80020b <_main+0x1d3>
  8001f7:	83 ec 04             	sub    $0x4,%esp
  8001fa:	68 00 2b 80 00       	push   $0x802b00
  8001ff:	6a 46                	push   $0x46
  800201:	68 22 2b 80 00       	push   $0x802b22
  800206:	e8 e8 04 00 00       	call   8006f3 <_panic>
		else
		{
			sys_disable_interrupt();
  80020b:	e8 03 22 00 00       	call   802413 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800210:	83 ec 0c             	sub    $0xc,%esp
  800213:	68 40 2b 80 00       	push   $0x802b40
  800218:	e8 01 06 00 00       	call   80081e <cprintf>
  80021d:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800220:	83 ec 0c             	sub    $0xc,%esp
  800223:	68 74 2b 80 00       	push   $0x802b74
  800228:	e8 f1 05 00 00       	call   80081e <cprintf>
  80022d:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800230:	83 ec 0c             	sub    $0xc,%esp
  800233:	68 a8 2b 80 00       	push   $0x802ba8
  800238:	e8 e1 05 00 00       	call   80081e <cprintf>
  80023d:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800240:	e8 e8 21 00 00       	call   80242d <sys_enable_interrupt>

		}

		free(Elements) ;
  800245:	83 ec 0c             	sub    $0xc,%esp
  800248:	ff 75 f0             	pushl  -0x10(%ebp)
  80024b:	e8 f9 1e 00 00       	call   802149 <free>
  800250:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  800253:	e8 bb 21 00 00       	call   802413 <sys_disable_interrupt>

		cprintf("Do you want to repeat (y/n): ") ;
  800258:	83 ec 0c             	sub    $0xc,%esp
  80025b:	68 da 2b 80 00       	push   $0x802bda
  800260:	e8 b9 05 00 00       	call   80081e <cprintf>
  800265:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  800268:	e8 6d 03 00 00       	call   8005da <getchar>
  80026d:	88 45 ef             	mov    %al,-0x11(%ebp)
		cputchar(Chose);
  800270:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  800274:	83 ec 0c             	sub    $0xc,%esp
  800277:	50                   	push   %eax
  800278:	e8 15 03 00 00       	call   800592 <cputchar>
  80027d:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	6a 0a                	push   $0xa
  800285:	e8 08 03 00 00       	call   800592 <cputchar>
  80028a:	83 c4 10             	add    $0x10,%esp

		sys_enable_interrupt();
  80028d:	e8 9b 21 00 00       	call   80242d <sys_enable_interrupt>

	} while (Chose == 'y');
  800292:	80 7d ef 79          	cmpb   $0x79,-0x11(%ebp)
  800296:	0f 84 a5 fd ff ff    	je     800041 <_main+0x9>

}
  80029c:	90                   	nop
  80029d:	c9                   	leave  
  80029e:	c3                   	ret    

0080029f <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  80029f:	55                   	push   %ebp
  8002a0:	89 e5                	mov    %esp,%ebp
  8002a2:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a8:	48                   	dec    %eax
  8002a9:	50                   	push   %eax
  8002aa:	6a 00                	push   $0x0
  8002ac:	ff 75 0c             	pushl  0xc(%ebp)
  8002af:	ff 75 08             	pushl  0x8(%ebp)
  8002b2:	e8 06 00 00 00       	call   8002bd <QSort>
  8002b7:	83 c4 10             	add    $0x10,%esp
}
  8002ba:	90                   	nop
  8002bb:	c9                   	leave  
  8002bc:	c3                   	ret    

008002bd <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002bd:	55                   	push   %ebp
  8002be:	89 e5                	mov    %esp,%ebp
  8002c0:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c6:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002c9:	0f 8d de 00 00 00    	jge    8003ad <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d2:	40                   	inc    %eax
  8002d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8002d9:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002dc:	e9 80 00 00 00       	jmp    800361 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  8002e1:	ff 45 f4             	incl   -0xc(%ebp)
  8002e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002e7:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002ea:	7f 2b                	jg     800317 <QSort+0x5a>
  8002ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f9:	01 d0                	add    %edx,%eax
  8002fb:	8b 10                	mov    (%eax),%edx
  8002fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800300:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800307:	8b 45 08             	mov    0x8(%ebp),%eax
  80030a:	01 c8                	add    %ecx,%eax
  80030c:	8b 00                	mov    (%eax),%eax
  80030e:	39 c2                	cmp    %eax,%edx
  800310:	7d cf                	jge    8002e1 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800312:	eb 03                	jmp    800317 <QSort+0x5a>
  800314:	ff 4d f0             	decl   -0x10(%ebp)
  800317:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80031a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80031d:	7e 26                	jle    800345 <QSort+0x88>
  80031f:	8b 45 10             	mov    0x10(%ebp),%eax
  800322:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800329:	8b 45 08             	mov    0x8(%ebp),%eax
  80032c:	01 d0                	add    %edx,%eax
  80032e:	8b 10                	mov    (%eax),%edx
  800330:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800333:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80033a:	8b 45 08             	mov    0x8(%ebp),%eax
  80033d:	01 c8                	add    %ecx,%eax
  80033f:	8b 00                	mov    (%eax),%eax
  800341:	39 c2                	cmp    %eax,%edx
  800343:	7e cf                	jle    800314 <QSort+0x57>

		if (i <= j)
  800345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800348:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80034b:	7f 14                	jg     800361 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  80034d:	83 ec 04             	sub    $0x4,%esp
  800350:	ff 75 f0             	pushl  -0x10(%ebp)
  800353:	ff 75 f4             	pushl  -0xc(%ebp)
  800356:	ff 75 08             	pushl  0x8(%ebp)
  800359:	e8 a9 00 00 00       	call   800407 <Swap>
  80035e:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800364:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800367:	0f 8e 77 ff ff ff    	jle    8002e4 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80036d:	83 ec 04             	sub    $0x4,%esp
  800370:	ff 75 f0             	pushl  -0x10(%ebp)
  800373:	ff 75 10             	pushl  0x10(%ebp)
  800376:	ff 75 08             	pushl  0x8(%ebp)
  800379:	e8 89 00 00 00       	call   800407 <Swap>
  80037e:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800381:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800384:	48                   	dec    %eax
  800385:	50                   	push   %eax
  800386:	ff 75 10             	pushl  0x10(%ebp)
  800389:	ff 75 0c             	pushl  0xc(%ebp)
  80038c:	ff 75 08             	pushl  0x8(%ebp)
  80038f:	e8 29 ff ff ff       	call   8002bd <QSort>
  800394:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  800397:	ff 75 14             	pushl  0x14(%ebp)
  80039a:	ff 75 f4             	pushl  -0xc(%ebp)
  80039d:	ff 75 0c             	pushl  0xc(%ebp)
  8003a0:	ff 75 08             	pushl  0x8(%ebp)
  8003a3:	e8 15 ff ff ff       	call   8002bd <QSort>
  8003a8:	83 c4 10             	add    $0x10,%esp
  8003ab:	eb 01                	jmp    8003ae <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003ad:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003ae:	c9                   	leave  
  8003af:	c3                   	ret    

008003b0 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003b0:	55                   	push   %ebp
  8003b1:	89 e5                	mov    %esp,%ebp
  8003b3:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003b6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003bd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003c4:	eb 33                	jmp    8003f9 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d3:	01 d0                	add    %edx,%eax
  8003d5:	8b 10                	mov    (%eax),%edx
  8003d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003da:	40                   	inc    %eax
  8003db:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e5:	01 c8                	add    %ecx,%eax
  8003e7:	8b 00                	mov    (%eax),%eax
  8003e9:	39 c2                	cmp    %eax,%edx
  8003eb:	7e 09                	jle    8003f6 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8003f4:	eb 0c                	jmp    800402 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003f6:	ff 45 f8             	incl   -0x8(%ebp)
  8003f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003fc:	48                   	dec    %eax
  8003fd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800400:	7f c4                	jg     8003c6 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800402:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800405:	c9                   	leave  
  800406:	c3                   	ret    

00800407 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800407:	55                   	push   %ebp
  800408:	89 e5                	mov    %esp,%ebp
  80040a:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80040d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800410:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800417:	8b 45 08             	mov    0x8(%ebp),%eax
  80041a:	01 d0                	add    %edx,%eax
  80041c:	8b 00                	mov    (%eax),%eax
  80041e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800421:	8b 45 0c             	mov    0xc(%ebp),%eax
  800424:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80042b:	8b 45 08             	mov    0x8(%ebp),%eax
  80042e:	01 c2                	add    %eax,%edx
  800430:	8b 45 10             	mov    0x10(%ebp),%eax
  800433:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	01 c8                	add    %ecx,%eax
  80043f:	8b 00                	mov    (%eax),%eax
  800441:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800443:	8b 45 10             	mov    0x10(%ebp),%eax
  800446:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80044d:	8b 45 08             	mov    0x8(%ebp),%eax
  800450:	01 c2                	add    %eax,%edx
  800452:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800455:	89 02                	mov    %eax,(%edx)
}
  800457:	90                   	nop
  800458:	c9                   	leave  
  800459:	c3                   	ret    

0080045a <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80045a:	55                   	push   %ebp
  80045b:	89 e5                	mov    %esp,%ebp
  80045d:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800460:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800467:	eb 17                	jmp    800480 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800469:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80046c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800473:	8b 45 08             	mov    0x8(%ebp),%eax
  800476:	01 c2                	add    %eax,%edx
  800478:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80047b:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80047d:	ff 45 fc             	incl   -0x4(%ebp)
  800480:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800483:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800486:	7c e1                	jl     800469 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  800488:	90                   	nop
  800489:	c9                   	leave  
  80048a:	c3                   	ret    

0080048b <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80048b:	55                   	push   %ebp
  80048c:	89 e5                	mov    %esp,%ebp
  80048e:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800491:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800498:	eb 1b                	jmp    8004b5 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  80049a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a7:	01 c2                	add    %eax,%edx
  8004a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ac:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004af:	48                   	dec    %eax
  8004b0:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b2:	ff 45 fc             	incl   -0x4(%ebp)
  8004b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004b8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004bb:	7c dd                	jl     80049a <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004bd:	90                   	nop
  8004be:	c9                   	leave  
  8004bf:	c3                   	ret    

008004c0 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
  8004c3:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004c9:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004ce:	f7 e9                	imul   %ecx
  8004d0:	c1 f9 1f             	sar    $0x1f,%ecx
  8004d3:	89 d0                	mov    %edx,%eax
  8004d5:	29 c8                	sub    %ecx,%eax
  8004d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8004da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004e1:	eb 1e                	jmp    800501 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8004e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f0:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8004f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004f6:	99                   	cltd   
  8004f7:	f7 7d f8             	idivl  -0x8(%ebp)
  8004fa:	89 d0                	mov    %edx,%eax
  8004fc:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004fe:	ff 45 fc             	incl   -0x4(%ebp)
  800501:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800504:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800507:	7c da                	jl     8004e3 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  800509:	90                   	nop
  80050a:	c9                   	leave  
  80050b:	c3                   	ret    

0080050c <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80050c:	55                   	push   %ebp
  80050d:	89 e5                	mov    %esp,%ebp
  80050f:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800512:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800519:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800520:	eb 42                	jmp    800564 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800522:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800525:	99                   	cltd   
  800526:	f7 7d f0             	idivl  -0x10(%ebp)
  800529:	89 d0                	mov    %edx,%eax
  80052b:	85 c0                	test   %eax,%eax
  80052d:	75 10                	jne    80053f <PrintElements+0x33>
			cprintf("\n");
  80052f:	83 ec 0c             	sub    $0xc,%esp
  800532:	68 20 2a 80 00       	push   $0x802a20
  800537:	e8 e2 02 00 00       	call   80081e <cprintf>
  80053c:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80053f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800542:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800549:	8b 45 08             	mov    0x8(%ebp),%eax
  80054c:	01 d0                	add    %edx,%eax
  80054e:	8b 00                	mov    (%eax),%eax
  800550:	83 ec 08             	sub    $0x8,%esp
  800553:	50                   	push   %eax
  800554:	68 f8 2b 80 00       	push   $0x802bf8
  800559:	e8 c0 02 00 00       	call   80081e <cprintf>
  80055e:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800561:	ff 45 f4             	incl   -0xc(%ebp)
  800564:	8b 45 0c             	mov    0xc(%ebp),%eax
  800567:	48                   	dec    %eax
  800568:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80056b:	7f b5                	jg     800522 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80056d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800570:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800577:	8b 45 08             	mov    0x8(%ebp),%eax
  80057a:	01 d0                	add    %edx,%eax
  80057c:	8b 00                	mov    (%eax),%eax
  80057e:	83 ec 08             	sub    $0x8,%esp
  800581:	50                   	push   %eax
  800582:	68 fd 2b 80 00       	push   $0x802bfd
  800587:	e8 92 02 00 00       	call   80081e <cprintf>
  80058c:	83 c4 10             	add    $0x10,%esp

}
  80058f:	90                   	nop
  800590:	c9                   	leave  
  800591:	c3                   	ret    

00800592 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800592:	55                   	push   %ebp
  800593:	89 e5                	mov    %esp,%ebp
  800595:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800598:	8b 45 08             	mov    0x8(%ebp),%eax
  80059b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80059e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005a2:	83 ec 0c             	sub    $0xc,%esp
  8005a5:	50                   	push   %eax
  8005a6:	e8 9c 1e 00 00       	call   802447 <sys_cputc>
  8005ab:	83 c4 10             	add    $0x10,%esp
}
  8005ae:	90                   	nop
  8005af:	c9                   	leave  
  8005b0:	c3                   	ret    

008005b1 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8005b1:	55                   	push   %ebp
  8005b2:	89 e5                	mov    %esp,%ebp
  8005b4:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005b7:	e8 57 1e 00 00       	call   802413 <sys_disable_interrupt>
	char c = ch;
  8005bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bf:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005c2:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005c6:	83 ec 0c             	sub    $0xc,%esp
  8005c9:	50                   	push   %eax
  8005ca:	e8 78 1e 00 00       	call   802447 <sys_cputc>
  8005cf:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005d2:	e8 56 1e 00 00       	call   80242d <sys_enable_interrupt>
}
  8005d7:	90                   	nop
  8005d8:	c9                   	leave  
  8005d9:	c3                   	ret    

008005da <getchar>:

int
getchar(void)
{
  8005da:	55                   	push   %ebp
  8005db:	89 e5                	mov    %esp,%ebp
  8005dd:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8005e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005e7:	eb 08                	jmp    8005f1 <getchar+0x17>
	{
		c = sys_cgetc();
  8005e9:	e8 a3 1c 00 00       	call   802291 <sys_cgetc>
  8005ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  8005f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8005f5:	74 f2                	je     8005e9 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  8005f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005fa:	c9                   	leave  
  8005fb:	c3                   	ret    

008005fc <atomic_getchar>:

int
atomic_getchar(void)
{
  8005fc:	55                   	push   %ebp
  8005fd:	89 e5                	mov    %esp,%ebp
  8005ff:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800602:	e8 0c 1e 00 00       	call   802413 <sys_disable_interrupt>
	int c=0;
  800607:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80060e:	eb 08                	jmp    800618 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800610:	e8 7c 1c 00 00       	call   802291 <sys_cgetc>
  800615:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  800618:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80061c:	74 f2                	je     800610 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  80061e:	e8 0a 1e 00 00       	call   80242d <sys_enable_interrupt>
	return c;
  800623:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800626:	c9                   	leave  
  800627:	c3                   	ret    

00800628 <iscons>:

int iscons(int fdnum)
{
  800628:	55                   	push   %ebp
  800629:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80062b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800630:	5d                   	pop    %ebp
  800631:	c3                   	ret    

00800632 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800632:	55                   	push   %ebp
  800633:	89 e5                	mov    %esp,%ebp
  800635:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800638:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80063c:	7e 0a                	jle    800648 <libmain+0x16>
		binaryname = argv[0];
  80063e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800641:	8b 00                	mov    (%eax),%eax
  800643:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800648:	83 ec 08             	sub    $0x8,%esp
  80064b:	ff 75 0c             	pushl  0xc(%ebp)
  80064e:	ff 75 08             	pushl  0x8(%ebp)
  800651:	e8 e2 f9 ff ff       	call   800038 <_main>
  800656:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  800659:	e8 67 1c 00 00       	call   8022c5 <sys_getenvid>
  80065e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  800661:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800664:	89 d0                	mov    %edx,%eax
  800666:	c1 e0 03             	shl    $0x3,%eax
  800669:	01 d0                	add    %edx,%eax
  80066b:	01 c0                	add    %eax,%eax
  80066d:	01 d0                	add    %edx,%eax
  80066f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800676:	01 d0                	add    %edx,%eax
  800678:	c1 e0 03             	shl    $0x3,%eax
  80067b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800680:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  800683:	e8 8b 1d 00 00       	call   802413 <sys_disable_interrupt>
		cprintf("**************************************\n");
  800688:	83 ec 0c             	sub    $0xc,%esp
  80068b:	68 1c 2c 80 00       	push   $0x802c1c
  800690:	e8 89 01 00 00       	call   80081e <cprintf>
  800695:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  800698:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80069b:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  8006a1:	83 ec 08             	sub    $0x8,%esp
  8006a4:	50                   	push   %eax
  8006a5:	68 44 2c 80 00       	push   $0x802c44
  8006aa:	e8 6f 01 00 00       	call   80081e <cprintf>
  8006af:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8006b2:	83 ec 0c             	sub    $0xc,%esp
  8006b5:	68 1c 2c 80 00       	push   $0x802c1c
  8006ba:	e8 5f 01 00 00       	call   80081e <cprintf>
  8006bf:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006c2:	e8 66 1d 00 00       	call   80242d <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006c7:	e8 19 00 00 00       	call   8006e5 <exit>
}
  8006cc:	90                   	nop
  8006cd:	c9                   	leave  
  8006ce:	c3                   	ret    

008006cf <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006cf:	55                   	push   %ebp
  8006d0:	89 e5                	mov    %esp,%ebp
  8006d2:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8006d5:	83 ec 0c             	sub    $0xc,%esp
  8006d8:	6a 00                	push   $0x0
  8006da:	e8 cb 1b 00 00       	call   8022aa <sys_env_destroy>
  8006df:	83 c4 10             	add    $0x10,%esp
}
  8006e2:	90                   	nop
  8006e3:	c9                   	leave  
  8006e4:	c3                   	ret    

008006e5 <exit>:

void
exit(void)
{
  8006e5:	55                   	push   %ebp
  8006e6:	89 e5                	mov    %esp,%ebp
  8006e8:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8006eb:	e8 ee 1b 00 00       	call   8022de <sys_env_exit>
}
  8006f0:	90                   	nop
  8006f1:	c9                   	leave  
  8006f2:	c3                   	ret    

008006f3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006f3:	55                   	push   %ebp
  8006f4:	89 e5                	mov    %esp,%ebp
  8006f6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8006f9:	8d 45 10             	lea    0x10(%ebp),%eax
  8006fc:	83 c0 04             	add    $0x4,%eax
  8006ff:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  800702:	a1 70 40 98 00       	mov    0x984070,%eax
  800707:	85 c0                	test   %eax,%eax
  800709:	74 16                	je     800721 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80070b:	a1 70 40 98 00       	mov    0x984070,%eax
  800710:	83 ec 08             	sub    $0x8,%esp
  800713:	50                   	push   %eax
  800714:	68 5d 2c 80 00       	push   $0x802c5d
  800719:	e8 00 01 00 00       	call   80081e <cprintf>
  80071e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800721:	a1 00 40 80 00       	mov    0x804000,%eax
  800726:	ff 75 0c             	pushl  0xc(%ebp)
  800729:	ff 75 08             	pushl  0x8(%ebp)
  80072c:	50                   	push   %eax
  80072d:	68 62 2c 80 00       	push   $0x802c62
  800732:	e8 e7 00 00 00       	call   80081e <cprintf>
  800737:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80073a:	8b 45 10             	mov    0x10(%ebp),%eax
  80073d:	83 ec 08             	sub    $0x8,%esp
  800740:	ff 75 f4             	pushl  -0xc(%ebp)
  800743:	50                   	push   %eax
  800744:	e8 7a 00 00 00       	call   8007c3 <vcprintf>
  800749:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  80074c:	83 ec 0c             	sub    $0xc,%esp
  80074f:	68 7e 2c 80 00       	push   $0x802c7e
  800754:	e8 c5 00 00 00       	call   80081e <cprintf>
  800759:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80075c:	e8 84 ff ff ff       	call   8006e5 <exit>

	// should not return here
	while (1) ;
  800761:	eb fe                	jmp    800761 <_panic+0x6e>

00800763 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800763:	55                   	push   %ebp
  800764:	89 e5                	mov    %esp,%ebp
  800766:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800769:	8b 45 0c             	mov    0xc(%ebp),%eax
  80076c:	8b 00                	mov    (%eax),%eax
  80076e:	8d 48 01             	lea    0x1(%eax),%ecx
  800771:	8b 55 0c             	mov    0xc(%ebp),%edx
  800774:	89 0a                	mov    %ecx,(%edx)
  800776:	8b 55 08             	mov    0x8(%ebp),%edx
  800779:	88 d1                	mov    %dl,%cl
  80077b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80077e:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800782:	8b 45 0c             	mov    0xc(%ebp),%eax
  800785:	8b 00                	mov    (%eax),%eax
  800787:	3d ff 00 00 00       	cmp    $0xff,%eax
  80078c:	75 23                	jne    8007b1 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  80078e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800791:	8b 00                	mov    (%eax),%eax
  800793:	89 c2                	mov    %eax,%edx
  800795:	8b 45 0c             	mov    0xc(%ebp),%eax
  800798:	83 c0 08             	add    $0x8,%eax
  80079b:	83 ec 08             	sub    $0x8,%esp
  80079e:	52                   	push   %edx
  80079f:	50                   	push   %eax
  8007a0:	e8 cf 1a 00 00       	call   802274 <sys_cputs>
  8007a5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8007a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8007b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b4:	8b 40 04             	mov    0x4(%eax),%eax
  8007b7:	8d 50 01             	lea    0x1(%eax),%edx
  8007ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007bd:	89 50 04             	mov    %edx,0x4(%eax)
}
  8007c0:	90                   	nop
  8007c1:	c9                   	leave  
  8007c2:	c3                   	ret    

008007c3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8007c3:	55                   	push   %ebp
  8007c4:	89 e5                	mov    %esp,%ebp
  8007c6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8007cc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007d3:	00 00 00 
	b.cnt = 0;
  8007d6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007dd:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007e0:	ff 75 0c             	pushl  0xc(%ebp)
  8007e3:	ff 75 08             	pushl  0x8(%ebp)
  8007e6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007ec:	50                   	push   %eax
  8007ed:	68 63 07 80 00       	push   $0x800763
  8007f2:	e8 fa 01 00 00       	call   8009f1 <vprintfmt>
  8007f7:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  8007fa:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800800:	83 ec 08             	sub    $0x8,%esp
  800803:	50                   	push   %eax
  800804:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80080a:	83 c0 08             	add    $0x8,%eax
  80080d:	50                   	push   %eax
  80080e:	e8 61 1a 00 00       	call   802274 <sys_cputs>
  800813:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  800816:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80081c:	c9                   	leave  
  80081d:	c3                   	ret    

0080081e <cprintf>:

int cprintf(const char *fmt, ...) {
  80081e:	55                   	push   %ebp
  80081f:	89 e5                	mov    %esp,%ebp
  800821:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800824:	8d 45 0c             	lea    0xc(%ebp),%eax
  800827:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80082a:	8b 45 08             	mov    0x8(%ebp),%eax
  80082d:	83 ec 08             	sub    $0x8,%esp
  800830:	ff 75 f4             	pushl  -0xc(%ebp)
  800833:	50                   	push   %eax
  800834:	e8 8a ff ff ff       	call   8007c3 <vcprintf>
  800839:	83 c4 10             	add    $0x10,%esp
  80083c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80083f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800842:	c9                   	leave  
  800843:	c3                   	ret    

00800844 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800844:	55                   	push   %ebp
  800845:	89 e5                	mov    %esp,%ebp
  800847:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80084a:	e8 c4 1b 00 00       	call   802413 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80084f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800852:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800855:	8b 45 08             	mov    0x8(%ebp),%eax
  800858:	83 ec 08             	sub    $0x8,%esp
  80085b:	ff 75 f4             	pushl  -0xc(%ebp)
  80085e:	50                   	push   %eax
  80085f:	e8 5f ff ff ff       	call   8007c3 <vcprintf>
  800864:	83 c4 10             	add    $0x10,%esp
  800867:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80086a:	e8 be 1b 00 00       	call   80242d <sys_enable_interrupt>
	return cnt;
  80086f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800872:	c9                   	leave  
  800873:	c3                   	ret    

00800874 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800874:	55                   	push   %ebp
  800875:	89 e5                	mov    %esp,%ebp
  800877:	53                   	push   %ebx
  800878:	83 ec 14             	sub    $0x14,%esp
  80087b:	8b 45 10             	mov    0x10(%ebp),%eax
  80087e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800881:	8b 45 14             	mov    0x14(%ebp),%eax
  800884:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800887:	8b 45 18             	mov    0x18(%ebp),%eax
  80088a:	ba 00 00 00 00       	mov    $0x0,%edx
  80088f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800892:	77 55                	ja     8008e9 <printnum+0x75>
  800894:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800897:	72 05                	jb     80089e <printnum+0x2a>
  800899:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80089c:	77 4b                	ja     8008e9 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80089e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8008a1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008a4:	8b 45 18             	mov    0x18(%ebp),%eax
  8008a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ac:	52                   	push   %edx
  8008ad:	50                   	push   %eax
  8008ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8008b1:	ff 75 f0             	pushl  -0x10(%ebp)
  8008b4:	e8 f7 1e 00 00       	call   8027b0 <__udivdi3>
  8008b9:	83 c4 10             	add    $0x10,%esp
  8008bc:	83 ec 04             	sub    $0x4,%esp
  8008bf:	ff 75 20             	pushl  0x20(%ebp)
  8008c2:	53                   	push   %ebx
  8008c3:	ff 75 18             	pushl  0x18(%ebp)
  8008c6:	52                   	push   %edx
  8008c7:	50                   	push   %eax
  8008c8:	ff 75 0c             	pushl  0xc(%ebp)
  8008cb:	ff 75 08             	pushl  0x8(%ebp)
  8008ce:	e8 a1 ff ff ff       	call   800874 <printnum>
  8008d3:	83 c4 20             	add    $0x20,%esp
  8008d6:	eb 1a                	jmp    8008f2 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008d8:	83 ec 08             	sub    $0x8,%esp
  8008db:	ff 75 0c             	pushl  0xc(%ebp)
  8008de:	ff 75 20             	pushl  0x20(%ebp)
  8008e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e4:	ff d0                	call   *%eax
  8008e6:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008e9:	ff 4d 1c             	decl   0x1c(%ebp)
  8008ec:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008f0:	7f e6                	jg     8008d8 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008f2:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008f5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800900:	53                   	push   %ebx
  800901:	51                   	push   %ecx
  800902:	52                   	push   %edx
  800903:	50                   	push   %eax
  800904:	e8 b7 1f 00 00       	call   8028c0 <__umoddi3>
  800909:	83 c4 10             	add    $0x10,%esp
  80090c:	05 94 2e 80 00       	add    $0x802e94,%eax
  800911:	8a 00                	mov    (%eax),%al
  800913:	0f be c0             	movsbl %al,%eax
  800916:	83 ec 08             	sub    $0x8,%esp
  800919:	ff 75 0c             	pushl  0xc(%ebp)
  80091c:	50                   	push   %eax
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	ff d0                	call   *%eax
  800922:	83 c4 10             	add    $0x10,%esp
}
  800925:	90                   	nop
  800926:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800929:	c9                   	leave  
  80092a:	c3                   	ret    

0080092b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80092e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800932:	7e 1c                	jle    800950 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800934:	8b 45 08             	mov    0x8(%ebp),%eax
  800937:	8b 00                	mov    (%eax),%eax
  800939:	8d 50 08             	lea    0x8(%eax),%edx
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	89 10                	mov    %edx,(%eax)
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	83 e8 08             	sub    $0x8,%eax
  800949:	8b 50 04             	mov    0x4(%eax),%edx
  80094c:	8b 00                	mov    (%eax),%eax
  80094e:	eb 40                	jmp    800990 <getuint+0x65>
	else if (lflag)
  800950:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800954:	74 1e                	je     800974 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	8b 00                	mov    (%eax),%eax
  80095b:	8d 50 04             	lea    0x4(%eax),%edx
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	89 10                	mov    %edx,(%eax)
  800963:	8b 45 08             	mov    0x8(%ebp),%eax
  800966:	8b 00                	mov    (%eax),%eax
  800968:	83 e8 04             	sub    $0x4,%eax
  80096b:	8b 00                	mov    (%eax),%eax
  80096d:	ba 00 00 00 00       	mov    $0x0,%edx
  800972:	eb 1c                	jmp    800990 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	8b 00                	mov    (%eax),%eax
  800979:	8d 50 04             	lea    0x4(%eax),%edx
  80097c:	8b 45 08             	mov    0x8(%ebp),%eax
  80097f:	89 10                	mov    %edx,(%eax)
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	8b 00                	mov    (%eax),%eax
  800986:	83 e8 04             	sub    $0x4,%eax
  800989:	8b 00                	mov    (%eax),%eax
  80098b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800990:	5d                   	pop    %ebp
  800991:	c3                   	ret    

00800992 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800992:	55                   	push   %ebp
  800993:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800995:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800999:	7e 1c                	jle    8009b7 <getint+0x25>
		return va_arg(*ap, long long);
  80099b:	8b 45 08             	mov    0x8(%ebp),%eax
  80099e:	8b 00                	mov    (%eax),%eax
  8009a0:	8d 50 08             	lea    0x8(%eax),%edx
  8009a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a6:	89 10                	mov    %edx,(%eax)
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	8b 00                	mov    (%eax),%eax
  8009ad:	83 e8 08             	sub    $0x8,%eax
  8009b0:	8b 50 04             	mov    0x4(%eax),%edx
  8009b3:	8b 00                	mov    (%eax),%eax
  8009b5:	eb 38                	jmp    8009ef <getint+0x5d>
	else if (lflag)
  8009b7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009bb:	74 1a                	je     8009d7 <getint+0x45>
		return va_arg(*ap, long);
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	8b 00                	mov    (%eax),%eax
  8009c2:	8d 50 04             	lea    0x4(%eax),%edx
  8009c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c8:	89 10                	mov    %edx,(%eax)
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	8b 00                	mov    (%eax),%eax
  8009cf:	83 e8 04             	sub    $0x4,%eax
  8009d2:	8b 00                	mov    (%eax),%eax
  8009d4:	99                   	cltd   
  8009d5:	eb 18                	jmp    8009ef <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009da:	8b 00                	mov    (%eax),%eax
  8009dc:	8d 50 04             	lea    0x4(%eax),%edx
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	89 10                	mov    %edx,(%eax)
  8009e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e7:	8b 00                	mov    (%eax),%eax
  8009e9:	83 e8 04             	sub    $0x4,%eax
  8009ec:	8b 00                	mov    (%eax),%eax
  8009ee:	99                   	cltd   
}
  8009ef:	5d                   	pop    %ebp
  8009f0:	c3                   	ret    

008009f1 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009f1:	55                   	push   %ebp
  8009f2:	89 e5                	mov    %esp,%ebp
  8009f4:	56                   	push   %esi
  8009f5:	53                   	push   %ebx
  8009f6:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009f9:	eb 17                	jmp    800a12 <vprintfmt+0x21>
			if (ch == '\0')
  8009fb:	85 db                	test   %ebx,%ebx
  8009fd:	0f 84 af 03 00 00    	je     800db2 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800a03:	83 ec 08             	sub    $0x8,%esp
  800a06:	ff 75 0c             	pushl  0xc(%ebp)
  800a09:	53                   	push   %ebx
  800a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0d:	ff d0                	call   *%eax
  800a0f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a12:	8b 45 10             	mov    0x10(%ebp),%eax
  800a15:	8d 50 01             	lea    0x1(%eax),%edx
  800a18:	89 55 10             	mov    %edx,0x10(%ebp)
  800a1b:	8a 00                	mov    (%eax),%al
  800a1d:	0f b6 d8             	movzbl %al,%ebx
  800a20:	83 fb 25             	cmp    $0x25,%ebx
  800a23:	75 d6                	jne    8009fb <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a25:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a29:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a30:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a37:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a3e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a45:	8b 45 10             	mov    0x10(%ebp),%eax
  800a48:	8d 50 01             	lea    0x1(%eax),%edx
  800a4b:	89 55 10             	mov    %edx,0x10(%ebp)
  800a4e:	8a 00                	mov    (%eax),%al
  800a50:	0f b6 d8             	movzbl %al,%ebx
  800a53:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a56:	83 f8 55             	cmp    $0x55,%eax
  800a59:	0f 87 2b 03 00 00    	ja     800d8a <vprintfmt+0x399>
  800a5f:	8b 04 85 b8 2e 80 00 	mov    0x802eb8(,%eax,4),%eax
  800a66:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a68:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a6c:	eb d7                	jmp    800a45 <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a6e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a72:	eb d1                	jmp    800a45 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a74:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a7b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a7e:	89 d0                	mov    %edx,%eax
  800a80:	c1 e0 02             	shl    $0x2,%eax
  800a83:	01 d0                	add    %edx,%eax
  800a85:	01 c0                	add    %eax,%eax
  800a87:	01 d8                	add    %ebx,%eax
  800a89:	83 e8 30             	sub    $0x30,%eax
  800a8c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800a92:	8a 00                	mov    (%eax),%al
  800a94:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a97:	83 fb 2f             	cmp    $0x2f,%ebx
  800a9a:	7e 3e                	jle    800ada <vprintfmt+0xe9>
  800a9c:	83 fb 39             	cmp    $0x39,%ebx
  800a9f:	7f 39                	jg     800ada <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800aa1:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800aa4:	eb d5                	jmp    800a7b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800aa6:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa9:	83 c0 04             	add    $0x4,%eax
  800aac:	89 45 14             	mov    %eax,0x14(%ebp)
  800aaf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab2:	83 e8 04             	sub    $0x4,%eax
  800ab5:	8b 00                	mov    (%eax),%eax
  800ab7:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800aba:	eb 1f                	jmp    800adb <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800abc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac0:	79 83                	jns    800a45 <vprintfmt+0x54>
				width = 0;
  800ac2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ac9:	e9 77 ff ff ff       	jmp    800a45 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ace:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ad5:	e9 6b ff ff ff       	jmp    800a45 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ada:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800adb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800adf:	0f 89 60 ff ff ff    	jns    800a45 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ae5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ae8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800aeb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800af2:	e9 4e ff ff ff       	jmp    800a45 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800af7:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800afa:	e9 46 ff ff ff       	jmp    800a45 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800aff:	8b 45 14             	mov    0x14(%ebp),%eax
  800b02:	83 c0 04             	add    $0x4,%eax
  800b05:	89 45 14             	mov    %eax,0x14(%ebp)
  800b08:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0b:	83 e8 04             	sub    $0x4,%eax
  800b0e:	8b 00                	mov    (%eax),%eax
  800b10:	83 ec 08             	sub    $0x8,%esp
  800b13:	ff 75 0c             	pushl  0xc(%ebp)
  800b16:	50                   	push   %eax
  800b17:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1a:	ff d0                	call   *%eax
  800b1c:	83 c4 10             	add    $0x10,%esp
			break;
  800b1f:	e9 89 02 00 00       	jmp    800dad <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b24:	8b 45 14             	mov    0x14(%ebp),%eax
  800b27:	83 c0 04             	add    $0x4,%eax
  800b2a:	89 45 14             	mov    %eax,0x14(%ebp)
  800b2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b30:	83 e8 04             	sub    $0x4,%eax
  800b33:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b35:	85 db                	test   %ebx,%ebx
  800b37:	79 02                	jns    800b3b <vprintfmt+0x14a>
				err = -err;
  800b39:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b3b:	83 fb 64             	cmp    $0x64,%ebx
  800b3e:	7f 0b                	jg     800b4b <vprintfmt+0x15a>
  800b40:	8b 34 9d 00 2d 80 00 	mov    0x802d00(,%ebx,4),%esi
  800b47:	85 f6                	test   %esi,%esi
  800b49:	75 19                	jne    800b64 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b4b:	53                   	push   %ebx
  800b4c:	68 a5 2e 80 00       	push   $0x802ea5
  800b51:	ff 75 0c             	pushl  0xc(%ebp)
  800b54:	ff 75 08             	pushl  0x8(%ebp)
  800b57:	e8 5e 02 00 00       	call   800dba <printfmt>
  800b5c:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b5f:	e9 49 02 00 00       	jmp    800dad <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b64:	56                   	push   %esi
  800b65:	68 ae 2e 80 00       	push   $0x802eae
  800b6a:	ff 75 0c             	pushl  0xc(%ebp)
  800b6d:	ff 75 08             	pushl  0x8(%ebp)
  800b70:	e8 45 02 00 00       	call   800dba <printfmt>
  800b75:	83 c4 10             	add    $0x10,%esp
			break;
  800b78:	e9 30 02 00 00       	jmp    800dad <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b80:	83 c0 04             	add    $0x4,%eax
  800b83:	89 45 14             	mov    %eax,0x14(%ebp)
  800b86:	8b 45 14             	mov    0x14(%ebp),%eax
  800b89:	83 e8 04             	sub    $0x4,%eax
  800b8c:	8b 30                	mov    (%eax),%esi
  800b8e:	85 f6                	test   %esi,%esi
  800b90:	75 05                	jne    800b97 <vprintfmt+0x1a6>
				p = "(null)";
  800b92:	be b1 2e 80 00       	mov    $0x802eb1,%esi
			if (width > 0 && padc != '-')
  800b97:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b9b:	7e 6d                	jle    800c0a <vprintfmt+0x219>
  800b9d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ba1:	74 67                	je     800c0a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ba3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ba6:	83 ec 08             	sub    $0x8,%esp
  800ba9:	50                   	push   %eax
  800baa:	56                   	push   %esi
  800bab:	e8 12 05 00 00       	call   8010c2 <strnlen>
  800bb0:	83 c4 10             	add    $0x10,%esp
  800bb3:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800bb6:	eb 16                	jmp    800bce <vprintfmt+0x1dd>
					putch(padc, putdat);
  800bb8:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800bbc:	83 ec 08             	sub    $0x8,%esp
  800bbf:	ff 75 0c             	pushl  0xc(%ebp)
  800bc2:	50                   	push   %eax
  800bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc6:	ff d0                	call   *%eax
  800bc8:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bcb:	ff 4d e4             	decl   -0x1c(%ebp)
  800bce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bd2:	7f e4                	jg     800bb8 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bd4:	eb 34                	jmp    800c0a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800bd6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800bda:	74 1c                	je     800bf8 <vprintfmt+0x207>
  800bdc:	83 fb 1f             	cmp    $0x1f,%ebx
  800bdf:	7e 05                	jle    800be6 <vprintfmt+0x1f5>
  800be1:	83 fb 7e             	cmp    $0x7e,%ebx
  800be4:	7e 12                	jle    800bf8 <vprintfmt+0x207>
					putch('?', putdat);
  800be6:	83 ec 08             	sub    $0x8,%esp
  800be9:	ff 75 0c             	pushl  0xc(%ebp)
  800bec:	6a 3f                	push   $0x3f
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	ff d0                	call   *%eax
  800bf3:	83 c4 10             	add    $0x10,%esp
  800bf6:	eb 0f                	jmp    800c07 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800bf8:	83 ec 08             	sub    $0x8,%esp
  800bfb:	ff 75 0c             	pushl  0xc(%ebp)
  800bfe:	53                   	push   %ebx
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	ff d0                	call   *%eax
  800c04:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c07:	ff 4d e4             	decl   -0x1c(%ebp)
  800c0a:	89 f0                	mov    %esi,%eax
  800c0c:	8d 70 01             	lea    0x1(%eax),%esi
  800c0f:	8a 00                	mov    (%eax),%al
  800c11:	0f be d8             	movsbl %al,%ebx
  800c14:	85 db                	test   %ebx,%ebx
  800c16:	74 24                	je     800c3c <vprintfmt+0x24b>
  800c18:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c1c:	78 b8                	js     800bd6 <vprintfmt+0x1e5>
  800c1e:	ff 4d e0             	decl   -0x20(%ebp)
  800c21:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c25:	79 af                	jns    800bd6 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c27:	eb 13                	jmp    800c3c <vprintfmt+0x24b>
				putch(' ', putdat);
  800c29:	83 ec 08             	sub    $0x8,%esp
  800c2c:	ff 75 0c             	pushl  0xc(%ebp)
  800c2f:	6a 20                	push   $0x20
  800c31:	8b 45 08             	mov    0x8(%ebp),%eax
  800c34:	ff d0                	call   *%eax
  800c36:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c39:	ff 4d e4             	decl   -0x1c(%ebp)
  800c3c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c40:	7f e7                	jg     800c29 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c42:	e9 66 01 00 00       	jmp    800dad <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c47:	83 ec 08             	sub    $0x8,%esp
  800c4a:	ff 75 e8             	pushl  -0x18(%ebp)
  800c4d:	8d 45 14             	lea    0x14(%ebp),%eax
  800c50:	50                   	push   %eax
  800c51:	e8 3c fd ff ff       	call   800992 <getint>
  800c56:	83 c4 10             	add    $0x10,%esp
  800c59:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c5c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c65:	85 d2                	test   %edx,%edx
  800c67:	79 23                	jns    800c8c <vprintfmt+0x29b>
				putch('-', putdat);
  800c69:	83 ec 08             	sub    $0x8,%esp
  800c6c:	ff 75 0c             	pushl  0xc(%ebp)
  800c6f:	6a 2d                	push   $0x2d
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	ff d0                	call   *%eax
  800c76:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c7f:	f7 d8                	neg    %eax
  800c81:	83 d2 00             	adc    $0x0,%edx
  800c84:	f7 da                	neg    %edx
  800c86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c89:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c8c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c93:	e9 bc 00 00 00       	jmp    800d54 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c98:	83 ec 08             	sub    $0x8,%esp
  800c9b:	ff 75 e8             	pushl  -0x18(%ebp)
  800c9e:	8d 45 14             	lea    0x14(%ebp),%eax
  800ca1:	50                   	push   %eax
  800ca2:	e8 84 fc ff ff       	call   80092b <getuint>
  800ca7:	83 c4 10             	add    $0x10,%esp
  800caa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cad:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800cb0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cb7:	e9 98 00 00 00       	jmp    800d54 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800cbc:	83 ec 08             	sub    $0x8,%esp
  800cbf:	ff 75 0c             	pushl  0xc(%ebp)
  800cc2:	6a 58                	push   $0x58
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	ff d0                	call   *%eax
  800cc9:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ccc:	83 ec 08             	sub    $0x8,%esp
  800ccf:	ff 75 0c             	pushl  0xc(%ebp)
  800cd2:	6a 58                	push   $0x58
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	ff d0                	call   *%eax
  800cd9:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cdc:	83 ec 08             	sub    $0x8,%esp
  800cdf:	ff 75 0c             	pushl  0xc(%ebp)
  800ce2:	6a 58                	push   $0x58
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	ff d0                	call   *%eax
  800ce9:	83 c4 10             	add    $0x10,%esp
			break;
  800cec:	e9 bc 00 00 00       	jmp    800dad <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800cf1:	83 ec 08             	sub    $0x8,%esp
  800cf4:	ff 75 0c             	pushl  0xc(%ebp)
  800cf7:	6a 30                	push   $0x30
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	ff d0                	call   *%eax
  800cfe:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d01:	83 ec 08             	sub    $0x8,%esp
  800d04:	ff 75 0c             	pushl  0xc(%ebp)
  800d07:	6a 78                	push   $0x78
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	ff d0                	call   *%eax
  800d0e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d11:	8b 45 14             	mov    0x14(%ebp),%eax
  800d14:	83 c0 04             	add    $0x4,%eax
  800d17:	89 45 14             	mov    %eax,0x14(%ebp)
  800d1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1d:	83 e8 04             	sub    $0x4,%eax
  800d20:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d22:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d2c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d33:	eb 1f                	jmp    800d54 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d35:	83 ec 08             	sub    $0x8,%esp
  800d38:	ff 75 e8             	pushl  -0x18(%ebp)
  800d3b:	8d 45 14             	lea    0x14(%ebp),%eax
  800d3e:	50                   	push   %eax
  800d3f:	e8 e7 fb ff ff       	call   80092b <getuint>
  800d44:	83 c4 10             	add    $0x10,%esp
  800d47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d4a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d4d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d54:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d5b:	83 ec 04             	sub    $0x4,%esp
  800d5e:	52                   	push   %edx
  800d5f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d62:	50                   	push   %eax
  800d63:	ff 75 f4             	pushl  -0xc(%ebp)
  800d66:	ff 75 f0             	pushl  -0x10(%ebp)
  800d69:	ff 75 0c             	pushl  0xc(%ebp)
  800d6c:	ff 75 08             	pushl  0x8(%ebp)
  800d6f:	e8 00 fb ff ff       	call   800874 <printnum>
  800d74:	83 c4 20             	add    $0x20,%esp
			break;
  800d77:	eb 34                	jmp    800dad <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d79:	83 ec 08             	sub    $0x8,%esp
  800d7c:	ff 75 0c             	pushl  0xc(%ebp)
  800d7f:	53                   	push   %ebx
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	ff d0                	call   *%eax
  800d85:	83 c4 10             	add    $0x10,%esp
			break;
  800d88:	eb 23                	jmp    800dad <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d8a:	83 ec 08             	sub    $0x8,%esp
  800d8d:	ff 75 0c             	pushl  0xc(%ebp)
  800d90:	6a 25                	push   $0x25
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	ff d0                	call   *%eax
  800d97:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d9a:	ff 4d 10             	decl   0x10(%ebp)
  800d9d:	eb 03                	jmp    800da2 <vprintfmt+0x3b1>
  800d9f:	ff 4d 10             	decl   0x10(%ebp)
  800da2:	8b 45 10             	mov    0x10(%ebp),%eax
  800da5:	48                   	dec    %eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	3c 25                	cmp    $0x25,%al
  800daa:	75 f3                	jne    800d9f <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800dac:	90                   	nop
		}
	}
  800dad:	e9 47 fc ff ff       	jmp    8009f9 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800db2:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800db3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800db6:	5b                   	pop    %ebx
  800db7:	5e                   	pop    %esi
  800db8:	5d                   	pop    %ebp
  800db9:	c3                   	ret    

00800dba <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
  800dbd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800dc0:	8d 45 10             	lea    0x10(%ebp),%eax
  800dc3:	83 c0 04             	add    $0x4,%eax
  800dc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800dc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dcc:	ff 75 f4             	pushl  -0xc(%ebp)
  800dcf:	50                   	push   %eax
  800dd0:	ff 75 0c             	pushl  0xc(%ebp)
  800dd3:	ff 75 08             	pushl  0x8(%ebp)
  800dd6:	e8 16 fc ff ff       	call   8009f1 <vprintfmt>
  800ddb:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800dde:	90                   	nop
  800ddf:	c9                   	leave  
  800de0:	c3                   	ret    

00800de1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800de4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de7:	8b 40 08             	mov    0x8(%eax),%eax
  800dea:	8d 50 01             	lea    0x1(%eax),%edx
  800ded:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df0:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800df3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df6:	8b 10                	mov    (%eax),%edx
  800df8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfb:	8b 40 04             	mov    0x4(%eax),%eax
  800dfe:	39 c2                	cmp    %eax,%edx
  800e00:	73 12                	jae    800e14 <sprintputch+0x33>
		*b->buf++ = ch;
  800e02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e05:	8b 00                	mov    (%eax),%eax
  800e07:	8d 48 01             	lea    0x1(%eax),%ecx
  800e0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e0d:	89 0a                	mov    %ecx,(%edx)
  800e0f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e12:	88 10                	mov    %dl,(%eax)
}
  800e14:	90                   	nop
  800e15:	5d                   	pop    %ebp
  800e16:	c3                   	ret    

00800e17 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e26:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	01 d0                	add    %edx,%eax
  800e2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e3c:	74 06                	je     800e44 <vsnprintf+0x2d>
  800e3e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e42:	7f 07                	jg     800e4b <vsnprintf+0x34>
		return -E_INVAL;
  800e44:	b8 03 00 00 00       	mov    $0x3,%eax
  800e49:	eb 20                	jmp    800e6b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e4b:	ff 75 14             	pushl  0x14(%ebp)
  800e4e:	ff 75 10             	pushl  0x10(%ebp)
  800e51:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e54:	50                   	push   %eax
  800e55:	68 e1 0d 80 00       	push   $0x800de1
  800e5a:	e8 92 fb ff ff       	call   8009f1 <vprintfmt>
  800e5f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e65:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e6b:	c9                   	leave  
  800e6c:	c3                   	ret    

00800e6d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e6d:	55                   	push   %ebp
  800e6e:	89 e5                	mov    %esp,%ebp
  800e70:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e73:	8d 45 10             	lea    0x10(%ebp),%eax
  800e76:	83 c0 04             	add    $0x4,%eax
  800e79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7f:	ff 75 f4             	pushl  -0xc(%ebp)
  800e82:	50                   	push   %eax
  800e83:	ff 75 0c             	pushl  0xc(%ebp)
  800e86:	ff 75 08             	pushl  0x8(%ebp)
  800e89:	e8 89 ff ff ff       	call   800e17 <vsnprintf>
  800e8e:	83 c4 10             	add    $0x10,%esp
  800e91:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e94:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e97:	c9                   	leave  
  800e98:	c3                   	ret    

00800e99 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800e99:	55                   	push   %ebp
  800e9a:	89 e5                	mov    %esp,%ebp
  800e9c:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  800e9f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ea3:	74 13                	je     800eb8 <readline+0x1f>
		cprintf("%s", prompt);
  800ea5:	83 ec 08             	sub    $0x8,%esp
  800ea8:	ff 75 08             	pushl  0x8(%ebp)
  800eab:	68 10 30 80 00       	push   $0x803010
  800eb0:	e8 69 f9 ff ff       	call   80081e <cprintf>
  800eb5:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800eb8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800ebf:	83 ec 0c             	sub    $0xc,%esp
  800ec2:	6a 00                	push   $0x0
  800ec4:	e8 5f f7 ff ff       	call   800628 <iscons>
  800ec9:	83 c4 10             	add    $0x10,%esp
  800ecc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800ecf:	e8 06 f7 ff ff       	call   8005da <getchar>
  800ed4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800ed7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800edb:	79 22                	jns    800eff <readline+0x66>
			if (c != -E_EOF)
  800edd:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800ee1:	0f 84 ad 00 00 00    	je     800f94 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800ee7:	83 ec 08             	sub    $0x8,%esp
  800eea:	ff 75 ec             	pushl  -0x14(%ebp)
  800eed:	68 13 30 80 00       	push   $0x803013
  800ef2:	e8 27 f9 ff ff       	call   80081e <cprintf>
  800ef7:	83 c4 10             	add    $0x10,%esp
			return;
  800efa:	e9 95 00 00 00       	jmp    800f94 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800eff:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800f03:	7e 34                	jle    800f39 <readline+0xa0>
  800f05:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800f0c:	7f 2b                	jg     800f39 <readline+0xa0>
			if (echoing)
  800f0e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f12:	74 0e                	je     800f22 <readline+0x89>
				cputchar(c);
  800f14:	83 ec 0c             	sub    $0xc,%esp
  800f17:	ff 75 ec             	pushl  -0x14(%ebp)
  800f1a:	e8 73 f6 ff ff       	call   800592 <cputchar>
  800f1f:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f25:	8d 50 01             	lea    0x1(%eax),%edx
  800f28:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800f2b:	89 c2                	mov    %eax,%edx
  800f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f30:	01 d0                	add    %edx,%eax
  800f32:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f35:	88 10                	mov    %dl,(%eax)
  800f37:	eb 56                	jmp    800f8f <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800f39:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800f3d:	75 1f                	jne    800f5e <readline+0xc5>
  800f3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800f43:	7e 19                	jle    800f5e <readline+0xc5>
			if (echoing)
  800f45:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f49:	74 0e                	je     800f59 <readline+0xc0>
				cputchar(c);
  800f4b:	83 ec 0c             	sub    $0xc,%esp
  800f4e:	ff 75 ec             	pushl  -0x14(%ebp)
  800f51:	e8 3c f6 ff ff       	call   800592 <cputchar>
  800f56:	83 c4 10             	add    $0x10,%esp

			i--;
  800f59:	ff 4d f4             	decl   -0xc(%ebp)
  800f5c:	eb 31                	jmp    800f8f <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800f5e:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800f62:	74 0a                	je     800f6e <readline+0xd5>
  800f64:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800f68:	0f 85 61 ff ff ff    	jne    800ecf <readline+0x36>
			if (echoing)
  800f6e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f72:	74 0e                	je     800f82 <readline+0xe9>
				cputchar(c);
  800f74:	83 ec 0c             	sub    $0xc,%esp
  800f77:	ff 75 ec             	pushl  -0x14(%ebp)
  800f7a:	e8 13 f6 ff ff       	call   800592 <cputchar>
  800f7f:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800f82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f88:	01 d0                	add    %edx,%eax
  800f8a:	c6 00 00             	movb   $0x0,(%eax)
			return;
  800f8d:	eb 06                	jmp    800f95 <readline+0xfc>
		}
	}
  800f8f:	e9 3b ff ff ff       	jmp    800ecf <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  800f94:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  800f95:	c9                   	leave  
  800f96:	c3                   	ret    

00800f97 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800f97:	55                   	push   %ebp
  800f98:	89 e5                	mov    %esp,%ebp
  800f9a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f9d:	e8 71 14 00 00       	call   802413 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  800fa2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fa6:	74 13                	je     800fbb <atomic_readline+0x24>
		cprintf("%s", prompt);
  800fa8:	83 ec 08             	sub    $0x8,%esp
  800fab:	ff 75 08             	pushl  0x8(%ebp)
  800fae:	68 10 30 80 00       	push   $0x803010
  800fb3:	e8 66 f8 ff ff       	call   80081e <cprintf>
  800fb8:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800fbb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800fc2:	83 ec 0c             	sub    $0xc,%esp
  800fc5:	6a 00                	push   $0x0
  800fc7:	e8 5c f6 ff ff       	call   800628 <iscons>
  800fcc:	83 c4 10             	add    $0x10,%esp
  800fcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800fd2:	e8 03 f6 ff ff       	call   8005da <getchar>
  800fd7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800fda:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800fde:	79 23                	jns    801003 <atomic_readline+0x6c>
			if (c != -E_EOF)
  800fe0:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800fe4:	74 13                	je     800ff9 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  800fe6:	83 ec 08             	sub    $0x8,%esp
  800fe9:	ff 75 ec             	pushl  -0x14(%ebp)
  800fec:	68 13 30 80 00       	push   $0x803013
  800ff1:	e8 28 f8 ff ff       	call   80081e <cprintf>
  800ff6:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800ff9:	e8 2f 14 00 00       	call   80242d <sys_enable_interrupt>
			return;
  800ffe:	e9 9a 00 00 00       	jmp    80109d <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801003:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801007:	7e 34                	jle    80103d <atomic_readline+0xa6>
  801009:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801010:	7f 2b                	jg     80103d <atomic_readline+0xa6>
			if (echoing)
  801012:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801016:	74 0e                	je     801026 <atomic_readline+0x8f>
				cputchar(c);
  801018:	83 ec 0c             	sub    $0xc,%esp
  80101b:	ff 75 ec             	pushl  -0x14(%ebp)
  80101e:	e8 6f f5 ff ff       	call   800592 <cputchar>
  801023:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801026:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801029:	8d 50 01             	lea    0x1(%eax),%edx
  80102c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80102f:	89 c2                	mov    %eax,%edx
  801031:	8b 45 0c             	mov    0xc(%ebp),%eax
  801034:	01 d0                	add    %edx,%eax
  801036:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801039:	88 10                	mov    %dl,(%eax)
  80103b:	eb 5b                	jmp    801098 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80103d:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801041:	75 1f                	jne    801062 <atomic_readline+0xcb>
  801043:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801047:	7e 19                	jle    801062 <atomic_readline+0xcb>
			if (echoing)
  801049:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80104d:	74 0e                	je     80105d <atomic_readline+0xc6>
				cputchar(c);
  80104f:	83 ec 0c             	sub    $0xc,%esp
  801052:	ff 75 ec             	pushl  -0x14(%ebp)
  801055:	e8 38 f5 ff ff       	call   800592 <cputchar>
  80105a:	83 c4 10             	add    $0x10,%esp
			i--;
  80105d:	ff 4d f4             	decl   -0xc(%ebp)
  801060:	eb 36                	jmp    801098 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801062:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801066:	74 0a                	je     801072 <atomic_readline+0xdb>
  801068:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80106c:	0f 85 60 ff ff ff    	jne    800fd2 <atomic_readline+0x3b>
			if (echoing)
  801072:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801076:	74 0e                	je     801086 <atomic_readline+0xef>
				cputchar(c);
  801078:	83 ec 0c             	sub    $0xc,%esp
  80107b:	ff 75 ec             	pushl  -0x14(%ebp)
  80107e:	e8 0f f5 ff ff       	call   800592 <cputchar>
  801083:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  801086:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801089:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108c:	01 d0                	add    %edx,%eax
  80108e:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  801091:	e8 97 13 00 00       	call   80242d <sys_enable_interrupt>
			return;
  801096:	eb 05                	jmp    80109d <atomic_readline+0x106>
		}
	}
  801098:	e9 35 ff ff ff       	jmp    800fd2 <atomic_readline+0x3b>
}
  80109d:	c9                   	leave  
  80109e:	c3                   	ret    

0080109f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80109f:	55                   	push   %ebp
  8010a0:	89 e5                	mov    %esp,%ebp
  8010a2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8010a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010ac:	eb 06                	jmp    8010b4 <strlen+0x15>
		n++;
  8010ae:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010b1:	ff 45 08             	incl   0x8(%ebp)
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	8a 00                	mov    (%eax),%al
  8010b9:	84 c0                	test   %al,%al
  8010bb:	75 f1                	jne    8010ae <strlen+0xf>
		n++;
	return n;
  8010bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010c0:	c9                   	leave  
  8010c1:	c3                   	ret    

008010c2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8010c2:	55                   	push   %ebp
  8010c3:	89 e5                	mov    %esp,%ebp
  8010c5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010cf:	eb 09                	jmp    8010da <strnlen+0x18>
		n++;
  8010d1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010d4:	ff 45 08             	incl   0x8(%ebp)
  8010d7:	ff 4d 0c             	decl   0xc(%ebp)
  8010da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010de:	74 09                	je     8010e9 <strnlen+0x27>
  8010e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e3:	8a 00                	mov    (%eax),%al
  8010e5:	84 c0                	test   %al,%al
  8010e7:	75 e8                	jne    8010d1 <strnlen+0xf>
		n++;
	return n;
  8010e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010ec:	c9                   	leave  
  8010ed:	c3                   	ret    

008010ee <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010ee:	55                   	push   %ebp
  8010ef:	89 e5                	mov    %esp,%ebp
  8010f1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010fa:	90                   	nop
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	8d 50 01             	lea    0x1(%eax),%edx
  801101:	89 55 08             	mov    %edx,0x8(%ebp)
  801104:	8b 55 0c             	mov    0xc(%ebp),%edx
  801107:	8d 4a 01             	lea    0x1(%edx),%ecx
  80110a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80110d:	8a 12                	mov    (%edx),%dl
  80110f:	88 10                	mov    %dl,(%eax)
  801111:	8a 00                	mov    (%eax),%al
  801113:	84 c0                	test   %al,%al
  801115:	75 e4                	jne    8010fb <strcpy+0xd>
		/* do nothing */;
	return ret;
  801117:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80111a:	c9                   	leave  
  80111b:	c3                   	ret    

0080111c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801128:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80112f:	eb 1f                	jmp    801150 <strncpy+0x34>
		*dst++ = *src;
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
  801134:	8d 50 01             	lea    0x1(%eax),%edx
  801137:	89 55 08             	mov    %edx,0x8(%ebp)
  80113a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80113d:	8a 12                	mov    (%edx),%dl
  80113f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801141:	8b 45 0c             	mov    0xc(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	84 c0                	test   %al,%al
  801148:	74 03                	je     80114d <strncpy+0x31>
			src++;
  80114a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80114d:	ff 45 fc             	incl   -0x4(%ebp)
  801150:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801153:	3b 45 10             	cmp    0x10(%ebp),%eax
  801156:	72 d9                	jb     801131 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801158:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80115b:	c9                   	leave  
  80115c:	c3                   	ret    

0080115d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80115d:	55                   	push   %ebp
  80115e:	89 e5                	mov    %esp,%ebp
  801160:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801169:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80116d:	74 30                	je     80119f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80116f:	eb 16                	jmp    801187 <strlcpy+0x2a>
			*dst++ = *src++;
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	8d 50 01             	lea    0x1(%eax),%edx
  801177:	89 55 08             	mov    %edx,0x8(%ebp)
  80117a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80117d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801180:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801183:	8a 12                	mov    (%edx),%dl
  801185:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801187:	ff 4d 10             	decl   0x10(%ebp)
  80118a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80118e:	74 09                	je     801199 <strlcpy+0x3c>
  801190:	8b 45 0c             	mov    0xc(%ebp),%eax
  801193:	8a 00                	mov    (%eax),%al
  801195:	84 c0                	test   %al,%al
  801197:	75 d8                	jne    801171 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801199:	8b 45 08             	mov    0x8(%ebp),%eax
  80119c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80119f:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a5:	29 c2                	sub    %eax,%edx
  8011a7:	89 d0                	mov    %edx,%eax
}
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8011ae:	eb 06                	jmp    8011b6 <strcmp+0xb>
		p++, q++;
  8011b0:	ff 45 08             	incl   0x8(%ebp)
  8011b3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b9:	8a 00                	mov    (%eax),%al
  8011bb:	84 c0                	test   %al,%al
  8011bd:	74 0e                	je     8011cd <strcmp+0x22>
  8011bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c2:	8a 10                	mov    (%eax),%dl
  8011c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c7:	8a 00                	mov    (%eax),%al
  8011c9:	38 c2                	cmp    %al,%dl
  8011cb:	74 e3                	je     8011b0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	8a 00                	mov    (%eax),%al
  8011d2:	0f b6 d0             	movzbl %al,%edx
  8011d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d8:	8a 00                	mov    (%eax),%al
  8011da:	0f b6 c0             	movzbl %al,%eax
  8011dd:	29 c2                	sub    %eax,%edx
  8011df:	89 d0                	mov    %edx,%eax
}
  8011e1:	5d                   	pop    %ebp
  8011e2:	c3                   	ret    

008011e3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8011e3:	55                   	push   %ebp
  8011e4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8011e6:	eb 09                	jmp    8011f1 <strncmp+0xe>
		n--, p++, q++;
  8011e8:	ff 4d 10             	decl   0x10(%ebp)
  8011eb:	ff 45 08             	incl   0x8(%ebp)
  8011ee:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8011f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011f5:	74 17                	je     80120e <strncmp+0x2b>
  8011f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fa:	8a 00                	mov    (%eax),%al
  8011fc:	84 c0                	test   %al,%al
  8011fe:	74 0e                	je     80120e <strncmp+0x2b>
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
  801203:	8a 10                	mov    (%eax),%dl
  801205:	8b 45 0c             	mov    0xc(%ebp),%eax
  801208:	8a 00                	mov    (%eax),%al
  80120a:	38 c2                	cmp    %al,%dl
  80120c:	74 da                	je     8011e8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80120e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801212:	75 07                	jne    80121b <strncmp+0x38>
		return 0;
  801214:	b8 00 00 00 00       	mov    $0x0,%eax
  801219:	eb 14                	jmp    80122f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80121b:	8b 45 08             	mov    0x8(%ebp),%eax
  80121e:	8a 00                	mov    (%eax),%al
  801220:	0f b6 d0             	movzbl %al,%edx
  801223:	8b 45 0c             	mov    0xc(%ebp),%eax
  801226:	8a 00                	mov    (%eax),%al
  801228:	0f b6 c0             	movzbl %al,%eax
  80122b:	29 c2                	sub    %eax,%edx
  80122d:	89 d0                	mov    %edx,%eax
}
  80122f:	5d                   	pop    %ebp
  801230:	c3                   	ret    

00801231 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801231:	55                   	push   %ebp
  801232:	89 e5                	mov    %esp,%ebp
  801234:	83 ec 04             	sub    $0x4,%esp
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80123d:	eb 12                	jmp    801251 <strchr+0x20>
		if (*s == c)
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
  801242:	8a 00                	mov    (%eax),%al
  801244:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801247:	75 05                	jne    80124e <strchr+0x1d>
			return (char *) s;
  801249:	8b 45 08             	mov    0x8(%ebp),%eax
  80124c:	eb 11                	jmp    80125f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80124e:	ff 45 08             	incl   0x8(%ebp)
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	8a 00                	mov    (%eax),%al
  801256:	84 c0                	test   %al,%al
  801258:	75 e5                	jne    80123f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80125a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80125f:	c9                   	leave  
  801260:	c3                   	ret    

00801261 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801261:	55                   	push   %ebp
  801262:	89 e5                	mov    %esp,%ebp
  801264:	83 ec 04             	sub    $0x4,%esp
  801267:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80126d:	eb 0d                	jmp    80127c <strfind+0x1b>
		if (*s == c)
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
  801272:	8a 00                	mov    (%eax),%al
  801274:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801277:	74 0e                	je     801287 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801279:	ff 45 08             	incl   0x8(%ebp)
  80127c:	8b 45 08             	mov    0x8(%ebp),%eax
  80127f:	8a 00                	mov    (%eax),%al
  801281:	84 c0                	test   %al,%al
  801283:	75 ea                	jne    80126f <strfind+0xe>
  801285:	eb 01                	jmp    801288 <strfind+0x27>
		if (*s == c)
			break;
  801287:	90                   	nop
	return (char *) s;
  801288:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80128b:	c9                   	leave  
  80128c:	c3                   	ret    

0080128d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80128d:	55                   	push   %ebp
  80128e:	89 e5                	mov    %esp,%ebp
  801290:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801293:	8b 45 08             	mov    0x8(%ebp),%eax
  801296:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801299:	8b 45 10             	mov    0x10(%ebp),%eax
  80129c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80129f:	eb 0e                	jmp    8012af <memset+0x22>
		*p++ = c;
  8012a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a4:	8d 50 01             	lea    0x1(%eax),%edx
  8012a7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ad:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8012af:	ff 4d f8             	decl   -0x8(%ebp)
  8012b2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8012b6:	79 e9                	jns    8012a1 <memset+0x14>
		*p++ = c;

	return v;
  8012b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012bb:	c9                   	leave  
  8012bc:	c3                   	ret    

008012bd <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
  8012c0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8012cf:	eb 16                	jmp    8012e7 <memcpy+0x2a>
		*d++ = *s++;
  8012d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d4:	8d 50 01             	lea    0x1(%eax),%edx
  8012d7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012da:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012dd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012e0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012e3:	8a 12                	mov    (%edx),%dl
  8012e5:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8012e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ea:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012ed:	89 55 10             	mov    %edx,0x10(%ebp)
  8012f0:	85 c0                	test   %eax,%eax
  8012f2:	75 dd                	jne    8012d1 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8012f4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012f7:	c9                   	leave  
  8012f8:	c3                   	ret    

008012f9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012f9:	55                   	push   %ebp
  8012fa:	89 e5                	mov    %esp,%ebp
  8012fc:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  8012ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801302:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80130b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80130e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801311:	73 50                	jae    801363 <memmove+0x6a>
  801313:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801316:	8b 45 10             	mov    0x10(%ebp),%eax
  801319:	01 d0                	add    %edx,%eax
  80131b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80131e:	76 43                	jbe    801363 <memmove+0x6a>
		s += n;
  801320:	8b 45 10             	mov    0x10(%ebp),%eax
  801323:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801326:	8b 45 10             	mov    0x10(%ebp),%eax
  801329:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80132c:	eb 10                	jmp    80133e <memmove+0x45>
			*--d = *--s;
  80132e:	ff 4d f8             	decl   -0x8(%ebp)
  801331:	ff 4d fc             	decl   -0x4(%ebp)
  801334:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801337:	8a 10                	mov    (%eax),%dl
  801339:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80133c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80133e:	8b 45 10             	mov    0x10(%ebp),%eax
  801341:	8d 50 ff             	lea    -0x1(%eax),%edx
  801344:	89 55 10             	mov    %edx,0x10(%ebp)
  801347:	85 c0                	test   %eax,%eax
  801349:	75 e3                	jne    80132e <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80134b:	eb 23                	jmp    801370 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80134d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801350:	8d 50 01             	lea    0x1(%eax),%edx
  801353:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801356:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801359:	8d 4a 01             	lea    0x1(%edx),%ecx
  80135c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80135f:	8a 12                	mov    (%edx),%dl
  801361:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801363:	8b 45 10             	mov    0x10(%ebp),%eax
  801366:	8d 50 ff             	lea    -0x1(%eax),%edx
  801369:	89 55 10             	mov    %edx,0x10(%ebp)
  80136c:	85 c0                	test   %eax,%eax
  80136e:	75 dd                	jne    80134d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801373:	c9                   	leave  
  801374:	c3                   	ret    

00801375 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801375:	55                   	push   %ebp
  801376:	89 e5                	mov    %esp,%ebp
  801378:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80137b:	8b 45 08             	mov    0x8(%ebp),%eax
  80137e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801381:	8b 45 0c             	mov    0xc(%ebp),%eax
  801384:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801387:	eb 2a                	jmp    8013b3 <memcmp+0x3e>
		if (*s1 != *s2)
  801389:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80138c:	8a 10                	mov    (%eax),%dl
  80138e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801391:	8a 00                	mov    (%eax),%al
  801393:	38 c2                	cmp    %al,%dl
  801395:	74 16                	je     8013ad <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801397:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80139a:	8a 00                	mov    (%eax),%al
  80139c:	0f b6 d0             	movzbl %al,%edx
  80139f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a2:	8a 00                	mov    (%eax),%al
  8013a4:	0f b6 c0             	movzbl %al,%eax
  8013a7:	29 c2                	sub    %eax,%edx
  8013a9:	89 d0                	mov    %edx,%eax
  8013ab:	eb 18                	jmp    8013c5 <memcmp+0x50>
		s1++, s2++;
  8013ad:	ff 45 fc             	incl   -0x4(%ebp)
  8013b0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8013b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013b9:	89 55 10             	mov    %edx,0x10(%ebp)
  8013bc:	85 c0                	test   %eax,%eax
  8013be:	75 c9                	jne    801389 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013c5:	c9                   	leave  
  8013c6:	c3                   	ret    

008013c7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013c7:	55                   	push   %ebp
  8013c8:	89 e5                	mov    %esp,%ebp
  8013ca:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d3:	01 d0                	add    %edx,%eax
  8013d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8013d8:	eb 15                	jmp    8013ef <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013da:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dd:	8a 00                	mov    (%eax),%al
  8013df:	0f b6 d0             	movzbl %al,%edx
  8013e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e5:	0f b6 c0             	movzbl %al,%eax
  8013e8:	39 c2                	cmp    %eax,%edx
  8013ea:	74 0d                	je     8013f9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013ec:	ff 45 08             	incl   0x8(%ebp)
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013f5:	72 e3                	jb     8013da <memfind+0x13>
  8013f7:	eb 01                	jmp    8013fa <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013f9:	90                   	nop
	return (void *) s;
  8013fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013fd:	c9                   	leave  
  8013fe:	c3                   	ret    

008013ff <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
  801402:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801405:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80140c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801413:	eb 03                	jmp    801418 <strtol+0x19>
		s++;
  801415:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	8a 00                	mov    (%eax),%al
  80141d:	3c 20                	cmp    $0x20,%al
  80141f:	74 f4                	je     801415 <strtol+0x16>
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	8a 00                	mov    (%eax),%al
  801426:	3c 09                	cmp    $0x9,%al
  801428:	74 eb                	je     801415 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80142a:	8b 45 08             	mov    0x8(%ebp),%eax
  80142d:	8a 00                	mov    (%eax),%al
  80142f:	3c 2b                	cmp    $0x2b,%al
  801431:	75 05                	jne    801438 <strtol+0x39>
		s++;
  801433:	ff 45 08             	incl   0x8(%ebp)
  801436:	eb 13                	jmp    80144b <strtol+0x4c>
	else if (*s == '-')
  801438:	8b 45 08             	mov    0x8(%ebp),%eax
  80143b:	8a 00                	mov    (%eax),%al
  80143d:	3c 2d                	cmp    $0x2d,%al
  80143f:	75 0a                	jne    80144b <strtol+0x4c>
		s++, neg = 1;
  801441:	ff 45 08             	incl   0x8(%ebp)
  801444:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80144b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80144f:	74 06                	je     801457 <strtol+0x58>
  801451:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801455:	75 20                	jne    801477 <strtol+0x78>
  801457:	8b 45 08             	mov    0x8(%ebp),%eax
  80145a:	8a 00                	mov    (%eax),%al
  80145c:	3c 30                	cmp    $0x30,%al
  80145e:	75 17                	jne    801477 <strtol+0x78>
  801460:	8b 45 08             	mov    0x8(%ebp),%eax
  801463:	40                   	inc    %eax
  801464:	8a 00                	mov    (%eax),%al
  801466:	3c 78                	cmp    $0x78,%al
  801468:	75 0d                	jne    801477 <strtol+0x78>
		s += 2, base = 16;
  80146a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80146e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801475:	eb 28                	jmp    80149f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801477:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80147b:	75 15                	jne    801492 <strtol+0x93>
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8a 00                	mov    (%eax),%al
  801482:	3c 30                	cmp    $0x30,%al
  801484:	75 0c                	jne    801492 <strtol+0x93>
		s++, base = 8;
  801486:	ff 45 08             	incl   0x8(%ebp)
  801489:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801490:	eb 0d                	jmp    80149f <strtol+0xa0>
	else if (base == 0)
  801492:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801496:	75 07                	jne    80149f <strtol+0xa0>
		base = 10;
  801498:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80149f:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a2:	8a 00                	mov    (%eax),%al
  8014a4:	3c 2f                	cmp    $0x2f,%al
  8014a6:	7e 19                	jle    8014c1 <strtol+0xc2>
  8014a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ab:	8a 00                	mov    (%eax),%al
  8014ad:	3c 39                	cmp    $0x39,%al
  8014af:	7f 10                	jg     8014c1 <strtol+0xc2>
			dig = *s - '0';
  8014b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b4:	8a 00                	mov    (%eax),%al
  8014b6:	0f be c0             	movsbl %al,%eax
  8014b9:	83 e8 30             	sub    $0x30,%eax
  8014bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014bf:	eb 42                	jmp    801503 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	8a 00                	mov    (%eax),%al
  8014c6:	3c 60                	cmp    $0x60,%al
  8014c8:	7e 19                	jle    8014e3 <strtol+0xe4>
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	8a 00                	mov    (%eax),%al
  8014cf:	3c 7a                	cmp    $0x7a,%al
  8014d1:	7f 10                	jg     8014e3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	8a 00                	mov    (%eax),%al
  8014d8:	0f be c0             	movsbl %al,%eax
  8014db:	83 e8 57             	sub    $0x57,%eax
  8014de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014e1:	eb 20                	jmp    801503 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8014e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e6:	8a 00                	mov    (%eax),%al
  8014e8:	3c 40                	cmp    $0x40,%al
  8014ea:	7e 39                	jle    801525 <strtol+0x126>
  8014ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ef:	8a 00                	mov    (%eax),%al
  8014f1:	3c 5a                	cmp    $0x5a,%al
  8014f3:	7f 30                	jg     801525 <strtol+0x126>
			dig = *s - 'A' + 10;
  8014f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f8:	8a 00                	mov    (%eax),%al
  8014fa:	0f be c0             	movsbl %al,%eax
  8014fd:	83 e8 37             	sub    $0x37,%eax
  801500:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801503:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801506:	3b 45 10             	cmp    0x10(%ebp),%eax
  801509:	7d 19                	jge    801524 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80150b:	ff 45 08             	incl   0x8(%ebp)
  80150e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801511:	0f af 45 10          	imul   0x10(%ebp),%eax
  801515:	89 c2                	mov    %eax,%edx
  801517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80151a:	01 d0                	add    %edx,%eax
  80151c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80151f:	e9 7b ff ff ff       	jmp    80149f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801524:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801525:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801529:	74 08                	je     801533 <strtol+0x134>
		*endptr = (char *) s;
  80152b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152e:	8b 55 08             	mov    0x8(%ebp),%edx
  801531:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801533:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801537:	74 07                	je     801540 <strtol+0x141>
  801539:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80153c:	f7 d8                	neg    %eax
  80153e:	eb 03                	jmp    801543 <strtol+0x144>
  801540:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801543:	c9                   	leave  
  801544:	c3                   	ret    

00801545 <ltostr>:

void
ltostr(long value, char *str)
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
  801548:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80154b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801552:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801559:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80155d:	79 13                	jns    801572 <ltostr+0x2d>
	{
		neg = 1;
  80155f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801566:	8b 45 0c             	mov    0xc(%ebp),%eax
  801569:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80156c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80156f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801572:	8b 45 08             	mov    0x8(%ebp),%eax
  801575:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80157a:	99                   	cltd   
  80157b:	f7 f9                	idiv   %ecx
  80157d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801580:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801583:	8d 50 01             	lea    0x1(%eax),%edx
  801586:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801589:	89 c2                	mov    %eax,%edx
  80158b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158e:	01 d0                	add    %edx,%eax
  801590:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801593:	83 c2 30             	add    $0x30,%edx
  801596:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801598:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80159b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015a0:	f7 e9                	imul   %ecx
  8015a2:	c1 fa 02             	sar    $0x2,%edx
  8015a5:	89 c8                	mov    %ecx,%eax
  8015a7:	c1 f8 1f             	sar    $0x1f,%eax
  8015aa:	29 c2                	sub    %eax,%edx
  8015ac:	89 d0                	mov    %edx,%eax
  8015ae:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8015b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015b4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015b9:	f7 e9                	imul   %ecx
  8015bb:	c1 fa 02             	sar    $0x2,%edx
  8015be:	89 c8                	mov    %ecx,%eax
  8015c0:	c1 f8 1f             	sar    $0x1f,%eax
  8015c3:	29 c2                	sub    %eax,%edx
  8015c5:	89 d0                	mov    %edx,%eax
  8015c7:	c1 e0 02             	shl    $0x2,%eax
  8015ca:	01 d0                	add    %edx,%eax
  8015cc:	01 c0                	add    %eax,%eax
  8015ce:	29 c1                	sub    %eax,%ecx
  8015d0:	89 ca                	mov    %ecx,%edx
  8015d2:	85 d2                	test   %edx,%edx
  8015d4:	75 9c                	jne    801572 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8015d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8015dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015e0:	48                   	dec    %eax
  8015e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8015e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015e8:	74 3d                	je     801627 <ltostr+0xe2>
		start = 1 ;
  8015ea:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015f1:	eb 34                	jmp    801627 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8015f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f9:	01 d0                	add    %edx,%eax
  8015fb:	8a 00                	mov    (%eax),%al
  8015fd:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801600:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801603:	8b 45 0c             	mov    0xc(%ebp),%eax
  801606:	01 c2                	add    %eax,%edx
  801608:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80160b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160e:	01 c8                	add    %ecx,%eax
  801610:	8a 00                	mov    (%eax),%al
  801612:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801614:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801617:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161a:	01 c2                	add    %eax,%edx
  80161c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80161f:	88 02                	mov    %al,(%edx)
		start++ ;
  801621:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801624:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80162d:	7c c4                	jl     8015f3 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80162f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801632:	8b 45 0c             	mov    0xc(%ebp),%eax
  801635:	01 d0                	add    %edx,%eax
  801637:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80163a:	90                   	nop
  80163b:	c9                   	leave  
  80163c:	c3                   	ret    

0080163d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
  801640:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801643:	ff 75 08             	pushl  0x8(%ebp)
  801646:	e8 54 fa ff ff       	call   80109f <strlen>
  80164b:	83 c4 04             	add    $0x4,%esp
  80164e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801651:	ff 75 0c             	pushl  0xc(%ebp)
  801654:	e8 46 fa ff ff       	call   80109f <strlen>
  801659:	83 c4 04             	add    $0x4,%esp
  80165c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80165f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801666:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80166d:	eb 17                	jmp    801686 <strcconcat+0x49>
		final[s] = str1[s] ;
  80166f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801672:	8b 45 10             	mov    0x10(%ebp),%eax
  801675:	01 c2                	add    %eax,%edx
  801677:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80167a:	8b 45 08             	mov    0x8(%ebp),%eax
  80167d:	01 c8                	add    %ecx,%eax
  80167f:	8a 00                	mov    (%eax),%al
  801681:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801683:	ff 45 fc             	incl   -0x4(%ebp)
  801686:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801689:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80168c:	7c e1                	jl     80166f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80168e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801695:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80169c:	eb 1f                	jmp    8016bd <strcconcat+0x80>
		final[s++] = str2[i] ;
  80169e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016a1:	8d 50 01             	lea    0x1(%eax),%edx
  8016a4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016a7:	89 c2                	mov    %eax,%edx
  8016a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ac:	01 c2                	add    %eax,%edx
  8016ae:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b4:	01 c8                	add    %ecx,%eax
  8016b6:	8a 00                	mov    (%eax),%al
  8016b8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016ba:	ff 45 f8             	incl   -0x8(%ebp)
  8016bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016c3:	7c d9                	jl     80169e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016cb:	01 d0                	add    %edx,%eax
  8016cd:	c6 00 00             	movb   $0x0,(%eax)
}
  8016d0:	90                   	nop
  8016d1:	c9                   	leave  
  8016d2:	c3                   	ret    

008016d3 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8016d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8016df:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e2:	8b 00                	mov    (%eax),%eax
  8016e4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ee:	01 d0                	add    %edx,%eax
  8016f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016f6:	eb 0c                	jmp    801704 <strsplit+0x31>
			*string++ = 0;
  8016f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fb:	8d 50 01             	lea    0x1(%eax),%edx
  8016fe:	89 55 08             	mov    %edx,0x8(%ebp)
  801701:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	8a 00                	mov    (%eax),%al
  801709:	84 c0                	test   %al,%al
  80170b:	74 18                	je     801725 <strsplit+0x52>
  80170d:	8b 45 08             	mov    0x8(%ebp),%eax
  801710:	8a 00                	mov    (%eax),%al
  801712:	0f be c0             	movsbl %al,%eax
  801715:	50                   	push   %eax
  801716:	ff 75 0c             	pushl  0xc(%ebp)
  801719:	e8 13 fb ff ff       	call   801231 <strchr>
  80171e:	83 c4 08             	add    $0x8,%esp
  801721:	85 c0                	test   %eax,%eax
  801723:	75 d3                	jne    8016f8 <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  801725:	8b 45 08             	mov    0x8(%ebp),%eax
  801728:	8a 00                	mov    (%eax),%al
  80172a:	84 c0                	test   %al,%al
  80172c:	74 5a                	je     801788 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  80172e:	8b 45 14             	mov    0x14(%ebp),%eax
  801731:	8b 00                	mov    (%eax),%eax
  801733:	83 f8 0f             	cmp    $0xf,%eax
  801736:	75 07                	jne    80173f <strsplit+0x6c>
		{
			return 0;
  801738:	b8 00 00 00 00       	mov    $0x0,%eax
  80173d:	eb 66                	jmp    8017a5 <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80173f:	8b 45 14             	mov    0x14(%ebp),%eax
  801742:	8b 00                	mov    (%eax),%eax
  801744:	8d 48 01             	lea    0x1(%eax),%ecx
  801747:	8b 55 14             	mov    0x14(%ebp),%edx
  80174a:	89 0a                	mov    %ecx,(%edx)
  80174c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801753:	8b 45 10             	mov    0x10(%ebp),%eax
  801756:	01 c2                	add    %eax,%edx
  801758:	8b 45 08             	mov    0x8(%ebp),%eax
  80175b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80175d:	eb 03                	jmp    801762 <strsplit+0x8f>
			string++;
  80175f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801762:	8b 45 08             	mov    0x8(%ebp),%eax
  801765:	8a 00                	mov    (%eax),%al
  801767:	84 c0                	test   %al,%al
  801769:	74 8b                	je     8016f6 <strsplit+0x23>
  80176b:	8b 45 08             	mov    0x8(%ebp),%eax
  80176e:	8a 00                	mov    (%eax),%al
  801770:	0f be c0             	movsbl %al,%eax
  801773:	50                   	push   %eax
  801774:	ff 75 0c             	pushl  0xc(%ebp)
  801777:	e8 b5 fa ff ff       	call   801231 <strchr>
  80177c:	83 c4 08             	add    $0x8,%esp
  80177f:	85 c0                	test   %eax,%eax
  801781:	74 dc                	je     80175f <strsplit+0x8c>
			string++;
	}
  801783:	e9 6e ff ff ff       	jmp    8016f6 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801788:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801789:	8b 45 14             	mov    0x14(%ebp),%eax
  80178c:	8b 00                	mov    (%eax),%eax
  80178e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801795:	8b 45 10             	mov    0x10(%ebp),%eax
  801798:	01 d0                	add    %edx,%eax
  80179a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017a0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017a5:	c9                   	leave  
  8017a6:	c3                   	ret    

008017a7 <malloc>:
int cnt_mem = 0;
int heap_mem[size_uhmem] = { 0 };
struct hmem heap_size[size_uhmem] = { 0 };
int check = 0;

void* malloc(uint32 size) {
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
  8017aa:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyNEXTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	//NEXT FIT
	if (sys_isUHeapPlacementStrategyNEXTFIT()) {
  8017b0:	e8 7d 0f 00 00       	call   802732 <sys_isUHeapPlacementStrategyNEXTFIT>
  8017b5:	85 c0                	test   %eax,%eax
  8017b7:	0f 84 6f 03 00 00    	je     801b2c <malloc+0x385>
		size = ROUNDUP(size, PAGE_SIZE);
  8017bd:	c7 45 84 00 10 00 00 	movl   $0x1000,-0x7c(%ebp)
  8017c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8017c7:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8017ca:	01 d0                	add    %edx,%eax
  8017cc:	48                   	dec    %eax
  8017cd:	89 45 80             	mov    %eax,-0x80(%ebp)
  8017d0:	8b 45 80             	mov    -0x80(%ebp),%eax
  8017d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d8:	f7 75 84             	divl   -0x7c(%ebp)
  8017db:	8b 45 80             	mov    -0x80(%ebp),%eax
  8017de:	29 d0                	sub    %edx,%eax
  8017e0:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  8017e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017e7:	74 09                	je     8017f2 <malloc+0x4b>
  8017e9:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8017f0:	76 0a                	jbe    8017fc <malloc+0x55>
			return NULL;
  8017f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f7:	e9 4b 09 00 00       	jmp    802147 <malloc+0x9a0>
		}
		// first we can allocate by " Strategy Continues "
		if (ptr_uheap + size <= (uint32) USER_HEAP_MAX && !check) {
  8017fc:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
  801805:	01 d0                	add    %edx,%eax
  801807:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80180c:	0f 87 a2 00 00 00    	ja     8018b4 <malloc+0x10d>
  801812:	a1 60 40 98 00       	mov    0x984060,%eax
  801817:	85 c0                	test   %eax,%eax
  801819:	0f 85 95 00 00 00    	jne    8018b4 <malloc+0x10d>

			void* ret = (void *) ptr_uheap;
  80181f:	a1 04 40 80 00       	mov    0x804004,%eax
  801824:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			sys_allocateMem(ptr_uheap, size);
  80182a:	a1 04 40 80 00       	mov    0x804004,%eax
  80182f:	83 ec 08             	sub    $0x8,%esp
  801832:	ff 75 08             	pushl  0x8(%ebp)
  801835:	50                   	push   %eax
  801836:	e8 a3 0b 00 00       	call   8023de <sys_allocateMem>
  80183b:	83 c4 10             	add    $0x10,%esp

			heap_size[cnt_mem].size = size;
  80183e:	a1 40 40 80 00       	mov    0x804040,%eax
  801843:	8b 55 08             	mov    0x8(%ebp),%edx
  801846:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
  80184d:	a1 40 40 80 00       	mov    0x804040,%eax
  801852:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801858:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
			cnt_mem++;
  80185f:	a1 40 40 80 00       	mov    0x804040,%eax
  801864:	40                   	inc    %eax
  801865:	a3 40 40 80 00       	mov    %eax,0x804040
			int i = 0;
  80186a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  801871:	eb 2e                	jmp    8018a1 <malloc+0xfa>
			{

				heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801873:	a1 04 40 80 00       	mov    0x804004,%eax
  801878:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] = 1;
  80187d:	c1 e8 0c             	shr    $0xc,%eax
  801880:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  801887:	01 00 00 00 

				ptr_uheap += (uint32) PAGE_SIZE;
  80188b:	a1 04 40 80 00       	mov    0x804004,%eax
  801890:	05 00 10 00 00       	add    $0x1000,%eax
  801895:	a3 04 40 80 00       	mov    %eax,0x804004
			heap_size[cnt_mem].size = size;
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
			cnt_mem++;
			int i = 0;
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  80189a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  8018a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8018a7:	72 ca                	jb     801873 <malloc+0xcc>
						/ (uint32) PAGE_SIZE)] = 1;

				ptr_uheap += (uint32) PAGE_SIZE;
			}

			return ret;
  8018a9:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8018af:	e9 93 08 00 00       	jmp    802147 <malloc+0x9a0>

		} else {
			// second we can allocate by " Strategy NEXTFIT "
			void* temp_end = NULL;
  8018b4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

			int check_start = 0;
  8018bb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			// check first that we used " Strategy Continues " before and not do it again and turn to NEXTFIT
			if (!check) {
  8018c2:	a1 60 40 98 00       	mov    0x984060,%eax
  8018c7:	85 c0                	test   %eax,%eax
  8018c9:	75 1d                	jne    8018e8 <malloc+0x141>
				ptr_uheap = (uint32) USER_HEAP_START;
  8018cb:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  8018d2:	00 00 80 
				check = 1;
  8018d5:	c7 05 60 40 98 00 01 	movl   $0x1,0x984060
  8018dc:	00 00 00 
				check_start = 1;// to dont use second loop CZ ptr_uheap start from USER_HEAP_START
  8018df:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  8018e6:	eb 08                	jmp    8018f0 <malloc+0x149>
			} else {
				temp_end = (void*) ptr_uheap;
  8018e8:	a1 04 40 80 00       	mov    0x804004,%eax
  8018ed:	89 45 f0             	mov    %eax,-0x10(%ebp)

			}

			uint32 sz = 0;
  8018f0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
			int f = 0;
  8018f7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			uint32 ptr = ptr_uheap;
  8018fe:	a1 04 40 80 00       	mov    0x804004,%eax
  801903:	89 45 e0             	mov    %eax,-0x20(%ebp)
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  801906:	eb 4d                	jmp    801955 <malloc+0x1ae>
				if (sz == size) {
  801908:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80190b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80190e:	75 09                	jne    801919 <malloc+0x172>
					f = 1;
  801910:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  801917:	eb 45                	jmp    80195e <malloc+0x1b7>
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801919:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80191c:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] == 0) {
  801921:	c1 e8 0c             	shr    $0xc,%eax
			while (ptr < (uint32) USER_HEAP_MAX) {
				if (sz == size) {
					f = 1;
					break;
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801924:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  80192b:	85 c0                	test   %eax,%eax
  80192d:	75 10                	jne    80193f <malloc+0x198>
						/ (uint32) PAGE_SIZE)] == 0) {

					sz += PAGE_SIZE;
  80192f:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
					ptr += PAGE_SIZE;
  801936:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  80193d:	eb 16                	jmp    801955 <malloc+0x1ae>
				} else {
					sz = 0;
  80193f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
					ptr += PAGE_SIZE;
  801946:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
					ptr_uheap = ptr;
  80194d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801950:	a3 04 40 80 00       	mov    %eax,0x804004

			uint32 sz = 0;
			int f = 0;
			uint32 ptr = ptr_uheap;
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  801955:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  80195c:	76 aa                	jbe    801908 <malloc+0x161>
					ptr_uheap = ptr;
				}

			}

			if (f) {
  80195e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801962:	0f 84 95 00 00 00    	je     8019fd <malloc+0x256>

				void* ret = (void *) ptr_uheap;
  801968:	a1 04 40 80 00       	mov    0x804004,%eax
  80196d:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

				sys_allocateMem(ptr_uheap, size);
  801973:	a1 04 40 80 00       	mov    0x804004,%eax
  801978:	83 ec 08             	sub    $0x8,%esp
  80197b:	ff 75 08             	pushl  0x8(%ebp)
  80197e:	50                   	push   %eax
  80197f:	e8 5a 0a 00 00       	call   8023de <sys_allocateMem>
  801984:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  801987:	a1 40 40 80 00       	mov    0x804040,%eax
  80198c:	8b 55 08             	mov    0x8(%ebp),%edx
  80198f:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801996:	a1 40 40 80 00       	mov    0x804040,%eax
  80199b:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8019a1:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
				cnt_mem++;
  8019a8:	a1 40 40 80 00       	mov    0x804040,%eax
  8019ad:	40                   	inc    %eax
  8019ae:	a3 40 40 80 00       	mov    %eax,0x804040
				int i = 0;
  8019b3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  8019ba:	eb 2e                	jmp    8019ea <malloc+0x243>
				{

					heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8019bc:	a1 04 40 80 00       	mov    0x804004,%eax
  8019c1:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  8019c6:	c1 e8 0c             	shr    $0xc,%eax
  8019c9:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  8019d0:	01 00 00 00 

					ptr_uheap += (uint32) PAGE_SIZE;
  8019d4:	a1 04 40 80 00       	mov    0x804004,%eax
  8019d9:	05 00 10 00 00       	add    $0x1000,%eax
  8019de:	a3 04 40 80 00       	mov    %eax,0x804004
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
				cnt_mem++;
				int i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  8019e3:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  8019ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019ed:	3b 45 08             	cmp    0x8(%ebp),%eax
  8019f0:	72 ca                	jb     8019bc <malloc+0x215>
							/ (uint32) PAGE_SIZE)] = 1;

					ptr_uheap += (uint32) PAGE_SIZE;
				}

				return ret;
  8019f2:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8019f8:	e9 4a 07 00 00       	jmp    802147 <malloc+0x9a0>

			} else {

				if (check_start) {
  8019fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a01:	74 0a                	je     801a0d <malloc+0x266>

					return NULL;
  801a03:	b8 00 00 00 00       	mov    $0x0,%eax
  801a08:	e9 3a 07 00 00       	jmp    802147 <malloc+0x9a0>
				}

//////////////back loop////////////////

				uint32 sz = 0;
  801a0d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
				int f = 0;
  801a14:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				uint32 ptr = USER_HEAP_START;
  801a1b:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
				ptr_uheap = USER_HEAP_START;
  801a22:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  801a29:	00 00 80 
				while (ptr < (uint32) temp_end) {
  801a2c:	eb 4d                	jmp    801a7b <malloc+0x2d4>
					if (sz == size) {
  801a2e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a31:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a34:	75 09                	jne    801a3f <malloc+0x298>
						f = 1;
  801a36:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
						break;
  801a3d:	eb 44                	jmp    801a83 <malloc+0x2dc>
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801a3f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801a42:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] == 0) {
  801a47:	c1 e8 0c             	shr    $0xc,%eax
				while (ptr < (uint32) temp_end) {
					if (sz == size) {
						f = 1;
						break;
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801a4a:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  801a51:	85 c0                	test   %eax,%eax
  801a53:	75 10                	jne    801a65 <malloc+0x2be>
							/ (uint32) PAGE_SIZE)] == 0) {

						sz += PAGE_SIZE;
  801a55:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801a5c:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
  801a63:	eb 16                	jmp    801a7b <malloc+0x2d4>
					} else {
						sz = 0;
  801a65:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801a6c:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
						ptr_uheap = ptr;
  801a73:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801a76:	a3 04 40 80 00       	mov    %eax,0x804004

				uint32 sz = 0;
				int f = 0;
				uint32 ptr = USER_HEAP_START;
				ptr_uheap = USER_HEAP_START;
				while (ptr < (uint32) temp_end) {
  801a7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a7e:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801a81:	72 ab                	jb     801a2e <malloc+0x287>
						ptr_uheap = ptr;
					}

				}

				if (f) {
  801a83:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801a87:	0f 84 95 00 00 00    	je     801b22 <malloc+0x37b>

					void* ret = (void *) ptr_uheap;
  801a8d:	a1 04 40 80 00       	mov    0x804004,%eax
  801a92:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

					sys_allocateMem(ptr_uheap, size);
  801a98:	a1 04 40 80 00       	mov    0x804004,%eax
  801a9d:	83 ec 08             	sub    $0x8,%esp
  801aa0:	ff 75 08             	pushl  0x8(%ebp)
  801aa3:	50                   	push   %eax
  801aa4:	e8 35 09 00 00       	call   8023de <sys_allocateMem>
  801aa9:	83 c4 10             	add    $0x10,%esp

					heap_size[cnt_mem].size = size;
  801aac:	a1 40 40 80 00       	mov    0x804040,%eax
  801ab1:	8b 55 08             	mov    0x8(%ebp),%edx
  801ab4:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801abb:	a1 40 40 80 00       	mov    0x804040,%eax
  801ac0:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801ac6:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
					cnt_mem++;
  801acd:	a1 40 40 80 00       	mov    0x804040,%eax
  801ad2:	40                   	inc    %eax
  801ad3:	a3 40 40 80 00       	mov    %eax,0x804040
					int i = 0;
  801ad8:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

					for (; i < size; i += PAGE_SIZE)
  801adf:	eb 2e                	jmp    801b0f <malloc+0x368>
					{

						heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801ae1:	a1 04 40 80 00       	mov    0x804004,%eax
  801ae6:	05 00 00 00 80       	add    $0x80000000,%eax
								/ (uint32) PAGE_SIZE)] = 1;
  801aeb:	c1 e8 0c             	shr    $0xc,%eax
  801aee:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  801af5:	01 00 00 00 

						ptr_uheap += (uint32) PAGE_SIZE;
  801af9:	a1 04 40 80 00       	mov    0x804004,%eax
  801afe:	05 00 10 00 00       	add    $0x1000,%eax
  801b03:	a3 04 40 80 00       	mov    %eax,0x804004
					heap_size[cnt_mem].size = size;
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
					cnt_mem++;
					int i = 0;

					for (; i < size; i += PAGE_SIZE)
  801b08:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  801b0f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801b12:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b15:	72 ca                	jb     801ae1 <malloc+0x33a>
								/ (uint32) PAGE_SIZE)] = 1;

						ptr_uheap += (uint32) PAGE_SIZE;
					}

					return ret;
  801b17:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801b1d:	e9 25 06 00 00       	jmp    802147 <malloc+0x9a0>

				} else {

					return NULL;
  801b22:	b8 00 00 00 00       	mov    $0x0,%eax
  801b27:	e9 1b 06 00 00       	jmp    802147 <malloc+0x9a0>

		}

	}

	else if (sys_isUHeapPlacementStrategyBESTFIT()) {
  801b2c:	e8 d0 0b 00 00       	call   802701 <sys_isUHeapPlacementStrategyBESTFIT>
  801b31:	85 c0                	test   %eax,%eax
  801b33:	0f 84 ba 01 00 00    	je     801cf3 <malloc+0x54c>

		size = ROUNDUP(size, PAGE_SIZE);
  801b39:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  801b40:	10 00 00 
  801b43:	8b 55 08             	mov    0x8(%ebp),%edx
  801b46:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  801b4c:	01 d0                	add    %edx,%eax
  801b4e:	48                   	dec    %eax
  801b4f:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  801b55:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801b5b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b60:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  801b66:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801b6c:	29 d0                	sub    %edx,%eax
  801b6e:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801b71:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b75:	74 09                	je     801b80 <malloc+0x3d9>
  801b77:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801b7e:	76 0a                	jbe    801b8a <malloc+0x3e3>
			return NULL;
  801b80:	b8 00 00 00 00       	mov    $0x0,%eax
  801b85:	e9 bd 05 00 00       	jmp    802147 <malloc+0x9a0>
		}
		uint32 ptr = (uint32) USER_HEAP_START;
  801b8a:	c7 45 c8 00 00 00 80 	movl   $0x80000000,-0x38(%ebp)
		uint32 temp = 0;
  801b91:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		uint32 min_sz = size_uhmem + 1;
  801b98:	c7 45 c0 01 00 02 00 	movl   $0x20001,-0x40(%ebp)
		uint32 count = 0;
  801b9f:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
		int i = 0;
  801ba6:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801bad:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb0:	c1 e8 0c             	shr    $0xc,%eax
  801bb3:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801bb9:	e9 80 00 00 00       	jmp    801c3e <malloc+0x497>

			if (heap_mem[i] == 0) {
  801bbe:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801bc1:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  801bc8:	85 c0                	test   %eax,%eax
  801bca:	75 0c                	jne    801bd8 <malloc+0x431>

				count++;
  801bcc:	ff 45 bc             	incl   -0x44(%ebp)
				ptr += PAGE_SIZE;
  801bcf:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801bd6:	eb 2d                	jmp    801c05 <malloc+0x45e>
			} else {
				if (num_p <= count && min_sz > count) {
  801bd8:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801bde:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801be1:	77 14                	ja     801bf7 <malloc+0x450>
  801be3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801be6:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801be9:	76 0c                	jbe    801bf7 <malloc+0x450>

					min_sz = count;
  801beb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801bee:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801bf1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801bf4:	89 45 c4             	mov    %eax,-0x3c(%ebp)

				}
				count = 0;
  801bf7:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
				ptr += PAGE_SIZE;
  801bfe:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
			}

			if (i == size_uhmem - 1) {
  801c05:	81 7d b8 ff ff 01 00 	cmpl   $0x1ffff,-0x48(%ebp)
  801c0c:	75 2d                	jne    801c3b <malloc+0x494>

				if (num_p <= count && min_sz > count) {
  801c0e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801c14:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801c17:	77 22                	ja     801c3b <malloc+0x494>
  801c19:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c1c:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801c1f:	76 1a                	jbe    801c3b <malloc+0x494>

					min_sz = count;
  801c21:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801c24:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801c27:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c2a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
					count = 0;
  801c2d:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
					ptr += PAGE_SIZE;
  801c34:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801c3b:	ff 45 b8             	incl   -0x48(%ebp)
  801c3e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801c41:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801c46:	0f 86 72 ff ff ff    	jbe    801bbe <malloc+0x417>

			}

		}

		if (num_p > min_sz || temp == 0) {
  801c4c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801c52:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  801c55:	77 06                	ja     801c5d <malloc+0x4b6>
  801c57:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801c5b:	75 0a                	jne    801c67 <malloc+0x4c0>
			return NULL;
  801c5d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c62:	e9 e0 04 00 00       	jmp    802147 <malloc+0x9a0>

		}

		temp = temp - (PAGE_SIZE * min_sz);
  801c67:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c6a:	c1 e0 0c             	shl    $0xc,%eax
  801c6d:	29 45 c4             	sub    %eax,-0x3c(%ebp)
		void* ret = (void*) temp;
  801c70:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801c73:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)

		sys_allocateMem(temp, size);
  801c79:	83 ec 08             	sub    $0x8,%esp
  801c7c:	ff 75 08             	pushl  0x8(%ebp)
  801c7f:	ff 75 c4             	pushl  -0x3c(%ebp)
  801c82:	e8 57 07 00 00       	call   8023de <sys_allocateMem>
  801c87:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801c8a:	a1 40 40 80 00       	mov    0x804040,%eax
  801c8f:	8b 55 08             	mov    0x8(%ebp),%edx
  801c92:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801c99:	a1 40 40 80 00       	mov    0x804040,%eax
  801c9e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801ca1:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
		cnt_mem++;
  801ca8:	a1 40 40 80 00       	mov    0x804040,%eax
  801cad:	40                   	inc    %eax
  801cae:	a3 40 40 80 00       	mov    %eax,0x804040
		i = 0;
  801cb3:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801cba:	eb 24                	jmp    801ce0 <malloc+0x539>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801cbc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801cbf:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801cc4:	c1 e8 0c             	shr    $0xc,%eax
  801cc7:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  801cce:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801cd2:	81 45 c4 00 10 00 00 	addl   $0x1000,-0x3c(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801cd9:	81 45 b8 00 10 00 00 	addl   $0x1000,-0x48(%ebp)
  801ce0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801ce3:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ce6:	72 d4                	jb     801cbc <malloc+0x515>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801ce8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801cee:	e9 54 04 00 00       	jmp    802147 <malloc+0x9a0>

	} else if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801cf3:	e8 d8 09 00 00       	call   8026d0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801cf8:	85 c0                	test   %eax,%eax
  801cfa:	0f 84 88 01 00 00    	je     801e88 <malloc+0x6e1>

		size = ROUNDUP(size, PAGE_SIZE);
  801d00:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  801d07:	10 00 00 
  801d0a:	8b 55 08             	mov    0x8(%ebp),%edx
  801d0d:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  801d13:	01 d0                	add    %edx,%eax
  801d15:	48                   	dec    %eax
  801d16:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  801d1c:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801d22:	ba 00 00 00 00       	mov    $0x0,%edx
  801d27:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  801d2d:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801d33:	29 d0                	sub    %edx,%eax
  801d35:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801d38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d3c:	74 09                	je     801d47 <malloc+0x5a0>
  801d3e:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801d45:	76 0a                	jbe    801d51 <malloc+0x5aa>
			return NULL;
  801d47:	b8 00 00 00 00       	mov    $0x0,%eax
  801d4c:	e9 f6 03 00 00       	jmp    802147 <malloc+0x9a0>
		}

		uint32 ptr = (uint32) USER_HEAP_START;
  801d51:	c7 45 b4 00 00 00 80 	movl   $0x80000000,-0x4c(%ebp)
		uint32 temp = 0;
  801d58:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
		uint32 found = 0;
  801d5f:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		uint32 count = 0;
  801d66:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
		int i = 0;
  801d6d:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	c1 e8 0c             	shr    $0xc,%eax
  801d7a:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

		for (; i < size_uhmem; i++) {
  801d80:	eb 5a                	jmp    801ddc <malloc+0x635>

			if (heap_mem[i] == 0) {
  801d82:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801d85:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  801d8c:	85 c0                	test   %eax,%eax
  801d8e:	75 0c                	jne    801d9c <malloc+0x5f5>

				count++;
  801d90:	ff 45 a8             	incl   -0x58(%ebp)
				ptr += PAGE_SIZE;
  801d93:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
  801d9a:	eb 22                	jmp    801dbe <malloc+0x617>
			} else {
				if (num_p <= count) {
  801d9c:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801da2:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801da5:	77 09                	ja     801db0 <malloc+0x609>

					found = 1;
  801da7:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)

					break;
  801dae:	eb 36                	jmp    801de6 <malloc+0x63f>
				}
				count = 0;
  801db0:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
				ptr += PAGE_SIZE;
  801db7:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
			}

			if (i == size_uhmem - 1) {
  801dbe:	81 7d a4 ff ff 01 00 	cmpl   $0x1ffff,-0x5c(%ebp)
  801dc5:	75 12                	jne    801dd9 <malloc+0x632>

				if (num_p <= count) {
  801dc7:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801dcd:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801dd0:	77 07                	ja     801dd9 <malloc+0x632>

					found = 1;
  801dd2:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
		uint32 found = 0;
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		for (; i < size_uhmem; i++) {
  801dd9:	ff 45 a4             	incl   -0x5c(%ebp)
  801ddc:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801ddf:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801de4:	76 9c                	jbe    801d82 <malloc+0x5db>

			}

		}

		if (!found) {
  801de6:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  801dea:	75 0a                	jne    801df6 <malloc+0x64f>
			return NULL;
  801dec:	b8 00 00 00 00       	mov    $0x0,%eax
  801df1:	e9 51 03 00 00       	jmp    802147 <malloc+0x9a0>

		}

		temp = ptr;
  801df6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801df9:	89 45 b0             	mov    %eax,-0x50(%ebp)
		temp = temp - (PAGE_SIZE * count);
  801dfc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801dff:	c1 e0 0c             	shl    $0xc,%eax
  801e02:	29 45 b0             	sub    %eax,-0x50(%ebp)
		void* ret = (void*) temp;
  801e05:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801e08:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)

		sys_allocateMem(temp, size);
  801e0e:	83 ec 08             	sub    $0x8,%esp
  801e11:	ff 75 08             	pushl  0x8(%ebp)
  801e14:	ff 75 b0             	pushl  -0x50(%ebp)
  801e17:	e8 c2 05 00 00       	call   8023de <sys_allocateMem>
  801e1c:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801e1f:	a1 40 40 80 00       	mov    0x804040,%eax
  801e24:	8b 55 08             	mov    0x8(%ebp),%edx
  801e27:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801e2e:	a1 40 40 80 00       	mov    0x804040,%eax
  801e33:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801e36:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
		cnt_mem++;
  801e3d:	a1 40 40 80 00       	mov    0x804040,%eax
  801e42:	40                   	inc    %eax
  801e43:	a3 40 40 80 00       	mov    %eax,0x804040
		i = 0;
  801e48:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801e4f:	eb 24                	jmp    801e75 <malloc+0x6ce>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801e51:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801e54:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801e59:	c1 e8 0c             	shr    $0xc,%eax
  801e5c:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  801e63:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801e67:	81 45 b0 00 10 00 00 	addl   $0x1000,-0x50(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801e6e:	81 45 a4 00 10 00 00 	addl   $0x1000,-0x5c(%ebp)
  801e75:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801e78:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e7b:	72 d4                	jb     801e51 <malloc+0x6aa>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801e7d:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  801e83:	e9 bf 02 00 00       	jmp    802147 <malloc+0x9a0>

	}
	else if(sys_isUHeapPlacementStrategyWORSTFIT())
  801e88:	e8 d6 08 00 00       	call   802763 <sys_isUHeapPlacementStrategyWORSTFIT>
  801e8d:	85 c0                	test   %eax,%eax
  801e8f:	0f 84 ba 01 00 00    	je     80204f <malloc+0x8a8>
	{
		size = ROUNDUP(size, PAGE_SIZE);
  801e95:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  801e9c:	10 00 00 
  801e9f:	8b 55 08             	mov    0x8(%ebp),%edx
  801ea2:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  801ea8:	01 d0                	add    %edx,%eax
  801eaa:	48                   	dec    %eax
  801eab:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  801eb1:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  801eb7:	ba 00 00 00 00       	mov    $0x0,%edx
  801ebc:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  801ec2:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  801ec8:	29 d0                	sub    %edx,%eax
  801eca:	89 45 08             	mov    %eax,0x8(%ebp)

				if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801ecd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ed1:	74 09                	je     801edc <malloc+0x735>
  801ed3:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801eda:	76 0a                	jbe    801ee6 <malloc+0x73f>
					return NULL;
  801edc:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee1:	e9 61 02 00 00       	jmp    802147 <malloc+0x9a0>
				}
				uint32 ptr = (uint32) USER_HEAP_START;
  801ee6:	c7 45 a0 00 00 00 80 	movl   $0x80000000,-0x60(%ebp)
				uint32 temp = 0;
  801eed:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
				uint32 max_sz = -1;
  801ef4:	c7 45 98 ff ff ff ff 	movl   $0xffffffff,-0x68(%ebp)
				uint32 count = 0;
  801efb:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
				int i = 0;
  801f02:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				uint32 num_p = size / PAGE_SIZE;
  801f09:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0c:	c1 e8 0c             	shr    $0xc,%eax
  801f0f:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  801f15:	e9 80 00 00 00       	jmp    801f9a <malloc+0x7f3>

					if (heap_mem[i] == 0) {
  801f1a:	8b 45 90             	mov    -0x70(%ebp),%eax
  801f1d:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  801f24:	85 c0                	test   %eax,%eax
  801f26:	75 0c                	jne    801f34 <malloc+0x78d>

						count++;
  801f28:	ff 45 94             	incl   -0x6c(%ebp)
						ptr += PAGE_SIZE;
  801f2b:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
  801f32:	eb 2d                	jmp    801f61 <malloc+0x7ba>
					} else {
						if (num_p <= count && max_sz < count) {
  801f34:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801f3a:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801f3d:	77 14                	ja     801f53 <malloc+0x7ac>
  801f3f:	8b 45 98             	mov    -0x68(%ebp),%eax
  801f42:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801f45:	73 0c                	jae    801f53 <malloc+0x7ac>

							max_sz = count;
  801f47:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801f4a:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  801f4d:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801f50:	89 45 9c             	mov    %eax,-0x64(%ebp)

						}
						count = 0;
  801f53:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
						ptr += PAGE_SIZE;
  801f5a:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
					}

					if (i == size_uhmem - 1) {
  801f61:	81 7d 90 ff ff 01 00 	cmpl   $0x1ffff,-0x70(%ebp)
  801f68:	75 2d                	jne    801f97 <malloc+0x7f0>

						if (num_p <= count && max_sz > count) {
  801f6a:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801f70:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801f73:	77 22                	ja     801f97 <malloc+0x7f0>
  801f75:	8b 45 98             	mov    -0x68(%ebp),%eax
  801f78:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801f7b:	76 1a                	jbe    801f97 <malloc+0x7f0>

							max_sz = count;
  801f7d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801f80:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  801f83:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801f86:	89 45 9c             	mov    %eax,-0x64(%ebp)
							count = 0;
  801f89:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
							ptr += PAGE_SIZE;
  801f90:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
				uint32 count = 0;
				int i = 0;
				uint32 num_p = size / PAGE_SIZE;

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  801f97:	ff 45 90             	incl   -0x70(%ebp)
  801f9a:	8b 45 90             	mov    -0x70(%ebp),%eax
  801f9d:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801fa2:	0f 86 72 ff ff ff    	jbe    801f1a <malloc+0x773>

					}

				}

				if (num_p > max_sz || temp == 0) {
  801fa8:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801fae:	3b 45 98             	cmp    -0x68(%ebp),%eax
  801fb1:	77 06                	ja     801fb9 <malloc+0x812>
  801fb3:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  801fb7:	75 0a                	jne    801fc3 <malloc+0x81c>
					return NULL;
  801fb9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbe:	e9 84 01 00 00       	jmp    802147 <malloc+0x9a0>

				}

				temp = temp - (PAGE_SIZE * max_sz);
  801fc3:	8b 45 98             	mov    -0x68(%ebp),%eax
  801fc6:	c1 e0 0c             	shl    $0xc,%eax
  801fc9:	29 45 9c             	sub    %eax,-0x64(%ebp)
				void* ret = (void*) temp;
  801fcc:	8b 45 9c             	mov    -0x64(%ebp),%eax
  801fcf:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

				sys_allocateMem(temp, size);
  801fd5:	83 ec 08             	sub    $0x8,%esp
  801fd8:	ff 75 08             	pushl  0x8(%ebp)
  801fdb:	ff 75 9c             	pushl  -0x64(%ebp)
  801fde:	e8 fb 03 00 00       	call   8023de <sys_allocateMem>
  801fe3:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  801fe6:	a1 40 40 80 00       	mov    0x804040,%eax
  801feb:	8b 55 08             	mov    0x8(%ebp),%edx
  801fee:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
				heap_size[cnt_mem].vir = (void*) temp;
  801ff5:	a1 40 40 80 00       	mov    0x804040,%eax
  801ffa:	8b 55 9c             	mov    -0x64(%ebp),%edx
  801ffd:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
				cnt_mem++;
  802004:	a1 40 40 80 00       	mov    0x804040,%eax
  802009:	40                   	inc    %eax
  80200a:	a3 40 40 80 00       	mov    %eax,0x804040
				i = 0;
  80200f:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  802016:	eb 24                	jmp    80203c <malloc+0x895>
				{

					heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  802018:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80201b:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  802020:	c1 e8 0c             	shr    $0xc,%eax
  802023:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  80202a:	01 00 00 00 

					temp += (uint32) PAGE_SIZE;
  80202e:	81 45 9c 00 10 00 00 	addl   $0x1000,-0x64(%ebp)
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) temp;
				cnt_mem++;
				i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  802035:	81 45 90 00 10 00 00 	addl   $0x1000,-0x70(%ebp)
  80203c:	8b 45 90             	mov    -0x70(%ebp),%eax
  80203f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802042:	72 d4                	jb     802018 <malloc+0x871>

					temp += (uint32) PAGE_SIZE;
				}

				//cprintf("\n size = %d.........vir= %d  \n",num_p,((uint32) ret-USER_HEAP_START)/PAGE_SIZE);
				return ret;
  802044:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  80204a:	e9 f8 00 00 00       	jmp    802147 <malloc+0x9a0>

	}
// this is to make malloc is work
	void* ret = NULL;
  80204f:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
	size = ROUNDUP(size, PAGE_SIZE);
  802056:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  80205d:	10 00 00 
  802060:	8b 55 08             	mov    0x8(%ebp),%edx
  802063:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  802069:	01 d0                	add    %edx,%eax
  80206b:	48                   	dec    %eax
  80206c:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  802072:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  802078:	ba 00 00 00 00       	mov    $0x0,%edx
  80207d:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  802083:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  802089:	29 d0                	sub    %edx,%eax
  80208b:	89 45 08             	mov    %eax,0x8(%ebp)

	if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  80208e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802092:	74 09                	je     80209d <malloc+0x8f6>
  802094:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80209b:	76 0a                	jbe    8020a7 <malloc+0x900>
		return NULL;
  80209d:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a2:	e9 a0 00 00 00       	jmp    802147 <malloc+0x9a0>
	}

	if (ptr_uheap + size <= (uint32) USER_HEAP_MAX) {
  8020a7:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8020ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b0:	01 d0                	add    %edx,%eax
  8020b2:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8020b7:	0f 87 87 00 00 00    	ja     802144 <malloc+0x99d>

		ret = (void *) ptr_uheap;
  8020bd:	a1 04 40 80 00       	mov    0x804004,%eax
  8020c2:	89 45 8c             	mov    %eax,-0x74(%ebp)
		sys_allocateMem(ptr_uheap, size);
  8020c5:	a1 04 40 80 00       	mov    0x804004,%eax
  8020ca:	83 ec 08             	sub    $0x8,%esp
  8020cd:	ff 75 08             	pushl  0x8(%ebp)
  8020d0:	50                   	push   %eax
  8020d1:	e8 08 03 00 00       	call   8023de <sys_allocateMem>
  8020d6:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  8020d9:	a1 40 40 80 00       	mov    0x804040,%eax
  8020de:	8b 55 08             	mov    0x8(%ebp),%edx
  8020e1:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8020e8:	a1 40 40 80 00       	mov    0x804040,%eax
  8020ed:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8020f3:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
		cnt_mem++;
  8020fa:	a1 40 40 80 00       	mov    0x804040,%eax
  8020ff:	40                   	inc    %eax
  802100:	a3 40 40 80 00       	mov    %eax,0x804040
		int i = 0;
  802105:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)

		for (; i < size; i += PAGE_SIZE)
  80210c:	eb 2e                	jmp    80213c <malloc+0x995>
		{

			heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  80210e:	a1 04 40 80 00       	mov    0x804004,%eax
  802113:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  802118:	c1 e8 0c             	shr    $0xc,%eax
  80211b:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  802122:	01 00 00 00 

			ptr_uheap += (uint32) PAGE_SIZE;
  802126:	a1 04 40 80 00       	mov    0x804004,%eax
  80212b:	05 00 10 00 00       	add    $0x1000,%eax
  802130:	a3 04 40 80 00       	mov    %eax,0x804004
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
		cnt_mem++;
		int i = 0;

		for (; i < size; i += PAGE_SIZE)
  802135:	81 45 88 00 10 00 00 	addl   $0x1000,-0x78(%ebp)
  80213c:	8b 45 88             	mov    -0x78(%ebp),%eax
  80213f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802142:	72 ca                	jb     80210e <malloc+0x967>
					/ (uint32) PAGE_SIZE)] = 1;

			ptr_uheap += (uint32) PAGE_SIZE;
		}
	}
	return ret;
  802144:	8b 45 8c             	mov    -0x74(%ebp),%eax

	//TODO: [PROJECT 2016 - BONUS2] Apply FIRST FIT and WORST FIT policies

//return 0;

}
  802147:	c9                   	leave  
  802148:	c3                   	ret    

00802149 <free>:
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address) {
  802149:	55                   	push   %ebp
  80214a:	89 e5                	mov    %esp,%ebp
  80214c:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
  80214f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; inx < cnt_mem; inx++) {
  802156:	e9 c1 00 00 00       	jmp    80221c <free+0xd3>
		if (heap_size[inx].vir == virtual_address) {
  80215b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215e:	8b 04 c5 60 40 88 00 	mov    0x884060(,%eax,8),%eax
  802165:	3b 45 08             	cmp    0x8(%ebp),%eax
  802168:	0f 85 ab 00 00 00    	jne    802219 <free+0xd0>

			if (heap_size[inx].size == 0) {
  80216e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802171:	8b 04 c5 64 40 88 00 	mov    0x884064(,%eax,8),%eax
  802178:	85 c0                	test   %eax,%eax
  80217a:	75 21                	jne    80219d <free+0x54>
				heap_size[inx].size = 0;
  80217c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217f:	c7 04 c5 64 40 88 00 	movl   $0x0,0x884064(,%eax,8)
  802186:	00 00 00 00 
				heap_size[inx].vir = NULL;
  80218a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218d:	c7 04 c5 60 40 88 00 	movl   $0x0,0x884060(,%eax,8)
  802194:	00 00 00 00 
				return;
  802198:	e9 8d 00 00 00       	jmp    80222a <free+0xe1>

			}

			sys_freeMem((uint32) virtual_address, heap_size[inx].size);
  80219d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a0:	8b 14 c5 64 40 88 00 	mov    0x884064(,%eax,8),%edx
  8021a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021aa:	83 ec 08             	sub    $0x8,%esp
  8021ad:	52                   	push   %edx
  8021ae:	50                   	push   %eax
  8021af:	e8 0e 02 00 00       	call   8023c2 <sys_freeMem>
  8021b4:	83 c4 10             	add    $0x10,%esp

			int i = 0;
  8021b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
  8021be:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  8021c4:	eb 24                	jmp    8021ea <free+0xa1>
			{
				heap_mem[(int) (((uint32) va - USER_HEAP_START) / PAGE_SIZE)] =
  8021c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021c9:	05 00 00 00 80       	add    $0x80000000,%eax
  8021ce:	c1 e8 0c             	shr    $0xc,%eax
  8021d1:	c7 04 85 60 40 80 00 	movl   $0x0,0x804060(,%eax,4)
  8021d8:	00 00 00 00 
						0;

				va += PAGE_SIZE;
  8021dc:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
			sys_freeMem((uint32) virtual_address, heap_size[inx].size);

			int i = 0;
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  8021e3:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  8021ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ed:	8b 14 c5 64 40 88 00 	mov    0x884064(,%eax,8),%edx
  8021f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f7:	39 c2                	cmp    %eax,%edx
  8021f9:	77 cb                	ja     8021c6 <free+0x7d>

				va += PAGE_SIZE;

			}

			heap_size[inx].size = 0;
  8021fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fe:	c7 04 c5 64 40 88 00 	movl   $0x0,0x884064(,%eax,8)
  802205:	00 00 00 00 
			heap_size[inx].vir = NULL;
  802209:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220c:	c7 04 c5 60 40 88 00 	movl   $0x0,0x884060(,%eax,8)
  802213:	00 00 00 00 
			break;
  802217:	eb 11                	jmp    80222a <free+0xe1>
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
	for (; inx < cnt_mem; inx++) {
  802219:	ff 45 f4             	incl   -0xc(%ebp)
  80221c:	a1 40 40 80 00       	mov    0x804040,%eax
  802221:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  802224:	0f 8c 31 ff ff ff    	jl     80215b <free+0x12>
	}

	//get the size of the given allocation using its address
	//you need to call sys_freeMem()

}
  80222a:	c9                   	leave  
  80222b:	c3                   	ret    

0080222c <realloc>:
//  Hint: you may need to use the sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size) {
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
  80222f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2016 - BONUS4] realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802232:	83 ec 04             	sub    $0x4,%esp
  802235:	68 24 30 80 00       	push   $0x803024
  80223a:	68 1c 02 00 00       	push   $0x21c
  80223f:	68 4a 30 80 00       	push   $0x80304a
  802244:	e8 aa e4 ff ff       	call   8006f3 <_panic>

00802249 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802249:	55                   	push   %ebp
  80224a:	89 e5                	mov    %esp,%ebp
  80224c:	57                   	push   %edi
  80224d:	56                   	push   %esi
  80224e:	53                   	push   %ebx
  80224f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802252:	8b 45 08             	mov    0x8(%ebp),%eax
  802255:	8b 55 0c             	mov    0xc(%ebp),%edx
  802258:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80225b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80225e:	8b 7d 18             	mov    0x18(%ebp),%edi
  802261:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802264:	cd 30                	int    $0x30
  802266:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802269:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80226c:	83 c4 10             	add    $0x10,%esp
  80226f:	5b                   	pop    %ebx
  802270:	5e                   	pop    %esi
  802271:	5f                   	pop    %edi
  802272:	5d                   	pop    %ebp
  802273:	c3                   	ret    

00802274 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  802277:	8b 45 08             	mov    0x8(%ebp),%eax
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	ff 75 0c             	pushl  0xc(%ebp)
  802283:	50                   	push   %eax
  802284:	6a 00                	push   $0x0
  802286:	e8 be ff ff ff       	call   802249 <syscall>
  80228b:	83 c4 18             	add    $0x18,%esp
}
  80228e:	90                   	nop
  80228f:	c9                   	leave  
  802290:	c3                   	ret    

00802291 <sys_cgetc>:

int
sys_cgetc(void)
{
  802291:	55                   	push   %ebp
  802292:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	6a 01                	push   $0x1
  8022a0:	e8 a4 ff ff ff       	call   802249 <syscall>
  8022a5:	83 c4 18             	add    $0x18,%esp
}
  8022a8:	c9                   	leave  
  8022a9:	c3                   	ret    

008022aa <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8022aa:	55                   	push   %ebp
  8022ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8022ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	50                   	push   %eax
  8022b9:	6a 03                	push   $0x3
  8022bb:	e8 89 ff ff ff       	call   802249 <syscall>
  8022c0:	83 c4 18             	add    $0x18,%esp
}
  8022c3:	c9                   	leave  
  8022c4:	c3                   	ret    

008022c5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8022c5:	55                   	push   %ebp
  8022c6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 02                	push   $0x2
  8022d4:	e8 70 ff ff ff       	call   802249 <syscall>
  8022d9:	83 c4 18             	add    $0x18,%esp
}
  8022dc:	c9                   	leave  
  8022dd:	c3                   	ret    

008022de <sys_env_exit>:

void sys_env_exit(void)
{
  8022de:	55                   	push   %ebp
  8022df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 04                	push   $0x4
  8022ed:	e8 57 ff ff ff       	call   802249 <syscall>
  8022f2:	83 c4 18             	add    $0x18,%esp
}
  8022f5:	90                   	nop
  8022f6:	c9                   	leave  
  8022f7:	c3                   	ret    

008022f8 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8022f8:	55                   	push   %ebp
  8022f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8022fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802301:	6a 00                	push   $0x0
  802303:	6a 00                	push   $0x0
  802305:	6a 00                	push   $0x0
  802307:	52                   	push   %edx
  802308:	50                   	push   %eax
  802309:	6a 05                	push   $0x5
  80230b:	e8 39 ff ff ff       	call   802249 <syscall>
  802310:	83 c4 18             	add    $0x18,%esp
}
  802313:	c9                   	leave  
  802314:	c3                   	ret    

00802315 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802315:	55                   	push   %ebp
  802316:	89 e5                	mov    %esp,%ebp
  802318:	56                   	push   %esi
  802319:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80231a:	8b 75 18             	mov    0x18(%ebp),%esi
  80231d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802320:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802323:	8b 55 0c             	mov    0xc(%ebp),%edx
  802326:	8b 45 08             	mov    0x8(%ebp),%eax
  802329:	56                   	push   %esi
  80232a:	53                   	push   %ebx
  80232b:	51                   	push   %ecx
  80232c:	52                   	push   %edx
  80232d:	50                   	push   %eax
  80232e:	6a 06                	push   $0x6
  802330:	e8 14 ff ff ff       	call   802249 <syscall>
  802335:	83 c4 18             	add    $0x18,%esp
}
  802338:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80233b:	5b                   	pop    %ebx
  80233c:	5e                   	pop    %esi
  80233d:	5d                   	pop    %ebp
  80233e:	c3                   	ret    

0080233f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80233f:	55                   	push   %ebp
  802340:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802342:	8b 55 0c             	mov    0xc(%ebp),%edx
  802345:	8b 45 08             	mov    0x8(%ebp),%eax
  802348:	6a 00                	push   $0x0
  80234a:	6a 00                	push   $0x0
  80234c:	6a 00                	push   $0x0
  80234e:	52                   	push   %edx
  80234f:	50                   	push   %eax
  802350:	6a 07                	push   $0x7
  802352:	e8 f2 fe ff ff       	call   802249 <syscall>
  802357:	83 c4 18             	add    $0x18,%esp
}
  80235a:	c9                   	leave  
  80235b:	c3                   	ret    

0080235c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80235c:	55                   	push   %ebp
  80235d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80235f:	6a 00                	push   $0x0
  802361:	6a 00                	push   $0x0
  802363:	6a 00                	push   $0x0
  802365:	ff 75 0c             	pushl  0xc(%ebp)
  802368:	ff 75 08             	pushl  0x8(%ebp)
  80236b:	6a 08                	push   $0x8
  80236d:	e8 d7 fe ff ff       	call   802249 <syscall>
  802372:	83 c4 18             	add    $0x18,%esp
}
  802375:	c9                   	leave  
  802376:	c3                   	ret    

00802377 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802377:	55                   	push   %ebp
  802378:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80237a:	6a 00                	push   $0x0
  80237c:	6a 00                	push   $0x0
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	6a 09                	push   $0x9
  802386:	e8 be fe ff ff       	call   802249 <syscall>
  80238b:	83 c4 18             	add    $0x18,%esp
}
  80238e:	c9                   	leave  
  80238f:	c3                   	ret    

00802390 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802393:	6a 00                	push   $0x0
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	6a 0a                	push   $0xa
  80239f:	e8 a5 fe ff ff       	call   802249 <syscall>
  8023a4:	83 c4 18             	add    $0x18,%esp
}
  8023a7:	c9                   	leave  
  8023a8:	c3                   	ret    

008023a9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8023a9:	55                   	push   %ebp
  8023aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8023ac:	6a 00                	push   $0x0
  8023ae:	6a 00                	push   $0x0
  8023b0:	6a 00                	push   $0x0
  8023b2:	6a 00                	push   $0x0
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 0b                	push   $0xb
  8023b8:	e8 8c fe ff ff       	call   802249 <syscall>
  8023bd:	83 c4 18             	add    $0x18,%esp
}
  8023c0:	c9                   	leave  
  8023c1:	c3                   	ret    

008023c2 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8023c2:	55                   	push   %ebp
  8023c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8023c5:	6a 00                	push   $0x0
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 00                	push   $0x0
  8023cb:	ff 75 0c             	pushl  0xc(%ebp)
  8023ce:	ff 75 08             	pushl  0x8(%ebp)
  8023d1:	6a 0d                	push   $0xd
  8023d3:	e8 71 fe ff ff       	call   802249 <syscall>
  8023d8:	83 c4 18             	add    $0x18,%esp
	return;
  8023db:	90                   	nop
}
  8023dc:	c9                   	leave  
  8023dd:	c3                   	ret    

008023de <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8023de:	55                   	push   %ebp
  8023df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	ff 75 0c             	pushl  0xc(%ebp)
  8023ea:	ff 75 08             	pushl  0x8(%ebp)
  8023ed:	6a 0e                	push   $0xe
  8023ef:	e8 55 fe ff ff       	call   802249 <syscall>
  8023f4:	83 c4 18             	add    $0x18,%esp
	return ;
  8023f7:	90                   	nop
}
  8023f8:	c9                   	leave  
  8023f9:	c3                   	ret    

008023fa <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8023fa:	55                   	push   %ebp
  8023fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 00                	push   $0x0
  802403:	6a 00                	push   $0x0
  802405:	6a 00                	push   $0x0
  802407:	6a 0c                	push   $0xc
  802409:	e8 3b fe ff ff       	call   802249 <syscall>
  80240e:	83 c4 18             	add    $0x18,%esp
}
  802411:	c9                   	leave  
  802412:	c3                   	ret    

00802413 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802413:	55                   	push   %ebp
  802414:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802416:	6a 00                	push   $0x0
  802418:	6a 00                	push   $0x0
  80241a:	6a 00                	push   $0x0
  80241c:	6a 00                	push   $0x0
  80241e:	6a 00                	push   $0x0
  802420:	6a 10                	push   $0x10
  802422:	e8 22 fe ff ff       	call   802249 <syscall>
  802427:	83 c4 18             	add    $0x18,%esp
}
  80242a:	90                   	nop
  80242b:	c9                   	leave  
  80242c:	c3                   	ret    

0080242d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80242d:	55                   	push   %ebp
  80242e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802430:	6a 00                	push   $0x0
  802432:	6a 00                	push   $0x0
  802434:	6a 00                	push   $0x0
  802436:	6a 00                	push   $0x0
  802438:	6a 00                	push   $0x0
  80243a:	6a 11                	push   $0x11
  80243c:	e8 08 fe ff ff       	call   802249 <syscall>
  802441:	83 c4 18             	add    $0x18,%esp
}
  802444:	90                   	nop
  802445:	c9                   	leave  
  802446:	c3                   	ret    

00802447 <sys_cputc>:


void
sys_cputc(const char c)
{
  802447:	55                   	push   %ebp
  802448:	89 e5                	mov    %esp,%ebp
  80244a:	83 ec 04             	sub    $0x4,%esp
  80244d:	8b 45 08             	mov    0x8(%ebp),%eax
  802450:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802453:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802457:	6a 00                	push   $0x0
  802459:	6a 00                	push   $0x0
  80245b:	6a 00                	push   $0x0
  80245d:	6a 00                	push   $0x0
  80245f:	50                   	push   %eax
  802460:	6a 12                	push   $0x12
  802462:	e8 e2 fd ff ff       	call   802249 <syscall>
  802467:	83 c4 18             	add    $0x18,%esp
}
  80246a:	90                   	nop
  80246b:	c9                   	leave  
  80246c:	c3                   	ret    

0080246d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80246d:	55                   	push   %ebp
  80246e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802470:	6a 00                	push   $0x0
  802472:	6a 00                	push   $0x0
  802474:	6a 00                	push   $0x0
  802476:	6a 00                	push   $0x0
  802478:	6a 00                	push   $0x0
  80247a:	6a 13                	push   $0x13
  80247c:	e8 c8 fd ff ff       	call   802249 <syscall>
  802481:	83 c4 18             	add    $0x18,%esp
}
  802484:	90                   	nop
  802485:	c9                   	leave  
  802486:	c3                   	ret    

00802487 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802487:	55                   	push   %ebp
  802488:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80248a:	8b 45 08             	mov    0x8(%ebp),%eax
  80248d:	6a 00                	push   $0x0
  80248f:	6a 00                	push   $0x0
  802491:	6a 00                	push   $0x0
  802493:	ff 75 0c             	pushl  0xc(%ebp)
  802496:	50                   	push   %eax
  802497:	6a 14                	push   $0x14
  802499:	e8 ab fd ff ff       	call   802249 <syscall>
  80249e:	83 c4 18             	add    $0x18,%esp
}
  8024a1:	c9                   	leave  
  8024a2:	c3                   	ret    

008024a3 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  8024a3:	55                   	push   %ebp
  8024a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  8024a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a9:	6a 00                	push   $0x0
  8024ab:	6a 00                	push   $0x0
  8024ad:	6a 00                	push   $0x0
  8024af:	6a 00                	push   $0x0
  8024b1:	50                   	push   %eax
  8024b2:	6a 17                	push   $0x17
  8024b4:	e8 90 fd ff ff       	call   802249 <syscall>
  8024b9:	83 c4 18             	add    $0x18,%esp
}
  8024bc:	c9                   	leave  
  8024bd:	c3                   	ret    

008024be <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  8024be:	55                   	push   %ebp
  8024bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  8024c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c4:	6a 00                	push   $0x0
  8024c6:	6a 00                	push   $0x0
  8024c8:	6a 00                	push   $0x0
  8024ca:	6a 00                	push   $0x0
  8024cc:	50                   	push   %eax
  8024cd:	6a 15                	push   $0x15
  8024cf:	e8 75 fd ff ff       	call   802249 <syscall>
  8024d4:	83 c4 18             	add    $0x18,%esp
}
  8024d7:	90                   	nop
  8024d8:	c9                   	leave  
  8024d9:	c3                   	ret    

008024da <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  8024da:	55                   	push   %ebp
  8024db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  8024dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 00                	push   $0x0
  8024e6:	6a 00                	push   $0x0
  8024e8:	50                   	push   %eax
  8024e9:	6a 16                	push   $0x16
  8024eb:	e8 59 fd ff ff       	call   802249 <syscall>
  8024f0:	83 c4 18             	add    $0x18,%esp
}
  8024f3:	90                   	nop
  8024f4:	c9                   	leave  
  8024f5:	c3                   	ret    

008024f6 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  8024f6:	55                   	push   %ebp
  8024f7:	89 e5                	mov    %esp,%ebp
  8024f9:	83 ec 04             	sub    $0x4,%esp
  8024fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8024ff:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  802502:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802505:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802509:	8b 45 08             	mov    0x8(%ebp),%eax
  80250c:	6a 00                	push   $0x0
  80250e:	51                   	push   %ecx
  80250f:	52                   	push   %edx
  802510:	ff 75 0c             	pushl  0xc(%ebp)
  802513:	50                   	push   %eax
  802514:	6a 18                	push   $0x18
  802516:	e8 2e fd ff ff       	call   802249 <syscall>
  80251b:	83 c4 18             	add    $0x18,%esp
}
  80251e:	c9                   	leave  
  80251f:	c3                   	ret    

00802520 <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  802520:	55                   	push   %ebp
  802521:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  802523:	8b 55 0c             	mov    0xc(%ebp),%edx
  802526:	8b 45 08             	mov    0x8(%ebp),%eax
  802529:	6a 00                	push   $0x0
  80252b:	6a 00                	push   $0x0
  80252d:	6a 00                	push   $0x0
  80252f:	52                   	push   %edx
  802530:	50                   	push   %eax
  802531:	6a 19                	push   $0x19
  802533:	e8 11 fd ff ff       	call   802249 <syscall>
  802538:	83 c4 18             	add    $0x18,%esp
}
  80253b:	c9                   	leave  
  80253c:	c3                   	ret    

0080253d <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  80253d:	55                   	push   %ebp
  80253e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  802540:	8b 45 08             	mov    0x8(%ebp),%eax
  802543:	6a 00                	push   $0x0
  802545:	6a 00                	push   $0x0
  802547:	6a 00                	push   $0x0
  802549:	6a 00                	push   $0x0
  80254b:	50                   	push   %eax
  80254c:	6a 1a                	push   $0x1a
  80254e:	e8 f6 fc ff ff       	call   802249 <syscall>
  802553:	83 c4 18             	add    $0x18,%esp
}
  802556:	c9                   	leave  
  802557:	c3                   	ret    

00802558 <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  802558:	55                   	push   %ebp
  802559:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  80255b:	6a 00                	push   $0x0
  80255d:	6a 00                	push   $0x0
  80255f:	6a 00                	push   $0x0
  802561:	6a 00                	push   $0x0
  802563:	6a 00                	push   $0x0
  802565:	6a 1b                	push   $0x1b
  802567:	e8 dd fc ff ff       	call   802249 <syscall>
  80256c:	83 c4 18             	add    $0x18,%esp
}
  80256f:	c9                   	leave  
  802570:	c3                   	ret    

00802571 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802571:	55                   	push   %ebp
  802572:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802574:	6a 00                	push   $0x0
  802576:	6a 00                	push   $0x0
  802578:	6a 00                	push   $0x0
  80257a:	6a 00                	push   $0x0
  80257c:	6a 00                	push   $0x0
  80257e:	6a 1c                	push   $0x1c
  802580:	e8 c4 fc ff ff       	call   802249 <syscall>
  802585:	83 c4 18             	add    $0x18,%esp
}
  802588:	c9                   	leave  
  802589:	c3                   	ret    

0080258a <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  80258a:	55                   	push   %ebp
  80258b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  80258d:	8b 45 08             	mov    0x8(%ebp),%eax
  802590:	6a 00                	push   $0x0
  802592:	6a 00                	push   $0x0
  802594:	6a 00                	push   $0x0
  802596:	ff 75 0c             	pushl  0xc(%ebp)
  802599:	50                   	push   %eax
  80259a:	6a 1d                	push   $0x1d
  80259c:	e8 a8 fc ff ff       	call   802249 <syscall>
  8025a1:	83 c4 18             	add    $0x18,%esp
}
  8025a4:	c9                   	leave  
  8025a5:	c3                   	ret    

008025a6 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8025a6:	55                   	push   %ebp
  8025a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8025a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ac:	6a 00                	push   $0x0
  8025ae:	6a 00                	push   $0x0
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 00                	push   $0x0
  8025b4:	50                   	push   %eax
  8025b5:	6a 1e                	push   $0x1e
  8025b7:	e8 8d fc ff ff       	call   802249 <syscall>
  8025bc:	83 c4 18             	add    $0x18,%esp
}
  8025bf:	90                   	nop
  8025c0:	c9                   	leave  
  8025c1:	c3                   	ret    

008025c2 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8025c2:	55                   	push   %ebp
  8025c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8025c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c8:	6a 00                	push   $0x0
  8025ca:	6a 00                	push   $0x0
  8025cc:	6a 00                	push   $0x0
  8025ce:	6a 00                	push   $0x0
  8025d0:	50                   	push   %eax
  8025d1:	6a 1f                	push   $0x1f
  8025d3:	e8 71 fc ff ff       	call   802249 <syscall>
  8025d8:	83 c4 18             	add    $0x18,%esp
}
  8025db:	90                   	nop
  8025dc:	c9                   	leave  
  8025dd:	c3                   	ret    

008025de <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8025de:	55                   	push   %ebp
  8025df:	89 e5                	mov    %esp,%ebp
  8025e1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8025e4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8025e7:	8d 50 04             	lea    0x4(%eax),%edx
  8025ea:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8025ed:	6a 00                	push   $0x0
  8025ef:	6a 00                	push   $0x0
  8025f1:	6a 00                	push   $0x0
  8025f3:	52                   	push   %edx
  8025f4:	50                   	push   %eax
  8025f5:	6a 20                	push   $0x20
  8025f7:	e8 4d fc ff ff       	call   802249 <syscall>
  8025fc:	83 c4 18             	add    $0x18,%esp
	return result;
  8025ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802602:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802605:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802608:	89 01                	mov    %eax,(%ecx)
  80260a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80260d:	8b 45 08             	mov    0x8(%ebp),%eax
  802610:	c9                   	leave  
  802611:	c2 04 00             	ret    $0x4

00802614 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802614:	55                   	push   %ebp
  802615:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802617:	6a 00                	push   $0x0
  802619:	6a 00                	push   $0x0
  80261b:	ff 75 10             	pushl  0x10(%ebp)
  80261e:	ff 75 0c             	pushl  0xc(%ebp)
  802621:	ff 75 08             	pushl  0x8(%ebp)
  802624:	6a 0f                	push   $0xf
  802626:	e8 1e fc ff ff       	call   802249 <syscall>
  80262b:	83 c4 18             	add    $0x18,%esp
	return ;
  80262e:	90                   	nop
}
  80262f:	c9                   	leave  
  802630:	c3                   	ret    

00802631 <sys_rcr2>:
uint32 sys_rcr2()
{
  802631:	55                   	push   %ebp
  802632:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802634:	6a 00                	push   $0x0
  802636:	6a 00                	push   $0x0
  802638:	6a 00                	push   $0x0
  80263a:	6a 00                	push   $0x0
  80263c:	6a 00                	push   $0x0
  80263e:	6a 21                	push   $0x21
  802640:	e8 04 fc ff ff       	call   802249 <syscall>
  802645:	83 c4 18             	add    $0x18,%esp
}
  802648:	c9                   	leave  
  802649:	c3                   	ret    

0080264a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80264a:	55                   	push   %ebp
  80264b:	89 e5                	mov    %esp,%ebp
  80264d:	83 ec 04             	sub    $0x4,%esp
  802650:	8b 45 08             	mov    0x8(%ebp),%eax
  802653:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802656:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80265a:	6a 00                	push   $0x0
  80265c:	6a 00                	push   $0x0
  80265e:	6a 00                	push   $0x0
  802660:	6a 00                	push   $0x0
  802662:	50                   	push   %eax
  802663:	6a 22                	push   $0x22
  802665:	e8 df fb ff ff       	call   802249 <syscall>
  80266a:	83 c4 18             	add    $0x18,%esp
	return ;
  80266d:	90                   	nop
}
  80266e:	c9                   	leave  
  80266f:	c3                   	ret    

00802670 <rsttst>:
void rsttst()
{
  802670:	55                   	push   %ebp
  802671:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802673:	6a 00                	push   $0x0
  802675:	6a 00                	push   $0x0
  802677:	6a 00                	push   $0x0
  802679:	6a 00                	push   $0x0
  80267b:	6a 00                	push   $0x0
  80267d:	6a 24                	push   $0x24
  80267f:	e8 c5 fb ff ff       	call   802249 <syscall>
  802684:	83 c4 18             	add    $0x18,%esp
	return ;
  802687:	90                   	nop
}
  802688:	c9                   	leave  
  802689:	c3                   	ret    

0080268a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80268a:	55                   	push   %ebp
  80268b:	89 e5                	mov    %esp,%ebp
  80268d:	83 ec 04             	sub    $0x4,%esp
  802690:	8b 45 14             	mov    0x14(%ebp),%eax
  802693:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802696:	8b 55 18             	mov    0x18(%ebp),%edx
  802699:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80269d:	52                   	push   %edx
  80269e:	50                   	push   %eax
  80269f:	ff 75 10             	pushl  0x10(%ebp)
  8026a2:	ff 75 0c             	pushl  0xc(%ebp)
  8026a5:	ff 75 08             	pushl  0x8(%ebp)
  8026a8:	6a 23                	push   $0x23
  8026aa:	e8 9a fb ff ff       	call   802249 <syscall>
  8026af:	83 c4 18             	add    $0x18,%esp
	return ;
  8026b2:	90                   	nop
}
  8026b3:	c9                   	leave  
  8026b4:	c3                   	ret    

008026b5 <chktst>:
void chktst(uint32 n)
{
  8026b5:	55                   	push   %ebp
  8026b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8026b8:	6a 00                	push   $0x0
  8026ba:	6a 00                	push   $0x0
  8026bc:	6a 00                	push   $0x0
  8026be:	6a 00                	push   $0x0
  8026c0:	ff 75 08             	pushl  0x8(%ebp)
  8026c3:	6a 25                	push   $0x25
  8026c5:	e8 7f fb ff ff       	call   802249 <syscall>
  8026ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8026cd:	90                   	nop
}
  8026ce:	c9                   	leave  
  8026cf:	c3                   	ret    

008026d0 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8026d0:	55                   	push   %ebp
  8026d1:	89 e5                	mov    %esp,%ebp
  8026d3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026d6:	6a 00                	push   $0x0
  8026d8:	6a 00                	push   $0x0
  8026da:	6a 00                	push   $0x0
  8026dc:	6a 00                	push   $0x0
  8026de:	6a 00                	push   $0x0
  8026e0:	6a 26                	push   $0x26
  8026e2:	e8 62 fb ff ff       	call   802249 <syscall>
  8026e7:	83 c4 18             	add    $0x18,%esp
  8026ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8026ed:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8026f1:	75 07                	jne    8026fa <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8026f3:	b8 01 00 00 00       	mov    $0x1,%eax
  8026f8:	eb 05                	jmp    8026ff <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8026fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026ff:	c9                   	leave  
  802700:	c3                   	ret    

00802701 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802701:	55                   	push   %ebp
  802702:	89 e5                	mov    %esp,%ebp
  802704:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802707:	6a 00                	push   $0x0
  802709:	6a 00                	push   $0x0
  80270b:	6a 00                	push   $0x0
  80270d:	6a 00                	push   $0x0
  80270f:	6a 00                	push   $0x0
  802711:	6a 26                	push   $0x26
  802713:	e8 31 fb ff ff       	call   802249 <syscall>
  802718:	83 c4 18             	add    $0x18,%esp
  80271b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80271e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802722:	75 07                	jne    80272b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802724:	b8 01 00 00 00       	mov    $0x1,%eax
  802729:	eb 05                	jmp    802730 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80272b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802730:	c9                   	leave  
  802731:	c3                   	ret    

00802732 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802732:	55                   	push   %ebp
  802733:	89 e5                	mov    %esp,%ebp
  802735:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802738:	6a 00                	push   $0x0
  80273a:	6a 00                	push   $0x0
  80273c:	6a 00                	push   $0x0
  80273e:	6a 00                	push   $0x0
  802740:	6a 00                	push   $0x0
  802742:	6a 26                	push   $0x26
  802744:	e8 00 fb ff ff       	call   802249 <syscall>
  802749:	83 c4 18             	add    $0x18,%esp
  80274c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80274f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802753:	75 07                	jne    80275c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802755:	b8 01 00 00 00       	mov    $0x1,%eax
  80275a:	eb 05                	jmp    802761 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80275c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802761:	c9                   	leave  
  802762:	c3                   	ret    

00802763 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802763:	55                   	push   %ebp
  802764:	89 e5                	mov    %esp,%ebp
  802766:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802769:	6a 00                	push   $0x0
  80276b:	6a 00                	push   $0x0
  80276d:	6a 00                	push   $0x0
  80276f:	6a 00                	push   $0x0
  802771:	6a 00                	push   $0x0
  802773:	6a 26                	push   $0x26
  802775:	e8 cf fa ff ff       	call   802249 <syscall>
  80277a:	83 c4 18             	add    $0x18,%esp
  80277d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802780:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802784:	75 07                	jne    80278d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802786:	b8 01 00 00 00       	mov    $0x1,%eax
  80278b:	eb 05                	jmp    802792 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80278d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802792:	c9                   	leave  
  802793:	c3                   	ret    

00802794 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802794:	55                   	push   %ebp
  802795:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802797:	6a 00                	push   $0x0
  802799:	6a 00                	push   $0x0
  80279b:	6a 00                	push   $0x0
  80279d:	6a 00                	push   $0x0
  80279f:	ff 75 08             	pushl  0x8(%ebp)
  8027a2:	6a 27                	push   $0x27
  8027a4:	e8 a0 fa ff ff       	call   802249 <syscall>
  8027a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8027ac:	90                   	nop
}
  8027ad:	c9                   	leave  
  8027ae:	c3                   	ret    
  8027af:	90                   	nop

008027b0 <__udivdi3>:
  8027b0:	55                   	push   %ebp
  8027b1:	57                   	push   %edi
  8027b2:	56                   	push   %esi
  8027b3:	53                   	push   %ebx
  8027b4:	83 ec 1c             	sub    $0x1c,%esp
  8027b7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8027bb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8027bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8027c3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8027c7:	89 ca                	mov    %ecx,%edx
  8027c9:	89 f8                	mov    %edi,%eax
  8027cb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8027cf:	85 f6                	test   %esi,%esi
  8027d1:	75 2d                	jne    802800 <__udivdi3+0x50>
  8027d3:	39 cf                	cmp    %ecx,%edi
  8027d5:	77 65                	ja     80283c <__udivdi3+0x8c>
  8027d7:	89 fd                	mov    %edi,%ebp
  8027d9:	85 ff                	test   %edi,%edi
  8027db:	75 0b                	jne    8027e8 <__udivdi3+0x38>
  8027dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8027e2:	31 d2                	xor    %edx,%edx
  8027e4:	f7 f7                	div    %edi
  8027e6:	89 c5                	mov    %eax,%ebp
  8027e8:	31 d2                	xor    %edx,%edx
  8027ea:	89 c8                	mov    %ecx,%eax
  8027ec:	f7 f5                	div    %ebp
  8027ee:	89 c1                	mov    %eax,%ecx
  8027f0:	89 d8                	mov    %ebx,%eax
  8027f2:	f7 f5                	div    %ebp
  8027f4:	89 cf                	mov    %ecx,%edi
  8027f6:	89 fa                	mov    %edi,%edx
  8027f8:	83 c4 1c             	add    $0x1c,%esp
  8027fb:	5b                   	pop    %ebx
  8027fc:	5e                   	pop    %esi
  8027fd:	5f                   	pop    %edi
  8027fe:	5d                   	pop    %ebp
  8027ff:	c3                   	ret    
  802800:	39 ce                	cmp    %ecx,%esi
  802802:	77 28                	ja     80282c <__udivdi3+0x7c>
  802804:	0f bd fe             	bsr    %esi,%edi
  802807:	83 f7 1f             	xor    $0x1f,%edi
  80280a:	75 40                	jne    80284c <__udivdi3+0x9c>
  80280c:	39 ce                	cmp    %ecx,%esi
  80280e:	72 0a                	jb     80281a <__udivdi3+0x6a>
  802810:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802814:	0f 87 9e 00 00 00    	ja     8028b8 <__udivdi3+0x108>
  80281a:	b8 01 00 00 00       	mov    $0x1,%eax
  80281f:	89 fa                	mov    %edi,%edx
  802821:	83 c4 1c             	add    $0x1c,%esp
  802824:	5b                   	pop    %ebx
  802825:	5e                   	pop    %esi
  802826:	5f                   	pop    %edi
  802827:	5d                   	pop    %ebp
  802828:	c3                   	ret    
  802829:	8d 76 00             	lea    0x0(%esi),%esi
  80282c:	31 ff                	xor    %edi,%edi
  80282e:	31 c0                	xor    %eax,%eax
  802830:	89 fa                	mov    %edi,%edx
  802832:	83 c4 1c             	add    $0x1c,%esp
  802835:	5b                   	pop    %ebx
  802836:	5e                   	pop    %esi
  802837:	5f                   	pop    %edi
  802838:	5d                   	pop    %ebp
  802839:	c3                   	ret    
  80283a:	66 90                	xchg   %ax,%ax
  80283c:	89 d8                	mov    %ebx,%eax
  80283e:	f7 f7                	div    %edi
  802840:	31 ff                	xor    %edi,%edi
  802842:	89 fa                	mov    %edi,%edx
  802844:	83 c4 1c             	add    $0x1c,%esp
  802847:	5b                   	pop    %ebx
  802848:	5e                   	pop    %esi
  802849:	5f                   	pop    %edi
  80284a:	5d                   	pop    %ebp
  80284b:	c3                   	ret    
  80284c:	bd 20 00 00 00       	mov    $0x20,%ebp
  802851:	89 eb                	mov    %ebp,%ebx
  802853:	29 fb                	sub    %edi,%ebx
  802855:	89 f9                	mov    %edi,%ecx
  802857:	d3 e6                	shl    %cl,%esi
  802859:	89 c5                	mov    %eax,%ebp
  80285b:	88 d9                	mov    %bl,%cl
  80285d:	d3 ed                	shr    %cl,%ebp
  80285f:	89 e9                	mov    %ebp,%ecx
  802861:	09 f1                	or     %esi,%ecx
  802863:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802867:	89 f9                	mov    %edi,%ecx
  802869:	d3 e0                	shl    %cl,%eax
  80286b:	89 c5                	mov    %eax,%ebp
  80286d:	89 d6                	mov    %edx,%esi
  80286f:	88 d9                	mov    %bl,%cl
  802871:	d3 ee                	shr    %cl,%esi
  802873:	89 f9                	mov    %edi,%ecx
  802875:	d3 e2                	shl    %cl,%edx
  802877:	8b 44 24 08          	mov    0x8(%esp),%eax
  80287b:	88 d9                	mov    %bl,%cl
  80287d:	d3 e8                	shr    %cl,%eax
  80287f:	09 c2                	or     %eax,%edx
  802881:	89 d0                	mov    %edx,%eax
  802883:	89 f2                	mov    %esi,%edx
  802885:	f7 74 24 0c          	divl   0xc(%esp)
  802889:	89 d6                	mov    %edx,%esi
  80288b:	89 c3                	mov    %eax,%ebx
  80288d:	f7 e5                	mul    %ebp
  80288f:	39 d6                	cmp    %edx,%esi
  802891:	72 19                	jb     8028ac <__udivdi3+0xfc>
  802893:	74 0b                	je     8028a0 <__udivdi3+0xf0>
  802895:	89 d8                	mov    %ebx,%eax
  802897:	31 ff                	xor    %edi,%edi
  802899:	e9 58 ff ff ff       	jmp    8027f6 <__udivdi3+0x46>
  80289e:	66 90                	xchg   %ax,%ax
  8028a0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8028a4:	89 f9                	mov    %edi,%ecx
  8028a6:	d3 e2                	shl    %cl,%edx
  8028a8:	39 c2                	cmp    %eax,%edx
  8028aa:	73 e9                	jae    802895 <__udivdi3+0xe5>
  8028ac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8028af:	31 ff                	xor    %edi,%edi
  8028b1:	e9 40 ff ff ff       	jmp    8027f6 <__udivdi3+0x46>
  8028b6:	66 90                	xchg   %ax,%ax
  8028b8:	31 c0                	xor    %eax,%eax
  8028ba:	e9 37 ff ff ff       	jmp    8027f6 <__udivdi3+0x46>
  8028bf:	90                   	nop

008028c0 <__umoddi3>:
  8028c0:	55                   	push   %ebp
  8028c1:	57                   	push   %edi
  8028c2:	56                   	push   %esi
  8028c3:	53                   	push   %ebx
  8028c4:	83 ec 1c             	sub    $0x1c,%esp
  8028c7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8028cb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8028cf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8028d3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8028d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8028db:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8028df:	89 f3                	mov    %esi,%ebx
  8028e1:	89 fa                	mov    %edi,%edx
  8028e3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8028e7:	89 34 24             	mov    %esi,(%esp)
  8028ea:	85 c0                	test   %eax,%eax
  8028ec:	75 1a                	jne    802908 <__umoddi3+0x48>
  8028ee:	39 f7                	cmp    %esi,%edi
  8028f0:	0f 86 a2 00 00 00    	jbe    802998 <__umoddi3+0xd8>
  8028f6:	89 c8                	mov    %ecx,%eax
  8028f8:	89 f2                	mov    %esi,%edx
  8028fa:	f7 f7                	div    %edi
  8028fc:	89 d0                	mov    %edx,%eax
  8028fe:	31 d2                	xor    %edx,%edx
  802900:	83 c4 1c             	add    $0x1c,%esp
  802903:	5b                   	pop    %ebx
  802904:	5e                   	pop    %esi
  802905:	5f                   	pop    %edi
  802906:	5d                   	pop    %ebp
  802907:	c3                   	ret    
  802908:	39 f0                	cmp    %esi,%eax
  80290a:	0f 87 ac 00 00 00    	ja     8029bc <__umoddi3+0xfc>
  802910:	0f bd e8             	bsr    %eax,%ebp
  802913:	83 f5 1f             	xor    $0x1f,%ebp
  802916:	0f 84 ac 00 00 00    	je     8029c8 <__umoddi3+0x108>
  80291c:	bf 20 00 00 00       	mov    $0x20,%edi
  802921:	29 ef                	sub    %ebp,%edi
  802923:	89 fe                	mov    %edi,%esi
  802925:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802929:	89 e9                	mov    %ebp,%ecx
  80292b:	d3 e0                	shl    %cl,%eax
  80292d:	89 d7                	mov    %edx,%edi
  80292f:	89 f1                	mov    %esi,%ecx
  802931:	d3 ef                	shr    %cl,%edi
  802933:	09 c7                	or     %eax,%edi
  802935:	89 e9                	mov    %ebp,%ecx
  802937:	d3 e2                	shl    %cl,%edx
  802939:	89 14 24             	mov    %edx,(%esp)
  80293c:	89 d8                	mov    %ebx,%eax
  80293e:	d3 e0                	shl    %cl,%eax
  802940:	89 c2                	mov    %eax,%edx
  802942:	8b 44 24 08          	mov    0x8(%esp),%eax
  802946:	d3 e0                	shl    %cl,%eax
  802948:	89 44 24 04          	mov    %eax,0x4(%esp)
  80294c:	8b 44 24 08          	mov    0x8(%esp),%eax
  802950:	89 f1                	mov    %esi,%ecx
  802952:	d3 e8                	shr    %cl,%eax
  802954:	09 d0                	or     %edx,%eax
  802956:	d3 eb                	shr    %cl,%ebx
  802958:	89 da                	mov    %ebx,%edx
  80295a:	f7 f7                	div    %edi
  80295c:	89 d3                	mov    %edx,%ebx
  80295e:	f7 24 24             	mull   (%esp)
  802961:	89 c6                	mov    %eax,%esi
  802963:	89 d1                	mov    %edx,%ecx
  802965:	39 d3                	cmp    %edx,%ebx
  802967:	0f 82 87 00 00 00    	jb     8029f4 <__umoddi3+0x134>
  80296d:	0f 84 91 00 00 00    	je     802a04 <__umoddi3+0x144>
  802973:	8b 54 24 04          	mov    0x4(%esp),%edx
  802977:	29 f2                	sub    %esi,%edx
  802979:	19 cb                	sbb    %ecx,%ebx
  80297b:	89 d8                	mov    %ebx,%eax
  80297d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802981:	d3 e0                	shl    %cl,%eax
  802983:	89 e9                	mov    %ebp,%ecx
  802985:	d3 ea                	shr    %cl,%edx
  802987:	09 d0                	or     %edx,%eax
  802989:	89 e9                	mov    %ebp,%ecx
  80298b:	d3 eb                	shr    %cl,%ebx
  80298d:	89 da                	mov    %ebx,%edx
  80298f:	83 c4 1c             	add    $0x1c,%esp
  802992:	5b                   	pop    %ebx
  802993:	5e                   	pop    %esi
  802994:	5f                   	pop    %edi
  802995:	5d                   	pop    %ebp
  802996:	c3                   	ret    
  802997:	90                   	nop
  802998:	89 fd                	mov    %edi,%ebp
  80299a:	85 ff                	test   %edi,%edi
  80299c:	75 0b                	jne    8029a9 <__umoddi3+0xe9>
  80299e:	b8 01 00 00 00       	mov    $0x1,%eax
  8029a3:	31 d2                	xor    %edx,%edx
  8029a5:	f7 f7                	div    %edi
  8029a7:	89 c5                	mov    %eax,%ebp
  8029a9:	89 f0                	mov    %esi,%eax
  8029ab:	31 d2                	xor    %edx,%edx
  8029ad:	f7 f5                	div    %ebp
  8029af:	89 c8                	mov    %ecx,%eax
  8029b1:	f7 f5                	div    %ebp
  8029b3:	89 d0                	mov    %edx,%eax
  8029b5:	e9 44 ff ff ff       	jmp    8028fe <__umoddi3+0x3e>
  8029ba:	66 90                	xchg   %ax,%ax
  8029bc:	89 c8                	mov    %ecx,%eax
  8029be:	89 f2                	mov    %esi,%edx
  8029c0:	83 c4 1c             	add    $0x1c,%esp
  8029c3:	5b                   	pop    %ebx
  8029c4:	5e                   	pop    %esi
  8029c5:	5f                   	pop    %edi
  8029c6:	5d                   	pop    %ebp
  8029c7:	c3                   	ret    
  8029c8:	3b 04 24             	cmp    (%esp),%eax
  8029cb:	72 06                	jb     8029d3 <__umoddi3+0x113>
  8029cd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8029d1:	77 0f                	ja     8029e2 <__umoddi3+0x122>
  8029d3:	89 f2                	mov    %esi,%edx
  8029d5:	29 f9                	sub    %edi,%ecx
  8029d7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8029db:	89 14 24             	mov    %edx,(%esp)
  8029de:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8029e2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8029e6:	8b 14 24             	mov    (%esp),%edx
  8029e9:	83 c4 1c             	add    $0x1c,%esp
  8029ec:	5b                   	pop    %ebx
  8029ed:	5e                   	pop    %esi
  8029ee:	5f                   	pop    %edi
  8029ef:	5d                   	pop    %ebp
  8029f0:	c3                   	ret    
  8029f1:	8d 76 00             	lea    0x0(%esi),%esi
  8029f4:	2b 04 24             	sub    (%esp),%eax
  8029f7:	19 fa                	sbb    %edi,%edx
  8029f9:	89 d1                	mov    %edx,%ecx
  8029fb:	89 c6                	mov    %eax,%esi
  8029fd:	e9 71 ff ff ff       	jmp    802973 <__umoddi3+0xb3>
  802a02:	66 90                	xchg   %ax,%ax
  802a04:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802a08:	72 ea                	jb     8029f4 <__umoddi3+0x134>
  802a0a:	89 d9                	mov    %ebx,%ecx
  802a0c:	e9 62 ff ff ff       	jmp    802973 <__umoddi3+0xb3>
