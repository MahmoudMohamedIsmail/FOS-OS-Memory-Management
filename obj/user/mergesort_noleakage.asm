
obj/user/mergesort_noleakage:     file format elf32-i386


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
  800031:	e8 5e 07 00 00       	call   800794 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

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
  800041:	e8 2f 25 00 00       	call   802575 <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 80 2b 80 00       	push   $0x802b80
  80004e:	e8 2d 09 00 00       	call   800980 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 82 2b 80 00       	push   $0x802b82
  80005e:	e8 1d 09 00 00       	call   800980 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 98 2b 80 00       	push   $0x802b98
  80006e:	e8 0d 09 00 00       	call   800980 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 82 2b 80 00       	push   $0x802b82
  80007e:	e8 fd 08 00 00       	call   800980 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 80 2b 80 00       	push   $0x802b80
  80008e:	e8 ed 08 00 00       	call   800980 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 b0 2b 80 00       	push   $0x802bb0
  8000a5:	e8 51 0f 00 00       	call   800ffb <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 a1 14 00 00       	call   801561 <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 34 18 00 00       	call   801909 <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 d0 2b 80 00       	push   $0x802bd0
  8000e3:	e8 98 08 00 00       	call   800980 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 f2 2b 80 00       	push   $0x802bf2
  8000f3:	e8 88 08 00 00       	call   800980 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 00 2c 80 00       	push   $0x802c00
  800103:	e8 78 08 00 00       	call   800980 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 0f 2c 80 00       	push   $0x802c0f
  800113:	e8 68 08 00 00       	call   800980 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 1f 2c 80 00       	push   $0x802c1f
  800123:	e8 58 08 00 00       	call   800980 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  80012b:	e8 0c 06 00 00       	call   80073c <getchar>
  800130:	88 45 ef             	mov    %al,-0x11(%ebp)
		cputchar(Chose);
  800133:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 b4 05 00 00       	call   8006f4 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 a7 05 00 00       	call   8006f4 <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp

		//2012: lock the interrupt
		sys_enable_interrupt();
  800150:	e8 3a 24 00 00       	call   80258f <sys_enable_interrupt>

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
  800171:	e8 d5 01 00 00       	call   80034b <InitializeAscending>
  800176:	83 c4 10             	add    $0x10,%esp
			break ;
  800179:	eb 37                	jmp    8001b2 <_main+0x17a>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80017b:	83 ec 08             	sub    $0x8,%esp
  80017e:	ff 75 f4             	pushl  -0xc(%ebp)
  800181:	ff 75 f0             	pushl  -0x10(%ebp)
  800184:	e8 f3 01 00 00       	call   80037c <InitializeDescending>
  800189:	83 c4 10             	add    $0x10,%esp
			break ;
  80018c:	eb 24                	jmp    8001b2 <_main+0x17a>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  80018e:	83 ec 08             	sub    $0x8,%esp
  800191:	ff 75 f4             	pushl  -0xc(%ebp)
  800194:	ff 75 f0             	pushl  -0x10(%ebp)
  800197:	e8 15 02 00 00       	call   8003b1 <InitializeSemiRandom>
  80019c:	83 c4 10             	add    $0x10,%esp
			break ;
  80019f:	eb 11                	jmp    8001b2 <_main+0x17a>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8001a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001aa:	e8 02 02 00 00       	call   8003b1 <InitializeSemiRandom>
  8001af:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001b2:	83 ec 04             	sub    $0x4,%esp
  8001b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8001b8:	6a 01                	push   $0x1
  8001ba:	ff 75 f0             	pushl  -0x10(%ebp)
  8001bd:	e8 c1 02 00 00       	call   800483 <MSort>
  8001c2:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001c5:	e8 ab 23 00 00       	call   802575 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001ca:	83 ec 0c             	sub    $0xc,%esp
  8001cd:	68 28 2c 80 00       	push   $0x802c28
  8001d2:	e8 a9 07 00 00       	call   800980 <cprintf>
  8001d7:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001da:	e8 b0 23 00 00       	call   80258f <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001df:	83 ec 08             	sub    $0x8,%esp
  8001e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8001e5:	ff 75 f0             	pushl  -0x10(%ebp)
  8001e8:	e8 b4 00 00 00       	call   8002a1 <CheckSorted>
  8001ed:	83 c4 10             	add    $0x10,%esp
  8001f0:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001f3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8001f7:	75 14                	jne    80020d <_main+0x1d5>
  8001f9:	83 ec 04             	sub    $0x4,%esp
  8001fc:	68 5c 2c 80 00       	push   $0x802c5c
  800201:	6a 47                	push   $0x47
  800203:	68 7e 2c 80 00       	push   $0x802c7e
  800208:	e8 48 06 00 00       	call   800855 <_panic>
		else
		{ 
			sys_disable_interrupt();
  80020d:	e8 63 23 00 00       	call   802575 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800212:	83 ec 0c             	sub    $0xc,%esp
  800215:	68 9c 2c 80 00       	push   $0x802c9c
  80021a:	e8 61 07 00 00       	call   800980 <cprintf>
  80021f:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 d0 2c 80 00       	push   $0x802cd0
  80022a:	e8 51 07 00 00       	call   800980 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 04 2d 80 00       	push   $0x802d04
  80023a:	e8 41 07 00 00       	call   800980 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800242:	e8 48 23 00 00       	call   80258f <sys_enable_interrupt>
		}

		free(Elements) ;
  800247:	83 ec 0c             	sub    $0xc,%esp
  80024a:	ff 75 f0             	pushl  -0x10(%ebp)
  80024d:	e8 59 20 00 00       	call   8022ab <free>
  800252:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  800255:	e8 1b 23 00 00       	call   802575 <sys_disable_interrupt>
		cprintf("Do you want to repeat (y/n): ") ;
  80025a:	83 ec 0c             	sub    $0xc,%esp
  80025d:	68 36 2d 80 00       	push   $0x802d36
  800262:	e8 19 07 00 00       	call   800980 <cprintf>
  800267:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  80026a:	e8 cd 04 00 00       	call   80073c <getchar>
  80026f:	88 45 ef             	mov    %al,-0x11(%ebp)
		cputchar(Chose);
  800272:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  800276:	83 ec 0c             	sub    $0xc,%esp
  800279:	50                   	push   %eax
  80027a:	e8 75 04 00 00       	call   8006f4 <cputchar>
  80027f:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  800282:	83 ec 0c             	sub    $0xc,%esp
  800285:	6a 0a                	push   $0xa
  800287:	e8 68 04 00 00       	call   8006f4 <cputchar>
  80028c:	83 c4 10             	add    $0x10,%esp
		sys_enable_interrupt();
  80028f:	e8 fb 22 00 00       	call   80258f <sys_enable_interrupt>

	} while (Chose == 'y');
  800294:	80 7d ef 79          	cmpb   $0x79,-0x11(%ebp)
  800298:	0f 84 a3 fd ff ff    	je     800041 <_main+0x9>

}
  80029e:	90                   	nop
  80029f:	c9                   	leave  
  8002a0:	c3                   	ret    

008002a1 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002a1:	55                   	push   %ebp
  8002a2:	89 e5                	mov    %esp,%ebp
  8002a4:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002a7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002b5:	eb 33                	jmp    8002ea <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c4:	01 d0                	add    %edx,%eax
  8002c6:	8b 10                	mov    (%eax),%edx
  8002c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002cb:	40                   	inc    %eax
  8002cc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d6:	01 c8                	add    %ecx,%eax
  8002d8:	8b 00                	mov    (%eax),%eax
  8002da:	39 c2                	cmp    %eax,%edx
  8002dc:	7e 09                	jle    8002e7 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8002de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8002e5:	eb 0c                	jmp    8002f3 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002e7:	ff 45 f8             	incl   -0x8(%ebp)
  8002ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ed:	48                   	dec    %eax
  8002ee:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8002f1:	7f c4                	jg     8002b7 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8002f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8002f6:	c9                   	leave  
  8002f7:	c3                   	ret    

008002f8 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  8002f8:	55                   	push   %ebp
  8002f9:	89 e5                	mov    %esp,%ebp
  8002fb:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8002fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800301:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800308:	8b 45 08             	mov    0x8(%ebp),%eax
  80030b:	01 d0                	add    %edx,%eax
  80030d:	8b 00                	mov    (%eax),%eax
  80030f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800312:	8b 45 0c             	mov    0xc(%ebp),%eax
  800315:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80031c:	8b 45 08             	mov    0x8(%ebp),%eax
  80031f:	01 c2                	add    %eax,%edx
  800321:	8b 45 10             	mov    0x10(%ebp),%eax
  800324:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	01 c8                	add    %ecx,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800334:	8b 45 10             	mov    0x10(%ebp),%eax
  800337:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033e:	8b 45 08             	mov    0x8(%ebp),%eax
  800341:	01 c2                	add    %eax,%edx
  800343:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800346:	89 02                	mov    %eax,(%edx)
}
  800348:	90                   	nop
  800349:	c9                   	leave  
  80034a:	c3                   	ret    

0080034b <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80034b:	55                   	push   %ebp
  80034c:	89 e5                	mov    %esp,%ebp
  80034e:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800351:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800358:	eb 17                	jmp    800371 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80035a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80035d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800364:	8b 45 08             	mov    0x8(%ebp),%eax
  800367:	01 c2                	add    %eax,%edx
  800369:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80036c:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80036e:	ff 45 fc             	incl   -0x4(%ebp)
  800371:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800374:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800377:	7c e1                	jl     80035a <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  800379:	90                   	nop
  80037a:	c9                   	leave  
  80037b:	c3                   	ret    

0080037c <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800382:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800389:	eb 1b                	jmp    8003a6 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  80038b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80038e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800395:	8b 45 08             	mov    0x8(%ebp),%eax
  800398:	01 c2                	add    %eax,%edx
  80039a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80039d:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003a0:	48                   	dec    %eax
  8003a1:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a3:	ff 45 fc             	incl   -0x4(%ebp)
  8003a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003a9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003ac:	7c dd                	jl     80038b <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003ae:	90                   	nop
  8003af:	c9                   	leave  
  8003b0:	c3                   	ret    

008003b1 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003b1:	55                   	push   %ebp
  8003b2:	89 e5                	mov    %esp,%ebp
  8003b4:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003ba:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003bf:	f7 e9                	imul   %ecx
  8003c1:	c1 f9 1f             	sar    $0x1f,%ecx
  8003c4:	89 d0                	mov    %edx,%eax
  8003c6:	29 c8                	sub    %ecx,%eax
  8003c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003d2:	eb 1e                	jmp    8003f2 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8003d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003de:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8003e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003e7:	99                   	cltd   
  8003e8:	f7 7d f8             	idivl  -0x8(%ebp)
  8003eb:	89 d0                	mov    %edx,%eax
  8003ed:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003ef:	ff 45 fc             	incl   -0x4(%ebp)
  8003f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003f5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003f8:	7c da                	jl     8003d4 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  8003fa:	90                   	nop
  8003fb:	c9                   	leave  
  8003fc:	c3                   	ret    

008003fd <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  8003fd:	55                   	push   %ebp
  8003fe:	89 e5                	mov    %esp,%ebp
  800400:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800403:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80040a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800411:	eb 42                	jmp    800455 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800416:	99                   	cltd   
  800417:	f7 7d f0             	idivl  -0x10(%ebp)
  80041a:	89 d0                	mov    %edx,%eax
  80041c:	85 c0                	test   %eax,%eax
  80041e:	75 10                	jne    800430 <PrintElements+0x33>
			cprintf("\n");
  800420:	83 ec 0c             	sub    $0xc,%esp
  800423:	68 80 2b 80 00       	push   $0x802b80
  800428:	e8 53 05 00 00       	call   800980 <cprintf>
  80042d:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800433:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	01 d0                	add    %edx,%eax
  80043f:	8b 00                	mov    (%eax),%eax
  800441:	83 ec 08             	sub    $0x8,%esp
  800444:	50                   	push   %eax
  800445:	68 54 2d 80 00       	push   $0x802d54
  80044a:	e8 31 05 00 00       	call   800980 <cprintf>
  80044f:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800452:	ff 45 f4             	incl   -0xc(%ebp)
  800455:	8b 45 0c             	mov    0xc(%ebp),%eax
  800458:	48                   	dec    %eax
  800459:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80045c:	7f b5                	jg     800413 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80045e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800461:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800468:	8b 45 08             	mov    0x8(%ebp),%eax
  80046b:	01 d0                	add    %edx,%eax
  80046d:	8b 00                	mov    (%eax),%eax
  80046f:	83 ec 08             	sub    $0x8,%esp
  800472:	50                   	push   %eax
  800473:	68 59 2d 80 00       	push   $0x802d59
  800478:	e8 03 05 00 00       	call   800980 <cprintf>
  80047d:	83 c4 10             	add    $0x10,%esp

}
  800480:	90                   	nop
  800481:	c9                   	leave  
  800482:	c3                   	ret    

00800483 <MSort>:


void MSort(int* A, int p, int r)
{
  800483:	55                   	push   %ebp
  800484:	89 e5                	mov    %esp,%ebp
  800486:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  800489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80048f:	7d 54                	jge    8004e5 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  800491:	8b 55 0c             	mov    0xc(%ebp),%edx
  800494:	8b 45 10             	mov    0x10(%ebp),%eax
  800497:	01 d0                	add    %edx,%eax
  800499:	89 c2                	mov    %eax,%edx
  80049b:	c1 ea 1f             	shr    $0x1f,%edx
  80049e:	01 d0                	add    %edx,%eax
  8004a0:	d1 f8                	sar    %eax
  8004a2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004a5:	83 ec 04             	sub    $0x4,%esp
  8004a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ab:	ff 75 0c             	pushl  0xc(%ebp)
  8004ae:	ff 75 08             	pushl  0x8(%ebp)
  8004b1:	e8 cd ff ff ff       	call   800483 <MSort>
  8004b6:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004bc:	40                   	inc    %eax
  8004bd:	83 ec 04             	sub    $0x4,%esp
  8004c0:	ff 75 10             	pushl  0x10(%ebp)
  8004c3:	50                   	push   %eax
  8004c4:	ff 75 08             	pushl  0x8(%ebp)
  8004c7:	e8 b7 ff ff ff       	call   800483 <MSort>
  8004cc:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  8004cf:	ff 75 10             	pushl  0x10(%ebp)
  8004d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8004d5:	ff 75 0c             	pushl  0xc(%ebp)
  8004d8:	ff 75 08             	pushl  0x8(%ebp)
  8004db:	e8 08 00 00 00       	call   8004e8 <Merge>
  8004e0:	83 c4 10             	add    $0x10,%esp
  8004e3:	eb 01                	jmp    8004e6 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  8004e5:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  8004e6:	c9                   	leave  
  8004e7:	c3                   	ret    

008004e8 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  8004e8:	55                   	push   %ebp
  8004e9:	89 e5                	mov    %esp,%ebp
  8004eb:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  8004ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f1:	2b 45 0c             	sub    0xc(%ebp),%eax
  8004f4:	40                   	inc    %eax
  8004f5:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  8004f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fb:	2b 45 10             	sub    0x10(%ebp),%eax
  8004fe:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800501:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800508:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  80050f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800512:	c1 e0 02             	shl    $0x2,%eax
  800515:	83 ec 0c             	sub    $0xc,%esp
  800518:	50                   	push   %eax
  800519:	e8 eb 13 00 00       	call   801909 <malloc>
  80051e:	83 c4 10             	add    $0x10,%esp
  800521:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800524:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800527:	c1 e0 02             	shl    $0x2,%eax
  80052a:	83 ec 0c             	sub    $0xc,%esp
  80052d:	50                   	push   %eax
  80052e:	e8 d6 13 00 00       	call   801909 <malloc>
  800533:	83 c4 10             	add    $0x10,%esp
  800536:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800539:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800540:	eb 2f                	jmp    800571 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800542:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800545:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80054c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80054f:	01 c2                	add    %eax,%edx
  800551:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800554:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800557:	01 c8                	add    %ecx,%eax
  800559:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80055e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800565:	8b 45 08             	mov    0x8(%ebp),%eax
  800568:	01 c8                	add    %ecx,%eax
  80056a:	8b 00                	mov    (%eax),%eax
  80056c:	89 02                	mov    %eax,(%edx)
	int* Left = malloc(sizeof(int) * leftCapacity);

	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80056e:	ff 45 ec             	incl   -0x14(%ebp)
  800571:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800574:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800577:	7c c9                	jl     800542 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800579:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800580:	eb 2a                	jmp    8005ac <Merge+0xc4>
	{
		Right[j] = A[q + j];
  800582:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800585:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80058c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80058f:	01 c2                	add    %eax,%edx
  800591:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800594:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800597:	01 c8                	add    %ecx,%eax
  800599:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a3:	01 c8                	add    %ecx,%eax
  8005a5:	8b 00                	mov    (%eax),%eax
  8005a7:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005a9:	ff 45 e8             	incl   -0x18(%ebp)
  8005ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005af:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005b2:	7c ce                	jl     800582 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005ba:	e9 0a 01 00 00       	jmp    8006c9 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005c2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005c5:	0f 8d 95 00 00 00    	jge    800660 <Merge+0x178>
  8005cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ce:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005d1:	0f 8d 89 00 00 00    	jge    800660 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8005d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005e4:	01 d0                	add    %edx,%eax
  8005e6:	8b 10                	mov    (%eax),%edx
  8005e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005eb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005f5:	01 c8                	add    %ecx,%eax
  8005f7:	8b 00                	mov    (%eax),%eax
  8005f9:	39 c2                	cmp    %eax,%edx
  8005fb:	7d 33                	jge    800630 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  8005fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800600:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800605:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80060c:	8b 45 08             	mov    0x8(%ebp),%eax
  80060f:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800615:	8d 50 01             	lea    0x1(%eax),%edx
  800618:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80061b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800622:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800625:	01 d0                	add    %edx,%eax
  800627:	8b 00                	mov    (%eax),%eax
  800629:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80062b:	e9 96 00 00 00       	jmp    8006c6 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800630:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800633:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800638:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80063f:	8b 45 08             	mov    0x8(%ebp),%eax
  800642:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800645:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800648:	8d 50 01             	lea    0x1(%eax),%edx
  80064b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80064e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800655:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800658:	01 d0                	add    %edx,%eax
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80065e:	eb 66                	jmp    8006c6 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800663:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800666:	7d 30                	jge    800698 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  800668:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80066b:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800670:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800677:	8b 45 08             	mov    0x8(%ebp),%eax
  80067a:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80067d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800680:	8d 50 01             	lea    0x1(%eax),%edx
  800683:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800686:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80068d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800690:	01 d0                	add    %edx,%eax
  800692:	8b 00                	mov    (%eax),%eax
  800694:	89 01                	mov    %eax,(%ecx)
  800696:	eb 2e                	jmp    8006c6 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  800698:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80069b:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b0:	8d 50 01             	lea    0x1(%eax),%edx
  8006b3:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006c0:	01 d0                	add    %edx,%eax
  8006c2:	8b 00                	mov    (%eax),%eax
  8006c4:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006c6:	ff 45 e4             	incl   -0x1c(%ebp)
  8006c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006cc:	3b 45 14             	cmp    0x14(%ebp),%eax
  8006cf:	0f 8e ea fe ff ff    	jle    8005bf <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

	free(Left);
  8006d5:	83 ec 0c             	sub    $0xc,%esp
  8006d8:	ff 75 d8             	pushl  -0x28(%ebp)
  8006db:	e8 cb 1b 00 00       	call   8022ab <free>
  8006e0:	83 c4 10             	add    $0x10,%esp
	free(Right);
  8006e3:	83 ec 0c             	sub    $0xc,%esp
  8006e6:	ff 75 d4             	pushl  -0x2c(%ebp)
  8006e9:	e8 bd 1b 00 00       	call   8022ab <free>
  8006ee:	83 c4 10             	add    $0x10,%esp

}
  8006f1:	90                   	nop
  8006f2:	c9                   	leave  
  8006f3:	c3                   	ret    

008006f4 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8006f4:	55                   	push   %ebp
  8006f5:	89 e5                	mov    %esp,%ebp
  8006f7:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8006fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fd:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800700:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800704:	83 ec 0c             	sub    $0xc,%esp
  800707:	50                   	push   %eax
  800708:	e8 9c 1e 00 00       	call   8025a9 <sys_cputc>
  80070d:	83 c4 10             	add    $0x10,%esp
}
  800710:	90                   	nop
  800711:	c9                   	leave  
  800712:	c3                   	ret    

00800713 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800713:	55                   	push   %ebp
  800714:	89 e5                	mov    %esp,%ebp
  800716:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800719:	e8 57 1e 00 00       	call   802575 <sys_disable_interrupt>
	char c = ch;
  80071e:	8b 45 08             	mov    0x8(%ebp),%eax
  800721:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800724:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800728:	83 ec 0c             	sub    $0xc,%esp
  80072b:	50                   	push   %eax
  80072c:	e8 78 1e 00 00       	call   8025a9 <sys_cputc>
  800731:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800734:	e8 56 1e 00 00       	call   80258f <sys_enable_interrupt>
}
  800739:	90                   	nop
  80073a:	c9                   	leave  
  80073b:	c3                   	ret    

0080073c <getchar>:

