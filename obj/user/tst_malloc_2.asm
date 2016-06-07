
obj/user/tst_malloc_2:     file format elf32-i386


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
  800031:	e8 3a 03 00 00       	call   800370 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	char a;
	short b;
	int c;
};
void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	81 ec 94 00 00 00    	sub    $0x94,%esp
	int envID = sys_getenvid();
  800042:	e8 b6 1d 00 00       	call   801dfd <sys_getenvid>
  800047:	89 45 f4             	mov    %eax,-0xc(%ebp)

	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  80004a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80004d:	89 d0                	mov    %edx,%eax
  80004f:	c1 e0 03             	shl    $0x3,%eax
  800052:	01 d0                	add    %edx,%eax
  800054:	01 c0                	add    %eax,%eax
  800056:	01 d0                	add    %edx,%eax
  800058:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80005f:	01 d0                	add    %edx,%eax
  800061:	c1 e0 03             	shl    $0x3,%eax
  800064:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800069:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int Mega = 1024*1024;
  80006c:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  800073:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	char minByte = 1<<7;
  80007a:	c6 45 e7 80          	movb   $0x80,-0x19(%ebp)
	char maxByte = 0x7F;
  80007e:	c6 45 e6 7f          	movb   $0x7f,-0x1a(%ebp)
	short minShort = 1<<15 ;
  800082:	66 c7 45 e4 00 80    	movw   $0x8000,-0x1c(%ebp)
	short maxShort = 0x7FFF;
  800088:	66 c7 45 e2 ff 7f    	movw   $0x7fff,-0x1e(%ebp)
	int minInt = 1<<31 ;
  80008e:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
	int maxInt = 0x7FFFFFFF;
  800095:	c7 45 d8 ff ff ff 7f 	movl   $0x7fffffff,-0x28(%ebp)

	void* ptr_allocations[20] = {0};
  80009c:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
  8000a2:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ac:	89 d7                	mov    %edx,%edi
  8000ae:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8000b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000b3:	01 c0                	add    %eax,%eax
  8000b5:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000b8:	83 ec 0c             	sub    $0xc,%esp
  8000bb:	50                   	push   %eax
  8000bc:	e8 1e 12 00 00       	call   8012df <malloc>
  8000c1:	83 c4 10             	add    $0x10,%esp
  8000c4:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
		char *byteArr = (char *) ptr_allocations[0];
  8000ca:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  8000d0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  8000d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000d6:	01 c0                	add    %eax,%eax
  8000d8:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000db:	48                   	dec    %eax
  8000dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = minByte ;
  8000df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000e2:	8a 55 e7             	mov    -0x19(%ebp),%dl
  8000e5:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  8000e7:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8000ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000ed:	01 c2                	add    %eax,%edx
  8000ef:	8a 45 e6             	mov    -0x1a(%ebp),%al
  8000f2:	88 02                	mov    %al,(%edx)

		ptr_allocations[1] = malloc(2*Mega-kilo);
  8000f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000f7:	01 c0                	add    %eax,%eax
  8000f9:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	50                   	push   %eax
  800100:	e8 da 11 00 00       	call   8012df <malloc>
  800105:	83 c4 10             	add    $0x10,%esp
  800108:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		short *shortArr = (short *) ptr_allocations[1];
  80010e:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800114:	89 45 cc             	mov    %eax,-0x34(%ebp)
		int lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800117:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80011a:	01 c0                	add    %eax,%eax
  80011c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80011f:	d1 e8                	shr    %eax
  800121:	48                   	dec    %eax
  800122:	89 45 c8             	mov    %eax,-0x38(%ebp)
		shortArr[0] = minShort;
  800125:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800128:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80012b:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  80012e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800131:	01 c0                	add    %eax,%eax
  800133:	89 c2                	mov    %eax,%edx
  800135:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800138:	01 c2                	add    %eax,%edx
  80013a:	66 8b 45 e2          	mov    -0x1e(%ebp),%ax
  80013e:	66 89 02             	mov    %ax,(%edx)

		ptr_allocations[2] = malloc(2*kilo);
  800141:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800144:	01 c0                	add    %eax,%eax
  800146:	83 ec 0c             	sub    $0xc,%esp
  800149:	50                   	push   %eax
  80014a:	e8 90 11 00 00       	call   8012df <malloc>
  80014f:	83 c4 10             	add    $0x10,%esp
  800152:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		int *intArr = (int *) ptr_allocations[2];
  800158:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80015e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		int lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  800161:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800164:	01 c0                	add    %eax,%eax
  800166:	c1 e8 02             	shr    $0x2,%eax
  800169:	48                   	dec    %eax
  80016a:	89 45 c0             	mov    %eax,-0x40(%ebp)
		intArr[0] = minInt;
  80016d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800170:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800173:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  800175:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800178:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80017f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800182:	01 c2                	add    %eax,%edx
  800184:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800187:	89 02                	mov    %eax,(%edx)

		ptr_allocations[3] = malloc(7*kilo);
  800189:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80018c:	89 d0                	mov    %edx,%eax
  80018e:	01 c0                	add    %eax,%eax
  800190:	01 d0                	add    %edx,%eax
  800192:	01 c0                	add    %eax,%eax
  800194:	01 d0                	add    %edx,%eax
  800196:	83 ec 0c             	sub    $0xc,%esp
  800199:	50                   	push   %eax
  80019a:	e8 40 11 00 00       	call   8012df <malloc>
  80019f:	83 c4 10             	add    $0x10,%esp
  8001a2:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		struct MyStruct *structArr = (struct MyStruct *) ptr_allocations[3];
  8001a8:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8001ae:	89 45 bc             	mov    %eax,-0x44(%ebp)
		int lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  8001b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8001b4:	89 d0                	mov    %edx,%eax
  8001b6:	01 c0                	add    %eax,%eax
  8001b8:	01 d0                	add    %edx,%eax
  8001ba:	01 c0                	add    %eax,%eax
  8001bc:	01 d0                	add    %edx,%eax
  8001be:	c1 e8 03             	shr    $0x3,%eax
  8001c1:	48                   	dec    %eax
  8001c2:	89 45 b8             	mov    %eax,-0x48(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  8001c5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001c8:	8a 55 e7             	mov    -0x19(%ebp),%dl
  8001cb:	88 10                	mov    %dl,(%eax)
  8001cd:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8001d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001d3:	66 89 42 02          	mov    %ax,0x2(%edx)
  8001d7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8001dd:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  8001e0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001e3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8001ea:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001ed:	01 c2                	add    %eax,%edx
  8001ef:	8a 45 e6             	mov    -0x1a(%ebp),%al
  8001f2:	88 02                	mov    %al,(%edx)
  8001f4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001f7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8001fe:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800201:	01 c2                	add    %eax,%edx
  800203:	66 8b 45 e2          	mov    -0x1e(%ebp),%ax
  800207:	66 89 42 02          	mov    %ax,0x2(%edx)
  80020b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80020e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800215:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800218:	01 c2                	add    %eax,%edx
  80021a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80021d:	89 42 04             	mov    %eax,0x4(%edx)

		//Check that the values are successfully stored
		if (byteArr[0] 	!= minByte 	|| byteArr[lastIndexOfByte] 	!= maxByte) panic("Wrong allocation: stored values are wrongly changed!");
  800220:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800223:	8a 00                	mov    (%eax),%al
  800225:	3a 45 e7             	cmp    -0x19(%ebp),%al
  800228:	75 0f                	jne    800239 <_main+0x201>
  80022a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80022d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800230:	01 d0                	add    %edx,%eax
  800232:	8a 00                	mov    (%eax),%al
  800234:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  800237:	74 14                	je     80024d <_main+0x215>
  800239:	83 ec 04             	sub    $0x4,%esp
  80023c:	68 60 25 80 00       	push   $0x802560
  800241:	6a 38                	push   $0x38
  800243:	68 95 25 80 00       	push   $0x802595
  800248:	e8 e4 01 00 00       	call   800431 <_panic>
		if (shortArr[0] != minShort || shortArr[lastIndexOfShort] 	!= maxShort) panic("Wrong allocation: stored values are wrongly changed!");
  80024d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800250:	66 8b 00             	mov    (%eax),%ax
  800253:	66 3b 45 e4          	cmp    -0x1c(%ebp),%ax
  800257:	75 15                	jne    80026e <_main+0x236>
  800259:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80025c:	01 c0                	add    %eax,%eax
  80025e:	89 c2                	mov    %eax,%edx
  800260:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800263:	01 d0                	add    %edx,%eax
  800265:	66 8b 00             	mov    (%eax),%ax
  800268:	66 3b 45 e2          	cmp    -0x1e(%ebp),%ax
  80026c:	74 14                	je     800282 <_main+0x24a>
  80026e:	83 ec 04             	sub    $0x4,%esp
  800271:	68 60 25 80 00       	push   $0x802560
  800276:	6a 39                	push   $0x39
  800278:	68 95 25 80 00       	push   $0x802595
  80027d:	e8 af 01 00 00       	call   800431 <_panic>
		if (intArr[0] 	!= minInt 	|| intArr[lastIndexOfInt] 		!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  800282:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800285:	8b 00                	mov    (%eax),%eax
  800287:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80028a:	75 16                	jne    8002a2 <_main+0x26a>
  80028c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80028f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800296:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800299:	01 d0                	add    %edx,%eax
  80029b:	8b 00                	mov    (%eax),%eax
  80029d:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8002a0:	74 14                	je     8002b6 <_main+0x27e>
  8002a2:	83 ec 04             	sub    $0x4,%esp
  8002a5:	68 60 25 80 00       	push   $0x802560
  8002aa:	6a 3a                	push   $0x3a
  8002ac:	68 95 25 80 00       	push   $0x802595
  8002b1:	e8 7b 01 00 00       	call   800431 <_panic>

		if (structArr[0].a != minByte 	|| structArr[lastIndexOfStruct].a != maxByte) 	panic("Wrong allocation: stored values are wrongly changed!");
  8002b6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8002b9:	8a 00                	mov    (%eax),%al
  8002bb:	3a 45 e7             	cmp    -0x19(%ebp),%al
  8002be:	75 16                	jne    8002d6 <_main+0x29e>
  8002c0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8002c3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002ca:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8002cd:	01 d0                	add    %edx,%eax
  8002cf:	8a 00                	mov    (%eax),%al
  8002d1:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  8002d4:	74 14                	je     8002ea <_main+0x2b2>
  8002d6:	83 ec 04             	sub    $0x4,%esp
  8002d9:	68 60 25 80 00       	push   $0x802560
  8002de:	6a 3c                	push   $0x3c
  8002e0:	68 95 25 80 00       	push   $0x802595
  8002e5:	e8 47 01 00 00       	call   800431 <_panic>
		if (structArr[0].b != minShort 	|| structArr[lastIndexOfStruct].b != maxShort) 	panic("Wrong allocation: stored values are wrongly changed!");
  8002ea:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8002ed:	66 8b 40 02          	mov    0x2(%eax),%ax
  8002f1:	66 3b 45 e4          	cmp    -0x1c(%ebp),%ax
  8002f5:	75 19                	jne    800310 <_main+0x2d8>
  8002f7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8002fa:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800301:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800304:	01 d0                	add    %edx,%eax
  800306:	66 8b 40 02          	mov    0x2(%eax),%ax
  80030a:	66 3b 45 e2          	cmp    -0x1e(%ebp),%ax
  80030e:	74 14                	je     800324 <_main+0x2ec>
  800310:	83 ec 04             	sub    $0x4,%esp
  800313:	68 60 25 80 00       	push   $0x802560
  800318:	6a 3d                	push   $0x3d
  80031a:	68 95 25 80 00       	push   $0x802595
  80031f:	e8 0d 01 00 00       	call   800431 <_panic>
		if (structArr[0].c != minInt 	|| structArr[lastIndexOfStruct].c != maxInt) 	panic("Wrong allocation: stored values are wrongly changed!");
  800324:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800327:	8b 40 04             	mov    0x4(%eax),%eax
  80032a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80032d:	75 17                	jne    800346 <_main+0x30e>
  80032f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800332:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800339:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80033c:	01 d0                	add    %edx,%eax
  80033e:	8b 40 04             	mov    0x4(%eax),%eax
  800341:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800344:	74 14                	je     80035a <_main+0x322>
  800346:	83 ec 04             	sub    $0x4,%esp
  800349:	68 60 25 80 00       	push   $0x802560
  80034e:	6a 3e                	push   $0x3e
  800350:	68 95 25 80 00       	push   $0x802595
  800355:	e8 d7 00 00 00       	call   800431 <_panic>


	}

	cprintf("Congratulations!! test malloc (2) completed successfully.\n");
  80035a:	83 ec 0c             	sub    $0xc,%esp
  80035d:	68 ac 25 80 00       	push   $0x8025ac
  800362:	e8 f5 01 00 00       	call   80055c <cprintf>
  800367:	83 c4 10             	add    $0x10,%esp

	return;
  80036a:	90                   	nop
}
  80036b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80036e:	c9                   	leave  
  80036f:	c3                   	ret    

00800370 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800370:	55                   	push   %ebp
  800371:	89 e5                	mov    %esp,%ebp
  800373:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800376:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80037a:	7e 0a                	jle    800386 <libmain+0x16>
		binaryname = argv[0];
  80037c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80037f:	8b 00                	mov    (%eax),%eax
  800381:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800386:	83 ec 08             	sub    $0x8,%esp
  800389:	ff 75 0c             	pushl  0xc(%ebp)
  80038c:	ff 75 08             	pushl  0x8(%ebp)
  80038f:	e8 a4 fc ff ff       	call   800038 <_main>
  800394:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  800397:	e8 61 1a 00 00       	call   801dfd <sys_getenvid>
  80039c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  80039f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003a2:	89 d0                	mov    %edx,%eax
  8003a4:	c1 e0 03             	shl    $0x3,%eax
  8003a7:	01 d0                	add    %edx,%eax
  8003a9:	01 c0                	add    %eax,%eax
  8003ab:	01 d0                	add    %edx,%eax
  8003ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b4:	01 d0                	add    %edx,%eax
  8003b6:	c1 e0 03             	shl    $0x3,%eax
  8003b9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003be:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  8003c1:	e8 85 1b 00 00       	call   801f4b <sys_disable_interrupt>
		cprintf("**************************************\n");
  8003c6:	83 ec 0c             	sub    $0xc,%esp
  8003c9:	68 00 26 80 00       	push   $0x802600
  8003ce:	e8 89 01 00 00       	call   80055c <cprintf>
  8003d3:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  8003d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003d9:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  8003df:	83 ec 08             	sub    $0x8,%esp
  8003e2:	50                   	push   %eax
  8003e3:	68 28 26 80 00       	push   $0x802628
  8003e8:	e8 6f 01 00 00       	call   80055c <cprintf>
  8003ed:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8003f0:	83 ec 0c             	sub    $0xc,%esp
  8003f3:	68 00 26 80 00       	push   $0x802600
  8003f8:	e8 5f 01 00 00       	call   80055c <cprintf>
  8003fd:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800400:	e8 60 1b 00 00       	call   801f65 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800405:	e8 19 00 00 00       	call   800423 <exit>
}
  80040a:	90                   	nop
  80040b:	c9                   	leave  
  80040c:	c3                   	ret    

0080040d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80040d:	55                   	push   %ebp
  80040e:	89 e5                	mov    %esp,%ebp
  800410:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800413:	83 ec 0c             	sub    $0xc,%esp
  800416:	6a 00                	push   $0x0
  800418:	e8 c5 19 00 00       	call   801de2 <sys_env_destroy>
  80041d:	83 c4 10             	add    $0x10,%esp
}
  800420:	90                   	nop
  800421:	c9                   	leave  
  800422:	c3                   	ret    

00800423 <exit>:

void
exit(void)
{
  800423:	55                   	push   %ebp
  800424:	89 e5                	mov    %esp,%ebp
  800426:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800429:	e8 e8 19 00 00       	call   801e16 <sys_env_exit>
}
  80042e:	90                   	nop
  80042f:	c9                   	leave  
  800430:	c3                   	ret    

00800431 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800431:	55                   	push   %ebp
  800432:	89 e5                	mov    %esp,%ebp
  800434:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800437:	8d 45 10             	lea    0x10(%ebp),%eax
  80043a:	83 c0 04             	add    $0x4,%eax
  80043d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  800440:	a1 50 30 98 00       	mov    0x983050,%eax
  800445:	85 c0                	test   %eax,%eax
  800447:	74 16                	je     80045f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800449:	a1 50 30 98 00       	mov    0x983050,%eax
  80044e:	83 ec 08             	sub    $0x8,%esp
  800451:	50                   	push   %eax
  800452:	68 41 26 80 00       	push   $0x802641
  800457:	e8 00 01 00 00       	call   80055c <cprintf>
  80045c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80045f:	a1 00 30 80 00       	mov    0x803000,%eax
  800464:	ff 75 0c             	pushl  0xc(%ebp)
  800467:	ff 75 08             	pushl  0x8(%ebp)
  80046a:	50                   	push   %eax
  80046b:	68 46 26 80 00       	push   $0x802646
  800470:	e8 e7 00 00 00       	call   80055c <cprintf>
  800475:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800478:	8b 45 10             	mov    0x10(%ebp),%eax
  80047b:	83 ec 08             	sub    $0x8,%esp
  80047e:	ff 75 f4             	pushl  -0xc(%ebp)
  800481:	50                   	push   %eax
  800482:	e8 7a 00 00 00       	call   800501 <vcprintf>
  800487:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  80048a:	83 ec 0c             	sub    $0xc,%esp
  80048d:	68 62 26 80 00       	push   $0x802662
  800492:	e8 c5 00 00 00       	call   80055c <cprintf>
  800497:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80049a:	e8 84 ff ff ff       	call   800423 <exit>

	// should not return here
	while (1) ;
  80049f:	eb fe                	jmp    80049f <_panic+0x6e>

