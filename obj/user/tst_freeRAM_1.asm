
obj/user/tst_freeRAM_1:     file format elf32-i386


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
  800031:	e8 44 03 00 00       	call   80037a <libmain>
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
  80003c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
	int envID = sys_getenvid();
  800042:	e8 c0 1d 00 00       	call   801e07 <sys_getenvid>
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
  80009c:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
  8000a2:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ac:	89 d7                	mov    %edx,%edi
  8000ae:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//Allocate 2 MB
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8000b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000b3:	01 c0                	add    %eax,%eax
  8000b5:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000b8:	83 ec 0c             	sub    $0xc,%esp
  8000bb:	50                   	push   %eax
  8000bc:	e8 28 12 00 00       	call   8012e9 <malloc>
  8000c1:	83 c4 10             	add    $0x10,%esp
  8000c4:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		char *byteArr = (char *) ptr_allocations[0];
  8000ca:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
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

		//Allocate another 2 MB
		ptr_allocations[1] = malloc(2*Mega-kilo);
  8000f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000f7:	01 c0                	add    %eax,%eax
  8000f9:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	50                   	push   %eax
  800100:	e8 e4 11 00 00       	call   8012e9 <malloc>
  800105:	83 c4 10             	add    $0x10,%esp
  800108:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
		short *shortArr = (short *) ptr_allocations[1];
  80010e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
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

		//Allocate all remaining RAM (Here: it requires to free some RAM)
		int freeFrames = sys_calculate_free_frames() ;
  800141:	e8 73 1d 00 00       	call   801eb9 <sys_calculate_free_frames>
  800146:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[2] = malloc(freeFrames*PAGE_SIZE);
  800149:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80014c:	c1 e0 0c             	shl    $0xc,%eax
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	50                   	push   %eax
  800153:	e8 91 11 00 00       	call   8012e9 <malloc>
  800158:	83 c4 10             	add    $0x10,%esp
  80015b:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		int *intArr = (int *) ptr_allocations[2];
  800161:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800167:	89 45 c0             	mov    %eax,-0x40(%ebp)
		int lastIndexOfInt = (freeFrames*PAGE_SIZE)/sizeof(int) - 1;
  80016a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80016d:	c1 e0 0c             	shl    $0xc,%eax
  800170:	c1 e8 02             	shr    $0x2,%eax
  800173:	48                   	dec    %eax
  800174:	89 45 bc             	mov    %eax,-0x44(%ebp)
		intArr[0] = minInt;
  800177:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80017a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80017d:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  80017f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800182:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800189:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80018c:	01 c2                	add    %eax,%edx
  80018e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800191:	89 02                	mov    %eax,(%edx)

		//Allocate 7 KB after freeing some RAM
		ptr_allocations[3] = malloc(7*kilo);
  800193:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800196:	89 d0                	mov    %edx,%eax
  800198:	01 c0                	add    %eax,%eax
  80019a:	01 d0                	add    %edx,%eax
  80019c:	01 c0                	add    %eax,%eax
  80019e:	01 d0                	add    %edx,%eax
  8001a0:	83 ec 0c             	sub    $0xc,%esp
  8001a3:	50                   	push   %eax
  8001a4:	e8 40 11 00 00       	call   8012e9 <malloc>
  8001a9:	83 c4 10             	add    $0x10,%esp
  8001ac:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		struct MyStruct *structArr = (struct MyStruct *) ptr_allocations[3];
  8001b2:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8001b8:	89 45 b8             	mov    %eax,-0x48(%ebp)
		int lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  8001bb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8001be:	89 d0                	mov    %edx,%eax
  8001c0:	01 c0                	add    %eax,%eax
  8001c2:	01 d0                	add    %edx,%eax
  8001c4:	01 c0                	add    %eax,%eax
  8001c6:	01 d0                	add    %edx,%eax
  8001c8:	c1 e8 03             	shr    $0x3,%eax
  8001cb:	48                   	dec    %eax
  8001cc:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  8001cf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001d2:	8a 55 e7             	mov    -0x19(%ebp),%dl
  8001d5:	88 10                	mov    %dl,(%eax)
  8001d7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8001da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001dd:	66 89 42 02          	mov    %ax,0x2(%edx)
  8001e1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001e4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8001e7:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  8001ea:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8001ed:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8001f4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001f7:	01 c2                	add    %eax,%edx
  8001f9:	8a 45 e6             	mov    -0x1a(%ebp),%al
  8001fc:	88 02                	mov    %al,(%edx)
  8001fe:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800201:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800208:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80020b:	01 c2                	add    %eax,%edx
  80020d:	66 8b 45 e2          	mov    -0x1e(%ebp),%ax
  800211:	66 89 42 02          	mov    %ax,0x2(%edx)
  800215:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800218:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80021f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800222:	01 c2                	add    %eax,%edx
  800224:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800227:	89 42 04             	mov    %eax,0x4(%edx)

		//Check that the values are successfully stored
		if (byteArr[0] 	!= minByte 	|| byteArr[lastIndexOfByte] 	!= maxByte) panic("Wrong allocation: stored values are wrongly changed!");
  80022a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80022d:	8a 00                	mov    (%eax),%al
  80022f:	3a 45 e7             	cmp    -0x19(%ebp),%al
  800232:	75 0f                	jne    800243 <_main+0x20b>
  800234:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800237:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80023a:	01 d0                	add    %edx,%eax
  80023c:	8a 00                	mov    (%eax),%al
  80023e:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  800241:	74 14                	je     800257 <_main+0x21f>
  800243:	83 ec 04             	sub    $0x4,%esp
  800246:	68 60 25 80 00       	push   $0x802560
  80024b:	6a 39                	push   $0x39
  80024d:	68 95 25 80 00       	push   $0x802595
  800252:	e8 e4 01 00 00       	call   80043b <_panic>
		if (shortArr[0] != minShort || shortArr[lastIndexOfShort] 	!= maxShort) panic("Wrong allocation: stored values are wrongly changed!");
  800257:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80025a:	66 8b 00             	mov    (%eax),%ax
  80025d:	66 3b 45 e4          	cmp    -0x1c(%ebp),%ax
  800261:	75 15                	jne    800278 <_main+0x240>
  800263:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800266:	01 c0                	add    %eax,%eax
  800268:	89 c2                	mov    %eax,%edx
  80026a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80026d:	01 d0                	add    %edx,%eax
  80026f:	66 8b 00             	mov    (%eax),%ax
  800272:	66 3b 45 e2          	cmp    -0x1e(%ebp),%ax
  800276:	74 14                	je     80028c <_main+0x254>
  800278:	83 ec 04             	sub    $0x4,%esp
  80027b:	68 60 25 80 00       	push   $0x802560
  800280:	6a 3a                	push   $0x3a
  800282:	68 95 25 80 00       	push   $0x802595
  800287:	e8 af 01 00 00       	call   80043b <_panic>
		if (intArr[0] 	!= minInt 	|| intArr[lastIndexOfInt] 		!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  80028c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80028f:	8b 00                	mov    (%eax),%eax
  800291:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800294:	75 16                	jne    8002ac <_main+0x274>
  800296:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800299:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002a0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8002a3:	01 d0                	add    %edx,%eax
  8002a5:	8b 00                	mov    (%eax),%eax
  8002a7:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8002aa:	74 14                	je     8002c0 <_main+0x288>
  8002ac:	83 ec 04             	sub    $0x4,%esp
  8002af:	68 60 25 80 00       	push   $0x802560
  8002b4:	6a 3b                	push   $0x3b
  8002b6:	68 95 25 80 00       	push   $0x802595
  8002bb:	e8 7b 01 00 00       	call   80043b <_panic>

		if (structArr[0].a != minByte 	|| structArr[lastIndexOfStruct].a != maxByte) 	panic("Wrong allocation: stored values are wrongly changed!");
  8002c0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8002c3:	8a 00                	mov    (%eax),%al
  8002c5:	3a 45 e7             	cmp    -0x19(%ebp),%al
  8002c8:	75 16                	jne    8002e0 <_main+0x2a8>
  8002ca:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8002cd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002d4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8002d7:	01 d0                	add    %edx,%eax
  8002d9:	8a 00                	mov    (%eax),%al
  8002db:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  8002de:	74 14                	je     8002f4 <_main+0x2bc>
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	68 60 25 80 00       	push   $0x802560
  8002e8:	6a 3d                	push   $0x3d
  8002ea:	68 95 25 80 00       	push   $0x802595
  8002ef:	e8 47 01 00 00       	call   80043b <_panic>
		if (structArr[0].b != minShort 	|| structArr[lastIndexOfStruct].b != maxShort) 	panic("Wrong allocation: stored values are wrongly changed!");
  8002f4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8002f7:	66 8b 40 02          	mov    0x2(%eax),%ax
  8002fb:	66 3b 45 e4          	cmp    -0x1c(%ebp),%ax
  8002ff:	75 19                	jne    80031a <_main+0x2e2>
  800301:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800304:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80030b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80030e:	01 d0                	add    %edx,%eax
  800310:	66 8b 40 02          	mov    0x2(%eax),%ax
  800314:	66 3b 45 e2          	cmp    -0x1e(%ebp),%ax
  800318:	74 14                	je     80032e <_main+0x2f6>
  80031a:	83 ec 04             	sub    $0x4,%esp
  80031d:	68 60 25 80 00       	push   $0x802560
  800322:	6a 3e                	push   $0x3e
  800324:	68 95 25 80 00       	push   $0x802595
  800329:	e8 0d 01 00 00       	call   80043b <_panic>
		if (structArr[0].c != minInt 	|| structArr[lastIndexOfStruct].c != maxInt) 	panic("Wrong allocation: stored values are wrongly changed!");
  80032e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800331:	8b 40 04             	mov    0x4(%eax),%eax
  800334:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800337:	75 17                	jne    800350 <_main+0x318>
  800339:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80033c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800343:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800346:	01 d0                	add    %edx,%eax
  800348:	8b 40 04             	mov    0x4(%eax),%eax
  80034b:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80034e:	74 14                	je     800364 <_main+0x32c>
  800350:	83 ec 04             	sub    $0x4,%esp
  800353:	68 60 25 80 00       	push   $0x802560
  800358:	6a 3f                	push   $0x3f
  80035a:	68 95 25 80 00       	push   $0x802595
  80035f:	e8 d7 00 00 00       	call   80043b <_panic>


	}

	cprintf("Congratulations!! test freeRAM (1) completed successfully.\n");
  800364:	83 ec 0c             	sub    $0xc,%esp
  800367:	68 ac 25 80 00       	push   $0x8025ac
  80036c:	e8 f5 01 00 00       	call   800566 <cprintf>
  800371:	83 c4 10             	add    $0x10,%esp

	return;
  800374:	90                   	nop
}
  800375:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800378:	c9                   	leave  
  800379:	c3                   	ret    

0080037a <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80037a:	55                   	push   %ebp
  80037b:	89 e5                	mov    %esp,%ebp
  80037d:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800380:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800384:	7e 0a                	jle    800390 <libmain+0x16>
		binaryname = argv[0];
  800386:	8b 45 0c             	mov    0xc(%ebp),%eax
  800389:	8b 00                	mov    (%eax),%eax
  80038b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800390:	83 ec 08             	sub    $0x8,%esp
  800393:	ff 75 0c             	pushl  0xc(%ebp)
  800396:	ff 75 08             	pushl  0x8(%ebp)
  800399:	e8 9a fc ff ff       	call   800038 <_main>
  80039e:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8003a1:	e8 61 1a 00 00       	call   801e07 <sys_getenvid>
  8003a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  8003a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003ac:	89 d0                	mov    %edx,%eax
  8003ae:	c1 e0 03             	shl    $0x3,%eax
  8003b1:	01 d0                	add    %edx,%eax
  8003b3:	01 c0                	add    %eax,%eax
  8003b5:	01 d0                	add    %edx,%eax
  8003b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003be:	01 d0                	add    %edx,%eax
  8003c0:	c1 e0 03             	shl    $0x3,%eax
  8003c3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003c8:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  8003cb:	e8 85 1b 00 00       	call   801f55 <sys_disable_interrupt>
		cprintf("**************************************\n");
  8003d0:	83 ec 0c             	sub    $0xc,%esp
  8003d3:	68 00 26 80 00       	push   $0x802600
  8003d8:	e8 89 01 00 00       	call   800566 <cprintf>
  8003dd:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  8003e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e3:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  8003e9:	83 ec 08             	sub    $0x8,%esp
  8003ec:	50                   	push   %eax
  8003ed:	68 28 26 80 00       	push   $0x802628
  8003f2:	e8 6f 01 00 00       	call   800566 <cprintf>
  8003f7:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8003fa:	83 ec 0c             	sub    $0xc,%esp
  8003fd:	68 00 26 80 00       	push   $0x802600
  800402:	e8 5f 01 00 00       	call   800566 <cprintf>
  800407:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80040a:	e8 60 1b 00 00       	call   801f6f <sys_enable_interrupt>

	// exit gracefully
	exit();
  80040f:	e8 19 00 00 00       	call   80042d <exit>
}
  800414:	90                   	nop
  800415:	c9                   	leave  
  800416:	c3                   	ret    

00800417 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800417:	55                   	push   %ebp
  800418:	89 e5                	mov    %esp,%ebp
  80041a:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80041d:	83 ec 0c             	sub    $0xc,%esp
  800420:	6a 00                	push   $0x0
  800422:	e8 c5 19 00 00       	call   801dec <sys_env_destroy>
  800427:	83 c4 10             	add    $0x10,%esp
}
  80042a:	90                   	nop
  80042b:	c9                   	leave  
  80042c:	c3                   	ret    

0080042d <exit>:

void
exit(void)
{
  80042d:	55                   	push   %ebp
  80042e:	89 e5                	mov    %esp,%ebp
  800430:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800433:	e8 e8 19 00 00       	call   801e20 <sys_env_exit>
}
  800438:	90                   	nop
  800439:	c9                   	leave  
  80043a:	c3                   	ret    

0080043b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80043b:	55                   	push   %ebp
  80043c:	89 e5                	mov    %esp,%ebp
  80043e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800441:	8d 45 10             	lea    0x10(%ebp),%eax
  800444:	83 c0 04             	add    $0x4,%eax
  800447:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  80044a:	a1 50 30 98 00       	mov    0x983050,%eax
  80044f:	85 c0                	test   %eax,%eax
  800451:	74 16                	je     800469 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800453:	a1 50 30 98 00       	mov    0x983050,%eax
  800458:	83 ec 08             	sub    $0x8,%esp
  80045b:	50                   	push   %eax
  80045c:	68 41 26 80 00       	push   $0x802641
  800461:	e8 00 01 00 00       	call   800566 <cprintf>
  800466:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800469:	a1 00 30 80 00       	mov    0x803000,%eax
  80046e:	ff 75 0c             	pushl  0xc(%ebp)
  800471:	ff 75 08             	pushl  0x8(%ebp)
  800474:	50                   	push   %eax
  800475:	68 46 26 80 00       	push   $0x802646
  80047a:	e8 e7 00 00 00       	call   800566 <cprintf>
  80047f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800482:	8b 45 10             	mov    0x10(%ebp),%eax
  800485:	83 ec 08             	sub    $0x8,%esp
  800488:	ff 75 f4             	pushl  -0xc(%ebp)
  80048b:	50                   	push   %eax
  80048c:	e8 7a 00 00 00       	call   80050b <vcprintf>
  800491:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  800494:	83 ec 0c             	sub    $0xc,%esp
  800497:	68 62 26 80 00       	push   $0x802662
  80049c:	e8 c5 00 00 00       	call   800566 <cprintf>
  8004a1:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004a4:	e8 84 ff ff ff       	call   80042d <exit>

	// should not return here
	while (1) ;
  8004a9:	eb fe                	jmp    8004a9 <_panic+0x6e>

008004ab <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004ab:	55                   	push   %ebp
  8004ac:	89 e5                	mov    %esp,%ebp
  8004ae:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	8d 48 01             	lea    0x1(%eax),%ecx
  8004b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004bc:	89 0a                	mov    %ecx,(%edx)
  8004be:	8b 55 08             	mov    0x8(%ebp),%edx
  8004c1:	88 d1                	mov    %dl,%cl
  8004c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cd:	8b 00                	mov    (%eax),%eax
  8004cf:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004d4:	75 23                	jne    8004f9 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  8004d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d9:	8b 00                	mov    (%eax),%eax
  8004db:	89 c2                	mov    %eax,%edx
  8004dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e0:	83 c0 08             	add    $0x8,%eax
  8004e3:	83 ec 08             	sub    $0x8,%esp
  8004e6:	52                   	push   %edx
  8004e7:	50                   	push   %eax
  8004e8:	e8 c9 18 00 00       	call   801db6 <sys_cputs>
  8004ed:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fc:	8b 40 04             	mov    0x4(%eax),%eax
  8004ff:	8d 50 01             	lea    0x1(%eax),%edx
  800502:	8b 45 0c             	mov    0xc(%ebp),%eax
  800505:	89 50 04             	mov    %edx,0x4(%eax)
}
  800508:	90                   	nop
  800509:	c9                   	leave  
  80050a:	c3                   	ret    

0080050b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800514:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80051b:	00 00 00 
	b.cnt = 0;
  80051e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800525:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800528:	ff 75 0c             	pushl  0xc(%ebp)
  80052b:	ff 75 08             	pushl  0x8(%ebp)
  80052e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800534:	50                   	push   %eax
  800535:	68 ab 04 80 00       	push   $0x8004ab
  80053a:	e8 fa 01 00 00       	call   800739 <vprintfmt>
  80053f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  800542:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800548:	83 ec 08             	sub    $0x8,%esp
  80054b:	50                   	push   %eax
  80054c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800552:	83 c0 08             	add    $0x8,%eax
  800555:	50                   	push   %eax
  800556:	e8 5b 18 00 00       	call   801db6 <sys_cputs>
  80055b:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  80055e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800564:	c9                   	leave  
  800565:	c3                   	ret    

00800566 <cprintf>:

int cprintf(const char *fmt, ...) {
  800566:	55                   	push   %ebp
  800567:	89 e5                	mov    %esp,%ebp
  800569:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80056c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80056f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800572:	8b 45 08             	mov    0x8(%ebp),%eax
  800575:	83 ec 08             	sub    $0x8,%esp
  800578:	ff 75 f4             	pushl  -0xc(%ebp)
  80057b:	50                   	push   %eax
  80057c:	e8 8a ff ff ff       	call   80050b <vcprintf>
  800581:	83 c4 10             	add    $0x10,%esp
  800584:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800587:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80058a:	c9                   	leave  
  80058b:	c3                   	ret    

0080058c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80058c:	55                   	push   %ebp
  80058d:	89 e5                	mov    %esp,%ebp
  80058f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800592:	e8 be 19 00 00       	call   801f55 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800597:	8d 45 0c             	lea    0xc(%ebp),%eax
  80059a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80059d:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a0:	83 ec 08             	sub    $0x8,%esp
  8005a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8005a6:	50                   	push   %eax
  8005a7:	e8 5f ff ff ff       	call   80050b <vcprintf>
  8005ac:	83 c4 10             	add    $0x10,%esp
  8005af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005b2:	e8 b8 19 00 00       	call   801f6f <sys_enable_interrupt>
	return cnt;
  8005b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005ba:	c9                   	leave  
  8005bb:	c3                   	ret    

008005bc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005bc:	55                   	push   %ebp
  8005bd:	89 e5                	mov    %esp,%ebp
  8005bf:	53                   	push   %ebx
  8005c0:	83 ec 14             	sub    $0x14,%esp
  8005c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8005c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005cf:	8b 45 18             	mov    0x18(%ebp),%eax
  8005d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005da:	77 55                	ja     800631 <printnum+0x75>
  8005dc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005df:	72 05                	jb     8005e6 <printnum+0x2a>
  8005e1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005e4:	77 4b                	ja     800631 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005e6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005e9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005ec:	8b 45 18             	mov    0x18(%ebp),%eax
  8005ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f4:	52                   	push   %edx
  8005f5:	50                   	push   %eax
  8005f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005f9:	ff 75 f0             	pushl  -0x10(%ebp)
  8005fc:	e8 f3 1c 00 00       	call   8022f4 <__udivdi3>
  800601:	83 c4 10             	add    $0x10,%esp
  800604:	83 ec 04             	sub    $0x4,%esp
  800607:	ff 75 20             	pushl  0x20(%ebp)
  80060a:	53                   	push   %ebx
  80060b:	ff 75 18             	pushl  0x18(%ebp)
  80060e:	52                   	push   %edx
  80060f:	50                   	push   %eax
  800610:	ff 75 0c             	pushl  0xc(%ebp)
  800613:	ff 75 08             	pushl  0x8(%ebp)
  800616:	e8 a1 ff ff ff       	call   8005bc <printnum>
  80061b:	83 c4 20             	add    $0x20,%esp
  80061e:	eb 1a                	jmp    80063a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800620:	83 ec 08             	sub    $0x8,%esp
  800623:	ff 75 0c             	pushl  0xc(%ebp)
  800626:	ff 75 20             	pushl  0x20(%ebp)
  800629:	8b 45 08             	mov    0x8(%ebp),%eax
  80062c:	ff d0                	call   *%eax
  80062e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800631:	ff 4d 1c             	decl   0x1c(%ebp)
  800634:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800638:	7f e6                	jg     800620 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80063a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80063d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800642:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800645:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800648:	53                   	push   %ebx
  800649:	51                   	push   %ecx
  80064a:	52                   	push   %edx
  80064b:	50                   	push   %eax
  80064c:	e8 b3 1d 00 00       	call   802404 <__umoddi3>
  800651:	83 c4 10             	add    $0x10,%esp
  800654:	05 94 28 80 00       	add    $0x802894,%eax
  800659:	8a 00                	mov    (%eax),%al
  80065b:	0f be c0             	movsbl %al,%eax
  80065e:	83 ec 08             	sub    $0x8,%esp
  800661:	ff 75 0c             	pushl  0xc(%ebp)
  800664:	50                   	push   %eax
  800665:	8b 45 08             	mov    0x8(%ebp),%eax
  800668:	ff d0                	call   *%eax
  80066a:	83 c4 10             	add    $0x10,%esp
}
  80066d:	90                   	nop
  80066e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800671:	c9                   	leave  
  800672:	c3                   	ret    

00800673 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800673:	55                   	push   %ebp
  800674:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800676:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80067a:	7e 1c                	jle    800698 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80067c:	8b 45 08             	mov    0x8(%ebp),%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	8d 50 08             	lea    0x8(%eax),%edx
  800684:	8b 45 08             	mov    0x8(%ebp),%eax
  800687:	89 10                	mov    %edx,(%eax)
  800689:	8b 45 08             	mov    0x8(%ebp),%eax
  80068c:	8b 00                	mov    (%eax),%eax
  80068e:	83 e8 08             	sub    $0x8,%eax
  800691:	8b 50 04             	mov    0x4(%eax),%edx
  800694:	8b 00                	mov    (%eax),%eax
  800696:	eb 40                	jmp    8006d8 <getuint+0x65>
	else if (lflag)
  800698:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80069c:	74 1e                	je     8006bc <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80069e:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a1:	8b 00                	mov    (%eax),%eax
  8006a3:	8d 50 04             	lea    0x4(%eax),%edx
  8006a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a9:	89 10                	mov    %edx,(%eax)
  8006ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ae:	8b 00                	mov    (%eax),%eax
  8006b0:	83 e8 04             	sub    $0x4,%eax
  8006b3:	8b 00                	mov    (%eax),%eax
  8006b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ba:	eb 1c                	jmp    8006d8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	8d 50 04             	lea    0x4(%eax),%edx
  8006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c7:	89 10                	mov    %edx,(%eax)
  8006c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cc:	8b 00                	mov    (%eax),%eax
  8006ce:	83 e8 04             	sub    $0x4,%eax
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006d8:	5d                   	pop    %ebp
  8006d9:	c3                   	ret    

008006da <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006da:	55                   	push   %ebp
  8006db:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006dd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006e1:	7e 1c                	jle    8006ff <getint+0x25>
		return va_arg(*ap, long long);
  8006e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e6:	8b 00                	mov    (%eax),%eax
  8006e8:	8d 50 08             	lea    0x8(%eax),%edx
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	89 10                	mov    %edx,(%eax)
  8006f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f3:	8b 00                	mov    (%eax),%eax
  8006f5:	83 e8 08             	sub    $0x8,%eax
  8006f8:	8b 50 04             	mov    0x4(%eax),%edx
  8006fb:	8b 00                	mov    (%eax),%eax
  8006fd:	eb 38                	jmp    800737 <getint+0x5d>
	else if (lflag)
  8006ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800703:	74 1a                	je     80071f <getint+0x45>
		return va_arg(*ap, long);
  800705:	8b 45 08             	mov    0x8(%ebp),%eax
  800708:	8b 00                	mov    (%eax),%eax
  80070a:	8d 50 04             	lea    0x4(%eax),%edx
  80070d:	8b 45 08             	mov    0x8(%ebp),%eax
  800710:	89 10                	mov    %edx,(%eax)
  800712:	8b 45 08             	mov    0x8(%ebp),%eax
  800715:	8b 00                	mov    (%eax),%eax
  800717:	83 e8 04             	sub    $0x4,%eax
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	99                   	cltd   
  80071d:	eb 18                	jmp    800737 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	8b 00                	mov    (%eax),%eax
  800724:	8d 50 04             	lea    0x4(%eax),%edx
  800727:	8b 45 08             	mov    0x8(%ebp),%eax
  80072a:	89 10                	mov    %edx,(%eax)
  80072c:	8b 45 08             	mov    0x8(%ebp),%eax
  80072f:	8b 00                	mov    (%eax),%eax
  800731:	83 e8 04             	sub    $0x4,%eax
  800734:	8b 00                	mov    (%eax),%eax
  800736:	99                   	cltd   
}
  800737:	5d                   	pop    %ebp
  800738:	c3                   	ret    

00800739 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800739:	55                   	push   %ebp
  80073a:	89 e5                	mov    %esp,%ebp
  80073c:	56                   	push   %esi
  80073d:	53                   	push   %ebx
  80073e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800741:	eb 17                	jmp    80075a <vprintfmt+0x21>
			if (ch == '\0')
  800743:	85 db                	test   %ebx,%ebx
  800745:	0f 84 af 03 00 00    	je     800afa <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80074b:	83 ec 08             	sub    $0x8,%esp
  80074e:	ff 75 0c             	pushl  0xc(%ebp)
  800751:	53                   	push   %ebx
  800752:	8b 45 08             	mov    0x8(%ebp),%eax
  800755:	ff d0                	call   *%eax
  800757:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80075a:	8b 45 10             	mov    0x10(%ebp),%eax
  80075d:	8d 50 01             	lea    0x1(%eax),%edx
  800760:	89 55 10             	mov    %edx,0x10(%ebp)
  800763:	8a 00                	mov    (%eax),%al
  800765:	0f b6 d8             	movzbl %al,%ebx
  800768:	83 fb 25             	cmp    $0x25,%ebx
  80076b:	75 d6                	jne    800743 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80076d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800771:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800778:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80077f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800786:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80078d:	8b 45 10             	mov    0x10(%ebp),%eax
  800790:	8d 50 01             	lea    0x1(%eax),%edx
  800793:	89 55 10             	mov    %edx,0x10(%ebp)
  800796:	8a 00                	mov    (%eax),%al
  800798:	0f b6 d8             	movzbl %al,%ebx
  80079b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80079e:	83 f8 55             	cmp    $0x55,%eax
  8007a1:	0f 87 2b 03 00 00    	ja     800ad2 <vprintfmt+0x399>
  8007a7:	8b 04 85 b8 28 80 00 	mov    0x8028b8(,%eax,4),%eax
  8007ae:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007b0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007b4:	eb d7                	jmp    80078d <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007b6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007ba:	eb d1                	jmp    80078d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007bc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007c3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007c6:	89 d0                	mov    %edx,%eax
  8007c8:	c1 e0 02             	shl    $0x2,%eax
  8007cb:	01 d0                	add    %edx,%eax
  8007cd:	01 c0                	add    %eax,%eax
  8007cf:	01 d8                	add    %ebx,%eax
  8007d1:	83 e8 30             	sub    $0x30,%eax
  8007d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007da:	8a 00                	mov    (%eax),%al
  8007dc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007df:	83 fb 2f             	cmp    $0x2f,%ebx
  8007e2:	7e 3e                	jle    800822 <vprintfmt+0xe9>
  8007e4:	83 fb 39             	cmp    $0x39,%ebx
  8007e7:	7f 39                	jg     800822 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007e9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007ec:	eb d5                	jmp    8007c3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f1:	83 c0 04             	add    $0x4,%eax
  8007f4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fa:	83 e8 04             	sub    $0x4,%eax
  8007fd:	8b 00                	mov    (%eax),%eax
  8007ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800802:	eb 1f                	jmp    800823 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800804:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800808:	79 83                	jns    80078d <vprintfmt+0x54>
				width = 0;
  80080a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800811:	e9 77 ff ff ff       	jmp    80078d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800816:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80081d:	e9 6b ff ff ff       	jmp    80078d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800822:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800823:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800827:	0f 89 60 ff ff ff    	jns    80078d <vprintfmt+0x54>
				width = precision, precision = -1;
  80082d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800830:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800833:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80083a:	e9 4e ff ff ff       	jmp    80078d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80083f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800842:	e9 46 ff ff ff       	jmp    80078d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800847:	8b 45 14             	mov    0x14(%ebp),%eax
  80084a:	83 c0 04             	add    $0x4,%eax
  80084d:	89 45 14             	mov    %eax,0x14(%ebp)
  800850:	8b 45 14             	mov    0x14(%ebp),%eax
  800853:	83 e8 04             	sub    $0x4,%eax
  800856:	8b 00                	mov    (%eax),%eax
  800858:	83 ec 08             	sub    $0x8,%esp
  80085b:	ff 75 0c             	pushl  0xc(%ebp)
  80085e:	50                   	push   %eax
  80085f:	8b 45 08             	mov    0x8(%ebp),%eax
  800862:	ff d0                	call   *%eax
  800864:	83 c4 10             	add    $0x10,%esp
			break;
  800867:	e9 89 02 00 00       	jmp    800af5 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80086c:	8b 45 14             	mov    0x14(%ebp),%eax
  80086f:	83 c0 04             	add    $0x4,%eax
  800872:	89 45 14             	mov    %eax,0x14(%ebp)
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	83 e8 04             	sub    $0x4,%eax
  80087b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80087d:	85 db                	test   %ebx,%ebx
  80087f:	79 02                	jns    800883 <vprintfmt+0x14a>
				err = -err;
  800881:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800883:	83 fb 64             	cmp    $0x64,%ebx
  800886:	7f 0b                	jg     800893 <vprintfmt+0x15a>
  800888:	8b 34 9d 00 27 80 00 	mov    0x802700(,%ebx,4),%esi
  80088f:	85 f6                	test   %esi,%esi
  800891:	75 19                	jne    8008ac <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800893:	53                   	push   %ebx
  800894:	68 a5 28 80 00       	push   $0x8028a5
  800899:	ff 75 0c             	pushl  0xc(%ebp)
  80089c:	ff 75 08             	pushl  0x8(%ebp)
  80089f:	e8 5e 02 00 00       	call   800b02 <printfmt>
  8008a4:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008a7:	e9 49 02 00 00       	jmp    800af5 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008ac:	56                   	push   %esi
  8008ad:	68 ae 28 80 00       	push   $0x8028ae
  8008b2:	ff 75 0c             	pushl  0xc(%ebp)
  8008b5:	ff 75 08             	pushl  0x8(%ebp)
  8008b8:	e8 45 02 00 00       	call   800b02 <printfmt>
  8008bd:	83 c4 10             	add    $0x10,%esp
			break;
  8008c0:	e9 30 02 00 00       	jmp    800af5 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c8:	83 c0 04             	add    $0x4,%eax
  8008cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d1:	83 e8 04             	sub    $0x4,%eax
  8008d4:	8b 30                	mov    (%eax),%esi
  8008d6:	85 f6                	test   %esi,%esi
  8008d8:	75 05                	jne    8008df <vprintfmt+0x1a6>
				p = "(null)";
  8008da:	be b1 28 80 00       	mov    $0x8028b1,%esi
			if (width > 0 && padc != '-')
  8008df:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e3:	7e 6d                	jle    800952 <vprintfmt+0x219>
  8008e5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008e9:	74 67                	je     800952 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ee:	83 ec 08             	sub    $0x8,%esp
  8008f1:	50                   	push   %eax
  8008f2:	56                   	push   %esi
  8008f3:	e8 0c 03 00 00       	call   800c04 <strnlen>
  8008f8:	83 c4 10             	add    $0x10,%esp
  8008fb:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008fe:	eb 16                	jmp    800916 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800900:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800904:	83 ec 08             	sub    $0x8,%esp
  800907:	ff 75 0c             	pushl  0xc(%ebp)
  80090a:	50                   	push   %eax
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	ff d0                	call   *%eax
  800910:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800913:	ff 4d e4             	decl   -0x1c(%ebp)
  800916:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80091a:	7f e4                	jg     800900 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80091c:	eb 34                	jmp    800952 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80091e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800922:	74 1c                	je     800940 <vprintfmt+0x207>
  800924:	83 fb 1f             	cmp    $0x1f,%ebx
  800927:	7e 05                	jle    80092e <vprintfmt+0x1f5>
  800929:	83 fb 7e             	cmp    $0x7e,%ebx
  80092c:	7e 12                	jle    800940 <vprintfmt+0x207>
					putch('?', putdat);
  80092e:	83 ec 08             	sub    $0x8,%esp
  800931:	ff 75 0c             	pushl  0xc(%ebp)
  800934:	6a 3f                	push   $0x3f
  800936:	8b 45 08             	mov    0x8(%ebp),%eax
  800939:	ff d0                	call   *%eax
  80093b:	83 c4 10             	add    $0x10,%esp
  80093e:	eb 0f                	jmp    80094f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800940:	83 ec 08             	sub    $0x8,%esp
  800943:	ff 75 0c             	pushl  0xc(%ebp)
  800946:	53                   	push   %ebx
  800947:	8b 45 08             	mov    0x8(%ebp),%eax
  80094a:	ff d0                	call   *%eax
  80094c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80094f:	ff 4d e4             	decl   -0x1c(%ebp)
  800952:	89 f0                	mov    %esi,%eax
  800954:	8d 70 01             	lea    0x1(%eax),%esi
  800957:	8a 00                	mov    (%eax),%al
  800959:	0f be d8             	movsbl %al,%ebx
  80095c:	85 db                	test   %ebx,%ebx
  80095e:	74 24                	je     800984 <vprintfmt+0x24b>
  800960:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800964:	78 b8                	js     80091e <vprintfmt+0x1e5>
  800966:	ff 4d e0             	decl   -0x20(%ebp)
  800969:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80096d:	79 af                	jns    80091e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80096f:	eb 13                	jmp    800984 <vprintfmt+0x24b>
				putch(' ', putdat);
  800971:	83 ec 08             	sub    $0x8,%esp
  800974:	ff 75 0c             	pushl  0xc(%ebp)
  800977:	6a 20                	push   $0x20
  800979:	8b 45 08             	mov    0x8(%ebp),%eax
  80097c:	ff d0                	call   *%eax
  80097e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800981:	ff 4d e4             	decl   -0x1c(%ebp)
  800984:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800988:	7f e7                	jg     800971 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80098a:	e9 66 01 00 00       	jmp    800af5 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80098f:	83 ec 08             	sub    $0x8,%esp
  800992:	ff 75 e8             	pushl  -0x18(%ebp)
  800995:	8d 45 14             	lea    0x14(%ebp),%eax
  800998:	50                   	push   %eax
  800999:	e8 3c fd ff ff       	call   8006da <getint>
  80099e:	83 c4 10             	add    $0x10,%esp
  8009a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ad:	85 d2                	test   %edx,%edx
  8009af:	79 23                	jns    8009d4 <vprintfmt+0x29b>
				putch('-', putdat);
  8009b1:	83 ec 08             	sub    $0x8,%esp
  8009b4:	ff 75 0c             	pushl  0xc(%ebp)
  8009b7:	6a 2d                	push   $0x2d
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	ff d0                	call   *%eax
  8009be:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009c7:	f7 d8                	neg    %eax
  8009c9:	83 d2 00             	adc    $0x0,%edx
  8009cc:	f7 da                	neg    %edx
  8009ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009d4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009db:	e9 bc 00 00 00       	jmp    800a9c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009e0:	83 ec 08             	sub    $0x8,%esp
  8009e3:	ff 75 e8             	pushl  -0x18(%ebp)
  8009e6:	8d 45 14             	lea    0x14(%ebp),%eax
  8009e9:	50                   	push   %eax
  8009ea:	e8 84 fc ff ff       	call   800673 <getuint>
  8009ef:	83 c4 10             	add    $0x10,%esp
  8009f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009f5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009f8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009ff:	e9 98 00 00 00       	jmp    800a9c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a04:	83 ec 08             	sub    $0x8,%esp
  800a07:	ff 75 0c             	pushl  0xc(%ebp)
  800a0a:	6a 58                	push   $0x58
  800a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0f:	ff d0                	call   *%eax
  800a11:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a14:	83 ec 08             	sub    $0x8,%esp
  800a17:	ff 75 0c             	pushl  0xc(%ebp)
  800a1a:	6a 58                	push   $0x58
  800a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1f:	ff d0                	call   *%eax
  800a21:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a24:	83 ec 08             	sub    $0x8,%esp
  800a27:	ff 75 0c             	pushl  0xc(%ebp)
  800a2a:	6a 58                	push   $0x58
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	ff d0                	call   *%eax
  800a31:	83 c4 10             	add    $0x10,%esp
			break;
  800a34:	e9 bc 00 00 00       	jmp    800af5 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a39:	83 ec 08             	sub    $0x8,%esp
  800a3c:	ff 75 0c             	pushl  0xc(%ebp)
  800a3f:	6a 30                	push   $0x30
  800a41:	8b 45 08             	mov    0x8(%ebp),%eax
  800a44:	ff d0                	call   *%eax
  800a46:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a49:	83 ec 08             	sub    $0x8,%esp
  800a4c:	ff 75 0c             	pushl  0xc(%ebp)
  800a4f:	6a 78                	push   $0x78
  800a51:	8b 45 08             	mov    0x8(%ebp),%eax
  800a54:	ff d0                	call   *%eax
  800a56:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a59:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5c:	83 c0 04             	add    $0x4,%eax
  800a5f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a62:	8b 45 14             	mov    0x14(%ebp),%eax
  800a65:	83 e8 04             	sub    $0x4,%eax
  800a68:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a6d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a74:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a7b:	eb 1f                	jmp    800a9c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a7d:	83 ec 08             	sub    $0x8,%esp
  800a80:	ff 75 e8             	pushl  -0x18(%ebp)
  800a83:	8d 45 14             	lea    0x14(%ebp),%eax
  800a86:	50                   	push   %eax
  800a87:	e8 e7 fb ff ff       	call   800673 <getuint>
  800a8c:	83 c4 10             	add    $0x10,%esp
  800a8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a92:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a95:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a9c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800aa0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aa3:	83 ec 04             	sub    $0x4,%esp
  800aa6:	52                   	push   %edx
  800aa7:	ff 75 e4             	pushl  -0x1c(%ebp)
  800aaa:	50                   	push   %eax
  800aab:	ff 75 f4             	pushl  -0xc(%ebp)
  800aae:	ff 75 f0             	pushl  -0x10(%ebp)
  800ab1:	ff 75 0c             	pushl  0xc(%ebp)
  800ab4:	ff 75 08             	pushl  0x8(%ebp)
  800ab7:	e8 00 fb ff ff       	call   8005bc <printnum>
  800abc:	83 c4 20             	add    $0x20,%esp
			break;
  800abf:	eb 34                	jmp    800af5 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ac1:	83 ec 08             	sub    $0x8,%esp
  800ac4:	ff 75 0c             	pushl  0xc(%ebp)
  800ac7:	53                   	push   %ebx
  800ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  800acb:	ff d0                	call   *%eax
  800acd:	83 c4 10             	add    $0x10,%esp
			break;
  800ad0:	eb 23                	jmp    800af5 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ad2:	83 ec 08             	sub    $0x8,%esp
  800ad5:	ff 75 0c             	pushl  0xc(%ebp)
  800ad8:	6a 25                	push   $0x25
  800ada:	8b 45 08             	mov    0x8(%ebp),%eax
  800add:	ff d0                	call   *%eax
  800adf:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ae2:	ff 4d 10             	decl   0x10(%ebp)
  800ae5:	eb 03                	jmp    800aea <vprintfmt+0x3b1>
  800ae7:	ff 4d 10             	decl   0x10(%ebp)
  800aea:	8b 45 10             	mov    0x10(%ebp),%eax
  800aed:	48                   	dec    %eax
  800aee:	8a 00                	mov    (%eax),%al
  800af0:	3c 25                	cmp    $0x25,%al
  800af2:	75 f3                	jne    800ae7 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800af4:	90                   	nop
		}
	}
  800af5:	e9 47 fc ff ff       	jmp    800741 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800afa:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800afb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800afe:	5b                   	pop    %ebx
  800aff:	5e                   	pop    %esi
  800b00:	5d                   	pop    %ebp
  800b01:	c3                   	ret    