int
getchar(void)
{
  80073c:	55                   	push   %ebp
  80073d:	89 e5                	mov    %esp,%ebp
  80073f:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800742:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800749:	eb 08                	jmp    800753 <getchar+0x17>
	{
		c = sys_cgetc();
  80074b:	e8 a3 1c 00 00       	call   8023f3 <sys_cgetc>
  800750:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800753:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800757:	74 f2                	je     80074b <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800759:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80075c:	c9                   	leave  
  80075d:	c3                   	ret    

0080075e <atomic_getchar>:

int
atomic_getchar(void)
{
  80075e:	55                   	push   %ebp
  80075f:	89 e5                	mov    %esp,%ebp
  800761:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800764:	e8 0c 1e 00 00       	call   802575 <sys_disable_interrupt>
	int c=0;
  800769:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800770:	eb 08                	jmp    80077a <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800772:	e8 7c 1c 00 00       	call   8023f3 <sys_cgetc>
  800777:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80077a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80077e:	74 f2                	je     800772 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800780:	e8 0a 1e 00 00       	call   80258f <sys_enable_interrupt>
	return c;
  800785:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800788:	c9                   	leave  
  800789:	c3                   	ret    

0080078a <iscons>:

int iscons(int fdnum)
{
  80078a:	55                   	push   %ebp
  80078b:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80078d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800792:	5d                   	pop    %ebp
  800793:	c3                   	ret    

00800794 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800794:	55                   	push   %ebp
  800795:	89 e5                	mov    %esp,%ebp
  800797:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80079a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80079e:	7e 0a                	jle    8007aa <libmain+0x16>
		binaryname = argv[0];
  8007a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a3:	8b 00                	mov    (%eax),%eax
  8007a5:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8007aa:	83 ec 08             	sub    $0x8,%esp
  8007ad:	ff 75 0c             	pushl  0xc(%ebp)
  8007b0:	ff 75 08             	pushl  0x8(%ebp)
  8007b3:	e8 80 f8 ff ff       	call   800038 <_main>
  8007b8:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8007bb:	e8 67 1c 00 00       	call   802427 <sys_getenvid>
  8007c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  8007c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007c6:	89 d0                	mov    %edx,%eax
  8007c8:	c1 e0 03             	shl    $0x3,%eax
  8007cb:	01 d0                	add    %edx,%eax
  8007cd:	01 c0                	add    %eax,%eax
  8007cf:	01 d0                	add    %edx,%eax
  8007d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007d8:	01 d0                	add    %edx,%eax
  8007da:	c1 e0 03             	shl    $0x3,%eax
  8007dd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007e2:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  8007e5:	e8 8b 1d 00 00       	call   802575 <sys_disable_interrupt>
		cprintf("**************************************\n");
  8007ea:	83 ec 0c             	sub    $0xc,%esp
  8007ed:	68 78 2d 80 00       	push   $0x802d78
  8007f2:	e8 89 01 00 00       	call   800980 <cprintf>
  8007f7:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  8007fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007fd:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  800803:	83 ec 08             	sub    $0x8,%esp
  800806:	50                   	push   %eax
  800807:	68 a0 2d 80 00       	push   $0x802da0
  80080c:	e8 6f 01 00 00       	call   800980 <cprintf>
  800811:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800814:	83 ec 0c             	sub    $0xc,%esp
  800817:	68 78 2d 80 00       	push   $0x802d78
  80081c:	e8 5f 01 00 00       	call   800980 <cprintf>
  800821:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800824:	e8 66 1d 00 00       	call   80258f <sys_enable_interrupt>

	// exit gracefully
	exit();
  800829:	e8 19 00 00 00       	call   800847 <exit>
}
  80082e:	90                   	nop
  80082f:	c9                   	leave  
  800830:	c3                   	ret    

00800831 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800831:	55                   	push   %ebp
  800832:	89 e5                	mov    %esp,%ebp
  800834:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800837:	83 ec 0c             	sub    $0xc,%esp
  80083a:	6a 00                	push   $0x0
  80083c:	e8 cb 1b 00 00       	call   80240c <sys_env_destroy>
  800841:	83 c4 10             	add    $0x10,%esp
}
  800844:	90                   	nop
  800845:	c9                   	leave  
  800846:	c3                   	ret    

00800847 <exit>:

void
exit(void)
{
  800847:	55                   	push   %ebp
  800848:	89 e5                	mov    %esp,%ebp
  80084a:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80084d:	e8 ee 1b 00 00       	call   802440 <sys_env_exit>
}
  800852:	90                   	nop
  800853:	c9                   	leave  
  800854:	c3                   	ret    

00800855 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800855:	55                   	push   %ebp
  800856:	89 e5                	mov    %esp,%ebp
  800858:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80085b:	8d 45 10             	lea    0x10(%ebp),%eax
  80085e:	83 c0 04             	add    $0x4,%eax
  800861:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  800864:	a1 70 40 98 00       	mov    0x984070,%eax
  800869:	85 c0                	test   %eax,%eax
  80086b:	74 16                	je     800883 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80086d:	a1 70 40 98 00       	mov    0x984070,%eax
  800872:	83 ec 08             	sub    $0x8,%esp
  800875:	50                   	push   %eax
  800876:	68 b9 2d 80 00       	push   $0x802db9
  80087b:	e8 00 01 00 00       	call   800980 <cprintf>
  800880:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800883:	a1 00 40 80 00       	mov    0x804000,%eax
  800888:	ff 75 0c             	pushl  0xc(%ebp)
  80088b:	ff 75 08             	pushl  0x8(%ebp)
  80088e:	50                   	push   %eax
  80088f:	68 be 2d 80 00       	push   $0x802dbe
  800894:	e8 e7 00 00 00       	call   800980 <cprintf>
  800899:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80089c:	8b 45 10             	mov    0x10(%ebp),%eax
  80089f:	83 ec 08             	sub    $0x8,%esp
  8008a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8008a5:	50                   	push   %eax
  8008a6:	e8 7a 00 00 00       	call   800925 <vcprintf>
  8008ab:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  8008ae:	83 ec 0c             	sub    $0xc,%esp
  8008b1:	68 da 2d 80 00       	push   $0x802dda
  8008b6:	e8 c5 00 00 00       	call   800980 <cprintf>
  8008bb:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8008be:	e8 84 ff ff ff       	call   800847 <exit>

	// should not return here
	while (1) ;
  8008c3:	eb fe                	jmp    8008c3 <_panic+0x6e>

008008c5 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8008c5:	55                   	push   %ebp
  8008c6:	89 e5                	mov    %esp,%ebp
  8008c8:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ce:	8b 00                	mov    (%eax),%eax
  8008d0:	8d 48 01             	lea    0x1(%eax),%ecx
  8008d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d6:	89 0a                	mov    %ecx,(%edx)
  8008d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8008db:	88 d1                	mov    %dl,%cl
  8008dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e7:	8b 00                	mov    (%eax),%eax
  8008e9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008ee:	75 23                	jne    800913 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  8008f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f3:	8b 00                	mov    (%eax),%eax
  8008f5:	89 c2                	mov    %eax,%edx
  8008f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008fa:	83 c0 08             	add    $0x8,%eax
  8008fd:	83 ec 08             	sub    $0x8,%esp
  800900:	52                   	push   %edx
  800901:	50                   	push   %eax
  800902:	e8 cf 1a 00 00       	call   8023d6 <sys_cputs>
  800907:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80090a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800913:	8b 45 0c             	mov    0xc(%ebp),%eax
  800916:	8b 40 04             	mov    0x4(%eax),%eax
  800919:	8d 50 01             	lea    0x1(%eax),%edx
  80091c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800922:	90                   	nop
  800923:	c9                   	leave  
  800924:	c3                   	ret    

00800925 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800925:	55                   	push   %ebp
  800926:	89 e5                	mov    %esp,%ebp
  800928:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80092e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800935:	00 00 00 
	b.cnt = 0;
  800938:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80093f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800942:	ff 75 0c             	pushl  0xc(%ebp)
  800945:	ff 75 08             	pushl  0x8(%ebp)
  800948:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80094e:	50                   	push   %eax
  80094f:	68 c5 08 80 00       	push   $0x8008c5
  800954:	e8 fa 01 00 00       	call   800b53 <vprintfmt>
  800959:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  80095c:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800962:	83 ec 08             	sub    $0x8,%esp
  800965:	50                   	push   %eax
  800966:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80096c:	83 c0 08             	add    $0x8,%eax
  80096f:	50                   	push   %eax
  800970:	e8 61 1a 00 00       	call   8023d6 <sys_cputs>
  800975:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  800978:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80097e:	c9                   	leave  
  80097f:	c3                   	ret    

00800980 <cprintf>:

int cprintf(const char *fmt, ...) {
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800986:	8d 45 0c             	lea    0xc(%ebp),%eax
  800989:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80098c:	8b 45 08             	mov    0x8(%ebp),%eax
  80098f:	83 ec 08             	sub    $0x8,%esp
  800992:	ff 75 f4             	pushl  -0xc(%ebp)
  800995:	50                   	push   %eax
  800996:	e8 8a ff ff ff       	call   800925 <vcprintf>
  80099b:	83 c4 10             	add    $0x10,%esp
  80099e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009a4:	c9                   	leave  
  8009a5:	c3                   	ret    

008009a6 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009a6:	55                   	push   %ebp
  8009a7:	89 e5                	mov    %esp,%ebp
  8009a9:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009ac:	e8 c4 1b 00 00       	call   802575 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009b1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	83 ec 08             	sub    $0x8,%esp
  8009bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8009c0:	50                   	push   %eax
  8009c1:	e8 5f ff ff ff       	call   800925 <vcprintf>
  8009c6:	83 c4 10             	add    $0x10,%esp
  8009c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009cc:	e8 be 1b 00 00       	call   80258f <sys_enable_interrupt>
	return cnt;
  8009d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009d4:	c9                   	leave  
  8009d5:	c3                   	ret    

008009d6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009d6:	55                   	push   %ebp
  8009d7:	89 e5                	mov    %esp,%ebp
  8009d9:	53                   	push   %ebx
  8009da:	83 ec 14             	sub    $0x14,%esp
  8009dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009e9:	8b 45 18             	mov    0x18(%ebp),%eax
  8009ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009f4:	77 55                	ja     800a4b <printnum+0x75>
  8009f6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009f9:	72 05                	jb     800a00 <printnum+0x2a>
  8009fb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009fe:	77 4b                	ja     800a4b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a00:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a03:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a06:	8b 45 18             	mov    0x18(%ebp),%eax
  800a09:	ba 00 00 00 00       	mov    $0x0,%edx
  800a0e:	52                   	push   %edx
  800a0f:	50                   	push   %eax
  800a10:	ff 75 f4             	pushl  -0xc(%ebp)
  800a13:	ff 75 f0             	pushl  -0x10(%ebp)
  800a16:	e8 f9 1e 00 00       	call   802914 <__udivdi3>
  800a1b:	83 c4 10             	add    $0x10,%esp
  800a1e:	83 ec 04             	sub    $0x4,%esp
  800a21:	ff 75 20             	pushl  0x20(%ebp)
  800a24:	53                   	push   %ebx
  800a25:	ff 75 18             	pushl  0x18(%ebp)
  800a28:	52                   	push   %edx
  800a29:	50                   	push   %eax
  800a2a:	ff 75 0c             	pushl  0xc(%ebp)
  800a2d:	ff 75 08             	pushl  0x8(%ebp)
  800a30:	e8 a1 ff ff ff       	call   8009d6 <printnum>
  800a35:	83 c4 20             	add    $0x20,%esp
  800a38:	eb 1a                	jmp    800a54 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a3a:	83 ec 08             	sub    $0x8,%esp
  800a3d:	ff 75 0c             	pushl  0xc(%ebp)
  800a40:	ff 75 20             	pushl  0x20(%ebp)
  800a43:	8b 45 08             	mov    0x8(%ebp),%eax
  800a46:	ff d0                	call   *%eax
  800a48:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a4b:	ff 4d 1c             	decl   0x1c(%ebp)
  800a4e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a52:	7f e6                	jg     800a3a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a54:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a57:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a62:	53                   	push   %ebx
  800a63:	51                   	push   %ecx
  800a64:	52                   	push   %edx
  800a65:	50                   	push   %eax
  800a66:	e8 b9 1f 00 00       	call   802a24 <__umoddi3>
  800a6b:	83 c4 10             	add    $0x10,%esp
  800a6e:	05 f4 2f 80 00       	add    $0x802ff4,%eax
  800a73:	8a 00                	mov    (%eax),%al
  800a75:	0f be c0             	movsbl %al,%eax
  800a78:	83 ec 08             	sub    $0x8,%esp
  800a7b:	ff 75 0c             	pushl  0xc(%ebp)
  800a7e:	50                   	push   %eax
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	ff d0                	call   *%eax
  800a84:	83 c4 10             	add    $0x10,%esp
}
  800a87:	90                   	nop
  800a88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a8b:	c9                   	leave  
  800a8c:	c3                   	ret    

00800a8d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a90:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a94:	7e 1c                	jle    800ab2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	8b 00                	mov    (%eax),%eax
  800a9b:	8d 50 08             	lea    0x8(%eax),%edx
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	89 10                	mov    %edx,(%eax)
  800aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa6:	8b 00                	mov    (%eax),%eax
  800aa8:	83 e8 08             	sub    $0x8,%eax
  800aab:	8b 50 04             	mov    0x4(%eax),%edx
  800aae:	8b 00                	mov    (%eax),%eax
  800ab0:	eb 40                	jmp    800af2 <getuint+0x65>
	else if (lflag)
  800ab2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ab6:	74 1e                	je     800ad6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  800abb:	8b 00                	mov    (%eax),%eax
  800abd:	8d 50 04             	lea    0x4(%eax),%edx
  800ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac3:	89 10                	mov    %edx,(%eax)
  800ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac8:	8b 00                	mov    (%eax),%eax
  800aca:	83 e8 04             	sub    $0x4,%eax
  800acd:	8b 00                	mov    (%eax),%eax
  800acf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ad4:	eb 1c                	jmp    800af2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad9:	8b 00                	mov    (%eax),%eax
  800adb:	8d 50 04             	lea    0x4(%eax),%edx
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	89 10                	mov    %edx,(%eax)
  800ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae6:	8b 00                	mov    (%eax),%eax
  800ae8:	83 e8 04             	sub    $0x4,%eax
  800aeb:	8b 00                	mov    (%eax),%eax
  800aed:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    

00800af4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800af7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800afb:	7e 1c                	jle    800b19 <getint+0x25>
		return va_arg(*ap, long long);
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	8b 00                	mov    (%eax),%eax
  800b02:	8d 50 08             	lea    0x8(%eax),%edx
  800b05:	8b 45 08             	mov    0x8(%ebp),%eax
  800b08:	89 10                	mov    %edx,(%eax)
  800b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0d:	8b 00                	mov    (%eax),%eax
  800b0f:	83 e8 08             	sub    $0x8,%eax
  800b12:	8b 50 04             	mov    0x4(%eax),%edx
  800b15:	8b 00                	mov    (%eax),%eax
  800b17:	eb 38                	jmp    800b51 <getint+0x5d>
	else if (lflag)
  800b19:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b1d:	74 1a                	je     800b39 <getint+0x45>
		return va_arg(*ap, long);
  800b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b22:	8b 00                	mov    (%eax),%eax
  800b24:	8d 50 04             	lea    0x4(%eax),%edx
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	89 10                	mov    %edx,(%eax)
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	8b 00                	mov    (%eax),%eax
  800b31:	83 e8 04             	sub    $0x4,%eax
  800b34:	8b 00                	mov    (%eax),%eax
  800b36:	99                   	cltd   
  800b37:	eb 18                	jmp    800b51 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	8b 00                	mov    (%eax),%eax
  800b3e:	8d 50 04             	lea    0x4(%eax),%edx
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	89 10                	mov    %edx,(%eax)
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	8b 00                	mov    (%eax),%eax
  800b4b:	83 e8 04             	sub    $0x4,%eax
  800b4e:	8b 00                	mov    (%eax),%eax
  800b50:	99                   	cltd   
}
  800b51:	5d                   	pop    %ebp
  800b52:	c3                   	ret    

00800b53 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	56                   	push   %esi
  800b57:	53                   	push   %ebx
  800b58:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b5b:	eb 17                	jmp    800b74 <vprintfmt+0x21>
			if (ch == '\0')
  800b5d:	85 db                	test   %ebx,%ebx
  800b5f:	0f 84 af 03 00 00    	je     800f14 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b65:	83 ec 08             	sub    $0x8,%esp
  800b68:	ff 75 0c             	pushl  0xc(%ebp)
  800b6b:	53                   	push   %ebx
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	ff d0                	call   *%eax
  800b71:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b74:	8b 45 10             	mov    0x10(%ebp),%eax
  800b77:	8d 50 01             	lea    0x1(%eax),%edx
  800b7a:	89 55 10             	mov    %edx,0x10(%ebp)
  800b7d:	8a 00                	mov    (%eax),%al
  800b7f:	0f b6 d8             	movzbl %al,%ebx
  800b82:	83 fb 25             	cmp    $0x25,%ebx
  800b85:	75 d6                	jne    800b5d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b87:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b8b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b92:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b99:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800ba0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ba7:	8b 45 10             	mov    0x10(%ebp),%eax
  800baa:	8d 50 01             	lea    0x1(%eax),%edx
  800bad:	89 55 10             	mov    %edx,0x10(%ebp)
  800bb0:	8a 00                	mov    (%eax),%al
  800bb2:	0f b6 d8             	movzbl %al,%ebx
  800bb5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800bb8:	83 f8 55             	cmp    $0x55,%eax
  800bbb:	0f 87 2b 03 00 00    	ja     800eec <vprintfmt+0x399>
  800bc1:	8b 04 85 18 30 80 00 	mov    0x803018(,%eax,4),%eax
  800bc8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bca:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800bce:	eb d7                	jmp    800ba7 <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bd0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bd4:	eb d1                	jmp    800ba7 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bd6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800bdd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800be0:	89 d0                	mov    %edx,%eax
  800be2:	c1 e0 02             	shl    $0x2,%eax
  800be5:	01 d0                	add    %edx,%eax
  800be7:	01 c0                	add    %eax,%eax
  800be9:	01 d8                	add    %ebx,%eax
  800beb:	83 e8 30             	sub    $0x30,%eax
  800bee:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800bf1:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf4:	8a 00                	mov    (%eax),%al
  800bf6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bf9:	83 fb 2f             	cmp    $0x2f,%ebx
  800bfc:	7e 3e                	jle    800c3c <vprintfmt+0xe9>
  800bfe:	83 fb 39             	cmp    $0x39,%ebx
  800c01:	7f 39                	jg     800c3c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c03:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c06:	eb d5                	jmp    800bdd <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c08:	8b 45 14             	mov    0x14(%ebp),%eax
  800c0b:	83 c0 04             	add    $0x4,%eax
  800c0e:	89 45 14             	mov    %eax,0x14(%ebp)
  800c11:	8b 45 14             	mov    0x14(%ebp),%eax
  800c14:	83 e8 04             	sub    $0x4,%eax
  800c17:	8b 00                	mov    (%eax),%eax
  800c19:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c1c:	eb 1f                	jmp    800c3d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c1e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c22:	79 83                	jns    800ba7 <vprintfmt+0x54>
				width = 0;
  800c24:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c2b:	e9 77 ff ff ff       	jmp    800ba7 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c30:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c37:	e9 6b ff ff ff       	jmp    800ba7 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c3c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c3d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c41:	0f 89 60 ff ff ff    	jns    800ba7 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c47:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c4d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c54:	e9 4e ff ff ff       	jmp    800ba7 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c59:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c5c:	e9 46 ff ff ff       	jmp    800ba7 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c61:	8b 45 14             	mov    0x14(%ebp),%eax
  800c64:	83 c0 04             	add    $0x4,%eax
  800c67:	89 45 14             	mov    %eax,0x14(%ebp)
  800c6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6d:	83 e8 04             	sub    $0x4,%eax
  800c70:	8b 00                	mov    (%eax),%eax
  800c72:	83 ec 08             	sub    $0x8,%esp
  800c75:	ff 75 0c             	pushl  0xc(%ebp)
  800c78:	50                   	push   %eax
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	ff d0                	call   *%eax
  800c7e:	83 c4 10             	add    $0x10,%esp
			break;
  800c81:	e9 89 02 00 00       	jmp    800f0f <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c86:	8b 45 14             	mov    0x14(%ebp),%eax
  800c89:	83 c0 04             	add    $0x4,%eax
  800c8c:	89 45 14             	mov    %eax,0x14(%ebp)
  800c8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c92:	83 e8 04             	sub    $0x4,%eax
  800c95:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800c97:	85 db                	test   %ebx,%ebx
  800c99:	79 02                	jns    800c9d <vprintfmt+0x14a>
				err = -err;
  800c9b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800c9d:	83 fb 64             	cmp    $0x64,%ebx
  800ca0:	7f 0b                	jg     800cad <vprintfmt+0x15a>
  800ca2:	8b 34 9d 60 2e 80 00 	mov    0x802e60(,%ebx,4),%esi
  800ca9:	85 f6                	test   %esi,%esi
  800cab:	75 19                	jne    800cc6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cad:	53                   	push   %ebx
  800cae:	68 05 30 80 00       	push   $0x803005
  800cb3:	ff 75 0c             	pushl  0xc(%ebp)
  800cb6:	ff 75 08             	pushl  0x8(%ebp)
  800cb9:	e8 5e 02 00 00       	call   800f1c <printfmt>
  800cbe:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800cc1:	e9 49 02 00 00       	jmp    800f0f <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cc6:	56                   	push   %esi
  800cc7:	68 0e 30 80 00       	push   $0x80300e
  800ccc:	ff 75 0c             	pushl  0xc(%ebp)
  800ccf:	ff 75 08             	pushl  0x8(%ebp)
  800cd2:	e8 45 02 00 00       	call   800f1c <printfmt>
  800cd7:	83 c4 10             	add    $0x10,%esp
			break;
  800cda:	e9 30 02 00 00       	jmp    800f0f <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800cdf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce2:	83 c0 04             	add    $0x4,%eax
  800ce5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ce8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ceb:	83 e8 04             	sub    $0x4,%eax
  800cee:	8b 30                	mov    (%eax),%esi
  800cf0:	85 f6                	test   %esi,%esi
  800cf2:	75 05                	jne    800cf9 <vprintfmt+0x1a6>
				p = "(null)";
  800cf4:	be 11 30 80 00       	mov    $0x803011,%esi
			if (width > 0 && padc != '-')
  800cf9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cfd:	7e 6d                	jle    800d6c <vprintfmt+0x219>
  800cff:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d03:	74 67                	je     800d6c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d05:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d08:	83 ec 08             	sub    $0x8,%esp
  800d0b:	50                   	push   %eax
  800d0c:	56                   	push   %esi
  800d0d:	e8 12 05 00 00       	call   801224 <strnlen>
  800d12:	83 c4 10             	add    $0x10,%esp
  800d15:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d18:	eb 16                	jmp    800d30 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d1a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d1e:	83 ec 08             	sub    $0x8,%esp
  800d21:	ff 75 0c             	pushl  0xc(%ebp)
  800d24:	50                   	push   %eax
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	ff d0                	call   *%eax
  800d2a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d2d:	ff 4d e4             	decl   -0x1c(%ebp)
  800d30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d34:	7f e4                	jg     800d1a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d36:	eb 34                	jmp    800d6c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d38:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d3c:	74 1c                	je     800d5a <vprintfmt+0x207>
  800d3e:	83 fb 1f             	cmp    $0x1f,%ebx
  800d41:	7e 05                	jle    800d48 <vprintfmt+0x1f5>
  800d43:	83 fb 7e             	cmp    $0x7e,%ebx
  800d46:	7e 12                	jle    800d5a <vprintfmt+0x207>
					putch('?', putdat);
  800d48:	83 ec 08             	sub    $0x8,%esp
  800d4b:	ff 75 0c             	pushl  0xc(%ebp)
  800d4e:	6a 3f                	push   $0x3f
  800d50:	8b 45 08             	mov    0x8(%ebp),%eax
  800d53:	ff d0                	call   *%eax
  800d55:	83 c4 10             	add    $0x10,%esp
  800d58:	eb 0f                	jmp    800d69 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d5a:	83 ec 08             	sub    $0x8,%esp
  800d5d:	ff 75 0c             	pushl  0xc(%ebp)
  800d60:	53                   	push   %ebx
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	ff d0                	call   *%eax
  800d66:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d69:	ff 4d e4             	decl   -0x1c(%ebp)
  800d6c:	89 f0                	mov    %esi,%eax
  800d6e:	8d 70 01             	lea    0x1(%eax),%esi
  800d71:	8a 00                	mov    (%eax),%al
  800d73:	0f be d8             	movsbl %al,%ebx
  800d76:	85 db                	test   %ebx,%ebx
  800d78:	74 24                	je     800d9e <vprintfmt+0x24b>
  800d7a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d7e:	78 b8                	js     800d38 <vprintfmt+0x1e5>
  800d80:	ff 4d e0             	decl   -0x20(%ebp)
  800d83:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d87:	79 af                	jns    800d38 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d89:	eb 13                	jmp    800d9e <vprintfmt+0x24b>
				putch(' ', putdat);
  800d8b:	83 ec 08             	sub    $0x8,%esp
  800d8e:	ff 75 0c             	pushl  0xc(%ebp)
  800d91:	6a 20                	push   $0x20
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	ff d0                	call   *%eax
  800d98:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d9b:	ff 4d e4             	decl   -0x1c(%ebp)
  800d9e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800da2:	7f e7                	jg     800d8b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800da4:	e9 66 01 00 00       	jmp    800f0f <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800da9:	83 ec 08             	sub    $0x8,%esp
  800dac:	ff 75 e8             	pushl  -0x18(%ebp)
  800daf:	8d 45 14             	lea    0x14(%ebp),%eax
  800db2:	50                   	push   %eax
  800db3:	e8 3c fd ff ff       	call   800af4 <getint>
  800db8:	83 c4 10             	add    $0x10,%esp
  800dbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dbe:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dc7:	85 d2                	test   %edx,%edx
  800dc9:	79 23                	jns    800dee <vprintfmt+0x29b>
				putch('-', putdat);
  800dcb:	83 ec 08             	sub    $0x8,%esp
  800dce:	ff 75 0c             	pushl  0xc(%ebp)
  800dd1:	6a 2d                	push   $0x2d
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	ff d0                	call   *%eax
  800dd8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ddb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800de1:	f7 d8                	neg    %eax
  800de3:	83 d2 00             	adc    $0x0,%edx
  800de6:	f7 da                	neg    %edx
  800de8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800deb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800dee:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800df5:	e9 bc 00 00 00       	jmp    800eb6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800dfa:	83 ec 08             	sub    $0x8,%esp
  800dfd:	ff 75 e8             	pushl  -0x18(%ebp)
  800e00:	8d 45 14             	lea    0x14(%ebp),%eax
  800e03:	50                   	push   %eax
  800e04:	e8 84 fc ff ff       	call   800a8d <getuint>
  800e09:	83 c4 10             	add    $0x10,%esp
  800e0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e0f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e12:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e19:	e9 98 00 00 00       	jmp    800eb6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e1e:	83 ec 08             	sub    $0x8,%esp
  800e21:	ff 75 0c             	pushl  0xc(%ebp)
  800e24:	6a 58                	push   $0x58
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
  800e29:	ff d0                	call   *%eax
  800e2b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e2e:	83 ec 08             	sub    $0x8,%esp
  800e31:	ff 75 0c             	pushl  0xc(%ebp)
  800e34:	6a 58                	push   $0x58
  800e36:	8b 45 08             	mov    0x8(%ebp),%eax
  800e39:	ff d0                	call   *%eax
  800e3b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e3e:	83 ec 08             	sub    $0x8,%esp
  800e41:	ff 75 0c             	pushl  0xc(%ebp)
  800e44:	6a 58                	push   $0x58
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	ff d0                	call   *%eax
  800e4b:	83 c4 10             	add    $0x10,%esp
			break;
  800e4e:	e9 bc 00 00 00       	jmp    800f0f <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e53:	83 ec 08             	sub    $0x8,%esp
  800e56:	ff 75 0c             	pushl  0xc(%ebp)
  800e59:	6a 30                	push   $0x30
  800e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5e:	ff d0                	call   *%eax
  800e60:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e63:	83 ec 08             	sub    $0x8,%esp
  800e66:	ff 75 0c             	pushl  0xc(%ebp)
  800e69:	6a 78                	push   $0x78
  800e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6e:	ff d0                	call   *%eax
  800e70:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e73:	8b 45 14             	mov    0x14(%ebp),%eax
  800e76:	83 c0 04             	add    $0x4,%eax
  800e79:	89 45 14             	mov    %eax,0x14(%ebp)
  800e7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e7f:	83 e8 04             	sub    $0x4,%eax
  800e82:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e84:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e87:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e8e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e95:	eb 1f                	jmp    800eb6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800e97:	83 ec 08             	sub    $0x8,%esp
  800e9a:	ff 75 e8             	pushl  -0x18(%ebp)
  800e9d:	8d 45 14             	lea    0x14(%ebp),%eax
  800ea0:	50                   	push   %eax
  800ea1:	e8 e7 fb ff ff       	call   800a8d <getuint>
  800ea6:	83 c4 10             	add    $0x10,%esp
  800ea9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eac:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800eaf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800eb6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800eba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ebd:	83 ec 04             	sub    $0x4,%esp
  800ec0:	52                   	push   %edx
  800ec1:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ec4:	50                   	push   %eax
  800ec5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ec8:	ff 75 f0             	pushl  -0x10(%ebp)
  800ecb:	ff 75 0c             	pushl  0xc(%ebp)
  800ece:	ff 75 08             	pushl  0x8(%ebp)
  800ed1:	e8 00 fb ff ff       	call   8009d6 <printnum>
  800ed6:	83 c4 20             	add    $0x20,%esp
			break;
  800ed9:	eb 34                	jmp    800f0f <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800edb:	83 ec 08             	sub    $0x8,%esp
  800ede:	ff 75 0c             	pushl  0xc(%ebp)
  800ee1:	53                   	push   %ebx
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	ff d0                	call   *%eax
  800ee7:	83 c4 10             	add    $0x10,%esp
			break;
  800eea:	eb 23                	jmp    800f0f <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800eec:	83 ec 08             	sub    $0x8,%esp
  800eef:	ff 75 0c             	pushl  0xc(%ebp)
  800ef2:	6a 25                	push   $0x25
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	ff d0                	call   *%eax
  800ef9:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800efc:	ff 4d 10             	decl   0x10(%ebp)
  800eff:	eb 03                	jmp    800f04 <vprintfmt+0x3b1>
  800f01:	ff 4d 10             	decl   0x10(%ebp)
  800f04:	8b 45 10             	mov    0x10(%ebp),%eax
  800f07:	48                   	dec    %eax
  800f08:	8a 00                	mov    (%eax),%al
  800f0a:	3c 25                	cmp    $0x25,%al
  800f0c:	75 f3                	jne    800f01 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f0e:	90                   	nop
		}
	}
  800f0f:	e9 47 fc ff ff       	jmp    800b5b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f14:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f15:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f18:	5b                   	pop    %ebx
  800f19:	5e                   	pop    %esi
  800f1a:	5d                   	pop    %ebp
  800f1b:	c3                   	ret    