008004a1 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004a1:	55                   	push   %ebp
  8004a2:	89 e5                	mov    %esp,%ebp
  8004a4:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004aa:	8b 00                	mov    (%eax),%eax
  8004ac:	8d 48 01             	lea    0x1(%eax),%ecx
  8004af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b2:	89 0a                	mov    %ecx,(%edx)
  8004b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8004b7:	88 d1                	mov    %dl,%cl
  8004b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004bc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c3:	8b 00                	mov    (%eax),%eax
  8004c5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004ca:	75 23                	jne    8004ef <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  8004cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cf:	8b 00                	mov    (%eax),%eax
  8004d1:	89 c2                	mov    %eax,%edx
  8004d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d6:	83 c0 08             	add    $0x8,%eax
  8004d9:	83 ec 08             	sub    $0x8,%esp
  8004dc:	52                   	push   %edx
  8004dd:	50                   	push   %eax
  8004de:	e8 c9 18 00 00       	call   801dac <sys_cputs>
  8004e3:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f2:	8b 40 04             	mov    0x4(%eax),%eax
  8004f5:	8d 50 01             	lea    0x1(%eax),%edx
  8004f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fb:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004fe:	90                   	nop
  8004ff:	c9                   	leave  
  800500:	c3                   	ret    

00800501 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800501:	55                   	push   %ebp
  800502:	89 e5                	mov    %esp,%ebp
  800504:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80050a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800511:	00 00 00 
	b.cnt = 0;
  800514:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80051b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80051e:	ff 75 0c             	pushl  0xc(%ebp)
  800521:	ff 75 08             	pushl  0x8(%ebp)
  800524:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80052a:	50                   	push   %eax
  80052b:	68 a1 04 80 00       	push   $0x8004a1
  800530:	e8 fa 01 00 00       	call   80072f <vprintfmt>
  800535:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  800538:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80053e:	83 ec 08             	sub    $0x8,%esp
  800541:	50                   	push   %eax
  800542:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800548:	83 c0 08             	add    $0x8,%eax
  80054b:	50                   	push   %eax
  80054c:	e8 5b 18 00 00       	call   801dac <sys_cputs>
  800551:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  800554:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80055a:	c9                   	leave  
  80055b:	c3                   	ret    

0080055c <cprintf>:

int cprintf(const char *fmt, ...) {
  80055c:	55                   	push   %ebp
  80055d:	89 e5                	mov    %esp,%ebp
  80055f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800562:	8d 45 0c             	lea    0xc(%ebp),%eax
  800565:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800568:	8b 45 08             	mov    0x8(%ebp),%eax
  80056b:	83 ec 08             	sub    $0x8,%esp
  80056e:	ff 75 f4             	pushl  -0xc(%ebp)
  800571:	50                   	push   %eax
  800572:	e8 8a ff ff ff       	call   800501 <vcprintf>
  800577:	83 c4 10             	add    $0x10,%esp
  80057a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80057d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800580:	c9                   	leave  
  800581:	c3                   	ret    

00800582 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800582:	55                   	push   %ebp
  800583:	89 e5                	mov    %esp,%ebp
  800585:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800588:	e8 be 19 00 00       	call   801f4b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80058d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800590:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800593:	8b 45 08             	mov    0x8(%ebp),%eax
  800596:	83 ec 08             	sub    $0x8,%esp
  800599:	ff 75 f4             	pushl  -0xc(%ebp)
  80059c:	50                   	push   %eax
  80059d:	e8 5f ff ff ff       	call   800501 <vcprintf>
  8005a2:	83 c4 10             	add    $0x10,%esp
  8005a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005a8:	e8 b8 19 00 00       	call   801f65 <sys_enable_interrupt>
	return cnt;
  8005ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005b0:	c9                   	leave  
  8005b1:	c3                   	ret    

008005b2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005b2:	55                   	push   %ebp
  8005b3:	89 e5                	mov    %esp,%ebp
  8005b5:	53                   	push   %ebx
  8005b6:	83 ec 14             	sub    $0x14,%esp
  8005b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005c5:	8b 45 18             	mov    0x18(%ebp),%eax
  8005c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005cd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005d0:	77 55                	ja     800627 <printnum+0x75>
  8005d2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005d5:	72 05                	jb     8005dc <printnum+0x2a>
  8005d7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005da:	77 4b                	ja     800627 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005dc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005df:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005e2:	8b 45 18             	mov    0x18(%ebp),%eax
  8005e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ea:	52                   	push   %edx
  8005eb:	50                   	push   %eax
  8005ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8005f2:	e8 f1 1c 00 00       	call   8022e8 <__udivdi3>
  8005f7:	83 c4 10             	add    $0x10,%esp
  8005fa:	83 ec 04             	sub    $0x4,%esp
  8005fd:	ff 75 20             	pushl  0x20(%ebp)
  800600:	53                   	push   %ebx
  800601:	ff 75 18             	pushl  0x18(%ebp)
  800604:	52                   	push   %edx
  800605:	50                   	push   %eax
  800606:	ff 75 0c             	pushl  0xc(%ebp)
  800609:	ff 75 08             	pushl  0x8(%ebp)
  80060c:	e8 a1 ff ff ff       	call   8005b2 <printnum>
  800611:	83 c4 20             	add    $0x20,%esp
  800614:	eb 1a                	jmp    800630 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800616:	83 ec 08             	sub    $0x8,%esp
  800619:	ff 75 0c             	pushl  0xc(%ebp)
  80061c:	ff 75 20             	pushl  0x20(%ebp)
  80061f:	8b 45 08             	mov    0x8(%ebp),%eax
  800622:	ff d0                	call   *%eax
  800624:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800627:	ff 4d 1c             	decl   0x1c(%ebp)
  80062a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80062e:	7f e6                	jg     800616 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800630:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800633:	bb 00 00 00 00       	mov    $0x0,%ebx
  800638:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80063b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80063e:	53                   	push   %ebx
  80063f:	51                   	push   %ecx
  800640:	52                   	push   %edx
  800641:	50                   	push   %eax
  800642:	e8 b1 1d 00 00       	call   8023f8 <__umoddi3>
  800647:	83 c4 10             	add    $0x10,%esp
  80064a:	05 94 28 80 00       	add    $0x802894,%eax
  80064f:	8a 00                	mov    (%eax),%al
  800651:	0f be c0             	movsbl %al,%eax
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	ff 75 0c             	pushl  0xc(%ebp)
  80065a:	50                   	push   %eax
  80065b:	8b 45 08             	mov    0x8(%ebp),%eax
  80065e:	ff d0                	call   *%eax
  800660:	83 c4 10             	add    $0x10,%esp
}
  800663:	90                   	nop
  800664:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800667:	c9                   	leave  
  800668:	c3                   	ret    

00800669 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800669:	55                   	push   %ebp
  80066a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80066c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800670:	7e 1c                	jle    80068e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800672:	8b 45 08             	mov    0x8(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	8d 50 08             	lea    0x8(%eax),%edx
  80067a:	8b 45 08             	mov    0x8(%ebp),%eax
  80067d:	89 10                	mov    %edx,(%eax)
  80067f:	8b 45 08             	mov    0x8(%ebp),%eax
  800682:	8b 00                	mov    (%eax),%eax
  800684:	83 e8 08             	sub    $0x8,%eax
  800687:	8b 50 04             	mov    0x4(%eax),%edx
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	eb 40                	jmp    8006ce <getuint+0x65>
	else if (lflag)
  80068e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800692:	74 1e                	je     8006b2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	8d 50 04             	lea    0x4(%eax),%edx
  80069c:	8b 45 08             	mov    0x8(%ebp),%eax
  80069f:	89 10                	mov    %edx,(%eax)
  8006a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	83 e8 04             	sub    $0x4,%eax
  8006a9:	8b 00                	mov    (%eax),%eax
  8006ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b0:	eb 1c                	jmp    8006ce <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	8d 50 04             	lea    0x4(%eax),%edx
  8006ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bd:	89 10                	mov    %edx,(%eax)
  8006bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c2:	8b 00                	mov    (%eax),%eax
  8006c4:	83 e8 04             	sub    $0x4,%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006ce:	5d                   	pop    %ebp
  8006cf:	c3                   	ret    

008006d0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006d0:	55                   	push   %ebp
  8006d1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006d3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006d7:	7e 1c                	jle    8006f5 <getint+0x25>
		return va_arg(*ap, long long);
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	8d 50 08             	lea    0x8(%eax),%edx
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	89 10                	mov    %edx,(%eax)
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	83 e8 08             	sub    $0x8,%eax
  8006ee:	8b 50 04             	mov    0x4(%eax),%edx
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	eb 38                	jmp    80072d <getint+0x5d>
	else if (lflag)
  8006f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006f9:	74 1a                	je     800715 <getint+0x45>
		return va_arg(*ap, long);
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	8d 50 04             	lea    0x4(%eax),%edx
  800703:	8b 45 08             	mov    0x8(%ebp),%eax
  800706:	89 10                	mov    %edx,(%eax)
  800708:	8b 45 08             	mov    0x8(%ebp),%eax
  80070b:	8b 00                	mov    (%eax),%eax
  80070d:	83 e8 04             	sub    $0x4,%eax
  800710:	8b 00                	mov    (%eax),%eax
  800712:	99                   	cltd   
  800713:	eb 18                	jmp    80072d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800715:	8b 45 08             	mov    0x8(%ebp),%eax
  800718:	8b 00                	mov    (%eax),%eax
  80071a:	8d 50 04             	lea    0x4(%eax),%edx
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	89 10                	mov    %edx,(%eax)
  800722:	8b 45 08             	mov    0x8(%ebp),%eax
  800725:	8b 00                	mov    (%eax),%eax
  800727:	83 e8 04             	sub    $0x4,%eax
  80072a:	8b 00                	mov    (%eax),%eax
  80072c:	99                   	cltd   
}
  80072d:	5d                   	pop    %ebp
  80072e:	c3                   	ret    

0080072f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80072f:	55                   	push   %ebp
  800730:	89 e5                	mov    %esp,%ebp
  800732:	56                   	push   %esi
  800733:	53                   	push   %ebx
  800734:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800737:	eb 17                	jmp    800750 <vprintfmt+0x21>
			if (ch == '\0')
  800739:	85 db                	test   %ebx,%ebx
  80073b:	0f 84 af 03 00 00    	je     800af0 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800741:	83 ec 08             	sub    $0x8,%esp
  800744:	ff 75 0c             	pushl  0xc(%ebp)
  800747:	53                   	push   %ebx
  800748:	8b 45 08             	mov    0x8(%ebp),%eax
  80074b:	ff d0                	call   *%eax
  80074d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800750:	8b 45 10             	mov    0x10(%ebp),%eax
  800753:	8d 50 01             	lea    0x1(%eax),%edx
  800756:	89 55 10             	mov    %edx,0x10(%ebp)
  800759:	8a 00                	mov    (%eax),%al
  80075b:	0f b6 d8             	movzbl %al,%ebx
  80075e:	83 fb 25             	cmp    $0x25,%ebx
  800761:	75 d6                	jne    800739 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800763:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800767:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80076e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800775:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80077c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800783:	8b 45 10             	mov    0x10(%ebp),%eax
  800786:	8d 50 01             	lea    0x1(%eax),%edx
  800789:	89 55 10             	mov    %edx,0x10(%ebp)
  80078c:	8a 00                	mov    (%eax),%al
  80078e:	0f b6 d8             	movzbl %al,%ebx
  800791:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800794:	83 f8 55             	cmp    $0x55,%eax
  800797:	0f 87 2b 03 00 00    	ja     800ac8 <vprintfmt+0x399>
  80079d:	8b 04 85 b8 28 80 00 	mov    0x8028b8(,%eax,4),%eax
  8007a4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007a6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007aa:	eb d7                	jmp    800783 <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007ac:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007b0:	eb d1                	jmp    800783 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007b2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007bc:	89 d0                	mov    %edx,%eax
  8007be:	c1 e0 02             	shl    $0x2,%eax
  8007c1:	01 d0                	add    %edx,%eax
  8007c3:	01 c0                	add    %eax,%eax
  8007c5:	01 d8                	add    %ebx,%eax
  8007c7:	83 e8 30             	sub    $0x30,%eax
  8007ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d0:	8a 00                	mov    (%eax),%al
  8007d2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007d5:	83 fb 2f             	cmp    $0x2f,%ebx
  8007d8:	7e 3e                	jle    800818 <vprintfmt+0xe9>
  8007da:	83 fb 39             	cmp    $0x39,%ebx
  8007dd:	7f 39                	jg     800818 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007df:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007e2:	eb d5                	jmp    8007b9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e7:	83 c0 04             	add    $0x4,%eax
  8007ea:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f0:	83 e8 04             	sub    $0x4,%eax
  8007f3:	8b 00                	mov    (%eax),%eax
  8007f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007f8:	eb 1f                	jmp    800819 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fe:	79 83                	jns    800783 <vprintfmt+0x54>
				width = 0;
  800800:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800807:	e9 77 ff ff ff       	jmp    800783 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80080c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800813:	e9 6b ff ff ff       	jmp    800783 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800818:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800819:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80081d:	0f 89 60 ff ff ff    	jns    800783 <vprintfmt+0x54>
				width = precision, precision = -1;
  800823:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800826:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800829:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800830:	e9 4e ff ff ff       	jmp    800783 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800835:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800838:	e9 46 ff ff ff       	jmp    800783 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80083d:	8b 45 14             	mov    0x14(%ebp),%eax
  800840:	83 c0 04             	add    $0x4,%eax
  800843:	89 45 14             	mov    %eax,0x14(%ebp)
  800846:	8b 45 14             	mov    0x14(%ebp),%eax
  800849:	83 e8 04             	sub    $0x4,%eax
  80084c:	8b 00                	mov    (%eax),%eax
  80084e:	83 ec 08             	sub    $0x8,%esp
  800851:	ff 75 0c             	pushl  0xc(%ebp)
  800854:	50                   	push   %eax
  800855:	8b 45 08             	mov    0x8(%ebp),%eax
  800858:	ff d0                	call   *%eax
  80085a:	83 c4 10             	add    $0x10,%esp
			break;
  80085d:	e9 89 02 00 00       	jmp    800aeb <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800862:	8b 45 14             	mov    0x14(%ebp),%eax
  800865:	83 c0 04             	add    $0x4,%eax
  800868:	89 45 14             	mov    %eax,0x14(%ebp)
  80086b:	8b 45 14             	mov    0x14(%ebp),%eax
  80086e:	83 e8 04             	sub    $0x4,%eax
  800871:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800873:	85 db                	test   %ebx,%ebx
  800875:	79 02                	jns    800879 <vprintfmt+0x14a>
				err = -err;
  800877:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800879:	83 fb 64             	cmp    $0x64,%ebx
  80087c:	7f 0b                	jg     800889 <vprintfmt+0x15a>
  80087e:	8b 34 9d 00 27 80 00 	mov    0x802700(,%ebx,4),%esi
  800885:	85 f6                	test   %esi,%esi
  800887:	75 19                	jne    8008a2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800889:	53                   	push   %ebx
  80088a:	68 a5 28 80 00       	push   $0x8028a5
  80088f:	ff 75 0c             	pushl  0xc(%ebp)
  800892:	ff 75 08             	pushl  0x8(%ebp)
  800895:	e8 5e 02 00 00       	call   800af8 <printfmt>
  80089a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80089d:	e9 49 02 00 00       	jmp    800aeb <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008a2:	56                   	push   %esi
  8008a3:	68 ae 28 80 00       	push   $0x8028ae
  8008a8:	ff 75 0c             	pushl  0xc(%ebp)
  8008ab:	ff 75 08             	pushl  0x8(%ebp)
  8008ae:	e8 45 02 00 00       	call   800af8 <printfmt>
  8008b3:	83 c4 10             	add    $0x10,%esp
			break;
  8008b6:	e9 30 02 00 00       	jmp    800aeb <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008be:	83 c0 04             	add    $0x4,%eax
  8008c1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c7:	83 e8 04             	sub    $0x4,%eax
  8008ca:	8b 30                	mov    (%eax),%esi
  8008cc:	85 f6                	test   %esi,%esi
  8008ce:	75 05                	jne    8008d5 <vprintfmt+0x1a6>
				p = "(null)";
  8008d0:	be b1 28 80 00       	mov    $0x8028b1,%esi
			if (width > 0 && padc != '-')
  8008d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008d9:	7e 6d                	jle    800948 <vprintfmt+0x219>
  8008db:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008df:	74 67                	je     800948 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008e4:	83 ec 08             	sub    $0x8,%esp
  8008e7:	50                   	push   %eax
  8008e8:	56                   	push   %esi
  8008e9:	e8 0c 03 00 00       	call   800bfa <strnlen>
  8008ee:	83 c4 10             	add    $0x10,%esp
  8008f1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008f4:	eb 16                	jmp    80090c <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008f6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008fa:	83 ec 08             	sub    $0x8,%esp
  8008fd:	ff 75 0c             	pushl  0xc(%ebp)
  800900:	50                   	push   %eax
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	ff d0                	call   *%eax
  800906:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800909:	ff 4d e4             	decl   -0x1c(%ebp)
  80090c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800910:	7f e4                	jg     8008f6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800912:	eb 34                	jmp    800948 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800914:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800918:	74 1c                	je     800936 <vprintfmt+0x207>
  80091a:	83 fb 1f             	cmp    $0x1f,%ebx
  80091d:	7e 05                	jle    800924 <vprintfmt+0x1f5>
  80091f:	83 fb 7e             	cmp    $0x7e,%ebx
  800922:	7e 12                	jle    800936 <vprintfmt+0x207>
					putch('?', putdat);
  800924:	83 ec 08             	sub    $0x8,%esp
  800927:	ff 75 0c             	pushl  0xc(%ebp)
  80092a:	6a 3f                	push   $0x3f
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	ff d0                	call   *%eax
  800931:	83 c4 10             	add    $0x10,%esp
  800934:	eb 0f                	jmp    800945 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800936:	83 ec 08             	sub    $0x8,%esp
  800939:	ff 75 0c             	pushl  0xc(%ebp)
  80093c:	53                   	push   %ebx
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	ff d0                	call   *%eax
  800942:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800945:	ff 4d e4             	decl   -0x1c(%ebp)
  800948:	89 f0                	mov    %esi,%eax
  80094a:	8d 70 01             	lea    0x1(%eax),%esi
  80094d:	8a 00                	mov    (%eax),%al
  80094f:	0f be d8             	movsbl %al,%ebx
  800952:	85 db                	test   %ebx,%ebx
  800954:	74 24                	je     80097a <vprintfmt+0x24b>
  800956:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80095a:	78 b8                	js     800914 <vprintfmt+0x1e5>
  80095c:	ff 4d e0             	decl   -0x20(%ebp)
  80095f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800963:	79 af                	jns    800914 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800965:	eb 13                	jmp    80097a <vprintfmt+0x24b>
				putch(' ', putdat);
  800967:	83 ec 08             	sub    $0x8,%esp
  80096a:	ff 75 0c             	pushl  0xc(%ebp)
  80096d:	6a 20                	push   $0x20
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	ff d0                	call   *%eax
  800974:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800977:	ff 4d e4             	decl   -0x1c(%ebp)
  80097a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80097e:	7f e7                	jg     800967 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800980:	e9 66 01 00 00       	jmp    800aeb <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800985:	83 ec 08             	sub    $0x8,%esp
  800988:	ff 75 e8             	pushl  -0x18(%ebp)
  80098b:	8d 45 14             	lea    0x14(%ebp),%eax
  80098e:	50                   	push   %eax
  80098f:	e8 3c fd ff ff       	call   8006d0 <getint>
  800994:	83 c4 10             	add    $0x10,%esp
  800997:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80099a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80099d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009a3:	85 d2                	test   %edx,%edx
  8009a5:	79 23                	jns    8009ca <vprintfmt+0x29b>
				putch('-', putdat);
  8009a7:	83 ec 08             	sub    $0x8,%esp
  8009aa:	ff 75 0c             	pushl  0xc(%ebp)
  8009ad:	6a 2d                	push   $0x2d
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	ff d0                	call   *%eax
  8009b4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009bd:	f7 d8                	neg    %eax
  8009bf:	83 d2 00             	adc    $0x0,%edx
  8009c2:	f7 da                	neg    %edx
  8009c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009ca:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009d1:	e9 bc 00 00 00       	jmp    800a92 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009d6:	83 ec 08             	sub    $0x8,%esp
  8009d9:	ff 75 e8             	pushl  -0x18(%ebp)
  8009dc:	8d 45 14             	lea    0x14(%ebp),%eax
  8009df:	50                   	push   %eax
  8009e0:	e8 84 fc ff ff       	call   800669 <getuint>
  8009e5:	83 c4 10             	add    $0x10,%esp
  8009e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009eb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009ee:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009f5:	e9 98 00 00 00       	jmp    800a92 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009fa:	83 ec 08             	sub    $0x8,%esp
  8009fd:	ff 75 0c             	pushl  0xc(%ebp)
  800a00:	6a 58                	push   $0x58
  800a02:	8b 45 08             	mov    0x8(%ebp),%eax
  800a05:	ff d0                	call   *%eax
  800a07:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a0a:	83 ec 08             	sub    $0x8,%esp
  800a0d:	ff 75 0c             	pushl  0xc(%ebp)
  800a10:	6a 58                	push   $0x58
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	ff d0                	call   *%eax
  800a17:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a1a:	83 ec 08             	sub    $0x8,%esp
  800a1d:	ff 75 0c             	pushl  0xc(%ebp)
  800a20:	6a 58                	push   $0x58
  800a22:	8b 45 08             	mov    0x8(%ebp),%eax
  800a25:	ff d0                	call   *%eax
  800a27:	83 c4 10             	add    $0x10,%esp
			break;
  800a2a:	e9 bc 00 00 00       	jmp    800aeb <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a2f:	83 ec 08             	sub    $0x8,%esp
  800a32:	ff 75 0c             	pushl  0xc(%ebp)
  800a35:	6a 30                	push   $0x30
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	ff d0                	call   *%eax
  800a3c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a3f:	83 ec 08             	sub    $0x8,%esp
  800a42:	ff 75 0c             	pushl  0xc(%ebp)
  800a45:	6a 78                	push   $0x78
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	ff d0                	call   *%eax
  800a4c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a52:	83 c0 04             	add    $0x4,%eax
  800a55:	89 45 14             	mov    %eax,0x14(%ebp)
  800a58:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5b:	83 e8 04             	sub    $0x4,%eax
  800a5e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a6a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a71:	eb 1f                	jmp    800a92 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a73:	83 ec 08             	sub    $0x8,%esp
  800a76:	ff 75 e8             	pushl  -0x18(%ebp)
  800a79:	8d 45 14             	lea    0x14(%ebp),%eax
  800a7c:	50                   	push   %eax
  800a7d:	e8 e7 fb ff ff       	call   800669 <getuint>
  800a82:	83 c4 10             	add    $0x10,%esp
  800a85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a88:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a8b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a92:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a99:	83 ec 04             	sub    $0x4,%esp
  800a9c:	52                   	push   %edx
  800a9d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800aa0:	50                   	push   %eax
  800aa1:	ff 75 f4             	pushl  -0xc(%ebp)
  800aa4:	ff 75 f0             	pushl  -0x10(%ebp)
  800aa7:	ff 75 0c             	pushl  0xc(%ebp)
  800aaa:	ff 75 08             	pushl  0x8(%ebp)
  800aad:	e8 00 fb ff ff       	call   8005b2 <printnum>
  800ab2:	83 c4 20             	add    $0x20,%esp
			break;
  800ab5:	eb 34                	jmp    800aeb <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ab7:	83 ec 08             	sub    $0x8,%esp
  800aba:	ff 75 0c             	pushl  0xc(%ebp)
  800abd:	53                   	push   %ebx
  800abe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac1:	ff d0                	call   *%eax
  800ac3:	83 c4 10             	add    $0x10,%esp
			break;
  800ac6:	eb 23                	jmp    800aeb <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ac8:	83 ec 08             	sub    $0x8,%esp
  800acb:	ff 75 0c             	pushl  0xc(%ebp)
  800ace:	6a 25                	push   $0x25
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad3:	ff d0                	call   *%eax
  800ad5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ad8:	ff 4d 10             	decl   0x10(%ebp)
  800adb:	eb 03                	jmp    800ae0 <vprintfmt+0x3b1>
  800add:	ff 4d 10             	decl   0x10(%ebp)
  800ae0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae3:	48                   	dec    %eax
  800ae4:	8a 00                	mov    (%eax),%al
  800ae6:	3c 25                	cmp    $0x25,%al
  800ae8:	75 f3                	jne    800add <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800aea:	90                   	nop
		}
	}
  800aeb:	e9 47 fc ff ff       	jmp    800737 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800af0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800af1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800af4:	5b                   	pop    %ebx
  800af5:	5e                   	pop    %esi
  800af6:	5d                   	pop    %ebp
  800af7:	c3                   	ret    