00800b02 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b02:	55                   	push   %ebp
  800b03:	89 e5                	mov    %esp,%ebp
  800b05:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b08:	8d 45 10             	lea    0x10(%ebp),%eax
  800b0b:	83 c0 04             	add    $0x4,%eax
  800b0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b11:	8b 45 10             	mov    0x10(%ebp),%eax
  800b14:	ff 75 f4             	pushl  -0xc(%ebp)
  800b17:	50                   	push   %eax
  800b18:	ff 75 0c             	pushl  0xc(%ebp)
  800b1b:	ff 75 08             	pushl  0x8(%ebp)
  800b1e:	e8 16 fc ff ff       	call   800739 <vprintfmt>
  800b23:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b26:	90                   	nop
  800b27:	c9                   	leave  
  800b28:	c3                   	ret    

00800b29 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b29:	55                   	push   %ebp
  800b2a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2f:	8b 40 08             	mov    0x8(%eax),%eax
  800b32:	8d 50 01             	lea    0x1(%eax),%edx
  800b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b38:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3e:	8b 10                	mov    (%eax),%edx
  800b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b43:	8b 40 04             	mov    0x4(%eax),%eax
  800b46:	39 c2                	cmp    %eax,%edx
  800b48:	73 12                	jae    800b5c <sprintputch+0x33>
		*b->buf++ = ch;
  800b4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4d:	8b 00                	mov    (%eax),%eax
  800b4f:	8d 48 01             	lea    0x1(%eax),%ecx
  800b52:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b55:	89 0a                	mov    %ecx,(%edx)
  800b57:	8b 55 08             	mov    0x8(%ebp),%edx
  800b5a:	88 10                	mov    %dl,(%eax)
}
  800b5c:	90                   	nop
  800b5d:	5d                   	pop    %ebp
  800b5e:	c3                   	ret    

00800b5f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b5f:	55                   	push   %ebp
  800b60:	89 e5                	mov    %esp,%ebp
  800b62:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b71:	8b 45 08             	mov    0x8(%ebp),%eax
  800b74:	01 d0                	add    %edx,%eax
  800b76:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b80:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b84:	74 06                	je     800b8c <vsnprintf+0x2d>
  800b86:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b8a:	7f 07                	jg     800b93 <vsnprintf+0x34>
		return -E_INVAL;
  800b8c:	b8 03 00 00 00       	mov    $0x3,%eax
  800b91:	eb 20                	jmp    800bb3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b93:	ff 75 14             	pushl  0x14(%ebp)
  800b96:	ff 75 10             	pushl  0x10(%ebp)
  800b99:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b9c:	50                   	push   %eax
  800b9d:	68 29 0b 80 00       	push   $0x800b29
  800ba2:	e8 92 fb ff ff       	call   800739 <vprintfmt>
  800ba7:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800baa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bad:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bb3:	c9                   	leave  
  800bb4:	c3                   	ret    

00800bb5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bbb:	8d 45 10             	lea    0x10(%ebp),%eax
  800bbe:	83 c0 04             	add    $0x4,%eax
  800bc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bc4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc7:	ff 75 f4             	pushl  -0xc(%ebp)
  800bca:	50                   	push   %eax
  800bcb:	ff 75 0c             	pushl  0xc(%ebp)
  800bce:	ff 75 08             	pushl  0x8(%ebp)
  800bd1:	e8 89 ff ff ff       	call   800b5f <vsnprintf>
  800bd6:	83 c4 10             	add    $0x10,%esp
  800bd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bdf:	c9                   	leave  
  800be0:	c3                   	ret    

00800be1 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800be1:	55                   	push   %ebp
  800be2:	89 e5                	mov    %esp,%ebp
  800be4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800be7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bee:	eb 06                	jmp    800bf6 <strlen+0x15>
		n++;
  800bf0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bf3:	ff 45 08             	incl   0x8(%ebp)
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	8a 00                	mov    (%eax),%al
  800bfb:	84 c0                	test   %al,%al
  800bfd:	75 f1                	jne    800bf0 <strlen+0xf>
		n++;
	return n;
  800bff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c02:	c9                   	leave  
  800c03:	c3                   	ret    

00800c04 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c11:	eb 09                	jmp    800c1c <strnlen+0x18>
		n++;
  800c13:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c16:	ff 45 08             	incl   0x8(%ebp)
  800c19:	ff 4d 0c             	decl   0xc(%ebp)
  800c1c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c20:	74 09                	je     800c2b <strnlen+0x27>
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	8a 00                	mov    (%eax),%al
  800c27:	84 c0                	test   %al,%al
  800c29:	75 e8                	jne    800c13 <strnlen+0xf>
		n++;
	return n;
  800c2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c2e:	c9                   	leave  
  800c2f:	c3                   	ret    

00800c30 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c30:	55                   	push   %ebp
  800c31:	89 e5                	mov    %esp,%ebp
  800c33:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c36:	8b 45 08             	mov    0x8(%ebp),%eax
  800c39:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c3c:	90                   	nop
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	8d 50 01             	lea    0x1(%eax),%edx
  800c43:	89 55 08             	mov    %edx,0x8(%ebp)
  800c46:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c49:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c4c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c4f:	8a 12                	mov    (%edx),%dl
  800c51:	88 10                	mov    %dl,(%eax)
  800c53:	8a 00                	mov    (%eax),%al
  800c55:	84 c0                	test   %al,%al
  800c57:	75 e4                	jne    800c3d <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c59:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c5c:	c9                   	leave  
  800c5d:	c3                   	ret    

00800c5e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c5e:	55                   	push   %ebp
  800c5f:	89 e5                	mov    %esp,%ebp
  800c61:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c64:	8b 45 08             	mov    0x8(%ebp),%eax
  800c67:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c6a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c71:	eb 1f                	jmp    800c92 <strncpy+0x34>
		*dst++ = *src;
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	8d 50 01             	lea    0x1(%eax),%edx
  800c79:	89 55 08             	mov    %edx,0x8(%ebp)
  800c7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c7f:	8a 12                	mov    (%edx),%dl
  800c81:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c86:	8a 00                	mov    (%eax),%al
  800c88:	84 c0                	test   %al,%al
  800c8a:	74 03                	je     800c8f <strncpy+0x31>
			src++;
  800c8c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c8f:	ff 45 fc             	incl   -0x4(%ebp)
  800c92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c95:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c98:	72 d9                	jb     800c73 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c9d:	c9                   	leave  
  800c9e:	c3                   	ret    

00800c9f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c9f:	55                   	push   %ebp
  800ca0:	89 e5                	mov    %esp,%ebp
  800ca2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800caf:	74 30                	je     800ce1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cb1:	eb 16                	jmp    800cc9 <strlcpy+0x2a>
			*dst++ = *src++;
  800cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb6:	8d 50 01             	lea    0x1(%eax),%edx
  800cb9:	89 55 08             	mov    %edx,0x8(%ebp)
  800cbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cc2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cc5:	8a 12                	mov    (%edx),%dl
  800cc7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cc9:	ff 4d 10             	decl   0x10(%ebp)
  800ccc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd0:	74 09                	je     800cdb <strlcpy+0x3c>
  800cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd5:	8a 00                	mov    (%eax),%al
  800cd7:	84 c0                	test   %al,%al
  800cd9:	75 d8                	jne    800cb3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ce1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce7:	29 c2                	sub    %eax,%edx
  800ce9:	89 d0                	mov    %edx,%eax
}
  800ceb:	c9                   	leave  
  800cec:	c3                   	ret    

00800ced <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ced:	55                   	push   %ebp
  800cee:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cf0:	eb 06                	jmp    800cf8 <strcmp+0xb>
		p++, q++;
  800cf2:	ff 45 08             	incl   0x8(%ebp)
  800cf5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	8a 00                	mov    (%eax),%al
  800cfd:	84 c0                	test   %al,%al
  800cff:	74 0e                	je     800d0f <strcmp+0x22>
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	8a 10                	mov    (%eax),%dl
  800d06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d09:	8a 00                	mov    (%eax),%al
  800d0b:	38 c2                	cmp    %al,%dl
  800d0d:	74 e3                	je     800cf2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	8a 00                	mov    (%eax),%al
  800d14:	0f b6 d0             	movzbl %al,%edx
  800d17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1a:	8a 00                	mov    (%eax),%al
  800d1c:	0f b6 c0             	movzbl %al,%eax
  800d1f:	29 c2                	sub    %eax,%edx
  800d21:	89 d0                	mov    %edx,%eax
}
  800d23:	5d                   	pop    %ebp
  800d24:	c3                   	ret    

00800d25 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d28:	eb 09                	jmp    800d33 <strncmp+0xe>
		n--, p++, q++;
  800d2a:	ff 4d 10             	decl   0x10(%ebp)
  800d2d:	ff 45 08             	incl   0x8(%ebp)
  800d30:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d33:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d37:	74 17                	je     800d50 <strncmp+0x2b>
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8a 00                	mov    (%eax),%al
  800d3e:	84 c0                	test   %al,%al
  800d40:	74 0e                	je     800d50 <strncmp+0x2b>
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	8a 10                	mov    (%eax),%dl
  800d47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4a:	8a 00                	mov    (%eax),%al
  800d4c:	38 c2                	cmp    %al,%dl
  800d4e:	74 da                	je     800d2a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d54:	75 07                	jne    800d5d <strncmp+0x38>
		return 0;
  800d56:	b8 00 00 00 00       	mov    $0x0,%eax
  800d5b:	eb 14                	jmp    800d71 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d60:	8a 00                	mov    (%eax),%al
  800d62:	0f b6 d0             	movzbl %al,%edx
  800d65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d68:	8a 00                	mov    (%eax),%al
  800d6a:	0f b6 c0             	movzbl %al,%eax
  800d6d:	29 c2                	sub    %eax,%edx
  800d6f:	89 d0                	mov    %edx,%eax
}
  800d71:	5d                   	pop    %ebp
  800d72:	c3                   	ret    

00800d73 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	83 ec 04             	sub    $0x4,%esp
  800d79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d7f:	eb 12                	jmp    800d93 <strchr+0x20>
		if (*s == c)
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d89:	75 05                	jne    800d90 <strchr+0x1d>
			return (char *) s;
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	eb 11                	jmp    800da1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d90:	ff 45 08             	incl   0x8(%ebp)
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	8a 00                	mov    (%eax),%al
  800d98:	84 c0                	test   %al,%al
  800d9a:	75 e5                	jne    800d81 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800da1:	c9                   	leave  
  800da2:	c3                   	ret    

00800da3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	83 ec 04             	sub    $0x4,%esp
  800da9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dac:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800daf:	eb 0d                	jmp    800dbe <strfind+0x1b>
		if (*s == c)
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	8a 00                	mov    (%eax),%al
  800db6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800db9:	74 0e                	je     800dc9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dbb:	ff 45 08             	incl   0x8(%ebp)
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	8a 00                	mov    (%eax),%al
  800dc3:	84 c0                	test   %al,%al
  800dc5:	75 ea                	jne    800db1 <strfind+0xe>
  800dc7:	eb 01                	jmp    800dca <strfind+0x27>
		if (*s == c)
			break;
  800dc9:	90                   	nop
	return (char *) s;
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dcd:	c9                   	leave  
  800dce:	c3                   	ret    

00800dcf <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dcf:	55                   	push   %ebp
  800dd0:	89 e5                	mov    %esp,%ebp
  800dd2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ddb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dde:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800de1:	eb 0e                	jmp    800df1 <memset+0x22>
		*p++ = c;
  800de3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de6:	8d 50 01             	lea    0x1(%eax),%edx
  800de9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dec:	8b 55 0c             	mov    0xc(%ebp),%edx
  800def:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800df1:	ff 4d f8             	decl   -0x8(%ebp)
  800df4:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800df8:	79 e9                	jns    800de3 <memset+0x14>
		*p++ = c;

	return v;
  800dfa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dfd:	c9                   	leave  
  800dfe:	c3                   	ret    

00800dff <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dff:	55                   	push   %ebp
  800e00:	89 e5                	mov    %esp,%ebp
  800e02:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e11:	eb 16                	jmp    800e29 <memcpy+0x2a>
		*d++ = *s++;
  800e13:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e16:	8d 50 01             	lea    0x1(%eax),%edx
  800e19:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e1c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e1f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e22:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e25:	8a 12                	mov    (%edx),%dl
  800e27:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e29:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e2f:	89 55 10             	mov    %edx,0x10(%ebp)
  800e32:	85 c0                	test   %eax,%eax
  800e34:	75 dd                	jne    800e13 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e36:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e39:	c9                   	leave  
  800e3a:	c3                   	ret    

