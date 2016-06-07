
obj/user/mergesort_leakage:     file format elf32-i386


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
  800031:	e8 42 07 00 00       	call   800778 <libmain>
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
  800041:	e8 13 25 00 00       	call   802559 <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 60 2b 80 00       	push   $0x802b60
  80004e:	e8 11 09 00 00       	call   800964 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 62 2b 80 00       	push   $0x802b62
  80005e:	e8 01 09 00 00       	call   800964 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 78 2b 80 00       	push   $0x802b78
  80006e:	e8 f1 08 00 00       	call   800964 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 62 2b 80 00       	push   $0x802b62
  80007e:	e8 e1 08 00 00       	call   800964 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 60 2b 80 00       	push   $0x802b60
  80008e:	e8 d1 08 00 00       	call   800964 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 90 2b 80 00       	push   $0x802b90
  8000a5:	e8 35 0f 00 00       	call   800fdf <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 85 14 00 00       	call   801545 <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 18 18 00 00       	call   8018ed <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 b0 2b 80 00       	push   $0x802bb0
  8000e3:	e8 7c 08 00 00       	call   800964 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 d2 2b 80 00       	push   $0x802bd2
  8000f3:	e8 6c 08 00 00       	call   800964 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 e0 2b 80 00       	push   $0x802be0
  800103:	e8 5c 08 00 00       	call   800964 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 ef 2b 80 00       	push   $0x802bef
  800113:	e8 4c 08 00 00       	call   800964 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 ff 2b 80 00       	push   $0x802bff
  800123:	e8 3c 08 00 00       	call   800964 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  80012b:	e8 f0 05 00 00       	call   800720 <getchar>
  800130:	88 45 ef             	mov    %al,-0x11(%ebp)
		cputchar(Chose);
  800133:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 98 05 00 00       	call   8006d8 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 8b 05 00 00       	call   8006d8 <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp

		//2012: lock the interrupt
		sys_enable_interrupt();
  800150:	e8 1e 24 00 00       	call   802573 <sys_enable_interrupt>

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
  8001c5:	e8 8f 23 00 00       	call   802559 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001ca:	83 ec 0c             	sub    $0xc,%esp
  8001cd:	68 08 2c 80 00       	push   $0x802c08
  8001d2:	e8 8d 07 00 00       	call   800964 <cprintf>
  8001d7:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001da:	e8 94 23 00 00       	call   802573 <sys_enable_interrupt>

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
  8001fc:	68 3c 2c 80 00       	push   $0x802c3c
  800201:	6a 47                	push   $0x47
  800203:	68 5e 2c 80 00       	push   $0x802c5e
  800208:	e8 2c 06 00 00       	call   800839 <_panic>
		else
		{ 
			sys_disable_interrupt();
  80020d:	e8 47 23 00 00       	call   802559 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800212:	83 ec 0c             	sub    $0xc,%esp
  800215:	68 78 2c 80 00       	push   $0x802c78
  80021a:	e8 45 07 00 00       	call   800964 <cprintf>
  80021f:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 ac 2c 80 00       	push   $0x802cac
  80022a:	e8 35 07 00 00       	call   800964 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 e0 2c 80 00       	push   $0x802ce0
  80023a:	e8 25 07 00 00       	call   800964 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800242:	e8 2c 23 00 00       	call   802573 <sys_enable_interrupt>
		}

		free(Elements) ;
  800247:	83 ec 0c             	sub    $0xc,%esp
  80024a:	ff 75 f0             	pushl  -0x10(%ebp)
  80024d:	e8 3d 20 00 00       	call   80228f <free>
  800252:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  800255:	e8 ff 22 00 00       	call   802559 <sys_disable_interrupt>
		cprintf("Do you want to repeat (y/n): ") ;
  80025a:	83 ec 0c             	sub    $0xc,%esp
  80025d:	68 12 2d 80 00       	push   $0x802d12
  800262:	e8 fd 06 00 00       	call   800964 <cprintf>
  800267:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  80026a:	e8 b1 04 00 00       	call   800720 <getchar>
  80026f:	88 45 ef             	mov    %al,-0x11(%ebp)
		cputchar(Chose);
  800272:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  800276:	83 ec 0c             	sub    $0xc,%esp
  800279:	50                   	push   %eax
  80027a:	e8 59 04 00 00       	call   8006d8 <cputchar>
  80027f:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  800282:	83 ec 0c             	sub    $0xc,%esp
  800285:	6a 0a                	push   $0xa
  800287:	e8 4c 04 00 00       	call   8006d8 <cputchar>
  80028c:	83 c4 10             	add    $0x10,%esp
		sys_enable_interrupt();
  80028f:	e8 df 22 00 00       	call   802573 <sys_enable_interrupt>

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
  800423:	68 60 2b 80 00       	push   $0x802b60
  800428:	e8 37 05 00 00       	call   800964 <cprintf>
  80042d:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800433:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	01 d0                	add    %edx,%eax
  80043f:	8b 00                	mov    (%eax),%eax
  800441:	83 ec 08             	sub    $0x8,%esp
  800444:	50                   	push   %eax
  800445:	68 30 2d 80 00       	push   $0x802d30
  80044a:	e8 15 05 00 00       	call   800964 <cprintf>
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
  800473:	68 35 2d 80 00       	push   $0x802d35
  800478:	e8 e7 04 00 00       	call   800964 <cprintf>
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
  800519:	e8 cf 13 00 00       	call   8018ed <malloc>
  80051e:	83 c4 10             	add    $0x10,%esp
  800521:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800524:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800527:	c1 e0 02             	shl    $0x2,%eax
  80052a:	83 ec 0c             	sub    $0xc,%esp
  80052d:	50                   	push   %eax
  80052e:	e8 ba 13 00 00       	call   8018ed <malloc>
  800533:	83 c4 10             	add    $0x10,%esp
  800536:	89 45 d4             	mov    %eax,-0x2c(%ebp)

//	int Left[5000] ;
//	int Right[5000] ;

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

//	int Left[5000] ;
//	int Right[5000] ;

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

}
  8006d5:	90                   	nop
  8006d6:	c9                   	leave  
  8006d7:	c3                   	ret    

008006d8 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8006d8:	55                   	push   %ebp
  8006d9:	89 e5                	mov    %esp,%ebp
  8006db:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8006de:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e1:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8006e4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8006e8:	83 ec 0c             	sub    $0xc,%esp
  8006eb:	50                   	push   %eax
  8006ec:	e8 9c 1e 00 00       	call   80258d <sys_cputc>
  8006f1:	83 c4 10             	add    $0x10,%esp
}
  8006f4:	90                   	nop
  8006f5:	c9                   	leave  
  8006f6:	c3                   	ret    

008006f7 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8006f7:	55                   	push   %ebp
  8006f8:	89 e5                	mov    %esp,%ebp
  8006fa:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006fd:	e8 57 1e 00 00       	call   802559 <sys_disable_interrupt>
	char c = ch;
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800708:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80070c:	83 ec 0c             	sub    $0xc,%esp
  80070f:	50                   	push   %eax
  800710:	e8 78 1e 00 00       	call   80258d <sys_cputc>
  800715:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800718:	e8 56 1e 00 00       	call   802573 <sys_enable_interrupt>
}
  80071d:	90                   	nop
  80071e:	c9                   	leave  
  80071f:	c3                   	ret    

00800720 <getchar>:

int
getchar(void)
{
  800720:	55                   	push   %ebp
  800721:	89 e5                	mov    %esp,%ebp
  800723:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800726:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80072d:	eb 08                	jmp    800737 <getchar+0x17>
	{
		c = sys_cgetc();
  80072f:	e8 a3 1c 00 00       	call   8023d7 <sys_cgetc>
  800734:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800737:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80073b:	74 f2                	je     80072f <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80073d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800740:	c9                   	leave  
  800741:	c3                   	ret    

00800742 <atomic_getchar>:

int
atomic_getchar(void)
{
  800742:	55                   	push   %ebp
  800743:	89 e5                	mov    %esp,%ebp
  800745:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800748:	e8 0c 1e 00 00       	call   802559 <sys_disable_interrupt>
	int c=0;
  80074d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800754:	eb 08                	jmp    80075e <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800756:	e8 7c 1c 00 00       	call   8023d7 <sys_cgetc>
  80075b:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80075e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800762:	74 f2                	je     800756 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800764:	e8 0a 1e 00 00       	call   802573 <sys_enable_interrupt>
	return c;
  800769:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80076c:	c9                   	leave  
  80076d:	c3                   	ret    

0080076e <iscons>:

int iscons(int fdnum)
{
  80076e:	55                   	push   %ebp
  80076f:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800771:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800776:	5d                   	pop    %ebp
  800777:	c3                   	ret    

00800778 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800778:	55                   	push   %ebp
  800779:	89 e5                	mov    %esp,%ebp
  80077b:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80077e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800782:	7e 0a                	jle    80078e <libmain+0x16>
		binaryname = argv[0];
  800784:	8b 45 0c             	mov    0xc(%ebp),%eax
  800787:	8b 00                	mov    (%eax),%eax
  800789:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80078e:	83 ec 08             	sub    $0x8,%esp
  800791:	ff 75 0c             	pushl  0xc(%ebp)
  800794:	ff 75 08             	pushl  0x8(%ebp)
  800797:	e8 9c f8 ff ff       	call   800038 <_main>
  80079c:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  80079f:	e8 67 1c 00 00       	call   80240b <sys_getenvid>
  8007a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  8007a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007aa:	89 d0                	mov    %edx,%eax
  8007ac:	c1 e0 03             	shl    $0x3,%eax
  8007af:	01 d0                	add    %edx,%eax
  8007b1:	01 c0                	add    %eax,%eax
  8007b3:	01 d0                	add    %edx,%eax
  8007b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007bc:	01 d0                	add    %edx,%eax
  8007be:	c1 e0 03             	shl    $0x3,%eax
  8007c1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007c6:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  8007c9:	e8 8b 1d 00 00       	call   802559 <sys_disable_interrupt>
		cprintf("**************************************\n");
  8007ce:	83 ec 0c             	sub    $0xc,%esp
  8007d1:	68 54 2d 80 00       	push   $0x802d54
  8007d6:	e8 89 01 00 00       	call   800964 <cprintf>
  8007db:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  8007de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e1:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  8007e7:	83 ec 08             	sub    $0x8,%esp
  8007ea:	50                   	push   %eax
  8007eb:	68 7c 2d 80 00       	push   $0x802d7c
  8007f0:	e8 6f 01 00 00       	call   800964 <cprintf>
  8007f5:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8007f8:	83 ec 0c             	sub    $0xc,%esp
  8007fb:	68 54 2d 80 00       	push   $0x802d54
  800800:	e8 5f 01 00 00       	call   800964 <cprintf>
  800805:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800808:	e8 66 1d 00 00       	call   802573 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80080d:	e8 19 00 00 00       	call   80082b <exit>
}
  800812:	90                   	nop
  800813:	c9                   	leave  
  800814:	c3                   	ret    

00800815 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800815:	55                   	push   %ebp
  800816:	89 e5                	mov    %esp,%ebp
  800818:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80081b:	83 ec 0c             	sub    $0xc,%esp
  80081e:	6a 00                	push   $0x0
  800820:	e8 cb 1b 00 00       	call   8023f0 <sys_env_destroy>
  800825:	83 c4 10             	add    $0x10,%esp
}
  800828:	90                   	nop
  800829:	c9                   	leave  
  80082a:	c3                   	ret    

0080082b <exit>:

void
exit(void)
{
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800831:	e8 ee 1b 00 00       	call   802424 <sys_env_exit>
}
  800836:	90                   	nop
  800837:	c9                   	leave  
  800838:	c3                   	ret    

00800839 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800839:	55                   	push   %ebp
  80083a:	89 e5                	mov    %esp,%ebp
  80083c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80083f:	8d 45 10             	lea    0x10(%ebp),%eax
  800842:	83 c0 04             	add    $0x4,%eax
  800845:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  800848:	a1 70 40 98 00       	mov    0x984070,%eax
  80084d:	85 c0                	test   %eax,%eax
  80084f:	74 16                	je     800867 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800851:	a1 70 40 98 00       	mov    0x984070,%eax
  800856:	83 ec 08             	sub    $0x8,%esp
  800859:	50                   	push   %eax
  80085a:	68 95 2d 80 00       	push   $0x802d95
  80085f:	e8 00 01 00 00       	call   800964 <cprintf>
  800864:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800867:	a1 00 40 80 00       	mov    0x804000,%eax
  80086c:	ff 75 0c             	pushl  0xc(%ebp)
  80086f:	ff 75 08             	pushl  0x8(%ebp)
  800872:	50                   	push   %eax
  800873:	68 9a 2d 80 00       	push   $0x802d9a
  800878:	e8 e7 00 00 00       	call   800964 <cprintf>
  80087d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800880:	8b 45 10             	mov    0x10(%ebp),%eax
  800883:	83 ec 08             	sub    $0x8,%esp
  800886:	ff 75 f4             	pushl  -0xc(%ebp)
  800889:	50                   	push   %eax
  80088a:	e8 7a 00 00 00       	call   800909 <vcprintf>
  80088f:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  800892:	83 ec 0c             	sub    $0xc,%esp
  800895:	68 b6 2d 80 00       	push   $0x802db6
  80089a:	e8 c5 00 00 00       	call   800964 <cprintf>
  80089f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8008a2:	e8 84 ff ff ff       	call   80082b <exit>

	// should not return here
	while (1) ;
  8008a7:	eb fe                	jmp    8008a7 <_panic+0x6e>

008008a9 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8008a9:	55                   	push   %ebp
  8008aa:	89 e5                	mov    %esp,%ebp
  8008ac:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b2:	8b 00                	mov    (%eax),%eax
  8008b4:	8d 48 01             	lea    0x1(%eax),%ecx
  8008b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ba:	89 0a                	mov    %ecx,(%edx)
  8008bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8008bf:	88 d1                	mov    %dl,%cl
  8008c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c4:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008cb:	8b 00                	mov    (%eax),%eax
  8008cd:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008d2:	75 23                	jne    8008f7 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  8008d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d7:	8b 00                	mov    (%eax),%eax
  8008d9:	89 c2                	mov    %eax,%edx
  8008db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008de:	83 c0 08             	add    $0x8,%eax
  8008e1:	83 ec 08             	sub    $0x8,%esp
  8008e4:	52                   	push   %edx
  8008e5:	50                   	push   %eax
  8008e6:	e8 cf 1a 00 00       	call   8023ba <sys_cputs>
  8008eb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8008ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8008f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008fa:	8b 40 04             	mov    0x4(%eax),%eax
  8008fd:	8d 50 01             	lea    0x1(%eax),%edx
  800900:	8b 45 0c             	mov    0xc(%ebp),%eax
  800903:	89 50 04             	mov    %edx,0x4(%eax)
}
  800906:	90                   	nop
  800907:	c9                   	leave  
  800908:	c3                   	ret    

00800909 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800909:	55                   	push   %ebp
  80090a:	89 e5                	mov    %esp,%ebp
  80090c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800912:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800919:	00 00 00 
	b.cnt = 0;
  80091c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800923:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800926:	ff 75 0c             	pushl  0xc(%ebp)
  800929:	ff 75 08             	pushl  0x8(%ebp)
  80092c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800932:	50                   	push   %eax
  800933:	68 a9 08 80 00       	push   $0x8008a9
  800938:	e8 fa 01 00 00       	call   800b37 <vprintfmt>
  80093d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  800940:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800946:	83 ec 08             	sub    $0x8,%esp
  800949:	50                   	push   %eax
  80094a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800950:	83 c0 08             	add    $0x8,%eax
  800953:	50                   	push   %eax
  800954:	e8 61 1a 00 00       	call   8023ba <sys_cputs>
  800959:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  80095c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800962:	c9                   	leave  
  800963:	c3                   	ret    

00800964 <cprintf>:

int cprintf(const char *fmt, ...) {
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80096a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80096d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800970:	8b 45 08             	mov    0x8(%ebp),%eax
  800973:	83 ec 08             	sub    $0x8,%esp
  800976:	ff 75 f4             	pushl  -0xc(%ebp)
  800979:	50                   	push   %eax
  80097a:	e8 8a ff ff ff       	call   800909 <vcprintf>
  80097f:	83 c4 10             	add    $0x10,%esp
  800982:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800985:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800988:	c9                   	leave  
  800989:	c3                   	ret    

0080098a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800990:	e8 c4 1b 00 00       	call   802559 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800995:	8d 45 0c             	lea    0xc(%ebp),%eax
  800998:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80099b:	8b 45 08             	mov    0x8(%ebp),%eax
  80099e:	83 ec 08             	sub    $0x8,%esp
  8009a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8009a4:	50                   	push   %eax
  8009a5:	e8 5f ff ff ff       	call   800909 <vcprintf>
  8009aa:	83 c4 10             	add    $0x10,%esp
  8009ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009b0:	e8 be 1b 00 00       	call   802573 <sys_enable_interrupt>
	return cnt;
  8009b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009b8:	c9                   	leave  
  8009b9:	c3                   	ret    

008009ba <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009ba:	55                   	push   %ebp
  8009bb:	89 e5                	mov    %esp,%ebp
  8009bd:	53                   	push   %ebx
  8009be:	83 ec 14             	sub    $0x14,%esp
  8009c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009cd:	8b 45 18             	mov    0x18(%ebp),%eax
  8009d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009d8:	77 55                	ja     800a2f <printnum+0x75>
  8009da:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009dd:	72 05                	jb     8009e4 <printnum+0x2a>
  8009df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009e2:	77 4b                	ja     800a2f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8009e4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8009e7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8009ea:	8b 45 18             	mov    0x18(%ebp),%eax
  8009ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f2:	52                   	push   %edx
  8009f3:	50                   	push   %eax
  8009f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8009f7:	ff 75 f0             	pushl  -0x10(%ebp)
  8009fa:	e8 f9 1e 00 00       	call   8028f8 <__udivdi3>
  8009ff:	83 c4 10             	add    $0x10,%esp
  800a02:	83 ec 04             	sub    $0x4,%esp
  800a05:	ff 75 20             	pushl  0x20(%ebp)
  800a08:	53                   	push   %ebx
  800a09:	ff 75 18             	pushl  0x18(%ebp)
  800a0c:	52                   	push   %edx
  800a0d:	50                   	push   %eax
  800a0e:	ff 75 0c             	pushl  0xc(%ebp)
  800a11:	ff 75 08             	pushl  0x8(%ebp)
  800a14:	e8 a1 ff ff ff       	call   8009ba <printnum>
  800a19:	83 c4 20             	add    $0x20,%esp
  800a1c:	eb 1a                	jmp    800a38 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a1e:	83 ec 08             	sub    $0x8,%esp
  800a21:	ff 75 0c             	pushl  0xc(%ebp)
  800a24:	ff 75 20             	pushl  0x20(%ebp)
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	ff d0                	call   *%eax
  800a2c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a2f:	ff 4d 1c             	decl   0x1c(%ebp)
  800a32:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a36:	7f e6                	jg     800a1e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a38:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a3b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a46:	53                   	push   %ebx
  800a47:	51                   	push   %ecx
  800a48:	52                   	push   %edx
  800a49:	50                   	push   %eax
  800a4a:	e8 b9 1f 00 00       	call   802a08 <__umoddi3>
  800a4f:	83 c4 10             	add    $0x10,%esp
  800a52:	05 d4 2f 80 00       	add    $0x802fd4,%eax
  800a57:	8a 00                	mov    (%eax),%al
  800a59:	0f be c0             	movsbl %al,%eax
  800a5c:	83 ec 08             	sub    $0x8,%esp
  800a5f:	ff 75 0c             	pushl  0xc(%ebp)
  800a62:	50                   	push   %eax
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	ff d0                	call   *%eax
  800a68:	83 c4 10             	add    $0x10,%esp
}
  800a6b:	90                   	nop
  800a6c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a6f:	c9                   	leave  
  800a70:	c3                   	ret    

00800a71 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a71:	55                   	push   %ebp
  800a72:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a74:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a78:	7e 1c                	jle    800a96 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7d:	8b 00                	mov    (%eax),%eax
  800a7f:	8d 50 08             	lea    0x8(%eax),%edx
  800a82:	8b 45 08             	mov    0x8(%ebp),%eax
  800a85:	89 10                	mov    %edx,(%eax)
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	8b 00                	mov    (%eax),%eax
  800a8c:	83 e8 08             	sub    $0x8,%eax
  800a8f:	8b 50 04             	mov    0x4(%eax),%edx
  800a92:	8b 00                	mov    (%eax),%eax
  800a94:	eb 40                	jmp    800ad6 <getuint+0x65>
	else if (lflag)
  800a96:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a9a:	74 1e                	je     800aba <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	8b 00                	mov    (%eax),%eax
  800aa1:	8d 50 04             	lea    0x4(%eax),%edx
  800aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa7:	89 10                	mov    %edx,(%eax)
  800aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aac:	8b 00                	mov    (%eax),%eax
  800aae:	83 e8 04             	sub    $0x4,%eax
  800ab1:	8b 00                	mov    (%eax),%eax
  800ab3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab8:	eb 1c                	jmp    800ad6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	8b 00                	mov    (%eax),%eax
  800abf:	8d 50 04             	lea    0x4(%eax),%edx
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	89 10                	mov    %edx,(%eax)
  800ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aca:	8b 00                	mov    (%eax),%eax
  800acc:	83 e8 04             	sub    $0x4,%eax
  800acf:	8b 00                	mov    (%eax),%eax
  800ad1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ad6:	5d                   	pop    %ebp
  800ad7:	c3                   	ret    

00800ad8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ad8:	55                   	push   %ebp
  800ad9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800adb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800adf:	7e 1c                	jle    800afd <getint+0x25>
		return va_arg(*ap, long long);
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	8b 00                	mov    (%eax),%eax
  800ae6:	8d 50 08             	lea    0x8(%eax),%edx
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	89 10                	mov    %edx,(%eax)
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	8b 00                	mov    (%eax),%eax
  800af3:	83 e8 08             	sub    $0x8,%eax
  800af6:	8b 50 04             	mov    0x4(%eax),%edx
  800af9:	8b 00                	mov    (%eax),%eax
  800afb:	eb 38                	jmp    800b35 <getint+0x5d>
	else if (lflag)
  800afd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b01:	74 1a                	je     800b1d <getint+0x45>
		return va_arg(*ap, long);
  800b03:	8b 45 08             	mov    0x8(%ebp),%eax
  800b06:	8b 00                	mov    (%eax),%eax
  800b08:	8d 50 04             	lea    0x4(%eax),%edx
  800b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0e:	89 10                	mov    %edx,(%eax)
  800b10:	8b 45 08             	mov    0x8(%ebp),%eax
  800b13:	8b 00                	mov    (%eax),%eax
  800b15:	83 e8 04             	sub    $0x4,%eax
  800b18:	8b 00                	mov    (%eax),%eax
  800b1a:	99                   	cltd   
  800b1b:	eb 18                	jmp    800b35 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	8b 00                	mov    (%eax),%eax
  800b22:	8d 50 04             	lea    0x4(%eax),%edx
  800b25:	8b 45 08             	mov    0x8(%ebp),%eax
  800b28:	89 10                	mov    %edx,(%eax)
  800b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2d:	8b 00                	mov    (%eax),%eax
  800b2f:	83 e8 04             	sub    $0x4,%eax
  800b32:	8b 00                	mov    (%eax),%eax
  800b34:	99                   	cltd   
}
  800b35:	5d                   	pop    %ebp
  800b36:	c3                   	ret    