00800af8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800af8:	55                   	push   %ebp
  800af9:	89 e5                	mov    %esp,%ebp
  800afb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800afe:	8d 45 10             	lea    0x10(%ebp),%eax
  800b01:	83 c0 04             	add    $0x4,%eax
  800b04:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b07:	8b 45 10             	mov    0x10(%ebp),%eax
  800b0a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b0d:	50                   	push   %eax
  800b0e:	ff 75 0c             	pushl  0xc(%ebp)
  800b11:	ff 75 08             	pushl  0x8(%ebp)
  800b14:	e8 16 fc ff ff       	call   80072f <vprintfmt>
  800b19:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b1c:	90                   	nop
  800b1d:	c9                   	leave  
  800b1e:	c3                   	ret    

00800b1f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b1f:	55                   	push   %ebp
  800b20:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b25:	8b 40 08             	mov    0x8(%eax),%eax
  800b28:	8d 50 01             	lea    0x1(%eax),%edx
  800b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b34:	8b 10                	mov    (%eax),%edx
  800b36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b39:	8b 40 04             	mov    0x4(%eax),%eax
  800b3c:	39 c2                	cmp    %eax,%edx
  800b3e:	73 12                	jae    800b52 <sprintputch+0x33>
		*b->buf++ = ch;
  800b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b43:	8b 00                	mov    (%eax),%eax
  800b45:	8d 48 01             	lea    0x1(%eax),%ecx
  800b48:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b4b:	89 0a                	mov    %ecx,(%edx)
  800b4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b50:	88 10                	mov    %dl,(%eax)
}
  800b52:	90                   	nop
  800b53:	5d                   	pop    %ebp
  800b54:	c3                   	ret    

00800b55 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b64:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	01 d0                	add    %edx,%eax
  800b6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b76:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b7a:	74 06                	je     800b82 <vsnprintf+0x2d>
  800b7c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b80:	7f 07                	jg     800b89 <vsnprintf+0x34>
		return -E_INVAL;
  800b82:	b8 03 00 00 00       	mov    $0x3,%eax
  800b87:	eb 20                	jmp    800ba9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b89:	ff 75 14             	pushl  0x14(%ebp)
  800b8c:	ff 75 10             	pushl  0x10(%ebp)
  800b8f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b92:	50                   	push   %eax
  800b93:	68 1f 0b 80 00       	push   $0x800b1f
  800b98:	e8 92 fb ff ff       	call   80072f <vprintfmt>
  800b9d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ba0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ba3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ba9:	c9                   	leave  
  800baa:	c3                   	ret    

00800bab <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bab:	55                   	push   %ebp
  800bac:	89 e5                	mov    %esp,%ebp
  800bae:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bb1:	8d 45 10             	lea    0x10(%ebp),%eax
  800bb4:	83 c0 04             	add    $0x4,%eax
  800bb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bba:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbd:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc0:	50                   	push   %eax
  800bc1:	ff 75 0c             	pushl  0xc(%ebp)
  800bc4:	ff 75 08             	pushl  0x8(%ebp)
  800bc7:	e8 89 ff ff ff       	call   800b55 <vsnprintf>
  800bcc:	83 c4 10             	add    $0x10,%esp
  800bcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bd5:	c9                   	leave  
  800bd6:	c3                   	ret    

00800bd7 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
  800bda:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bdd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be4:	eb 06                	jmp    800bec <strlen+0x15>
		n++;
  800be6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800be9:	ff 45 08             	incl   0x8(%ebp)
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	8a 00                	mov    (%eax),%al
  800bf1:	84 c0                	test   %al,%al
  800bf3:	75 f1                	jne    800be6 <strlen+0xf>
		n++;
	return n;
  800bf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bf8:	c9                   	leave  
  800bf9:	c3                   	ret    

00800bfa <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bfa:	55                   	push   %ebp
  800bfb:	89 e5                	mov    %esp,%ebp
  800bfd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c00:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c07:	eb 09                	jmp    800c12 <strnlen+0x18>
		n++;
  800c09:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c0c:	ff 45 08             	incl   0x8(%ebp)
  800c0f:	ff 4d 0c             	decl   0xc(%ebp)
  800c12:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c16:	74 09                	je     800c21 <strnlen+0x27>
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	8a 00                	mov    (%eax),%al
  800c1d:	84 c0                	test   %al,%al
  800c1f:	75 e8                	jne    800c09 <strnlen+0xf>
		n++;
	return n;
  800c21:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c24:	c9                   	leave  
  800c25:	c3                   	ret    

00800c26 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c32:	90                   	nop
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	8d 50 01             	lea    0x1(%eax),%edx
  800c39:	89 55 08             	mov    %edx,0x8(%ebp)
  800c3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c42:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c45:	8a 12                	mov    (%edx),%dl
  800c47:	88 10                	mov    %dl,(%eax)
  800c49:	8a 00                	mov    (%eax),%al
  800c4b:	84 c0                	test   %al,%al
  800c4d:	75 e4                	jne    800c33 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c52:	c9                   	leave  
  800c53:	c3                   	ret    

00800c54 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c67:	eb 1f                	jmp    800c88 <strncpy+0x34>
		*dst++ = *src;
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	8d 50 01             	lea    0x1(%eax),%edx
  800c6f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c72:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c75:	8a 12                	mov    (%edx),%dl
  800c77:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7c:	8a 00                	mov    (%eax),%al
  800c7e:	84 c0                	test   %al,%al
  800c80:	74 03                	je     800c85 <strncpy+0x31>
			src++;
  800c82:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c85:	ff 45 fc             	incl   -0x4(%ebp)
  800c88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c8b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c8e:	72 d9                	jb     800c69 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c90:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c93:	c9                   	leave  
  800c94:	c3                   	ret    

00800c95 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ca1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca5:	74 30                	je     800cd7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ca7:	eb 16                	jmp    800cbf <strlcpy+0x2a>
			*dst++ = *src++;
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	8d 50 01             	lea    0x1(%eax),%edx
  800caf:	89 55 08             	mov    %edx,0x8(%ebp)
  800cb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cb8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cbb:	8a 12                	mov    (%edx),%dl
  800cbd:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cbf:	ff 4d 10             	decl   0x10(%ebp)
  800cc2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc6:	74 09                	je     800cd1 <strlcpy+0x3c>
  800cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccb:	8a 00                	mov    (%eax),%al
  800ccd:	84 c0                	test   %al,%al
  800ccf:	75 d8                	jne    800ca9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cd7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cdd:	29 c2                	sub    %eax,%edx
  800cdf:	89 d0                	mov    %edx,%eax
}
  800ce1:	c9                   	leave  
  800ce2:	c3                   	ret    

00800ce3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ce6:	eb 06                	jmp    800cee <strcmp+0xb>
		p++, q++;
  800ce8:	ff 45 08             	incl   0x8(%ebp)
  800ceb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	8a 00                	mov    (%eax),%al
  800cf3:	84 c0                	test   %al,%al
  800cf5:	74 0e                	je     800d05 <strcmp+0x22>
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	8a 10                	mov    (%eax),%dl
  800cfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cff:	8a 00                	mov    (%eax),%al
  800d01:	38 c2                	cmp    %al,%dl
  800d03:	74 e3                	je     800ce8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	8a 00                	mov    (%eax),%al
  800d0a:	0f b6 d0             	movzbl %al,%edx
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	0f b6 c0             	movzbl %al,%eax
  800d15:	29 c2                	sub    %eax,%edx
  800d17:	89 d0                	mov    %edx,%eax
}
  800d19:	5d                   	pop    %ebp
  800d1a:	c3                   	ret    

00800d1b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d1e:	eb 09                	jmp    800d29 <strncmp+0xe>
		n--, p++, q++;
  800d20:	ff 4d 10             	decl   0x10(%ebp)
  800d23:	ff 45 08             	incl   0x8(%ebp)
  800d26:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2d:	74 17                	je     800d46 <strncmp+0x2b>
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	8a 00                	mov    (%eax),%al
  800d34:	84 c0                	test   %al,%al
  800d36:	74 0e                	je     800d46 <strncmp+0x2b>
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8a 10                	mov    (%eax),%dl
  800d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d40:	8a 00                	mov    (%eax),%al
  800d42:	38 c2                	cmp    %al,%dl
  800d44:	74 da                	je     800d20 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d46:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d4a:	75 07                	jne    800d53 <strncmp+0x38>
		return 0;
  800d4c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d51:	eb 14                	jmp    800d67 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	8a 00                	mov    (%eax),%al
  800d58:	0f b6 d0             	movzbl %al,%edx
  800d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5e:	8a 00                	mov    (%eax),%al
  800d60:	0f b6 c0             	movzbl %al,%eax
  800d63:	29 c2                	sub    %eax,%edx
  800d65:	89 d0                	mov    %edx,%eax
}
  800d67:	5d                   	pop    %ebp
  800d68:	c3                   	ret    

00800d69 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	83 ec 04             	sub    $0x4,%esp
  800d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d72:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d75:	eb 12                	jmp    800d89 <strchr+0x20>
		if (*s == c)
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d7f:	75 05                	jne    800d86 <strchr+0x1d>
			return (char *) s;
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	eb 11                	jmp    800d97 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d86:	ff 45 08             	incl   0x8(%ebp)
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	84 c0                	test   %al,%al
  800d90:	75 e5                	jne    800d77 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d97:	c9                   	leave  
  800d98:	c3                   	ret    

00800d99 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
  800d9c:	83 ec 04             	sub    $0x4,%esp
  800d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800da5:	eb 0d                	jmp    800db4 <strfind+0x1b>
		if (*s == c)
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	8a 00                	mov    (%eax),%al
  800dac:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800daf:	74 0e                	je     800dbf <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800db1:	ff 45 08             	incl   0x8(%ebp)
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	8a 00                	mov    (%eax),%al
  800db9:	84 c0                	test   %al,%al
  800dbb:	75 ea                	jne    800da7 <strfind+0xe>
  800dbd:	eb 01                	jmp    800dc0 <strfind+0x27>
		if (*s == c)
			break;
  800dbf:	90                   	nop
	return (char *) s;
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc3:	c9                   	leave  
  800dc4:	c3                   	ret    

00800dc5 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dd7:	eb 0e                	jmp    800de7 <memset+0x22>
		*p++ = c;
  800dd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ddc:	8d 50 01             	lea    0x1(%eax),%edx
  800ddf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800de2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de5:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800de7:	ff 4d f8             	decl   -0x8(%ebp)
  800dea:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dee:	79 e9                	jns    800dd9 <memset+0x14>
		*p++ = c;

	return v;
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df3:	c9                   	leave  
  800df4:	c3                   	ret    

00800df5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e07:	eb 16                	jmp    800e1f <memcpy+0x2a>
		*d++ = *s++;
  800e09:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e0c:	8d 50 01             	lea    0x1(%eax),%edx
  800e0f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e12:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e15:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e18:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e1b:	8a 12                	mov    (%edx),%dl
  800e1d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e1f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e22:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e25:	89 55 10             	mov    %edx,0x10(%ebp)
  800e28:	85 c0                	test   %eax,%eax
  800e2a:	75 dd                	jne    800e09 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e2f:	c9                   	leave  
  800e30:	c3                   	ret    