00800e3b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e3b:	55                   	push   %ebp
  800e3c:	89 e5                	mov    %esp,%ebp
  800e3e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  800e41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e50:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e53:	73 50                	jae    800ea5 <memmove+0x6a>
  800e55:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e58:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5b:	01 d0                	add    %edx,%eax
  800e5d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e60:	76 43                	jbe    800ea5 <memmove+0x6a>
		s += n;
  800e62:	8b 45 10             	mov    0x10(%ebp),%eax
  800e65:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e68:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e6e:	eb 10                	jmp    800e80 <memmove+0x45>
			*--d = *--s;
  800e70:	ff 4d f8             	decl   -0x8(%ebp)
  800e73:	ff 4d fc             	decl   -0x4(%ebp)
  800e76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e79:	8a 10                	mov    (%eax),%dl
  800e7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e7e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e80:	8b 45 10             	mov    0x10(%ebp),%eax
  800e83:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e86:	89 55 10             	mov    %edx,0x10(%ebp)
  800e89:	85 c0                	test   %eax,%eax
  800e8b:	75 e3                	jne    800e70 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e8d:	eb 23                	jmp    800eb2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e92:	8d 50 01             	lea    0x1(%eax),%edx
  800e95:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e98:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e9b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e9e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ea1:	8a 12                	mov    (%edx),%dl
  800ea3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ea5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eab:	89 55 10             	mov    %edx,0x10(%ebp)
  800eae:	85 c0                	test   %eax,%eax
  800eb0:	75 dd                	jne    800e8f <memmove+0x54>
			*d++ = *s++;

	return dst;
  800eb2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb5:	c9                   	leave  
  800eb6:	c3                   	ret    

00800eb7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800eb7:	55                   	push   %ebp
  800eb8:	89 e5                	mov    %esp,%ebp
  800eba:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ec3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ec9:	eb 2a                	jmp    800ef5 <memcmp+0x3e>
		if (*s1 != *s2)
  800ecb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ece:	8a 10                	mov    (%eax),%dl
  800ed0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed3:	8a 00                	mov    (%eax),%al
  800ed5:	38 c2                	cmp    %al,%dl
  800ed7:	74 16                	je     800eef <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ed9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800edc:	8a 00                	mov    (%eax),%al
  800ede:	0f b6 d0             	movzbl %al,%edx
  800ee1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee4:	8a 00                	mov    (%eax),%al
  800ee6:	0f b6 c0             	movzbl %al,%eax
  800ee9:	29 c2                	sub    %eax,%edx
  800eeb:	89 d0                	mov    %edx,%eax
  800eed:	eb 18                	jmp    800f07 <memcmp+0x50>
		s1++, s2++;
  800eef:	ff 45 fc             	incl   -0x4(%ebp)
  800ef2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ef5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800efb:	89 55 10             	mov    %edx,0x10(%ebp)
  800efe:	85 c0                	test   %eax,%eax
  800f00:	75 c9                	jne    800ecb <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f07:	c9                   	leave  
  800f08:	c3                   	ret    

00800f09 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f09:	55                   	push   %ebp
  800f0a:	89 e5                	mov    %esp,%ebp
  800f0c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f0f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f12:	8b 45 10             	mov    0x10(%ebp),%eax
  800f15:	01 d0                	add    %edx,%eax
  800f17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f1a:	eb 15                	jmp    800f31 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	8a 00                	mov    (%eax),%al
  800f21:	0f b6 d0             	movzbl %al,%edx
  800f24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f27:	0f b6 c0             	movzbl %al,%eax
  800f2a:	39 c2                	cmp    %eax,%edx
  800f2c:	74 0d                	je     800f3b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f2e:	ff 45 08             	incl   0x8(%ebp)
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f37:	72 e3                	jb     800f1c <memfind+0x13>
  800f39:	eb 01                	jmp    800f3c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f3b:	90                   	nop
	return (void *) s;
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f3f:	c9                   	leave  
  800f40:	c3                   	ret    

00800f41 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f41:	55                   	push   %ebp
  800f42:	89 e5                	mov    %esp,%ebp
  800f44:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f47:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f4e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f55:	eb 03                	jmp    800f5a <strtol+0x19>
		s++;
  800f57:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5d:	8a 00                	mov    (%eax),%al
  800f5f:	3c 20                	cmp    $0x20,%al
  800f61:	74 f4                	je     800f57 <strtol+0x16>
  800f63:	8b 45 08             	mov    0x8(%ebp),%eax
  800f66:	8a 00                	mov    (%eax),%al
  800f68:	3c 09                	cmp    $0x9,%al
  800f6a:	74 eb                	je     800f57 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	3c 2b                	cmp    $0x2b,%al
  800f73:	75 05                	jne    800f7a <strtol+0x39>
		s++;
  800f75:	ff 45 08             	incl   0x8(%ebp)
  800f78:	eb 13                	jmp    800f8d <strtol+0x4c>
	else if (*s == '-')
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	8a 00                	mov    (%eax),%al
  800f7f:	3c 2d                	cmp    $0x2d,%al
  800f81:	75 0a                	jne    800f8d <strtol+0x4c>
		s++, neg = 1;
  800f83:	ff 45 08             	incl   0x8(%ebp)
  800f86:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f8d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f91:	74 06                	je     800f99 <strtol+0x58>
  800f93:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f97:	75 20                	jne    800fb9 <strtol+0x78>
  800f99:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9c:	8a 00                	mov    (%eax),%al
  800f9e:	3c 30                	cmp    $0x30,%al
  800fa0:	75 17                	jne    800fb9 <strtol+0x78>
  800fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa5:	40                   	inc    %eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	3c 78                	cmp    $0x78,%al
  800faa:	75 0d                	jne    800fb9 <strtol+0x78>
		s += 2, base = 16;
  800fac:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fb0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fb7:	eb 28                	jmp    800fe1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fb9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fbd:	75 15                	jne    800fd4 <strtol+0x93>
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	8a 00                	mov    (%eax),%al
  800fc4:	3c 30                	cmp    $0x30,%al
  800fc6:	75 0c                	jne    800fd4 <strtol+0x93>
		s++, base = 8;
  800fc8:	ff 45 08             	incl   0x8(%ebp)
  800fcb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fd2:	eb 0d                	jmp    800fe1 <strtol+0xa0>
	else if (base == 0)
  800fd4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fd8:	75 07                	jne    800fe1 <strtol+0xa0>
		base = 10;
  800fda:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	3c 2f                	cmp    $0x2f,%al
  800fe8:	7e 19                	jle    801003 <strtol+0xc2>
  800fea:	8b 45 08             	mov    0x8(%ebp),%eax
  800fed:	8a 00                	mov    (%eax),%al
  800fef:	3c 39                	cmp    $0x39,%al
  800ff1:	7f 10                	jg     801003 <strtol+0xc2>
			dig = *s - '0';
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	8a 00                	mov    (%eax),%al
  800ff8:	0f be c0             	movsbl %al,%eax
  800ffb:	83 e8 30             	sub    $0x30,%eax
  800ffe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801001:	eb 42                	jmp    801045 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	3c 60                	cmp    $0x60,%al
  80100a:	7e 19                	jle    801025 <strtol+0xe4>
  80100c:	8b 45 08             	mov    0x8(%ebp),%eax
  80100f:	8a 00                	mov    (%eax),%al
  801011:	3c 7a                	cmp    $0x7a,%al
  801013:	7f 10                	jg     801025 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	8a 00                	mov    (%eax),%al
  80101a:	0f be c0             	movsbl %al,%eax
  80101d:	83 e8 57             	sub    $0x57,%eax
  801020:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801023:	eb 20                	jmp    801045 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	8a 00                	mov    (%eax),%al
  80102a:	3c 40                	cmp    $0x40,%al
  80102c:	7e 39                	jle    801067 <strtol+0x126>
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	8a 00                	mov    (%eax),%al
  801033:	3c 5a                	cmp    $0x5a,%al
  801035:	7f 30                	jg     801067 <strtol+0x126>
			dig = *s - 'A' + 10;
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	8a 00                	mov    (%eax),%al
  80103c:	0f be c0             	movsbl %al,%eax
  80103f:	83 e8 37             	sub    $0x37,%eax
  801042:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801048:	3b 45 10             	cmp    0x10(%ebp),%eax
  80104b:	7d 19                	jge    801066 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80104d:	ff 45 08             	incl   0x8(%ebp)
  801050:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801053:	0f af 45 10          	imul   0x10(%ebp),%eax
  801057:	89 c2                	mov    %eax,%edx
  801059:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80105c:	01 d0                	add    %edx,%eax
  80105e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801061:	e9 7b ff ff ff       	jmp    800fe1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801066:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801067:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80106b:	74 08                	je     801075 <strtol+0x134>
		*endptr = (char *) s;
  80106d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801070:	8b 55 08             	mov    0x8(%ebp),%edx
  801073:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801075:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801079:	74 07                	je     801082 <strtol+0x141>
  80107b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80107e:	f7 d8                	neg    %eax
  801080:	eb 03                	jmp    801085 <strtol+0x144>
  801082:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801085:	c9                   	leave  
  801086:	c3                   	ret    

00801087 <ltostr>:

void
ltostr(long value, char *str)
{
  801087:	55                   	push   %ebp
  801088:	89 e5                	mov    %esp,%ebp
  80108a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80108d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801094:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80109b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80109f:	79 13                	jns    8010b4 <ltostr+0x2d>
	{
		neg = 1;
  8010a1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ab:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010ae:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010b1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010bc:	99                   	cltd   
  8010bd:	f7 f9                	idiv   %ecx
  8010bf:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c5:	8d 50 01             	lea    0x1(%eax),%edx
  8010c8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010cb:	89 c2                	mov    %eax,%edx
  8010cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d0:	01 d0                	add    %edx,%eax
  8010d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010d5:	83 c2 30             	add    $0x30,%edx
  8010d8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010dd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010e2:	f7 e9                	imul   %ecx
  8010e4:	c1 fa 02             	sar    $0x2,%edx
  8010e7:	89 c8                	mov    %ecx,%eax
  8010e9:	c1 f8 1f             	sar    $0x1f,%eax
  8010ec:	29 c2                	sub    %eax,%edx
  8010ee:	89 d0                	mov    %edx,%eax
  8010f0:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010f6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010fb:	f7 e9                	imul   %ecx
  8010fd:	c1 fa 02             	sar    $0x2,%edx
  801100:	89 c8                	mov    %ecx,%eax
  801102:	c1 f8 1f             	sar    $0x1f,%eax
  801105:	29 c2                	sub    %eax,%edx
  801107:	89 d0                	mov    %edx,%eax
  801109:	c1 e0 02             	shl    $0x2,%eax
  80110c:	01 d0                	add    %edx,%eax
  80110e:	01 c0                	add    %eax,%eax
  801110:	29 c1                	sub    %eax,%ecx
  801112:	89 ca                	mov    %ecx,%edx
  801114:	85 d2                	test   %edx,%edx
  801116:	75 9c                	jne    8010b4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801118:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80111f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801122:	48                   	dec    %eax
  801123:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801126:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80112a:	74 3d                	je     801169 <ltostr+0xe2>
		start = 1 ;
  80112c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801133:	eb 34                	jmp    801169 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801135:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801138:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113b:	01 d0                	add    %edx,%eax
  80113d:	8a 00                	mov    (%eax),%al
  80113f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801142:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801145:	8b 45 0c             	mov    0xc(%ebp),%eax
  801148:	01 c2                	add    %eax,%edx
  80114a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80114d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801150:	01 c8                	add    %ecx,%eax
  801152:	8a 00                	mov    (%eax),%al
  801154:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801156:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801159:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115c:	01 c2                	add    %eax,%edx
  80115e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801161:	88 02                	mov    %al,(%edx)
		start++ ;
  801163:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801166:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80116c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80116f:	7c c4                	jl     801135 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801171:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801174:	8b 45 0c             	mov    0xc(%ebp),%eax
  801177:	01 d0                	add    %edx,%eax
  801179:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80117c:	90                   	nop
  80117d:	c9                   	leave  
  80117e:	c3                   	ret    

0080117f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
  801182:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801185:	ff 75 08             	pushl  0x8(%ebp)
  801188:	e8 54 fa ff ff       	call   800be1 <strlen>
  80118d:	83 c4 04             	add    $0x4,%esp
  801190:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801193:	ff 75 0c             	pushl  0xc(%ebp)
  801196:	e8 46 fa ff ff       	call   800be1 <strlen>
  80119b:	83 c4 04             	add    $0x4,%esp
  80119e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011af:	eb 17                	jmp    8011c8 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b7:	01 c2                	add    %eax,%edx
  8011b9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bf:	01 c8                	add    %ecx,%eax
  8011c1:	8a 00                	mov    (%eax),%al
  8011c3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011c5:	ff 45 fc             	incl   -0x4(%ebp)
  8011c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011cb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011ce:	7c e1                	jl     8011b1 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011d0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011d7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011de:	eb 1f                	jmp    8011ff <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e3:	8d 50 01             	lea    0x1(%eax),%edx
  8011e6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011e9:	89 c2                	mov    %eax,%edx
  8011eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ee:	01 c2                	add    %eax,%edx
  8011f0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f6:	01 c8                	add    %ecx,%eax
  8011f8:	8a 00                	mov    (%eax),%al
  8011fa:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011fc:	ff 45 f8             	incl   -0x8(%ebp)
  8011ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801202:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801205:	7c d9                	jl     8011e0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801207:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80120a:	8b 45 10             	mov    0x10(%ebp),%eax
  80120d:	01 d0                	add    %edx,%eax
  80120f:	c6 00 00             	movb   $0x0,(%eax)
}
  801212:	90                   	nop
  801213:	c9                   	leave  
  801214:	c3                   	ret    

00801215 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801218:	8b 45 14             	mov    0x14(%ebp),%eax
  80121b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801221:	8b 45 14             	mov    0x14(%ebp),%eax
  801224:	8b 00                	mov    (%eax),%eax
  801226:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80122d:	8b 45 10             	mov    0x10(%ebp),%eax
  801230:	01 d0                	add    %edx,%eax
  801232:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801238:	eb 0c                	jmp    801246 <strsplit+0x31>
			*string++ = 0;
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
  80123d:	8d 50 01             	lea    0x1(%eax),%edx
  801240:	89 55 08             	mov    %edx,0x8(%ebp)
  801243:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801246:	8b 45 08             	mov    0x8(%ebp),%eax
  801249:	8a 00                	mov    (%eax),%al
  80124b:	84 c0                	test   %al,%al
  80124d:	74 18                	je     801267 <strsplit+0x52>
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	8a 00                	mov    (%eax),%al
  801254:	0f be c0             	movsbl %al,%eax
  801257:	50                   	push   %eax
  801258:	ff 75 0c             	pushl  0xc(%ebp)
  80125b:	e8 13 fb ff ff       	call   800d73 <strchr>
  801260:	83 c4 08             	add    $0x8,%esp
  801263:	85 c0                	test   %eax,%eax
  801265:	75 d3                	jne    80123a <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	84 c0                	test   %al,%al
  80126e:	74 5a                	je     8012ca <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  801270:	8b 45 14             	mov    0x14(%ebp),%eax
  801273:	8b 00                	mov    (%eax),%eax
  801275:	83 f8 0f             	cmp    $0xf,%eax
  801278:	75 07                	jne    801281 <strsplit+0x6c>
		{
			return 0;
  80127a:	b8 00 00 00 00       	mov    $0x0,%eax
  80127f:	eb 66                	jmp    8012e7 <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801281:	8b 45 14             	mov    0x14(%ebp),%eax
  801284:	8b 00                	mov    (%eax),%eax
  801286:	8d 48 01             	lea    0x1(%eax),%ecx
  801289:	8b 55 14             	mov    0x14(%ebp),%edx
  80128c:	89 0a                	mov    %ecx,(%edx)
  80128e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801295:	8b 45 10             	mov    0x10(%ebp),%eax
  801298:	01 c2                	add    %eax,%edx
  80129a:	8b 45 08             	mov    0x8(%ebp),%eax
  80129d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80129f:	eb 03                	jmp    8012a4 <strsplit+0x8f>
			string++;
  8012a1:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	8a 00                	mov    (%eax),%al
  8012a9:	84 c0                	test   %al,%al
  8012ab:	74 8b                	je     801238 <strsplit+0x23>
  8012ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b0:	8a 00                	mov    (%eax),%al
  8012b2:	0f be c0             	movsbl %al,%eax
  8012b5:	50                   	push   %eax
  8012b6:	ff 75 0c             	pushl  0xc(%ebp)
  8012b9:	e8 b5 fa ff ff       	call   800d73 <strchr>
  8012be:	83 c4 08             	add    $0x8,%esp
  8012c1:	85 c0                	test   %eax,%eax
  8012c3:	74 dc                	je     8012a1 <strsplit+0x8c>
			string++;
	}
  8012c5:	e9 6e ff ff ff       	jmp    801238 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012ca:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ce:	8b 00                	mov    (%eax),%eax
  8012d0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012da:	01 d0                	add    %edx,%eax
  8012dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012e2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012e7:	c9                   	leave  
  8012e8:	c3                   	ret    

008012e9 <malloc>:
int cnt_mem = 0;
int heap_mem[size_uhmem] = { 0 };
struct hmem heap_size[size_uhmem] = { 0 };
int check = 0;

void* malloc(uint32 size) {
  8012e9:	55                   	push   %ebp
  8012ea:	89 e5                	mov    %esp,%ebp
  8012ec:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyNEXTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	//NEXT FIT
	if (sys_isUHeapPlacementStrategyNEXTFIT()) {
  8012f2:	e8 7d 0f 00 00       	call   802274 <sys_isUHeapPlacementStrategyNEXTFIT>
  8012f7:	85 c0                	test   %eax,%eax
  8012f9:	0f 84 6f 03 00 00    	je     80166e <malloc+0x385>
		size = ROUNDUP(size, PAGE_SIZE);
  8012ff:	c7 45 84 00 10 00 00 	movl   $0x1000,-0x7c(%ebp)
  801306:	8b 55 08             	mov    0x8(%ebp),%edx
  801309:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80130c:	01 d0                	add    %edx,%eax
  80130e:	48                   	dec    %eax
  80130f:	89 45 80             	mov    %eax,-0x80(%ebp)
  801312:	8b 45 80             	mov    -0x80(%ebp),%eax
  801315:	ba 00 00 00 00       	mov    $0x0,%edx
  80131a:	f7 75 84             	divl   -0x7c(%ebp)
  80131d:	8b 45 80             	mov    -0x80(%ebp),%eax
  801320:	29 d0                	sub    %edx,%eax
  801322:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801325:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801329:	74 09                	je     801334 <malloc+0x4b>
  80132b:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801332:	76 0a                	jbe    80133e <malloc+0x55>
			return NULL;
  801334:	b8 00 00 00 00       	mov    $0x0,%eax
  801339:	e9 4b 09 00 00       	jmp    801c89 <malloc+0x9a0>
		}
		// first we can allocate by " Strategy Continues "
		if (ptr_uheap + size <= (uint32) USER_HEAP_MAX && !check) {
  80133e:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801344:	8b 45 08             	mov    0x8(%ebp),%eax
  801347:	01 d0                	add    %edx,%eax
  801349:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80134e:	0f 87 a2 00 00 00    	ja     8013f6 <malloc+0x10d>
  801354:	a1 40 30 98 00       	mov    0x983040,%eax
  801359:	85 c0                	test   %eax,%eax
  80135b:	0f 85 95 00 00 00    	jne    8013f6 <malloc+0x10d>

			void* ret = (void *) ptr_uheap;
  801361:	a1 04 30 80 00       	mov    0x803004,%eax
  801366:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			sys_allocateMem(ptr_uheap, size);
  80136c:	a1 04 30 80 00       	mov    0x803004,%eax
  801371:	83 ec 08             	sub    $0x8,%esp
  801374:	ff 75 08             	pushl  0x8(%ebp)
  801377:	50                   	push   %eax
  801378:	e8 a3 0b 00 00       	call   801f20 <sys_allocateMem>
  80137d:	83 c4 10             	add    $0x10,%esp

			heap_size[cnt_mem].size = size;
  801380:	a1 20 30 80 00       	mov    0x803020,%eax
  801385:	8b 55 08             	mov    0x8(%ebp),%edx
  801388:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
  80138f:	a1 20 30 80 00       	mov    0x803020,%eax
  801394:	8b 15 04 30 80 00    	mov    0x803004,%edx
  80139a:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
			cnt_mem++;
  8013a1:	a1 20 30 80 00       	mov    0x803020,%eax
  8013a6:	40                   	inc    %eax
  8013a7:	a3 20 30 80 00       	mov    %eax,0x803020
			int i = 0;
  8013ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  8013b3:	eb 2e                	jmp    8013e3 <malloc+0xfa>
			{

				heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8013b5:	a1 04 30 80 00       	mov    0x803004,%eax
  8013ba:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] = 1;
  8013bf:	c1 e8 0c             	shr    $0xc,%eax
  8013c2:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  8013c9:	01 00 00 00 

				ptr_uheap += (uint32) PAGE_SIZE;
  8013cd:	a1 04 30 80 00       	mov    0x803004,%eax
  8013d2:	05 00 10 00 00       	add    $0x1000,%eax
  8013d7:	a3 04 30 80 00       	mov    %eax,0x803004
			heap_size[cnt_mem].size = size;
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
			cnt_mem++;
			int i = 0;
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  8013dc:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  8013e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013e6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8013e9:	72 ca                	jb     8013b5 <malloc+0xcc>
						/ (uint32) PAGE_SIZE)] = 1;

				ptr_uheap += (uint32) PAGE_SIZE;
			}

			return ret;
  8013eb:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8013f1:	e9 93 08 00 00       	jmp    801c89 <malloc+0x9a0>

		} else {
			// second we can allocate by " Strategy NEXTFIT "
			void* temp_end = NULL;
  8013f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

			int check_start = 0;
  8013fd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			// check first that we used " Strategy Continues " before and not do it again and turn to NEXTFIT
			if (!check) {
  801404:	a1 40 30 98 00       	mov    0x983040,%eax
  801409:	85 c0                	test   %eax,%eax
  80140b:	75 1d                	jne    80142a <malloc+0x141>
				ptr_uheap = (uint32) USER_HEAP_START;
  80140d:	c7 05 04 30 80 00 00 	movl   $0x80000000,0x803004
  801414:	00 00 80 
				check = 1;
  801417:	c7 05 40 30 98 00 01 	movl   $0x1,0x983040
  80141e:	00 00 00 
				check_start = 1;// to dont use second loop CZ ptr_uheap start from USER_HEAP_START
  801421:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  801428:	eb 08                	jmp    801432 <malloc+0x149>
			} else {
				temp_end = (void*) ptr_uheap;
  80142a:	a1 04 30 80 00       	mov    0x803004,%eax
  80142f:	89 45 f0             	mov    %eax,-0x10(%ebp)

			}

			uint32 sz = 0;
  801432:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
			int f = 0;
  801439:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			uint32 ptr = ptr_uheap;
  801440:	a1 04 30 80 00       	mov    0x803004,%eax
  801445:	89 45 e0             	mov    %eax,-0x20(%ebp)
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  801448:	eb 4d                	jmp    801497 <malloc+0x1ae>
				if (sz == size) {
  80144a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80144d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801450:	75 09                	jne    80145b <malloc+0x172>
					f = 1;
  801452:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  801459:	eb 45                	jmp    8014a0 <malloc+0x1b7>
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  80145b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80145e:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] == 0) {
  801463:	c1 e8 0c             	shr    $0xc,%eax
			while (ptr < (uint32) USER_HEAP_MAX) {
				if (sz == size) {
					f = 1;
					break;
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801466:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  80146d:	85 c0                	test   %eax,%eax
  80146f:	75 10                	jne    801481 <malloc+0x198>
						/ (uint32) PAGE_SIZE)] == 0) {

					sz += PAGE_SIZE;
  801471:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
					ptr += PAGE_SIZE;
  801478:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  80147f:	eb 16                	jmp    801497 <malloc+0x1ae>
				} else {
					sz = 0;
  801481:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
					ptr += PAGE_SIZE;
  801488:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
					ptr_uheap = ptr;
  80148f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801492:	a3 04 30 80 00       	mov    %eax,0x803004

			uint32 sz = 0;
			int f = 0;
			uint32 ptr = ptr_uheap;
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  801497:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  80149e:	76 aa                	jbe    80144a <malloc+0x161>
					ptr_uheap = ptr;
				}

			}

			if (f) {
  8014a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014a4:	0f 84 95 00 00 00    	je     80153f <malloc+0x256>

				void* ret = (void *) ptr_uheap;
  8014aa:	a1 04 30 80 00       	mov    0x803004,%eax
  8014af:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

				sys_allocateMem(ptr_uheap, size);
  8014b5:	a1 04 30 80 00       	mov    0x803004,%eax
  8014ba:	83 ec 08             	sub    $0x8,%esp
  8014bd:	ff 75 08             	pushl  0x8(%ebp)
  8014c0:	50                   	push   %eax
  8014c1:	e8 5a 0a 00 00       	call   801f20 <sys_allocateMem>
  8014c6:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  8014c9:	a1 20 30 80 00       	mov    0x803020,%eax
  8014ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d1:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8014d8:	a1 20 30 80 00       	mov    0x803020,%eax
  8014dd:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8014e3:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
				cnt_mem++;
  8014ea:	a1 20 30 80 00       	mov    0x803020,%eax
  8014ef:	40                   	inc    %eax
  8014f0:	a3 20 30 80 00       	mov    %eax,0x803020
				int i = 0;
  8014f5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  8014fc:	eb 2e                	jmp    80152c <malloc+0x243>
				{

					heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8014fe:	a1 04 30 80 00       	mov    0x803004,%eax
  801503:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  801508:	c1 e8 0c             	shr    $0xc,%eax
  80150b:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801512:	01 00 00 00 

					ptr_uheap += (uint32) PAGE_SIZE;
  801516:	a1 04 30 80 00       	mov    0x803004,%eax
  80151b:	05 00 10 00 00       	add    $0x1000,%eax
  801520:	a3 04 30 80 00       	mov    %eax,0x803004
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
				cnt_mem++;
				int i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801525:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  80152c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80152f:	3b 45 08             	cmp    0x8(%ebp),%eax
  801532:	72 ca                	jb     8014fe <malloc+0x215>
							/ (uint32) PAGE_SIZE)] = 1;

					ptr_uheap += (uint32) PAGE_SIZE;
				}

				return ret;
  801534:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80153a:	e9 4a 07 00 00       	jmp    801c89 <malloc+0x9a0>

			} else {

				if (check_start) {
  80153f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801543:	74 0a                	je     80154f <malloc+0x266>

					return NULL;
  801545:	b8 00 00 00 00       	mov    $0x0,%eax
  80154a:	e9 3a 07 00 00       	jmp    801c89 <malloc+0x9a0>
				}

//////////////back loop////////////////

				uint32 sz = 0;
  80154f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
				int f = 0;
  801556:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				uint32 ptr = USER_HEAP_START;
  80155d:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
				ptr_uheap = USER_HEAP_START;
  801564:	c7 05 04 30 80 00 00 	movl   $0x80000000,0x803004
  80156b:	00 00 80 
				while (ptr < (uint32) temp_end) {
  80156e:	eb 4d                	jmp    8015bd <malloc+0x2d4>
					if (sz == size) {
  801570:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801573:	3b 45 08             	cmp    0x8(%ebp),%eax
  801576:	75 09                	jne    801581 <malloc+0x298>
						f = 1;
  801578:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
						break;
  80157f:	eb 44                	jmp    8015c5 <malloc+0x2dc>
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801581:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801584:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] == 0) {
  801589:	c1 e8 0c             	shr    $0xc,%eax
				while (ptr < (uint32) temp_end) {
					if (sz == size) {
						f = 1;
						break;
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  80158c:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  801593:	85 c0                	test   %eax,%eax
  801595:	75 10                	jne    8015a7 <malloc+0x2be>
							/ (uint32) PAGE_SIZE)] == 0) {

						sz += PAGE_SIZE;
  801597:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
						ptr += PAGE_SIZE;
  80159e:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
  8015a5:	eb 16                	jmp    8015bd <malloc+0x2d4>
					} else {
						sz = 0;
  8015a7:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
						ptr += PAGE_SIZE;
  8015ae:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
						ptr_uheap = ptr;
  8015b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8015b8:	a3 04 30 80 00       	mov    %eax,0x803004

				uint32 sz = 0;
				int f = 0;
				uint32 ptr = USER_HEAP_START;
				ptr_uheap = USER_HEAP_START;
				while (ptr < (uint32) temp_end) {
  8015bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c0:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  8015c3:	72 ab                	jb     801570 <malloc+0x287>
						ptr_uheap = ptr;
					}

				}

				if (f) {
  8015c5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8015c9:	0f 84 95 00 00 00    	je     801664 <malloc+0x37b>

					void* ret = (void *) ptr_uheap;
  8015cf:	a1 04 30 80 00       	mov    0x803004,%eax
  8015d4:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

					sys_allocateMem(ptr_uheap, size);
  8015da:	a1 04 30 80 00       	mov    0x803004,%eax
  8015df:	83 ec 08             	sub    $0x8,%esp
  8015e2:	ff 75 08             	pushl  0x8(%ebp)
  8015e5:	50                   	push   %eax
  8015e6:	e8 35 09 00 00       	call   801f20 <sys_allocateMem>
  8015eb:	83 c4 10             	add    $0x10,%esp

					heap_size[cnt_mem].size = size;
  8015ee:	a1 20 30 80 00       	mov    0x803020,%eax
  8015f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8015f6:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8015fd:	a1 20 30 80 00       	mov    0x803020,%eax
  801602:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801608:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
					cnt_mem++;
  80160f:	a1 20 30 80 00       	mov    0x803020,%eax
  801614:	40                   	inc    %eax
  801615:	a3 20 30 80 00       	mov    %eax,0x803020
					int i = 0;
  80161a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

					for (; i < size; i += PAGE_SIZE)
  801621:	eb 2e                	jmp    801651 <malloc+0x368>
					{

						heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801623:	a1 04 30 80 00       	mov    0x803004,%eax
  801628:	05 00 00 00 80       	add    $0x80000000,%eax
								/ (uint32) PAGE_SIZE)] = 1;
  80162d:	c1 e8 0c             	shr    $0xc,%eax
  801630:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801637:	01 00 00 00 

						ptr_uheap += (uint32) PAGE_SIZE;
  80163b:	a1 04 30 80 00       	mov    0x803004,%eax
  801640:	05 00 10 00 00       	add    $0x1000,%eax
  801645:	a3 04 30 80 00       	mov    %eax,0x803004
					heap_size[cnt_mem].size = size;
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
					cnt_mem++;
					int i = 0;

					for (; i < size; i += PAGE_SIZE)
  80164a:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  801651:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801654:	3b 45 08             	cmp    0x8(%ebp),%eax
  801657:	72 ca                	jb     801623 <malloc+0x33a>
								/ (uint32) PAGE_SIZE)] = 1;

						ptr_uheap += (uint32) PAGE_SIZE;
					}

					return ret;
  801659:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80165f:	e9 25 06 00 00       	jmp    801c89 <malloc+0x9a0>

				} else {

					return NULL;
  801664:	b8 00 00 00 00       	mov    $0x0,%eax
  801669:	e9 1b 06 00 00       	jmp    801c89 <malloc+0x9a0>

		}

	}

	else if (sys_isUHeapPlacementStrategyBESTFIT()) {
  80166e:	e8 d0 0b 00 00       	call   802243 <sys_isUHeapPlacementStrategyBESTFIT>
  801673:	85 c0                	test   %eax,%eax
  801675:	0f 84 ba 01 00 00    	je     801835 <malloc+0x54c>

		size = ROUNDUP(size, PAGE_SIZE);
  80167b:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  801682:	10 00 00 
  801685:	8b 55 08             	mov    0x8(%ebp),%edx
  801688:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80168e:	01 d0                	add    %edx,%eax
  801690:	48                   	dec    %eax
  801691:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  801697:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  80169d:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a2:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  8016a8:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8016ae:	29 d0                	sub    %edx,%eax
  8016b0:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  8016b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016b7:	74 09                	je     8016c2 <malloc+0x3d9>
  8016b9:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8016c0:	76 0a                	jbe    8016cc <malloc+0x3e3>
			return NULL;
  8016c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c7:	e9 bd 05 00 00       	jmp    801c89 <malloc+0x9a0>
		}
		uint32 ptr = (uint32) USER_HEAP_START;
  8016cc:	c7 45 c8 00 00 00 80 	movl   $0x80000000,-0x38(%ebp)
		uint32 temp = 0;
  8016d3:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		uint32 min_sz = size_uhmem + 1;
  8016da:	c7 45 c0 01 00 02 00 	movl   $0x20001,-0x40(%ebp)
		uint32 count = 0;
  8016e1:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
		int i = 0;
  8016e8:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	c1 e8 0c             	shr    $0xc,%eax
  8016f5:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  8016fb:	e9 80 00 00 00       	jmp    801780 <malloc+0x497>

			if (heap_mem[i] == 0) {
  801700:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801703:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  80170a:	85 c0                	test   %eax,%eax
  80170c:	75 0c                	jne    80171a <malloc+0x431>

				count++;
  80170e:	ff 45 bc             	incl   -0x44(%ebp)
				ptr += PAGE_SIZE;
  801711:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801718:	eb 2d                	jmp    801747 <malloc+0x45e>
			} else {
				if (num_p <= count && min_sz > count) {
  80171a:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801720:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801723:	77 14                	ja     801739 <malloc+0x450>
  801725:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801728:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  80172b:	76 0c                	jbe    801739 <malloc+0x450>

					min_sz = count;
  80172d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801730:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801733:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801736:	89 45 c4             	mov    %eax,-0x3c(%ebp)

				}
				count = 0;
  801739:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
				ptr += PAGE_SIZE;
  801740:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
			}

			if (i == size_uhmem - 1) {
  801747:	81 7d b8 ff ff 01 00 	cmpl   $0x1ffff,-0x48(%ebp)
  80174e:	75 2d                	jne    80177d <malloc+0x494>

				if (num_p <= count && min_sz > count) {
  801750:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801756:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801759:	77 22                	ja     80177d <malloc+0x494>
  80175b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80175e:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801761:	76 1a                	jbe    80177d <malloc+0x494>

					min_sz = count;
  801763:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801766:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801769:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80176c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
					count = 0;
  80176f:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
					ptr += PAGE_SIZE;
  801776:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  80177d:	ff 45 b8             	incl   -0x48(%ebp)
  801780:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801783:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801788:	0f 86 72 ff ff ff    	jbe    801700 <malloc+0x417>

			}

		}

		if (num_p > min_sz || temp == 0) {
  80178e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801794:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  801797:	77 06                	ja     80179f <malloc+0x4b6>
  801799:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80179d:	75 0a                	jne    8017a9 <malloc+0x4c0>
			return NULL;
  80179f:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a4:	e9 e0 04 00 00       	jmp    801c89 <malloc+0x9a0>

		}

		temp = temp - (PAGE_SIZE * min_sz);
  8017a9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8017ac:	c1 e0 0c             	shl    $0xc,%eax
  8017af:	29 45 c4             	sub    %eax,-0x3c(%ebp)
		void* ret = (void*) temp;
  8017b2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8017b5:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)

		sys_allocateMem(temp, size);
  8017bb:	83 ec 08             	sub    $0x8,%esp
  8017be:	ff 75 08             	pushl  0x8(%ebp)
  8017c1:	ff 75 c4             	pushl  -0x3c(%ebp)
  8017c4:	e8 57 07 00 00       	call   801f20 <sys_allocateMem>
  8017c9:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  8017cc:	a1 20 30 80 00       	mov    0x803020,%eax
  8017d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8017d4:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  8017db:	a1 20 30 80 00       	mov    0x803020,%eax
  8017e0:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8017e3:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
		cnt_mem++;
  8017ea:	a1 20 30 80 00       	mov    0x803020,%eax
  8017ef:	40                   	inc    %eax
  8017f0:	a3 20 30 80 00       	mov    %eax,0x803020
		i = 0;
  8017f5:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  8017fc:	eb 24                	jmp    801822 <malloc+0x539>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  8017fe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801801:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801806:	c1 e8 0c             	shr    $0xc,%eax
  801809:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801810:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801814:	81 45 c4 00 10 00 00 	addl   $0x1000,-0x3c(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  80181b:	81 45 b8 00 10 00 00 	addl   $0x1000,-0x48(%ebp)
  801822:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801825:	3b 45 08             	cmp    0x8(%ebp),%eax
  801828:	72 d4                	jb     8017fe <malloc+0x515>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  80182a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801830:	e9 54 04 00 00       	jmp    801c89 <malloc+0x9a0>

	} else if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801835:	e8 d8 09 00 00       	call   802212 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80183a:	85 c0                	test   %eax,%eax
  80183c:	0f 84 88 01 00 00    	je     8019ca <malloc+0x6e1>

		size = ROUNDUP(size, PAGE_SIZE);
  801842:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  801849:	10 00 00 
  80184c:	8b 55 08             	mov    0x8(%ebp),%edx
  80184f:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  801855:	01 d0                	add    %edx,%eax
  801857:	48                   	dec    %eax
  801858:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  80185e:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801864:	ba 00 00 00 00       	mov    $0x0,%edx
  801869:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  80186f:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801875:	29 d0                	sub    %edx,%eax
  801877:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  80187a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80187e:	74 09                	je     801889 <malloc+0x5a0>
  801880:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801887:	76 0a                	jbe    801893 <malloc+0x5aa>
			return NULL;
  801889:	b8 00 00 00 00       	mov    $0x0,%eax
  80188e:	e9 f6 03 00 00       	jmp    801c89 <malloc+0x9a0>
		}

		uint32 ptr = (uint32) USER_HEAP_START;
  801893:	c7 45 b4 00 00 00 80 	movl   $0x80000000,-0x4c(%ebp)
		uint32 temp = 0;
  80189a:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
		uint32 found = 0;
  8018a1:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		uint32 count = 0;
  8018a8:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
		int i = 0;
  8018af:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  8018b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b9:	c1 e8 0c             	shr    $0xc,%eax
  8018bc:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

		for (; i < size_uhmem; i++) {
  8018c2:	eb 5a                	jmp    80191e <malloc+0x635>

			if (heap_mem[i] == 0) {
  8018c4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8018c7:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  8018ce:	85 c0                	test   %eax,%eax
  8018d0:	75 0c                	jne    8018de <malloc+0x5f5>

				count++;
  8018d2:	ff 45 a8             	incl   -0x58(%ebp)
				ptr += PAGE_SIZE;
  8018d5:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
  8018dc:	eb 22                	jmp    801900 <malloc+0x617>
			} else {
				if (num_p <= count) {
  8018de:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8018e4:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  8018e7:	77 09                	ja     8018f2 <malloc+0x609>

					found = 1;
  8018e9:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)

					break;
  8018f0:	eb 36                	jmp    801928 <malloc+0x63f>
				}
				count = 0;
  8018f2:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
				ptr += PAGE_SIZE;
  8018f9:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
			}

			if (i == size_uhmem - 1) {
  801900:	81 7d a4 ff ff 01 00 	cmpl   $0x1ffff,-0x5c(%ebp)
  801907:	75 12                	jne    80191b <malloc+0x632>

				if (num_p <= count) {
  801909:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80190f:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801912:	77 07                	ja     80191b <malloc+0x632>

					found = 1;
  801914:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
		uint32 found = 0;
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		for (; i < size_uhmem; i++) {
  80191b:	ff 45 a4             	incl   -0x5c(%ebp)
  80191e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801921:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801926:	76 9c                	jbe    8018c4 <malloc+0x5db>

			}

		}

		if (!found) {
  801928:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  80192c:	75 0a                	jne    801938 <malloc+0x64f>
			return NULL;
  80192e:	b8 00 00 00 00       	mov    $0x0,%eax
  801933:	e9 51 03 00 00       	jmp    801c89 <malloc+0x9a0>

		}

		temp = ptr;
  801938:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80193b:	89 45 b0             	mov    %eax,-0x50(%ebp)
		temp = temp - (PAGE_SIZE * count);
  80193e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801941:	c1 e0 0c             	shl    $0xc,%eax
  801944:	29 45 b0             	sub    %eax,-0x50(%ebp)
		void* ret = (void*) temp;
  801947:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80194a:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)

		sys_allocateMem(temp, size);
  801950:	83 ec 08             	sub    $0x8,%esp
  801953:	ff 75 08             	pushl  0x8(%ebp)
  801956:	ff 75 b0             	pushl  -0x50(%ebp)
  801959:	e8 c2 05 00 00       	call   801f20 <sys_allocateMem>
  80195e:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801961:	a1 20 30 80 00       	mov    0x803020,%eax
  801966:	8b 55 08             	mov    0x8(%ebp),%edx
  801969:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801970:	a1 20 30 80 00       	mov    0x803020,%eax
  801975:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801978:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
		cnt_mem++;
  80197f:	a1 20 30 80 00       	mov    0x803020,%eax
  801984:	40                   	inc    %eax
  801985:	a3 20 30 80 00       	mov    %eax,0x803020
		i = 0;
  80198a:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801991:	eb 24                	jmp    8019b7 <malloc+0x6ce>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801993:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801996:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  80199b:	c1 e8 0c             	shr    $0xc,%eax
  80199e:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  8019a5:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  8019a9:	81 45 b0 00 10 00 00 	addl   $0x1000,-0x50(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  8019b0:	81 45 a4 00 10 00 00 	addl   $0x1000,-0x5c(%ebp)
  8019b7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8019ba:	3b 45 08             	cmp    0x8(%ebp),%eax
  8019bd:	72 d4                	jb     801993 <malloc+0x6aa>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  8019bf:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  8019c5:	e9 bf 02 00 00       	jmp    801c89 <malloc+0x9a0>

	}
	else if(sys_isUHeapPlacementStrategyWORSTFIT())
  8019ca:	e8 d6 08 00 00       	call   8022a5 <sys_isUHeapPlacementStrategyWORSTFIT>
  8019cf:	85 c0                	test   %eax,%eax
  8019d1:	0f 84 ba 01 00 00    	je     801b91 <malloc+0x8a8>
	{
		size = ROUNDUP(size, PAGE_SIZE);
  8019d7:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  8019de:	10 00 00 
  8019e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8019e4:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  8019ea:	01 d0                	add    %edx,%eax
  8019ec:	48                   	dec    %eax
  8019ed:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  8019f3:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  8019f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8019fe:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  801a04:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  801a0a:	29 d0                	sub    %edx,%eax
  801a0c:	89 45 08             	mov    %eax,0x8(%ebp)

				if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801a0f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a13:	74 09                	je     801a1e <malloc+0x735>
  801a15:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801a1c:	76 0a                	jbe    801a28 <malloc+0x73f>
					return NULL;
  801a1e:	b8 00 00 00 00       	mov    $0x0,%eax
  801a23:	e9 61 02 00 00       	jmp    801c89 <malloc+0x9a0>
				}
				uint32 ptr = (uint32) USER_HEAP_START;
  801a28:	c7 45 a0 00 00 00 80 	movl   $0x80000000,-0x60(%ebp)
				uint32 temp = 0;
  801a2f:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
				uint32 max_sz = -1;
  801a36:	c7 45 98 ff ff ff ff 	movl   $0xffffffff,-0x68(%ebp)
				uint32 count = 0;
  801a3d:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
				int i = 0;
  801a44:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				uint32 num_p = size / PAGE_SIZE;
  801a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4e:	c1 e8 0c             	shr    $0xc,%eax
  801a51:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  801a57:	e9 80 00 00 00       	jmp    801adc <malloc+0x7f3>

					if (heap_mem[i] == 0) {
  801a5c:	8b 45 90             	mov    -0x70(%ebp),%eax
  801a5f:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  801a66:	85 c0                	test   %eax,%eax
  801a68:	75 0c                	jne    801a76 <malloc+0x78d>

						count++;
  801a6a:	ff 45 94             	incl   -0x6c(%ebp)
						ptr += PAGE_SIZE;
  801a6d:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
  801a74:	eb 2d                	jmp    801aa3 <malloc+0x7ba>
					} else {
						if (num_p <= count && max_sz < count) {
  801a76:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801a7c:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801a7f:	77 14                	ja     801a95 <malloc+0x7ac>
  801a81:	8b 45 98             	mov    -0x68(%ebp),%eax
  801a84:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801a87:	73 0c                	jae    801a95 <malloc+0x7ac>

							max_sz = count;
  801a89:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801a8c:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  801a8f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801a92:	89 45 9c             	mov    %eax,-0x64(%ebp)

						}
						count = 0;
  801a95:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
						ptr += PAGE_SIZE;
  801a9c:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
					}

					if (i == size_uhmem - 1) {
  801aa3:	81 7d 90 ff ff 01 00 	cmpl   $0x1ffff,-0x70(%ebp)
  801aaa:	75 2d                	jne    801ad9 <malloc+0x7f0>

						if (num_p <= count && max_sz > count) {
  801aac:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801ab2:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801ab5:	77 22                	ja     801ad9 <malloc+0x7f0>
  801ab7:	8b 45 98             	mov    -0x68(%ebp),%eax
  801aba:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801abd:	76 1a                	jbe    801ad9 <malloc+0x7f0>

							max_sz = count;
  801abf:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801ac2:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  801ac5:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801ac8:	89 45 9c             	mov    %eax,-0x64(%ebp)
							count = 0;
  801acb:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
							ptr += PAGE_SIZE;
  801ad2:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
				uint32 count = 0;
				int i = 0;
				uint32 num_p = size / PAGE_SIZE;

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  801ad9:	ff 45 90             	incl   -0x70(%ebp)
  801adc:	8b 45 90             	mov    -0x70(%ebp),%eax
  801adf:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801ae4:	0f 86 72 ff ff ff    	jbe    801a5c <malloc+0x773>

					}

				}

				if (num_p > max_sz || temp == 0) {
  801aea:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801af0:	3b 45 98             	cmp    -0x68(%ebp),%eax
  801af3:	77 06                	ja     801afb <malloc+0x812>
  801af5:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  801af9:	75 0a                	jne    801b05 <malloc+0x81c>
					return NULL;
  801afb:	b8 00 00 00 00       	mov    $0x0,%eax
  801b00:	e9 84 01 00 00       	jmp    801c89 <malloc+0x9a0>

				}

				temp = temp - (PAGE_SIZE * max_sz);
  801b05:	8b 45 98             	mov    -0x68(%ebp),%eax
  801b08:	c1 e0 0c             	shl    $0xc,%eax
  801b0b:	29 45 9c             	sub    %eax,-0x64(%ebp)
				void* ret = (void*) temp;
  801b0e:	8b 45 9c             	mov    -0x64(%ebp),%eax
  801b11:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

				sys_allocateMem(temp, size);
  801b17:	83 ec 08             	sub    $0x8,%esp
  801b1a:	ff 75 08             	pushl  0x8(%ebp)
  801b1d:	ff 75 9c             	pushl  -0x64(%ebp)
  801b20:	e8 fb 03 00 00       	call   801f20 <sys_allocateMem>
  801b25:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  801b28:	a1 20 30 80 00       	mov    0x803020,%eax
  801b2d:	8b 55 08             	mov    0x8(%ebp),%edx
  801b30:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) temp;
  801b37:	a1 20 30 80 00       	mov    0x803020,%eax
  801b3c:	8b 55 9c             	mov    -0x64(%ebp),%edx
  801b3f:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
				cnt_mem++;
  801b46:	a1 20 30 80 00       	mov    0x803020,%eax
  801b4b:	40                   	inc    %eax
  801b4c:	a3 20 30 80 00       	mov    %eax,0x803020
				i = 0;
  801b51:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801b58:	eb 24                	jmp    801b7e <malloc+0x895>
				{

					heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801b5a:	8b 45 9c             	mov    -0x64(%ebp),%eax
  801b5d:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  801b62:	c1 e8 0c             	shr    $0xc,%eax
  801b65:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801b6c:	01 00 00 00 

					temp += (uint32) PAGE_SIZE;
  801b70:	81 45 9c 00 10 00 00 	addl   $0x1000,-0x64(%ebp)
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) temp;
				cnt_mem++;
				i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801b77:	81 45 90 00 10 00 00 	addl   $0x1000,-0x70(%ebp)
  801b7e:	8b 45 90             	mov    -0x70(%ebp),%eax
  801b81:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b84:	72 d4                	jb     801b5a <malloc+0x871>

					temp += (uint32) PAGE_SIZE;
				}

				//cprintf("\n size = %d.........vir= %d  \n",num_p,((uint32) ret-USER_HEAP_START)/PAGE_SIZE);
				return ret;
  801b86:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  801b8c:	e9 f8 00 00 00       	jmp    801c89 <malloc+0x9a0>

	}