00800b37 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b37:	55                   	push   %ebp
  800b38:	89 e5                	mov    %esp,%ebp
  800b3a:	56                   	push   %esi
  800b3b:	53                   	push   %ebx
  800b3c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b3f:	eb 17                	jmp    800b58 <vprintfmt+0x21>
			if (ch == '\0')
  800b41:	85 db                	test   %ebx,%ebx
  800b43:	0f 84 af 03 00 00    	je     800ef8 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b49:	83 ec 08             	sub    $0x8,%esp
  800b4c:	ff 75 0c             	pushl  0xc(%ebp)
  800b4f:	53                   	push   %ebx
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	ff d0                	call   *%eax
  800b55:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b58:	8b 45 10             	mov    0x10(%ebp),%eax
  800b5b:	8d 50 01             	lea    0x1(%eax),%edx
  800b5e:	89 55 10             	mov    %edx,0x10(%ebp)
  800b61:	8a 00                	mov    (%eax),%al
  800b63:	0f b6 d8             	movzbl %al,%ebx
  800b66:	83 fb 25             	cmp    $0x25,%ebx
  800b69:	75 d6                	jne    800b41 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b6b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b6f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b76:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b7d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800b84:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8e:	8d 50 01             	lea    0x1(%eax),%edx
  800b91:	89 55 10             	mov    %edx,0x10(%ebp)
  800b94:	8a 00                	mov    (%eax),%al
  800b96:	0f b6 d8             	movzbl %al,%ebx
  800b99:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800b9c:	83 f8 55             	cmp    $0x55,%eax
  800b9f:	0f 87 2b 03 00 00    	ja     800ed0 <vprintfmt+0x399>
  800ba5:	8b 04 85 f8 2f 80 00 	mov    0x802ff8(,%eax,4),%eax
  800bac:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bae:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800bb2:	eb d7                	jmp    800b8b <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bb4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bb8:	eb d1                	jmp    800b8b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bba:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800bc1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bc4:	89 d0                	mov    %edx,%eax
  800bc6:	c1 e0 02             	shl    $0x2,%eax
  800bc9:	01 d0                	add    %edx,%eax
  800bcb:	01 c0                	add    %eax,%eax
  800bcd:	01 d8                	add    %ebx,%eax
  800bcf:	83 e8 30             	sub    $0x30,%eax
  800bd2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800bd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd8:	8a 00                	mov    (%eax),%al
  800bda:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bdd:	83 fb 2f             	cmp    $0x2f,%ebx
  800be0:	7e 3e                	jle    800c20 <vprintfmt+0xe9>
  800be2:	83 fb 39             	cmp    $0x39,%ebx
  800be5:	7f 39                	jg     800c20 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800be7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bea:	eb d5                	jmp    800bc1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800bec:	8b 45 14             	mov    0x14(%ebp),%eax
  800bef:	83 c0 04             	add    $0x4,%eax
  800bf2:	89 45 14             	mov    %eax,0x14(%ebp)
  800bf5:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf8:	83 e8 04             	sub    $0x4,%eax
  800bfb:	8b 00                	mov    (%eax),%eax
  800bfd:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c00:	eb 1f                	jmp    800c21 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c02:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c06:	79 83                	jns    800b8b <vprintfmt+0x54>
				width = 0;
  800c08:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c0f:	e9 77 ff ff ff       	jmp    800b8b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c14:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c1b:	e9 6b ff ff ff       	jmp    800b8b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c20:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c21:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c25:	0f 89 60 ff ff ff    	jns    800b8b <vprintfmt+0x54>
				width = precision, precision = -1;
  800c2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c31:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c38:	e9 4e ff ff ff       	jmp    800b8b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c3d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c40:	e9 46 ff ff ff       	jmp    800b8b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c45:	8b 45 14             	mov    0x14(%ebp),%eax
  800c48:	83 c0 04             	add    $0x4,%eax
  800c4b:	89 45 14             	mov    %eax,0x14(%ebp)
  800c4e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c51:	83 e8 04             	sub    $0x4,%eax
  800c54:	8b 00                	mov    (%eax),%eax
  800c56:	83 ec 08             	sub    $0x8,%esp
  800c59:	ff 75 0c             	pushl  0xc(%ebp)
  800c5c:	50                   	push   %eax
  800c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c60:	ff d0                	call   *%eax
  800c62:	83 c4 10             	add    $0x10,%esp
			break;
  800c65:	e9 89 02 00 00       	jmp    800ef3 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6d:	83 c0 04             	add    $0x4,%eax
  800c70:	89 45 14             	mov    %eax,0x14(%ebp)
  800c73:	8b 45 14             	mov    0x14(%ebp),%eax
  800c76:	83 e8 04             	sub    $0x4,%eax
  800c79:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800c7b:	85 db                	test   %ebx,%ebx
  800c7d:	79 02                	jns    800c81 <vprintfmt+0x14a>
				err = -err;
  800c7f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800c81:	83 fb 64             	cmp    $0x64,%ebx
  800c84:	7f 0b                	jg     800c91 <vprintfmt+0x15a>
  800c86:	8b 34 9d 40 2e 80 00 	mov    0x802e40(,%ebx,4),%esi
  800c8d:	85 f6                	test   %esi,%esi
  800c8f:	75 19                	jne    800caa <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c91:	53                   	push   %ebx
  800c92:	68 e5 2f 80 00       	push   $0x802fe5
  800c97:	ff 75 0c             	pushl  0xc(%ebp)
  800c9a:	ff 75 08             	pushl  0x8(%ebp)
  800c9d:	e8 5e 02 00 00       	call   800f00 <printfmt>
  800ca2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ca5:	e9 49 02 00 00       	jmp    800ef3 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800caa:	56                   	push   %esi
  800cab:	68 ee 2f 80 00       	push   $0x802fee
  800cb0:	ff 75 0c             	pushl  0xc(%ebp)
  800cb3:	ff 75 08             	pushl  0x8(%ebp)
  800cb6:	e8 45 02 00 00       	call   800f00 <printfmt>
  800cbb:	83 c4 10             	add    $0x10,%esp
			break;
  800cbe:	e9 30 02 00 00       	jmp    800ef3 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800cc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc6:	83 c0 04             	add    $0x4,%eax
  800cc9:	89 45 14             	mov    %eax,0x14(%ebp)
  800ccc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ccf:	83 e8 04             	sub    $0x4,%eax
  800cd2:	8b 30                	mov    (%eax),%esi
  800cd4:	85 f6                	test   %esi,%esi
  800cd6:	75 05                	jne    800cdd <vprintfmt+0x1a6>
				p = "(null)";
  800cd8:	be f1 2f 80 00       	mov    $0x802ff1,%esi
			if (width > 0 && padc != '-')
  800cdd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ce1:	7e 6d                	jle    800d50 <vprintfmt+0x219>
  800ce3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ce7:	74 67                	je     800d50 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ce9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cec:	83 ec 08             	sub    $0x8,%esp
  800cef:	50                   	push   %eax
  800cf0:	56                   	push   %esi
  800cf1:	e8 12 05 00 00       	call   801208 <strnlen>
  800cf6:	83 c4 10             	add    $0x10,%esp
  800cf9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800cfc:	eb 16                	jmp    800d14 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800cfe:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d02:	83 ec 08             	sub    $0x8,%esp
  800d05:	ff 75 0c             	pushl  0xc(%ebp)
  800d08:	50                   	push   %eax
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	ff d0                	call   *%eax
  800d0e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d11:	ff 4d e4             	decl   -0x1c(%ebp)
  800d14:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d18:	7f e4                	jg     800cfe <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d1a:	eb 34                	jmp    800d50 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d1c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d20:	74 1c                	je     800d3e <vprintfmt+0x207>
  800d22:	83 fb 1f             	cmp    $0x1f,%ebx
  800d25:	7e 05                	jle    800d2c <vprintfmt+0x1f5>
  800d27:	83 fb 7e             	cmp    $0x7e,%ebx
  800d2a:	7e 12                	jle    800d3e <vprintfmt+0x207>
					putch('?', putdat);
  800d2c:	83 ec 08             	sub    $0x8,%esp
  800d2f:	ff 75 0c             	pushl  0xc(%ebp)
  800d32:	6a 3f                	push   $0x3f
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	ff d0                	call   *%eax
  800d39:	83 c4 10             	add    $0x10,%esp
  800d3c:	eb 0f                	jmp    800d4d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d3e:	83 ec 08             	sub    $0x8,%esp
  800d41:	ff 75 0c             	pushl  0xc(%ebp)
  800d44:	53                   	push   %ebx
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	ff d0                	call   *%eax
  800d4a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d4d:	ff 4d e4             	decl   -0x1c(%ebp)
  800d50:	89 f0                	mov    %esi,%eax
  800d52:	8d 70 01             	lea    0x1(%eax),%esi
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	0f be d8             	movsbl %al,%ebx
  800d5a:	85 db                	test   %ebx,%ebx
  800d5c:	74 24                	je     800d82 <vprintfmt+0x24b>
  800d5e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d62:	78 b8                	js     800d1c <vprintfmt+0x1e5>
  800d64:	ff 4d e0             	decl   -0x20(%ebp)
  800d67:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d6b:	79 af                	jns    800d1c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d6d:	eb 13                	jmp    800d82 <vprintfmt+0x24b>
				putch(' ', putdat);
  800d6f:	83 ec 08             	sub    $0x8,%esp
  800d72:	ff 75 0c             	pushl  0xc(%ebp)
  800d75:	6a 20                	push   $0x20
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	ff d0                	call   *%eax
  800d7c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d7f:	ff 4d e4             	decl   -0x1c(%ebp)
  800d82:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d86:	7f e7                	jg     800d6f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800d88:	e9 66 01 00 00       	jmp    800ef3 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d8d:	83 ec 08             	sub    $0x8,%esp
  800d90:	ff 75 e8             	pushl  -0x18(%ebp)
  800d93:	8d 45 14             	lea    0x14(%ebp),%eax
  800d96:	50                   	push   %eax
  800d97:	e8 3c fd ff ff       	call   800ad8 <getint>
  800d9c:	83 c4 10             	add    $0x10,%esp
  800d9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800da2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800da5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800da8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dab:	85 d2                	test   %edx,%edx
  800dad:	79 23                	jns    800dd2 <vprintfmt+0x29b>
				putch('-', putdat);
  800daf:	83 ec 08             	sub    $0x8,%esp
  800db2:	ff 75 0c             	pushl  0xc(%ebp)
  800db5:	6a 2d                	push   $0x2d
  800db7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dba:	ff d0                	call   *%eax
  800dbc:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800dbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dc2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dc5:	f7 d8                	neg    %eax
  800dc7:	83 d2 00             	adc    $0x0,%edx
  800dca:	f7 da                	neg    %edx
  800dcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dcf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800dd2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800dd9:	e9 bc 00 00 00       	jmp    800e9a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800dde:	83 ec 08             	sub    $0x8,%esp
  800de1:	ff 75 e8             	pushl  -0x18(%ebp)
  800de4:	8d 45 14             	lea    0x14(%ebp),%eax
  800de7:	50                   	push   %eax
  800de8:	e8 84 fc ff ff       	call   800a71 <getuint>
  800ded:	83 c4 10             	add    $0x10,%esp
  800df0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800df3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800df6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800dfd:	e9 98 00 00 00       	jmp    800e9a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e02:	83 ec 08             	sub    $0x8,%esp
  800e05:	ff 75 0c             	pushl  0xc(%ebp)
  800e08:	6a 58                	push   $0x58
  800e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0d:	ff d0                	call   *%eax
  800e0f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e12:	83 ec 08             	sub    $0x8,%esp
  800e15:	ff 75 0c             	pushl  0xc(%ebp)
  800e18:	6a 58                	push   $0x58
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	ff d0                	call   *%eax
  800e1f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e22:	83 ec 08             	sub    $0x8,%esp
  800e25:	ff 75 0c             	pushl  0xc(%ebp)
  800e28:	6a 58                	push   $0x58
  800e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2d:	ff d0                	call   *%eax
  800e2f:	83 c4 10             	add    $0x10,%esp
			break;
  800e32:	e9 bc 00 00 00       	jmp    800ef3 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e37:	83 ec 08             	sub    $0x8,%esp
  800e3a:	ff 75 0c             	pushl  0xc(%ebp)
  800e3d:	6a 30                	push   $0x30
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e42:	ff d0                	call   *%eax
  800e44:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e47:	83 ec 08             	sub    $0x8,%esp
  800e4a:	ff 75 0c             	pushl  0xc(%ebp)
  800e4d:	6a 78                	push   $0x78
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	ff d0                	call   *%eax
  800e54:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e57:	8b 45 14             	mov    0x14(%ebp),%eax
  800e5a:	83 c0 04             	add    $0x4,%eax
  800e5d:	89 45 14             	mov    %eax,0x14(%ebp)
  800e60:	8b 45 14             	mov    0x14(%ebp),%eax
  800e63:	83 e8 04             	sub    $0x4,%eax
  800e66:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e72:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e79:	eb 1f                	jmp    800e9a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800e7b:	83 ec 08             	sub    $0x8,%esp
  800e7e:	ff 75 e8             	pushl  -0x18(%ebp)
  800e81:	8d 45 14             	lea    0x14(%ebp),%eax
  800e84:	50                   	push   %eax
  800e85:	e8 e7 fb ff ff       	call   800a71 <getuint>
  800e8a:	83 c4 10             	add    $0x10,%esp
  800e8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e90:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800e93:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e9a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800e9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ea1:	83 ec 04             	sub    $0x4,%esp
  800ea4:	52                   	push   %edx
  800ea5:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ea8:	50                   	push   %eax
  800ea9:	ff 75 f4             	pushl  -0xc(%ebp)
  800eac:	ff 75 f0             	pushl  -0x10(%ebp)
  800eaf:	ff 75 0c             	pushl  0xc(%ebp)
  800eb2:	ff 75 08             	pushl  0x8(%ebp)
  800eb5:	e8 00 fb ff ff       	call   8009ba <printnum>
  800eba:	83 c4 20             	add    $0x20,%esp
			break;
  800ebd:	eb 34                	jmp    800ef3 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ebf:	83 ec 08             	sub    $0x8,%esp
  800ec2:	ff 75 0c             	pushl  0xc(%ebp)
  800ec5:	53                   	push   %ebx
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	ff d0                	call   *%eax
  800ecb:	83 c4 10             	add    $0x10,%esp
			break;
  800ece:	eb 23                	jmp    800ef3 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ed0:	83 ec 08             	sub    $0x8,%esp
  800ed3:	ff 75 0c             	pushl  0xc(%ebp)
  800ed6:	6a 25                	push   $0x25
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  800edb:	ff d0                	call   *%eax
  800edd:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ee0:	ff 4d 10             	decl   0x10(%ebp)
  800ee3:	eb 03                	jmp    800ee8 <vprintfmt+0x3b1>
  800ee5:	ff 4d 10             	decl   0x10(%ebp)
  800ee8:	8b 45 10             	mov    0x10(%ebp),%eax
  800eeb:	48                   	dec    %eax
  800eec:	8a 00                	mov    (%eax),%al
  800eee:	3c 25                	cmp    $0x25,%al
  800ef0:	75 f3                	jne    800ee5 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ef2:	90                   	nop
		}
	}
  800ef3:	e9 47 fc ff ff       	jmp    800b3f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ef8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ef9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800efc:	5b                   	pop    %ebx
  800efd:	5e                   	pop    %esi
  800efe:	5d                   	pop    %ebp
  800eff:	c3                   	ret    

00800f00 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
  800f03:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f06:	8d 45 10             	lea    0x10(%ebp),%eax
  800f09:	83 c0 04             	add    $0x4,%eax
  800f0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f12:	ff 75 f4             	pushl  -0xc(%ebp)
  800f15:	50                   	push   %eax
  800f16:	ff 75 0c             	pushl  0xc(%ebp)
  800f19:	ff 75 08             	pushl  0x8(%ebp)
  800f1c:	e8 16 fc ff ff       	call   800b37 <vprintfmt>
  800f21:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f24:	90                   	nop
  800f25:	c9                   	leave  
  800f26:	c3                   	ret    

00800f27 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f27:	55                   	push   %ebp
  800f28:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2d:	8b 40 08             	mov    0x8(%eax),%eax
  800f30:	8d 50 01             	lea    0x1(%eax),%edx
  800f33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f36:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3c:	8b 10                	mov    (%eax),%edx
  800f3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f41:	8b 40 04             	mov    0x4(%eax),%eax
  800f44:	39 c2                	cmp    %eax,%edx
  800f46:	73 12                	jae    800f5a <sprintputch+0x33>
		*b->buf++ = ch;
  800f48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4b:	8b 00                	mov    (%eax),%eax
  800f4d:	8d 48 01             	lea    0x1(%eax),%ecx
  800f50:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f53:	89 0a                	mov    %ecx,(%edx)
  800f55:	8b 55 08             	mov    0x8(%ebp),%edx
  800f58:	88 10                	mov    %dl,(%eax)
}
  800f5a:	90                   	nop
  800f5b:	5d                   	pop    %ebp
  800f5c:	c3                   	ret    