00800e31 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e31:	55                   	push   %ebp
  800e32:	89 e5                	mov    %esp,%ebp
  800e34:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  800e37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e46:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e49:	73 50                	jae    800e9b <memmove+0x6a>
  800e4b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e51:	01 d0                	add    %edx,%eax
  800e53:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e56:	76 43                	jbe    800e9b <memmove+0x6a>
		s += n;
  800e58:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e61:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e64:	eb 10                	jmp    800e76 <memmove+0x45>
			*--d = *--s;
  800e66:	ff 4d f8             	decl   -0x8(%ebp)
  800e69:	ff 4d fc             	decl   -0x4(%ebp)
  800e6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e6f:	8a 10                	mov    (%eax),%dl
  800e71:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e74:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e76:	8b 45 10             	mov    0x10(%ebp),%eax
  800e79:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e7c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e7f:	85 c0                	test   %eax,%eax
  800e81:	75 e3                	jne    800e66 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e83:	eb 23                	jmp    800ea8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e85:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e88:	8d 50 01             	lea    0x1(%eax),%edx
  800e8b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e8e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e91:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e94:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e97:	8a 12                	mov    (%edx),%dl
  800e99:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ea4:	85 c0                	test   %eax,%eax
  800ea6:	75 dd                	jne    800e85 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eab:	c9                   	leave  
  800eac:	c3                   	ret    

00800ead <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebc:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ebf:	eb 2a                	jmp    800eeb <memcmp+0x3e>
		if (*s1 != *s2)
  800ec1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec4:	8a 10                	mov    (%eax),%dl
  800ec6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec9:	8a 00                	mov    (%eax),%al
  800ecb:	38 c2                	cmp    %al,%dl
  800ecd:	74 16                	je     800ee5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ecf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed2:	8a 00                	mov    (%eax),%al
  800ed4:	0f b6 d0             	movzbl %al,%edx
  800ed7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eda:	8a 00                	mov    (%eax),%al
  800edc:	0f b6 c0             	movzbl %al,%eax
  800edf:	29 c2                	sub    %eax,%edx
  800ee1:	89 d0                	mov    %edx,%eax
  800ee3:	eb 18                	jmp    800efd <memcmp+0x50>
		s1++, s2++;
  800ee5:	ff 45 fc             	incl   -0x4(%ebp)
  800ee8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800eeb:	8b 45 10             	mov    0x10(%ebp),%eax
  800eee:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef4:	85 c0                	test   %eax,%eax
  800ef6:	75 c9                	jne    800ec1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ef8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800efd:	c9                   	leave  
  800efe:	c3                   	ret    

00800eff <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eff:	55                   	push   %ebp
  800f00:	89 e5                	mov    %esp,%ebp
  800f02:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f05:	8b 55 08             	mov    0x8(%ebp),%edx
  800f08:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0b:	01 d0                	add    %edx,%eax
  800f0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f10:	eb 15                	jmp    800f27 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	8a 00                	mov    (%eax),%al
  800f17:	0f b6 d0             	movzbl %al,%edx
  800f1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1d:	0f b6 c0             	movzbl %al,%eax
  800f20:	39 c2                	cmp    %eax,%edx
  800f22:	74 0d                	je     800f31 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f24:	ff 45 08             	incl   0x8(%ebp)
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f2d:	72 e3                	jb     800f12 <memfind+0x13>
  800f2f:	eb 01                	jmp    800f32 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f31:	90                   	nop
	return (void *) s;
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f35:	c9                   	leave  
  800f36:	c3                   	ret    

00800f37 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
  800f3a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f44:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f4b:	eb 03                	jmp    800f50 <strtol+0x19>
		s++;
  800f4d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	3c 20                	cmp    $0x20,%al
  800f57:	74 f4                	je     800f4d <strtol+0x16>
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	3c 09                	cmp    $0x9,%al
  800f60:	74 eb                	je     800f4d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	8a 00                	mov    (%eax),%al
  800f67:	3c 2b                	cmp    $0x2b,%al
  800f69:	75 05                	jne    800f70 <strtol+0x39>
		s++;
  800f6b:	ff 45 08             	incl   0x8(%ebp)
  800f6e:	eb 13                	jmp    800f83 <strtol+0x4c>
	else if (*s == '-')
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	8a 00                	mov    (%eax),%al
  800f75:	3c 2d                	cmp    $0x2d,%al
  800f77:	75 0a                	jne    800f83 <strtol+0x4c>
		s++, neg = 1;
  800f79:	ff 45 08             	incl   0x8(%ebp)
  800f7c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f83:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f87:	74 06                	je     800f8f <strtol+0x58>
  800f89:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f8d:	75 20                	jne    800faf <strtol+0x78>
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	3c 30                	cmp    $0x30,%al
  800f96:	75 17                	jne    800faf <strtol+0x78>
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	40                   	inc    %eax
  800f9c:	8a 00                	mov    (%eax),%al
  800f9e:	3c 78                	cmp    $0x78,%al
  800fa0:	75 0d                	jne    800faf <strtol+0x78>
		s += 2, base = 16;
  800fa2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fa6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fad:	eb 28                	jmp    800fd7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800faf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb3:	75 15                	jne    800fca <strtol+0x93>
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	3c 30                	cmp    $0x30,%al
  800fbc:	75 0c                	jne    800fca <strtol+0x93>
		s++, base = 8;
  800fbe:	ff 45 08             	incl   0x8(%ebp)
  800fc1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fc8:	eb 0d                	jmp    800fd7 <strtol+0xa0>
	else if (base == 0)
  800fca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fce:	75 07                	jne    800fd7 <strtol+0xa0>
		base = 10;
  800fd0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	3c 2f                	cmp    $0x2f,%al
  800fde:	7e 19                	jle    800ff9 <strtol+0xc2>
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	8a 00                	mov    (%eax),%al
  800fe5:	3c 39                	cmp    $0x39,%al
  800fe7:	7f 10                	jg     800ff9 <strtol+0xc2>
			dig = *s - '0';
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	0f be c0             	movsbl %al,%eax
  800ff1:	83 e8 30             	sub    $0x30,%eax
  800ff4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ff7:	eb 42                	jmp    80103b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	8a 00                	mov    (%eax),%al
  800ffe:	3c 60                	cmp    $0x60,%al
  801000:	7e 19                	jle    80101b <strtol+0xe4>
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	8a 00                	mov    (%eax),%al
  801007:	3c 7a                	cmp    $0x7a,%al
  801009:	7f 10                	jg     80101b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80100b:	8b 45 08             	mov    0x8(%ebp),%eax
  80100e:	8a 00                	mov    (%eax),%al
  801010:	0f be c0             	movsbl %al,%eax
  801013:	83 e8 57             	sub    $0x57,%eax
  801016:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801019:	eb 20                	jmp    80103b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
  80101e:	8a 00                	mov    (%eax),%al
  801020:	3c 40                	cmp    $0x40,%al
  801022:	7e 39                	jle    80105d <strtol+0x126>
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
  801027:	8a 00                	mov    (%eax),%al
  801029:	3c 5a                	cmp    $0x5a,%al
  80102b:	7f 30                	jg     80105d <strtol+0x126>
			dig = *s - 'A' + 10;
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	0f be c0             	movsbl %al,%eax
  801035:	83 e8 37             	sub    $0x37,%eax
  801038:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80103b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80103e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801041:	7d 19                	jge    80105c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801043:	ff 45 08             	incl   0x8(%ebp)
  801046:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801049:	0f af 45 10          	imul   0x10(%ebp),%eax
  80104d:	89 c2                	mov    %eax,%edx
  80104f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801052:	01 d0                	add    %edx,%eax
  801054:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801057:	e9 7b ff ff ff       	jmp    800fd7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80105c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80105d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801061:	74 08                	je     80106b <strtol+0x134>
		*endptr = (char *) s;
  801063:	8b 45 0c             	mov    0xc(%ebp),%eax
  801066:	8b 55 08             	mov    0x8(%ebp),%edx
  801069:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80106b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80106f:	74 07                	je     801078 <strtol+0x141>
  801071:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801074:	f7 d8                	neg    %eax
  801076:	eb 03                	jmp    80107b <strtol+0x144>
  801078:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80107b:	c9                   	leave  
  80107c:	c3                   	ret    

0080107d <ltostr>:

void
ltostr(long value, char *str)
{
  80107d:	55                   	push   %ebp
  80107e:	89 e5                	mov    %esp,%ebp
  801080:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801083:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80108a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801091:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801095:	79 13                	jns    8010aa <ltostr+0x2d>
	{
		neg = 1;
  801097:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80109e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010a4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010a7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010b2:	99                   	cltd   
  8010b3:	f7 f9                	idiv   %ecx
  8010b5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bb:	8d 50 01             	lea    0x1(%eax),%edx
  8010be:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010c1:	89 c2                	mov    %eax,%edx
  8010c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c6:	01 d0                	add    %edx,%eax
  8010c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010cb:	83 c2 30             	add    $0x30,%edx
  8010ce:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010d3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010d8:	f7 e9                	imul   %ecx
  8010da:	c1 fa 02             	sar    $0x2,%edx
  8010dd:	89 c8                	mov    %ecx,%eax
  8010df:	c1 f8 1f             	sar    $0x1f,%eax
  8010e2:	29 c2                	sub    %eax,%edx
  8010e4:	89 d0                	mov    %edx,%eax
  8010e6:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ec:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010f1:	f7 e9                	imul   %ecx
  8010f3:	c1 fa 02             	sar    $0x2,%edx
  8010f6:	89 c8                	mov    %ecx,%eax
  8010f8:	c1 f8 1f             	sar    $0x1f,%eax
  8010fb:	29 c2                	sub    %eax,%edx
  8010fd:	89 d0                	mov    %edx,%eax
  8010ff:	c1 e0 02             	shl    $0x2,%eax
  801102:	01 d0                	add    %edx,%eax
  801104:	01 c0                	add    %eax,%eax
  801106:	29 c1                	sub    %eax,%ecx
  801108:	89 ca                	mov    %ecx,%edx
  80110a:	85 d2                	test   %edx,%edx
  80110c:	75 9c                	jne    8010aa <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80110e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801115:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801118:	48                   	dec    %eax
  801119:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80111c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801120:	74 3d                	je     80115f <ltostr+0xe2>
		start = 1 ;
  801122:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801129:	eb 34                	jmp    80115f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80112b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80112e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801131:	01 d0                	add    %edx,%eax
  801133:	8a 00                	mov    (%eax),%al
  801135:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801138:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80113b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113e:	01 c2                	add    %eax,%edx
  801140:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801143:	8b 45 0c             	mov    0xc(%ebp),%eax
  801146:	01 c8                	add    %ecx,%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80114c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80114f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801152:	01 c2                	add    %eax,%edx
  801154:	8a 45 eb             	mov    -0x15(%ebp),%al
  801157:	88 02                	mov    %al,(%edx)
		start++ ;
  801159:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80115c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80115f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801162:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801165:	7c c4                	jl     80112b <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801167:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80116a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116d:	01 d0                	add    %edx,%eax
  80116f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801172:	90                   	nop
  801173:	c9                   	leave  
  801174:	c3                   	ret    

00801175 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801175:	55                   	push   %ebp
  801176:	89 e5                	mov    %esp,%ebp
  801178:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80117b:	ff 75 08             	pushl  0x8(%ebp)
  80117e:	e8 54 fa ff ff       	call   800bd7 <strlen>
  801183:	83 c4 04             	add    $0x4,%esp
  801186:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801189:	ff 75 0c             	pushl  0xc(%ebp)
  80118c:	e8 46 fa ff ff       	call   800bd7 <strlen>
  801191:	83 c4 04             	add    $0x4,%esp
  801194:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801197:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80119e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011a5:	eb 17                	jmp    8011be <strcconcat+0x49>
		final[s] = str1[s] ;
  8011a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ad:	01 c2                	add    %eax,%edx
  8011af:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	01 c8                	add    %ecx,%eax
  8011b7:	8a 00                	mov    (%eax),%al
  8011b9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011bb:	ff 45 fc             	incl   -0x4(%ebp)
  8011be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011c4:	7c e1                	jl     8011a7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011c6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011cd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011d4:	eb 1f                	jmp    8011f5 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d9:	8d 50 01             	lea    0x1(%eax),%edx
  8011dc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011df:	89 c2                	mov    %eax,%edx
  8011e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e4:	01 c2                	add    %eax,%edx
  8011e6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ec:	01 c8                	add    %ecx,%eax
  8011ee:	8a 00                	mov    (%eax),%al
  8011f0:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011f2:	ff 45 f8             	incl   -0x8(%ebp)
  8011f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011fb:	7c d9                	jl     8011d6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801200:	8b 45 10             	mov    0x10(%ebp),%eax
  801203:	01 d0                	add    %edx,%eax
  801205:	c6 00 00             	movb   $0x0,(%eax)
}
  801208:	90                   	nop
  801209:	c9                   	leave  
  80120a:	c3                   	ret    

0080120b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80120e:	8b 45 14             	mov    0x14(%ebp),%eax
  801211:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801217:	8b 45 14             	mov    0x14(%ebp),%eax
  80121a:	8b 00                	mov    (%eax),%eax
  80121c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801223:	8b 45 10             	mov    0x10(%ebp),%eax
  801226:	01 d0                	add    %edx,%eax
  801228:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80122e:	eb 0c                	jmp    80123c <strsplit+0x31>
			*string++ = 0;
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
  801233:	8d 50 01             	lea    0x1(%eax),%edx
  801236:	89 55 08             	mov    %edx,0x8(%ebp)
  801239:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80123c:	8b 45 08             	mov    0x8(%ebp),%eax
  80123f:	8a 00                	mov    (%eax),%al
  801241:	84 c0                	test   %al,%al
  801243:	74 18                	je     80125d <strsplit+0x52>
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	8a 00                	mov    (%eax),%al
  80124a:	0f be c0             	movsbl %al,%eax
  80124d:	50                   	push   %eax
  80124e:	ff 75 0c             	pushl  0xc(%ebp)
  801251:	e8 13 fb ff ff       	call   800d69 <strchr>
  801256:	83 c4 08             	add    $0x8,%esp
  801259:	85 c0                	test   %eax,%eax
  80125b:	75 d3                	jne    801230 <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	8a 00                	mov    (%eax),%al
  801262:	84 c0                	test   %al,%al
  801264:	74 5a                	je     8012c0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  801266:	8b 45 14             	mov    0x14(%ebp),%eax
  801269:	8b 00                	mov    (%eax),%eax
  80126b:	83 f8 0f             	cmp    $0xf,%eax
  80126e:	75 07                	jne    801277 <strsplit+0x6c>
		{
			return 0;
  801270:	b8 00 00 00 00       	mov    $0x0,%eax
  801275:	eb 66                	jmp    8012dd <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801277:	8b 45 14             	mov    0x14(%ebp),%eax
  80127a:	8b 00                	mov    (%eax),%eax
  80127c:	8d 48 01             	lea    0x1(%eax),%ecx
  80127f:	8b 55 14             	mov    0x14(%ebp),%edx
  801282:	89 0a                	mov    %ecx,(%edx)
  801284:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80128b:	8b 45 10             	mov    0x10(%ebp),%eax
  80128e:	01 c2                	add    %eax,%edx
  801290:	8b 45 08             	mov    0x8(%ebp),%eax
  801293:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801295:	eb 03                	jmp    80129a <strsplit+0x8f>
			string++;
  801297:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80129a:	8b 45 08             	mov    0x8(%ebp),%eax
  80129d:	8a 00                	mov    (%eax),%al
  80129f:	84 c0                	test   %al,%al
  8012a1:	74 8b                	je     80122e <strsplit+0x23>
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	0f be c0             	movsbl %al,%eax
  8012ab:	50                   	push   %eax
  8012ac:	ff 75 0c             	pushl  0xc(%ebp)
  8012af:	e8 b5 fa ff ff       	call   800d69 <strchr>
  8012b4:	83 c4 08             	add    $0x8,%esp
  8012b7:	85 c0                	test   %eax,%eax
  8012b9:	74 dc                	je     801297 <strsplit+0x8c>
			string++;
	}
  8012bb:	e9 6e ff ff ff       	jmp    80122e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012c0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c4:	8b 00                	mov    (%eax),%eax
  8012c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d0:	01 d0                	add    %edx,%eax
  8012d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012d8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012dd:	c9                   	leave  
  8012de:	c3                   	ret    

008012df <malloc>:
int cnt_mem = 0;
int heap_mem[size_uhmem] = { 0 };
struct hmem heap_size[size_uhmem] = { 0 };
int check = 0;

void* malloc(uint32 size) {
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
  8012e2:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyNEXTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	//NEXT FIT
	if (sys_isUHeapPlacementStrategyNEXTFIT()) {
  8012e8:	e8 7d 0f 00 00       	call   80226a <sys_isUHeapPlacementStrategyNEXTFIT>
  8012ed:	85 c0                	test   %eax,%eax
  8012ef:	0f 84 6f 03 00 00    	je     801664 <malloc+0x385>
		size = ROUNDUP(size, PAGE_SIZE);
  8012f5:	c7 45 84 00 10 00 00 	movl   $0x1000,-0x7c(%ebp)
  8012fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ff:	8b 45 84             	mov    -0x7c(%ebp),%eax
  801302:	01 d0                	add    %edx,%eax
  801304:	48                   	dec    %eax
  801305:	89 45 80             	mov    %eax,-0x80(%ebp)
  801308:	8b 45 80             	mov    -0x80(%ebp),%eax
  80130b:	ba 00 00 00 00       	mov    $0x0,%edx
  801310:	f7 75 84             	divl   -0x7c(%ebp)
  801313:	8b 45 80             	mov    -0x80(%ebp),%eax
  801316:	29 d0                	sub    %edx,%eax
  801318:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  80131b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80131f:	74 09                	je     80132a <malloc+0x4b>
  801321:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801328:	76 0a                	jbe    801334 <malloc+0x55>
			return NULL;
  80132a:	b8 00 00 00 00       	mov    $0x0,%eax
  80132f:	e9 4b 09 00 00       	jmp    801c7f <malloc+0x9a0>
		}
		// first we can allocate by " Strategy Continues "
		if (ptr_uheap + size <= (uint32) USER_HEAP_MAX && !check) {
  801334:	8b 15 04 30 80 00    	mov    0x803004,%edx
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
  80133d:	01 d0                	add    %edx,%eax
  80133f:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801344:	0f 87 a2 00 00 00    	ja     8013ec <malloc+0x10d>
  80134a:	a1 40 30 98 00       	mov    0x983040,%eax
  80134f:	85 c0                	test   %eax,%eax
  801351:	0f 85 95 00 00 00    	jne    8013ec <malloc+0x10d>

			void* ret = (void *) ptr_uheap;
  801357:	a1 04 30 80 00       	mov    0x803004,%eax
  80135c:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			sys_allocateMem(ptr_uheap, size);
  801362:	a1 04 30 80 00       	mov    0x803004,%eax
  801367:	83 ec 08             	sub    $0x8,%esp
  80136a:	ff 75 08             	pushl  0x8(%ebp)
  80136d:	50                   	push   %eax
  80136e:	e8 a3 0b 00 00       	call   801f16 <sys_allocateMem>
  801373:	83 c4 10             	add    $0x10,%esp

			heap_size[cnt_mem].size = size;
  801376:	a1 20 30 80 00       	mov    0x803020,%eax
  80137b:	8b 55 08             	mov    0x8(%ebp),%edx
  80137e:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801385:	a1 20 30 80 00       	mov    0x803020,%eax
  80138a:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801390:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
			cnt_mem++;
  801397:	a1 20 30 80 00       	mov    0x803020,%eax
  80139c:	40                   	inc    %eax
  80139d:	a3 20 30 80 00       	mov    %eax,0x803020
			int i = 0;
  8013a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  8013a9:	eb 2e                	jmp    8013d9 <malloc+0xfa>
			{

				heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8013ab:	a1 04 30 80 00       	mov    0x803004,%eax
  8013b0:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] = 1;
  8013b5:	c1 e8 0c             	shr    $0xc,%eax
  8013b8:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  8013bf:	01 00 00 00 

				ptr_uheap += (uint32) PAGE_SIZE;
  8013c3:	a1 04 30 80 00       	mov    0x803004,%eax
  8013c8:	05 00 10 00 00       	add    $0x1000,%eax
  8013cd:	a3 04 30 80 00       	mov    %eax,0x803004
			heap_size[cnt_mem].size = size;
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
			cnt_mem++;
			int i = 0;
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  8013d2:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  8013d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013dc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8013df:	72 ca                	jb     8013ab <malloc+0xcc>
						/ (uint32) PAGE_SIZE)] = 1;

				ptr_uheap += (uint32) PAGE_SIZE;
			}

			return ret;
  8013e1:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8013e7:	e9 93 08 00 00       	jmp    801c7f <malloc+0x9a0>

		} else {
			// second we can allocate by " Strategy NEXTFIT "
			void* temp_end = NULL;
  8013ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

			int check_start = 0;
  8013f3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			// check first that we used " Strategy Continues " before and not do it again and turn to NEXTFIT
			if (!check) {
  8013fa:	a1 40 30 98 00       	mov    0x983040,%eax
  8013ff:	85 c0                	test   %eax,%eax
  801401:	75 1d                	jne    801420 <malloc+0x141>
				ptr_uheap = (uint32) USER_HEAP_START;
  801403:	c7 05 04 30 80 00 00 	movl   $0x80000000,0x803004
  80140a:	00 00 80 
				check = 1;
  80140d:	c7 05 40 30 98 00 01 	movl   $0x1,0x983040
  801414:	00 00 00 
				check_start = 1;// to dont use second loop CZ ptr_uheap start from USER_HEAP_START
  801417:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  80141e:	eb 08                	jmp    801428 <malloc+0x149>
			} else {
				temp_end = (void*) ptr_uheap;
  801420:	a1 04 30 80 00       	mov    0x803004,%eax
  801425:	89 45 f0             	mov    %eax,-0x10(%ebp)

			}

			uint32 sz = 0;
  801428:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
			int f = 0;
  80142f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			uint32 ptr = ptr_uheap;
  801436:	a1 04 30 80 00       	mov    0x803004,%eax
  80143b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  80143e:	eb 4d                	jmp    80148d <malloc+0x1ae>
				if (sz == size) {
  801440:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801443:	3b 45 08             	cmp    0x8(%ebp),%eax
  801446:	75 09                	jne    801451 <malloc+0x172>
					f = 1;
  801448:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  80144f:	eb 45                	jmp    801496 <malloc+0x1b7>
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801451:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801454:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] == 0) {
  801459:	c1 e8 0c             	shr    $0xc,%eax
			while (ptr < (uint32) USER_HEAP_MAX) {
				if (sz == size) {
					f = 1;
					break;
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  80145c:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  801463:	85 c0                	test   %eax,%eax
  801465:	75 10                	jne    801477 <malloc+0x198>
						/ (uint32) PAGE_SIZE)] == 0) {

					sz += PAGE_SIZE;
  801467:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
					ptr += PAGE_SIZE;
  80146e:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  801475:	eb 16                	jmp    80148d <malloc+0x1ae>
				} else {
					sz = 0;
  801477:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
					ptr += PAGE_SIZE;
  80147e:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
					ptr_uheap = ptr;
  801485:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801488:	a3 04 30 80 00       	mov    %eax,0x803004

			uint32 sz = 0;
			int f = 0;
			uint32 ptr = ptr_uheap;
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  80148d:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  801494:	76 aa                	jbe    801440 <malloc+0x161>
					ptr_uheap = ptr;
				}

			}

			if (f) {
  801496:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80149a:	0f 84 95 00 00 00    	je     801535 <malloc+0x256>

				void* ret = (void *) ptr_uheap;
  8014a0:	a1 04 30 80 00       	mov    0x803004,%eax
  8014a5:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

				sys_allocateMem(ptr_uheap, size);
  8014ab:	a1 04 30 80 00       	mov    0x803004,%eax
  8014b0:	83 ec 08             	sub    $0x8,%esp
  8014b3:	ff 75 08             	pushl  0x8(%ebp)
  8014b6:	50                   	push   %eax
  8014b7:	e8 5a 0a 00 00       	call   801f16 <sys_allocateMem>
  8014bc:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  8014bf:	a1 20 30 80 00       	mov    0x803020,%eax
  8014c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8014c7:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8014ce:	a1 20 30 80 00       	mov    0x803020,%eax
  8014d3:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8014d9:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
				cnt_mem++;
  8014e0:	a1 20 30 80 00       	mov    0x803020,%eax
  8014e5:	40                   	inc    %eax
  8014e6:	a3 20 30 80 00       	mov    %eax,0x803020
				int i = 0;
  8014eb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  8014f2:	eb 2e                	jmp    801522 <malloc+0x243>
				{

					heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8014f4:	a1 04 30 80 00       	mov    0x803004,%eax
  8014f9:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  8014fe:	c1 e8 0c             	shr    $0xc,%eax
  801501:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801508:	01 00 00 00 

					ptr_uheap += (uint32) PAGE_SIZE;
  80150c:	a1 04 30 80 00       	mov    0x803004,%eax
  801511:	05 00 10 00 00       	add    $0x1000,%eax
  801516:	a3 04 30 80 00       	mov    %eax,0x803004
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
				cnt_mem++;
				int i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  80151b:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801522:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801525:	3b 45 08             	cmp    0x8(%ebp),%eax
  801528:	72 ca                	jb     8014f4 <malloc+0x215>
							/ (uint32) PAGE_SIZE)] = 1;

					ptr_uheap += (uint32) PAGE_SIZE;
				}

				return ret;
  80152a:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  801530:	e9 4a 07 00 00       	jmp    801c7f <malloc+0x9a0>

			} else {

				if (check_start) {
  801535:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801539:	74 0a                	je     801545 <malloc+0x266>

					return NULL;
  80153b:	b8 00 00 00 00       	mov    $0x0,%eax
  801540:	e9 3a 07 00 00       	jmp    801c7f <malloc+0x9a0>
				}

//////////////back loop////////////////

				uint32 sz = 0;
  801545:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
				int f = 0;
  80154c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				uint32 ptr = USER_HEAP_START;
  801553:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
				ptr_uheap = USER_HEAP_START;
  80155a:	c7 05 04 30 80 00 00 	movl   $0x80000000,0x803004
  801561:	00 00 80 
				while (ptr < (uint32) temp_end) {
  801564:	eb 4d                	jmp    8015b3 <malloc+0x2d4>
					if (sz == size) {
  801566:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801569:	3b 45 08             	cmp    0x8(%ebp),%eax
  80156c:	75 09                	jne    801577 <malloc+0x298>
						f = 1;
  80156e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
						break;
  801575:	eb 44                	jmp    8015bb <malloc+0x2dc>
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801577:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80157a:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] == 0) {
  80157f:	c1 e8 0c             	shr    $0xc,%eax
				while (ptr < (uint32) temp_end) {
					if (sz == size) {
						f = 1;
						break;
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801582:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  801589:	85 c0                	test   %eax,%eax
  80158b:	75 10                	jne    80159d <malloc+0x2be>
							/ (uint32) PAGE_SIZE)] == 0) {

						sz += PAGE_SIZE;
  80158d:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801594:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
  80159b:	eb 16                	jmp    8015b3 <malloc+0x2d4>
					} else {
						sz = 0;
  80159d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
						ptr += PAGE_SIZE;
  8015a4:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
						ptr_uheap = ptr;
  8015ab:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8015ae:	a3 04 30 80 00       	mov    %eax,0x803004

				uint32 sz = 0;
				int f = 0;
				uint32 ptr = USER_HEAP_START;
				ptr_uheap = USER_HEAP_START;
				while (ptr < (uint32) temp_end) {
  8015b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b6:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  8015b9:	72 ab                	jb     801566 <malloc+0x287>
						ptr_uheap = ptr;
					}

				}

				if (f) {
  8015bb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8015bf:	0f 84 95 00 00 00    	je     80165a <malloc+0x37b>

					void* ret = (void *) ptr_uheap;
  8015c5:	a1 04 30 80 00       	mov    0x803004,%eax
  8015ca:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

					sys_allocateMem(ptr_uheap, size);
  8015d0:	a1 04 30 80 00       	mov    0x803004,%eax
  8015d5:	83 ec 08             	sub    $0x8,%esp
  8015d8:	ff 75 08             	pushl  0x8(%ebp)
  8015db:	50                   	push   %eax
  8015dc:	e8 35 09 00 00       	call   801f16 <sys_allocateMem>
  8015e1:	83 c4 10             	add    $0x10,%esp

					heap_size[cnt_mem].size = size;
  8015e4:	a1 20 30 80 00       	mov    0x803020,%eax
  8015e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ec:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8015f3:	a1 20 30 80 00       	mov    0x803020,%eax
  8015f8:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8015fe:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
					cnt_mem++;
  801605:	a1 20 30 80 00       	mov    0x803020,%eax
  80160a:	40                   	inc    %eax
  80160b:	a3 20 30 80 00       	mov    %eax,0x803020
					int i = 0;
  801610:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

					for (; i < size; i += PAGE_SIZE)
  801617:	eb 2e                	jmp    801647 <malloc+0x368>
					{

						heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801619:	a1 04 30 80 00       	mov    0x803004,%eax
  80161e:	05 00 00 00 80       	add    $0x80000000,%eax
								/ (uint32) PAGE_SIZE)] = 1;
  801623:	c1 e8 0c             	shr    $0xc,%eax
  801626:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  80162d:	01 00 00 00 

						ptr_uheap += (uint32) PAGE_SIZE;
  801631:	a1 04 30 80 00       	mov    0x803004,%eax
  801636:	05 00 10 00 00       	add    $0x1000,%eax
  80163b:	a3 04 30 80 00       	mov    %eax,0x803004
					heap_size[cnt_mem].size = size;
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
					cnt_mem++;
					int i = 0;

					for (; i < size; i += PAGE_SIZE)
  801640:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  801647:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80164a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80164d:	72 ca                	jb     801619 <malloc+0x33a>
								/ (uint32) PAGE_SIZE)] = 1;

						ptr_uheap += (uint32) PAGE_SIZE;
					}

					return ret;
  80164f:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801655:	e9 25 06 00 00       	jmp    801c7f <malloc+0x9a0>

				} else {

					return NULL;
  80165a:	b8 00 00 00 00       	mov    $0x0,%eax
  80165f:	e9 1b 06 00 00       	jmp    801c7f <malloc+0x9a0>

		}

	}

	else if (sys_isUHeapPlacementStrategyBESTFIT()) {
  801664:	e8 d0 0b 00 00       	call   802239 <sys_isUHeapPlacementStrategyBESTFIT>
  801669:	85 c0                	test   %eax,%eax
  80166b:	0f 84 ba 01 00 00    	je     80182b <malloc+0x54c>

		size = ROUNDUP(size, PAGE_SIZE);
  801671:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  801678:	10 00 00 
  80167b:	8b 55 08             	mov    0x8(%ebp),%edx
  80167e:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  801684:	01 d0                	add    %edx,%eax
  801686:	48                   	dec    %eax
  801687:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  80168d:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801693:	ba 00 00 00 00       	mov    $0x0,%edx
  801698:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  80169e:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8016a4:	29 d0                	sub    %edx,%eax
  8016a6:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  8016a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016ad:	74 09                	je     8016b8 <malloc+0x3d9>
  8016af:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8016b6:	76 0a                	jbe    8016c2 <malloc+0x3e3>
			return NULL;
  8016b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8016bd:	e9 bd 05 00 00       	jmp    801c7f <malloc+0x9a0>
		}
		uint32 ptr = (uint32) USER_HEAP_START;
  8016c2:	c7 45 c8 00 00 00 80 	movl   $0x80000000,-0x38(%ebp)
		uint32 temp = 0;
  8016c9:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		uint32 min_sz = size_uhmem + 1;
  8016d0:	c7 45 c0 01 00 02 00 	movl   $0x20001,-0x40(%ebp)
		uint32 count = 0;
  8016d7:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
		int i = 0;
  8016de:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  8016e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e8:	c1 e8 0c             	shr    $0xc,%eax
  8016eb:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  8016f1:	e9 80 00 00 00       	jmp    801776 <malloc+0x497>

			if (heap_mem[i] == 0) {
  8016f6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8016f9:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  801700:	85 c0                	test   %eax,%eax
  801702:	75 0c                	jne    801710 <malloc+0x431>

				count++;
  801704:	ff 45 bc             	incl   -0x44(%ebp)
				ptr += PAGE_SIZE;
  801707:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  80170e:	eb 2d                	jmp    80173d <malloc+0x45e>
			} else {
				if (num_p <= count && min_sz > count) {
  801710:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801716:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801719:	77 14                	ja     80172f <malloc+0x450>
  80171b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80171e:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801721:	76 0c                	jbe    80172f <malloc+0x450>

					min_sz = count;
  801723:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801726:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801729:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80172c:	89 45 c4             	mov    %eax,-0x3c(%ebp)

				}
				count = 0;
  80172f:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
				ptr += PAGE_SIZE;
  801736:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
			}

			if (i == size_uhmem - 1) {
  80173d:	81 7d b8 ff ff 01 00 	cmpl   $0x1ffff,-0x48(%ebp)
  801744:	75 2d                	jne    801773 <malloc+0x494>

				if (num_p <= count && min_sz > count) {
  801746:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80174c:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  80174f:	77 22                	ja     801773 <malloc+0x494>
  801751:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801754:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801757:	76 1a                	jbe    801773 <malloc+0x494>

					min_sz = count;
  801759:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80175c:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  80175f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801762:	89 45 c4             	mov    %eax,-0x3c(%ebp)
					count = 0;
  801765:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
					ptr += PAGE_SIZE;
  80176c:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801773:	ff 45 b8             	incl   -0x48(%ebp)
  801776:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801779:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  80177e:	0f 86 72 ff ff ff    	jbe    8016f6 <malloc+0x417>

			}

		}

		if (num_p > min_sz || temp == 0) {
  801784:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80178a:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  80178d:	77 06                	ja     801795 <malloc+0x4b6>
  80178f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801793:	75 0a                	jne    80179f <malloc+0x4c0>
			return NULL;
  801795:	b8 00 00 00 00       	mov    $0x0,%eax
  80179a:	e9 e0 04 00 00       	jmp    801c7f <malloc+0x9a0>

		}

		temp = temp - (PAGE_SIZE * min_sz);
  80179f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8017a2:	c1 e0 0c             	shl    $0xc,%eax
  8017a5:	29 45 c4             	sub    %eax,-0x3c(%ebp)
		void* ret = (void*) temp;
  8017a8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8017ab:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)

		sys_allocateMem(temp, size);
  8017b1:	83 ec 08             	sub    $0x8,%esp
  8017b4:	ff 75 08             	pushl  0x8(%ebp)
  8017b7:	ff 75 c4             	pushl  -0x3c(%ebp)
  8017ba:	e8 57 07 00 00       	call   801f16 <sys_allocateMem>
  8017bf:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  8017c2:	a1 20 30 80 00       	mov    0x803020,%eax
  8017c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8017ca:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  8017d1:	a1 20 30 80 00       	mov    0x803020,%eax
  8017d6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8017d9:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
		cnt_mem++;
  8017e0:	a1 20 30 80 00       	mov    0x803020,%eax
  8017e5:	40                   	inc    %eax
  8017e6:	a3 20 30 80 00       	mov    %eax,0x803020
		i = 0;
  8017eb:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  8017f2:	eb 24                	jmp    801818 <malloc+0x539>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  8017f4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8017f7:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  8017fc:	c1 e8 0c             	shr    $0xc,%eax
  8017ff:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801806:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  80180a:	81 45 c4 00 10 00 00 	addl   $0x1000,-0x3c(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801811:	81 45 b8 00 10 00 00 	addl   $0x1000,-0x48(%ebp)
  801818:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80181b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80181e:	72 d4                	jb     8017f4 <malloc+0x515>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801820:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801826:	e9 54 04 00 00       	jmp    801c7f <malloc+0x9a0>

	} else if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  80182b:	e8 d8 09 00 00       	call   802208 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801830:	85 c0                	test   %eax,%eax
  801832:	0f 84 88 01 00 00    	je     8019c0 <malloc+0x6e1>

		size = ROUNDUP(size, PAGE_SIZE);
  801838:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  80183f:	10 00 00 
  801842:	8b 55 08             	mov    0x8(%ebp),%edx
  801845:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80184b:	01 d0                	add    %edx,%eax
  80184d:	48                   	dec    %eax
  80184e:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  801854:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  80185a:	ba 00 00 00 00       	mov    $0x0,%edx
  80185f:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  801865:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  80186b:	29 d0                	sub    %edx,%eax
  80186d:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801870:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801874:	74 09                	je     80187f <malloc+0x5a0>
  801876:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80187d:	76 0a                	jbe    801889 <malloc+0x5aa>
			return NULL;
  80187f:	b8 00 00 00 00       	mov    $0x0,%eax
  801884:	e9 f6 03 00 00       	jmp    801c7f <malloc+0x9a0>
		}

		uint32 ptr = (uint32) USER_HEAP_START;
  801889:	c7 45 b4 00 00 00 80 	movl   $0x80000000,-0x4c(%ebp)
		uint32 temp = 0;
  801890:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
		uint32 found = 0;
  801897:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		uint32 count = 0;
  80189e:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
		int i = 0;
  8018a5:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  8018ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8018af:	c1 e8 0c             	shr    $0xc,%eax
  8018b2:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

		for (; i < size_uhmem; i++) {
  8018b8:	eb 5a                	jmp    801914 <malloc+0x635>

			if (heap_mem[i] == 0) {
  8018ba:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8018bd:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  8018c4:	85 c0                	test   %eax,%eax
  8018c6:	75 0c                	jne    8018d4 <malloc+0x5f5>

				count++;
  8018c8:	ff 45 a8             	incl   -0x58(%ebp)
				ptr += PAGE_SIZE;
  8018cb:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
  8018d2:	eb 22                	jmp    8018f6 <malloc+0x617>
			} else {
				if (num_p <= count) {
  8018d4:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8018da:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  8018dd:	77 09                	ja     8018e8 <malloc+0x609>

					found = 1;
  8018df:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)

					break;
  8018e6:	eb 36                	jmp    80191e <malloc+0x63f>
				}
				count = 0;
  8018e8:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
				ptr += PAGE_SIZE;
  8018ef:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
			}

			if (i == size_uhmem - 1) {
  8018f6:	81 7d a4 ff ff 01 00 	cmpl   $0x1ffff,-0x5c(%ebp)
  8018fd:	75 12                	jne    801911 <malloc+0x632>

				if (num_p <= count) {
  8018ff:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801905:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801908:	77 07                	ja     801911 <malloc+0x632>

					found = 1;
  80190a:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
		uint32 found = 0;
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		for (; i < size_uhmem; i++) {
  801911:	ff 45 a4             	incl   -0x5c(%ebp)
  801914:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801917:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  80191c:	76 9c                	jbe    8018ba <malloc+0x5db>

			}

		}

		if (!found) {
  80191e:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  801922:	75 0a                	jne    80192e <malloc+0x64f>
			return NULL;
  801924:	b8 00 00 00 00       	mov    $0x0,%eax
  801929:	e9 51 03 00 00       	jmp    801c7f <malloc+0x9a0>

		}

		temp = ptr;
  80192e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801931:	89 45 b0             	mov    %eax,-0x50(%ebp)
		temp = temp - (PAGE_SIZE * count);
  801934:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801937:	c1 e0 0c             	shl    $0xc,%eax
  80193a:	29 45 b0             	sub    %eax,-0x50(%ebp)
		void* ret = (void*) temp;
  80193d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801940:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)

		sys_allocateMem(temp, size);
  801946:	83 ec 08             	sub    $0x8,%esp
  801949:	ff 75 08             	pushl  0x8(%ebp)
  80194c:	ff 75 b0             	pushl  -0x50(%ebp)
  80194f:	e8 c2 05 00 00       	call   801f16 <sys_allocateMem>
  801954:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801957:	a1 20 30 80 00       	mov    0x803020,%eax
  80195c:	8b 55 08             	mov    0x8(%ebp),%edx
  80195f:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801966:	a1 20 30 80 00       	mov    0x803020,%eax
  80196b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80196e:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
		cnt_mem++;
  801975:	a1 20 30 80 00       	mov    0x803020,%eax
  80197a:	40                   	inc    %eax
  80197b:	a3 20 30 80 00       	mov    %eax,0x803020
		i = 0;
  801980:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801987:	eb 24                	jmp    8019ad <malloc+0x6ce>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801989:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80198c:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801991:	c1 e8 0c             	shr    $0xc,%eax
  801994:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  80199b:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  80199f:	81 45 b0 00 10 00 00 	addl   $0x1000,-0x50(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  8019a6:	81 45 a4 00 10 00 00 	addl   $0x1000,-0x5c(%ebp)
  8019ad:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8019b0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8019b3:	72 d4                	jb     801989 <malloc+0x6aa>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  8019b5:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  8019bb:	e9 bf 02 00 00       	jmp    801c7f <malloc+0x9a0>

	}
	else if(sys_isUHeapPlacementStrategyWORSTFIT())
  8019c0:	e8 d6 08 00 00       	call   80229b <sys_isUHeapPlacementStrategyWORSTFIT>
  8019c5:	85 c0                	test   %eax,%eax
  8019c7:	0f 84 ba 01 00 00    	je     801b87 <malloc+0x8a8>
	{
		size = ROUNDUP(size, PAGE_SIZE);
  8019cd:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  8019d4:	10 00 00 
  8019d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8019da:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  8019e0:	01 d0                	add    %edx,%eax
  8019e2:	48                   	dec    %eax
  8019e3:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  8019e9:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  8019ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f4:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  8019fa:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  801a00:	29 d0                	sub    %edx,%eax
  801a02:	89 45 08             	mov    %eax,0x8(%ebp)

				if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801a05:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a09:	74 09                	je     801a14 <malloc+0x735>
  801a0b:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801a12:	76 0a                	jbe    801a1e <malloc+0x73f>
					return NULL;
  801a14:	b8 00 00 00 00       	mov    $0x0,%eax
  801a19:	e9 61 02 00 00       	jmp    801c7f <malloc+0x9a0>
				}
				uint32 ptr = (uint32) USER_HEAP_START;
  801a1e:	c7 45 a0 00 00 00 80 	movl   $0x80000000,-0x60(%ebp)
				uint32 temp = 0;
  801a25:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
				uint32 max_sz = -1;
  801a2c:	c7 45 98 ff ff ff ff 	movl   $0xffffffff,-0x68(%ebp)
				uint32 count = 0;
  801a33:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
				int i = 0;
  801a3a:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				uint32 num_p = size / PAGE_SIZE;
  801a41:	8b 45 08             	mov    0x8(%ebp),%eax
  801a44:	c1 e8 0c             	shr    $0xc,%eax
  801a47:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  801a4d:	e9 80 00 00 00       	jmp    801ad2 <malloc+0x7f3>

					if (heap_mem[i] == 0) {
  801a52:	8b 45 90             	mov    -0x70(%ebp),%eax
  801a55:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  801a5c:	85 c0                	test   %eax,%eax
  801a5e:	75 0c                	jne    801a6c <malloc+0x78d>

						count++;
  801a60:	ff 45 94             	incl   -0x6c(%ebp)
						ptr += PAGE_SIZE;
  801a63:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
  801a6a:	eb 2d                	jmp    801a99 <malloc+0x7ba>
					} else {
						if (num_p <= count && max_sz < count) {
  801a6c:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801a72:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801a75:	77 14                	ja     801a8b <malloc+0x7ac>
  801a77:	8b 45 98             	mov    -0x68(%ebp),%eax
  801a7a:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801a7d:	73 0c                	jae    801a8b <malloc+0x7ac>

							max_sz = count;
  801a7f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801a82:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  801a85:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801a88:	89 45 9c             	mov    %eax,-0x64(%ebp)

						}
						count = 0;
  801a8b:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
						ptr += PAGE_SIZE;
  801a92:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
					}

					if (i == size_uhmem - 1) {
  801a99:	81 7d 90 ff ff 01 00 	cmpl   $0x1ffff,-0x70(%ebp)
  801aa0:	75 2d                	jne    801acf <malloc+0x7f0>

						if (num_p <= count && max_sz > count) {
  801aa2:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801aa8:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801aab:	77 22                	ja     801acf <malloc+0x7f0>
  801aad:	8b 45 98             	mov    -0x68(%ebp),%eax
  801ab0:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801ab3:	76 1a                	jbe    801acf <malloc+0x7f0>

							max_sz = count;
  801ab5:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801ab8:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  801abb:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801abe:	89 45 9c             	mov    %eax,-0x64(%ebp)
							count = 0;
  801ac1:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
							ptr += PAGE_SIZE;
  801ac8:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
				uint32 count = 0;
				int i = 0;
				uint32 num_p = size / PAGE_SIZE;

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  801acf:	ff 45 90             	incl   -0x70(%ebp)
  801ad2:	8b 45 90             	mov    -0x70(%ebp),%eax
  801ad5:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801ada:	0f 86 72 ff ff ff    	jbe    801a52 <malloc+0x773>

					}

				}

				if (num_p > max_sz || temp == 0) {
  801ae0:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801ae6:	3b 45 98             	cmp    -0x68(%ebp),%eax
  801ae9:	77 06                	ja     801af1 <malloc+0x812>
  801aeb:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  801aef:	75 0a                	jne    801afb <malloc+0x81c>
					return NULL;
  801af1:	b8 00 00 00 00       	mov    $0x0,%eax
  801af6:	e9 84 01 00 00       	jmp    801c7f <malloc+0x9a0>

				}

				temp = temp - (PAGE_SIZE * max_sz);
  801afb:	8b 45 98             	mov    -0x68(%ebp),%eax
  801afe:	c1 e0 0c             	shl    $0xc,%eax
  801b01:	29 45 9c             	sub    %eax,-0x64(%ebp)
				void* ret = (void*) temp;
  801b04:	8b 45 9c             	mov    -0x64(%ebp),%eax
  801b07:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

				sys_allocateMem(temp, size);
  801b0d:	83 ec 08             	sub    $0x8,%esp
  801b10:	ff 75 08             	pushl  0x8(%ebp)
  801b13:	ff 75 9c             	pushl  -0x64(%ebp)
  801b16:	e8 fb 03 00 00       	call   801f16 <sys_allocateMem>
  801b1b:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  801b1e:	a1 20 30 80 00       	mov    0x803020,%eax
  801b23:	8b 55 08             	mov    0x8(%ebp),%edx
  801b26:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) temp;
  801b2d:	a1 20 30 80 00       	mov    0x803020,%eax
  801b32:	8b 55 9c             	mov    -0x64(%ebp),%edx
  801b35:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
				cnt_mem++;
  801b3c:	a1 20 30 80 00       	mov    0x803020,%eax
  801b41:	40                   	inc    %eax
  801b42:	a3 20 30 80 00       	mov    %eax,0x803020
				i = 0;
  801b47:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801b4e:	eb 24                	jmp    801b74 <malloc+0x895>
				{

					heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801b50:	8b 45 9c             	mov    -0x64(%ebp),%eax
  801b53:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  801b58:	c1 e8 0c             	shr    $0xc,%eax
  801b5b:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801b62:	01 00 00 00 

					temp += (uint32) PAGE_SIZE;
  801b66:	81 45 9c 00 10 00 00 	addl   $0x1000,-0x64(%ebp)
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) temp;
				cnt_mem++;
				i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801b6d:	81 45 90 00 10 00 00 	addl   $0x1000,-0x70(%ebp)
  801b74:	8b 45 90             	mov    -0x70(%ebp),%eax
  801b77:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b7a:	72 d4                	jb     801b50 <malloc+0x871>

					temp += (uint32) PAGE_SIZE;
				}

				//cprintf("\n size = %d.........vir= %d  \n",num_p,((uint32) ret-USER_HEAP_START)/PAGE_SIZE);
				return ret;
  801b7c:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  801b82:	e9 f8 00 00 00       	jmp    801c7f <malloc+0x9a0>

	}