00800f1c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f1c:	55                   	push   %ebp
  800f1d:	89 e5                	mov    %esp,%ebp
  800f1f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f22:	8d 45 10             	lea    0x10(%ebp),%eax
  800f25:	83 c0 04             	add    $0x4,%eax
  800f28:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2e:	ff 75 f4             	pushl  -0xc(%ebp)
  800f31:	50                   	push   %eax
  800f32:	ff 75 0c             	pushl  0xc(%ebp)
  800f35:	ff 75 08             	pushl  0x8(%ebp)
  800f38:	e8 16 fc ff ff       	call   800b53 <vprintfmt>
  800f3d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f40:	90                   	nop
  800f41:	c9                   	leave  
  800f42:	c3                   	ret    

00800f43 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f49:	8b 40 08             	mov    0x8(%eax),%eax
  800f4c:	8d 50 01             	lea    0x1(%eax),%edx
  800f4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f52:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f58:	8b 10                	mov    (%eax),%edx
  800f5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5d:	8b 40 04             	mov    0x4(%eax),%eax
  800f60:	39 c2                	cmp    %eax,%edx
  800f62:	73 12                	jae    800f76 <sprintputch+0x33>
		*b->buf++ = ch;
  800f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f67:	8b 00                	mov    (%eax),%eax
  800f69:	8d 48 01             	lea    0x1(%eax),%ecx
  800f6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f6f:	89 0a                	mov    %ecx,(%edx)
  800f71:	8b 55 08             	mov    0x8(%ebp),%edx
  800f74:	88 10                	mov    %dl,(%eax)
}
  800f76:	90                   	nop
  800f77:	5d                   	pop    %ebp
  800f78:	c3                   	ret    

00800f79 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f79:	55                   	push   %ebp
  800f7a:	89 e5                	mov    %esp,%ebp
  800f7c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f82:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f88:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8e:	01 d0                	add    %edx,%eax
  800f90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f9e:	74 06                	je     800fa6 <vsnprintf+0x2d>
  800fa0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fa4:	7f 07                	jg     800fad <vsnprintf+0x34>
		return -E_INVAL;
  800fa6:	b8 03 00 00 00       	mov    $0x3,%eax
  800fab:	eb 20                	jmp    800fcd <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fad:	ff 75 14             	pushl  0x14(%ebp)
  800fb0:	ff 75 10             	pushl  0x10(%ebp)
  800fb3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fb6:	50                   	push   %eax
  800fb7:	68 43 0f 80 00       	push   $0x800f43
  800fbc:	e8 92 fb ff ff       	call   800b53 <vprintfmt>
  800fc1:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fc7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fcd:	c9                   	leave  
  800fce:	c3                   	ret    

00800fcf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fcf:	55                   	push   %ebp
  800fd0:	89 e5                	mov    %esp,%ebp
  800fd2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fd5:	8d 45 10             	lea    0x10(%ebp),%eax
  800fd8:	83 c0 04             	add    $0x4,%eax
  800fdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fde:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe1:	ff 75 f4             	pushl  -0xc(%ebp)
  800fe4:	50                   	push   %eax
  800fe5:	ff 75 0c             	pushl  0xc(%ebp)
  800fe8:	ff 75 08             	pushl  0x8(%ebp)
  800feb:	e8 89 ff ff ff       	call   800f79 <vsnprintf>
  800ff0:	83 c4 10             	add    $0x10,%esp
  800ff3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ff6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ff9:	c9                   	leave  
  800ffa:	c3                   	ret    

00800ffb <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  801001:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801005:	74 13                	je     80101a <readline+0x1f>
		cprintf("%s", prompt);
  801007:	83 ec 08             	sub    $0x8,%esp
  80100a:	ff 75 08             	pushl  0x8(%ebp)
  80100d:	68 70 31 80 00       	push   $0x803170
  801012:	e8 69 f9 ff ff       	call   800980 <cprintf>
  801017:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80101a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801021:	83 ec 0c             	sub    $0xc,%esp
  801024:	6a 00                	push   $0x0
  801026:	e8 5f f7 ff ff       	call   80078a <iscons>
  80102b:	83 c4 10             	add    $0x10,%esp
  80102e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801031:	e8 06 f7 ff ff       	call   80073c <getchar>
  801036:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801039:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80103d:	79 22                	jns    801061 <readline+0x66>
			if (c != -E_EOF)
  80103f:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801043:	0f 84 ad 00 00 00    	je     8010f6 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801049:	83 ec 08             	sub    $0x8,%esp
  80104c:	ff 75 ec             	pushl  -0x14(%ebp)
  80104f:	68 73 31 80 00       	push   $0x803173
  801054:	e8 27 f9 ff ff       	call   800980 <cprintf>
  801059:	83 c4 10             	add    $0x10,%esp
			return;
  80105c:	e9 95 00 00 00       	jmp    8010f6 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801061:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801065:	7e 34                	jle    80109b <readline+0xa0>
  801067:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80106e:	7f 2b                	jg     80109b <readline+0xa0>
			if (echoing)
  801070:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801074:	74 0e                	je     801084 <readline+0x89>
				cputchar(c);
  801076:	83 ec 0c             	sub    $0xc,%esp
  801079:	ff 75 ec             	pushl  -0x14(%ebp)
  80107c:	e8 73 f6 ff ff       	call   8006f4 <cputchar>
  801081:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801084:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801087:	8d 50 01             	lea    0x1(%eax),%edx
  80108a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80108d:	89 c2                	mov    %eax,%edx
  80108f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801092:	01 d0                	add    %edx,%eax
  801094:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801097:	88 10                	mov    %dl,(%eax)
  801099:	eb 56                	jmp    8010f1 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80109b:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80109f:	75 1f                	jne    8010c0 <readline+0xc5>
  8010a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8010a5:	7e 19                	jle    8010c0 <readline+0xc5>
			if (echoing)
  8010a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8010ab:	74 0e                	je     8010bb <readline+0xc0>
				cputchar(c);
  8010ad:	83 ec 0c             	sub    $0xc,%esp
  8010b0:	ff 75 ec             	pushl  -0x14(%ebp)
  8010b3:	e8 3c f6 ff ff       	call   8006f4 <cputchar>
  8010b8:	83 c4 10             	add    $0x10,%esp

			i--;
  8010bb:	ff 4d f4             	decl   -0xc(%ebp)
  8010be:	eb 31                	jmp    8010f1 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8010c0:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8010c4:	74 0a                	je     8010d0 <readline+0xd5>
  8010c6:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8010ca:	0f 85 61 ff ff ff    	jne    801031 <readline+0x36>
			if (echoing)
  8010d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8010d4:	74 0e                	je     8010e4 <readline+0xe9>
				cputchar(c);
  8010d6:	83 ec 0c             	sub    $0xc,%esp
  8010d9:	ff 75 ec             	pushl  -0x14(%ebp)
  8010dc:	e8 13 f6 ff ff       	call   8006f4 <cputchar>
  8010e1:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8010e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ea:	01 d0                	add    %edx,%eax
  8010ec:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8010ef:	eb 06                	jmp    8010f7 <readline+0xfc>
		}
	}
  8010f1:	e9 3b ff ff ff       	jmp    801031 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8010f6:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8010f7:	c9                   	leave  
  8010f8:	c3                   	ret    

008010f9 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8010f9:	55                   	push   %ebp
  8010fa:	89 e5                	mov    %esp,%ebp
  8010fc:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8010ff:	e8 71 14 00 00       	call   802575 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801104:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801108:	74 13                	je     80111d <atomic_readline+0x24>
		cprintf("%s", prompt);
  80110a:	83 ec 08             	sub    $0x8,%esp
  80110d:	ff 75 08             	pushl  0x8(%ebp)
  801110:	68 70 31 80 00       	push   $0x803170
  801115:	e8 66 f8 ff ff       	call   800980 <cprintf>
  80111a:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80111d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801124:	83 ec 0c             	sub    $0xc,%esp
  801127:	6a 00                	push   $0x0
  801129:	e8 5c f6 ff ff       	call   80078a <iscons>
  80112e:	83 c4 10             	add    $0x10,%esp
  801131:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801134:	e8 03 f6 ff ff       	call   80073c <getchar>
  801139:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80113c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801140:	79 23                	jns    801165 <atomic_readline+0x6c>
			if (c != -E_EOF)
  801142:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801146:	74 13                	je     80115b <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801148:	83 ec 08             	sub    $0x8,%esp
  80114b:	ff 75 ec             	pushl  -0x14(%ebp)
  80114e:	68 73 31 80 00       	push   $0x803173
  801153:	e8 28 f8 ff ff       	call   800980 <cprintf>
  801158:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80115b:	e8 2f 14 00 00       	call   80258f <sys_enable_interrupt>
			return;
  801160:	e9 9a 00 00 00       	jmp    8011ff <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801165:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801169:	7e 34                	jle    80119f <atomic_readline+0xa6>
  80116b:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801172:	7f 2b                	jg     80119f <atomic_readline+0xa6>
			if (echoing)
  801174:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801178:	74 0e                	je     801188 <atomic_readline+0x8f>
				cputchar(c);
  80117a:	83 ec 0c             	sub    $0xc,%esp
  80117d:	ff 75 ec             	pushl  -0x14(%ebp)
  801180:	e8 6f f5 ff ff       	call   8006f4 <cputchar>
  801185:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801188:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80118b:	8d 50 01             	lea    0x1(%eax),%edx
  80118e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801191:	89 c2                	mov    %eax,%edx
  801193:	8b 45 0c             	mov    0xc(%ebp),%eax
  801196:	01 d0                	add    %edx,%eax
  801198:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80119b:	88 10                	mov    %dl,(%eax)
  80119d:	eb 5b                	jmp    8011fa <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80119f:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8011a3:	75 1f                	jne    8011c4 <atomic_readline+0xcb>
  8011a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8011a9:	7e 19                	jle    8011c4 <atomic_readline+0xcb>
			if (echoing)
  8011ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011af:	74 0e                	je     8011bf <atomic_readline+0xc6>
				cputchar(c);
  8011b1:	83 ec 0c             	sub    $0xc,%esp
  8011b4:	ff 75 ec             	pushl  -0x14(%ebp)
  8011b7:	e8 38 f5 ff ff       	call   8006f4 <cputchar>
  8011bc:	83 c4 10             	add    $0x10,%esp
			i--;
  8011bf:	ff 4d f4             	decl   -0xc(%ebp)
  8011c2:	eb 36                	jmp    8011fa <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  8011c4:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8011c8:	74 0a                	je     8011d4 <atomic_readline+0xdb>
  8011ca:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8011ce:	0f 85 60 ff ff ff    	jne    801134 <atomic_readline+0x3b>
			if (echoing)
  8011d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011d8:	74 0e                	je     8011e8 <atomic_readline+0xef>
				cputchar(c);
  8011da:	83 ec 0c             	sub    $0xc,%esp
  8011dd:	ff 75 ec             	pushl  -0x14(%ebp)
  8011e0:	e8 0f f5 ff ff       	call   8006f4 <cputchar>
  8011e5:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8011e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ee:	01 d0                	add    %edx,%eax
  8011f0:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8011f3:	e8 97 13 00 00       	call   80258f <sys_enable_interrupt>
			return;
  8011f8:	eb 05                	jmp    8011ff <atomic_readline+0x106>
		}
	}
  8011fa:	e9 35 ff ff ff       	jmp    801134 <atomic_readline+0x3b>
}
  8011ff:	c9                   	leave  
  801200:	c3                   	ret    

00801201 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801201:	55                   	push   %ebp
  801202:	89 e5                	mov    %esp,%ebp
  801204:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801207:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80120e:	eb 06                	jmp    801216 <strlen+0x15>
		n++;
  801210:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801213:	ff 45 08             	incl   0x8(%ebp)
  801216:	8b 45 08             	mov    0x8(%ebp),%eax
  801219:	8a 00                	mov    (%eax),%al
  80121b:	84 c0                	test   %al,%al
  80121d:	75 f1                	jne    801210 <strlen+0xf>
		n++;
	return n;
  80121f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801222:	c9                   	leave  
  801223:	c3                   	ret    

00801224 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801224:	55                   	push   %ebp
  801225:	89 e5                	mov    %esp,%ebp
  801227:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80122a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801231:	eb 09                	jmp    80123c <strnlen+0x18>
		n++;
  801233:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801236:	ff 45 08             	incl   0x8(%ebp)
  801239:	ff 4d 0c             	decl   0xc(%ebp)
  80123c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801240:	74 09                	je     80124b <strnlen+0x27>
  801242:	8b 45 08             	mov    0x8(%ebp),%eax
  801245:	8a 00                	mov    (%eax),%al
  801247:	84 c0                	test   %al,%al
  801249:	75 e8                	jne    801233 <strnlen+0xf>
		n++;
	return n;
  80124b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80124e:	c9                   	leave  
  80124f:	c3                   	ret    