00800f5d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f5d:	55                   	push   %ebp
  800f5e:	89 e5                	mov    %esp,%ebp
  800f60:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f63:	8b 45 08             	mov    0x8(%ebp),%eax
  800f66:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	01 d0                	add    %edx,%eax
  800f74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f77:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f7e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f82:	74 06                	je     800f8a <vsnprintf+0x2d>
  800f84:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f88:	7f 07                	jg     800f91 <vsnprintf+0x34>
		return -E_INVAL;
  800f8a:	b8 03 00 00 00       	mov    $0x3,%eax
  800f8f:	eb 20                	jmp    800fb1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f91:	ff 75 14             	pushl  0x14(%ebp)
  800f94:	ff 75 10             	pushl  0x10(%ebp)
  800f97:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800f9a:	50                   	push   %eax
  800f9b:	68 27 0f 80 00       	push   $0x800f27
  800fa0:	e8 92 fb ff ff       	call   800b37 <vprintfmt>
  800fa5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fa8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fab:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fb1:	c9                   	leave  
  800fb2:	c3                   	ret    

00800fb3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fb3:	55                   	push   %ebp
  800fb4:	89 e5                	mov    %esp,%ebp
  800fb6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fb9:	8d 45 10             	lea    0x10(%ebp),%eax
  800fbc:	83 c0 04             	add    $0x4,%eax
  800fbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc5:	ff 75 f4             	pushl  -0xc(%ebp)
  800fc8:	50                   	push   %eax
  800fc9:	ff 75 0c             	pushl  0xc(%ebp)
  800fcc:	ff 75 08             	pushl  0x8(%ebp)
  800fcf:	e8 89 ff ff ff       	call   800f5d <vsnprintf>
  800fd4:	83 c4 10             	add    $0x10,%esp
  800fd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800fda:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fdd:	c9                   	leave  
  800fde:	c3                   	ret    

00800fdf <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  800fe5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fe9:	74 13                	je     800ffe <readline+0x1f>
		cprintf("%s", prompt);
  800feb:	83 ec 08             	sub    $0x8,%esp
  800fee:	ff 75 08             	pushl  0x8(%ebp)
  800ff1:	68 50 31 80 00       	push   $0x803150
  800ff6:	e8 69 f9 ff ff       	call   800964 <cprintf>
  800ffb:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800ffe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801005:	83 ec 0c             	sub    $0xc,%esp
  801008:	6a 00                	push   $0x0
  80100a:	e8 5f f7 ff ff       	call   80076e <iscons>
  80100f:	83 c4 10             	add    $0x10,%esp
  801012:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801015:	e8 06 f7 ff ff       	call   800720 <getchar>
  80101a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80101d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801021:	79 22                	jns    801045 <readline+0x66>
			if (c != -E_EOF)
  801023:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801027:	0f 84 ad 00 00 00    	je     8010da <readline+0xfb>
				cprintf("read error: %e\n", c);
  80102d:	83 ec 08             	sub    $0x8,%esp
  801030:	ff 75 ec             	pushl  -0x14(%ebp)
  801033:	68 53 31 80 00       	push   $0x803153
  801038:	e8 27 f9 ff ff       	call   800964 <cprintf>
  80103d:	83 c4 10             	add    $0x10,%esp
			return;
  801040:	e9 95 00 00 00       	jmp    8010da <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801045:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801049:	7e 34                	jle    80107f <readline+0xa0>
  80104b:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801052:	7f 2b                	jg     80107f <readline+0xa0>
			if (echoing)
  801054:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801058:	74 0e                	je     801068 <readline+0x89>
				cputchar(c);
  80105a:	83 ec 0c             	sub    $0xc,%esp
  80105d:	ff 75 ec             	pushl  -0x14(%ebp)
  801060:	e8 73 f6 ff ff       	call   8006d8 <cputchar>
  801065:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106b:	8d 50 01             	lea    0x1(%eax),%edx
  80106e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801071:	89 c2                	mov    %eax,%edx
  801073:	8b 45 0c             	mov    0xc(%ebp),%eax
  801076:	01 d0                	add    %edx,%eax
  801078:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80107b:	88 10                	mov    %dl,(%eax)
  80107d:	eb 56                	jmp    8010d5 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80107f:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801083:	75 1f                	jne    8010a4 <readline+0xc5>
  801085:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801089:	7e 19                	jle    8010a4 <readline+0xc5>
			if (echoing)
  80108b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80108f:	74 0e                	je     80109f <readline+0xc0>
				cputchar(c);
  801091:	83 ec 0c             	sub    $0xc,%esp
  801094:	ff 75 ec             	pushl  -0x14(%ebp)
  801097:	e8 3c f6 ff ff       	call   8006d8 <cputchar>
  80109c:	83 c4 10             	add    $0x10,%esp

			i--;
  80109f:	ff 4d f4             	decl   -0xc(%ebp)
  8010a2:	eb 31                	jmp    8010d5 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8010a4:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8010a8:	74 0a                	je     8010b4 <readline+0xd5>
  8010aa:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8010ae:	0f 85 61 ff ff ff    	jne    801015 <readline+0x36>
			if (echoing)
  8010b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8010b8:	74 0e                	je     8010c8 <readline+0xe9>
				cputchar(c);
  8010ba:	83 ec 0c             	sub    $0xc,%esp
  8010bd:	ff 75 ec             	pushl  -0x14(%ebp)
  8010c0:	e8 13 f6 ff ff       	call   8006d8 <cputchar>
  8010c5:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8010c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ce:	01 d0                	add    %edx,%eax
  8010d0:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8010d3:	eb 06                	jmp    8010db <readline+0xfc>
		}
	}
  8010d5:	e9 3b ff ff ff       	jmp    801015 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8010da:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8010db:	c9                   	leave  
  8010dc:	c3                   	ret    

008010dd <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8010dd:	55                   	push   %ebp
  8010de:	89 e5                	mov    %esp,%ebp
  8010e0:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8010e3:	e8 71 14 00 00       	call   802559 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8010e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010ec:	74 13                	je     801101 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8010ee:	83 ec 08             	sub    $0x8,%esp
  8010f1:	ff 75 08             	pushl  0x8(%ebp)
  8010f4:	68 50 31 80 00       	push   $0x803150
  8010f9:	e8 66 f8 ff ff       	call   800964 <cprintf>
  8010fe:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801101:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801108:	83 ec 0c             	sub    $0xc,%esp
  80110b:	6a 00                	push   $0x0
  80110d:	e8 5c f6 ff ff       	call   80076e <iscons>
  801112:	83 c4 10             	add    $0x10,%esp
  801115:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801118:	e8 03 f6 ff ff       	call   800720 <getchar>
  80111d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801120:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801124:	79 23                	jns    801149 <atomic_readline+0x6c>
			if (c != -E_EOF)
  801126:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80112a:	74 13                	je     80113f <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  80112c:	83 ec 08             	sub    $0x8,%esp
  80112f:	ff 75 ec             	pushl  -0x14(%ebp)
  801132:	68 53 31 80 00       	push   $0x803153
  801137:	e8 28 f8 ff ff       	call   800964 <cprintf>
  80113c:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80113f:	e8 2f 14 00 00       	call   802573 <sys_enable_interrupt>
			return;
  801144:	e9 9a 00 00 00       	jmp    8011e3 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801149:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80114d:	7e 34                	jle    801183 <atomic_readline+0xa6>
  80114f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801156:	7f 2b                	jg     801183 <atomic_readline+0xa6>
			if (echoing)
  801158:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80115c:	74 0e                	je     80116c <atomic_readline+0x8f>
				cputchar(c);
  80115e:	83 ec 0c             	sub    $0xc,%esp
  801161:	ff 75 ec             	pushl  -0x14(%ebp)
  801164:	e8 6f f5 ff ff       	call   8006d8 <cputchar>
  801169:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80116c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80116f:	8d 50 01             	lea    0x1(%eax),%edx
  801172:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801175:	89 c2                	mov    %eax,%edx
  801177:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117a:	01 d0                	add    %edx,%eax
  80117c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80117f:	88 10                	mov    %dl,(%eax)
  801181:	eb 5b                	jmp    8011de <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  801183:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801187:	75 1f                	jne    8011a8 <atomic_readline+0xcb>
  801189:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80118d:	7e 19                	jle    8011a8 <atomic_readline+0xcb>
			if (echoing)
  80118f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801193:	74 0e                	je     8011a3 <atomic_readline+0xc6>
				cputchar(c);
  801195:	83 ec 0c             	sub    $0xc,%esp
  801198:	ff 75 ec             	pushl  -0x14(%ebp)
  80119b:	e8 38 f5 ff ff       	call   8006d8 <cputchar>
  8011a0:	83 c4 10             	add    $0x10,%esp
			i--;
  8011a3:	ff 4d f4             	decl   -0xc(%ebp)
  8011a6:	eb 36                	jmp    8011de <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  8011a8:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8011ac:	74 0a                	je     8011b8 <atomic_readline+0xdb>
  8011ae:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8011b2:	0f 85 60 ff ff ff    	jne    801118 <atomic_readline+0x3b>
			if (echoing)
  8011b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011bc:	74 0e                	je     8011cc <atomic_readline+0xef>
				cputchar(c);
  8011be:	83 ec 0c             	sub    $0xc,%esp
  8011c1:	ff 75 ec             	pushl  -0x14(%ebp)
  8011c4:	e8 0f f5 ff ff       	call   8006d8 <cputchar>
  8011c9:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8011cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d2:	01 d0                	add    %edx,%eax
  8011d4:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8011d7:	e8 97 13 00 00       	call   802573 <sys_enable_interrupt>
			return;
  8011dc:	eb 05                	jmp    8011e3 <atomic_readline+0x106>
		}
	}
  8011de:	e9 35 ff ff ff       	jmp    801118 <atomic_readline+0x3b>
}
  8011e3:	c9                   	leave  
  8011e4:	c3                   	ret    

008011e5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8011e5:	55                   	push   %ebp
  8011e6:	89 e5                	mov    %esp,%ebp
  8011e8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8011eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011f2:	eb 06                	jmp    8011fa <strlen+0x15>
		n++;
  8011f4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011f7:	ff 45 08             	incl   0x8(%ebp)
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	84 c0                	test   %al,%al
  801201:	75 f1                	jne    8011f4 <strlen+0xf>
		n++;
	return n;
  801203:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801206:	c9                   	leave  
  801207:	c3                   	ret    

00801208 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801208:	55                   	push   %ebp
  801209:	89 e5                	mov    %esp,%ebp
  80120b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80120e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801215:	eb 09                	jmp    801220 <strnlen+0x18>
		n++;
  801217:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80121a:	ff 45 08             	incl   0x8(%ebp)
  80121d:	ff 4d 0c             	decl   0xc(%ebp)
  801220:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801224:	74 09                	je     80122f <strnlen+0x27>
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	8a 00                	mov    (%eax),%al
  80122b:	84 c0                	test   %al,%al
  80122d:	75 e8                	jne    801217 <strnlen+0xf>
		n++;
	return n;
  80122f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801232:	c9                   	leave  
  801233:	c3                   	ret    

00801234 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801234:	55                   	push   %ebp
  801235:	89 e5                	mov    %esp,%ebp
  801237:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
  80123d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801240:	90                   	nop
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	8d 50 01             	lea    0x1(%eax),%edx
  801247:	89 55 08             	mov    %edx,0x8(%ebp)
  80124a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80124d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801250:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801253:	8a 12                	mov    (%edx),%dl
  801255:	88 10                	mov    %dl,(%eax)
  801257:	8a 00                	mov    (%eax),%al
  801259:	84 c0                	test   %al,%al
  80125b:	75 e4                	jne    801241 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80125d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801260:	c9                   	leave  
  801261:	c3                   	ret    

00801262 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
  801265:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801268:	8b 45 08             	mov    0x8(%ebp),%eax
  80126b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80126e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801275:	eb 1f                	jmp    801296 <strncpy+0x34>
		*dst++ = *src;
  801277:	8b 45 08             	mov    0x8(%ebp),%eax
  80127a:	8d 50 01             	lea    0x1(%eax),%edx
  80127d:	89 55 08             	mov    %edx,0x8(%ebp)
  801280:	8b 55 0c             	mov    0xc(%ebp),%edx
  801283:	8a 12                	mov    (%edx),%dl
  801285:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801287:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128a:	8a 00                	mov    (%eax),%al
  80128c:	84 c0                	test   %al,%al
  80128e:	74 03                	je     801293 <strncpy+0x31>
			src++;
  801290:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801293:	ff 45 fc             	incl   -0x4(%ebp)
  801296:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801299:	3b 45 10             	cmp    0x10(%ebp),%eax
  80129c:	72 d9                	jb     801277 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80129e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012a1:	c9                   	leave  
  8012a2:	c3                   	ret    

008012a3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
  8012a6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8012a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8012af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012b3:	74 30                	je     8012e5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8012b5:	eb 16                	jmp    8012cd <strlcpy+0x2a>
			*dst++ = *src++;
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	8d 50 01             	lea    0x1(%eax),%edx
  8012bd:	89 55 08             	mov    %edx,0x8(%ebp)
  8012c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012c6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012c9:	8a 12                	mov    (%edx),%dl
  8012cb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8012cd:	ff 4d 10             	decl   0x10(%ebp)
  8012d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012d4:	74 09                	je     8012df <strlcpy+0x3c>
  8012d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d9:	8a 00                	mov    (%eax),%al
  8012db:	84 c0                	test   %al,%al
  8012dd:	75 d8                	jne    8012b7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8012df:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8012e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012eb:	29 c2                	sub    %eax,%edx
  8012ed:	89 d0                	mov    %edx,%eax
}
  8012ef:	c9                   	leave  
  8012f0:	c3                   	ret    

008012f1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8012f4:	eb 06                	jmp    8012fc <strcmp+0xb>
		p++, q++;
  8012f6:	ff 45 08             	incl   0x8(%ebp)
  8012f9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8012fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ff:	8a 00                	mov    (%eax),%al
  801301:	84 c0                	test   %al,%al
  801303:	74 0e                	je     801313 <strcmp+0x22>
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	8a 10                	mov    (%eax),%dl
  80130a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130d:	8a 00                	mov    (%eax),%al
  80130f:	38 c2                	cmp    %al,%dl
  801311:	74 e3                	je     8012f6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801313:	8b 45 08             	mov    0x8(%ebp),%eax
  801316:	8a 00                	mov    (%eax),%al
  801318:	0f b6 d0             	movzbl %al,%edx
  80131b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131e:	8a 00                	mov    (%eax),%al
  801320:	0f b6 c0             	movzbl %al,%eax
  801323:	29 c2                	sub    %eax,%edx
  801325:	89 d0                	mov    %edx,%eax
}
  801327:	5d                   	pop    %ebp
  801328:	c3                   	ret    

00801329 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801329:	55                   	push   %ebp
  80132a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80132c:	eb 09                	jmp    801337 <strncmp+0xe>
		n--, p++, q++;
  80132e:	ff 4d 10             	decl   0x10(%ebp)
  801331:	ff 45 08             	incl   0x8(%ebp)
  801334:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801337:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80133b:	74 17                	je     801354 <strncmp+0x2b>
  80133d:	8b 45 08             	mov    0x8(%ebp),%eax
  801340:	8a 00                	mov    (%eax),%al
  801342:	84 c0                	test   %al,%al
  801344:	74 0e                	je     801354 <strncmp+0x2b>
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	8a 10                	mov    (%eax),%dl
  80134b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134e:	8a 00                	mov    (%eax),%al
  801350:	38 c2                	cmp    %al,%dl
  801352:	74 da                	je     80132e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801354:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801358:	75 07                	jne    801361 <strncmp+0x38>
		return 0;
  80135a:	b8 00 00 00 00       	mov    $0x0,%eax
  80135f:	eb 14                	jmp    801375 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801361:	8b 45 08             	mov    0x8(%ebp),%eax
  801364:	8a 00                	mov    (%eax),%al
  801366:	0f b6 d0             	movzbl %al,%edx
  801369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136c:	8a 00                	mov    (%eax),%al
  80136e:	0f b6 c0             	movzbl %al,%eax
  801371:	29 c2                	sub    %eax,%edx
  801373:	89 d0                	mov    %edx,%eax
}
  801375:	5d                   	pop    %ebp
  801376:	c3                   	ret    

00801377 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
  80137a:	83 ec 04             	sub    $0x4,%esp
  80137d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801380:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801383:	eb 12                	jmp    801397 <strchr+0x20>
		if (*s == c)
  801385:	8b 45 08             	mov    0x8(%ebp),%eax
  801388:	8a 00                	mov    (%eax),%al
  80138a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80138d:	75 05                	jne    801394 <strchr+0x1d>
			return (char *) s;
  80138f:	8b 45 08             	mov    0x8(%ebp),%eax
  801392:	eb 11                	jmp    8013a5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801394:	ff 45 08             	incl   0x8(%ebp)
  801397:	8b 45 08             	mov    0x8(%ebp),%eax
  80139a:	8a 00                	mov    (%eax),%al
  80139c:	84 c0                	test   %al,%al
  80139e:	75 e5                	jne    801385 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8013a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013a5:	c9                   	leave  
  8013a6:	c3                   	ret    

008013a7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
  8013aa:	83 ec 04             	sub    $0x4,%esp
  8013ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013b3:	eb 0d                	jmp    8013c2 <strfind+0x1b>
		if (*s == c)
  8013b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b8:	8a 00                	mov    (%eax),%al
  8013ba:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8013bd:	74 0e                	je     8013cd <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8013bf:	ff 45 08             	incl   0x8(%ebp)
  8013c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c5:	8a 00                	mov    (%eax),%al
  8013c7:	84 c0                	test   %al,%al
  8013c9:	75 ea                	jne    8013b5 <strfind+0xe>
  8013cb:	eb 01                	jmp    8013ce <strfind+0x27>
		if (*s == c)
			break;
  8013cd:	90                   	nop
	return (char *) s;
  8013ce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013d1:	c9                   	leave  
  8013d2:	c3                   	ret    

008013d3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8013d3:	55                   	push   %ebp
  8013d4:	89 e5                	mov    %esp,%ebp
  8013d6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8013d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8013df:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8013e5:	eb 0e                	jmp    8013f5 <memset+0x22>
		*p++ = c;
  8013e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ea:	8d 50 01             	lea    0x1(%eax),%edx
  8013ed:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8013f5:	ff 4d f8             	decl   -0x8(%ebp)
  8013f8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8013fc:	79 e9                	jns    8013e7 <memset+0x14>
		*p++ = c;

	return v;
  8013fe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801401:	c9                   	leave  
  801402:	c3                   	ret    

00801403 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801403:	55                   	push   %ebp
  801404:	89 e5                	mov    %esp,%ebp
  801406:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801409:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80140f:	8b 45 08             	mov    0x8(%ebp),%eax
  801412:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801415:	eb 16                	jmp    80142d <memcpy+0x2a>
		*d++ = *s++;
  801417:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80141a:	8d 50 01             	lea    0x1(%eax),%edx
  80141d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801420:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801423:	8d 4a 01             	lea    0x1(%edx),%ecx
  801426:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801429:	8a 12                	mov    (%edx),%dl
  80142b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80142d:	8b 45 10             	mov    0x10(%ebp),%eax
  801430:	8d 50 ff             	lea    -0x1(%eax),%edx
  801433:	89 55 10             	mov    %edx,0x10(%ebp)
  801436:	85 c0                	test   %eax,%eax
  801438:	75 dd                	jne    801417 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80143a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80143d:	c9                   	leave  
  80143e:	c3                   	ret    