// this is to make malloc is work
	void* ret = NULL;
  801b87:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
	size = ROUNDUP(size, PAGE_SIZE);
  801b8e:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  801b95:	10 00 00 
  801b98:	8b 55 08             	mov    0x8(%ebp),%edx
  801b9b:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  801ba1:	01 d0                	add    %edx,%eax
  801ba3:	48                   	dec    %eax
  801ba4:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  801baa:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  801bb0:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb5:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  801bbb:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  801bc1:	29 d0                	sub    %edx,%eax
  801bc3:	89 45 08             	mov    %eax,0x8(%ebp)

	if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801bc6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bca:	74 09                	je     801bd5 <malloc+0x8f6>
  801bcc:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801bd3:	76 0a                	jbe    801bdf <malloc+0x900>
		return NULL;
  801bd5:	b8 00 00 00 00       	mov    $0x0,%eax
  801bda:	e9 a0 00 00 00       	jmp    801c7f <malloc+0x9a0>
	}

	if (ptr_uheap + size <= (uint32) USER_HEAP_MAX) {
  801bdf:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801be5:	8b 45 08             	mov    0x8(%ebp),%eax
  801be8:	01 d0                	add    %edx,%eax
  801bea:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801bef:	0f 87 87 00 00 00    	ja     801c7c <malloc+0x99d>

		ret = (void *) ptr_uheap;
  801bf5:	a1 04 30 80 00       	mov    0x803004,%eax
  801bfa:	89 45 8c             	mov    %eax,-0x74(%ebp)
		sys_allocateMem(ptr_uheap, size);
  801bfd:	a1 04 30 80 00       	mov    0x803004,%eax
  801c02:	83 ec 08             	sub    $0x8,%esp
  801c05:	ff 75 08             	pushl  0x8(%ebp)
  801c08:	50                   	push   %eax
  801c09:	e8 08 03 00 00       	call   801f16 <sys_allocateMem>
  801c0e:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801c11:	a1 20 30 80 00       	mov    0x803020,%eax
  801c16:	8b 55 08             	mov    0x8(%ebp),%edx
  801c19:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801c20:	a1 20 30 80 00       	mov    0x803020,%eax
  801c25:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801c2b:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
		cnt_mem++;
  801c32:	a1 20 30 80 00       	mov    0x803020,%eax
  801c37:	40                   	inc    %eax
  801c38:	a3 20 30 80 00       	mov    %eax,0x803020
		int i = 0;
  801c3d:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)

		for (; i < size; i += PAGE_SIZE)
  801c44:	eb 2e                	jmp    801c74 <malloc+0x995>
		{

			heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801c46:	a1 04 30 80 00       	mov    0x803004,%eax
  801c4b:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801c50:	c1 e8 0c             	shr    $0xc,%eax
  801c53:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801c5a:	01 00 00 00 

			ptr_uheap += (uint32) PAGE_SIZE;
  801c5e:	a1 04 30 80 00       	mov    0x803004,%eax
  801c63:	05 00 10 00 00       	add    $0x1000,%eax
  801c68:	a3 04 30 80 00       	mov    %eax,0x803004
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
		cnt_mem++;
		int i = 0;

		for (; i < size; i += PAGE_SIZE)
  801c6d:	81 45 88 00 10 00 00 	addl   $0x1000,-0x78(%ebp)
  801c74:	8b 45 88             	mov    -0x78(%ebp),%eax
  801c77:	3b 45 08             	cmp    0x8(%ebp),%eax
  801c7a:	72 ca                	jb     801c46 <malloc+0x967>
					/ (uint32) PAGE_SIZE)] = 1;

			ptr_uheap += (uint32) PAGE_SIZE;
		}
	}
	return ret;
  801c7c:	8b 45 8c             	mov    -0x74(%ebp),%eax

	//TODO: [PROJECT 2016 - BONUS2] Apply FIRST FIT and WORST FIT policies