00801250 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801250:	55                   	push   %ebp
  801251:	89 e5                	mov    %esp,%ebp
  801253:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80125c:	90                   	nop
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	8d 50 01             	lea    0x1(%eax),%edx
  801263:	89 55 08             	mov    %edx,0x8(%ebp)
  801266:	8b 55 0c             	mov    0xc(%ebp),%edx
  801269:	8d 4a 01             	lea    0x1(%edx),%ecx
  80126c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80126f:	8a 12                	mov    (%edx),%dl
  801271:	88 10                	mov    %dl,(%eax)
  801273:	8a 00                	mov    (%eax),%al
  801275:	84 c0                	test   %al,%al
  801277:	75 e4                	jne    80125d <strcpy+0xd>
		/* do nothing */;
	return ret;
  801279:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80127c:	c9                   	leave  
  80127d:	c3                   	ret    

0080127e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80127e:	55                   	push   %ebp
  80127f:	89 e5                	mov    %esp,%ebp
  801281:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80128a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801291:	eb 1f                	jmp    8012b2 <strncpy+0x34>
		*dst++ = *src;
  801293:	8b 45 08             	mov    0x8(%ebp),%eax
  801296:	8d 50 01             	lea    0x1(%eax),%edx
  801299:	89 55 08             	mov    %edx,0x8(%ebp)
  80129c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129f:	8a 12                	mov    (%edx),%dl
  8012a1:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	84 c0                	test   %al,%al
  8012aa:	74 03                	je     8012af <strncpy+0x31>
			src++;
  8012ac:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012af:	ff 45 fc             	incl   -0x4(%ebp)
  8012b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012b8:	72 d9                	jb     801293 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    

008012bf <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8012cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012cf:	74 30                	je     801301 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8012d1:	eb 16                	jmp    8012e9 <strlcpy+0x2a>
			*dst++ = *src++;
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	8d 50 01             	lea    0x1(%eax),%edx
  8012d9:	89 55 08             	mov    %edx,0x8(%ebp)
  8012dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012df:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012e2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012e5:	8a 12                	mov    (%edx),%dl
  8012e7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8012e9:	ff 4d 10             	decl   0x10(%ebp)
  8012ec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012f0:	74 09                	je     8012fb <strlcpy+0x3c>
  8012f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f5:	8a 00                	mov    (%eax),%al
  8012f7:	84 c0                	test   %al,%al
  8012f9:	75 d8                	jne    8012d3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801301:	8b 55 08             	mov    0x8(%ebp),%edx
  801304:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801307:	29 c2                	sub    %eax,%edx
  801309:	89 d0                	mov    %edx,%eax
}
  80130b:	c9                   	leave  
  80130c:	c3                   	ret    

0080130d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80130d:	55                   	push   %ebp
  80130e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801310:	eb 06                	jmp    801318 <strcmp+0xb>
		p++, q++;
  801312:	ff 45 08             	incl   0x8(%ebp)
  801315:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801318:	8b 45 08             	mov    0x8(%ebp),%eax
  80131b:	8a 00                	mov    (%eax),%al
  80131d:	84 c0                	test   %al,%al
  80131f:	74 0e                	je     80132f <strcmp+0x22>
  801321:	8b 45 08             	mov    0x8(%ebp),%eax
  801324:	8a 10                	mov    (%eax),%dl
  801326:	8b 45 0c             	mov    0xc(%ebp),%eax
  801329:	8a 00                	mov    (%eax),%al
  80132b:	38 c2                	cmp    %al,%dl
  80132d:	74 e3                	je     801312 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80132f:	8b 45 08             	mov    0x8(%ebp),%eax
  801332:	8a 00                	mov    (%eax),%al
  801334:	0f b6 d0             	movzbl %al,%edx
  801337:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133a:	8a 00                	mov    (%eax),%al
  80133c:	0f b6 c0             	movzbl %al,%eax
  80133f:	29 c2                	sub    %eax,%edx
  801341:	89 d0                	mov    %edx,%eax
}
  801343:	5d                   	pop    %ebp
  801344:	c3                   	ret    

00801345 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801345:	55                   	push   %ebp
  801346:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801348:	eb 09                	jmp    801353 <strncmp+0xe>
		n--, p++, q++;
  80134a:	ff 4d 10             	decl   0x10(%ebp)
  80134d:	ff 45 08             	incl   0x8(%ebp)
  801350:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801353:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801357:	74 17                	je     801370 <strncmp+0x2b>
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	8a 00                	mov    (%eax),%al
  80135e:	84 c0                	test   %al,%al
  801360:	74 0e                	je     801370 <strncmp+0x2b>
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	8a 10                	mov    (%eax),%dl
  801367:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136a:	8a 00                	mov    (%eax),%al
  80136c:	38 c2                	cmp    %al,%dl
  80136e:	74 da                	je     80134a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801370:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801374:	75 07                	jne    80137d <strncmp+0x38>
		return 0;
  801376:	b8 00 00 00 00       	mov    $0x0,%eax
  80137b:	eb 14                	jmp    801391 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80137d:	8b 45 08             	mov    0x8(%ebp),%eax
  801380:	8a 00                	mov    (%eax),%al
  801382:	0f b6 d0             	movzbl %al,%edx
  801385:	8b 45 0c             	mov    0xc(%ebp),%eax
  801388:	8a 00                	mov    (%eax),%al
  80138a:	0f b6 c0             	movzbl %al,%eax
  80138d:	29 c2                	sub    %eax,%edx
  80138f:	89 d0                	mov    %edx,%eax
}
  801391:	5d                   	pop    %ebp
  801392:	c3                   	ret    

00801393 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801393:	55                   	push   %ebp
  801394:	89 e5                	mov    %esp,%ebp
  801396:	83 ec 04             	sub    $0x4,%esp
  801399:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80139f:	eb 12                	jmp    8013b3 <strchr+0x20>
		if (*s == c)
  8013a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a4:	8a 00                	mov    (%eax),%al
  8013a6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8013a9:	75 05                	jne    8013b0 <strchr+0x1d>
			return (char *) s;
  8013ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ae:	eb 11                	jmp    8013c1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013b0:	ff 45 08             	incl   0x8(%ebp)
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	8a 00                	mov    (%eax),%al
  8013b8:	84 c0                	test   %al,%al
  8013ba:	75 e5                	jne    8013a1 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8013bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013c1:	c9                   	leave  
  8013c2:	c3                   	ret    

008013c3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013c3:	55                   	push   %ebp
  8013c4:	89 e5                	mov    %esp,%ebp
  8013c6:	83 ec 04             	sub    $0x4,%esp
  8013c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013cf:	eb 0d                	jmp    8013de <strfind+0x1b>
		if (*s == c)
  8013d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8013d9:	74 0e                	je     8013e9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8013db:	ff 45 08             	incl   0x8(%ebp)
  8013de:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e1:	8a 00                	mov    (%eax),%al
  8013e3:	84 c0                	test   %al,%al
  8013e5:	75 ea                	jne    8013d1 <strfind+0xe>
  8013e7:	eb 01                	jmp    8013ea <strfind+0x27>
		if (*s == c)
			break;
  8013e9:	90                   	nop
	return (char *) s;
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013ed:	c9                   	leave  
  8013ee:	c3                   	ret    

008013ef <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
  8013f2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8013f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801401:	eb 0e                	jmp    801411 <memset+0x22>
		*p++ = c;
  801403:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801406:	8d 50 01             	lea    0x1(%eax),%edx
  801409:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80140c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80140f:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801411:	ff 4d f8             	decl   -0x8(%ebp)
  801414:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801418:	79 e9                	jns    801403 <memset+0x14>
		*p++ = c;

	return v;
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80141d:	c9                   	leave  
  80141e:	c3                   	ret    

0080141f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80141f:	55                   	push   %ebp
  801420:	89 e5                	mov    %esp,%ebp
  801422:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801425:	8b 45 0c             	mov    0xc(%ebp),%eax
  801428:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801431:	eb 16                	jmp    801449 <memcpy+0x2a>
		*d++ = *s++;
  801433:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801436:	8d 50 01             	lea    0x1(%eax),%edx
  801439:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80143c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80143f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801442:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801445:	8a 12                	mov    (%edx),%dl
  801447:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801449:	8b 45 10             	mov    0x10(%ebp),%eax
  80144c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80144f:	89 55 10             	mov    %edx,0x10(%ebp)
  801452:	85 c0                	test   %eax,%eax
  801454:	75 dd                	jne    801433 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801459:	c9                   	leave  
  80145a:	c3                   	ret    

0080145b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
  80145e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  801461:	8b 45 0c             	mov    0xc(%ebp),%eax
  801464:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801467:	8b 45 08             	mov    0x8(%ebp),%eax
  80146a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80146d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801470:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801473:	73 50                	jae    8014c5 <memmove+0x6a>
  801475:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801478:	8b 45 10             	mov    0x10(%ebp),%eax
  80147b:	01 d0                	add    %edx,%eax
  80147d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801480:	76 43                	jbe    8014c5 <memmove+0x6a>
		s += n;
  801482:	8b 45 10             	mov    0x10(%ebp),%eax
  801485:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801488:	8b 45 10             	mov    0x10(%ebp),%eax
  80148b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80148e:	eb 10                	jmp    8014a0 <memmove+0x45>
			*--d = *--s;
  801490:	ff 4d f8             	decl   -0x8(%ebp)
  801493:	ff 4d fc             	decl   -0x4(%ebp)
  801496:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801499:	8a 10                	mov    (%eax),%dl
  80149b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80149e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8014a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014a6:	89 55 10             	mov    %edx,0x10(%ebp)
  8014a9:	85 c0                	test   %eax,%eax
  8014ab:	75 e3                	jne    801490 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8014ad:	eb 23                	jmp    8014d2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8014af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014b2:	8d 50 01             	lea    0x1(%eax),%edx
  8014b5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014bb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014be:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014c1:	8a 12                	mov    (%edx),%dl
  8014c3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8014c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014cb:	89 55 10             	mov    %edx,0x10(%ebp)
  8014ce:	85 c0                	test   %eax,%eax
  8014d0:	75 dd                	jne    8014af <memmove+0x54>
			*d++ = *s++;

	return dst;
  8014d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014d5:	c9                   	leave  
  8014d6:	c3                   	ret    

008014d7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
  8014da:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8014dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8014e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8014e9:	eb 2a                	jmp    801515 <memcmp+0x3e>
		if (*s1 != *s2)
  8014eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014ee:	8a 10                	mov    (%eax),%dl
  8014f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f3:	8a 00                	mov    (%eax),%al
  8014f5:	38 c2                	cmp    %al,%dl
  8014f7:	74 16                	je     80150f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8014f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014fc:	8a 00                	mov    (%eax),%al
  8014fe:	0f b6 d0             	movzbl %al,%edx
  801501:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801504:	8a 00                	mov    (%eax),%al
  801506:	0f b6 c0             	movzbl %al,%eax
  801509:	29 c2                	sub    %eax,%edx
  80150b:	89 d0                	mov    %edx,%eax
  80150d:	eb 18                	jmp    801527 <memcmp+0x50>
		s1++, s2++;
  80150f:	ff 45 fc             	incl   -0x4(%ebp)
  801512:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801515:	8b 45 10             	mov    0x10(%ebp),%eax
  801518:	8d 50 ff             	lea    -0x1(%eax),%edx
  80151b:	89 55 10             	mov    %edx,0x10(%ebp)
  80151e:	85 c0                	test   %eax,%eax
  801520:	75 c9                	jne    8014eb <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801522:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801527:	c9                   	leave  
  801528:	c3                   	ret    

00801529 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801529:	55                   	push   %ebp
  80152a:	89 e5                	mov    %esp,%ebp
  80152c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80152f:	8b 55 08             	mov    0x8(%ebp),%edx
  801532:	8b 45 10             	mov    0x10(%ebp),%eax
  801535:	01 d0                	add    %edx,%eax
  801537:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80153a:	eb 15                	jmp    801551 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80153c:	8b 45 08             	mov    0x8(%ebp),%eax
  80153f:	8a 00                	mov    (%eax),%al
  801541:	0f b6 d0             	movzbl %al,%edx
  801544:	8b 45 0c             	mov    0xc(%ebp),%eax
  801547:	0f b6 c0             	movzbl %al,%eax
  80154a:	39 c2                	cmp    %eax,%edx
  80154c:	74 0d                	je     80155b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80154e:	ff 45 08             	incl   0x8(%ebp)
  801551:	8b 45 08             	mov    0x8(%ebp),%eax
  801554:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801557:	72 e3                	jb     80153c <memfind+0x13>
  801559:	eb 01                	jmp    80155c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80155b:	90                   	nop
	return (void *) s;
  80155c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80155f:	c9                   	leave  
  801560:	c3                   	ret    

00801561 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801567:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80156e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801575:	eb 03                	jmp    80157a <strtol+0x19>
		s++;
  801577:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80157a:	8b 45 08             	mov    0x8(%ebp),%eax
  80157d:	8a 00                	mov    (%eax),%al
  80157f:	3c 20                	cmp    $0x20,%al
  801581:	74 f4                	je     801577 <strtol+0x16>
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	8a 00                	mov    (%eax),%al
  801588:	3c 09                	cmp    $0x9,%al
  80158a:	74 eb                	je     801577 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	8a 00                	mov    (%eax),%al
  801591:	3c 2b                	cmp    $0x2b,%al
  801593:	75 05                	jne    80159a <strtol+0x39>
		s++;
  801595:	ff 45 08             	incl   0x8(%ebp)
  801598:	eb 13                	jmp    8015ad <strtol+0x4c>
	else if (*s == '-')
  80159a:	8b 45 08             	mov    0x8(%ebp),%eax
  80159d:	8a 00                	mov    (%eax),%al
  80159f:	3c 2d                	cmp    $0x2d,%al
  8015a1:	75 0a                	jne    8015ad <strtol+0x4c>
		s++, neg = 1;
  8015a3:	ff 45 08             	incl   0x8(%ebp)
  8015a6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015b1:	74 06                	je     8015b9 <strtol+0x58>
  8015b3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8015b7:	75 20                	jne    8015d9 <strtol+0x78>
  8015b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bc:	8a 00                	mov    (%eax),%al
  8015be:	3c 30                	cmp    $0x30,%al
  8015c0:	75 17                	jne    8015d9 <strtol+0x78>
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c5:	40                   	inc    %eax
  8015c6:	8a 00                	mov    (%eax),%al
  8015c8:	3c 78                	cmp    $0x78,%al
  8015ca:	75 0d                	jne    8015d9 <strtol+0x78>
		s += 2, base = 16;
  8015cc:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8015d0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8015d7:	eb 28                	jmp    801601 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8015d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015dd:	75 15                	jne    8015f4 <strtol+0x93>
  8015df:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e2:	8a 00                	mov    (%eax),%al
  8015e4:	3c 30                	cmp    $0x30,%al
  8015e6:	75 0c                	jne    8015f4 <strtol+0x93>
		s++, base = 8;
  8015e8:	ff 45 08             	incl   0x8(%ebp)
  8015eb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8015f2:	eb 0d                	jmp    801601 <strtol+0xa0>
	else if (base == 0)
  8015f4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015f8:	75 07                	jne    801601 <strtol+0xa0>
		base = 10;
  8015fa:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801601:	8b 45 08             	mov    0x8(%ebp),%eax
  801604:	8a 00                	mov    (%eax),%al
  801606:	3c 2f                	cmp    $0x2f,%al
  801608:	7e 19                	jle    801623 <strtol+0xc2>
  80160a:	8b 45 08             	mov    0x8(%ebp),%eax
  80160d:	8a 00                	mov    (%eax),%al
  80160f:	3c 39                	cmp    $0x39,%al
  801611:	7f 10                	jg     801623 <strtol+0xc2>
			dig = *s - '0';
  801613:	8b 45 08             	mov    0x8(%ebp),%eax
  801616:	8a 00                	mov    (%eax),%al
  801618:	0f be c0             	movsbl %al,%eax
  80161b:	83 e8 30             	sub    $0x30,%eax
  80161e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801621:	eb 42                	jmp    801665 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	8a 00                	mov    (%eax),%al
  801628:	3c 60                	cmp    $0x60,%al
  80162a:	7e 19                	jle    801645 <strtol+0xe4>
  80162c:	8b 45 08             	mov    0x8(%ebp),%eax
  80162f:	8a 00                	mov    (%eax),%al
  801631:	3c 7a                	cmp    $0x7a,%al
  801633:	7f 10                	jg     801645 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	8a 00                	mov    (%eax),%al
  80163a:	0f be c0             	movsbl %al,%eax
  80163d:	83 e8 57             	sub    $0x57,%eax
  801640:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801643:	eb 20                	jmp    801665 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801645:	8b 45 08             	mov    0x8(%ebp),%eax
  801648:	8a 00                	mov    (%eax),%al
  80164a:	3c 40                	cmp    $0x40,%al
  80164c:	7e 39                	jle    801687 <strtol+0x126>
  80164e:	8b 45 08             	mov    0x8(%ebp),%eax
  801651:	8a 00                	mov    (%eax),%al
  801653:	3c 5a                	cmp    $0x5a,%al
  801655:	7f 30                	jg     801687 <strtol+0x126>
			dig = *s - 'A' + 10;
  801657:	8b 45 08             	mov    0x8(%ebp),%eax
  80165a:	8a 00                	mov    (%eax),%al
  80165c:	0f be c0             	movsbl %al,%eax
  80165f:	83 e8 37             	sub    $0x37,%eax
  801662:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801668:	3b 45 10             	cmp    0x10(%ebp),%eax
  80166b:	7d 19                	jge    801686 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80166d:	ff 45 08             	incl   0x8(%ebp)
  801670:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801673:	0f af 45 10          	imul   0x10(%ebp),%eax
  801677:	89 c2                	mov    %eax,%edx
  801679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167c:	01 d0                	add    %edx,%eax
  80167e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801681:	e9 7b ff ff ff       	jmp    801601 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801686:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801687:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80168b:	74 08                	je     801695 <strtol+0x134>
		*endptr = (char *) s;
  80168d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801690:	8b 55 08             	mov    0x8(%ebp),%edx
  801693:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801695:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801699:	74 07                	je     8016a2 <strtol+0x141>
  80169b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80169e:	f7 d8                	neg    %eax
  8016a0:	eb 03                	jmp    8016a5 <strtol+0x144>
  8016a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8016a5:	c9                   	leave  
  8016a6:	c3                   	ret    

008016a7 <ltostr>:

void
ltostr(long value, char *str)
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
  8016aa:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8016ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8016b4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8016bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016bf:	79 13                	jns    8016d4 <ltostr+0x2d>
	{
		neg = 1;
  8016c1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8016c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016cb:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8016ce:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8016d1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8016d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8016dc:	99                   	cltd   
  8016dd:	f7 f9                	idiv   %ecx
  8016df:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8016e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016e5:	8d 50 01             	lea    0x1(%eax),%edx
  8016e8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016eb:	89 c2                	mov    %eax,%edx
  8016ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f0:	01 d0                	add    %edx,%eax
  8016f2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016f5:	83 c2 30             	add    $0x30,%edx
  8016f8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8016fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016fd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801702:	f7 e9                	imul   %ecx
  801704:	c1 fa 02             	sar    $0x2,%edx
  801707:	89 c8                	mov    %ecx,%eax
  801709:	c1 f8 1f             	sar    $0x1f,%eax
  80170c:	29 c2                	sub    %eax,%edx
  80170e:	89 d0                	mov    %edx,%eax
  801710:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801713:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801716:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80171b:	f7 e9                	imul   %ecx
  80171d:	c1 fa 02             	sar    $0x2,%edx
  801720:	89 c8                	mov    %ecx,%eax
  801722:	c1 f8 1f             	sar    $0x1f,%eax
  801725:	29 c2                	sub    %eax,%edx
  801727:	89 d0                	mov    %edx,%eax
  801729:	c1 e0 02             	shl    $0x2,%eax
  80172c:	01 d0                	add    %edx,%eax
  80172e:	01 c0                	add    %eax,%eax
  801730:	29 c1                	sub    %eax,%ecx
  801732:	89 ca                	mov    %ecx,%edx
  801734:	85 d2                	test   %edx,%edx
  801736:	75 9c                	jne    8016d4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801738:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80173f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801742:	48                   	dec    %eax
  801743:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801746:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80174a:	74 3d                	je     801789 <ltostr+0xe2>
		start = 1 ;
  80174c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801753:	eb 34                	jmp    801789 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801755:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801758:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175b:	01 d0                	add    %edx,%eax
  80175d:	8a 00                	mov    (%eax),%al
  80175f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801762:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801765:	8b 45 0c             	mov    0xc(%ebp),%eax
  801768:	01 c2                	add    %eax,%edx
  80176a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80176d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801770:	01 c8                	add    %ecx,%eax
  801772:	8a 00                	mov    (%eax),%al
  801774:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801776:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801779:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177c:	01 c2                	add    %eax,%edx
  80177e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801781:	88 02                	mov    %al,(%edx)
		start++ ;
  801783:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801786:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80178f:	7c c4                	jl     801755 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801791:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801794:	8b 45 0c             	mov    0xc(%ebp),%eax
  801797:	01 d0                	add    %edx,%eax
  801799:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80179c:	90                   	nop
  80179d:	c9                   	leave  
  80179e:	c3                   	ret    

0080179f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80179f:	55                   	push   %ebp
  8017a0:	89 e5                	mov    %esp,%ebp
  8017a2:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8017a5:	ff 75 08             	pushl  0x8(%ebp)
  8017a8:	e8 54 fa ff ff       	call   801201 <strlen>
  8017ad:	83 c4 04             	add    $0x4,%esp
  8017b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8017b3:	ff 75 0c             	pushl  0xc(%ebp)
  8017b6:	e8 46 fa ff ff       	call   801201 <strlen>
  8017bb:	83 c4 04             	add    $0x4,%esp
  8017be:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8017c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8017c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017cf:	eb 17                	jmp    8017e8 <strcconcat+0x49>
		final[s] = str1[s] ;
  8017d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d7:	01 c2                	add    %eax,%edx
  8017d9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017df:	01 c8                	add    %ecx,%eax
  8017e1:	8a 00                	mov    (%eax),%al
  8017e3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8017e5:	ff 45 fc             	incl   -0x4(%ebp)
  8017e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017eb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8017ee:	7c e1                	jl     8017d1 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8017f0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8017f7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8017fe:	eb 1f                	jmp    80181f <strcconcat+0x80>
		final[s++] = str2[i] ;
  801800:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801803:	8d 50 01             	lea    0x1(%eax),%edx
  801806:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801809:	89 c2                	mov    %eax,%edx
  80180b:	8b 45 10             	mov    0x10(%ebp),%eax
  80180e:	01 c2                	add    %eax,%edx
  801810:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801813:	8b 45 0c             	mov    0xc(%ebp),%eax
  801816:	01 c8                	add    %ecx,%eax
  801818:	8a 00                	mov    (%eax),%al
  80181a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80181c:	ff 45 f8             	incl   -0x8(%ebp)
  80181f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801822:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801825:	7c d9                	jl     801800 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801827:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80182a:	8b 45 10             	mov    0x10(%ebp),%eax
  80182d:	01 d0                	add    %edx,%eax
  80182f:	c6 00 00             	movb   $0x0,(%eax)
}
  801832:	90                   	nop
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801838:	8b 45 14             	mov    0x14(%ebp),%eax
  80183b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801841:	8b 45 14             	mov    0x14(%ebp),%eax
  801844:	8b 00                	mov    (%eax),%eax
  801846:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80184d:	8b 45 10             	mov    0x10(%ebp),%eax
  801850:	01 d0                	add    %edx,%eax
  801852:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801858:	eb 0c                	jmp    801866 <strsplit+0x31>
			*string++ = 0;
  80185a:	8b 45 08             	mov    0x8(%ebp),%eax
  80185d:	8d 50 01             	lea    0x1(%eax),%edx
  801860:	89 55 08             	mov    %edx,0x8(%ebp)
  801863:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
  801869:	8a 00                	mov    (%eax),%al
  80186b:	84 c0                	test   %al,%al
  80186d:	74 18                	je     801887 <strsplit+0x52>
  80186f:	8b 45 08             	mov    0x8(%ebp),%eax
  801872:	8a 00                	mov    (%eax),%al
  801874:	0f be c0             	movsbl %al,%eax
  801877:	50                   	push   %eax
  801878:	ff 75 0c             	pushl  0xc(%ebp)
  80187b:	e8 13 fb ff ff       	call   801393 <strchr>
  801880:	83 c4 08             	add    $0x8,%esp
  801883:	85 c0                	test   %eax,%eax
  801885:	75 d3                	jne    80185a <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  801887:	8b 45 08             	mov    0x8(%ebp),%eax
  80188a:	8a 00                	mov    (%eax),%al
  80188c:	84 c0                	test   %al,%al
  80188e:	74 5a                	je     8018ea <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  801890:	8b 45 14             	mov    0x14(%ebp),%eax
  801893:	8b 00                	mov    (%eax),%eax
  801895:	83 f8 0f             	cmp    $0xf,%eax
  801898:	75 07                	jne    8018a1 <strsplit+0x6c>
		{
			return 0;
  80189a:	b8 00 00 00 00       	mov    $0x0,%eax
  80189f:	eb 66                	jmp    801907 <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8018a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8018a4:	8b 00                	mov    (%eax),%eax
  8018a6:	8d 48 01             	lea    0x1(%eax),%ecx
  8018a9:	8b 55 14             	mov    0x14(%ebp),%edx
  8018ac:	89 0a                	mov    %ecx,(%edx)
  8018ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b8:	01 c2                	add    %eax,%edx
  8018ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bd:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018bf:	eb 03                	jmp    8018c4 <strsplit+0x8f>
			string++;
  8018c1:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c7:	8a 00                	mov    (%eax),%al
  8018c9:	84 c0                	test   %al,%al
  8018cb:	74 8b                	je     801858 <strsplit+0x23>
  8018cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d0:	8a 00                	mov    (%eax),%al
  8018d2:	0f be c0             	movsbl %al,%eax
  8018d5:	50                   	push   %eax
  8018d6:	ff 75 0c             	pushl  0xc(%ebp)
  8018d9:	e8 b5 fa ff ff       	call   801393 <strchr>
  8018de:	83 c4 08             	add    $0x8,%esp
  8018e1:	85 c0                	test   %eax,%eax
  8018e3:	74 dc                	je     8018c1 <strsplit+0x8c>
			string++;
	}
  8018e5:	e9 6e ff ff ff       	jmp    801858 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8018ea:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8018eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8018ee:	8b 00                	mov    (%eax),%eax
  8018f0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8018fa:	01 d0                	add    %edx,%eax
  8018fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801902:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801907:	c9                   	leave  
  801908:	c3                   	ret    

00801909 <malloc>:
int cnt_mem = 0;
int heap_mem[size_uhmem] = { 0 };
struct hmem heap_size[size_uhmem] = { 0 };
int check = 0;

void* malloc(uint32 size) {
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
  80190c:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyNEXTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	//NEXT FIT
	if (sys_isUHeapPlacementStrategyNEXTFIT()) {
  801912:	e8 7d 0f 00 00       	call   802894 <sys_isUHeapPlacementStrategyNEXTFIT>
  801917:	85 c0                	test   %eax,%eax
  801919:	0f 84 6f 03 00 00    	je     801c8e <malloc+0x385>
		size = ROUNDUP(size, PAGE_SIZE);
  80191f:	c7 45 84 00 10 00 00 	movl   $0x1000,-0x7c(%ebp)
  801926:	8b 55 08             	mov    0x8(%ebp),%edx
  801929:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80192c:	01 d0                	add    %edx,%eax
  80192e:	48                   	dec    %eax
  80192f:	89 45 80             	mov    %eax,-0x80(%ebp)
  801932:	8b 45 80             	mov    -0x80(%ebp),%eax
  801935:	ba 00 00 00 00       	mov    $0x0,%edx
  80193a:	f7 75 84             	divl   -0x7c(%ebp)
  80193d:	8b 45 80             	mov    -0x80(%ebp),%eax
  801940:	29 d0                	sub    %edx,%eax
  801942:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801945:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801949:	74 09                	je     801954 <malloc+0x4b>
  80194b:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801952:	76 0a                	jbe    80195e <malloc+0x55>
			return NULL;
  801954:	b8 00 00 00 00       	mov    $0x0,%eax
  801959:	e9 4b 09 00 00       	jmp    8022a9 <malloc+0x9a0>
		}
		// first we can allocate by " Strategy Continues "
		if (ptr_uheap + size <= (uint32) USER_HEAP_MAX && !check) {
  80195e:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801964:	8b 45 08             	mov    0x8(%ebp),%eax
  801967:	01 d0                	add    %edx,%eax
  801969:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80196e:	0f 87 a2 00 00 00    	ja     801a16 <malloc+0x10d>
  801974:	a1 60 40 98 00       	mov    0x984060,%eax
  801979:	85 c0                	test   %eax,%eax
  80197b:	0f 85 95 00 00 00    	jne    801a16 <malloc+0x10d>

			void* ret = (void *) ptr_uheap;
  801981:	a1 04 40 80 00       	mov    0x804004,%eax
  801986:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			sys_allocateMem(ptr_uheap, size);
  80198c:	a1 04 40 80 00       	mov    0x804004,%eax
  801991:	83 ec 08             	sub    $0x8,%esp
  801994:	ff 75 08             	pushl  0x8(%ebp)
  801997:	50                   	push   %eax
  801998:	e8 a3 0b 00 00       	call   802540 <sys_allocateMem>
  80199d:	83 c4 10             	add    $0x10,%esp

			heap_size[cnt_mem].size = size;
  8019a0:	a1 40 40 80 00       	mov    0x804040,%eax
  8019a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8019a8:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8019af:	a1 40 40 80 00       	mov    0x804040,%eax
  8019b4:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8019ba:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
			cnt_mem++;
  8019c1:	a1 40 40 80 00       	mov    0x804040,%eax
  8019c6:	40                   	inc    %eax
  8019c7:	a3 40 40 80 00       	mov    %eax,0x804040
			int i = 0;
  8019cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  8019d3:	eb 2e                	jmp    801a03 <malloc+0xfa>
			{

				heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8019d5:	a1 04 40 80 00       	mov    0x804004,%eax
  8019da:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] = 1;
  8019df:	c1 e8 0c             	shr    $0xc,%eax
  8019e2:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  8019e9:	01 00 00 00 

				ptr_uheap += (uint32) PAGE_SIZE;
  8019ed:	a1 04 40 80 00       	mov    0x804004,%eax
  8019f2:	05 00 10 00 00       	add    $0x1000,%eax
  8019f7:	a3 04 40 80 00       	mov    %eax,0x804004
			heap_size[cnt_mem].size = size;
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
			cnt_mem++;
			int i = 0;
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  8019fc:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a06:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a09:	72 ca                	jb     8019d5 <malloc+0xcc>
						/ (uint32) PAGE_SIZE)] = 1;

				ptr_uheap += (uint32) PAGE_SIZE;
			}

			return ret;
  801a0b:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  801a11:	e9 93 08 00 00       	jmp    8022a9 <malloc+0x9a0>

		} else {
			// second we can allocate by " Strategy NEXTFIT "
			void* temp_end = NULL;
  801a16:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

			int check_start = 0;
  801a1d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			// check first that we used " Strategy Continues " before and not do it again and turn to NEXTFIT
			if (!check) {
  801a24:	a1 60 40 98 00       	mov    0x984060,%eax
  801a29:	85 c0                	test   %eax,%eax
  801a2b:	75 1d                	jne    801a4a <malloc+0x141>
				ptr_uheap = (uint32) USER_HEAP_START;
  801a2d:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  801a34:	00 00 80 
				check = 1;
  801a37:	c7 05 60 40 98 00 01 	movl   $0x1,0x984060
  801a3e:	00 00 00 
				check_start = 1;// to dont use second loop CZ ptr_uheap start from USER_HEAP_START
  801a41:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  801a48:	eb 08                	jmp    801a52 <malloc+0x149>
			} else {
				temp_end = (void*) ptr_uheap;
  801a4a:	a1 04 40 80 00       	mov    0x804004,%eax
  801a4f:	89 45 f0             	mov    %eax,-0x10(%ebp)

			}

			uint32 sz = 0;
  801a52:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
			int f = 0;
  801a59:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			uint32 ptr = ptr_uheap;
  801a60:	a1 04 40 80 00       	mov    0x804004,%eax
  801a65:	89 45 e0             	mov    %eax,-0x20(%ebp)
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  801a68:	eb 4d                	jmp    801ab7 <malloc+0x1ae>
				if (sz == size) {
  801a6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a6d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a70:	75 09                	jne    801a7b <malloc+0x172>
					f = 1;
  801a72:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  801a79:	eb 45                	jmp    801ac0 <malloc+0x1b7>
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801a7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a7e:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] == 0) {
  801a83:	c1 e8 0c             	shr    $0xc,%eax
			while (ptr < (uint32) USER_HEAP_MAX) {
				if (sz == size) {
					f = 1;
					break;
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801a86:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  801a8d:	85 c0                	test   %eax,%eax
  801a8f:	75 10                	jne    801aa1 <malloc+0x198>
						/ (uint32) PAGE_SIZE)] == 0) {

					sz += PAGE_SIZE;
  801a91:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
					ptr += PAGE_SIZE;
  801a98:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  801a9f:	eb 16                	jmp    801ab7 <malloc+0x1ae>
				} else {
					sz = 0;
  801aa1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
					ptr += PAGE_SIZE;
  801aa8:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
					ptr_uheap = ptr;
  801aaf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ab2:	a3 04 40 80 00       	mov    %eax,0x804004

			uint32 sz = 0;
			int f = 0;
			uint32 ptr = ptr_uheap;
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  801ab7:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  801abe:	76 aa                	jbe    801a6a <malloc+0x161>
					ptr_uheap = ptr;
				}

			}

			if (f) {
  801ac0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ac4:	0f 84 95 00 00 00    	je     801b5f <malloc+0x256>

				void* ret = (void *) ptr_uheap;
  801aca:	a1 04 40 80 00       	mov    0x804004,%eax
  801acf:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

				sys_allocateMem(ptr_uheap, size);
  801ad5:	a1 04 40 80 00       	mov    0x804004,%eax
  801ada:	83 ec 08             	sub    $0x8,%esp
  801add:	ff 75 08             	pushl  0x8(%ebp)
  801ae0:	50                   	push   %eax
  801ae1:	e8 5a 0a 00 00       	call   802540 <sys_allocateMem>
  801ae6:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  801ae9:	a1 40 40 80 00       	mov    0x804040,%eax
  801aee:	8b 55 08             	mov    0x8(%ebp),%edx
  801af1:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801af8:	a1 40 40 80 00       	mov    0x804040,%eax
  801afd:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b03:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
				cnt_mem++;
  801b0a:	a1 40 40 80 00       	mov    0x804040,%eax
  801b0f:	40                   	inc    %eax
  801b10:	a3 40 40 80 00       	mov    %eax,0x804040
				int i = 0;
  801b15:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801b1c:	eb 2e                	jmp    801b4c <malloc+0x243>
				{

					heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801b1e:	a1 04 40 80 00       	mov    0x804004,%eax
  801b23:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  801b28:	c1 e8 0c             	shr    $0xc,%eax
  801b2b:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  801b32:	01 00 00 00 

					ptr_uheap += (uint32) PAGE_SIZE;
  801b36:	a1 04 40 80 00       	mov    0x804004,%eax
  801b3b:	05 00 10 00 00       	add    $0x1000,%eax
  801b40:	a3 04 40 80 00       	mov    %eax,0x804004
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
				cnt_mem++;
				int i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801b45:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801b4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b4f:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b52:	72 ca                	jb     801b1e <malloc+0x215>
							/ (uint32) PAGE_SIZE)] = 1;

					ptr_uheap += (uint32) PAGE_SIZE;
				}

				return ret;
  801b54:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  801b5a:	e9 4a 07 00 00       	jmp    8022a9 <malloc+0x9a0>

			} else {

				if (check_start) {
  801b5f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b63:	74 0a                	je     801b6f <malloc+0x266>

					return NULL;
  801b65:	b8 00 00 00 00       	mov    $0x0,%eax
  801b6a:	e9 3a 07 00 00       	jmp    8022a9 <malloc+0x9a0>
				}

//////////////back loop////////////////

				uint32 sz = 0;
  801b6f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
				int f = 0;
  801b76:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				uint32 ptr = USER_HEAP_START;
  801b7d:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
				ptr_uheap = USER_HEAP_START;
  801b84:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  801b8b:	00 00 80 
				while (ptr < (uint32) temp_end) {
  801b8e:	eb 4d                	jmp    801bdd <malloc+0x2d4>
					if (sz == size) {
  801b90:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b93:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b96:	75 09                	jne    801ba1 <malloc+0x298>
						f = 1;
  801b98:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
						break;
  801b9f:	eb 44                	jmp    801be5 <malloc+0x2dc>
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801ba1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ba4:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] == 0) {
  801ba9:	c1 e8 0c             	shr    $0xc,%eax
				while (ptr < (uint32) temp_end) {
					if (sz == size) {
						f = 1;
						break;
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801bac:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  801bb3:	85 c0                	test   %eax,%eax
  801bb5:	75 10                	jne    801bc7 <malloc+0x2be>
							/ (uint32) PAGE_SIZE)] == 0) {

						sz += PAGE_SIZE;
  801bb7:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801bbe:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
  801bc5:	eb 16                	jmp    801bdd <malloc+0x2d4>
					} else {
						sz = 0;
  801bc7:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801bce:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
						ptr_uheap = ptr;
  801bd5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801bd8:	a3 04 40 80 00       	mov    %eax,0x804004

				uint32 sz = 0;
				int f = 0;
				uint32 ptr = USER_HEAP_START;
				ptr_uheap = USER_HEAP_START;
				while (ptr < (uint32) temp_end) {
  801bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be0:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801be3:	72 ab                	jb     801b90 <malloc+0x287>
						ptr_uheap = ptr;
					}

				}

				if (f) {
  801be5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801be9:	0f 84 95 00 00 00    	je     801c84 <malloc+0x37b>

					void* ret = (void *) ptr_uheap;
  801bef:	a1 04 40 80 00       	mov    0x804004,%eax
  801bf4:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

					sys_allocateMem(ptr_uheap, size);
  801bfa:	a1 04 40 80 00       	mov    0x804004,%eax
  801bff:	83 ec 08             	sub    $0x8,%esp
  801c02:	ff 75 08             	pushl  0x8(%ebp)
  801c05:	50                   	push   %eax
  801c06:	e8 35 09 00 00       	call   802540 <sys_allocateMem>
  801c0b:	83 c4 10             	add    $0x10,%esp

					heap_size[cnt_mem].size = size;
  801c0e:	a1 40 40 80 00       	mov    0x804040,%eax
  801c13:	8b 55 08             	mov    0x8(%ebp),%edx
  801c16:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801c1d:	a1 40 40 80 00       	mov    0x804040,%eax
  801c22:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c28:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
					cnt_mem++;
  801c2f:	a1 40 40 80 00       	mov    0x804040,%eax
  801c34:	40                   	inc    %eax
  801c35:	a3 40 40 80 00       	mov    %eax,0x804040
					int i = 0;
  801c3a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

					for (; i < size; i += PAGE_SIZE)
  801c41:	eb 2e                	jmp    801c71 <malloc+0x368>
					{

						heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801c43:	a1 04 40 80 00       	mov    0x804004,%eax
  801c48:	05 00 00 00 80       	add    $0x80000000,%eax
								/ (uint32) PAGE_SIZE)] = 1;
  801c4d:	c1 e8 0c             	shr    $0xc,%eax
  801c50:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  801c57:	01 00 00 00 

						ptr_uheap += (uint32) PAGE_SIZE;
  801c5b:	a1 04 40 80 00       	mov    0x804004,%eax
  801c60:	05 00 10 00 00       	add    $0x1000,%eax
  801c65:	a3 04 40 80 00       	mov    %eax,0x804004
					heap_size[cnt_mem].size = size;
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
					cnt_mem++;
					int i = 0;

					for (; i < size; i += PAGE_SIZE)
  801c6a:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  801c71:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801c74:	3b 45 08             	cmp    0x8(%ebp),%eax
  801c77:	72 ca                	jb     801c43 <malloc+0x33a>
								/ (uint32) PAGE_SIZE)] = 1;

						ptr_uheap += (uint32) PAGE_SIZE;
					}

					return ret;
  801c79:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801c7f:	e9 25 06 00 00       	jmp    8022a9 <malloc+0x9a0>

				} else {

					return NULL;
  801c84:	b8 00 00 00 00       	mov    $0x0,%eax
  801c89:	e9 1b 06 00 00       	jmp    8022a9 <malloc+0x9a0>

		}

	}

	else if (sys_isUHeapPlacementStrategyBESTFIT()) {
  801c8e:	e8 d0 0b 00 00       	call   802863 <sys_isUHeapPlacementStrategyBESTFIT>
  801c93:	85 c0                	test   %eax,%eax
  801c95:	0f 84 ba 01 00 00    	je     801e55 <malloc+0x54c>

		size = ROUNDUP(size, PAGE_SIZE);
  801c9b:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  801ca2:	10 00 00 
  801ca5:	8b 55 08             	mov    0x8(%ebp),%edx
  801ca8:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  801cae:	01 d0                	add    %edx,%eax
  801cb0:	48                   	dec    %eax
  801cb1:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  801cb7:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801cbd:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc2:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  801cc8:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801cce:	29 d0                	sub    %edx,%eax
  801cd0:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801cd3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801cd7:	74 09                	je     801ce2 <malloc+0x3d9>
  801cd9:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801ce0:	76 0a                	jbe    801cec <malloc+0x3e3>
			return NULL;
  801ce2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce7:	e9 bd 05 00 00       	jmp    8022a9 <malloc+0x9a0>
		}
		uint32 ptr = (uint32) USER_HEAP_START;
  801cec:	c7 45 c8 00 00 00 80 	movl   $0x80000000,-0x38(%ebp)
		uint32 temp = 0;
  801cf3:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		uint32 min_sz = size_uhmem + 1;
  801cfa:	c7 45 c0 01 00 02 00 	movl   $0x20001,-0x40(%ebp)
		uint32 count = 0;
  801d01:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
		int i = 0;
  801d08:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d12:	c1 e8 0c             	shr    $0xc,%eax
  801d15:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801d1b:	e9 80 00 00 00       	jmp    801da0 <malloc+0x497>

			if (heap_mem[i] == 0) {
  801d20:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801d23:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  801d2a:	85 c0                	test   %eax,%eax
  801d2c:	75 0c                	jne    801d3a <malloc+0x431>

				count++;
  801d2e:	ff 45 bc             	incl   -0x44(%ebp)
				ptr += PAGE_SIZE;
  801d31:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801d38:	eb 2d                	jmp    801d67 <malloc+0x45e>
			} else {
				if (num_p <= count && min_sz > count) {
  801d3a:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801d40:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801d43:	77 14                	ja     801d59 <malloc+0x450>
  801d45:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801d48:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801d4b:	76 0c                	jbe    801d59 <malloc+0x450>

					min_sz = count;
  801d4d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801d50:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801d53:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801d56:	89 45 c4             	mov    %eax,-0x3c(%ebp)

				}
				count = 0;
  801d59:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
				ptr += PAGE_SIZE;
  801d60:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
			}

			if (i == size_uhmem - 1) {
  801d67:	81 7d b8 ff ff 01 00 	cmpl   $0x1ffff,-0x48(%ebp)
  801d6e:	75 2d                	jne    801d9d <malloc+0x494>

				if (num_p <= count && min_sz > count) {
  801d70:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801d76:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801d79:	77 22                	ja     801d9d <malloc+0x494>
  801d7b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801d7e:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801d81:	76 1a                	jbe    801d9d <malloc+0x494>

					min_sz = count;
  801d83:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801d86:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801d89:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801d8c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
					count = 0;
  801d8f:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
					ptr += PAGE_SIZE;
  801d96:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801d9d:	ff 45 b8             	incl   -0x48(%ebp)
  801da0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801da3:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801da8:	0f 86 72 ff ff ff    	jbe    801d20 <malloc+0x417>

			}

		}

		if (num_p > min_sz || temp == 0) {
  801dae:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801db4:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  801db7:	77 06                	ja     801dbf <malloc+0x4b6>
  801db9:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801dbd:	75 0a                	jne    801dc9 <malloc+0x4c0>
			return NULL;
  801dbf:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc4:	e9 e0 04 00 00       	jmp    8022a9 <malloc+0x9a0>

		}

		temp = temp - (PAGE_SIZE * min_sz);
  801dc9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801dcc:	c1 e0 0c             	shl    $0xc,%eax
  801dcf:	29 45 c4             	sub    %eax,-0x3c(%ebp)
		void* ret = (void*) temp;
  801dd2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801dd5:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)

		sys_allocateMem(temp, size);
  801ddb:	83 ec 08             	sub    $0x8,%esp
  801dde:	ff 75 08             	pushl  0x8(%ebp)
  801de1:	ff 75 c4             	pushl  -0x3c(%ebp)
  801de4:	e8 57 07 00 00       	call   802540 <sys_allocateMem>
  801de9:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801dec:	a1 40 40 80 00       	mov    0x804040,%eax
  801df1:	8b 55 08             	mov    0x8(%ebp),%edx
  801df4:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801dfb:	a1 40 40 80 00       	mov    0x804040,%eax
  801e00:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801e03:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
		cnt_mem++;
  801e0a:	a1 40 40 80 00       	mov    0x804040,%eax
  801e0f:	40                   	inc    %eax
  801e10:	a3 40 40 80 00       	mov    %eax,0x804040
		i = 0;
  801e15:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801e1c:	eb 24                	jmp    801e42 <malloc+0x539>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801e1e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801e21:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801e26:	c1 e8 0c             	shr    $0xc,%eax
  801e29:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  801e30:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801e34:	81 45 c4 00 10 00 00 	addl   $0x1000,-0x3c(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801e3b:	81 45 b8 00 10 00 00 	addl   $0x1000,-0x48(%ebp)
  801e42:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801e45:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e48:	72 d4                	jb     801e1e <malloc+0x515>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801e4a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801e50:	e9 54 04 00 00       	jmp    8022a9 <malloc+0x9a0>

	} else if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801e55:	e8 d8 09 00 00       	call   802832 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e5a:	85 c0                	test   %eax,%eax
  801e5c:	0f 84 88 01 00 00    	je     801fea <malloc+0x6e1>

		size = ROUNDUP(size, PAGE_SIZE);
  801e62:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  801e69:	10 00 00 
  801e6c:	8b 55 08             	mov    0x8(%ebp),%edx
  801e6f:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  801e75:	01 d0                	add    %edx,%eax
  801e77:	48                   	dec    %eax
  801e78:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  801e7e:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801e84:	ba 00 00 00 00       	mov    $0x0,%edx
  801e89:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  801e8f:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801e95:	29 d0                	sub    %edx,%eax
  801e97:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801e9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e9e:	74 09                	je     801ea9 <malloc+0x5a0>
  801ea0:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801ea7:	76 0a                	jbe    801eb3 <malloc+0x5aa>
			return NULL;
  801ea9:	b8 00 00 00 00       	mov    $0x0,%eax
  801eae:	e9 f6 03 00 00       	jmp    8022a9 <malloc+0x9a0>
		}

		uint32 ptr = (uint32) USER_HEAP_START;
  801eb3:	c7 45 b4 00 00 00 80 	movl   $0x80000000,-0x4c(%ebp)
		uint32 temp = 0;
  801eba:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
		uint32 found = 0;
  801ec1:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		uint32 count = 0;
  801ec8:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
		int i = 0;
  801ecf:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed9:	c1 e8 0c             	shr    $0xc,%eax
  801edc:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

		for (; i < size_uhmem; i++) {
  801ee2:	eb 5a                	jmp    801f3e <malloc+0x635>

			if (heap_mem[i] == 0) {
  801ee4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801ee7:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  801eee:	85 c0                	test   %eax,%eax
  801ef0:	75 0c                	jne    801efe <malloc+0x5f5>

				count++;
  801ef2:	ff 45 a8             	incl   -0x58(%ebp)
				ptr += PAGE_SIZE;
  801ef5:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
  801efc:	eb 22                	jmp    801f20 <malloc+0x617>
			} else {
				if (num_p <= count) {
  801efe:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801f04:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801f07:	77 09                	ja     801f12 <malloc+0x609>

					found = 1;
  801f09:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)

					break;
  801f10:	eb 36                	jmp    801f48 <malloc+0x63f>
				}
				count = 0;
  801f12:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
				ptr += PAGE_SIZE;
  801f19:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
			}

			if (i == size_uhmem - 1) {
  801f20:	81 7d a4 ff ff 01 00 	cmpl   $0x1ffff,-0x5c(%ebp)
  801f27:	75 12                	jne    801f3b <malloc+0x632>

				if (num_p <= count) {
  801f29:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801f2f:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801f32:	77 07                	ja     801f3b <malloc+0x632>

					found = 1;
  801f34:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
		uint32 found = 0;
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		for (; i < size_uhmem; i++) {
  801f3b:	ff 45 a4             	incl   -0x5c(%ebp)
  801f3e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801f41:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801f46:	76 9c                	jbe    801ee4 <malloc+0x5db>

			}

		}

		if (!found) {
  801f48:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  801f4c:	75 0a                	jne    801f58 <malloc+0x64f>
			return NULL;
  801f4e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f53:	e9 51 03 00 00       	jmp    8022a9 <malloc+0x9a0>

		}

		temp = ptr;
  801f58:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801f5b:	89 45 b0             	mov    %eax,-0x50(%ebp)
		temp = temp - (PAGE_SIZE * count);
  801f5e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801f61:	c1 e0 0c             	shl    $0xc,%eax
  801f64:	29 45 b0             	sub    %eax,-0x50(%ebp)
		void* ret = (void*) temp;
  801f67:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801f6a:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)

		sys_allocateMem(temp, size);
  801f70:	83 ec 08             	sub    $0x8,%esp
  801f73:	ff 75 08             	pushl  0x8(%ebp)
  801f76:	ff 75 b0             	pushl  -0x50(%ebp)
  801f79:	e8 c2 05 00 00       	call   802540 <sys_allocateMem>
  801f7e:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801f81:	a1 40 40 80 00       	mov    0x804040,%eax
  801f86:	8b 55 08             	mov    0x8(%ebp),%edx
  801f89:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801f90:	a1 40 40 80 00       	mov    0x804040,%eax
  801f95:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801f98:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
		cnt_mem++;
  801f9f:	a1 40 40 80 00       	mov    0x804040,%eax
  801fa4:	40                   	inc    %eax
  801fa5:	a3 40 40 80 00       	mov    %eax,0x804040
		i = 0;
  801faa:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801fb1:	eb 24                	jmp    801fd7 <malloc+0x6ce>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801fb3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801fb6:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801fbb:	c1 e8 0c             	shr    $0xc,%eax
  801fbe:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  801fc5:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801fc9:	81 45 b0 00 10 00 00 	addl   $0x1000,-0x50(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801fd0:	81 45 a4 00 10 00 00 	addl   $0x1000,-0x5c(%ebp)
  801fd7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801fda:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fdd:	72 d4                	jb     801fb3 <malloc+0x6aa>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801fdf:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  801fe5:	e9 bf 02 00 00       	jmp    8022a9 <malloc+0x9a0>

	}
	else if(sys_isUHeapPlacementStrategyWORSTFIT())
  801fea:	e8 d6 08 00 00       	call   8028c5 <sys_isUHeapPlacementStrategyWORSTFIT>
  801fef:	85 c0                	test   %eax,%eax
  801ff1:	0f 84 ba 01 00 00    	je     8021b1 <malloc+0x8a8>
	{
		size = ROUNDUP(size, PAGE_SIZE);
  801ff7:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  801ffe:	10 00 00 
  802001:	8b 55 08             	mov    0x8(%ebp),%edx
  802004:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  80200a:	01 d0                	add    %edx,%eax
  80200c:	48                   	dec    %eax
  80200d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  802013:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  802019:	ba 00 00 00 00       	mov    $0x0,%edx
  80201e:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  802024:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  80202a:	29 d0                	sub    %edx,%eax
  80202c:	89 45 08             	mov    %eax,0x8(%ebp)

				if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  80202f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802033:	74 09                	je     80203e <malloc+0x735>
  802035:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80203c:	76 0a                	jbe    802048 <malloc+0x73f>
					return NULL;
  80203e:	b8 00 00 00 00       	mov    $0x0,%eax
  802043:	e9 61 02 00 00       	jmp    8022a9 <malloc+0x9a0>
				}
				uint32 ptr = (uint32) USER_HEAP_START;
  802048:	c7 45 a0 00 00 00 80 	movl   $0x80000000,-0x60(%ebp)
				uint32 temp = 0;
  80204f:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
				uint32 max_sz = -1;
  802056:	c7 45 98 ff ff ff ff 	movl   $0xffffffff,-0x68(%ebp)
				uint32 count = 0;
  80205d:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
				int i = 0;
  802064:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				uint32 num_p = size / PAGE_SIZE;
  80206b:	8b 45 08             	mov    0x8(%ebp),%eax
  80206e:	c1 e8 0c             	shr    $0xc,%eax
  802071:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  802077:	e9 80 00 00 00       	jmp    8020fc <malloc+0x7f3>

					if (heap_mem[i] == 0) {
  80207c:	8b 45 90             	mov    -0x70(%ebp),%eax
  80207f:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  802086:	85 c0                	test   %eax,%eax
  802088:	75 0c                	jne    802096 <malloc+0x78d>

						count++;
  80208a:	ff 45 94             	incl   -0x6c(%ebp)
						ptr += PAGE_SIZE;
  80208d:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
  802094:	eb 2d                	jmp    8020c3 <malloc+0x7ba>
					} else {
						if (num_p <= count && max_sz < count) {
  802096:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  80209c:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  80209f:	77 14                	ja     8020b5 <malloc+0x7ac>
  8020a1:	8b 45 98             	mov    -0x68(%ebp),%eax
  8020a4:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  8020a7:	73 0c                	jae    8020b5 <malloc+0x7ac>

							max_sz = count;
  8020a9:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8020ac:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  8020af:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8020b2:	89 45 9c             	mov    %eax,-0x64(%ebp)

						}
						count = 0;
  8020b5:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
						ptr += PAGE_SIZE;
  8020bc:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
					}

					if (i == size_uhmem - 1) {
  8020c3:	81 7d 90 ff ff 01 00 	cmpl   $0x1ffff,-0x70(%ebp)
  8020ca:	75 2d                	jne    8020f9 <malloc+0x7f0>

						if (num_p <= count && max_sz > count) {
  8020cc:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  8020d2:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  8020d5:	77 22                	ja     8020f9 <malloc+0x7f0>
  8020d7:	8b 45 98             	mov    -0x68(%ebp),%eax
  8020da:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  8020dd:	76 1a                	jbe    8020f9 <malloc+0x7f0>

							max_sz = count;
  8020df:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8020e2:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  8020e5:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8020e8:	89 45 9c             	mov    %eax,-0x64(%ebp)
							count = 0;
  8020eb:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
							ptr += PAGE_SIZE;
  8020f2:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
				uint32 count = 0;
				int i = 0;
				uint32 num_p = size / PAGE_SIZE;

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  8020f9:	ff 45 90             	incl   -0x70(%ebp)
  8020fc:	8b 45 90             	mov    -0x70(%ebp),%eax
  8020ff:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  802104:	0f 86 72 ff ff ff    	jbe    80207c <malloc+0x773>

					}

				}

				if (num_p > max_sz || temp == 0) {
  80210a:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  802110:	3b 45 98             	cmp    -0x68(%ebp),%eax
  802113:	77 06                	ja     80211b <malloc+0x812>
  802115:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802119:	75 0a                	jne    802125 <malloc+0x81c>
					return NULL;
  80211b:	b8 00 00 00 00       	mov    $0x0,%eax
  802120:	e9 84 01 00 00       	jmp    8022a9 <malloc+0x9a0>

				}

				temp = temp - (PAGE_SIZE * max_sz);
  802125:	8b 45 98             	mov    -0x68(%ebp),%eax
  802128:	c1 e0 0c             	shl    $0xc,%eax
  80212b:	29 45 9c             	sub    %eax,-0x64(%ebp)
				void* ret = (void*) temp;
  80212e:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802131:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

				sys_allocateMem(temp, size);
  802137:	83 ec 08             	sub    $0x8,%esp
  80213a:	ff 75 08             	pushl  0x8(%ebp)
  80213d:	ff 75 9c             	pushl  -0x64(%ebp)
  802140:	e8 fb 03 00 00       	call   802540 <sys_allocateMem>
  802145:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  802148:	a1 40 40 80 00       	mov    0x804040,%eax
  80214d:	8b 55 08             	mov    0x8(%ebp),%edx
  802150:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
				heap_size[cnt_mem].vir = (void*) temp;
  802157:	a1 40 40 80 00       	mov    0x804040,%eax
  80215c:	8b 55 9c             	mov    -0x64(%ebp),%edx
  80215f:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
				cnt_mem++;
  802166:	a1 40 40 80 00       	mov    0x804040,%eax
  80216b:	40                   	inc    %eax
  80216c:	a3 40 40 80 00       	mov    %eax,0x804040
				i = 0;
  802171:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  802178:	eb 24                	jmp    80219e <malloc+0x895>
				{

					heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  80217a:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80217d:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  802182:	c1 e8 0c             	shr    $0xc,%eax
  802185:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  80218c:	01 00 00 00 

					temp += (uint32) PAGE_SIZE;
  802190:	81 45 9c 00 10 00 00 	addl   $0x1000,-0x64(%ebp)
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) temp;
				cnt_mem++;
				i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  802197:	81 45 90 00 10 00 00 	addl   $0x1000,-0x70(%ebp)
  80219e:	8b 45 90             	mov    -0x70(%ebp),%eax
  8021a1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021a4:	72 d4                	jb     80217a <malloc+0x871>

					temp += (uint32) PAGE_SIZE;
				}

				//cprintf("\n size = %d.........vir= %d  \n",num_p,((uint32) ret-USER_HEAP_START)/PAGE_SIZE);
				return ret;
  8021a6:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  8021ac:	e9 f8 00 00 00       	jmp    8022a9 <malloc+0x9a0>

	}