0080143f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80143f:	55                   	push   %ebp
  801440:	89 e5                	mov    %esp,%ebp
  801442:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  801445:	8b 45 0c             	mov    0xc(%ebp),%eax
  801448:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801451:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801454:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801457:	73 50                	jae    8014a9 <memmove+0x6a>
  801459:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80145c:	8b 45 10             	mov    0x10(%ebp),%eax
  80145f:	01 d0                	add    %edx,%eax
  801461:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801464:	76 43                	jbe    8014a9 <memmove+0x6a>
		s += n;
  801466:	8b 45 10             	mov    0x10(%ebp),%eax
  801469:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80146c:	8b 45 10             	mov    0x10(%ebp),%eax
  80146f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801472:	eb 10                	jmp    801484 <memmove+0x45>
			*--d = *--s;
  801474:	ff 4d f8             	decl   -0x8(%ebp)
  801477:	ff 4d fc             	decl   -0x4(%ebp)
  80147a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80147d:	8a 10                	mov    (%eax),%dl
  80147f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801482:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801484:	8b 45 10             	mov    0x10(%ebp),%eax
  801487:	8d 50 ff             	lea    -0x1(%eax),%edx
  80148a:	89 55 10             	mov    %edx,0x10(%ebp)
  80148d:	85 c0                	test   %eax,%eax
  80148f:	75 e3                	jne    801474 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801491:	eb 23                	jmp    8014b6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801493:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801496:	8d 50 01             	lea    0x1(%eax),%edx
  801499:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80149c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80149f:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014a2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014a5:	8a 12                	mov    (%edx),%dl
  8014a7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8014a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014af:	89 55 10             	mov    %edx,0x10(%ebp)
  8014b2:	85 c0                	test   %eax,%eax
  8014b4:	75 dd                	jne    801493 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8014b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014b9:	c9                   	leave  
  8014ba:	c3                   	ret    

008014bb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8014c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ca:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8014cd:	eb 2a                	jmp    8014f9 <memcmp+0x3e>
		if (*s1 != *s2)
  8014cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d2:	8a 10                	mov    (%eax),%dl
  8014d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014d7:	8a 00                	mov    (%eax),%al
  8014d9:	38 c2                	cmp    %al,%dl
  8014db:	74 16                	je     8014f3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8014dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014e0:	8a 00                	mov    (%eax),%al
  8014e2:	0f b6 d0             	movzbl %al,%edx
  8014e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014e8:	8a 00                	mov    (%eax),%al
  8014ea:	0f b6 c0             	movzbl %al,%eax
  8014ed:	29 c2                	sub    %eax,%edx
  8014ef:	89 d0                	mov    %edx,%eax
  8014f1:	eb 18                	jmp    80150b <memcmp+0x50>
		s1++, s2++;
  8014f3:	ff 45 fc             	incl   -0x4(%ebp)
  8014f6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8014f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014fc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014ff:	89 55 10             	mov    %edx,0x10(%ebp)
  801502:	85 c0                	test   %eax,%eax
  801504:	75 c9                	jne    8014cf <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801506:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80150b:	c9                   	leave  
  80150c:	c3                   	ret    

0080150d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80150d:	55                   	push   %ebp
  80150e:	89 e5                	mov    %esp,%ebp
  801510:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801513:	8b 55 08             	mov    0x8(%ebp),%edx
  801516:	8b 45 10             	mov    0x10(%ebp),%eax
  801519:	01 d0                	add    %edx,%eax
  80151b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80151e:	eb 15                	jmp    801535 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801520:	8b 45 08             	mov    0x8(%ebp),%eax
  801523:	8a 00                	mov    (%eax),%al
  801525:	0f b6 d0             	movzbl %al,%edx
  801528:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152b:	0f b6 c0             	movzbl %al,%eax
  80152e:	39 c2                	cmp    %eax,%edx
  801530:	74 0d                	je     80153f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801532:	ff 45 08             	incl   0x8(%ebp)
  801535:	8b 45 08             	mov    0x8(%ebp),%eax
  801538:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80153b:	72 e3                	jb     801520 <memfind+0x13>
  80153d:	eb 01                	jmp    801540 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80153f:	90                   	nop
	return (void *) s;
  801540:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801543:	c9                   	leave  
  801544:	c3                   	ret    

00801545 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
  801548:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80154b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801552:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801559:	eb 03                	jmp    80155e <strtol+0x19>
		s++;
  80155b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80155e:	8b 45 08             	mov    0x8(%ebp),%eax
  801561:	8a 00                	mov    (%eax),%al
  801563:	3c 20                	cmp    $0x20,%al
  801565:	74 f4                	je     80155b <strtol+0x16>
  801567:	8b 45 08             	mov    0x8(%ebp),%eax
  80156a:	8a 00                	mov    (%eax),%al
  80156c:	3c 09                	cmp    $0x9,%al
  80156e:	74 eb                	je     80155b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	8a 00                	mov    (%eax),%al
  801575:	3c 2b                	cmp    $0x2b,%al
  801577:	75 05                	jne    80157e <strtol+0x39>
		s++;
  801579:	ff 45 08             	incl   0x8(%ebp)
  80157c:	eb 13                	jmp    801591 <strtol+0x4c>
	else if (*s == '-')
  80157e:	8b 45 08             	mov    0x8(%ebp),%eax
  801581:	8a 00                	mov    (%eax),%al
  801583:	3c 2d                	cmp    $0x2d,%al
  801585:	75 0a                	jne    801591 <strtol+0x4c>
		s++, neg = 1;
  801587:	ff 45 08             	incl   0x8(%ebp)
  80158a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801591:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801595:	74 06                	je     80159d <strtol+0x58>
  801597:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80159b:	75 20                	jne    8015bd <strtol+0x78>
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a0:	8a 00                	mov    (%eax),%al
  8015a2:	3c 30                	cmp    $0x30,%al
  8015a4:	75 17                	jne    8015bd <strtol+0x78>
  8015a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a9:	40                   	inc    %eax
  8015aa:	8a 00                	mov    (%eax),%al
  8015ac:	3c 78                	cmp    $0x78,%al
  8015ae:	75 0d                	jne    8015bd <strtol+0x78>
		s += 2, base = 16;
  8015b0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8015b4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8015bb:	eb 28                	jmp    8015e5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8015bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015c1:	75 15                	jne    8015d8 <strtol+0x93>
  8015c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c6:	8a 00                	mov    (%eax),%al
  8015c8:	3c 30                	cmp    $0x30,%al
  8015ca:	75 0c                	jne    8015d8 <strtol+0x93>
		s++, base = 8;
  8015cc:	ff 45 08             	incl   0x8(%ebp)
  8015cf:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8015d6:	eb 0d                	jmp    8015e5 <strtol+0xa0>
	else if (base == 0)
  8015d8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015dc:	75 07                	jne    8015e5 <strtol+0xa0>
		base = 10;
  8015de:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8015e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e8:	8a 00                	mov    (%eax),%al
  8015ea:	3c 2f                	cmp    $0x2f,%al
  8015ec:	7e 19                	jle    801607 <strtol+0xc2>
  8015ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f1:	8a 00                	mov    (%eax),%al
  8015f3:	3c 39                	cmp    $0x39,%al
  8015f5:	7f 10                	jg     801607 <strtol+0xc2>
			dig = *s - '0';
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fa:	8a 00                	mov    (%eax),%al
  8015fc:	0f be c0             	movsbl %al,%eax
  8015ff:	83 e8 30             	sub    $0x30,%eax
  801602:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801605:	eb 42                	jmp    801649 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	8a 00                	mov    (%eax),%al
  80160c:	3c 60                	cmp    $0x60,%al
  80160e:	7e 19                	jle    801629 <strtol+0xe4>
  801610:	8b 45 08             	mov    0x8(%ebp),%eax
  801613:	8a 00                	mov    (%eax),%al
  801615:	3c 7a                	cmp    $0x7a,%al
  801617:	7f 10                	jg     801629 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801619:	8b 45 08             	mov    0x8(%ebp),%eax
  80161c:	8a 00                	mov    (%eax),%al
  80161e:	0f be c0             	movsbl %al,%eax
  801621:	83 e8 57             	sub    $0x57,%eax
  801624:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801627:	eb 20                	jmp    801649 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801629:	8b 45 08             	mov    0x8(%ebp),%eax
  80162c:	8a 00                	mov    (%eax),%al
  80162e:	3c 40                	cmp    $0x40,%al
  801630:	7e 39                	jle    80166b <strtol+0x126>
  801632:	8b 45 08             	mov    0x8(%ebp),%eax
  801635:	8a 00                	mov    (%eax),%al
  801637:	3c 5a                	cmp    $0x5a,%al
  801639:	7f 30                	jg     80166b <strtol+0x126>
			dig = *s - 'A' + 10;
  80163b:	8b 45 08             	mov    0x8(%ebp),%eax
  80163e:	8a 00                	mov    (%eax),%al
  801640:	0f be c0             	movsbl %al,%eax
  801643:	83 e8 37             	sub    $0x37,%eax
  801646:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80164f:	7d 19                	jge    80166a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801651:	ff 45 08             	incl   0x8(%ebp)
  801654:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801657:	0f af 45 10          	imul   0x10(%ebp),%eax
  80165b:	89 c2                	mov    %eax,%edx
  80165d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801660:	01 d0                	add    %edx,%eax
  801662:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801665:	e9 7b ff ff ff       	jmp    8015e5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80166a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80166b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80166f:	74 08                	je     801679 <strtol+0x134>
		*endptr = (char *) s;
  801671:	8b 45 0c             	mov    0xc(%ebp),%eax
  801674:	8b 55 08             	mov    0x8(%ebp),%edx
  801677:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801679:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80167d:	74 07                	je     801686 <strtol+0x141>
  80167f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801682:	f7 d8                	neg    %eax
  801684:	eb 03                	jmp    801689 <strtol+0x144>
  801686:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801689:	c9                   	leave  
  80168a:	c3                   	ret    

0080168b <ltostr>:

void
ltostr(long value, char *str)
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
  80168e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801691:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801698:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80169f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016a3:	79 13                	jns    8016b8 <ltostr+0x2d>
	{
		neg = 1;
  8016a5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8016ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016af:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8016b2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8016b5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8016c0:	99                   	cltd   
  8016c1:	f7 f9                	idiv   %ecx
  8016c3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8016c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c9:	8d 50 01             	lea    0x1(%eax),%edx
  8016cc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016cf:	89 c2                	mov    %eax,%edx
  8016d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d4:	01 d0                	add    %edx,%eax
  8016d6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016d9:	83 c2 30             	add    $0x30,%edx
  8016dc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8016de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016e1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8016e6:	f7 e9                	imul   %ecx
  8016e8:	c1 fa 02             	sar    $0x2,%edx
  8016eb:	89 c8                	mov    %ecx,%eax
  8016ed:	c1 f8 1f             	sar    $0x1f,%eax
  8016f0:	29 c2                	sub    %eax,%edx
  8016f2:	89 d0                	mov    %edx,%eax
  8016f4:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8016f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016fa:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8016ff:	f7 e9                	imul   %ecx
  801701:	c1 fa 02             	sar    $0x2,%edx
  801704:	89 c8                	mov    %ecx,%eax
  801706:	c1 f8 1f             	sar    $0x1f,%eax
  801709:	29 c2                	sub    %eax,%edx
  80170b:	89 d0                	mov    %edx,%eax
  80170d:	c1 e0 02             	shl    $0x2,%eax
  801710:	01 d0                	add    %edx,%eax
  801712:	01 c0                	add    %eax,%eax
  801714:	29 c1                	sub    %eax,%ecx
  801716:	89 ca                	mov    %ecx,%edx
  801718:	85 d2                	test   %edx,%edx
  80171a:	75 9c                	jne    8016b8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80171c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801723:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801726:	48                   	dec    %eax
  801727:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80172a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80172e:	74 3d                	je     80176d <ltostr+0xe2>
		start = 1 ;
  801730:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801737:	eb 34                	jmp    80176d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801739:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80173c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80173f:	01 d0                	add    %edx,%eax
  801741:	8a 00                	mov    (%eax),%al
  801743:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801746:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801749:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174c:	01 c2                	add    %eax,%edx
  80174e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801751:	8b 45 0c             	mov    0xc(%ebp),%eax
  801754:	01 c8                	add    %ecx,%eax
  801756:	8a 00                	mov    (%eax),%al
  801758:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80175a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80175d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801760:	01 c2                	add    %eax,%edx
  801762:	8a 45 eb             	mov    -0x15(%ebp),%al
  801765:	88 02                	mov    %al,(%edx)
		start++ ;
  801767:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80176a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80176d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801770:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801773:	7c c4                	jl     801739 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801775:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801778:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177b:	01 d0                	add    %edx,%eax
  80177d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801780:	90                   	nop
  801781:	c9                   	leave  
  801782:	c3                   	ret    

00801783 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
  801786:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801789:	ff 75 08             	pushl  0x8(%ebp)
  80178c:	e8 54 fa ff ff       	call   8011e5 <strlen>
  801791:	83 c4 04             	add    $0x4,%esp
  801794:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801797:	ff 75 0c             	pushl  0xc(%ebp)
  80179a:	e8 46 fa ff ff       	call   8011e5 <strlen>
  80179f:	83 c4 04             	add    $0x4,%esp
  8017a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8017a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8017ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017b3:	eb 17                	jmp    8017cc <strcconcat+0x49>
		final[s] = str1[s] ;
  8017b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017bb:	01 c2                	add    %eax,%edx
  8017bd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c3:	01 c8                	add    %ecx,%eax
  8017c5:	8a 00                	mov    (%eax),%al
  8017c7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8017c9:	ff 45 fc             	incl   -0x4(%ebp)
  8017cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017cf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8017d2:	7c e1                	jl     8017b5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8017d4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8017db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8017e2:	eb 1f                	jmp    801803 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8017e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017e7:	8d 50 01             	lea    0x1(%eax),%edx
  8017ea:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8017ed:	89 c2                	mov    %eax,%edx
  8017ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f2:	01 c2                	add    %eax,%edx
  8017f4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8017f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fa:	01 c8                	add    %ecx,%eax
  8017fc:	8a 00                	mov    (%eax),%al
  8017fe:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801800:	ff 45 f8             	incl   -0x8(%ebp)
  801803:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801806:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801809:	7c d9                	jl     8017e4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80180b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80180e:	8b 45 10             	mov    0x10(%ebp),%eax
  801811:	01 d0                	add    %edx,%eax
  801813:	c6 00 00             	movb   $0x0,(%eax)
}
  801816:	90                   	nop
  801817:	c9                   	leave  
  801818:	c3                   	ret    

00801819 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80181c:	8b 45 14             	mov    0x14(%ebp),%eax
  80181f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801825:	8b 45 14             	mov    0x14(%ebp),%eax
  801828:	8b 00                	mov    (%eax),%eax
  80182a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801831:	8b 45 10             	mov    0x10(%ebp),%eax
  801834:	01 d0                	add    %edx,%eax
  801836:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80183c:	eb 0c                	jmp    80184a <strsplit+0x31>
			*string++ = 0;
  80183e:	8b 45 08             	mov    0x8(%ebp),%eax
  801841:	8d 50 01             	lea    0x1(%eax),%edx
  801844:	89 55 08             	mov    %edx,0x8(%ebp)
  801847:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80184a:	8b 45 08             	mov    0x8(%ebp),%eax
  80184d:	8a 00                	mov    (%eax),%al
  80184f:	84 c0                	test   %al,%al
  801851:	74 18                	je     80186b <strsplit+0x52>
  801853:	8b 45 08             	mov    0x8(%ebp),%eax
  801856:	8a 00                	mov    (%eax),%al
  801858:	0f be c0             	movsbl %al,%eax
  80185b:	50                   	push   %eax
  80185c:	ff 75 0c             	pushl  0xc(%ebp)
  80185f:	e8 13 fb ff ff       	call   801377 <strchr>
  801864:	83 c4 08             	add    $0x8,%esp
  801867:	85 c0                	test   %eax,%eax
  801869:	75 d3                	jne    80183e <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  80186b:	8b 45 08             	mov    0x8(%ebp),%eax
  80186e:	8a 00                	mov    (%eax),%al
  801870:	84 c0                	test   %al,%al
  801872:	74 5a                	je     8018ce <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  801874:	8b 45 14             	mov    0x14(%ebp),%eax
  801877:	8b 00                	mov    (%eax),%eax
  801879:	83 f8 0f             	cmp    $0xf,%eax
  80187c:	75 07                	jne    801885 <strsplit+0x6c>
		{
			return 0;
  80187e:	b8 00 00 00 00       	mov    $0x0,%eax
  801883:	eb 66                	jmp    8018eb <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801885:	8b 45 14             	mov    0x14(%ebp),%eax
  801888:	8b 00                	mov    (%eax),%eax
  80188a:	8d 48 01             	lea    0x1(%eax),%ecx
  80188d:	8b 55 14             	mov    0x14(%ebp),%edx
  801890:	89 0a                	mov    %ecx,(%edx)
  801892:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801899:	8b 45 10             	mov    0x10(%ebp),%eax
  80189c:	01 c2                	add    %eax,%edx
  80189e:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018a3:	eb 03                	jmp    8018a8 <strsplit+0x8f>
			string++;
  8018a5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ab:	8a 00                	mov    (%eax),%al
  8018ad:	84 c0                	test   %al,%al
  8018af:	74 8b                	je     80183c <strsplit+0x23>
  8018b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b4:	8a 00                	mov    (%eax),%al
  8018b6:	0f be c0             	movsbl %al,%eax
  8018b9:	50                   	push   %eax
  8018ba:	ff 75 0c             	pushl  0xc(%ebp)
  8018bd:	e8 b5 fa ff ff       	call   801377 <strchr>
  8018c2:	83 c4 08             	add    $0x8,%esp
  8018c5:	85 c0                	test   %eax,%eax
  8018c7:	74 dc                	je     8018a5 <strsplit+0x8c>
			string++;
	}
  8018c9:	e9 6e ff ff ff       	jmp    80183c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8018ce:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8018cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8018d2:	8b 00                	mov    (%eax),%eax
  8018d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018db:	8b 45 10             	mov    0x10(%ebp),%eax
  8018de:	01 d0                	add    %edx,%eax
  8018e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8018e6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <malloc>:
int cnt_mem = 0;
int heap_mem[size_uhmem] = { 0 };
struct hmem heap_size[size_uhmem] = { 0 };
int check = 0;