//return 0;

}
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <free>:
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address) {
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
  801c84:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
  801c87:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; inx < cnt_mem; inx++) {
  801c8e:	e9 c1 00 00 00       	jmp    801d54 <free+0xd3>
		if (heap_size[inx].vir == virtual_address) {
  801c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c96:	8b 04 c5 40 30 88 00 	mov    0x883040(,%eax,8),%eax
  801c9d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ca0:	0f 85 ab 00 00 00    	jne    801d51 <free+0xd0>

			if (heap_size[inx].size == 0) {
  801ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca9:	8b 04 c5 44 30 88 00 	mov    0x883044(,%eax,8),%eax
  801cb0:	85 c0                	test   %eax,%eax
  801cb2:	75 21                	jne    801cd5 <free+0x54>
				heap_size[inx].size = 0;
  801cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb7:	c7 04 c5 44 30 88 00 	movl   $0x0,0x883044(,%eax,8)
  801cbe:	00 00 00 00 
				heap_size[inx].vir = NULL;
  801cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc5:	c7 04 c5 40 30 88 00 	movl   $0x0,0x883040(,%eax,8)
  801ccc:	00 00 00 00 
				return;
  801cd0:	e9 8d 00 00 00       	jmp    801d62 <free+0xe1>

			}

			sys_freeMem((uint32) virtual_address, heap_size[inx].size);
  801cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd8:	8b 14 c5 44 30 88 00 	mov    0x883044(,%eax,8),%edx
  801cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce2:	83 ec 08             	sub    $0x8,%esp
  801ce5:	52                   	push   %edx
  801ce6:	50                   	push   %eax
  801ce7:	e8 0e 02 00 00       	call   801efa <sys_freeMem>
  801cec:	83 c4 10             	add    $0x10,%esp

			int i = 0;
  801cef:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
  801cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf9:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  801cfc:	eb 24                	jmp    801d22 <free+0xa1>
			{
				heap_mem[(int) (((uint32) va - USER_HEAP_START) / PAGE_SIZE)] =
  801cfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d01:	05 00 00 00 80       	add    $0x80000000,%eax
  801d06:	c1 e8 0c             	shr    $0xc,%eax
  801d09:	c7 04 85 40 30 80 00 	movl   $0x0,0x803040(,%eax,4)
  801d10:	00 00 00 00 
						0;

				va += PAGE_SIZE;
  801d14:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
			sys_freeMem((uint32) virtual_address, heap_size[inx].size);

			int i = 0;
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  801d1b:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d25:	8b 14 c5 44 30 88 00 	mov    0x883044(,%eax,8),%edx
  801d2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d2f:	39 c2                	cmp    %eax,%edx
  801d31:	77 cb                	ja     801cfe <free+0x7d>

				va += PAGE_SIZE;

			}

			heap_size[inx].size = 0;
  801d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d36:	c7 04 c5 44 30 88 00 	movl   $0x0,0x883044(,%eax,8)
  801d3d:	00 00 00 00 
			heap_size[inx].vir = NULL;
  801d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d44:	c7 04 c5 40 30 88 00 	movl   $0x0,0x883040(,%eax,8)
  801d4b:	00 00 00 00 
			break;
  801d4f:	eb 11                	jmp    801d62 <free+0xe1>
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
	for (; inx < cnt_mem; inx++) {
  801d51:	ff 45 f4             	incl   -0xc(%ebp)
  801d54:	a1 20 30 80 00       	mov    0x803020,%eax
  801d59:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801d5c:	0f 8c 31 ff ff ff    	jl     801c93 <free+0x12>
	}

	//get the size of the given allocation using its address
	//you need to call sys_freeMem()

}
  801d62:	c9                   	leave  
  801d63:	c3                   	ret    

00801d64 <realloc>:
//  Hint: you may need to use the sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size) {
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
  801d67:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2016 - BONUS4] realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801d6a:	83 ec 04             	sub    $0x4,%esp
  801d6d:	68 10 2a 80 00       	push   $0x802a10
  801d72:	68 1c 02 00 00       	push   $0x21c
  801d77:	68 36 2a 80 00       	push   $0x802a36
  801d7c:	e8 b0 e6 ff ff       	call   800431 <_panic>

00801d81 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
  801d84:	57                   	push   %edi
  801d85:	56                   	push   %esi
  801d86:	53                   	push   %ebx
  801d87:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d90:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d93:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d96:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d99:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d9c:	cd 30                	int    $0x30
  801d9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801da1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801da4:	83 c4 10             	add    $0x10,%esp
  801da7:	5b                   	pop    %ebx
  801da8:	5e                   	pop    %esi
  801da9:	5f                   	pop    %edi
  801daa:	5d                   	pop    %ebp
  801dab:	c3                   	ret    

00801dac <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  801daf:	8b 45 08             	mov    0x8(%ebp),%eax
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	ff 75 0c             	pushl  0xc(%ebp)
  801dbb:	50                   	push   %eax
  801dbc:	6a 00                	push   $0x0
  801dbe:	e8 be ff ff ff       	call   801d81 <syscall>
  801dc3:	83 c4 18             	add    $0x18,%esp
}
  801dc6:	90                   	nop
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <sys_cgetc>:

int
sys_cgetc(void)
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 01                	push   $0x1
  801dd8:	e8 a4 ff ff ff       	call   801d81 <syscall>
  801ddd:	83 c4 18             	add    $0x18,%esp
}
  801de0:	c9                   	leave  
  801de1:	c3                   	ret    

00801de2 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801de5:	8b 45 08             	mov    0x8(%ebp),%eax
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	50                   	push   %eax
  801df1:	6a 03                	push   $0x3
  801df3:	e8 89 ff ff ff       	call   801d81 <syscall>
  801df8:	83 c4 18             	add    $0x18,%esp
}
  801dfb:	c9                   	leave  
  801dfc:	c3                   	ret    

00801dfd <sys_getenvid>:

int32 sys_getenvid(void)
{
  801dfd:	55                   	push   %ebp
  801dfe:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 02                	push   $0x2
  801e0c:	e8 70 ff ff ff       	call   801d81 <syscall>
  801e11:	83 c4 18             	add    $0x18,%esp
}
  801e14:	c9                   	leave  
  801e15:	c3                   	ret    

00801e16 <sys_env_exit>:

void sys_env_exit(void)
{
  801e16:	55                   	push   %ebp
  801e17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 04                	push   $0x4
  801e25:	e8 57 ff ff ff       	call   801d81 <syscall>
  801e2a:	83 c4 18             	add    $0x18,%esp
}
  801e2d:	90                   	nop
  801e2e:	c9                   	leave  
  801e2f:	c3                   	ret    

00801e30 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801e33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e36:	8b 45 08             	mov    0x8(%ebp),%eax
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	52                   	push   %edx
  801e40:	50                   	push   %eax
  801e41:	6a 05                	push   $0x5
  801e43:	e8 39 ff ff ff       	call   801d81 <syscall>
  801e48:	83 c4 18             	add    $0x18,%esp
}
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
  801e50:	56                   	push   %esi
  801e51:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801e52:	8b 75 18             	mov    0x18(%ebp),%esi
  801e55:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e58:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e61:	56                   	push   %esi
  801e62:	53                   	push   %ebx
  801e63:	51                   	push   %ecx
  801e64:	52                   	push   %edx
  801e65:	50                   	push   %eax
  801e66:	6a 06                	push   $0x6
  801e68:	e8 14 ff ff ff       	call   801d81 <syscall>
  801e6d:	83 c4 18             	add    $0x18,%esp
}
  801e70:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e73:	5b                   	pop    %ebx
  801e74:	5e                   	pop    %esi
  801e75:	5d                   	pop    %ebp
  801e76:	c3                   	ret    

00801e77 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801e7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	52                   	push   %edx
  801e87:	50                   	push   %eax
  801e88:	6a 07                	push   $0x7
  801e8a:	e8 f2 fe ff ff       	call   801d81 <syscall>
  801e8f:	83 c4 18             	add    $0x18,%esp
}
  801e92:	c9                   	leave  
  801e93:	c3                   	ret    

00801e94 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	ff 75 0c             	pushl  0xc(%ebp)
  801ea0:	ff 75 08             	pushl  0x8(%ebp)
  801ea3:	6a 08                	push   $0x8
  801ea5:	e8 d7 fe ff ff       	call   801d81 <syscall>
  801eaa:	83 c4 18             	add    $0x18,%esp
}
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 09                	push   $0x9
  801ebe:	e8 be fe ff ff       	call   801d81 <syscall>
  801ec3:	83 c4 18             	add    $0x18,%esp
}
  801ec6:	c9                   	leave  
  801ec7:	c3                   	ret    

00801ec8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 0a                	push   $0xa
  801ed7:	e8 a5 fe ff ff       	call   801d81 <syscall>
  801edc:	83 c4 18             	add    $0x18,%esp
}
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 0b                	push   $0xb
  801ef0:	e8 8c fe ff ff       	call   801d81 <syscall>
  801ef5:	83 c4 18             	add    $0x18,%esp
}
  801ef8:	c9                   	leave  
  801ef9:	c3                   	ret    

00801efa <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	ff 75 0c             	pushl  0xc(%ebp)
  801f06:	ff 75 08             	pushl  0x8(%ebp)
  801f09:	6a 0d                	push   $0xd
  801f0b:	e8 71 fe ff ff       	call   801d81 <syscall>
  801f10:	83 c4 18             	add    $0x18,%esp
	return;
  801f13:	90                   	nop
}
  801f14:	c9                   	leave  
  801f15:	c3                   	ret    

00801f16 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	ff 75 0c             	pushl  0xc(%ebp)
  801f22:	ff 75 08             	pushl  0x8(%ebp)
  801f25:	6a 0e                	push   $0xe
  801f27:	e8 55 fe ff ff       	call   801d81 <syscall>
  801f2c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f2f:	90                   	nop
}
  801f30:	c9                   	leave  
  801f31:	c3                   	ret    

00801f32 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801f35:	6a 00                	push   $0x0
  801f37:	6a 00                	push   $0x0
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 0c                	push   $0xc
  801f41:	e8 3b fe ff ff       	call   801d81 <syscall>
  801f46:	83 c4 18             	add    $0x18,%esp
}
  801f49:	c9                   	leave  
  801f4a:	c3                   	ret    

00801f4b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801f4b:	55                   	push   %ebp
  801f4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 10                	push   $0x10
  801f5a:	e8 22 fe ff ff       	call   801d81 <syscall>
  801f5f:	83 c4 18             	add    $0x18,%esp
}
  801f62:	90                   	nop
  801f63:	c9                   	leave  
  801f64:	c3                   	ret    

00801f65 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 11                	push   $0x11
  801f74:	e8 08 fe ff ff       	call   801d81 <syscall>
  801f79:	83 c4 18             	add    $0x18,%esp
}
  801f7c:	90                   	nop
  801f7d:	c9                   	leave  
  801f7e:	c3                   	ret    

00801f7f <sys_cputc>:


void
sys_cputc(const char c)
{
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
  801f82:	83 ec 04             	sub    $0x4,%esp
  801f85:	8b 45 08             	mov    0x8(%ebp),%eax
  801f88:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f8b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	50                   	push   %eax
  801f98:	6a 12                	push   $0x12
  801f9a:	e8 e2 fd ff ff       	call   801d81 <syscall>
  801f9f:	83 c4 18             	add    $0x18,%esp
}
  801fa2:	90                   	nop
  801fa3:	c9                   	leave  
  801fa4:	c3                   	ret    

00801fa5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801fa5:	55                   	push   %ebp
  801fa6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 13                	push   $0x13
  801fb4:	e8 c8 fd ff ff       	call   801d81 <syscall>
  801fb9:	83 c4 18             	add    $0x18,%esp
}
  801fbc:	90                   	nop
  801fbd:	c9                   	leave  
  801fbe:	c3                   	ret    

00801fbf <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801fbf:	55                   	push   %ebp
  801fc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	ff 75 0c             	pushl  0xc(%ebp)
  801fce:	50                   	push   %eax
  801fcf:	6a 14                	push   $0x14
  801fd1:	e8 ab fd ff ff       	call   801d81 <syscall>
  801fd6:	83 c4 18             	add    $0x18,%esp
}
  801fd9:	c9                   	leave  
  801fda:	c3                   	ret    

00801fdb <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  801fdb:	55                   	push   %ebp
  801fdc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  801fde:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	50                   	push   %eax
  801fea:	6a 17                	push   $0x17
  801fec:	e8 90 fd ff ff       	call   801d81 <syscall>
  801ff1:	83 c4 18             	add    $0x18,%esp
}
  801ff4:	c9                   	leave  
  801ff5:	c3                   	ret    

00801ff6 <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  801ff6:	55                   	push   %ebp
  801ff7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  801ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffc:	6a 00                	push   $0x0
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	50                   	push   %eax
  802005:	6a 15                	push   $0x15
  802007:	e8 75 fd ff ff       	call   801d81 <syscall>
  80200c:	83 c4 18             	add    $0x18,%esp
}
  80200f:	90                   	nop
  802010:	c9                   	leave  
  802011:	c3                   	ret    

00802012 <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  802012:	55                   	push   %ebp
  802013:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  802015:	8b 45 08             	mov    0x8(%ebp),%eax
  802018:	6a 00                	push   $0x0
  80201a:	6a 00                	push   $0x0
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	50                   	push   %eax
  802021:	6a 16                	push   $0x16
  802023:	e8 59 fd ff ff       	call   801d81 <syscall>
  802028:	83 c4 18             	add    $0x18,%esp
}
  80202b:	90                   	nop
  80202c:	c9                   	leave  
  80202d:	c3                   	ret    

0080202e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  80202e:	55                   	push   %ebp
  80202f:	89 e5                	mov    %esp,%ebp
  802031:	83 ec 04             	sub    $0x4,%esp
  802034:	8b 45 10             	mov    0x10(%ebp),%eax
  802037:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  80203a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80203d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802041:	8b 45 08             	mov    0x8(%ebp),%eax
  802044:	6a 00                	push   $0x0
  802046:	51                   	push   %ecx
  802047:	52                   	push   %edx
  802048:	ff 75 0c             	pushl  0xc(%ebp)
  80204b:	50                   	push   %eax
  80204c:	6a 18                	push   $0x18
  80204e:	e8 2e fd ff ff       	call   801d81 <syscall>
  802053:	83 c4 18             	add    $0x18,%esp
}
  802056:	c9                   	leave  
  802057:	c3                   	ret    

00802058 <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  802058:	55                   	push   %ebp
  802059:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  80205b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80205e:	8b 45 08             	mov    0x8(%ebp),%eax
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	52                   	push   %edx
  802068:	50                   	push   %eax
  802069:	6a 19                	push   $0x19
  80206b:	e8 11 fd ff ff       	call   801d81 <syscall>
  802070:	83 c4 18             	add    $0x18,%esp
}
  802073:	c9                   	leave  
  802074:	c3                   	ret    

00802075 <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  802078:	8b 45 08             	mov    0x8(%ebp),%eax
  80207b:	6a 00                	push   $0x0
  80207d:	6a 00                	push   $0x0
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	50                   	push   %eax
  802084:	6a 1a                	push   $0x1a
  802086:	e8 f6 fc ff ff       	call   801d81 <syscall>
  80208b:	83 c4 18             	add    $0x18,%esp
}
  80208e:	c9                   	leave  
  80208f:	c3                   	ret    

00802090 <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	6a 1b                	push   $0x1b
  80209f:	e8 dd fc ff ff       	call   801d81 <syscall>
  8020a4:	83 c4 18             	add    $0x18,%esp
}
  8020a7:	c9                   	leave  
  8020a8:	c3                   	ret    

008020a9 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 1c                	push   $0x1c
  8020b8:	e8 c4 fc ff ff       	call   801d81 <syscall>
  8020bd:	83 c4 18             	add    $0x18,%esp
}
  8020c0:	c9                   	leave  
  8020c1:	c3                   	ret    

008020c2 <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  8020c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	ff 75 0c             	pushl  0xc(%ebp)
  8020d1:	50                   	push   %eax
  8020d2:	6a 1d                	push   $0x1d
  8020d4:	e8 a8 fc ff ff       	call   801d81 <syscall>
  8020d9:	83 c4 18             	add    $0x18,%esp
}
  8020dc:	c9                   	leave  
  8020dd:	c3                   	ret    

008020de <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8020de:	55                   	push   %ebp
  8020df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8020e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	50                   	push   %eax
  8020ed:	6a 1e                	push   $0x1e
  8020ef:	e8 8d fc ff ff       	call   801d81 <syscall>
  8020f4:	83 c4 18             	add    $0x18,%esp
}
  8020f7:	90                   	nop
  8020f8:	c9                   	leave  
  8020f9:	c3                   	ret    

008020fa <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8020fa:	55                   	push   %ebp
  8020fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8020fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 00                	push   $0x0
  802108:	50                   	push   %eax
  802109:	6a 1f                	push   $0x1f
  80210b:	e8 71 fc ff ff       	call   801d81 <syscall>
  802110:	83 c4 18             	add    $0x18,%esp
}
  802113:	90                   	nop
  802114:	c9                   	leave  
  802115:	c3                   	ret    

00802116 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  802116:	55                   	push   %ebp
  802117:	89 e5                	mov    %esp,%ebp
  802119:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80211c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80211f:	8d 50 04             	lea    0x4(%eax),%edx
  802122:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	52                   	push   %edx
  80212c:	50                   	push   %eax
  80212d:	6a 20                	push   $0x20
  80212f:	e8 4d fc ff ff       	call   801d81 <syscall>
  802134:	83 c4 18             	add    $0x18,%esp
	return result;
  802137:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80213a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80213d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802140:	89 01                	mov    %eax,(%ecx)
  802142:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802145:	8b 45 08             	mov    0x8(%ebp),%eax
  802148:	c9                   	leave  
  802149:	c2 04 00             	ret    $0x4

0080214c <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80214c:	55                   	push   %ebp
  80214d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	ff 75 10             	pushl  0x10(%ebp)
  802156:	ff 75 0c             	pushl  0xc(%ebp)
  802159:	ff 75 08             	pushl  0x8(%ebp)
  80215c:	6a 0f                	push   $0xf
  80215e:	e8 1e fc ff ff       	call   801d81 <syscall>
  802163:	83 c4 18             	add    $0x18,%esp
	return ;
  802166:	90                   	nop
}
  802167:	c9                   	leave  
  802168:	c3                   	ret    

00802169 <sys_rcr2>:
uint32 sys_rcr2()
{
  802169:	55                   	push   %ebp
  80216a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	6a 21                	push   $0x21
  802178:	e8 04 fc ff ff       	call   801d81 <syscall>
  80217d:	83 c4 18             	add    $0x18,%esp
}
  802180:	c9                   	leave  
  802181:	c3                   	ret    

00802182 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802182:	55                   	push   %ebp
  802183:	89 e5                	mov    %esp,%ebp
  802185:	83 ec 04             	sub    $0x4,%esp
  802188:	8b 45 08             	mov    0x8(%ebp),%eax
  80218b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80218e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	50                   	push   %eax
  80219b:	6a 22                	push   $0x22
  80219d:	e8 df fb ff ff       	call   801d81 <syscall>
  8021a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8021a5:	90                   	nop
}
  8021a6:	c9                   	leave  
  8021a7:	c3                   	ret    

008021a8 <rsttst>:
void rsttst()
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 24                	push   $0x24
  8021b7:	e8 c5 fb ff ff       	call   801d81 <syscall>
  8021bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8021bf:	90                   	nop
}
  8021c0:	c9                   	leave  
  8021c1:	c3                   	ret    