// this is to make malloc is work
	void* ret = NULL;
  8021b1:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
	size = ROUNDUP(size, PAGE_SIZE);
  8021b8:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  8021bf:	10 00 00 
  8021c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c5:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  8021cb:	01 d0                	add    %edx,%eax
  8021cd:	48                   	dec    %eax
  8021ce:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  8021d4:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  8021da:	ba 00 00 00 00       	mov    $0x0,%edx
  8021df:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  8021e5:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  8021eb:	29 d0                	sub    %edx,%eax
  8021ed:	89 45 08             	mov    %eax,0x8(%ebp)

	if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  8021f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021f4:	74 09                	je     8021ff <malloc+0x8f6>
  8021f6:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8021fd:	76 0a                	jbe    802209 <malloc+0x900>
		return NULL;
  8021ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802204:	e9 a0 00 00 00       	jmp    8022a9 <malloc+0x9a0>
	}

	if (ptr_uheap + size <= (uint32) USER_HEAP_MAX) {
  802209:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80220f:	8b 45 08             	mov    0x8(%ebp),%eax
  802212:	01 d0                	add    %edx,%eax
  802214:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802219:	0f 87 87 00 00 00    	ja     8022a6 <malloc+0x99d>

		ret = (void *) ptr_uheap;
  80221f:	a1 04 40 80 00       	mov    0x804004,%eax
  802224:	89 45 8c             	mov    %eax,-0x74(%ebp)
		sys_allocateMem(ptr_uheap, size);
  802227:	a1 04 40 80 00       	mov    0x804004,%eax
  80222c:	83 ec 08             	sub    $0x8,%esp
  80222f:	ff 75 08             	pushl  0x8(%ebp)
  802232:	50                   	push   %eax
  802233:	e8 08 03 00 00       	call   802540 <sys_allocateMem>
  802238:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  80223b:	a1 40 40 80 00       	mov    0x804040,%eax
  802240:	8b 55 08             	mov    0x8(%ebp),%edx
  802243:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
  80224a:	a1 40 40 80 00       	mov    0x804040,%eax
  80224f:	8b 15 04 40 80 00    	mov    0x804004,%edx
  802255:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
		cnt_mem++;
  80225c:	a1 40 40 80 00       	mov    0x804040,%eax
  802261:	40                   	inc    %eax
  802262:	a3 40 40 80 00       	mov    %eax,0x804040
		int i = 0;
  802267:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)

		for (; i < size; i += PAGE_SIZE)
  80226e:	eb 2e                	jmp    80229e <malloc+0x995>
		{

			heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  802270:	a1 04 40 80 00       	mov    0x804004,%eax
  802275:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  80227a:	c1 e8 0c             	shr    $0xc,%eax
  80227d:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  802284:	01 00 00 00 

			ptr_uheap += (uint32) PAGE_SIZE;
  802288:	a1 04 40 80 00       	mov    0x804004,%eax
  80228d:	05 00 10 00 00       	add    $0x1000,%eax
  802292:	a3 04 40 80 00       	mov    %eax,0x804004
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
		cnt_mem++;
		int i = 0;

		for (; i < size; i += PAGE_SIZE)
  802297:	81 45 88 00 10 00 00 	addl   $0x1000,-0x78(%ebp)
  80229e:	8b 45 88             	mov    -0x78(%ebp),%eax
  8022a1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022a4:	72 ca                	jb     802270 <malloc+0x967>
					/ (uint32) PAGE_SIZE)] = 1;

			ptr_uheap += (uint32) PAGE_SIZE;
		}
	}
	return ret;
  8022a6:	8b 45 8c             	mov    -0x74(%ebp),%eax

	//TODO: [PROJECT 2016 - BONUS2] Apply FIRST FIT and WORST FIT policies

//return 0;

}
  8022a9:	c9                   	leave  
  8022aa:	c3                   	ret    

008022ab <free>:
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address) {
  8022ab:	55                   	push   %ebp
  8022ac:	89 e5                	mov    %esp,%ebp
  8022ae:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
  8022b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; inx < cnt_mem; inx++) {
  8022b8:	e9 c1 00 00 00       	jmp    80237e <free+0xd3>
		if (heap_size[inx].vir == virtual_address) {
  8022bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c0:	8b 04 c5 60 40 88 00 	mov    0x884060(,%eax,8),%eax
  8022c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022ca:	0f 85 ab 00 00 00    	jne    80237b <free+0xd0>

			if (heap_size[inx].size == 0) {
  8022d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d3:	8b 04 c5 64 40 88 00 	mov    0x884064(,%eax,8),%eax
  8022da:	85 c0                	test   %eax,%eax
  8022dc:	75 21                	jne    8022ff <free+0x54>
				heap_size[inx].size = 0;
  8022de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e1:	c7 04 c5 64 40 88 00 	movl   $0x0,0x884064(,%eax,8)
  8022e8:	00 00 00 00 
				heap_size[inx].vir = NULL;
  8022ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ef:	c7 04 c5 60 40 88 00 	movl   $0x0,0x884060(,%eax,8)
  8022f6:	00 00 00 00 
				return;
  8022fa:	e9 8d 00 00 00       	jmp    80238c <free+0xe1>

			}

			sys_freeMem((uint32) virtual_address, heap_size[inx].size);
  8022ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802302:	8b 14 c5 64 40 88 00 	mov    0x884064(,%eax,8),%edx
  802309:	8b 45 08             	mov    0x8(%ebp),%eax
  80230c:	83 ec 08             	sub    $0x8,%esp
  80230f:	52                   	push   %edx
  802310:	50                   	push   %eax
  802311:	e8 0e 02 00 00       	call   802524 <sys_freeMem>
  802316:	83 c4 10             	add    $0x10,%esp

			int i = 0;
  802319:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
  802320:	8b 45 08             	mov    0x8(%ebp),%eax
  802323:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  802326:	eb 24                	jmp    80234c <free+0xa1>
			{
				heap_mem[(int) (((uint32) va - USER_HEAP_START) / PAGE_SIZE)] =
  802328:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80232b:	05 00 00 00 80       	add    $0x80000000,%eax
  802330:	c1 e8 0c             	shr    $0xc,%eax
  802333:	c7 04 85 60 40 80 00 	movl   $0x0,0x804060(,%eax,4)
  80233a:	00 00 00 00 
						0;

				va += PAGE_SIZE;
  80233e:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
			sys_freeMem((uint32) virtual_address, heap_size[inx].size);

			int i = 0;
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  802345:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  80234c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234f:	8b 14 c5 64 40 88 00 	mov    0x884064(,%eax,8),%edx
  802356:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802359:	39 c2                	cmp    %eax,%edx
  80235b:	77 cb                	ja     802328 <free+0x7d>

				va += PAGE_SIZE;

			}

			heap_size[inx].size = 0;
  80235d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802360:	c7 04 c5 64 40 88 00 	movl   $0x0,0x884064(,%eax,8)
  802367:	00 00 00 00 
			heap_size[inx].vir = NULL;
  80236b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236e:	c7 04 c5 60 40 88 00 	movl   $0x0,0x884060(,%eax,8)
  802375:	00 00 00 00 
			break;
  802379:	eb 11                	jmp    80238c <free+0xe1>
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
	for (; inx < cnt_mem; inx++) {
  80237b:	ff 45 f4             	incl   -0xc(%ebp)
  80237e:	a1 40 40 80 00       	mov    0x804040,%eax
  802383:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  802386:	0f 8c 31 ff ff ff    	jl     8022bd <free+0x12>
	}

	//get the size of the given allocation using its address
	//you need to call sys_freeMem()

}
  80238c:	c9                   	leave  
  80238d:	c3                   	ret    

0080238e <realloc>:
//  Hint: you may need to use the sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size) {
  80238e:	55                   	push   %ebp
  80238f:	89 e5                	mov    %esp,%ebp
  802391:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2016 - BONUS4] realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802394:	83 ec 04             	sub    $0x4,%esp
  802397:	68 84 31 80 00       	push   $0x803184
  80239c:	68 1c 02 00 00       	push   $0x21c
  8023a1:	68 aa 31 80 00       	push   $0x8031aa
  8023a6:	e8 aa e4 ff ff       	call   800855 <_panic>