void* malloc(uint32 size) {
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
  8018f0:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyNEXTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	//NEXT FIT
	if (sys_isUHeapPlacementStrategyNEXTFIT()) {
  8018f6:	e8 7d 0f 00 00       	call   802878 <sys_isUHeapPlacementStrategyNEXTFIT>
  8018fb:	85 c0                	test   %eax,%eax
  8018fd:	0f 84 6f 03 00 00    	je     801c72 <malloc+0x385>
		size = ROUNDUP(size, PAGE_SIZE);
  801903:	c7 45 84 00 10 00 00 	movl   $0x1000,-0x7c(%ebp)
  80190a:	8b 55 08             	mov    0x8(%ebp),%edx
  80190d:	8b 45 84             	mov    -0x7c(%ebp),%eax
  801910:	01 d0                	add    %edx,%eax
  801912:	48                   	dec    %eax
  801913:	89 45 80             	mov    %eax,-0x80(%ebp)
  801916:	8b 45 80             	mov    -0x80(%ebp),%eax
  801919:	ba 00 00 00 00       	mov    $0x0,%edx
  80191e:	f7 75 84             	divl   -0x7c(%ebp)
  801921:	8b 45 80             	mov    -0x80(%ebp),%eax
  801924:	29 d0                	sub    %edx,%eax
  801926:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801929:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80192d:	74 09                	je     801938 <malloc+0x4b>
  80192f:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801936:	76 0a                	jbe    801942 <malloc+0x55>
			return NULL;
  801938:	b8 00 00 00 00       	mov    $0x0,%eax
  80193d:	e9 4b 09 00 00       	jmp    80228d <malloc+0x9a0>
		}
		// first we can allocate by " Strategy Continues "
		if (ptr_uheap + size <= (uint32) USER_HEAP_MAX && !check) {
  801942:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801948:	8b 45 08             	mov    0x8(%ebp),%eax
  80194b:	01 d0                	add    %edx,%eax
  80194d:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801952:	0f 87 a2 00 00 00    	ja     8019fa <malloc+0x10d>
  801958:	a1 60 40 98 00       	mov    0x984060,%eax
  80195d:	85 c0                	test   %eax,%eax
  80195f:	0f 85 95 00 00 00    	jne    8019fa <malloc+0x10d>

			void* ret = (void *) ptr_uheap;
  801965:	a1 04 40 80 00       	mov    0x804004,%eax
  80196a:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			sys_allocateMem(ptr_uheap, size);
  801970:	a1 04 40 80 00       	mov    0x804004,%eax
  801975:	83 ec 08             	sub    $0x8,%esp
  801978:	ff 75 08             	pushl  0x8(%ebp)
  80197b:	50                   	push   %eax
  80197c:	e8 a3 0b 00 00       	call   802524 <sys_allocateMem>
  801981:	83 c4 10             	add    $0x10,%esp

			heap_size[cnt_mem].size = size;
  801984:	a1 40 40 80 00       	mov    0x804040,%eax
  801989:	8b 55 08             	mov    0x8(%ebp),%edx
  80198c:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801993:	a1 40 40 80 00       	mov    0x804040,%eax
  801998:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80199e:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
			cnt_mem++;
  8019a5:	a1 40 40 80 00       	mov    0x804040,%eax
  8019aa:	40                   	inc    %eax
  8019ab:	a3 40 40 80 00       	mov    %eax,0x804040
			int i = 0;
  8019b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  8019b7:	eb 2e                	jmp    8019e7 <malloc+0xfa>
			{

				heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8019b9:	a1 04 40 80 00       	mov    0x804004,%eax
  8019be:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] = 1;
  8019c3:	c1 e8 0c             	shr    $0xc,%eax
  8019c6:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  8019cd:	01 00 00 00 

				ptr_uheap += (uint32) PAGE_SIZE;
  8019d1:	a1 04 40 80 00       	mov    0x804004,%eax
  8019d6:	05 00 10 00 00       	add    $0x1000,%eax
  8019db:	a3 04 40 80 00       	mov    %eax,0x804004
			heap_size[cnt_mem].size = size;
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
			cnt_mem++;
			int i = 0;
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  8019e0:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  8019e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ea:	3b 45 08             	cmp    0x8(%ebp),%eax
  8019ed:	72 ca                	jb     8019b9 <malloc+0xcc>
						/ (uint32) PAGE_SIZE)] = 1;

				ptr_uheap += (uint32) PAGE_SIZE;
			}

			return ret;
  8019ef:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8019f5:	e9 93 08 00 00       	jmp    80228d <malloc+0x9a0>

		} else {
			// second we can allocate by " Strategy NEXTFIT "
			void* temp_end = NULL;
  8019fa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

			int check_start = 0;
  801a01:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			// check first that we used " Strategy Continues " before and not do it again and turn to NEXTFIT
			if (!check) {
  801a08:	a1 60 40 98 00       	mov    0x984060,%eax
  801a0d:	85 c0                	test   %eax,%eax
  801a0f:	75 1d                	jne    801a2e <malloc+0x141>
				ptr_uheap = (uint32) USER_HEAP_START;
  801a11:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  801a18:	00 00 80 
				check = 1;
  801a1b:	c7 05 60 40 98 00 01 	movl   $0x1,0x984060
  801a22:	00 00 00 
				check_start = 1;// to dont use second loop CZ ptr_uheap start from USER_HEAP_START
  801a25:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  801a2c:	eb 08                	jmp    801a36 <malloc+0x149>
			} else {
				temp_end = (void*) ptr_uheap;
  801a2e:	a1 04 40 80 00       	mov    0x804004,%eax
  801a33:	89 45 f0             	mov    %eax,-0x10(%ebp)

			}

			uint32 sz = 0;
  801a36:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
			int f = 0;
  801a3d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			uint32 ptr = ptr_uheap;
  801a44:	a1 04 40 80 00       	mov    0x804004,%eax
  801a49:	89 45 e0             	mov    %eax,-0x20(%ebp)
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  801a4c:	eb 4d                	jmp    801a9b <malloc+0x1ae>
				if (sz == size) {
  801a4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a51:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a54:	75 09                	jne    801a5f <malloc+0x172>
					f = 1;
  801a56:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  801a5d:	eb 45                	jmp    801aa4 <malloc+0x1b7>
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801a5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a62:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] == 0) {
  801a67:	c1 e8 0c             	shr    $0xc,%eax
			while (ptr < (uint32) USER_HEAP_MAX) {
				if (sz == size) {
					f = 1;
					break;
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801a6a:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  801a71:	85 c0                	test   %eax,%eax
  801a73:	75 10                	jne    801a85 <malloc+0x198>
						/ (uint32) PAGE_SIZE)] == 0) {

					sz += PAGE_SIZE;
  801a75:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
					ptr += PAGE_SIZE;
  801a7c:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  801a83:	eb 16                	jmp    801a9b <malloc+0x1ae>
				} else {
					sz = 0;
  801a85:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
					ptr += PAGE_SIZE;
  801a8c:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
					ptr_uheap = ptr;
  801a93:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a96:	a3 04 40 80 00       	mov    %eax,0x804004

			uint32 sz = 0;
			int f = 0;
			uint32 ptr = ptr_uheap;
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  801a9b:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  801aa2:	76 aa                	jbe    801a4e <malloc+0x161>
					ptr_uheap = ptr;
				}

			}

			if (f) {
  801aa4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801aa8:	0f 84 95 00 00 00    	je     801b43 <malloc+0x256>

				void* ret = (void *) ptr_uheap;
  801aae:	a1 04 40 80 00       	mov    0x804004,%eax
  801ab3:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

				sys_allocateMem(ptr_uheap, size);
  801ab9:	a1 04 40 80 00       	mov    0x804004,%eax
  801abe:	83 ec 08             	sub    $0x8,%esp
  801ac1:	ff 75 08             	pushl  0x8(%ebp)
  801ac4:	50                   	push   %eax
  801ac5:	e8 5a 0a 00 00       	call   802524 <sys_allocateMem>
  801aca:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  801acd:	a1 40 40 80 00       	mov    0x804040,%eax
  801ad2:	8b 55 08             	mov    0x8(%ebp),%edx
  801ad5:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801adc:	a1 40 40 80 00       	mov    0x804040,%eax
  801ae1:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801ae7:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
				cnt_mem++;
  801aee:	a1 40 40 80 00       	mov    0x804040,%eax
  801af3:	40                   	inc    %eax
  801af4:	a3 40 40 80 00       	mov    %eax,0x804040
				int i = 0;
  801af9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801b00:	eb 2e                	jmp    801b30 <malloc+0x243>
				{

					heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801b02:	a1 04 40 80 00       	mov    0x804004,%eax
  801b07:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  801b0c:	c1 e8 0c             	shr    $0xc,%eax
  801b0f:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  801b16:	01 00 00 00 

					ptr_uheap += (uint32) PAGE_SIZE;
  801b1a:	a1 04 40 80 00       	mov    0x804004,%eax
  801b1f:	05 00 10 00 00       	add    $0x1000,%eax
  801b24:	a3 04 40 80 00       	mov    %eax,0x804004
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
				cnt_mem++;
				int i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801b29:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801b30:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b33:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b36:	72 ca                	jb     801b02 <malloc+0x215>
							/ (uint32) PAGE_SIZE)] = 1;

					ptr_uheap += (uint32) PAGE_SIZE;
				}

				return ret;
  801b38:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  801b3e:	e9 4a 07 00 00       	jmp    80228d <malloc+0x9a0>

			} else {

				if (check_start) {
  801b43:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b47:	74 0a                	je     801b53 <malloc+0x266>

					return NULL;
  801b49:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4e:	e9 3a 07 00 00       	jmp    80228d <malloc+0x9a0>
				}

//////////////back loop////////////////

				uint32 sz = 0;
  801b53:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
				int f = 0;
  801b5a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				uint32 ptr = USER_HEAP_START;
  801b61:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
				ptr_uheap = USER_HEAP_START;
  801b68:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  801b6f:	00 00 80 
				while (ptr < (uint32) temp_end) {
  801b72:	eb 4d                	jmp    801bc1 <malloc+0x2d4>
					if (sz == size) {
  801b74:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b77:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b7a:	75 09                	jne    801b85 <malloc+0x298>
						f = 1;
  801b7c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
						break;
  801b83:	eb 44                	jmp    801bc9 <malloc+0x2dc>
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801b85:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b88:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] == 0) {
  801b8d:	c1 e8 0c             	shr    $0xc,%eax
				while (ptr < (uint32) temp_end) {
					if (sz == size) {
						f = 1;
						break;
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801b90:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  801b97:	85 c0                	test   %eax,%eax
  801b99:	75 10                	jne    801bab <malloc+0x2be>
							/ (uint32) PAGE_SIZE)] == 0) {

						sz += PAGE_SIZE;
  801b9b:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801ba2:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
  801ba9:	eb 16                	jmp    801bc1 <malloc+0x2d4>
					} else {
						sz = 0;
  801bab:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801bb2:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
						ptr_uheap = ptr;
  801bb9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801bbc:	a3 04 40 80 00       	mov    %eax,0x804004

				uint32 sz = 0;
				int f = 0;
				uint32 ptr = USER_HEAP_START;
				ptr_uheap = USER_HEAP_START;
				while (ptr < (uint32) temp_end) {
  801bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bc4:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801bc7:	72 ab                	jb     801b74 <malloc+0x287>
						ptr_uheap = ptr;
					}

				}

				if (f) {
  801bc9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801bcd:	0f 84 95 00 00 00    	je     801c68 <malloc+0x37b>

					void* ret = (void *) ptr_uheap;
  801bd3:	a1 04 40 80 00       	mov    0x804004,%eax
  801bd8:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

					sys_allocateMem(ptr_uheap, size);
  801bde:	a1 04 40 80 00       	mov    0x804004,%eax
  801be3:	83 ec 08             	sub    $0x8,%esp
  801be6:	ff 75 08             	pushl  0x8(%ebp)
  801be9:	50                   	push   %eax
  801bea:	e8 35 09 00 00       	call   802524 <sys_allocateMem>
  801bef:	83 c4 10             	add    $0x10,%esp

					heap_size[cnt_mem].size = size;
  801bf2:	a1 40 40 80 00       	mov    0x804040,%eax
  801bf7:	8b 55 08             	mov    0x8(%ebp),%edx
  801bfa:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801c01:	a1 40 40 80 00       	mov    0x804040,%eax
  801c06:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c0c:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
					cnt_mem++;
  801c13:	a1 40 40 80 00       	mov    0x804040,%eax
  801c18:	40                   	inc    %eax
  801c19:	a3 40 40 80 00       	mov    %eax,0x804040
					int i = 0;
  801c1e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

					for (; i < size; i += PAGE_SIZE)
  801c25:	eb 2e                	jmp    801c55 <malloc+0x368>
					{

						heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801c27:	a1 04 40 80 00       	mov    0x804004,%eax
  801c2c:	05 00 00 00 80       	add    $0x80000000,%eax
								/ (uint32) PAGE_SIZE)] = 1;
  801c31:	c1 e8 0c             	shr    $0xc,%eax
  801c34:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  801c3b:	01 00 00 00 

						ptr_uheap += (uint32) PAGE_SIZE;
  801c3f:	a1 04 40 80 00       	mov    0x804004,%eax
  801c44:	05 00 10 00 00       	add    $0x1000,%eax
  801c49:	a3 04 40 80 00       	mov    %eax,0x804004
					heap_size[cnt_mem].size = size;
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
					cnt_mem++;
					int i = 0;

					for (; i < size; i += PAGE_SIZE)
  801c4e:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  801c55:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801c58:	3b 45 08             	cmp    0x8(%ebp),%eax
  801c5b:	72 ca                	jb     801c27 <malloc+0x33a>
								/ (uint32) PAGE_SIZE)] = 1;

						ptr_uheap += (uint32) PAGE_SIZE;
					}

					return ret;
  801c5d:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801c63:	e9 25 06 00 00       	jmp    80228d <malloc+0x9a0>

				} else {

					return NULL;
  801c68:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6d:	e9 1b 06 00 00       	jmp    80228d <malloc+0x9a0>

		}

	}

	else if (sys_isUHeapPlacementStrategyBESTFIT()) {
  801c72:	e8 d0 0b 00 00       	call   802847 <sys_isUHeapPlacementStrategyBESTFIT>
  801c77:	85 c0                	test   %eax,%eax
  801c79:	0f 84 ba 01 00 00    	je     801e39 <malloc+0x54c>

		size = ROUNDUP(size, PAGE_SIZE);
  801c7f:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  801c86:	10 00 00 
  801c89:	8b 55 08             	mov    0x8(%ebp),%edx
  801c8c:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  801c92:	01 d0                	add    %edx,%eax
  801c94:	48                   	dec    %eax
  801c95:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  801c9b:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801ca1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca6:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  801cac:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801cb2:	29 d0                	sub    %edx,%eax
  801cb4:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801cb7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801cbb:	74 09                	je     801cc6 <malloc+0x3d9>
  801cbd:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801cc4:	76 0a                	jbe    801cd0 <malloc+0x3e3>
			return NULL;
  801cc6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ccb:	e9 bd 05 00 00       	jmp    80228d <malloc+0x9a0>
		}
		uint32 ptr = (uint32) USER_HEAP_START;
  801cd0:	c7 45 c8 00 00 00 80 	movl   $0x80000000,-0x38(%ebp)
		uint32 temp = 0;
  801cd7:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		uint32 min_sz = size_uhmem + 1;
  801cde:	c7 45 c0 01 00 02 00 	movl   $0x20001,-0x40(%ebp)
		uint32 count = 0;
  801ce5:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
		int i = 0;
  801cec:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf6:	c1 e8 0c             	shr    $0xc,%eax
  801cf9:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801cff:	e9 80 00 00 00       	jmp    801d84 <malloc+0x497>

			if (heap_mem[i] == 0) {
  801d04:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801d07:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  801d0e:	85 c0                	test   %eax,%eax
  801d10:	75 0c                	jne    801d1e <malloc+0x431>

				count++;
  801d12:	ff 45 bc             	incl   -0x44(%ebp)
				ptr += PAGE_SIZE;
  801d15:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801d1c:	eb 2d                	jmp    801d4b <malloc+0x45e>
			} else {
				if (num_p <= count && min_sz > count) {
  801d1e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801d24:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801d27:	77 14                	ja     801d3d <malloc+0x450>
  801d29:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801d2c:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801d2f:	76 0c                	jbe    801d3d <malloc+0x450>

					min_sz = count;
  801d31:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801d34:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801d37:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801d3a:	89 45 c4             	mov    %eax,-0x3c(%ebp)

				}
				count = 0;
  801d3d:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
				ptr += PAGE_SIZE;
  801d44:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
			}

			if (i == size_uhmem - 1) {
  801d4b:	81 7d b8 ff ff 01 00 	cmpl   $0x1ffff,-0x48(%ebp)
  801d52:	75 2d                	jne    801d81 <malloc+0x494>

				if (num_p <= count && min_sz > count) {
  801d54:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801d5a:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801d5d:	77 22                	ja     801d81 <malloc+0x494>
  801d5f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801d62:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801d65:	76 1a                	jbe    801d81 <malloc+0x494>

					min_sz = count;
  801d67:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801d6a:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801d6d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801d70:	89 45 c4             	mov    %eax,-0x3c(%ebp)
					count = 0;
  801d73:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
					ptr += PAGE_SIZE;
  801d7a:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801d81:	ff 45 b8             	incl   -0x48(%ebp)
  801d84:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801d87:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801d8c:	0f 86 72 ff ff ff    	jbe    801d04 <malloc+0x417>

			}

		}

		if (num_p > min_sz || temp == 0) {
  801d92:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801d98:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  801d9b:	77 06                	ja     801da3 <malloc+0x4b6>
  801d9d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801da1:	75 0a                	jne    801dad <malloc+0x4c0>
			return NULL;
  801da3:	b8 00 00 00 00       	mov    $0x0,%eax
  801da8:	e9 e0 04 00 00       	jmp    80228d <malloc+0x9a0>

		}

		temp = temp - (PAGE_SIZE * min_sz);
  801dad:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801db0:	c1 e0 0c             	shl    $0xc,%eax
  801db3:	29 45 c4             	sub    %eax,-0x3c(%ebp)
		void* ret = (void*) temp;
  801db6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801db9:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)

		sys_allocateMem(temp, size);
  801dbf:	83 ec 08             	sub    $0x8,%esp
  801dc2:	ff 75 08             	pushl  0x8(%ebp)
  801dc5:	ff 75 c4             	pushl  -0x3c(%ebp)
  801dc8:	e8 57 07 00 00       	call   802524 <sys_allocateMem>
  801dcd:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801dd0:	a1 40 40 80 00       	mov    0x804040,%eax
  801dd5:	8b 55 08             	mov    0x8(%ebp),%edx
  801dd8:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801ddf:	a1 40 40 80 00       	mov    0x804040,%eax
  801de4:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801de7:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
		cnt_mem++;
  801dee:	a1 40 40 80 00       	mov    0x804040,%eax
  801df3:	40                   	inc    %eax
  801df4:	a3 40 40 80 00       	mov    %eax,0x804040
		i = 0;
  801df9:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801e00:	eb 24                	jmp    801e26 <malloc+0x539>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801e02:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801e05:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801e0a:	c1 e8 0c             	shr    $0xc,%eax
  801e0d:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  801e14:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801e18:	81 45 c4 00 10 00 00 	addl   $0x1000,-0x3c(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801e1f:	81 45 b8 00 10 00 00 	addl   $0x1000,-0x48(%ebp)
  801e26:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801e29:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e2c:	72 d4                	jb     801e02 <malloc+0x515>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801e2e:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801e34:	e9 54 04 00 00       	jmp    80228d <malloc+0x9a0>

	} else if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801e39:	e8 d8 09 00 00       	call   802816 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e3e:	85 c0                	test   %eax,%eax
  801e40:	0f 84 88 01 00 00    	je     801fce <malloc+0x6e1>

		size = ROUNDUP(size, PAGE_SIZE);
  801e46:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  801e4d:	10 00 00 
  801e50:	8b 55 08             	mov    0x8(%ebp),%edx
  801e53:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  801e59:	01 d0                	add    %edx,%eax
  801e5b:	48                   	dec    %eax
  801e5c:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  801e62:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801e68:	ba 00 00 00 00       	mov    $0x0,%edx
  801e6d:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  801e73:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801e79:	29 d0                	sub    %edx,%eax
  801e7b:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801e7e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e82:	74 09                	je     801e8d <malloc+0x5a0>
  801e84:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801e8b:	76 0a                	jbe    801e97 <malloc+0x5aa>
			return NULL;
  801e8d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e92:	e9 f6 03 00 00       	jmp    80228d <malloc+0x9a0>
		}

		uint32 ptr = (uint32) USER_HEAP_START;
  801e97:	c7 45 b4 00 00 00 80 	movl   $0x80000000,-0x4c(%ebp)
		uint32 temp = 0;
  801e9e:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
		uint32 found = 0;
  801ea5:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		uint32 count = 0;
  801eac:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
		int i = 0;
  801eb3:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801eba:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebd:	c1 e8 0c             	shr    $0xc,%eax
  801ec0:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

		for (; i < size_uhmem; i++) {
  801ec6:	eb 5a                	jmp    801f22 <malloc+0x635>

			if (heap_mem[i] == 0) {
  801ec8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801ecb:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  801ed2:	85 c0                	test   %eax,%eax
  801ed4:	75 0c                	jne    801ee2 <malloc+0x5f5>

				count++;
  801ed6:	ff 45 a8             	incl   -0x58(%ebp)
				ptr += PAGE_SIZE;
  801ed9:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
  801ee0:	eb 22                	jmp    801f04 <malloc+0x617>
			} else {
				if (num_p <= count) {
  801ee2:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801ee8:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801eeb:	77 09                	ja     801ef6 <malloc+0x609>

					found = 1;
  801eed:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)

					break;
  801ef4:	eb 36                	jmp    801f2c <malloc+0x63f>
				}
				count = 0;
  801ef6:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
				ptr += PAGE_SIZE;
  801efd:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
			}

			if (i == size_uhmem - 1) {
  801f04:	81 7d a4 ff ff 01 00 	cmpl   $0x1ffff,-0x5c(%ebp)
  801f0b:	75 12                	jne    801f1f <malloc+0x632>

				if (num_p <= count) {
  801f0d:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801f13:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801f16:	77 07                	ja     801f1f <malloc+0x632>

					found = 1;
  801f18:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
		uint32 found = 0;
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		for (; i < size_uhmem; i++) {
  801f1f:	ff 45 a4             	incl   -0x5c(%ebp)
  801f22:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801f25:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801f2a:	76 9c                	jbe    801ec8 <malloc+0x5db>

			}

		}

		if (!found) {
  801f2c:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  801f30:	75 0a                	jne    801f3c <malloc+0x64f>
			return NULL;
  801f32:	b8 00 00 00 00       	mov    $0x0,%eax
  801f37:	e9 51 03 00 00       	jmp    80228d <malloc+0x9a0>

		}

		temp = ptr;
  801f3c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801f3f:	89 45 b0             	mov    %eax,-0x50(%ebp)
		temp = temp - (PAGE_SIZE * count);
  801f42:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801f45:	c1 e0 0c             	shl    $0xc,%eax
  801f48:	29 45 b0             	sub    %eax,-0x50(%ebp)
		void* ret = (void*) temp;
  801f4b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801f4e:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)

		sys_allocateMem(temp, size);
  801f54:	83 ec 08             	sub    $0x8,%esp
  801f57:	ff 75 08             	pushl  0x8(%ebp)
  801f5a:	ff 75 b0             	pushl  -0x50(%ebp)
  801f5d:	e8 c2 05 00 00       	call   802524 <sys_allocateMem>
  801f62:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801f65:	a1 40 40 80 00       	mov    0x804040,%eax
  801f6a:	8b 55 08             	mov    0x8(%ebp),%edx
  801f6d:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801f74:	a1 40 40 80 00       	mov    0x804040,%eax
  801f79:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801f7c:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
		cnt_mem++;
  801f83:	a1 40 40 80 00       	mov    0x804040,%eax
  801f88:	40                   	inc    %eax
  801f89:	a3 40 40 80 00       	mov    %eax,0x804040
		i = 0;
  801f8e:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801f95:	eb 24                	jmp    801fbb <malloc+0x6ce>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801f97:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801f9a:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801f9f:	c1 e8 0c             	shr    $0xc,%eax
  801fa2:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  801fa9:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801fad:	81 45 b0 00 10 00 00 	addl   $0x1000,-0x50(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801fb4:	81 45 a4 00 10 00 00 	addl   $0x1000,-0x5c(%ebp)
  801fbb:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801fbe:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fc1:	72 d4                	jb     801f97 <malloc+0x6aa>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801fc3:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  801fc9:	e9 bf 02 00 00       	jmp    80228d <malloc+0x9a0>

	}
	else if(sys_isUHeapPlacementStrategyWORSTFIT())
  801fce:	e8 d6 08 00 00       	call   8028a9 <sys_isUHeapPlacementStrategyWORSTFIT>
  801fd3:	85 c0                	test   %eax,%eax
  801fd5:	0f 84 ba 01 00 00    	je     802195 <malloc+0x8a8>
	{
		size = ROUNDUP(size, PAGE_SIZE);
  801fdb:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  801fe2:	10 00 00 
  801fe5:	8b 55 08             	mov    0x8(%ebp),%edx
  801fe8:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  801fee:	01 d0                	add    %edx,%eax
  801ff0:	48                   	dec    %eax
  801ff1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  801ff7:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  801ffd:	ba 00 00 00 00       	mov    $0x0,%edx
  802002:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  802008:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  80200e:	29 d0                	sub    %edx,%eax
  802010:	89 45 08             	mov    %eax,0x8(%ebp)

				if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  802013:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802017:	74 09                	je     802022 <malloc+0x735>
  802019:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  802020:	76 0a                	jbe    80202c <malloc+0x73f>
					return NULL;
  802022:	b8 00 00 00 00       	mov    $0x0,%eax
  802027:	e9 61 02 00 00       	jmp    80228d <malloc+0x9a0>
				}
				uint32 ptr = (uint32) USER_HEAP_START;
  80202c:	c7 45 a0 00 00 00 80 	movl   $0x80000000,-0x60(%ebp)
				uint32 temp = 0;
  802033:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
				uint32 max_sz = -1;
  80203a:	c7 45 98 ff ff ff ff 	movl   $0xffffffff,-0x68(%ebp)
				uint32 count = 0;
  802041:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
				int i = 0;
  802048:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				uint32 num_p = size / PAGE_SIZE;
  80204f:	8b 45 08             	mov    0x8(%ebp),%eax
  802052:	c1 e8 0c             	shr    $0xc,%eax
  802055:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  80205b:	e9 80 00 00 00       	jmp    8020e0 <malloc+0x7f3>

					if (heap_mem[i] == 0) {
  802060:	8b 45 90             	mov    -0x70(%ebp),%eax
  802063:	8b 04 85 60 40 80 00 	mov    0x804060(,%eax,4),%eax
  80206a:	85 c0                	test   %eax,%eax
  80206c:	75 0c                	jne    80207a <malloc+0x78d>

						count++;
  80206e:	ff 45 94             	incl   -0x6c(%ebp)
						ptr += PAGE_SIZE;
  802071:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
  802078:	eb 2d                	jmp    8020a7 <malloc+0x7ba>
					} else {
						if (num_p <= count && max_sz < count) {
  80207a:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  802080:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  802083:	77 14                	ja     802099 <malloc+0x7ac>
  802085:	8b 45 98             	mov    -0x68(%ebp),%eax
  802088:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  80208b:	73 0c                	jae    802099 <malloc+0x7ac>

							max_sz = count;
  80208d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802090:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  802093:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802096:	89 45 9c             	mov    %eax,-0x64(%ebp)

						}
						count = 0;
  802099:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
						ptr += PAGE_SIZE;
  8020a0:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
					}

					if (i == size_uhmem - 1) {
  8020a7:	81 7d 90 ff ff 01 00 	cmpl   $0x1ffff,-0x70(%ebp)
  8020ae:	75 2d                	jne    8020dd <malloc+0x7f0>

						if (num_p <= count && max_sz > count) {
  8020b0:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  8020b6:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  8020b9:	77 22                	ja     8020dd <malloc+0x7f0>
  8020bb:	8b 45 98             	mov    -0x68(%ebp),%eax
  8020be:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  8020c1:	76 1a                	jbe    8020dd <malloc+0x7f0>

							max_sz = count;
  8020c3:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8020c6:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  8020c9:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8020cc:	89 45 9c             	mov    %eax,-0x64(%ebp)
							count = 0;
  8020cf:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
							ptr += PAGE_SIZE;
  8020d6:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
				uint32 count = 0;
				int i = 0;
				uint32 num_p = size / PAGE_SIZE;

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  8020dd:	ff 45 90             	incl   -0x70(%ebp)
  8020e0:	8b 45 90             	mov    -0x70(%ebp),%eax
  8020e3:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  8020e8:	0f 86 72 ff ff ff    	jbe    802060 <malloc+0x773>

					}

				}

				if (num_p > max_sz || temp == 0) {
  8020ee:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  8020f4:	3b 45 98             	cmp    -0x68(%ebp),%eax
  8020f7:	77 06                	ja     8020ff <malloc+0x812>
  8020f9:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  8020fd:	75 0a                	jne    802109 <malloc+0x81c>
					return NULL;
  8020ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802104:	e9 84 01 00 00       	jmp    80228d <malloc+0x9a0>

				}

				temp = temp - (PAGE_SIZE * max_sz);
  802109:	8b 45 98             	mov    -0x68(%ebp),%eax
  80210c:	c1 e0 0c             	shl    $0xc,%eax
  80210f:	29 45 9c             	sub    %eax,-0x64(%ebp)
				void* ret = (void*) temp;
  802112:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802115:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

				sys_allocateMem(temp, size);
  80211b:	83 ec 08             	sub    $0x8,%esp
  80211e:	ff 75 08             	pushl  0x8(%ebp)
  802121:	ff 75 9c             	pushl  -0x64(%ebp)
  802124:	e8 fb 03 00 00       	call   802524 <sys_allocateMem>
  802129:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  80212c:	a1 40 40 80 00       	mov    0x804040,%eax
  802131:	8b 55 08             	mov    0x8(%ebp),%edx
  802134:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
				heap_size[cnt_mem].vir = (void*) temp;
  80213b:	a1 40 40 80 00       	mov    0x804040,%eax
  802140:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802143:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
				cnt_mem++;
  80214a:	a1 40 40 80 00       	mov    0x804040,%eax
  80214f:	40                   	inc    %eax
  802150:	a3 40 40 80 00       	mov    %eax,0x804040
				i = 0;
  802155:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  80215c:	eb 24                	jmp    802182 <malloc+0x895>
				{

					heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  80215e:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802161:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  802166:	c1 e8 0c             	shr    $0xc,%eax
  802169:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  802170:	01 00 00 00 

					temp += (uint32) PAGE_SIZE;
  802174:	81 45 9c 00 10 00 00 	addl   $0x1000,-0x64(%ebp)
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) temp;
				cnt_mem++;
				i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  80217b:	81 45 90 00 10 00 00 	addl   $0x1000,-0x70(%ebp)
  802182:	8b 45 90             	mov    -0x70(%ebp),%eax
  802185:	3b 45 08             	cmp    0x8(%ebp),%eax
  802188:	72 d4                	jb     80215e <malloc+0x871>

					temp += (uint32) PAGE_SIZE;
				}

				//cprintf("\n size = %d.........vir= %d  \n",num_p,((uint32) ret-USER_HEAP_START)/PAGE_SIZE);
				return ret;
  80218a:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  802190:	e9 f8 00 00 00       	jmp    80228d <malloc+0x9a0>

	}