// this is to make malloc is work
	void* ret = NULL;
  801b91:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
	size = ROUNDUP(size, PAGE_SIZE);
  801b98:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  801b9f:	10 00 00 
  801ba2:	8b 55 08             	mov    0x8(%ebp),%edx
  801ba5:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  801bab:	01 d0                	add    %edx,%eax
  801bad:	48                   	dec    %eax
  801bae:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  801bb4:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  801bba:	ba 00 00 00 00       	mov    $0x0,%edx
  801bbf:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  801bc5:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  801bcb:	29 d0                	sub    %edx,%eax
  801bcd:	89 45 08             	mov    %eax,0x8(%ebp)

	if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801bd0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bd4:	74 09                	je     801bdf <malloc+0x8f6>
  801bd6:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801bdd:	76 0a                	jbe    801be9 <malloc+0x900>
		return NULL;
  801bdf:	b8 00 00 00 00       	mov    $0x0,%eax
  801be4:	e9 a0 00 00 00       	jmp    801c89 <malloc+0x9a0>
	}

	if (ptr_uheap + size <= (uint32) USER_HEAP_MAX) {
  801be9:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801bef:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf2:	01 d0                	add    %edx,%eax
  801bf4:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801bf9:	0f 87 87 00 00 00    	ja     801c86 <malloc+0x99d>

		ret = (void *) ptr_uheap;
  801bff:	a1 04 30 80 00       	mov    0x803004,%eax
  801c04:	89 45 8c             	mov    %eax,-0x74(%ebp)
		sys_allocateMem(ptr_uheap, size);
  801c07:	a1 04 30 80 00       	mov    0x803004,%eax
  801c0c:	83 ec 08             	sub    $0x8,%esp
  801c0f:	ff 75 08             	pushl  0x8(%ebp)
  801c12:	50                   	push   %eax
  801c13:	e8 08 03 00 00       	call   801f20 <sys_allocateMem>
  801c18:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801c1b:	a1 20 30 80 00       	mov    0x803020,%eax
  801c20:	8b 55 08             	mov    0x8(%ebp),%edx
  801c23:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801c2a:	a1 20 30 80 00       	mov    0x803020,%eax
  801c2f:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801c35:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
		cnt_mem++;
  801c3c:	a1 20 30 80 00       	mov    0x803020,%eax
  801c41:	40                   	inc    %eax
  801c42:	a3 20 30 80 00       	mov    %eax,0x803020
		int i = 0;
  801c47:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)

		for (; i < size; i += PAGE_SIZE)
  801c4e:	eb 2e                	jmp    801c7e <malloc+0x995>
		{

			heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801c50:	a1 04 30 80 00       	mov    0x803004,%eax
  801c55:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801c5a:	c1 e8 0c             	shr    $0xc,%eax
  801c5d:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801c64:	01 00 00 00 

			ptr_uheap += (uint32) PAGE_SIZE;
  801c68:	a1 04 30 80 00       	mov    0x803004,%eax
  801c6d:	05 00 10 00 00       	add    $0x1000,%eax
  801c72:	a3 04 30 80 00       	mov    %eax,0x803004
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
		cnt_mem++;
		int i = 0;

		for (; i < size; i += PAGE_SIZE)
  801c77:	81 45 88 00 10 00 00 	addl   $0x1000,-0x78(%ebp)
  801c7e:	8b 45 88             	mov    -0x78(%ebp),%eax
  801c81:	3b 45 08             	cmp    0x8(%ebp),%eax
  801c84:	72 ca                	jb     801c50 <malloc+0x967>
					/ (uint32) PAGE_SIZE)] = 1;

			ptr_uheap += (uint32) PAGE_SIZE;
		}
	}
	return ret;
  801c86:	8b 45 8c             	mov    -0x74(%ebp),%eax

	//TODO: [PROJECT 2016 - BONUS2] Apply FIRST FIT and WORST FIT policies