008023ab <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8023ab:	55                   	push   %ebp
  8023ac:	89 e5                	mov    %esp,%ebp
  8023ae:	57                   	push   %edi
  8023af:	56                   	push   %esi
  8023b0:	53                   	push   %ebx
  8023b1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8023b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023bd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023c0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8023c3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8023c6:	cd 30                	int    $0x30
  8023c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8023cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8023ce:	83 c4 10             	add    $0x10,%esp
  8023d1:	5b                   	pop    %ebx
  8023d2:	5e                   	pop    %esi
  8023d3:	5f                   	pop    %edi
  8023d4:	5d                   	pop    %ebp
  8023d5:	c3                   	ret    

008023d6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  8023d6:	55                   	push   %ebp
  8023d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  8023d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dc:	6a 00                	push   $0x0
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 00                	push   $0x0
  8023e2:	ff 75 0c             	pushl  0xc(%ebp)
  8023e5:	50                   	push   %eax
  8023e6:	6a 00                	push   $0x0
  8023e8:	e8 be ff ff ff       	call   8023ab <syscall>
  8023ed:	83 c4 18             	add    $0x18,%esp
}
  8023f0:	90                   	nop
  8023f1:	c9                   	leave  
  8023f2:	c3                   	ret    

008023f3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8023f3:	55                   	push   %ebp
  8023f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8023f6:	6a 00                	push   $0x0
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	6a 01                	push   $0x1
  802402:	e8 a4 ff ff ff       	call   8023ab <syscall>
  802407:	83 c4 18             	add    $0x18,%esp
}
  80240a:	c9                   	leave  
  80240b:	c3                   	ret    

0080240c <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  80240c:	55                   	push   %ebp
  80240d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80240f:	8b 45 08             	mov    0x8(%ebp),%eax
  802412:	6a 00                	push   $0x0
  802414:	6a 00                	push   $0x0
  802416:	6a 00                	push   $0x0
  802418:	6a 00                	push   $0x0
  80241a:	50                   	push   %eax
  80241b:	6a 03                	push   $0x3
  80241d:	e8 89 ff ff ff       	call   8023ab <syscall>
  802422:	83 c4 18             	add    $0x18,%esp
}
  802425:	c9                   	leave  
  802426:	c3                   	ret    

00802427 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802427:	55                   	push   %ebp
  802428:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80242a:	6a 00                	push   $0x0
  80242c:	6a 00                	push   $0x0
  80242e:	6a 00                	push   $0x0
  802430:	6a 00                	push   $0x0
  802432:	6a 00                	push   $0x0
  802434:	6a 02                	push   $0x2
  802436:	e8 70 ff ff ff       	call   8023ab <syscall>
  80243b:	83 c4 18             	add    $0x18,%esp
}
  80243e:	c9                   	leave  
  80243f:	c3                   	ret    

00802440 <sys_env_exit>:

void sys_env_exit(void)
{
  802440:	55                   	push   %ebp
  802441:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  802443:	6a 00                	push   $0x0
  802445:	6a 00                	push   $0x0
  802447:	6a 00                	push   $0x0
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	6a 04                	push   $0x4
  80244f:	e8 57 ff ff ff       	call   8023ab <syscall>
  802454:	83 c4 18             	add    $0x18,%esp
}
  802457:	90                   	nop
  802458:	c9                   	leave  
  802459:	c3                   	ret    

0080245a <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80245d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802460:	8b 45 08             	mov    0x8(%ebp),%eax
  802463:	6a 00                	push   $0x0
  802465:	6a 00                	push   $0x0
  802467:	6a 00                	push   $0x0
  802469:	52                   	push   %edx
  80246a:	50                   	push   %eax
  80246b:	6a 05                	push   $0x5
  80246d:	e8 39 ff ff ff       	call   8023ab <syscall>
  802472:	83 c4 18             	add    $0x18,%esp
}
  802475:	c9                   	leave  
  802476:	c3                   	ret    

00802477 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802477:	55                   	push   %ebp
  802478:	89 e5                	mov    %esp,%ebp
  80247a:	56                   	push   %esi
  80247b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80247c:	8b 75 18             	mov    0x18(%ebp),%esi
  80247f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802482:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802485:	8b 55 0c             	mov    0xc(%ebp),%edx
  802488:	8b 45 08             	mov    0x8(%ebp),%eax
  80248b:	56                   	push   %esi
  80248c:	53                   	push   %ebx
  80248d:	51                   	push   %ecx
  80248e:	52                   	push   %edx
  80248f:	50                   	push   %eax
  802490:	6a 06                	push   $0x6
  802492:	e8 14 ff ff ff       	call   8023ab <syscall>
  802497:	83 c4 18             	add    $0x18,%esp
}
  80249a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80249d:	5b                   	pop    %ebx
  80249e:	5e                   	pop    %esi
  80249f:	5d                   	pop    %ebp
  8024a0:	c3                   	ret    

008024a1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8024a1:	55                   	push   %ebp
  8024a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8024a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024aa:	6a 00                	push   $0x0
  8024ac:	6a 00                	push   $0x0
  8024ae:	6a 00                	push   $0x0
  8024b0:	52                   	push   %edx
  8024b1:	50                   	push   %eax
  8024b2:	6a 07                	push   $0x7
  8024b4:	e8 f2 fe ff ff       	call   8023ab <syscall>
  8024b9:	83 c4 18             	add    $0x18,%esp
}
  8024bc:	c9                   	leave  
  8024bd:	c3                   	ret    

008024be <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8024be:	55                   	push   %ebp
  8024bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8024c1:	6a 00                	push   $0x0
  8024c3:	6a 00                	push   $0x0
  8024c5:	6a 00                	push   $0x0
  8024c7:	ff 75 0c             	pushl  0xc(%ebp)
  8024ca:	ff 75 08             	pushl  0x8(%ebp)
  8024cd:	6a 08                	push   $0x8
  8024cf:	e8 d7 fe ff ff       	call   8023ab <syscall>
  8024d4:	83 c4 18             	add    $0x18,%esp
}
  8024d7:	c9                   	leave  
  8024d8:	c3                   	ret    

008024d9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8024d9:	55                   	push   %ebp
  8024da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8024dc:	6a 00                	push   $0x0
  8024de:	6a 00                	push   $0x0
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 00                	push   $0x0
  8024e6:	6a 09                	push   $0x9
  8024e8:	e8 be fe ff ff       	call   8023ab <syscall>
  8024ed:	83 c4 18             	add    $0x18,%esp
}
  8024f0:	c9                   	leave  
  8024f1:	c3                   	ret    

008024f2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8024f2:	55                   	push   %ebp
  8024f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8024f5:	6a 00                	push   $0x0
  8024f7:	6a 00                	push   $0x0
  8024f9:	6a 00                	push   $0x0
  8024fb:	6a 00                	push   $0x0
  8024fd:	6a 00                	push   $0x0
  8024ff:	6a 0a                	push   $0xa
  802501:	e8 a5 fe ff ff       	call   8023ab <syscall>
  802506:	83 c4 18             	add    $0x18,%esp
}
  802509:	c9                   	leave  
  80250a:	c3                   	ret    

0080250b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80250b:	55                   	push   %ebp
  80250c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80250e:	6a 00                	push   $0x0
  802510:	6a 00                	push   $0x0
  802512:	6a 00                	push   $0x0
  802514:	6a 00                	push   $0x0
  802516:	6a 00                	push   $0x0
  802518:	6a 0b                	push   $0xb
  80251a:	e8 8c fe ff ff       	call   8023ab <syscall>
  80251f:	83 c4 18             	add    $0x18,%esp
}
  802522:	c9                   	leave  
  802523:	c3                   	ret    

00802524 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  802524:	55                   	push   %ebp
  802525:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  802527:	6a 00                	push   $0x0
  802529:	6a 00                	push   $0x0
  80252b:	6a 00                	push   $0x0
  80252d:	ff 75 0c             	pushl  0xc(%ebp)
  802530:	ff 75 08             	pushl  0x8(%ebp)
  802533:	6a 0d                	push   $0xd
  802535:	e8 71 fe ff ff       	call   8023ab <syscall>
  80253a:	83 c4 18             	add    $0x18,%esp
	return;
  80253d:	90                   	nop
}
  80253e:	c9                   	leave  
  80253f:	c3                   	ret    

00802540 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  802540:	55                   	push   %ebp
  802541:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  802543:	6a 00                	push   $0x0
  802545:	6a 00                	push   $0x0
  802547:	6a 00                	push   $0x0
  802549:	ff 75 0c             	pushl  0xc(%ebp)
  80254c:	ff 75 08             	pushl  0x8(%ebp)
  80254f:	6a 0e                	push   $0xe
  802551:	e8 55 fe ff ff       	call   8023ab <syscall>
  802556:	83 c4 18             	add    $0x18,%esp
	return ;
  802559:	90                   	nop
}
  80255a:	c9                   	leave  
  80255b:	c3                   	ret    

0080255c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80255c:	55                   	push   %ebp
  80255d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80255f:	6a 00                	push   $0x0
  802561:	6a 00                	push   $0x0
  802563:	6a 00                	push   $0x0
  802565:	6a 00                	push   $0x0
  802567:	6a 00                	push   $0x0
  802569:	6a 0c                	push   $0xc
  80256b:	e8 3b fe ff ff       	call   8023ab <syscall>
  802570:	83 c4 18             	add    $0x18,%esp
}
  802573:	c9                   	leave  
  802574:	c3                   	ret    

00802575 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802575:	55                   	push   %ebp
  802576:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802578:	6a 00                	push   $0x0
  80257a:	6a 00                	push   $0x0
  80257c:	6a 00                	push   $0x0
  80257e:	6a 00                	push   $0x0
  802580:	6a 00                	push   $0x0
  802582:	6a 10                	push   $0x10
  802584:	e8 22 fe ff ff       	call   8023ab <syscall>
  802589:	83 c4 18             	add    $0x18,%esp
}
  80258c:	90                   	nop
  80258d:	c9                   	leave  
  80258e:	c3                   	ret    

0080258f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80258f:	55                   	push   %ebp
  802590:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802592:	6a 00                	push   $0x0
  802594:	6a 00                	push   $0x0
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	6a 00                	push   $0x0
  80259c:	6a 11                	push   $0x11
  80259e:	e8 08 fe ff ff       	call   8023ab <syscall>
  8025a3:	83 c4 18             	add    $0x18,%esp
}
  8025a6:	90                   	nop
  8025a7:	c9                   	leave  
  8025a8:	c3                   	ret    

008025a9 <sys_cputc>:


void
sys_cputc(const char c)
{
  8025a9:	55                   	push   %ebp
  8025aa:	89 e5                	mov    %esp,%ebp
  8025ac:	83 ec 04             	sub    $0x4,%esp
  8025af:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8025b5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8025b9:	6a 00                	push   $0x0
  8025bb:	6a 00                	push   $0x0
  8025bd:	6a 00                	push   $0x0
  8025bf:	6a 00                	push   $0x0
  8025c1:	50                   	push   %eax
  8025c2:	6a 12                	push   $0x12
  8025c4:	e8 e2 fd ff ff       	call   8023ab <syscall>
  8025c9:	83 c4 18             	add    $0x18,%esp
}
  8025cc:	90                   	nop
  8025cd:	c9                   	leave  
  8025ce:	c3                   	ret    

008025cf <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8025cf:	55                   	push   %ebp
  8025d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8025d2:	6a 00                	push   $0x0
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 00                	push   $0x0
  8025d8:	6a 00                	push   $0x0
  8025da:	6a 00                	push   $0x0
  8025dc:	6a 13                	push   $0x13
  8025de:	e8 c8 fd ff ff       	call   8023ab <syscall>
  8025e3:	83 c4 18             	add    $0x18,%esp
}
  8025e6:	90                   	nop
  8025e7:	c9                   	leave  
  8025e8:	c3                   	ret    

008025e9 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8025e9:	55                   	push   %ebp
  8025ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8025ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ef:	6a 00                	push   $0x0
  8025f1:	6a 00                	push   $0x0
  8025f3:	6a 00                	push   $0x0
  8025f5:	ff 75 0c             	pushl  0xc(%ebp)
  8025f8:	50                   	push   %eax
  8025f9:	6a 14                	push   $0x14
  8025fb:	e8 ab fd ff ff       	call   8023ab <syscall>
  802600:	83 c4 18             	add    $0x18,%esp
}
  802603:	c9                   	leave  
  802604:	c3                   	ret    

00802605 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  802605:	55                   	push   %ebp
  802606:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  802608:	8b 45 08             	mov    0x8(%ebp),%eax
  80260b:	6a 00                	push   $0x0
  80260d:	6a 00                	push   $0x0
  80260f:	6a 00                	push   $0x0
  802611:	6a 00                	push   $0x0
  802613:	50                   	push   %eax
  802614:	6a 17                	push   $0x17
  802616:	e8 90 fd ff ff       	call   8023ab <syscall>
  80261b:	83 c4 18             	add    $0x18,%esp
}
  80261e:	c9                   	leave  
  80261f:	c3                   	ret    

00802620 <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  802620:	55                   	push   %ebp
  802621:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  802623:	8b 45 08             	mov    0x8(%ebp),%eax
  802626:	6a 00                	push   $0x0
  802628:	6a 00                	push   $0x0
  80262a:	6a 00                	push   $0x0
  80262c:	6a 00                	push   $0x0
  80262e:	50                   	push   %eax
  80262f:	6a 15                	push   $0x15
  802631:	e8 75 fd ff ff       	call   8023ab <syscall>
  802636:	83 c4 18             	add    $0x18,%esp
}
  802639:	90                   	nop
  80263a:	c9                   	leave  
  80263b:	c3                   	ret    

0080263c <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  80263c:	55                   	push   %ebp
  80263d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  80263f:	8b 45 08             	mov    0x8(%ebp),%eax
  802642:	6a 00                	push   $0x0
  802644:	6a 00                	push   $0x0
  802646:	6a 00                	push   $0x0
  802648:	6a 00                	push   $0x0
  80264a:	50                   	push   %eax
  80264b:	6a 16                	push   $0x16
  80264d:	e8 59 fd ff ff       	call   8023ab <syscall>
  802652:	83 c4 18             	add    $0x18,%esp
}
  802655:	90                   	nop
  802656:	c9                   	leave  
  802657:	c3                   	ret    

00802658 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  802658:	55                   	push   %ebp
  802659:	89 e5                	mov    %esp,%ebp
  80265b:	83 ec 04             	sub    $0x4,%esp
  80265e:	8b 45 10             	mov    0x10(%ebp),%eax
  802661:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  802664:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802667:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80266b:	8b 45 08             	mov    0x8(%ebp),%eax
  80266e:	6a 00                	push   $0x0
  802670:	51                   	push   %ecx
  802671:	52                   	push   %edx
  802672:	ff 75 0c             	pushl  0xc(%ebp)
  802675:	50                   	push   %eax
  802676:	6a 18                	push   $0x18
  802678:	e8 2e fd ff ff       	call   8023ab <syscall>
  80267d:	83 c4 18             	add    $0x18,%esp
}
  802680:	c9                   	leave  
  802681:	c3                   	ret    

00802682 <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  802682:	55                   	push   %ebp
  802683:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  802685:	8b 55 0c             	mov    0xc(%ebp),%edx
  802688:	8b 45 08             	mov    0x8(%ebp),%eax
  80268b:	6a 00                	push   $0x0
  80268d:	6a 00                	push   $0x0
  80268f:	6a 00                	push   $0x0
  802691:	52                   	push   %edx
  802692:	50                   	push   %eax
  802693:	6a 19                	push   $0x19
  802695:	e8 11 fd ff ff       	call   8023ab <syscall>
  80269a:	83 c4 18             	add    $0x18,%esp
}
  80269d:	c9                   	leave  
  80269e:	c3                   	ret    

0080269f <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  80269f:	55                   	push   %ebp
  8026a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  8026a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a5:	6a 00                	push   $0x0
  8026a7:	6a 00                	push   $0x0
  8026a9:	6a 00                	push   $0x0
  8026ab:	6a 00                	push   $0x0
  8026ad:	50                   	push   %eax
  8026ae:	6a 1a                	push   $0x1a
  8026b0:	e8 f6 fc ff ff       	call   8023ab <syscall>
  8026b5:	83 c4 18             	add    $0x18,%esp
}
  8026b8:	c9                   	leave  
  8026b9:	c3                   	ret    

008026ba <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  8026ba:	55                   	push   %ebp
  8026bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  8026bd:	6a 00                	push   $0x0
  8026bf:	6a 00                	push   $0x0
  8026c1:	6a 00                	push   $0x0
  8026c3:	6a 00                	push   $0x0
  8026c5:	6a 00                	push   $0x0
  8026c7:	6a 1b                	push   $0x1b
  8026c9:	e8 dd fc ff ff       	call   8023ab <syscall>
  8026ce:	83 c4 18             	add    $0x18,%esp
}
  8026d1:	c9                   	leave  
  8026d2:	c3                   	ret    

008026d3 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8026d3:	55                   	push   %ebp
  8026d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8026d6:	6a 00                	push   $0x0
  8026d8:	6a 00                	push   $0x0
  8026da:	6a 00                	push   $0x0
  8026dc:	6a 00                	push   $0x0
  8026de:	6a 00                	push   $0x0
  8026e0:	6a 1c                	push   $0x1c
  8026e2:	e8 c4 fc ff ff       	call   8023ab <syscall>
  8026e7:	83 c4 18             	add    $0x18,%esp
}
  8026ea:	c9                   	leave  
  8026eb:	c3                   	ret    

008026ec <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  8026ec:	55                   	push   %ebp
  8026ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  8026ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f2:	6a 00                	push   $0x0
  8026f4:	6a 00                	push   $0x0
  8026f6:	6a 00                	push   $0x0
  8026f8:	ff 75 0c             	pushl  0xc(%ebp)
  8026fb:	50                   	push   %eax
  8026fc:	6a 1d                	push   $0x1d
  8026fe:	e8 a8 fc ff ff       	call   8023ab <syscall>
  802703:	83 c4 18             	add    $0x18,%esp
}
  802706:	c9                   	leave  
  802707:	c3                   	ret    

00802708 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802708:	55                   	push   %ebp
  802709:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80270b:	8b 45 08             	mov    0x8(%ebp),%eax
  80270e:	6a 00                	push   $0x0
  802710:	6a 00                	push   $0x0
  802712:	6a 00                	push   $0x0
  802714:	6a 00                	push   $0x0
  802716:	50                   	push   %eax
  802717:	6a 1e                	push   $0x1e
  802719:	e8 8d fc ff ff       	call   8023ab <syscall>
  80271e:	83 c4 18             	add    $0x18,%esp
}
  802721:	90                   	nop
  802722:	c9                   	leave  
  802723:	c3                   	ret    

00802724 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  802724:	55                   	push   %ebp
  802725:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  802727:	8b 45 08             	mov    0x8(%ebp),%eax
  80272a:	6a 00                	push   $0x0
  80272c:	6a 00                	push   $0x0
  80272e:	6a 00                	push   $0x0
  802730:	6a 00                	push   $0x0
  802732:	50                   	push   %eax
  802733:	6a 1f                	push   $0x1f
  802735:	e8 71 fc ff ff       	call   8023ab <syscall>
  80273a:	83 c4 18             	add    $0x18,%esp
}
  80273d:	90                   	nop
  80273e:	c9                   	leave  
  80273f:	c3                   	ret    

00802740 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  802740:	55                   	push   %ebp
  802741:	89 e5                	mov    %esp,%ebp
  802743:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802746:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802749:	8d 50 04             	lea    0x4(%eax),%edx
  80274c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80274f:	6a 00                	push   $0x0
  802751:	6a 00                	push   $0x0
  802753:	6a 00                	push   $0x0
  802755:	52                   	push   %edx
  802756:	50                   	push   %eax
  802757:	6a 20                	push   $0x20
  802759:	e8 4d fc ff ff       	call   8023ab <syscall>
  80275e:	83 c4 18             	add    $0x18,%esp
	return result;
  802761:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802764:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802767:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80276a:	89 01                	mov    %eax,(%ecx)
  80276c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80276f:	8b 45 08             	mov    0x8(%ebp),%eax
  802772:	c9                   	leave  
  802773:	c2 04 00             	ret    $0x4

00802776 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802776:	55                   	push   %ebp
  802777:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802779:	6a 00                	push   $0x0
  80277b:	6a 00                	push   $0x0
  80277d:	ff 75 10             	pushl  0x10(%ebp)
  802780:	ff 75 0c             	pushl  0xc(%ebp)
  802783:	ff 75 08             	pushl  0x8(%ebp)
  802786:	6a 0f                	push   $0xf
  802788:	e8 1e fc ff ff       	call   8023ab <syscall>
  80278d:	83 c4 18             	add    $0x18,%esp
	return ;
  802790:	90                   	nop
}
  802791:	c9                   	leave  
  802792:	c3                   	ret    