// this is to make malloc is work
	void* ret = NULL;
  802195:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
	size = ROUNDUP(size, PAGE_SIZE);
  80219c:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  8021a3:	10 00 00 
  8021a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8021a9:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  8021af:	01 d0                	add    %edx,%eax
  8021b1:	48                   	dec    %eax
  8021b2:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  8021b8:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  8021be:	ba 00 00 00 00       	mov    $0x0,%edx
  8021c3:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  8021c9:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  8021cf:	29 d0                	sub    %edx,%eax
  8021d1:	89 45 08             	mov    %eax,0x8(%ebp)

	if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  8021d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021d8:	74 09                	je     8021e3 <malloc+0x8f6>
  8021da:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8021e1:	76 0a                	jbe    8021ed <malloc+0x900>
		return NULL;
  8021e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e8:	e9 a0 00 00 00       	jmp    80228d <malloc+0x9a0>
	}

	if (ptr_uheap + size <= (uint32) USER_HEAP_MAX) {
  8021ed:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8021f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f6:	01 d0                	add    %edx,%eax
  8021f8:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8021fd:	0f 87 87 00 00 00    	ja     80228a <malloc+0x99d>

		ret = (void *) ptr_uheap;
  802203:	a1 04 40 80 00       	mov    0x804004,%eax
  802208:	89 45 8c             	mov    %eax,-0x74(%ebp)
		sys_allocateMem(ptr_uheap, size);
  80220b:	a1 04 40 80 00       	mov    0x804004,%eax
  802210:	83 ec 08             	sub    $0x8,%esp
  802213:	ff 75 08             	pushl  0x8(%ebp)
  802216:	50                   	push   %eax
  802217:	e8 08 03 00 00       	call   802524 <sys_allocateMem>
  80221c:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  80221f:	a1 40 40 80 00       	mov    0x804040,%eax
  802224:	8b 55 08             	mov    0x8(%ebp),%edx
  802227:	89 14 c5 64 40 88 00 	mov    %edx,0x884064(,%eax,8)
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
  80222e:	a1 40 40 80 00       	mov    0x804040,%eax
  802233:	8b 15 04 40 80 00    	mov    0x804004,%edx
  802239:	89 14 c5 60 40 88 00 	mov    %edx,0x884060(,%eax,8)
		cnt_mem++;
  802240:	a1 40 40 80 00       	mov    0x804040,%eax
  802245:	40                   	inc    %eax
  802246:	a3 40 40 80 00       	mov    %eax,0x804040
		int i = 0;
  80224b:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)

		for (; i < size; i += PAGE_SIZE)
  802252:	eb 2e                	jmp    802282 <malloc+0x995>
		{

			heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  802254:	a1 04 40 80 00       	mov    0x804004,%eax
  802259:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  80225e:	c1 e8 0c             	shr    $0xc,%eax
  802261:	c7 04 85 60 40 80 00 	movl   $0x1,0x804060(,%eax,4)
  802268:	01 00 00 00 

			ptr_uheap += (uint32) PAGE_SIZE;
  80226c:	a1 04 40 80 00       	mov    0x804004,%eax
  802271:	05 00 10 00 00       	add    $0x1000,%eax
  802276:	a3 04 40 80 00       	mov    %eax,0x804004
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
		cnt_mem++;
		int i = 0;

		for (; i < size; i += PAGE_SIZE)
  80227b:	81 45 88 00 10 00 00 	addl   $0x1000,-0x78(%ebp)
  802282:	8b 45 88             	mov    -0x78(%ebp),%eax
  802285:	3b 45 08             	cmp    0x8(%ebp),%eax
  802288:	72 ca                	jb     802254 <malloc+0x967>
					/ (uint32) PAGE_SIZE)] = 1;

			ptr_uheap += (uint32) PAGE_SIZE;
		}
	}
	return ret;
  80228a:	8b 45 8c             	mov    -0x74(%ebp),%eax

	//TODO: [PROJECT 2016 - BONUS2] Apply FIRST FIT and WORST FIT policies

//return 0;

}
  80228d:	c9                   	leave  
  80228e:	c3                   	ret    

0080228f <free>:
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address) {
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
  802292:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
  802295:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; inx < cnt_mem; inx++) {
  80229c:	e9 c1 00 00 00       	jmp    802362 <free+0xd3>
		if (heap_size[inx].vir == virtual_address) {
  8022a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a4:	8b 04 c5 60 40 88 00 	mov    0x884060(,%eax,8),%eax
  8022ab:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022ae:	0f 85 ab 00 00 00    	jne    80235f <free+0xd0>

			if (heap_size[inx].size == 0) {
  8022b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b7:	8b 04 c5 64 40 88 00 	mov    0x884064(,%eax,8),%eax
  8022be:	85 c0                	test   %eax,%eax
  8022c0:	75 21                	jne    8022e3 <free+0x54>
				heap_size[inx].size = 0;
  8022c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c5:	c7 04 c5 64 40 88 00 	movl   $0x0,0x884064(,%eax,8)
  8022cc:	00 00 00 00 
				heap_size[inx].vir = NULL;
  8022d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d3:	c7 04 c5 60 40 88 00 	movl   $0x0,0x884060(,%eax,8)
  8022da:	00 00 00 00 
				return;
  8022de:	e9 8d 00 00 00       	jmp    802370 <free+0xe1>

			}

			sys_freeMem((uint32) virtual_address, heap_size[inx].size);
  8022e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e6:	8b 14 c5 64 40 88 00 	mov    0x884064(,%eax,8),%edx
  8022ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f0:	83 ec 08             	sub    $0x8,%esp
  8022f3:	52                   	push   %edx
  8022f4:	50                   	push   %eax
  8022f5:	e8 0e 02 00 00       	call   802508 <sys_freeMem>
  8022fa:	83 c4 10             	add    $0x10,%esp

			int i = 0;
  8022fd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
  802304:	8b 45 08             	mov    0x8(%ebp),%eax
  802307:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  80230a:	eb 24                	jmp    802330 <free+0xa1>
			{
				heap_mem[(int) (((uint32) va - USER_HEAP_START) / PAGE_SIZE)] =
  80230c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80230f:	05 00 00 00 80       	add    $0x80000000,%eax
  802314:	c1 e8 0c             	shr    $0xc,%eax
  802317:	c7 04 85 60 40 80 00 	movl   $0x0,0x804060(,%eax,4)
  80231e:	00 00 00 00 
						0;

				va += PAGE_SIZE;
  802322:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
			sys_freeMem((uint32) virtual_address, heap_size[inx].size);

			int i = 0;
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  802329:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  802330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802333:	8b 14 c5 64 40 88 00 	mov    0x884064(,%eax,8),%edx
  80233a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233d:	39 c2                	cmp    %eax,%edx
  80233f:	77 cb                	ja     80230c <free+0x7d>

				va += PAGE_SIZE;

			}

			heap_size[inx].size = 0;
  802341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802344:	c7 04 c5 64 40 88 00 	movl   $0x0,0x884064(,%eax,8)
  80234b:	00 00 00 00 
			heap_size[inx].vir = NULL;
  80234f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802352:	c7 04 c5 60 40 88 00 	movl   $0x0,0x884060(,%eax,8)
  802359:	00 00 00 00 
			break;
  80235d:	eb 11                	jmp    802370 <free+0xe1>
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
	for (; inx < cnt_mem; inx++) {
  80235f:	ff 45 f4             	incl   -0xc(%ebp)
  802362:	a1 40 40 80 00       	mov    0x804040,%eax
  802367:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  80236a:	0f 8c 31 ff ff ff    	jl     8022a1 <free+0x12>
	}

	//get the size of the given allocation using its address
	//you need to call sys_freeMem()

}
  802370:	c9                   	leave  
  802371:	c3                   	ret    

00802372 <realloc>:
//  Hint: you may need to use the sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size) {
  802372:	55                   	push   %ebp
  802373:	89 e5                	mov    %esp,%ebp
  802375:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2016 - BONUS4] realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802378:	83 ec 04             	sub    $0x4,%esp
  80237b:	68 64 31 80 00       	push   $0x803164
  802380:	68 1c 02 00 00       	push   $0x21c
  802385:	68 8a 31 80 00       	push   $0x80318a
  80238a:	e8 aa e4 ff ff       	call   800839 <_panic>

0080238f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80238f:	55                   	push   %ebp
  802390:	89 e5                	mov    %esp,%ebp
  802392:	57                   	push   %edi
  802393:	56                   	push   %esi
  802394:	53                   	push   %ebx
  802395:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802398:	8b 45 08             	mov    0x8(%ebp),%eax
  80239b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80239e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023a1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023a4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8023a7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8023aa:	cd 30                	int    $0x30
  8023ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8023af:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8023b2:	83 c4 10             	add    $0x10,%esp
  8023b5:	5b                   	pop    %ebx
  8023b6:	5e                   	pop    %esi
  8023b7:	5f                   	pop    %edi
  8023b8:	5d                   	pop    %ebp
  8023b9:	c3                   	ret    

008023ba <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  8023ba:	55                   	push   %ebp
  8023bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  8023bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	ff 75 0c             	pushl  0xc(%ebp)
  8023c9:	50                   	push   %eax
  8023ca:	6a 00                	push   $0x0
  8023cc:	e8 be ff ff ff       	call   80238f <syscall>
  8023d1:	83 c4 18             	add    $0x18,%esp
}
  8023d4:	90                   	nop
  8023d5:	c9                   	leave  
  8023d6:	c3                   	ret    

008023d7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8023d7:	55                   	push   %ebp
  8023d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8023da:	6a 00                	push   $0x0
  8023dc:	6a 00                	push   $0x0
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 01                	push   $0x1
  8023e6:	e8 a4 ff ff ff       	call   80238f <syscall>
  8023eb:	83 c4 18             	add    $0x18,%esp
}
  8023ee:	c9                   	leave  
  8023ef:	c3                   	ret    

008023f0 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8023f0:	55                   	push   %ebp
  8023f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8023f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f6:	6a 00                	push   $0x0
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	50                   	push   %eax
  8023ff:	6a 03                	push   $0x3
  802401:	e8 89 ff ff ff       	call   80238f <syscall>
  802406:	83 c4 18             	add    $0x18,%esp
}
  802409:	c9                   	leave  
  80240a:	c3                   	ret    