//return 0;

}
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <free>:
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address) {
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
  801c8e:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
  801c91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; inx < cnt_mem; inx++) {
  801c98:	e9 c1 00 00 00       	jmp    801d5e <free+0xd3>
		if (heap_size[inx].vir == virtual_address) {
  801c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca0:	8b 04 c5 40 30 88 00 	mov    0x883040(,%eax,8),%eax
  801ca7:	3b 45 08             	cmp    0x8(%ebp),%eax
  801caa:	0f 85 ab 00 00 00    	jne    801d5b <free+0xd0>

			if (heap_size[inx].size == 0) {
  801cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb3:	8b 04 c5 44 30 88 00 	mov    0x883044(,%eax,8),%eax
  801cba:	85 c0                	test   %eax,%eax
  801cbc:	75 21                	jne    801cdf <free+0x54>
				heap_size[inx].size = 0;
  801cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc1:	c7 04 c5 44 30 88 00 	movl   $0x0,0x883044(,%eax,8)
  801cc8:	00 00 00 00 
				heap_size[inx].vir = NULL;
  801ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ccf:	c7 04 c5 40 30 88 00 	movl   $0x0,0x883040(,%eax,8)
  801cd6:	00 00 00 00 
				return;
  801cda:	e9 8d 00 00 00       	jmp    801d6c <free+0xe1>

			}

			sys_freeMem((uint32) virtual_address, heap_size[inx].size);
  801cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce2:	8b 14 c5 44 30 88 00 	mov    0x883044(,%eax,8),%edx
  801ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cec:	83 ec 08             	sub    $0x8,%esp
  801cef:	52                   	push   %edx
  801cf0:	50                   	push   %eax
  801cf1:	e8 0e 02 00 00       	call   801f04 <sys_freeMem>
  801cf6:	83 c4 10             	add    $0x10,%esp

			int i = 0;
  801cf9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
  801d00:	8b 45 08             	mov    0x8(%ebp),%eax
  801d03:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  801d06:	eb 24                	jmp    801d2c <free+0xa1>
			{
				heap_mem[(int) (((uint32) va - USER_HEAP_START) / PAGE_SIZE)] =
  801d08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d0b:	05 00 00 00 80       	add    $0x80000000,%eax
  801d10:	c1 e8 0c             	shr    $0xc,%eax
  801d13:	c7 04 85 40 30 80 00 	movl   $0x0,0x803040(,%eax,4)
  801d1a:	00 00 00 00 
						0;

				va += PAGE_SIZE;
  801d1e:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
			sys_freeMem((uint32) virtual_address, heap_size[inx].size);

			int i = 0;
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  801d25:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2f:	8b 14 c5 44 30 88 00 	mov    0x883044(,%eax,8),%edx
  801d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d39:	39 c2                	cmp    %eax,%edx
  801d3b:	77 cb                	ja     801d08 <free+0x7d>

				va += PAGE_SIZE;

			}

			heap_size[inx].size = 0;
  801d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d40:	c7 04 c5 44 30 88 00 	movl   $0x0,0x883044(,%eax,8)
  801d47:	00 00 00 00 
			heap_size[inx].vir = NULL;
  801d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4e:	c7 04 c5 40 30 88 00 	movl   $0x0,0x883040(,%eax,8)
  801d55:	00 00 00 00 
			break;
  801d59:	eb 11                	jmp    801d6c <free+0xe1>
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
	for (; inx < cnt_mem; inx++) {
  801d5b:	ff 45 f4             	incl   -0xc(%ebp)
  801d5e:	a1 20 30 80 00       	mov    0x803020,%eax
  801d63:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801d66:	0f 8c 31 ff ff ff    	jl     801c9d <free+0x12>
	}

	//get the size of the given allocation using its address
	//you need to call sys_freeMem()

}
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    

00801d6e <realloc>:
//  Hint: you may need to use the sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size) {
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
  801d71:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2016 - BONUS4] realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801d74:	83 ec 04             	sub    $0x4,%esp
  801d77:	68 10 2a 80 00       	push   $0x802a10
  801d7c:	68 1c 02 00 00       	push   $0x21c
  801d81:	68 36 2a 80 00       	push   $0x802a36
  801d86:	e8 b0 e6 ff ff       	call   80043b <_panic>

00801d8b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
  801d8e:	57                   	push   %edi
  801d8f:	56                   	push   %esi
  801d90:	53                   	push   %ebx
  801d91:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d94:	8b 45 08             	mov    0x8(%ebp),%eax
  801d97:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d9d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801da0:	8b 7d 18             	mov    0x18(%ebp),%edi
  801da3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801da6:	cd 30                	int    $0x30
  801da8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801dab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801dae:	83 c4 10             	add    $0x10,%esp
  801db1:	5b                   	pop    %ebx
  801db2:	5e                   	pop    %esi
  801db3:	5f                   	pop    %edi
  801db4:	5d                   	pop    %ebp
  801db5:	c3                   	ret    

00801db6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  801db9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	ff 75 0c             	pushl  0xc(%ebp)
  801dc5:	50                   	push   %eax
  801dc6:	6a 00                	push   $0x0
  801dc8:	e8 be ff ff ff       	call   801d8b <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
}
  801dd0:	90                   	nop
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <sys_cgetc>:

int
sys_cgetc(void)
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 01                	push   $0x1
  801de2:	e8 a4 ff ff ff       	call   801d8b <syscall>
  801de7:	83 c4 18             	add    $0x18,%esp
}
  801dea:	c9                   	leave  
  801deb:	c3                   	ret    

00801dec <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801def:	8b 45 08             	mov    0x8(%ebp),%eax
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	50                   	push   %eax
  801dfb:	6a 03                	push   $0x3
  801dfd:	e8 89 ff ff ff       	call   801d8b <syscall>
  801e02:	83 c4 18             	add    $0x18,%esp
}
  801e05:	c9                   	leave  
  801e06:	c3                   	ret    

00801e07 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 02                	push   $0x2
  801e16:	e8 70 ff ff ff       	call   801d8b <syscall>
  801e1b:	83 c4 18             	add    $0x18,%esp
}
  801e1e:	c9                   	leave  
  801e1f:	c3                   	ret    

00801e20 <sys_env_exit>:

void sys_env_exit(void)
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 04                	push   $0x4
  801e2f:	e8 57 ff ff ff       	call   801d8b <syscall>
  801e34:	83 c4 18             	add    $0x18,%esp
}
  801e37:	90                   	nop
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801e3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e40:	8b 45 08             	mov    0x8(%ebp),%eax
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	52                   	push   %edx
  801e4a:	50                   	push   %eax
  801e4b:	6a 05                	push   $0x5
  801e4d:	e8 39 ff ff ff       	call   801d8b <syscall>
  801e52:	83 c4 18             	add    $0x18,%esp
}
  801e55:	c9                   	leave  
  801e56:	c3                   	ret    

00801e57 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
  801e5a:	56                   	push   %esi
  801e5b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801e5c:	8b 75 18             	mov    0x18(%ebp),%esi
  801e5f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e62:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e68:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6b:	56                   	push   %esi
  801e6c:	53                   	push   %ebx
  801e6d:	51                   	push   %ecx
  801e6e:	52                   	push   %edx
  801e6f:	50                   	push   %eax
  801e70:	6a 06                	push   $0x6
  801e72:	e8 14 ff ff ff       	call   801d8b <syscall>
  801e77:	83 c4 18             	add    $0x18,%esp
}
  801e7a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e7d:	5b                   	pop    %ebx
  801e7e:	5e                   	pop    %esi
  801e7f:	5d                   	pop    %ebp
  801e80:	c3                   	ret    

00801e81 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801e84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e87:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	52                   	push   %edx
  801e91:	50                   	push   %eax
  801e92:	6a 07                	push   $0x7
  801e94:	e8 f2 fe ff ff       	call   801d8b <syscall>
  801e99:	83 c4 18             	add    $0x18,%esp
}
  801e9c:	c9                   	leave  
  801e9d:	c3                   	ret    

00801e9e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e9e:	55                   	push   %ebp
  801e9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	ff 75 0c             	pushl  0xc(%ebp)
  801eaa:	ff 75 08             	pushl  0x8(%ebp)
  801ead:	6a 08                	push   $0x8
  801eaf:	e8 d7 fe ff ff       	call   801d8b <syscall>
  801eb4:	83 c4 18             	add    $0x18,%esp
}
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 09                	push   $0x9
  801ec8:	e8 be fe ff ff       	call   801d8b <syscall>
  801ecd:	83 c4 18             	add    $0x18,%esp
}
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	6a 0a                	push   $0xa
  801ee1:	e8 a5 fe ff ff       	call   801d8b <syscall>
  801ee6:	83 c4 18             	add    $0x18,%esp
}
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    

00801eeb <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 0b                	push   $0xb
  801efa:	e8 8c fe ff ff       	call   801d8b <syscall>
  801eff:	83 c4 18             	add    $0x18,%esp
}
  801f02:	c9                   	leave  
  801f03:	c3                   	ret    

00801f04 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801f04:	55                   	push   %ebp
  801f05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	ff 75 0c             	pushl  0xc(%ebp)
  801f10:	ff 75 08             	pushl  0x8(%ebp)
  801f13:	6a 0d                	push   $0xd
  801f15:	e8 71 fe ff ff       	call   801d8b <syscall>
  801f1a:	83 c4 18             	add    $0x18,%esp
	return;
  801f1d:	90                   	nop
}
  801f1e:	c9                   	leave  
  801f1f:	c3                   	ret    

00801f20 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	ff 75 0c             	pushl  0xc(%ebp)
  801f2c:	ff 75 08             	pushl  0x8(%ebp)
  801f2f:	6a 0e                	push   $0xe
  801f31:	e8 55 fe ff ff       	call   801d8b <syscall>
  801f36:	83 c4 18             	add    $0x18,%esp
	return ;
  801f39:	90                   	nop
}
  801f3a:	c9                   	leave  
  801f3b:	c3                   	ret    

00801f3c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	6a 00                	push   $0x0
  801f45:	6a 00                	push   $0x0
  801f47:	6a 00                	push   $0x0
  801f49:	6a 0c                	push   $0xc
  801f4b:	e8 3b fe ff ff       	call   801d8b <syscall>
  801f50:	83 c4 18             	add    $0x18,%esp
}
  801f53:	c9                   	leave  
  801f54:	c3                   	ret    

00801f55 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801f55:	55                   	push   %ebp
  801f56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	6a 10                	push   $0x10
  801f64:	e8 22 fe ff ff       	call   801d8b <syscall>
  801f69:	83 c4 18             	add    $0x18,%esp
}
  801f6c:	90                   	nop
  801f6d:	c9                   	leave  
  801f6e:	c3                   	ret    

00801f6f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801f72:	6a 00                	push   $0x0
  801f74:	6a 00                	push   $0x0
  801f76:	6a 00                	push   $0x0
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 11                	push   $0x11
  801f7e:	e8 08 fe ff ff       	call   801d8b <syscall>
  801f83:	83 c4 18             	add    $0x18,%esp
}
  801f86:	90                   	nop
  801f87:	c9                   	leave  
  801f88:	c3                   	ret    

00801f89 <sys_cputc>:


void
sys_cputc(const char c)
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
  801f8c:	83 ec 04             	sub    $0x4,%esp
  801f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f92:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f95:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	50                   	push   %eax
  801fa2:	6a 12                	push   $0x12
  801fa4:	e8 e2 fd ff ff       	call   801d8b <syscall>
  801fa9:	83 c4 18             	add    $0x18,%esp
}
  801fac:	90                   	nop
  801fad:	c9                   	leave  
  801fae:	c3                   	ret    

00801faf <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 13                	push   $0x13
  801fbe:	e8 c8 fd ff ff       	call   801d8b <syscall>
  801fc3:	83 c4 18             	add    $0x18,%esp
}
  801fc6:	90                   	nop
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	ff 75 0c             	pushl  0xc(%ebp)
  801fd8:	50                   	push   %eax
  801fd9:	6a 14                	push   $0x14
  801fdb:	e8 ab fd ff ff       	call   801d8b <syscall>
  801fe0:	83 c4 18             	add    $0x18,%esp
}
  801fe3:	c9                   	leave  
  801fe4:	c3                   	ret    

00801fe5 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  801fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	50                   	push   %eax
  801ff4:	6a 17                	push   $0x17
  801ff6:	e8 90 fd ff ff       	call   801d8b <syscall>
  801ffb:	83 c4 18             	add    $0x18,%esp
}
  801ffe:	c9                   	leave  
  801fff:	c3                   	ret    

00802000 <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  802003:	8b 45 08             	mov    0x8(%ebp),%eax
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	50                   	push   %eax
  80200f:	6a 15                	push   $0x15
  802011:	e8 75 fd ff ff       	call   801d8b <syscall>
  802016:	83 c4 18             	add    $0x18,%esp
}
  802019:	90                   	nop
  80201a:	c9                   	leave  
  80201b:	c3                   	ret    

0080201c <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  80201f:	8b 45 08             	mov    0x8(%ebp),%eax
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	50                   	push   %eax
  80202b:	6a 16                	push   $0x16
  80202d:	e8 59 fd ff ff       	call   801d8b <syscall>
  802032:	83 c4 18             	add    $0x18,%esp
}
  802035:	90                   	nop
  802036:	c9                   	leave  
  802037:	c3                   	ret    

00802038 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  802038:	55                   	push   %ebp
  802039:	89 e5                	mov    %esp,%ebp
  80203b:	83 ec 04             	sub    $0x4,%esp
  80203e:	8b 45 10             	mov    0x10(%ebp),%eax
  802041:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  802044:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802047:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80204b:	8b 45 08             	mov    0x8(%ebp),%eax
  80204e:	6a 00                	push   $0x0
  802050:	51                   	push   %ecx
  802051:	52                   	push   %edx
  802052:	ff 75 0c             	pushl  0xc(%ebp)
  802055:	50                   	push   %eax
  802056:	6a 18                	push   $0x18
  802058:	e8 2e fd ff ff       	call   801d8b <syscall>
  80205d:	83 c4 18             	add    $0x18,%esp
}
  802060:	c9                   	leave  
  802061:	c3                   	ret    

00802062 <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  802062:	55                   	push   %ebp
  802063:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  802065:	8b 55 0c             	mov    0xc(%ebp),%edx
  802068:	8b 45 08             	mov    0x8(%ebp),%eax
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	52                   	push   %edx
  802072:	50                   	push   %eax
  802073:	6a 19                	push   $0x19
  802075:	e8 11 fd ff ff       	call   801d8b <syscall>
  80207a:	83 c4 18             	add    $0x18,%esp
}
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    

0080207f <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  802082:	8b 45 08             	mov    0x8(%ebp),%eax
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	50                   	push   %eax
  80208e:	6a 1a                	push   $0x1a
  802090:	e8 f6 fc ff ff       	call   801d8b <syscall>
  802095:	83 c4 18             	add    $0x18,%esp
}
  802098:	c9                   	leave  
  802099:	c3                   	ret    

0080209a <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 1b                	push   $0x1b
  8020a9:	e8 dd fc ff ff       	call   801d8b <syscall>
  8020ae:	83 c4 18             	add    $0x18,%esp
}
  8020b1:	c9                   	leave  
  8020b2:	c3                   	ret    

008020b3 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 1c                	push   $0x1c
  8020c2:	e8 c4 fc ff ff       	call   801d8b <syscall>
  8020c7:	83 c4 18             	add    $0x18,%esp
}
  8020ca:	c9                   	leave  
  8020cb:	c3                   	ret    

008020cc <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  8020cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	ff 75 0c             	pushl  0xc(%ebp)
  8020db:	50                   	push   %eax
  8020dc:	6a 1d                	push   $0x1d
  8020de:	e8 a8 fc ff ff       	call   801d8b <syscall>
  8020e3:	83 c4 18             	add    $0x18,%esp
}
  8020e6:	c9                   	leave  
  8020e7:	c3                   	ret    

008020e8 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8020e8:	55                   	push   %ebp
  8020e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8020eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ee:	6a 00                	push   $0x0
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	50                   	push   %eax
  8020f7:	6a 1e                	push   $0x1e
  8020f9:	e8 8d fc ff ff       	call   801d8b <syscall>
  8020fe:	83 c4 18             	add    $0x18,%esp
}
  802101:	90                   	nop
  802102:	c9                   	leave  
  802103:	c3                   	ret    

00802104 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  802107:	8b 45 08             	mov    0x8(%ebp),%eax
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	50                   	push   %eax
  802113:	6a 1f                	push   $0x1f
  802115:	e8 71 fc ff ff       	call   801d8b <syscall>
  80211a:	83 c4 18             	add    $0x18,%esp
}
  80211d:	90                   	nop
  80211e:	c9                   	leave  
  80211f:	c3                   	ret    

00802120 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  802120:	55                   	push   %ebp
  802121:	89 e5                	mov    %esp,%ebp
  802123:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802126:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802129:	8d 50 04             	lea    0x4(%eax),%edx
  80212c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	52                   	push   %edx
  802136:	50                   	push   %eax
  802137:	6a 20                	push   $0x20
  802139:	e8 4d fc ff ff       	call   801d8b <syscall>
  80213e:	83 c4 18             	add    $0x18,%esp
	return result;
  802141:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802144:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802147:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80214a:	89 01                	mov    %eax,(%ecx)
  80214c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80214f:	8b 45 08             	mov    0x8(%ebp),%eax
  802152:	c9                   	leave  
  802153:	c2 04 00             	ret    $0x4

00802156 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802156:	55                   	push   %ebp
  802157:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802159:	6a 00                	push   $0x0
  80215b:	6a 00                	push   $0x0
  80215d:	ff 75 10             	pushl  0x10(%ebp)
  802160:	ff 75 0c             	pushl  0xc(%ebp)
  802163:	ff 75 08             	pushl  0x8(%ebp)
  802166:	6a 0f                	push   $0xf
  802168:	e8 1e fc ff ff       	call   801d8b <syscall>
  80216d:	83 c4 18             	add    $0x18,%esp
	return ;
  802170:	90                   	nop
}
  802171:	c9                   	leave  
  802172:	c3                   	ret    

00802173 <sys_rcr2>:
uint32 sys_rcr2()
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 21                	push   $0x21
  802182:	e8 04 fc ff ff       	call   801d8b <syscall>
  802187:	83 c4 18             	add    $0x18,%esp
}
  80218a:	c9                   	leave  
  80218b:	c3                   	ret    

0080218c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
  80218f:	83 ec 04             	sub    $0x4,%esp
  802192:	8b 45 08             	mov    0x8(%ebp),%eax
  802195:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802198:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80219c:	6a 00                	push   $0x0
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 00                	push   $0x0
  8021a2:	6a 00                	push   $0x0
  8021a4:	50                   	push   %eax
  8021a5:	6a 22                	push   $0x22
  8021a7:	e8 df fb ff ff       	call   801d8b <syscall>
  8021ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8021af:	90                   	nop
}
  8021b0:	c9                   	leave  
  8021b1:	c3                   	ret    

008021b2 <rsttst>:
void rsttst()
{
  8021b2:	55                   	push   %ebp
  8021b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8021b5:	6a 00                	push   $0x0
  8021b7:	6a 00                	push   $0x0
  8021b9:	6a 00                	push   $0x0
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 24                	push   $0x24
  8021c1:	e8 c5 fb ff ff       	call   801d8b <syscall>
  8021c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8021c9:	90                   	nop
}
  8021ca:	c9                   	leave  
  8021cb:	c3                   	ret    