008021c2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8021c2:	55                   	push   %ebp
  8021c3:	89 e5                	mov    %esp,%ebp
  8021c5:	83 ec 04             	sub    $0x4,%esp
  8021c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8021cb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8021ce:	8b 55 18             	mov    0x18(%ebp),%edx
  8021d1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021d5:	52                   	push   %edx
  8021d6:	50                   	push   %eax
  8021d7:	ff 75 10             	pushl  0x10(%ebp)
  8021da:	ff 75 0c             	pushl  0xc(%ebp)
  8021dd:	ff 75 08             	pushl  0x8(%ebp)
  8021e0:	6a 23                	push   $0x23
  8021e2:	e8 9a fb ff ff       	call   801d81 <syscall>
  8021e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ea:	90                   	nop
}
  8021eb:	c9                   	leave  
  8021ec:	c3                   	ret    

008021ed <chktst>:
void chktst(uint32 n)
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	ff 75 08             	pushl  0x8(%ebp)
  8021fb:	6a 25                	push   $0x25
  8021fd:	e8 7f fb ff ff       	call   801d81 <syscall>
  802202:	83 c4 18             	add    $0x18,%esp
	return ;
  802205:	90                   	nop
}
  802206:	c9                   	leave  
  802207:	c3                   	ret    

00802208 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802208:	55                   	push   %ebp
  802209:	89 e5                	mov    %esp,%ebp
  80220b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80220e:	6a 00                	push   $0x0
  802210:	6a 00                	push   $0x0
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 26                	push   $0x26
  80221a:	e8 62 fb ff ff       	call   801d81 <syscall>
  80221f:	83 c4 18             	add    $0x18,%esp
  802222:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802225:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802229:	75 07                	jne    802232 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80222b:	b8 01 00 00 00       	mov    $0x1,%eax
  802230:	eb 05                	jmp    802237 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802232:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802237:	c9                   	leave  
  802238:	c3                   	ret    

00802239 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802239:	55                   	push   %ebp
  80223a:	89 e5                	mov    %esp,%ebp
  80223c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80223f:	6a 00                	push   $0x0
  802241:	6a 00                	push   $0x0
  802243:	6a 00                	push   $0x0
  802245:	6a 00                	push   $0x0
  802247:	6a 00                	push   $0x0
  802249:	6a 26                	push   $0x26
  80224b:	e8 31 fb ff ff       	call   801d81 <syscall>
  802250:	83 c4 18             	add    $0x18,%esp
  802253:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802256:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80225a:	75 07                	jne    802263 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80225c:	b8 01 00 00 00       	mov    $0x1,%eax
  802261:	eb 05                	jmp    802268 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802263:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802268:	c9                   	leave  
  802269:	c3                   	ret    

0080226a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80226a:	55                   	push   %ebp
  80226b:	89 e5                	mov    %esp,%ebp
  80226d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	6a 00                	push   $0x0
  802278:	6a 00                	push   $0x0
  80227a:	6a 26                	push   $0x26
  80227c:	e8 00 fb ff ff       	call   801d81 <syscall>
  802281:	83 c4 18             	add    $0x18,%esp
  802284:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802287:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80228b:	75 07                	jne    802294 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80228d:	b8 01 00 00 00       	mov    $0x1,%eax
  802292:	eb 05                	jmp    802299 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802294:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802299:	c9                   	leave  
  80229a:	c3                   	ret    

0080229b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80229b:	55                   	push   %ebp
  80229c:	89 e5                	mov    %esp,%ebp
  80229e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 00                	push   $0x0
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 26                	push   $0x26
  8022ad:	e8 cf fa ff ff       	call   801d81 <syscall>
  8022b2:	83 c4 18             	add    $0x18,%esp
  8022b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8022b8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8022bc:	75 07                	jne    8022c5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8022be:	b8 01 00 00 00       	mov    $0x1,%eax
  8022c3:	eb 05                	jmp    8022ca <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8022c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022ca:	c9                   	leave  
  8022cb:	c3                   	ret    

008022cc <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8022cc:	55                   	push   %ebp
  8022cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 00                	push   $0x0
  8022d7:	ff 75 08             	pushl  0x8(%ebp)
  8022da:	6a 27                	push   $0x27
  8022dc:	e8 a0 fa ff ff       	call   801d81 <syscall>
  8022e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8022e4:	90                   	nop
}
  8022e5:	c9                   	leave  
  8022e6:	c3                   	ret    
  8022e7:	90                   	nop

008022e8 <__udivdi3>:
  8022e8:	55                   	push   %ebp
  8022e9:	57                   	push   %edi
  8022ea:	56                   	push   %esi
  8022eb:	53                   	push   %ebx
  8022ec:	83 ec 1c             	sub    $0x1c,%esp
  8022ef:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8022f3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8022f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022fb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022ff:	89 ca                	mov    %ecx,%edx
  802301:	89 f8                	mov    %edi,%eax
  802303:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802307:	85 f6                	test   %esi,%esi
  802309:	75 2d                	jne    802338 <__udivdi3+0x50>
  80230b:	39 cf                	cmp    %ecx,%edi
  80230d:	77 65                	ja     802374 <__udivdi3+0x8c>
  80230f:	89 fd                	mov    %edi,%ebp
  802311:	85 ff                	test   %edi,%edi
  802313:	75 0b                	jne    802320 <__udivdi3+0x38>
  802315:	b8 01 00 00 00       	mov    $0x1,%eax
  80231a:	31 d2                	xor    %edx,%edx
  80231c:	f7 f7                	div    %edi
  80231e:	89 c5                	mov    %eax,%ebp
  802320:	31 d2                	xor    %edx,%edx
  802322:	89 c8                	mov    %ecx,%eax
  802324:	f7 f5                	div    %ebp
  802326:	89 c1                	mov    %eax,%ecx
  802328:	89 d8                	mov    %ebx,%eax
  80232a:	f7 f5                	div    %ebp
  80232c:	89 cf                	mov    %ecx,%edi
  80232e:	89 fa                	mov    %edi,%edx
  802330:	83 c4 1c             	add    $0x1c,%esp
  802333:	5b                   	pop    %ebx
  802334:	5e                   	pop    %esi
  802335:	5f                   	pop    %edi
  802336:	5d                   	pop    %ebp
  802337:	c3                   	ret    
  802338:	39 ce                	cmp    %ecx,%esi
  80233a:	77 28                	ja     802364 <__udivdi3+0x7c>
  80233c:	0f bd fe             	bsr    %esi,%edi
  80233f:	83 f7 1f             	xor    $0x1f,%edi
  802342:	75 40                	jne    802384 <__udivdi3+0x9c>
  802344:	39 ce                	cmp    %ecx,%esi
  802346:	72 0a                	jb     802352 <__udivdi3+0x6a>
  802348:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80234c:	0f 87 9e 00 00 00    	ja     8023f0 <__udivdi3+0x108>
  802352:	b8 01 00 00 00       	mov    $0x1,%eax
  802357:	89 fa                	mov    %edi,%edx
  802359:	83 c4 1c             	add    $0x1c,%esp
  80235c:	5b                   	pop    %ebx
  80235d:	5e                   	pop    %esi
  80235e:	5f                   	pop    %edi
  80235f:	5d                   	pop    %ebp
  802360:	c3                   	ret    
  802361:	8d 76 00             	lea    0x0(%esi),%esi
  802364:	31 ff                	xor    %edi,%edi
  802366:	31 c0                	xor    %eax,%eax
  802368:	89 fa                	mov    %edi,%edx
  80236a:	83 c4 1c             	add    $0x1c,%esp
  80236d:	5b                   	pop    %ebx
  80236e:	5e                   	pop    %esi
  80236f:	5f                   	pop    %edi
  802370:	5d                   	pop    %ebp
  802371:	c3                   	ret    
  802372:	66 90                	xchg   %ax,%ax
  802374:	89 d8                	mov    %ebx,%eax
  802376:	f7 f7                	div    %edi
  802378:	31 ff                	xor    %edi,%edi
  80237a:	89 fa                	mov    %edi,%edx
  80237c:	83 c4 1c             	add    $0x1c,%esp
  80237f:	5b                   	pop    %ebx
  802380:	5e                   	pop    %esi
  802381:	5f                   	pop    %edi
  802382:	5d                   	pop    %ebp
  802383:	c3                   	ret    
  802384:	bd 20 00 00 00       	mov    $0x20,%ebp
  802389:	89 eb                	mov    %ebp,%ebx
  80238b:	29 fb                	sub    %edi,%ebx
  80238d:	89 f9                	mov    %edi,%ecx
  80238f:	d3 e6                	shl    %cl,%esi
  802391:	89 c5                	mov    %eax,%ebp
  802393:	88 d9                	mov    %bl,%cl
  802395:	d3 ed                	shr    %cl,%ebp
  802397:	89 e9                	mov    %ebp,%ecx
  802399:	09 f1                	or     %esi,%ecx
  80239b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80239f:	89 f9                	mov    %edi,%ecx
  8023a1:	d3 e0                	shl    %cl,%eax
  8023a3:	89 c5                	mov    %eax,%ebp
  8023a5:	89 d6                	mov    %edx,%esi
  8023a7:	88 d9                	mov    %bl,%cl
  8023a9:	d3 ee                	shr    %cl,%esi
  8023ab:	89 f9                	mov    %edi,%ecx
  8023ad:	d3 e2                	shl    %cl,%edx
  8023af:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023b3:	88 d9                	mov    %bl,%cl
  8023b5:	d3 e8                	shr    %cl,%eax
  8023b7:	09 c2                	or     %eax,%edx
  8023b9:	89 d0                	mov    %edx,%eax
  8023bb:	89 f2                	mov    %esi,%edx
  8023bd:	f7 74 24 0c          	divl   0xc(%esp)
  8023c1:	89 d6                	mov    %edx,%esi
  8023c3:	89 c3                	mov    %eax,%ebx
  8023c5:	f7 e5                	mul    %ebp
  8023c7:	39 d6                	cmp    %edx,%esi
  8023c9:	72 19                	jb     8023e4 <__udivdi3+0xfc>
  8023cb:	74 0b                	je     8023d8 <__udivdi3+0xf0>
  8023cd:	89 d8                	mov    %ebx,%eax
  8023cf:	31 ff                	xor    %edi,%edi
  8023d1:	e9 58 ff ff ff       	jmp    80232e <__udivdi3+0x46>
  8023d6:	66 90                	xchg   %ax,%ax
  8023d8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8023dc:	89 f9                	mov    %edi,%ecx
  8023de:	d3 e2                	shl    %cl,%edx
  8023e0:	39 c2                	cmp    %eax,%edx
  8023e2:	73 e9                	jae    8023cd <__udivdi3+0xe5>
  8023e4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023e7:	31 ff                	xor    %edi,%edi
  8023e9:	e9 40 ff ff ff       	jmp    80232e <__udivdi3+0x46>
  8023ee:	66 90                	xchg   %ax,%ax
  8023f0:	31 c0                	xor    %eax,%eax
  8023f2:	e9 37 ff ff ff       	jmp    80232e <__udivdi3+0x46>
  8023f7:	90                   	nop

008023f8 <__umoddi3>:
  8023f8:	55                   	push   %ebp
  8023f9:	57                   	push   %edi
  8023fa:	56                   	push   %esi
  8023fb:	53                   	push   %ebx
  8023fc:	83 ec 1c             	sub    $0x1c,%esp
  8023ff:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802403:	8b 74 24 34          	mov    0x34(%esp),%esi
  802407:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80240b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80240f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802413:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802417:	89 f3                	mov    %esi,%ebx
  802419:	89 fa                	mov    %edi,%edx
  80241b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80241f:	89 34 24             	mov    %esi,(%esp)
  802422:	85 c0                	test   %eax,%eax
  802424:	75 1a                	jne    802440 <__umoddi3+0x48>
  802426:	39 f7                	cmp    %esi,%edi
  802428:	0f 86 a2 00 00 00    	jbe    8024d0 <__umoddi3+0xd8>
  80242e:	89 c8                	mov    %ecx,%eax
  802430:	89 f2                	mov    %esi,%edx
  802432:	f7 f7                	div    %edi
  802434:	89 d0                	mov    %edx,%eax
  802436:	31 d2                	xor    %edx,%edx
  802438:	83 c4 1c             	add    $0x1c,%esp
  80243b:	5b                   	pop    %ebx
  80243c:	5e                   	pop    %esi
  80243d:	5f                   	pop    %edi
  80243e:	5d                   	pop    %ebp
  80243f:	c3                   	ret    
  802440:	39 f0                	cmp    %esi,%eax
  802442:	0f 87 ac 00 00 00    	ja     8024f4 <__umoddi3+0xfc>
  802448:	0f bd e8             	bsr    %eax,%ebp
  80244b:	83 f5 1f             	xor    $0x1f,%ebp
  80244e:	0f 84 ac 00 00 00    	je     802500 <__umoddi3+0x108>
  802454:	bf 20 00 00 00       	mov    $0x20,%edi
  802459:	29 ef                	sub    %ebp,%edi
  80245b:	89 fe                	mov    %edi,%esi
  80245d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802461:	89 e9                	mov    %ebp,%ecx
  802463:	d3 e0                	shl    %cl,%eax
  802465:	89 d7                	mov    %edx,%edi
  802467:	89 f1                	mov    %esi,%ecx
  802469:	d3 ef                	shr    %cl,%edi
  80246b:	09 c7                	or     %eax,%edi
  80246d:	89 e9                	mov    %ebp,%ecx
  80246f:	d3 e2                	shl    %cl,%edx
  802471:	89 14 24             	mov    %edx,(%esp)
  802474:	89 d8                	mov    %ebx,%eax
  802476:	d3 e0                	shl    %cl,%eax
  802478:	89 c2                	mov    %eax,%edx
  80247a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80247e:	d3 e0                	shl    %cl,%eax
  802480:	89 44 24 04          	mov    %eax,0x4(%esp)
  802484:	8b 44 24 08          	mov    0x8(%esp),%eax
  802488:	89 f1                	mov    %esi,%ecx
  80248a:	d3 e8                	shr    %cl,%eax
  80248c:	09 d0                	or     %edx,%eax
  80248e:	d3 eb                	shr    %cl,%ebx
  802490:	89 da                	mov    %ebx,%edx
  802492:	f7 f7                	div    %edi
  802494:	89 d3                	mov    %edx,%ebx
  802496:	f7 24 24             	mull   (%esp)
  802499:	89 c6                	mov    %eax,%esi
  80249b:	89 d1                	mov    %edx,%ecx
  80249d:	39 d3                	cmp    %edx,%ebx
  80249f:	0f 82 87 00 00 00    	jb     80252c <__umoddi3+0x134>
  8024a5:	0f 84 91 00 00 00    	je     80253c <__umoddi3+0x144>
  8024ab:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024af:	29 f2                	sub    %esi,%edx
  8024b1:	19 cb                	sbb    %ecx,%ebx
  8024b3:	89 d8                	mov    %ebx,%eax
  8024b5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8024b9:	d3 e0                	shl    %cl,%eax
  8024bb:	89 e9                	mov    %ebp,%ecx
  8024bd:	d3 ea                	shr    %cl,%edx
  8024bf:	09 d0                	or     %edx,%eax
  8024c1:	89 e9                	mov    %ebp,%ecx
  8024c3:	d3 eb                	shr    %cl,%ebx
  8024c5:	89 da                	mov    %ebx,%edx
  8024c7:	83 c4 1c             	add    $0x1c,%esp
  8024ca:	5b                   	pop    %ebx
  8024cb:	5e                   	pop    %esi
  8024cc:	5f                   	pop    %edi
  8024cd:	5d                   	pop    %ebp
  8024ce:	c3                   	ret    
  8024cf:	90                   	nop
  8024d0:	89 fd                	mov    %edi,%ebp
  8024d2:	85 ff                	test   %edi,%edi
  8024d4:	75 0b                	jne    8024e1 <__umoddi3+0xe9>
  8024d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8024db:	31 d2                	xor    %edx,%edx
  8024dd:	f7 f7                	div    %edi
  8024df:	89 c5                	mov    %eax,%ebp
  8024e1:	89 f0                	mov    %esi,%eax
  8024e3:	31 d2                	xor    %edx,%edx
  8024e5:	f7 f5                	div    %ebp
  8024e7:	89 c8                	mov    %ecx,%eax
  8024e9:	f7 f5                	div    %ebp
  8024eb:	89 d0                	mov    %edx,%eax
  8024ed:	e9 44 ff ff ff       	jmp    802436 <__umoddi3+0x3e>
  8024f2:	66 90                	xchg   %ax,%ax
  8024f4:	89 c8                	mov    %ecx,%eax
  8024f6:	89 f2                	mov    %esi,%edx
  8024f8:	83 c4 1c             	add    $0x1c,%esp
  8024fb:	5b                   	pop    %ebx
  8024fc:	5e                   	pop    %esi
  8024fd:	5f                   	pop    %edi
  8024fe:	5d                   	pop    %ebp
  8024ff:	c3                   	ret    
  802500:	3b 04 24             	cmp    (%esp),%eax
  802503:	72 06                	jb     80250b <__umoddi3+0x113>
  802505:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802509:	77 0f                	ja     80251a <__umoddi3+0x122>
  80250b:	89 f2                	mov    %esi,%edx
  80250d:	29 f9                	sub    %edi,%ecx
  80250f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802513:	89 14 24             	mov    %edx,(%esp)
  802516:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80251a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80251e:	8b 14 24             	mov    (%esp),%edx
  802521:	83 c4 1c             	add    $0x1c,%esp
  802524:	5b                   	pop    %ebx
  802525:	5e                   	pop    %esi
  802526:	5f                   	pop    %edi
  802527:	5d                   	pop    %ebp
  802528:	c3                   	ret    
  802529:	8d 76 00             	lea    0x0(%esi),%esi
  80252c:	2b 04 24             	sub    (%esp),%eax
  80252f:	19 fa                	sbb    %edi,%edx
  802531:	89 d1                	mov    %edx,%ecx
  802533:	89 c6                	mov    %eax,%esi
  802535:	e9 71 ff ff ff       	jmp    8024ab <__umoddi3+0xb3>
  80253a:	66 90                	xchg   %ax,%ax
  80253c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802540:	72 ea                	jb     80252c <__umoddi3+0x134>
  802542:	89 d9                	mov    %ebx,%ecx
  802544:	e9 62 ff ff ff       	jmp    8024ab <__umoddi3+0xb3>