0080240b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80240b:	55                   	push   %ebp
  80240c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80240e:	6a 00                	push   $0x0
  802410:	6a 00                	push   $0x0
  802412:	6a 00                	push   $0x0
  802414:	6a 00                	push   $0x0
  802416:	6a 00                	push   $0x0
  802418:	6a 02                	push   $0x2
  80241a:	e8 70 ff ff ff       	call   80238f <syscall>
  80241f:	83 c4 18             	add    $0x18,%esp
}
  802422:	c9                   	leave  
  802423:	c3                   	ret    

00802424 <sys_env_exit>:

void sys_env_exit(void)
{
  802424:	55                   	push   %ebp
  802425:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  802427:	6a 00                	push   $0x0
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	6a 04                	push   $0x4
  802433:	e8 57 ff ff ff       	call   80238f <syscall>
  802438:	83 c4 18             	add    $0x18,%esp
}
  80243b:	90                   	nop
  80243c:	c9                   	leave  
  80243d:	c3                   	ret    

0080243e <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  80243e:	55                   	push   %ebp
  80243f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802441:	8b 55 0c             	mov    0xc(%ebp),%edx
  802444:	8b 45 08             	mov    0x8(%ebp),%eax
  802447:	6a 00                	push   $0x0
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	52                   	push   %edx
  80244e:	50                   	push   %eax
  80244f:	6a 05                	push   $0x5
  802451:	e8 39 ff ff ff       	call   80238f <syscall>
  802456:	83 c4 18             	add    $0x18,%esp
}
  802459:	c9                   	leave  
  80245a:	c3                   	ret    

0080245b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80245b:	55                   	push   %ebp
  80245c:	89 e5                	mov    %esp,%ebp
  80245e:	56                   	push   %esi
  80245f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802460:	8b 75 18             	mov    0x18(%ebp),%esi
  802463:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802466:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802469:	8b 55 0c             	mov    0xc(%ebp),%edx
  80246c:	8b 45 08             	mov    0x8(%ebp),%eax
  80246f:	56                   	push   %esi
  802470:	53                   	push   %ebx
  802471:	51                   	push   %ecx
  802472:	52                   	push   %edx
  802473:	50                   	push   %eax
  802474:	6a 06                	push   $0x6
  802476:	e8 14 ff ff ff       	call   80238f <syscall>
  80247b:	83 c4 18             	add    $0x18,%esp
}
  80247e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802481:	5b                   	pop    %ebx
  802482:	5e                   	pop    %esi
  802483:	5d                   	pop    %ebp
  802484:	c3                   	ret    

00802485 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802485:	55                   	push   %ebp
  802486:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802488:	8b 55 0c             	mov    0xc(%ebp),%edx
  80248b:	8b 45 08             	mov    0x8(%ebp),%eax
  80248e:	6a 00                	push   $0x0
  802490:	6a 00                	push   $0x0
  802492:	6a 00                	push   $0x0
  802494:	52                   	push   %edx
  802495:	50                   	push   %eax
  802496:	6a 07                	push   $0x7
  802498:	e8 f2 fe ff ff       	call   80238f <syscall>
  80249d:	83 c4 18             	add    $0x18,%esp
}
  8024a0:	c9                   	leave  
  8024a1:	c3                   	ret    

008024a2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8024a2:	55                   	push   %ebp
  8024a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8024a5:	6a 00                	push   $0x0
  8024a7:	6a 00                	push   $0x0
  8024a9:	6a 00                	push   $0x0
  8024ab:	ff 75 0c             	pushl  0xc(%ebp)
  8024ae:	ff 75 08             	pushl  0x8(%ebp)
  8024b1:	6a 08                	push   $0x8
  8024b3:	e8 d7 fe ff ff       	call   80238f <syscall>
  8024b8:	83 c4 18             	add    $0x18,%esp
}
  8024bb:	c9                   	leave  
  8024bc:	c3                   	ret    

008024bd <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8024bd:	55                   	push   %ebp
  8024be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8024c0:	6a 00                	push   $0x0
  8024c2:	6a 00                	push   $0x0
  8024c4:	6a 00                	push   $0x0
  8024c6:	6a 00                	push   $0x0
  8024c8:	6a 00                	push   $0x0
  8024ca:	6a 09                	push   $0x9
  8024cc:	e8 be fe ff ff       	call   80238f <syscall>
  8024d1:	83 c4 18             	add    $0x18,%esp
}
  8024d4:	c9                   	leave  
  8024d5:	c3                   	ret    

008024d6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8024d6:	55                   	push   %ebp
  8024d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8024d9:	6a 00                	push   $0x0
  8024db:	6a 00                	push   $0x0
  8024dd:	6a 00                	push   $0x0
  8024df:	6a 00                	push   $0x0
  8024e1:	6a 00                	push   $0x0
  8024e3:	6a 0a                	push   $0xa
  8024e5:	e8 a5 fe ff ff       	call   80238f <syscall>
  8024ea:	83 c4 18             	add    $0x18,%esp
}
  8024ed:	c9                   	leave  
  8024ee:	c3                   	ret    

008024ef <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8024ef:	55                   	push   %ebp
  8024f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8024f2:	6a 00                	push   $0x0
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 00                	push   $0x0
  8024f8:	6a 00                	push   $0x0
  8024fa:	6a 00                	push   $0x0
  8024fc:	6a 0b                	push   $0xb
  8024fe:	e8 8c fe ff ff       	call   80238f <syscall>
  802503:	83 c4 18             	add    $0x18,%esp
}
  802506:	c9                   	leave  
  802507:	c3                   	ret    

00802508 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  802508:	55                   	push   %ebp
  802509:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  80250b:	6a 00                	push   $0x0
  80250d:	6a 00                	push   $0x0
  80250f:	6a 00                	push   $0x0
  802511:	ff 75 0c             	pushl  0xc(%ebp)
  802514:	ff 75 08             	pushl  0x8(%ebp)
  802517:	6a 0d                	push   $0xd
  802519:	e8 71 fe ff ff       	call   80238f <syscall>
  80251e:	83 c4 18             	add    $0x18,%esp
	return;
  802521:	90                   	nop
}
  802522:	c9                   	leave  
  802523:	c3                   	ret    

00802524 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  802524:	55                   	push   %ebp
  802525:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  802527:	6a 00                	push   $0x0
  802529:	6a 00                	push   $0x0
  80252b:	6a 00                	push   $0x0
  80252d:	ff 75 0c             	pushl  0xc(%ebp)
  802530:	ff 75 08             	pushl  0x8(%ebp)
  802533:	6a 0e                	push   $0xe
  802535:	e8 55 fe ff ff       	call   80238f <syscall>
  80253a:	83 c4 18             	add    $0x18,%esp
	return ;
  80253d:	90                   	nop
}
  80253e:	c9                   	leave  
  80253f:	c3                   	ret    

00802540 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802540:	55                   	push   %ebp
  802541:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802543:	6a 00                	push   $0x0
  802545:	6a 00                	push   $0x0
  802547:	6a 00                	push   $0x0
  802549:	6a 00                	push   $0x0
  80254b:	6a 00                	push   $0x0
  80254d:	6a 0c                	push   $0xc
  80254f:	e8 3b fe ff ff       	call   80238f <syscall>
  802554:	83 c4 18             	add    $0x18,%esp
}
  802557:	c9                   	leave  
  802558:	c3                   	ret    

00802559 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802559:	55                   	push   %ebp
  80255a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80255c:	6a 00                	push   $0x0
  80255e:	6a 00                	push   $0x0
  802560:	6a 00                	push   $0x0
  802562:	6a 00                	push   $0x0
  802564:	6a 00                	push   $0x0
  802566:	6a 10                	push   $0x10
  802568:	e8 22 fe ff ff       	call   80238f <syscall>
  80256d:	83 c4 18             	add    $0x18,%esp
}
  802570:	90                   	nop
  802571:	c9                   	leave  
  802572:	c3                   	ret    

00802573 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802573:	55                   	push   %ebp
  802574:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802576:	6a 00                	push   $0x0
  802578:	6a 00                	push   $0x0
  80257a:	6a 00                	push   $0x0
  80257c:	6a 00                	push   $0x0
  80257e:	6a 00                	push   $0x0
  802580:	6a 11                	push   $0x11
  802582:	e8 08 fe ff ff       	call   80238f <syscall>
  802587:	83 c4 18             	add    $0x18,%esp
}
  80258a:	90                   	nop
  80258b:	c9                   	leave  
  80258c:	c3                   	ret    

0080258d <sys_cputc>:


void
sys_cputc(const char c)
{
  80258d:	55                   	push   %ebp
  80258e:	89 e5                	mov    %esp,%ebp
  802590:	83 ec 04             	sub    $0x4,%esp
  802593:	8b 45 08             	mov    0x8(%ebp),%eax
  802596:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802599:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80259d:	6a 00                	push   $0x0
  80259f:	6a 00                	push   $0x0
  8025a1:	6a 00                	push   $0x0
  8025a3:	6a 00                	push   $0x0
  8025a5:	50                   	push   %eax
  8025a6:	6a 12                	push   $0x12
  8025a8:	e8 e2 fd ff ff       	call   80238f <syscall>
  8025ad:	83 c4 18             	add    $0x18,%esp
}
  8025b0:	90                   	nop
  8025b1:	c9                   	leave  
  8025b2:	c3                   	ret    

008025b3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8025b3:	55                   	push   %ebp
  8025b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8025b6:	6a 00                	push   $0x0
  8025b8:	6a 00                	push   $0x0
  8025ba:	6a 00                	push   $0x0
  8025bc:	6a 00                	push   $0x0
  8025be:	6a 00                	push   $0x0
  8025c0:	6a 13                	push   $0x13
  8025c2:	e8 c8 fd ff ff       	call   80238f <syscall>
  8025c7:	83 c4 18             	add    $0x18,%esp
}
  8025ca:	90                   	nop
  8025cb:	c9                   	leave  
  8025cc:	c3                   	ret    

008025cd <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8025cd:	55                   	push   %ebp
  8025ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8025d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d3:	6a 00                	push   $0x0
  8025d5:	6a 00                	push   $0x0
  8025d7:	6a 00                	push   $0x0
  8025d9:	ff 75 0c             	pushl  0xc(%ebp)
  8025dc:	50                   	push   %eax
  8025dd:	6a 14                	push   $0x14
  8025df:	e8 ab fd ff ff       	call   80238f <syscall>
  8025e4:	83 c4 18             	add    $0x18,%esp
}
  8025e7:	c9                   	leave  
  8025e8:	c3                   	ret    

008025e9 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  8025e9:	55                   	push   %ebp
  8025ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  8025ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ef:	6a 00                	push   $0x0
  8025f1:	6a 00                	push   $0x0
  8025f3:	6a 00                	push   $0x0
  8025f5:	6a 00                	push   $0x0
  8025f7:	50                   	push   %eax
  8025f8:	6a 17                	push   $0x17
  8025fa:	e8 90 fd ff ff       	call   80238f <syscall>
  8025ff:	83 c4 18             	add    $0x18,%esp
}
  802602:	c9                   	leave  
  802603:	c3                   	ret    

00802604 <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  802604:	55                   	push   %ebp
  802605:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  802607:	8b 45 08             	mov    0x8(%ebp),%eax
  80260a:	6a 00                	push   $0x0
  80260c:	6a 00                	push   $0x0
  80260e:	6a 00                	push   $0x0
  802610:	6a 00                	push   $0x0
  802612:	50                   	push   %eax
  802613:	6a 15                	push   $0x15
  802615:	e8 75 fd ff ff       	call   80238f <syscall>
  80261a:	83 c4 18             	add    $0x18,%esp
}
  80261d:	90                   	nop
  80261e:	c9                   	leave  
  80261f:	c3                   	ret    

00802620 <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  802620:	55                   	push   %ebp
  802621:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  802623:	8b 45 08             	mov    0x8(%ebp),%eax
  802626:	6a 00                	push   $0x0
  802628:	6a 00                	push   $0x0
  80262a:	6a 00                	push   $0x0
  80262c:	6a 00                	push   $0x0
  80262e:	50                   	push   %eax
  80262f:	6a 16                	push   $0x16
  802631:	e8 59 fd ff ff       	call   80238f <syscall>
  802636:	83 c4 18             	add    $0x18,%esp
}
  802639:	90                   	nop
  80263a:	c9                   	leave  
  80263b:	c3                   	ret    

0080263c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  80263c:	55                   	push   %ebp
  80263d:	89 e5                	mov    %esp,%ebp
  80263f:	83 ec 04             	sub    $0x4,%esp
  802642:	8b 45 10             	mov    0x10(%ebp),%eax
  802645:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  802648:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80264b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80264f:	8b 45 08             	mov    0x8(%ebp),%eax
  802652:	6a 00                	push   $0x0
  802654:	51                   	push   %ecx
  802655:	52                   	push   %edx
  802656:	ff 75 0c             	pushl  0xc(%ebp)
  802659:	50                   	push   %eax
  80265a:	6a 18                	push   $0x18
  80265c:	e8 2e fd ff ff       	call   80238f <syscall>
  802661:	83 c4 18             	add    $0x18,%esp
}
  802664:	c9                   	leave  
  802665:	c3                   	ret    

00802666 <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  802666:	55                   	push   %ebp
  802667:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  802669:	8b 55 0c             	mov    0xc(%ebp),%edx
  80266c:	8b 45 08             	mov    0x8(%ebp),%eax
  80266f:	6a 00                	push   $0x0
  802671:	6a 00                	push   $0x0
  802673:	6a 00                	push   $0x0
  802675:	52                   	push   %edx
  802676:	50                   	push   %eax
  802677:	6a 19                	push   $0x19
  802679:	e8 11 fd ff ff       	call   80238f <syscall>
  80267e:	83 c4 18             	add    $0x18,%esp
}
  802681:	c9                   	leave  
  802682:	c3                   	ret    

00802683 <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  802683:	55                   	push   %ebp
  802684:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  802686:	8b 45 08             	mov    0x8(%ebp),%eax
  802689:	6a 00                	push   $0x0
  80268b:	6a 00                	push   $0x0
  80268d:	6a 00                	push   $0x0
  80268f:	6a 00                	push   $0x0
  802691:	50                   	push   %eax
  802692:	6a 1a                	push   $0x1a
  802694:	e8 f6 fc ff ff       	call   80238f <syscall>
  802699:	83 c4 18             	add    $0x18,%esp
}
  80269c:	c9                   	leave  
  80269d:	c3                   	ret    

0080269e <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  80269e:	55                   	push   %ebp
  80269f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  8026a1:	6a 00                	push   $0x0
  8026a3:	6a 00                	push   $0x0
  8026a5:	6a 00                	push   $0x0
  8026a7:	6a 00                	push   $0x0
  8026a9:	6a 00                	push   $0x0
  8026ab:	6a 1b                	push   $0x1b
  8026ad:	e8 dd fc ff ff       	call   80238f <syscall>
  8026b2:	83 c4 18             	add    $0x18,%esp
}
  8026b5:	c9                   	leave  
  8026b6:	c3                   	ret    

008026b7 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8026b7:	55                   	push   %ebp
  8026b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8026ba:	6a 00                	push   $0x0
  8026bc:	6a 00                	push   $0x0
  8026be:	6a 00                	push   $0x0
  8026c0:	6a 00                	push   $0x0
  8026c2:	6a 00                	push   $0x0
  8026c4:	6a 1c                	push   $0x1c
  8026c6:	e8 c4 fc ff ff       	call   80238f <syscall>
  8026cb:	83 c4 18             	add    $0x18,%esp
}
  8026ce:	c9                   	leave  
  8026cf:	c3                   	ret    

008026d0 <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  8026d0:	55                   	push   %ebp
  8026d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  8026d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d6:	6a 00                	push   $0x0
  8026d8:	6a 00                	push   $0x0
  8026da:	6a 00                	push   $0x0
  8026dc:	ff 75 0c             	pushl  0xc(%ebp)
  8026df:	50                   	push   %eax
  8026e0:	6a 1d                	push   $0x1d
  8026e2:	e8 a8 fc ff ff       	call   80238f <syscall>
  8026e7:	83 c4 18             	add    $0x18,%esp
}
  8026ea:	c9                   	leave  
  8026eb:	c3                   	ret    

008026ec <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8026ec:	55                   	push   %ebp
  8026ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8026ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f2:	6a 00                	push   $0x0
  8026f4:	6a 00                	push   $0x0
  8026f6:	6a 00                	push   $0x0
  8026f8:	6a 00                	push   $0x0
  8026fa:	50                   	push   %eax
  8026fb:	6a 1e                	push   $0x1e
  8026fd:	e8 8d fc ff ff       	call   80238f <syscall>
  802702:	83 c4 18             	add    $0x18,%esp
}
  802705:	90                   	nop
  802706:	c9                   	leave  
  802707:	c3                   	ret    

00802708 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  802708:	55                   	push   %ebp
  802709:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  80270b:	8b 45 08             	mov    0x8(%ebp),%eax
  80270e:	6a 00                	push   $0x0
  802710:	6a 00                	push   $0x0
  802712:	6a 00                	push   $0x0
  802714:	6a 00                	push   $0x0
  802716:	50                   	push   %eax
  802717:	6a 1f                	push   $0x1f
  802719:	e8 71 fc ff ff       	call   80238f <syscall>
  80271e:	83 c4 18             	add    $0x18,%esp
}
  802721:	90                   	nop
  802722:	c9                   	leave  
  802723:	c3                   	ret    

00802724 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  802724:	55                   	push   %ebp
  802725:	89 e5                	mov    %esp,%ebp
  802727:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80272a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80272d:	8d 50 04             	lea    0x4(%eax),%edx
  802730:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802733:	6a 00                	push   $0x0
  802735:	6a 00                	push   $0x0
  802737:	6a 00                	push   $0x0
  802739:	52                   	push   %edx
  80273a:	50                   	push   %eax
  80273b:	6a 20                	push   $0x20
  80273d:	e8 4d fc ff ff       	call   80238f <syscall>
  802742:	83 c4 18             	add    $0x18,%esp
	return result;
  802745:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802748:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80274b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80274e:	89 01                	mov    %eax,(%ecx)
  802750:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802753:	8b 45 08             	mov    0x8(%ebp),%eax
  802756:	c9                   	leave  
  802757:	c2 04 00             	ret    $0x4

0080275a <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80275a:	55                   	push   %ebp
  80275b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80275d:	6a 00                	push   $0x0
  80275f:	6a 00                	push   $0x0
  802761:	ff 75 10             	pushl  0x10(%ebp)
  802764:	ff 75 0c             	pushl  0xc(%ebp)
  802767:	ff 75 08             	pushl  0x8(%ebp)
  80276a:	6a 0f                	push   $0xf
  80276c:	e8 1e fc ff ff       	call   80238f <syscall>
  802771:	83 c4 18             	add    $0x18,%esp
	return ;
  802774:	90                   	nop
}
  802775:	c9                   	leave  
  802776:	c3                   	ret    

00802777 <sys_rcr2>:
uint32 sys_rcr2()
{
  802777:	55                   	push   %ebp
  802778:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80277a:	6a 00                	push   $0x0
  80277c:	6a 00                	push   $0x0
  80277e:	6a 00                	push   $0x0
  802780:	6a 00                	push   $0x0
  802782:	6a 00                	push   $0x0
  802784:	6a 21                	push   $0x21
  802786:	e8 04 fc ff ff       	call   80238f <syscall>
  80278b:	83 c4 18             	add    $0x18,%esp
}
  80278e:	c9                   	leave  
  80278f:	c3                   	ret    

00802790 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802790:	55                   	push   %ebp
  802791:	89 e5                	mov    %esp,%ebp
  802793:	83 ec 04             	sub    $0x4,%esp
  802796:	8b 45 08             	mov    0x8(%ebp),%eax
  802799:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80279c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8027a0:	6a 00                	push   $0x0
  8027a2:	6a 00                	push   $0x0
  8027a4:	6a 00                	push   $0x0
  8027a6:	6a 00                	push   $0x0
  8027a8:	50                   	push   %eax
  8027a9:	6a 22                	push   $0x22
  8027ab:	e8 df fb ff ff       	call   80238f <syscall>
  8027b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8027b3:	90                   	nop
}
  8027b4:	c9                   	leave  
  8027b5:	c3                   	ret    