00802793 <sys_rcr2>:
uint32 sys_rcr2()
{
  802793:	55                   	push   %ebp
  802794:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802796:	6a 00                	push   $0x0
  802798:	6a 00                	push   $0x0
  80279a:	6a 00                	push   $0x0
  80279c:	6a 00                	push   $0x0
  80279e:	6a 00                	push   $0x0
  8027a0:	6a 21                	push   $0x21
  8027a2:	e8 04 fc ff ff       	call   8023ab <syscall>
  8027a7:	83 c4 18             	add    $0x18,%esp
}
  8027aa:	c9                   	leave  
  8027ab:	c3                   	ret    

008027ac <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8027ac:	55                   	push   %ebp
  8027ad:	89 e5                	mov    %esp,%ebp
  8027af:	83 ec 04             	sub    $0x4,%esp
  8027b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8027b8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8027bc:	6a 00                	push   $0x0
  8027be:	6a 00                	push   $0x0
  8027c0:	6a 00                	push   $0x0
  8027c2:	6a 00                	push   $0x0
  8027c4:	50                   	push   %eax
  8027c5:	6a 22                	push   $0x22
  8027c7:	e8 df fb ff ff       	call   8023ab <syscall>
  8027cc:	83 c4 18             	add    $0x18,%esp
	return ;
  8027cf:	90                   	nop
}
  8027d0:	c9                   	leave  
  8027d1:	c3                   	ret    

008027d2 <rsttst>:
void rsttst()
{
  8027d2:	55                   	push   %ebp
  8027d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8027d5:	6a 00                	push   $0x0
  8027d7:	6a 00                	push   $0x0
  8027d9:	6a 00                	push   $0x0
  8027db:	6a 00                	push   $0x0
  8027dd:	6a 00                	push   $0x0
  8027df:	6a 24                	push   $0x24
  8027e1:	e8 c5 fb ff ff       	call   8023ab <syscall>
  8027e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8027e9:	90                   	nop
}
  8027ea:	c9                   	leave  
  8027eb:	c3                   	ret    

008027ec <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8027ec:	55                   	push   %ebp
  8027ed:	89 e5                	mov    %esp,%ebp
  8027ef:	83 ec 04             	sub    $0x4,%esp
  8027f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8027f5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8027f8:	8b 55 18             	mov    0x18(%ebp),%edx
  8027fb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8027ff:	52                   	push   %edx
  802800:	50                   	push   %eax
  802801:	ff 75 10             	pushl  0x10(%ebp)
  802804:	ff 75 0c             	pushl  0xc(%ebp)
  802807:	ff 75 08             	pushl  0x8(%ebp)
  80280a:	6a 23                	push   $0x23
  80280c:	e8 9a fb ff ff       	call   8023ab <syscall>
  802811:	83 c4 18             	add    $0x18,%esp
	return ;
  802814:	90                   	nop
}
  802815:	c9                   	leave  
  802816:	c3                   	ret    

00802817 <chktst>:
void chktst(uint32 n)
{
  802817:	55                   	push   %ebp
  802818:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80281a:	6a 00                	push   $0x0
  80281c:	6a 00                	push   $0x0
  80281e:	6a 00                	push   $0x0
  802820:	6a 00                	push   $0x0
  802822:	ff 75 08             	pushl  0x8(%ebp)
  802825:	6a 25                	push   $0x25
  802827:	e8 7f fb ff ff       	call   8023ab <syscall>
  80282c:	83 c4 18             	add    $0x18,%esp
	return ;
  80282f:	90                   	nop
}
  802830:	c9                   	leave  
  802831:	c3                   	ret    

00802832 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802832:	55                   	push   %ebp
  802833:	89 e5                	mov    %esp,%ebp
  802835:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802838:	6a 00                	push   $0x0
  80283a:	6a 00                	push   $0x0
  80283c:	6a 00                	push   $0x0
  80283e:	6a 00                	push   $0x0
  802840:	6a 00                	push   $0x0
  802842:	6a 26                	push   $0x26
  802844:	e8 62 fb ff ff       	call   8023ab <syscall>
  802849:	83 c4 18             	add    $0x18,%esp
  80284c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80284f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802853:	75 07                	jne    80285c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802855:	b8 01 00 00 00       	mov    $0x1,%eax
  80285a:	eb 05                	jmp    802861 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80285c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802861:	c9                   	leave  
  802862:	c3                   	ret    

00802863 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802863:	55                   	push   %ebp
  802864:	89 e5                	mov    %esp,%ebp
  802866:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802869:	6a 00                	push   $0x0
  80286b:	6a 00                	push   $0x0
  80286d:	6a 00                	push   $0x0
  80286f:	6a 00                	push   $0x0
  802871:	6a 00                	push   $0x0
  802873:	6a 26                	push   $0x26
  802875:	e8 31 fb ff ff       	call   8023ab <syscall>
  80287a:	83 c4 18             	add    $0x18,%esp
  80287d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802880:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802884:	75 07                	jne    80288d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802886:	b8 01 00 00 00       	mov    $0x1,%eax
  80288b:	eb 05                	jmp    802892 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80288d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802892:	c9                   	leave  
  802893:	c3                   	ret    

00802894 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802894:	55                   	push   %ebp
  802895:	89 e5                	mov    %esp,%ebp
  802897:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80289a:	6a 00                	push   $0x0
  80289c:	6a 00                	push   $0x0
  80289e:	6a 00                	push   $0x0
  8028a0:	6a 00                	push   $0x0
  8028a2:	6a 00                	push   $0x0
  8028a4:	6a 26                	push   $0x26
  8028a6:	e8 00 fb ff ff       	call   8023ab <syscall>
  8028ab:	83 c4 18             	add    $0x18,%esp
  8028ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8028b1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8028b5:	75 07                	jne    8028be <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8028b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8028bc:	eb 05                	jmp    8028c3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8028be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028c3:	c9                   	leave  
  8028c4:	c3                   	ret    

008028c5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8028c5:	55                   	push   %ebp
  8028c6:	89 e5                	mov    %esp,%ebp
  8028c8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028cb:	6a 00                	push   $0x0
  8028cd:	6a 00                	push   $0x0
  8028cf:	6a 00                	push   $0x0
  8028d1:	6a 00                	push   $0x0
  8028d3:	6a 00                	push   $0x0
  8028d5:	6a 26                	push   $0x26
  8028d7:	e8 cf fa ff ff       	call   8023ab <syscall>
  8028dc:	83 c4 18             	add    $0x18,%esp
  8028df:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8028e2:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8028e6:	75 07                	jne    8028ef <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8028e8:	b8 01 00 00 00       	mov    $0x1,%eax
  8028ed:	eb 05                	jmp    8028f4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8028ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028f4:	c9                   	leave  
  8028f5:	c3                   	ret    

008028f6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8028f6:	55                   	push   %ebp
  8028f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8028f9:	6a 00                	push   $0x0
  8028fb:	6a 00                	push   $0x0
  8028fd:	6a 00                	push   $0x0
  8028ff:	6a 00                	push   $0x0
  802901:	ff 75 08             	pushl  0x8(%ebp)
  802904:	6a 27                	push   $0x27
  802906:	e8 a0 fa ff ff       	call   8023ab <syscall>
  80290b:	83 c4 18             	add    $0x18,%esp
	return ;
  80290e:	90                   	nop
}
  80290f:	c9                   	leave  
  802910:	c3                   	ret    
  802911:	66 90                	xchg   %ax,%ax
  802913:	90                   	nop

00802914 <__udivdi3>:
  802914:	55                   	push   %ebp
  802915:	57                   	push   %edi
  802916:	56                   	push   %esi
  802917:	53                   	push   %ebx
  802918:	83 ec 1c             	sub    $0x1c,%esp
  80291b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80291f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802923:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802927:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80292b:	89 ca                	mov    %ecx,%edx
  80292d:	89 f8                	mov    %edi,%eax
  80292f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802933:	85 f6                	test   %esi,%esi
  802935:	75 2d                	jne    802964 <__udivdi3+0x50>
  802937:	39 cf                	cmp    %ecx,%edi
  802939:	77 65                	ja     8029a0 <__udivdi3+0x8c>
  80293b:	89 fd                	mov    %edi,%ebp
  80293d:	85 ff                	test   %edi,%edi
  80293f:	75 0b                	jne    80294c <__udivdi3+0x38>
  802941:	b8 01 00 00 00       	mov    $0x1,%eax
  802946:	31 d2                	xor    %edx,%edx
  802948:	f7 f7                	div    %edi
  80294a:	89 c5                	mov    %eax,%ebp
  80294c:	31 d2                	xor    %edx,%edx
  80294e:	89 c8                	mov    %ecx,%eax
  802950:	f7 f5                	div    %ebp
  802952:	89 c1                	mov    %eax,%ecx
  802954:	89 d8                	mov    %ebx,%eax
  802956:	f7 f5                	div    %ebp
  802958:	89 cf                	mov    %ecx,%edi
  80295a:	89 fa                	mov    %edi,%edx
  80295c:	83 c4 1c             	add    $0x1c,%esp
  80295f:	5b                   	pop    %ebx
  802960:	5e                   	pop    %esi
  802961:	5f                   	pop    %edi
  802962:	5d                   	pop    %ebp
  802963:	c3                   	ret    
  802964:	39 ce                	cmp    %ecx,%esi
  802966:	77 28                	ja     802990 <__udivdi3+0x7c>
  802968:	0f bd fe             	bsr    %esi,%edi
  80296b:	83 f7 1f             	xor    $0x1f,%edi
  80296e:	75 40                	jne    8029b0 <__udivdi3+0x9c>
  802970:	39 ce                	cmp    %ecx,%esi
  802972:	72 0a                	jb     80297e <__udivdi3+0x6a>
  802974:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802978:	0f 87 9e 00 00 00    	ja     802a1c <__udivdi3+0x108>
  80297e:	b8 01 00 00 00       	mov    $0x1,%eax
  802983:	89 fa                	mov    %edi,%edx
  802985:	83 c4 1c             	add    $0x1c,%esp
  802988:	5b                   	pop    %ebx
  802989:	5e                   	pop    %esi
  80298a:	5f                   	pop    %edi
  80298b:	5d                   	pop    %ebp
  80298c:	c3                   	ret    
  80298d:	8d 76 00             	lea    0x0(%esi),%esi
  802990:	31 ff                	xor    %edi,%edi
  802992:	31 c0                	xor    %eax,%eax
  802994:	89 fa                	mov    %edi,%edx
  802996:	83 c4 1c             	add    $0x1c,%esp
  802999:	5b                   	pop    %ebx
  80299a:	5e                   	pop    %esi
  80299b:	5f                   	pop    %edi
  80299c:	5d                   	pop    %ebp
  80299d:	c3                   	ret    
  80299e:	66 90                	xchg   %ax,%ax
  8029a0:	89 d8                	mov    %ebx,%eax
  8029a2:	f7 f7                	div    %edi
  8029a4:	31 ff                	xor    %edi,%edi
  8029a6:	89 fa                	mov    %edi,%edx
  8029a8:	83 c4 1c             	add    $0x1c,%esp
  8029ab:	5b                   	pop    %ebx
  8029ac:	5e                   	pop    %esi
  8029ad:	5f                   	pop    %edi
  8029ae:	5d                   	pop    %ebp
  8029af:	c3                   	ret    
  8029b0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8029b5:	89 eb                	mov    %ebp,%ebx
  8029b7:	29 fb                	sub    %edi,%ebx
  8029b9:	89 f9                	mov    %edi,%ecx
  8029bb:	d3 e6                	shl    %cl,%esi
  8029bd:	89 c5                	mov    %eax,%ebp
  8029bf:	88 d9                	mov    %bl,%cl
  8029c1:	d3 ed                	shr    %cl,%ebp
  8029c3:	89 e9                	mov    %ebp,%ecx
  8029c5:	09 f1                	or     %esi,%ecx
  8029c7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8029cb:	89 f9                	mov    %edi,%ecx
  8029cd:	d3 e0                	shl    %cl,%eax
  8029cf:	89 c5                	mov    %eax,%ebp
  8029d1:	89 d6                	mov    %edx,%esi
  8029d3:	88 d9                	mov    %bl,%cl
  8029d5:	d3 ee                	shr    %cl,%esi
  8029d7:	89 f9                	mov    %edi,%ecx
  8029d9:	d3 e2                	shl    %cl,%edx
  8029db:	8b 44 24 08          	mov    0x8(%esp),%eax
  8029df:	88 d9                	mov    %bl,%cl
  8029e1:	d3 e8                	shr    %cl,%eax
  8029e3:	09 c2                	or     %eax,%edx
  8029e5:	89 d0                	mov    %edx,%eax
  8029e7:	89 f2                	mov    %esi,%edx
  8029e9:	f7 74 24 0c          	divl   0xc(%esp)
  8029ed:	89 d6                	mov    %edx,%esi
  8029ef:	89 c3                	mov    %eax,%ebx
  8029f1:	f7 e5                	mul    %ebp
  8029f3:	39 d6                	cmp    %edx,%esi
  8029f5:	72 19                	jb     802a10 <__udivdi3+0xfc>
  8029f7:	74 0b                	je     802a04 <__udivdi3+0xf0>
  8029f9:	89 d8                	mov    %ebx,%eax
  8029fb:	31 ff                	xor    %edi,%edi
  8029fd:	e9 58 ff ff ff       	jmp    80295a <__udivdi3+0x46>
  802a02:	66 90                	xchg   %ax,%ax
  802a04:	8b 54 24 08          	mov    0x8(%esp),%edx
  802a08:	89 f9                	mov    %edi,%ecx
  802a0a:	d3 e2                	shl    %cl,%edx
  802a0c:	39 c2                	cmp    %eax,%edx
  802a0e:	73 e9                	jae    8029f9 <__udivdi3+0xe5>
  802a10:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a13:	31 ff                	xor    %edi,%edi
  802a15:	e9 40 ff ff ff       	jmp    80295a <__udivdi3+0x46>
  802a1a:	66 90                	xchg   %ax,%ax
  802a1c:	31 c0                	xor    %eax,%eax
  802a1e:	e9 37 ff ff ff       	jmp    80295a <__udivdi3+0x46>
  802a23:	90                   	nop

00802a24 <__umoddi3>:
  802a24:	55                   	push   %ebp
  802a25:	57                   	push   %edi
  802a26:	56                   	push   %esi
  802a27:	53                   	push   %ebx
  802a28:	83 ec 1c             	sub    $0x1c,%esp
  802a2b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802a2f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802a33:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a37:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a3b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a3f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a43:	89 f3                	mov    %esi,%ebx
  802a45:	89 fa                	mov    %edi,%edx
  802a47:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802a4b:	89 34 24             	mov    %esi,(%esp)
  802a4e:	85 c0                	test   %eax,%eax
  802a50:	75 1a                	jne    802a6c <__umoddi3+0x48>
  802a52:	39 f7                	cmp    %esi,%edi
  802a54:	0f 86 a2 00 00 00    	jbe    802afc <__umoddi3+0xd8>
  802a5a:	89 c8                	mov    %ecx,%eax
  802a5c:	89 f2                	mov    %esi,%edx
  802a5e:	f7 f7                	div    %edi
  802a60:	89 d0                	mov    %edx,%eax
  802a62:	31 d2                	xor    %edx,%edx
  802a64:	83 c4 1c             	add    $0x1c,%esp
  802a67:	5b                   	pop    %ebx
  802a68:	5e                   	pop    %esi
  802a69:	5f                   	pop    %edi
  802a6a:	5d                   	pop    %ebp
  802a6b:	c3                   	ret    
  802a6c:	39 f0                	cmp    %esi,%eax
  802a6e:	0f 87 ac 00 00 00    	ja     802b20 <__umoddi3+0xfc>
  802a74:	0f bd e8             	bsr    %eax,%ebp
  802a77:	83 f5 1f             	xor    $0x1f,%ebp
  802a7a:	0f 84 ac 00 00 00    	je     802b2c <__umoddi3+0x108>
  802a80:	bf 20 00 00 00       	mov    $0x20,%edi
  802a85:	29 ef                	sub    %ebp,%edi
  802a87:	89 fe                	mov    %edi,%esi
  802a89:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a8d:	89 e9                	mov    %ebp,%ecx
  802a8f:	d3 e0                	shl    %cl,%eax
  802a91:	89 d7                	mov    %edx,%edi
  802a93:	89 f1                	mov    %esi,%ecx
  802a95:	d3 ef                	shr    %cl,%edi
  802a97:	09 c7                	or     %eax,%edi
  802a99:	89 e9                	mov    %ebp,%ecx
  802a9b:	d3 e2                	shl    %cl,%edx
  802a9d:	89 14 24             	mov    %edx,(%esp)
  802aa0:	89 d8                	mov    %ebx,%eax
  802aa2:	d3 e0                	shl    %cl,%eax
  802aa4:	89 c2                	mov    %eax,%edx
  802aa6:	8b 44 24 08          	mov    0x8(%esp),%eax
  802aaa:	d3 e0                	shl    %cl,%eax
  802aac:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ab0:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ab4:	89 f1                	mov    %esi,%ecx
  802ab6:	d3 e8                	shr    %cl,%eax
  802ab8:	09 d0                	or     %edx,%eax
  802aba:	d3 eb                	shr    %cl,%ebx
  802abc:	89 da                	mov    %ebx,%edx
  802abe:	f7 f7                	div    %edi
  802ac0:	89 d3                	mov    %edx,%ebx
  802ac2:	f7 24 24             	mull   (%esp)
  802ac5:	89 c6                	mov    %eax,%esi
  802ac7:	89 d1                	mov    %edx,%ecx
  802ac9:	39 d3                	cmp    %edx,%ebx
  802acb:	0f 82 87 00 00 00    	jb     802b58 <__umoddi3+0x134>
  802ad1:	0f 84 91 00 00 00    	je     802b68 <__umoddi3+0x144>
  802ad7:	8b 54 24 04          	mov    0x4(%esp),%edx
  802adb:	29 f2                	sub    %esi,%edx
  802add:	19 cb                	sbb    %ecx,%ebx
  802adf:	89 d8                	mov    %ebx,%eax
  802ae1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802ae5:	d3 e0                	shl    %cl,%eax
  802ae7:	89 e9                	mov    %ebp,%ecx
  802ae9:	d3 ea                	shr    %cl,%edx
  802aeb:	09 d0                	or     %edx,%eax
  802aed:	89 e9                	mov    %ebp,%ecx
  802aef:	d3 eb                	shr    %cl,%ebx
  802af1:	89 da                	mov    %ebx,%edx
  802af3:	83 c4 1c             	add    $0x1c,%esp
  802af6:	5b                   	pop    %ebx
  802af7:	5e                   	pop    %esi
  802af8:	5f                   	pop    %edi
  802af9:	5d                   	pop    %ebp
  802afa:	c3                   	ret    
  802afb:	90                   	nop
  802afc:	89 fd                	mov    %edi,%ebp
  802afe:	85 ff                	test   %edi,%edi
  802b00:	75 0b                	jne    802b0d <__umoddi3+0xe9>
  802b02:	b8 01 00 00 00       	mov    $0x1,%eax
  802b07:	31 d2                	xor    %edx,%edx
  802b09:	f7 f7                	div    %edi
  802b0b:	89 c5                	mov    %eax,%ebp
  802b0d:	89 f0                	mov    %esi,%eax
  802b0f:	31 d2                	xor    %edx,%edx
  802b11:	f7 f5                	div    %ebp
  802b13:	89 c8                	mov    %ecx,%eax
  802b15:	f7 f5                	div    %ebp
  802b17:	89 d0                	mov    %edx,%eax
  802b19:	e9 44 ff ff ff       	jmp    802a62 <__umoddi3+0x3e>
  802b1e:	66 90                	xchg   %ax,%ax
  802b20:	89 c8                	mov    %ecx,%eax
  802b22:	89 f2                	mov    %esi,%edx
  802b24:	83 c4 1c             	add    $0x1c,%esp
  802b27:	5b                   	pop    %ebx
  802b28:	5e                   	pop    %esi
  802b29:	5f                   	pop    %edi
  802b2a:	5d                   	pop    %ebp
  802b2b:	c3                   	ret    
  802b2c:	3b 04 24             	cmp    (%esp),%eax
  802b2f:	72 06                	jb     802b37 <__umoddi3+0x113>
  802b31:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802b35:	77 0f                	ja     802b46 <__umoddi3+0x122>
  802b37:	89 f2                	mov    %esi,%edx
  802b39:	29 f9                	sub    %edi,%ecx
  802b3b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802b3f:	89 14 24             	mov    %edx,(%esp)
  802b42:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802b46:	8b 44 24 04          	mov    0x4(%esp),%eax
  802b4a:	8b 14 24             	mov    (%esp),%edx
  802b4d:	83 c4 1c             	add    $0x1c,%esp
  802b50:	5b                   	pop    %ebx
  802b51:	5e                   	pop    %esi
  802b52:	5f                   	pop    %edi
  802b53:	5d                   	pop    %ebp
  802b54:	c3                   	ret    
  802b55:	8d 76 00             	lea    0x0(%esi),%esi
  802b58:	2b 04 24             	sub    (%esp),%eax
  802b5b:	19 fa                	sbb    %edi,%edx
  802b5d:	89 d1                	mov    %edx,%ecx
  802b5f:	89 c6                	mov    %eax,%esi
  802b61:	e9 71 ff ff ff       	jmp    802ad7 <__umoddi3+0xb3>
  802b66:	66 90                	xchg   %ax,%ax
  802b68:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802b6c:	72 ea                	jb     802b58 <__umoddi3+0x134>
  802b6e:	89 d9                	mov    %ebx,%ecx
  802b70:	e9 62 ff ff ff       	jmp    802ad7 <__umoddi3+0xb3>