008021cc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8021cc:	55                   	push   %ebp
  8021cd:	89 e5                	mov    %esp,%ebp
  8021cf:	83 ec 04             	sub    $0x4,%esp
  8021d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8021d5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8021d8:	8b 55 18             	mov    0x18(%ebp),%edx
  8021db:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021df:	52                   	push   %edx
  8021e0:	50                   	push   %eax
  8021e1:	ff 75 10             	pushl  0x10(%ebp)
  8021e4:	ff 75 0c             	pushl  0xc(%ebp)
  8021e7:	ff 75 08             	pushl  0x8(%ebp)
  8021ea:	6a 23                	push   $0x23
  8021ec:	e8 9a fb ff ff       	call   801d8b <syscall>
  8021f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8021f4:	90                   	nop
}
  8021f5:	c9                   	leave  
  8021f6:	c3                   	ret    

008021f7 <chktst>:
void chktst(uint32 n)
{
  8021f7:	55                   	push   %ebp
  8021f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8021fa:	6a 00                	push   $0x0
  8021fc:	6a 00                	push   $0x0
  8021fe:	6a 00                	push   $0x0
  802200:	6a 00                	push   $0x0
  802202:	ff 75 08             	pushl  0x8(%ebp)
  802205:	6a 25                	push   $0x25
  802207:	e8 7f fb ff ff       	call   801d8b <syscall>
  80220c:	83 c4 18             	add    $0x18,%esp
	return ;
  80220f:	90                   	nop
}
  802210:	c9                   	leave  
  802211:	c3                   	ret    

00802212 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
  802215:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	6a 26                	push   $0x26
  802224:	e8 62 fb ff ff       	call   801d8b <syscall>
  802229:	83 c4 18             	add    $0x18,%esp
  80222c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80222f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802233:	75 07                	jne    80223c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802235:	b8 01 00 00 00       	mov    $0x1,%eax
  80223a:	eb 05                	jmp    802241 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80223c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802241:	c9                   	leave  
  802242:	c3                   	ret    

00802243 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802243:	55                   	push   %ebp
  802244:	89 e5                	mov    %esp,%ebp
  802246:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 26                	push   $0x26
  802255:	e8 31 fb ff ff       	call   801d8b <syscall>
  80225a:	83 c4 18             	add    $0x18,%esp
  80225d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802260:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802264:	75 07                	jne    80226d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802266:	b8 01 00 00 00       	mov    $0x1,%eax
  80226b:	eb 05                	jmp    802272 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80226d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802272:	c9                   	leave  
  802273:	c3                   	ret    

00802274 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
  802277:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 26                	push   $0x26
  802286:	e8 00 fb ff ff       	call   801d8b <syscall>
  80228b:	83 c4 18             	add    $0x18,%esp
  80228e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802291:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802295:	75 07                	jne    80229e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802297:	b8 01 00 00 00       	mov    $0x1,%eax
  80229c:	eb 05                	jmp    8022a3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80229e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022a3:	c9                   	leave  
  8022a4:	c3                   	ret    

008022a5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8022a5:	55                   	push   %ebp
  8022a6:	89 e5                	mov    %esp,%ebp
  8022a8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 00                	push   $0x0
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 26                	push   $0x26
  8022b7:	e8 cf fa ff ff       	call   801d8b <syscall>
  8022bc:	83 c4 18             	add    $0x18,%esp
  8022bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8022c2:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8022c6:	75 07                	jne    8022cf <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8022c8:	b8 01 00 00 00       	mov    $0x1,%eax
  8022cd:	eb 05                	jmp    8022d4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8022cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022d4:	c9                   	leave  
  8022d5:	c3                   	ret    

008022d6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 00                	push   $0x0
  8022e1:	ff 75 08             	pushl  0x8(%ebp)
  8022e4:	6a 27                	push   $0x27
  8022e6:	e8 a0 fa ff ff       	call   801d8b <syscall>
  8022eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8022ee:	90                   	nop
}
  8022ef:	c9                   	leave  
  8022f0:	c3                   	ret    
  8022f1:	66 90                	xchg   %ax,%ax
  8022f3:	90                   	nop

008022f4 <__udivdi3>:
  8022f4:	55                   	push   %ebp
  8022f5:	57                   	push   %edi
  8022f6:	56                   	push   %esi
  8022f7:	53                   	push   %ebx
  8022f8:	83 ec 1c             	sub    $0x1c,%esp
  8022fb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8022ff:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802303:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802307:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80230b:	89 ca                	mov    %ecx,%edx
  80230d:	89 f8                	mov    %edi,%eax
  80230f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802313:	85 f6                	test   %esi,%esi
  802315:	75 2d                	jne    802344 <__udivdi3+0x50>
  802317:	39 cf                	cmp    %ecx,%edi
  802319:	77 65                	ja     802380 <__udivdi3+0x8c>
  80231b:	89 fd                	mov    %edi,%ebp
  80231d:	85 ff                	test   %edi,%edi
  80231f:	75 0b                	jne    80232c <__udivdi3+0x38>
  802321:	b8 01 00 00 00       	mov    $0x1,%eax
  802326:	31 d2                	xor    %edx,%edx
  802328:	f7 f7                	div    %edi
  80232a:	89 c5                	mov    %eax,%ebp
  80232c:	31 d2                	xor    %edx,%edx
  80232e:	89 c8                	mov    %ecx,%eax
  802330:	f7 f5                	div    %ebp
  802332:	89 c1                	mov    %eax,%ecx
  802334:	89 d8                	mov    %ebx,%eax
  802336:	f7 f5                	div    %ebp
  802338:	89 cf                	mov    %ecx,%edi
  80233a:	89 fa                	mov    %edi,%edx
  80233c:	83 c4 1c             	add    $0x1c,%esp
  80233f:	5b                   	pop    %ebx
  802340:	5e                   	pop    %esi
  802341:	5f                   	pop    %edi
  802342:	5d                   	pop    %ebp
  802343:	c3                   	ret    
  802344:	39 ce                	cmp    %ecx,%esi
  802346:	77 28                	ja     802370 <__udivdi3+0x7c>
  802348:	0f bd fe             	bsr    %esi,%edi
  80234b:	83 f7 1f             	xor    $0x1f,%edi
  80234e:	75 40                	jne    802390 <__udivdi3+0x9c>
  802350:	39 ce                	cmp    %ecx,%esi
  802352:	72 0a                	jb     80235e <__udivdi3+0x6a>
  802354:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802358:	0f 87 9e 00 00 00    	ja     8023fc <__udivdi3+0x108>
  80235e:	b8 01 00 00 00       	mov    $0x1,%eax
  802363:	89 fa                	mov    %edi,%edx
  802365:	83 c4 1c             	add    $0x1c,%esp
  802368:	5b                   	pop    %ebx
  802369:	5e                   	pop    %esi
  80236a:	5f                   	pop    %edi
  80236b:	5d                   	pop    %ebp
  80236c:	c3                   	ret    
  80236d:	8d 76 00             	lea    0x0(%esi),%esi
  802370:	31 ff                	xor    %edi,%edi
  802372:	31 c0                	xor    %eax,%eax
  802374:	89 fa                	mov    %edi,%edx
  802376:	83 c4 1c             	add    $0x1c,%esp
  802379:	5b                   	pop    %ebx
  80237a:	5e                   	pop    %esi
  80237b:	5f                   	pop    %edi
  80237c:	5d                   	pop    %ebp
  80237d:	c3                   	ret    
  80237e:	66 90                	xchg   %ax,%ax
  802380:	89 d8                	mov    %ebx,%eax
  802382:	f7 f7                	div    %edi
  802384:	31 ff                	xor    %edi,%edi
  802386:	89 fa                	mov    %edi,%edx
  802388:	83 c4 1c             	add    $0x1c,%esp
  80238b:	5b                   	pop    %ebx
  80238c:	5e                   	pop    %esi
  80238d:	5f                   	pop    %edi
  80238e:	5d                   	pop    %ebp
  80238f:	c3                   	ret    
  802390:	bd 20 00 00 00       	mov    $0x20,%ebp
  802395:	89 eb                	mov    %ebp,%ebx
  802397:	29 fb                	sub    %edi,%ebx
  802399:	89 f9                	mov    %edi,%ecx
  80239b:	d3 e6                	shl    %cl,%esi
  80239d:	89 c5                	mov    %eax,%ebp
  80239f:	88 d9                	mov    %bl,%cl
  8023a1:	d3 ed                	shr    %cl,%ebp
  8023a3:	89 e9                	mov    %ebp,%ecx
  8023a5:	09 f1                	or     %esi,%ecx
  8023a7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8023ab:	89 f9                	mov    %edi,%ecx
  8023ad:	d3 e0                	shl    %cl,%eax
  8023af:	89 c5                	mov    %eax,%ebp
  8023b1:	89 d6                	mov    %edx,%esi
  8023b3:	88 d9                	mov    %bl,%cl
  8023b5:	d3 ee                	shr    %cl,%esi
  8023b7:	89 f9                	mov    %edi,%ecx
  8023b9:	d3 e2                	shl    %cl,%edx
  8023bb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023bf:	88 d9                	mov    %bl,%cl
  8023c1:	d3 e8                	shr    %cl,%eax
  8023c3:	09 c2                	or     %eax,%edx
  8023c5:	89 d0                	mov    %edx,%eax
  8023c7:	89 f2                	mov    %esi,%edx
  8023c9:	f7 74 24 0c          	divl   0xc(%esp)
  8023cd:	89 d6                	mov    %edx,%esi
  8023cf:	89 c3                	mov    %eax,%ebx
  8023d1:	f7 e5                	mul    %ebp
  8023d3:	39 d6                	cmp    %edx,%esi
  8023d5:	72 19                	jb     8023f0 <__udivdi3+0xfc>
  8023d7:	74 0b                	je     8023e4 <__udivdi3+0xf0>
  8023d9:	89 d8                	mov    %ebx,%eax
  8023db:	31 ff                	xor    %edi,%edi
  8023dd:	e9 58 ff ff ff       	jmp    80233a <__udivdi3+0x46>
  8023e2:	66 90                	xchg   %ax,%ax
  8023e4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8023e8:	89 f9                	mov    %edi,%ecx
  8023ea:	d3 e2                	shl    %cl,%edx
  8023ec:	39 c2                	cmp    %eax,%edx
  8023ee:	73 e9                	jae    8023d9 <__udivdi3+0xe5>
  8023f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023f3:	31 ff                	xor    %edi,%edi
  8023f5:	e9 40 ff ff ff       	jmp    80233a <__udivdi3+0x46>
  8023fa:	66 90                	xchg   %ax,%ax
  8023fc:	31 c0                	xor    %eax,%eax
  8023fe:	e9 37 ff ff ff       	jmp    80233a <__udivdi3+0x46>
  802403:	90                   	nop

00802404 <__umoddi3>:
  802404:	55                   	push   %ebp
  802405:	57                   	push   %edi
  802406:	56                   	push   %esi
  802407:	53                   	push   %ebx
  802408:	83 ec 1c             	sub    $0x1c,%esp
  80240b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80240f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802413:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802417:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80241b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80241f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802423:	89 f3                	mov    %esi,%ebx
  802425:	89 fa                	mov    %edi,%edx
  802427:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80242b:	89 34 24             	mov    %esi,(%esp)
  80242e:	85 c0                	test   %eax,%eax
  802430:	75 1a                	jne    80244c <__umoddi3+0x48>
  802432:	39 f7                	cmp    %esi,%edi
  802434:	0f 86 a2 00 00 00    	jbe    8024dc <__umoddi3+0xd8>
  80243a:	89 c8                	mov    %ecx,%eax
  80243c:	89 f2                	mov    %esi,%edx
  80243e:	f7 f7                	div    %edi
  802440:	89 d0                	mov    %edx,%eax
  802442:	31 d2                	xor    %edx,%edx
  802444:	83 c4 1c             	add    $0x1c,%esp
  802447:	5b                   	pop    %ebx
  802448:	5e                   	pop    %esi
  802449:	5f                   	pop    %edi
  80244a:	5d                   	pop    %ebp
  80244b:	c3                   	ret    
  80244c:	39 f0                	cmp    %esi,%eax
  80244e:	0f 87 ac 00 00 00    	ja     802500 <__umoddi3+0xfc>
  802454:	0f bd e8             	bsr    %eax,%ebp
  802457:	83 f5 1f             	xor    $0x1f,%ebp
  80245a:	0f 84 ac 00 00 00    	je     80250c <__umoddi3+0x108>
  802460:	bf 20 00 00 00       	mov    $0x20,%edi
  802465:	29 ef                	sub    %ebp,%edi
  802467:	89 fe                	mov    %edi,%esi
  802469:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80246d:	89 e9                	mov    %ebp,%ecx
  80246f:	d3 e0                	shl    %cl,%eax
  802471:	89 d7                	mov    %edx,%edi
  802473:	89 f1                	mov    %esi,%ecx
  802475:	d3 ef                	shr    %cl,%edi
  802477:	09 c7                	or     %eax,%edi
  802479:	89 e9                	mov    %ebp,%ecx
  80247b:	d3 e2                	shl    %cl,%edx
  80247d:	89 14 24             	mov    %edx,(%esp)
  802480:	89 d8                	mov    %ebx,%eax
  802482:	d3 e0                	shl    %cl,%eax
  802484:	89 c2                	mov    %eax,%edx
  802486:	8b 44 24 08          	mov    0x8(%esp),%eax
  80248a:	d3 e0                	shl    %cl,%eax
  80248c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802490:	8b 44 24 08          	mov    0x8(%esp),%eax
  802494:	89 f1                	mov    %esi,%ecx
  802496:	d3 e8                	shr    %cl,%eax
  802498:	09 d0                	or     %edx,%eax
  80249a:	d3 eb                	shr    %cl,%ebx
  80249c:	89 da                	mov    %ebx,%edx
  80249e:	f7 f7                	div    %edi
  8024a0:	89 d3                	mov    %edx,%ebx
  8024a2:	f7 24 24             	mull   (%esp)
  8024a5:	89 c6                	mov    %eax,%esi
  8024a7:	89 d1                	mov    %edx,%ecx
  8024a9:	39 d3                	cmp    %edx,%ebx
  8024ab:	0f 82 87 00 00 00    	jb     802538 <__umoddi3+0x134>
  8024b1:	0f 84 91 00 00 00    	je     802548 <__umoddi3+0x144>
  8024b7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024bb:	29 f2                	sub    %esi,%edx
  8024bd:	19 cb                	sbb    %ecx,%ebx
  8024bf:	89 d8                	mov    %ebx,%eax
  8024c1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8024c5:	d3 e0                	shl    %cl,%eax
  8024c7:	89 e9                	mov    %ebp,%ecx
  8024c9:	d3 ea                	shr    %cl,%edx
  8024cb:	09 d0                	or     %edx,%eax
  8024cd:	89 e9                	mov    %ebp,%ecx
  8024cf:	d3 eb                	shr    %cl,%ebx
  8024d1:	89 da                	mov    %ebx,%edx
  8024d3:	83 c4 1c             	add    $0x1c,%esp
  8024d6:	5b                   	pop    %ebx
  8024d7:	5e                   	pop    %esi
  8024d8:	5f                   	pop    %edi
  8024d9:	5d                   	pop    %ebp
  8024da:	c3                   	ret    
  8024db:	90                   	nop
  8024dc:	89 fd                	mov    %edi,%ebp
  8024de:	85 ff                	test   %edi,%edi
  8024e0:	75 0b                	jne    8024ed <__umoddi3+0xe9>
  8024e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8024e7:	31 d2                	xor    %edx,%edx
  8024e9:	f7 f7                	div    %edi
  8024eb:	89 c5                	mov    %eax,%ebp
  8024ed:	89 f0                	mov    %esi,%eax
  8024ef:	31 d2                	xor    %edx,%edx
  8024f1:	f7 f5                	div    %ebp
  8024f3:	89 c8                	mov    %ecx,%eax
  8024f5:	f7 f5                	div    %ebp
  8024f7:	89 d0                	mov    %edx,%eax
  8024f9:	e9 44 ff ff ff       	jmp    802442 <__umoddi3+0x3e>
  8024fe:	66 90                	xchg   %ax,%ax
  802500:	89 c8                	mov    %ecx,%eax
  802502:	89 f2                	mov    %esi,%edx
  802504:	83 c4 1c             	add    $0x1c,%esp
  802507:	5b                   	pop    %ebx
  802508:	5e                   	pop    %esi
  802509:	5f                   	pop    %edi
  80250a:	5d                   	pop    %ebp
  80250b:	c3                   	ret    
  80250c:	3b 04 24             	cmp    (%esp),%eax
  80250f:	72 06                	jb     802517 <__umoddi3+0x113>
  802511:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802515:	77 0f                	ja     802526 <__umoddi3+0x122>
  802517:	89 f2                	mov    %esi,%edx
  802519:	29 f9                	sub    %edi,%ecx
  80251b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80251f:	89 14 24             	mov    %edx,(%esp)
  802522:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802526:	8b 44 24 04          	mov    0x4(%esp),%eax
  80252a:	8b 14 24             	mov    (%esp),%edx
  80252d:	83 c4 1c             	add    $0x1c,%esp
  802530:	5b                   	pop    %ebx
  802531:	5e                   	pop    %esi
  802532:	5f                   	pop    %edi
  802533:	5d                   	pop    %ebp
  802534:	c3                   	ret    
  802535:	8d 76 00             	lea    0x0(%esi),%esi
  802538:	2b 04 24             	sub    (%esp),%eax
  80253b:	19 fa                	sbb    %edi,%edx
  80253d:	89 d1                	mov    %edx,%ecx
  80253f:	89 c6                	mov    %eax,%esi
  802541:	e9 71 ff ff ff       	jmp    8024b7 <__umoddi3+0xb3>
  802546:	66 90                	xchg   %ax,%ax
  802548:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80254c:	72 ea                	jb     802538 <__umoddi3+0x134>
  80254e:	89 d9                	mov    %ebx,%ecx
  802550:	e9 62 ff ff ff       	jmp    8024b7 <__umoddi3+0xb3>