008027b6 <rsttst>:
void rsttst()
{
  8027b6:	55                   	push   %ebp
  8027b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8027b9:	6a 00                	push   $0x0
  8027bb:	6a 00                	push   $0x0
  8027bd:	6a 00                	push   $0x0
  8027bf:	6a 00                	push   $0x0
  8027c1:	6a 00                	push   $0x0
  8027c3:	6a 24                	push   $0x24
  8027c5:	e8 c5 fb ff ff       	call   80238f <syscall>
  8027ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8027cd:	90                   	nop
}
  8027ce:	c9                   	leave  
  8027cf:	c3                   	ret    

008027d0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8027d0:	55                   	push   %ebp
  8027d1:	89 e5                	mov    %esp,%ebp
  8027d3:	83 ec 04             	sub    $0x4,%esp
  8027d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8027d9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8027dc:	8b 55 18             	mov    0x18(%ebp),%edx
  8027df:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8027e3:	52                   	push   %edx
  8027e4:	50                   	push   %eax
  8027e5:	ff 75 10             	pushl  0x10(%ebp)
  8027e8:	ff 75 0c             	pushl  0xc(%ebp)
  8027eb:	ff 75 08             	pushl  0x8(%ebp)
  8027ee:	6a 23                	push   $0x23
  8027f0:	e8 9a fb ff ff       	call   80238f <syscall>
  8027f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8027f8:	90                   	nop
}
  8027f9:	c9                   	leave  
  8027fa:	c3                   	ret    

008027fb <chktst>:
void chktst(uint32 n)
{
  8027fb:	55                   	push   %ebp
  8027fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8027fe:	6a 00                	push   $0x0
  802800:	6a 00                	push   $0x0
  802802:	6a 00                	push   $0x0
  802804:	6a 00                	push   $0x0
  802806:	ff 75 08             	pushl  0x8(%ebp)
  802809:	6a 25                	push   $0x25
  80280b:	e8 7f fb ff ff       	call   80238f <syscall>
  802810:	83 c4 18             	add    $0x18,%esp
	return ;
  802813:	90                   	nop
}
  802814:	c9                   	leave  
  802815:	c3                   	ret    

00802816 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802816:	55                   	push   %ebp
  802817:	89 e5                	mov    %esp,%ebp
  802819:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80281c:	6a 00                	push   $0x0
  80281e:	6a 00                	push   $0x0
  802820:	6a 00                	push   $0x0
  802822:	6a 00                	push   $0x0
  802824:	6a 00                	push   $0x0
  802826:	6a 26                	push   $0x26
  802828:	e8 62 fb ff ff       	call   80238f <syscall>
  80282d:	83 c4 18             	add    $0x18,%esp
  802830:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802833:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802837:	75 07                	jne    802840 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802839:	b8 01 00 00 00       	mov    $0x1,%eax
  80283e:	eb 05                	jmp    802845 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802840:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802845:	c9                   	leave  
  802846:	c3                   	ret    

00802847 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802847:	55                   	push   %ebp
  802848:	89 e5                	mov    %esp,%ebp
  80284a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80284d:	6a 00                	push   $0x0
  80284f:	6a 00                	push   $0x0
  802851:	6a 00                	push   $0x0
  802853:	6a 00                	push   $0x0
  802855:	6a 00                	push   $0x0
  802857:	6a 26                	push   $0x26
  802859:	e8 31 fb ff ff       	call   80238f <syscall>
  80285e:	83 c4 18             	add    $0x18,%esp
  802861:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802864:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802868:	75 07                	jne    802871 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80286a:	b8 01 00 00 00       	mov    $0x1,%eax
  80286f:	eb 05                	jmp    802876 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802871:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802876:	c9                   	leave  
  802877:	c3                   	ret    

00802878 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802878:	55                   	push   %ebp
  802879:	89 e5                	mov    %esp,%ebp
  80287b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80287e:	6a 00                	push   $0x0
  802880:	6a 00                	push   $0x0
  802882:	6a 00                	push   $0x0
  802884:	6a 00                	push   $0x0
  802886:	6a 00                	push   $0x0
  802888:	6a 26                	push   $0x26
  80288a:	e8 00 fb ff ff       	call   80238f <syscall>
  80288f:	83 c4 18             	add    $0x18,%esp
  802892:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802895:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802899:	75 07                	jne    8028a2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80289b:	b8 01 00 00 00       	mov    $0x1,%eax
  8028a0:	eb 05                	jmp    8028a7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8028a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028a7:	c9                   	leave  
  8028a8:	c3                   	ret    

008028a9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8028a9:	55                   	push   %ebp
  8028aa:	89 e5                	mov    %esp,%ebp
  8028ac:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028af:	6a 00                	push   $0x0
  8028b1:	6a 00                	push   $0x0
  8028b3:	6a 00                	push   $0x0
  8028b5:	6a 00                	push   $0x0
  8028b7:	6a 00                	push   $0x0
  8028b9:	6a 26                	push   $0x26
  8028bb:	e8 cf fa ff ff       	call   80238f <syscall>
  8028c0:	83 c4 18             	add    $0x18,%esp
  8028c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8028c6:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8028ca:	75 07                	jne    8028d3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8028cc:	b8 01 00 00 00       	mov    $0x1,%eax
  8028d1:	eb 05                	jmp    8028d8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8028d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028d8:	c9                   	leave  
  8028d9:	c3                   	ret    

008028da <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8028da:	55                   	push   %ebp
  8028db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8028dd:	6a 00                	push   $0x0
  8028df:	6a 00                	push   $0x0
  8028e1:	6a 00                	push   $0x0
  8028e3:	6a 00                	push   $0x0
  8028e5:	ff 75 08             	pushl  0x8(%ebp)
  8028e8:	6a 27                	push   $0x27
  8028ea:	e8 a0 fa ff ff       	call   80238f <syscall>
  8028ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8028f2:	90                   	nop
}
  8028f3:	c9                   	leave  
  8028f4:	c3                   	ret    
  8028f5:	66 90                	xchg   %ax,%ax
  8028f7:	90                   	nop

008028f8 <__udivdi3>:
  8028f8:	55                   	push   %ebp
  8028f9:	57                   	push   %edi
  8028fa:	56                   	push   %esi
  8028fb:	53                   	push   %ebx
  8028fc:	83 ec 1c             	sub    $0x1c,%esp
  8028ff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802903:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802907:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80290b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80290f:	89 ca                	mov    %ecx,%edx
  802911:	89 f8                	mov    %edi,%eax
  802913:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802917:	85 f6                	test   %esi,%esi
  802919:	75 2d                	jne    802948 <__udivdi3+0x50>
  80291b:	39 cf                	cmp    %ecx,%edi
  80291d:	77 65                	ja     802984 <__udivdi3+0x8c>
  80291f:	89 fd                	mov    %edi,%ebp
  802921:	85 ff                	test   %edi,%edi
  802923:	75 0b                	jne    802930 <__udivdi3+0x38>
  802925:	b8 01 00 00 00       	mov    $0x1,%eax
  80292a:	31 d2                	xor    %edx,%edx
  80292c:	f7 f7                	div    %edi
  80292e:	89 c5                	mov    %eax,%ebp
  802930:	31 d2                	xor    %edx,%edx
  802932:	89 c8                	mov    %ecx,%eax
  802934:	f7 f5                	div    %ebp
  802936:	89 c1                	mov    %eax,%ecx
  802938:	89 d8                	mov    %ebx,%eax
  80293a:	f7 f5                	div    %ebp
  80293c:	89 cf                	mov    %ecx,%edi
  80293e:	89 fa                	mov    %edi,%edx
  802940:	83 c4 1c             	add    $0x1c,%esp
  802943:	5b                   	pop    %ebx
  802944:	5e                   	pop    %esi
  802945:	5f                   	pop    %edi
  802946:	5d                   	pop    %ebp
  802947:	c3                   	ret    
  802948:	39 ce                	cmp    %ecx,%esi
  80294a:	77 28                	ja     802974 <__udivdi3+0x7c>
  80294c:	0f bd fe             	bsr    %esi,%edi
  80294f:	83 f7 1f             	xor    $0x1f,%edi
  802952:	75 40                	jne    802994 <__udivdi3+0x9c>
  802954:	39 ce                	cmp    %ecx,%esi
  802956:	72 0a                	jb     802962 <__udivdi3+0x6a>
  802958:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80295c:	0f 87 9e 00 00 00    	ja     802a00 <__udivdi3+0x108>
  802962:	b8 01 00 00 00       	mov    $0x1,%eax
  802967:	89 fa                	mov    %edi,%edx
  802969:	83 c4 1c             	add    $0x1c,%esp
  80296c:	5b                   	pop    %ebx
  80296d:	5e                   	pop    %esi
  80296e:	5f                   	pop    %edi
  80296f:	5d                   	pop    %ebp
  802970:	c3                   	ret    
  802971:	8d 76 00             	lea    0x0(%esi),%esi
  802974:	31 ff                	xor    %edi,%edi
  802976:	31 c0                	xor    %eax,%eax
  802978:	89 fa                	mov    %edi,%edx
  80297a:	83 c4 1c             	add    $0x1c,%esp
  80297d:	5b                   	pop    %ebx
  80297e:	5e                   	pop    %esi
  80297f:	5f                   	pop    %edi
  802980:	5d                   	pop    %ebp
  802981:	c3                   	ret    
  802982:	66 90                	xchg   %ax,%ax
  802984:	89 d8                	mov    %ebx,%eax
  802986:	f7 f7                	div    %edi
  802988:	31 ff                	xor    %edi,%edi
  80298a:	89 fa                	mov    %edi,%edx
  80298c:	83 c4 1c             	add    $0x1c,%esp
  80298f:	5b                   	pop    %ebx
  802990:	5e                   	pop    %esi
  802991:	5f                   	pop    %edi
  802992:	5d                   	pop    %ebp
  802993:	c3                   	ret    
  802994:	bd 20 00 00 00       	mov    $0x20,%ebp
  802999:	89 eb                	mov    %ebp,%ebx
  80299b:	29 fb                	sub    %edi,%ebx
  80299d:	89 f9                	mov    %edi,%ecx
  80299f:	d3 e6                	shl    %cl,%esi
  8029a1:	89 c5                	mov    %eax,%ebp
  8029a3:	88 d9                	mov    %bl,%cl
  8029a5:	d3 ed                	shr    %cl,%ebp
  8029a7:	89 e9                	mov    %ebp,%ecx
  8029a9:	09 f1                	or     %esi,%ecx
  8029ab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8029af:	89 f9                	mov    %edi,%ecx
  8029b1:	d3 e0                	shl    %cl,%eax
  8029b3:	89 c5                	mov    %eax,%ebp
  8029b5:	89 d6                	mov    %edx,%esi
  8029b7:	88 d9                	mov    %bl,%cl
  8029b9:	d3 ee                	shr    %cl,%esi
  8029bb:	89 f9                	mov    %edi,%ecx
  8029bd:	d3 e2                	shl    %cl,%edx
  8029bf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8029c3:	88 d9                	mov    %bl,%cl
  8029c5:	d3 e8                	shr    %cl,%eax
  8029c7:	09 c2                	or     %eax,%edx
  8029c9:	89 d0                	mov    %edx,%eax
  8029cb:	89 f2                	mov    %esi,%edx
  8029cd:	f7 74 24 0c          	divl   0xc(%esp)
  8029d1:	89 d6                	mov    %edx,%esi
  8029d3:	89 c3                	mov    %eax,%ebx
  8029d5:	f7 e5                	mul    %ebp
  8029d7:	39 d6                	cmp    %edx,%esi
  8029d9:	72 19                	jb     8029f4 <__udivdi3+0xfc>
  8029db:	74 0b                	je     8029e8 <__udivdi3+0xf0>
  8029dd:	89 d8                	mov    %ebx,%eax
  8029df:	31 ff                	xor    %edi,%edi
  8029e1:	e9 58 ff ff ff       	jmp    80293e <__udivdi3+0x46>
  8029e6:	66 90                	xchg   %ax,%ax
  8029e8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8029ec:	89 f9                	mov    %edi,%ecx
  8029ee:	d3 e2                	shl    %cl,%edx
  8029f0:	39 c2                	cmp    %eax,%edx
  8029f2:	73 e9                	jae    8029dd <__udivdi3+0xe5>
  8029f4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8029f7:	31 ff                	xor    %edi,%edi
  8029f9:	e9 40 ff ff ff       	jmp    80293e <__udivdi3+0x46>
  8029fe:	66 90                	xchg   %ax,%ax
  802a00:	31 c0                	xor    %eax,%eax
  802a02:	e9 37 ff ff ff       	jmp    80293e <__udivdi3+0x46>
  802a07:	90                   	nop

00802a08 <__umoddi3>:
  802a08:	55                   	push   %ebp
  802a09:	57                   	push   %edi
  802a0a:	56                   	push   %esi
  802a0b:	53                   	push   %ebx
  802a0c:	83 ec 1c             	sub    $0x1c,%esp
  802a0f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802a13:	8b 74 24 34          	mov    0x34(%esp),%esi
  802a17:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a1b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a1f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a23:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a27:	89 f3                	mov    %esi,%ebx
  802a29:	89 fa                	mov    %edi,%edx
  802a2b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802a2f:	89 34 24             	mov    %esi,(%esp)
  802a32:	85 c0                	test   %eax,%eax
  802a34:	75 1a                	jne    802a50 <__umoddi3+0x48>
  802a36:	39 f7                	cmp    %esi,%edi
  802a38:	0f 86 a2 00 00 00    	jbe    802ae0 <__umoddi3+0xd8>
  802a3e:	89 c8                	mov    %ecx,%eax
  802a40:	89 f2                	mov    %esi,%edx
  802a42:	f7 f7                	div    %edi
  802a44:	89 d0                	mov    %edx,%eax
  802a46:	31 d2                	xor    %edx,%edx
  802a48:	83 c4 1c             	add    $0x1c,%esp
  802a4b:	5b                   	pop    %ebx
  802a4c:	5e                   	pop    %esi
  802a4d:	5f                   	pop    %edi
  802a4e:	5d                   	pop    %ebp
  802a4f:	c3                   	ret    
  802a50:	39 f0                	cmp    %esi,%eax
  802a52:	0f 87 ac 00 00 00    	ja     802b04 <__umoddi3+0xfc>
  802a58:	0f bd e8             	bsr    %eax,%ebp
  802a5b:	83 f5 1f             	xor    $0x1f,%ebp
  802a5e:	0f 84 ac 00 00 00    	je     802b10 <__umoddi3+0x108>
  802a64:	bf 20 00 00 00       	mov    $0x20,%edi
  802a69:	29 ef                	sub    %ebp,%edi
  802a6b:	89 fe                	mov    %edi,%esi
  802a6d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a71:	89 e9                	mov    %ebp,%ecx
  802a73:	d3 e0                	shl    %cl,%eax
  802a75:	89 d7                	mov    %edx,%edi
  802a77:	89 f1                	mov    %esi,%ecx
  802a79:	d3 ef                	shr    %cl,%edi
  802a7b:	09 c7                	or     %eax,%edi
  802a7d:	89 e9                	mov    %ebp,%ecx
  802a7f:	d3 e2                	shl    %cl,%edx
  802a81:	89 14 24             	mov    %edx,(%esp)
  802a84:	89 d8                	mov    %ebx,%eax
  802a86:	d3 e0                	shl    %cl,%eax
  802a88:	89 c2                	mov    %eax,%edx
  802a8a:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a8e:	d3 e0                	shl    %cl,%eax
  802a90:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a94:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a98:	89 f1                	mov    %esi,%ecx
  802a9a:	d3 e8                	shr    %cl,%eax
  802a9c:	09 d0                	or     %edx,%eax
  802a9e:	d3 eb                	shr    %cl,%ebx
  802aa0:	89 da                	mov    %ebx,%edx
  802aa2:	f7 f7                	div    %edi
  802aa4:	89 d3                	mov    %edx,%ebx
  802aa6:	f7 24 24             	mull   (%esp)
  802aa9:	89 c6                	mov    %eax,%esi
  802aab:	89 d1                	mov    %edx,%ecx
  802aad:	39 d3                	cmp    %edx,%ebx
  802aaf:	0f 82 87 00 00 00    	jb     802b3c <__umoddi3+0x134>
  802ab5:	0f 84 91 00 00 00    	je     802b4c <__umoddi3+0x144>
  802abb:	8b 54 24 04          	mov    0x4(%esp),%edx
  802abf:	29 f2                	sub    %esi,%edx
  802ac1:	19 cb                	sbb    %ecx,%ebx
  802ac3:	89 d8                	mov    %ebx,%eax
  802ac5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802ac9:	d3 e0                	shl    %cl,%eax
  802acb:	89 e9                	mov    %ebp,%ecx
  802acd:	d3 ea                	shr    %cl,%edx
  802acf:	09 d0                	or     %edx,%eax
  802ad1:	89 e9                	mov    %ebp,%ecx
  802ad3:	d3 eb                	shr    %cl,%ebx
  802ad5:	89 da                	mov    %ebx,%edx
  802ad7:	83 c4 1c             	add    $0x1c,%esp
  802ada:	5b                   	pop    %ebx
  802adb:	5e                   	pop    %esi
  802adc:	5f                   	pop    %edi
  802add:	5d                   	pop    %ebp
  802ade:	c3                   	ret    
  802adf:	90                   	nop
  802ae0:	89 fd                	mov    %edi,%ebp
  802ae2:	85 ff                	test   %edi,%edi
  802ae4:	75 0b                	jne    802af1 <__umoddi3+0xe9>
  802ae6:	b8 01 00 00 00       	mov    $0x1,%eax
  802aeb:	31 d2                	xor    %edx,%edx
  802aed:	f7 f7                	div    %edi
  802aef:	89 c5                	mov    %eax,%ebp
  802af1:	89 f0                	mov    %esi,%eax
  802af3:	31 d2                	xor    %edx,%edx
  802af5:	f7 f5                	div    %ebp
  802af7:	89 c8                	mov    %ecx,%eax
  802af9:	f7 f5                	div    %ebp
  802afb:	89 d0                	mov    %edx,%eax
  802afd:	e9 44 ff ff ff       	jmp    802a46 <__umoddi3+0x3e>
  802b02:	66 90                	xchg   %ax,%ax
  802b04:	89 c8                	mov    %ecx,%eax
  802b06:	89 f2                	mov    %esi,%edx
  802b08:	83 c4 1c             	add    $0x1c,%esp
  802b0b:	5b                   	pop    %ebx
  802b0c:	5e                   	pop    %esi
  802b0d:	5f                   	pop    %edi
  802b0e:	5d                   	pop    %ebp
  802b0f:	c3                   	ret    
  802b10:	3b 04 24             	cmp    (%esp),%eax
  802b13:	72 06                	jb     802b1b <__umoddi3+0x113>
  802b15:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802b19:	77 0f                	ja     802b2a <__umoddi3+0x122>
  802b1b:	89 f2                	mov    %esi,%edx
  802b1d:	29 f9                	sub    %edi,%ecx
  802b1f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802b23:	89 14 24             	mov    %edx,(%esp)
  802b26:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802b2a:	8b 44 24 04          	mov    0x4(%esp),%eax
  802b2e:	8b 14 24             	mov    (%esp),%edx
  802b31:	83 c4 1c             	add    $0x1c,%esp
  802b34:	5b                   	pop    %ebx
  802b35:	5e                   	pop    %esi
  802b36:	5f                   	pop    %edi
  802b37:	5d                   	pop    %ebp
  802b38:	c3                   	ret    
  802b39:	8d 76 00             	lea    0x0(%esi),%esi
  802b3c:	2b 04 24             	sub    (%esp),%eax
  802b3f:	19 fa                	sbb    %edi,%edx
  802b41:	89 d1                	mov    %edx,%ecx
  802b43:	89 c6                	mov    %eax,%esi
  802b45:	e9 71 ff ff ff       	jmp    802abb <__umoddi3+0xb3>
  802b4a:	66 90                	xchg   %ax,%ax
  802b4c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802b50:	72 ea                	jb     802b3c <__umoddi3+0x134>
  802b52:	89 d9                	mov    %ebx,%ecx
  802b54:	e9 62 ff ff ff       	jmp    802abb <__umoddi3+0xb3>
