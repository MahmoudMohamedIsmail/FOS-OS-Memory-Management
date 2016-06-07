
obj/user/tst_placement:     file format elf32-i386


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
  800031:	e8 c4 09 00 00       	call   8009fa <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec a4 00 00 01    	sub    $0x10000a4,%esp
	int envID = sys_getenvid();
  800042:	e8 9e 19 00 00       	call   8019e5 <sys_getenvid>
  800047:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf("envID = %d\n",envID);
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  80004a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80004d:	89 d0                	mov    %edx,%eax
  80004f:	c1 e0 03             	shl    $0x3,%eax
  800052:	01 d0                	add    %edx,%eax
  800054:	01 c0                	add    %eax,%eax
  800056:	01 d0                	add    %edx,%eax
  800058:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80005f:	01 d0                	add    %edx,%eax
  800061:	c1 e0 03             	shl    $0x3,%eax
  800064:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800069:	89 45 ec             	mov    %eax,-0x14(%ebp)

	char arr[PAGE_SIZE*1024*4];

	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80006c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80006f:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800075:	8b 00                	mov    (%eax),%eax
  800077:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80007a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80007d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800082:	3d 00 00 20 00       	cmp    $0x200000,%eax
  800087:	74 14                	je     80009d <_main+0x65>
  800089:	83 ec 04             	sub    $0x4,%esp
  80008c:	68 40 21 80 00       	push   $0x802140
  800091:	6a 12                	push   $0x12
  800093:	68 81 21 80 00       	push   $0x802181
  800098:	e8 1e 0a 00 00       	call   800abb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80009d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000a0:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8000a6:	83 c0 0c             	add    $0xc,%eax
  8000a9:	8b 00                	mov    (%eax),%eax
  8000ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000b1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000b6:	3d 00 10 20 00       	cmp    $0x201000,%eax
  8000bb:	74 14                	je     8000d1 <_main+0x99>
  8000bd:	83 ec 04             	sub    $0x4,%esp
  8000c0:	68 40 21 80 00       	push   $0x802140
  8000c5:	6a 13                	push   $0x13
  8000c7:	68 81 21 80 00       	push   $0x802181
  8000cc:	e8 ea 09 00 00       	call   800abb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000d4:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8000da:	83 c0 18             	add    $0x18,%eax
  8000dd:	8b 00                	mov    (%eax),%eax
  8000df:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8000e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000e5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000ea:	3d 00 20 20 00       	cmp    $0x202000,%eax
  8000ef:	74 14                	je     800105 <_main+0xcd>
  8000f1:	83 ec 04             	sub    $0x4,%esp
  8000f4:	68 40 21 80 00       	push   $0x802140
  8000f9:	6a 14                	push   $0x14
  8000fb:	68 81 21 80 00       	push   $0x802181
  800100:	e8 b6 09 00 00       	call   800abb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800105:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800108:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  80010e:	83 c0 24             	add    $0x24,%eax
  800111:	8b 00                	mov    (%eax),%eax
  800113:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800116:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800119:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80011e:	3d 00 30 20 00       	cmp    $0x203000,%eax
  800123:	74 14                	je     800139 <_main+0x101>
  800125:	83 ec 04             	sub    $0x4,%esp
  800128:	68 40 21 80 00       	push   $0x802140
  80012d:	6a 15                	push   $0x15
  80012f:	68 81 21 80 00       	push   $0x802181
  800134:	e8 82 09 00 00       	call   800abb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800139:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80013c:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800142:	83 c0 30             	add    $0x30,%eax
  800145:	8b 00                	mov    (%eax),%eax
  800147:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80014a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80014d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800152:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800157:	74 14                	je     80016d <_main+0x135>
  800159:	83 ec 04             	sub    $0x4,%esp
  80015c:	68 40 21 80 00       	push   $0x802140
  800161:	6a 16                	push   $0x16
  800163:	68 81 21 80 00       	push   $0x802181
  800168:	e8 4e 09 00 00       	call   800abb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80016d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800170:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800176:	83 c0 3c             	add    $0x3c,%eax
  800179:	8b 00                	mov    (%eax),%eax
  80017b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80017e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800181:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800186:	3d 00 50 20 00       	cmp    $0x205000,%eax
  80018b:	74 14                	je     8001a1 <_main+0x169>
  80018d:	83 ec 04             	sub    $0x4,%esp
  800190:	68 40 21 80 00       	push   $0x802140
  800195:	6a 17                	push   $0x17
  800197:	68 81 21 80 00       	push   $0x802181
  80019c:	e8 1a 09 00 00       	call   800abb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x206000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001a4:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8001aa:	83 c0 48             	add    $0x48,%eax
  8001ad:	8b 00                	mov    (%eax),%eax
  8001af:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8001b2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001b5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001ba:	3d 00 60 20 00       	cmp    $0x206000,%eax
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 40 21 80 00       	push   $0x802140
  8001c9:	6a 18                	push   $0x18
  8001cb:	68 81 21 80 00       	push   $0x802181
  8001d0:	e8 e6 08 00 00       	call   800abb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001d8:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8001de:	83 c0 54             	add    $0x54,%eax
  8001e1:	8b 00                	mov    (%eax),%eax
  8001e3:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8001e6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001ee:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001f3:	74 14                	je     800209 <_main+0x1d1>
  8001f5:	83 ec 04             	sub    $0x4,%esp
  8001f8:	68 40 21 80 00       	push   $0x802140
  8001fd:	6a 19                	push   $0x19
  8001ff:	68 81 21 80 00       	push   $0x802181
  800204:	e8 b2 08 00 00       	call   800abb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800209:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80020c:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800212:	83 c0 60             	add    $0x60,%eax
  800215:	8b 00                	mov    (%eax),%eax
  800217:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80021a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80021d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800222:	3d 00 10 80 00       	cmp    $0x801000,%eax
  800227:	74 14                	je     80023d <_main+0x205>
  800229:	83 ec 04             	sub    $0x4,%esp
  80022c:	68 40 21 80 00       	push   $0x802140
  800231:	6a 1a                	push   $0x1a
  800233:	68 81 21 80 00       	push   $0x802181
  800238:	e8 7e 08 00 00       	call   800abb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80023d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800240:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800246:	83 c0 6c             	add    $0x6c,%eax
  800249:	8b 00                	mov    (%eax),%eax
  80024b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80024e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800251:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800256:	3d 00 20 80 00       	cmp    $0x802000,%eax
  80025b:	74 14                	je     800271 <_main+0x239>
  80025d:	83 ec 04             	sub    $0x4,%esp
  800260:	68 40 21 80 00       	push   $0x802140
  800265:	6a 1b                	push   $0x1b
  800267:	68 81 21 80 00       	push   $0x802181
  80026c:	e8 4a 08 00 00       	call   800abb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800271:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800274:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  80027a:	83 c0 78             	add    $0x78,%eax
  80027d:	8b 00                	mov    (%eax),%eax
  80027f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800282:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800285:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80028a:	3d 00 30 80 00       	cmp    $0x803000,%eax
  80028f:	74 14                	je     8002a5 <_main+0x26d>
  800291:	83 ec 04             	sub    $0x4,%esp
  800294:	68 40 21 80 00       	push   $0x802140
  800299:	6a 1c                	push   $0x1c
  80029b:	68 81 21 80 00       	push   $0x802181
  8002a0:	e8 16 08 00 00       	call   800abb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[11].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8002a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002a8:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8002ae:	05 84 00 00 00       	add    $0x84,%eax
  8002b3:	8b 00                	mov    (%eax),%eax
  8002b5:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8002b8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8002bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002c0:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  8002c5:	74 14                	je     8002db <_main+0x2a3>
  8002c7:	83 ec 04             	sub    $0x4,%esp
  8002ca:	68 40 21 80 00       	push   $0x802140
  8002cf:	6a 1d                	push   $0x1d
  8002d1:	68 81 21 80 00       	push   $0x802181
  8002d6:	e8 e0 07 00 00       	call   800abb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[12].virtual_address,PAGE_SIZE) !=   0xedbfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8002db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002de:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8002e4:	05 90 00 00 00       	add    $0x90,%eax
  8002e9:	8b 00                	mov    (%eax),%eax
  8002eb:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8002ee:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8002f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002f6:	3d 00 d0 bf ed       	cmp    $0xedbfd000,%eax
  8002fb:	74 14                	je     800311 <_main+0x2d9>
  8002fd:	83 ec 04             	sub    $0x4,%esp
  800300:	68 40 21 80 00       	push   $0x802140
  800305:	6a 1e                	push   $0x1e
  800307:	68 81 21 80 00       	push   $0x802181
  80030c:	e8 aa 07 00 00       	call   800abb <_panic>
		if( myEnv->__uptr_pws[13].empty !=  1)  										panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800311:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800314:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  80031a:	05 9c 00 00 00       	add    $0x9c,%eax
  80031f:	8a 40 04             	mov    0x4(%eax),%al
  800322:	3c 01                	cmp    $0x1,%al
  800324:	74 14                	je     80033a <_main+0x302>
  800326:	83 ec 04             	sub    $0x4,%esp
  800329:	68 40 21 80 00       	push   $0x802140
  80032e:	6a 1f                	push   $0x1f
  800330:	68 81 21 80 00       	push   $0x802181
  800335:	e8 81 07 00 00       	call   800abb <_panic>
		if( myEnv->page_last_WS_index !=  13)  											panic("INITIAL PAGE last index checking failed! Review size of the WS..!!");
  80033a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80033d:	8b 80 d4 02 00 00    	mov    0x2d4(%eax),%eax
  800343:	83 f8 0d             	cmp    $0xd,%eax
  800346:	74 14                	je     80035c <_main+0x324>
  800348:	83 ec 04             	sub    $0x4,%esp
  80034b:	68 98 21 80 00       	push   $0x802198
  800350:	6a 20                	push   $0x20
  800352:	68 81 21 80 00       	push   $0x802181
  800357:	e8 5f 07 00 00       	call   800abb <_panic>

	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80035c:	e8 b9 17 00 00       	call   801b1a <sys_pf_calculate_allocated_pages>
  800361:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	int freePages = sys_calculate_free_frames();
  800364:	e8 2e 17 00 00       	call   801a97 <sys_calculate_free_frames>
  800369:	89 45 b0             	mov    %eax,-0x50(%ebp)

	int i=0;
  80036c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(;i<=PAGE_SIZE;i++)
  800373:	eb 11                	jmp    800386 <_main+0x34e>
	{
		arr[i] = -1;
  800375:	8d 95 64 ff ff fe    	lea    -0x100009c(%ebp),%edx
  80037b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80037e:	01 d0                	add    %edx,%eax
  800380:	c6 00 ff             	movb   $0xff,(%eax)

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
	int freePages = sys_calculate_free_frames();

	int i=0;
	for(;i<=PAGE_SIZE;i++)
  800383:	ff 45 f4             	incl   -0xc(%ebp)
  800386:	81 7d f4 00 10 00 00 	cmpl   $0x1000,-0xc(%ebp)
  80038d:	7e e6                	jle    800375 <_main+0x33d>
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024;
  80038f:	c7 45 f4 00 00 40 00 	movl   $0x400000,-0xc(%ebp)
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  800396:	eb 11                	jmp    8003a9 <_main+0x371>
	{
		arr[i] = -1;
  800398:	8d 95 64 ff ff fe    	lea    -0x100009c(%ebp),%edx
  80039e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003a1:	01 d0                	add    %edx,%eax
  8003a3:	c6 00 ff             	movb   $0xff,(%eax)
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024;
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  8003a6:	ff 45 f4             	incl   -0xc(%ebp)
  8003a9:	81 7d f4 00 10 40 00 	cmpl   $0x401000,-0xc(%ebp)
  8003b0:	7e e6                	jle    800398 <_main+0x360>
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024*2;
  8003b2:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  8003b9:	eb 11                	jmp    8003cc <_main+0x394>
	{
		arr[i] = -1;
  8003bb:	8d 95 64 ff ff fe    	lea    -0x100009c(%ebp),%edx
  8003c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003c4:	01 d0                	add    %edx,%eax
  8003c6:	c6 00 ff             	movb   $0xff,(%eax)
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024*2;
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  8003c9:	ff 45 f4             	incl   -0xc(%ebp)
  8003cc:	81 7d f4 00 10 80 00 	cmpl   $0x801000,-0xc(%ebp)
  8003d3:	7e e6                	jle    8003bb <_main+0x383>
		arr[i] = -1;
	}



	cprintf("STEP A: checking PLACEMENT fault handling ... \n");
  8003d5:	83 ec 0c             	sub    $0xc,%esp
  8003d8:	68 dc 21 80 00       	push   $0x8021dc
  8003dd:	e8 04 08 00 00       	call   800be6 <cprintf>
  8003e2:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] !=  -1)  panic("PLACEMENT of stack page failed");
  8003e5:	8a 85 64 ff ff fe    	mov    -0x100009c(%ebp),%al
  8003eb:	3c ff                	cmp    $0xff,%al
  8003ed:	74 14                	je     800403 <_main+0x3cb>
  8003ef:	83 ec 04             	sub    $0x4,%esp
  8003f2:	68 0c 22 80 00       	push   $0x80220c
  8003f7:	6a 3d                	push   $0x3d
  8003f9:	68 81 21 80 00       	push   $0x802181
  8003fe:	e8 b8 06 00 00       	call   800abb <_panic>
		if( arr[PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");
  800403:	8a 85 64 0f 00 ff    	mov    -0xfff09c(%ebp),%al
  800409:	3c ff                	cmp    $0xff,%al
  80040b:	74 14                	je     800421 <_main+0x3e9>
  80040d:	83 ec 04             	sub    $0x4,%esp
  800410:	68 0c 22 80 00       	push   $0x80220c
  800415:	6a 3e                	push   $0x3e
  800417:	68 81 21 80 00       	push   $0x802181
  80041c:	e8 9a 06 00 00       	call   800abb <_panic>

		if( arr[PAGE_SIZE*1024] !=  -1)  panic("PLACEMENT of stack page failed");
  800421:	8a 85 64 ff 3f ff    	mov    -0xc0009c(%ebp),%al
  800427:	3c ff                	cmp    $0xff,%al
  800429:	74 14                	je     80043f <_main+0x407>
  80042b:	83 ec 04             	sub    $0x4,%esp
  80042e:	68 0c 22 80 00       	push   $0x80220c
  800433:	6a 40                	push   $0x40
  800435:	68 81 21 80 00       	push   $0x802181
  80043a:	e8 7c 06 00 00       	call   800abb <_panic>
		if( arr[PAGE_SIZE*1025] !=  -1)  panic("PLACEMENT of stack page failed");
  80043f:	8a 85 64 0f 40 ff    	mov    -0xbff09c(%ebp),%al
  800445:	3c ff                	cmp    $0xff,%al
  800447:	74 14                	je     80045d <_main+0x425>
  800449:	83 ec 04             	sub    $0x4,%esp
  80044c:	68 0c 22 80 00       	push   $0x80220c
  800451:	6a 41                	push   $0x41
  800453:	68 81 21 80 00       	push   $0x802181
  800458:	e8 5e 06 00 00       	call   800abb <_panic>

		if( arr[PAGE_SIZE*1024*2] !=  -1)  panic("PLACEMENT of stack page failed");
  80045d:	8a 85 64 ff 7f ff    	mov    -0x80009c(%ebp),%al
  800463:	3c ff                	cmp    $0xff,%al
  800465:	74 14                	je     80047b <_main+0x443>
  800467:	83 ec 04             	sub    $0x4,%esp
  80046a:	68 0c 22 80 00       	push   $0x80220c
  80046f:	6a 43                	push   $0x43
  800471:	68 81 21 80 00       	push   $0x802181
  800476:	e8 40 06 00 00       	call   800abb <_panic>
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");
  80047b:	8a 85 64 0f 80 ff    	mov    -0x7ff09c(%ebp),%al
  800481:	3c ff                	cmp    $0xff,%al
  800483:	74 14                	je     800499 <_main+0x461>
  800485:	83 ec 04             	sub    $0x4,%esp
  800488:	68 0c 22 80 00       	push   $0x80220c
  80048d:	6a 44                	push   $0x44
  80048f:	68 81 21 80 00       	push   $0x802181
  800494:	e8 22 06 00 00       	call   800abb <_panic>


		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5) panic("new stack pages are not written to Page File");
  800499:	e8 7c 16 00 00       	call   801b1a <sys_pf_calculate_allocated_pages>
  80049e:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  8004a1:	83 f8 05             	cmp    $0x5,%eax
  8004a4:	74 14                	je     8004ba <_main+0x482>
  8004a6:	83 ec 04             	sub    $0x4,%esp
  8004a9:	68 2c 22 80 00       	push   $0x80222c
  8004ae:	6a 47                	push   $0x47
  8004b0:	68 81 21 80 00       	push   $0x802181
  8004b5:	e8 01 06 00 00       	call   800abb <_panic>

		if( (freePages - sys_calculate_free_frames() ) != 9 ) panic("allocated memory size incorrect");
  8004ba:	8b 5d b0             	mov    -0x50(%ebp),%ebx
  8004bd:	e8 d5 15 00 00       	call   801a97 <sys_calculate_free_frames>
  8004c2:	29 c3                	sub    %eax,%ebx
  8004c4:	89 d8                	mov    %ebx,%eax
  8004c6:	83 f8 09             	cmp    $0x9,%eax
  8004c9:	74 14                	je     8004df <_main+0x4a7>
  8004cb:	83 ec 04             	sub    $0x4,%esp
  8004ce:	68 5c 22 80 00       	push   $0x80225c
  8004d3:	6a 49                	push   $0x49
  8004d5:	68 81 21 80 00       	push   $0x802181
  8004da:	e8 dc 05 00 00       	call   800abb <_panic>
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");
  8004df:	83 ec 0c             	sub    $0xc,%esp
  8004e2:	68 7c 22 80 00       	push   $0x80227c
  8004e7:	e8 fa 06 00 00       	call   800be6 <cprintf>
  8004ec:	83 c4 10             	add    $0x10,%esp



	cprintf("STEP B: checking WS entries ...\n");
  8004ef:	83 ec 0c             	sub    $0xc,%esp
  8004f2:	68 b0 22 80 00       	push   $0x8022b0
  8004f7:	e8 ea 06 00 00       	call   800be6 <cprintf>
  8004fc:	83 c4 10             	add    $0x10,%esp
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
  8004ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800502:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800508:	8b 00                	mov    (%eax),%eax
  80050a:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80050d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800510:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800515:	3d 00 00 20 00       	cmp    $0x200000,%eax
  80051a:	74 14                	je     800530 <_main+0x4f8>
  80051c:	83 ec 04             	sub    $0x4,%esp
  80051f:	68 d4 22 80 00       	push   $0x8022d4
  800524:	6a 51                	push   $0x51
  800526:	68 81 21 80 00       	push   $0x802181
  80052b:	e8 8b 05 00 00       	call   800abb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
  800530:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800533:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800539:	83 c0 0c             	add    $0xc,%eax
  80053c:	8b 00                	mov    (%eax),%eax
  80053e:	89 45 a8             	mov    %eax,-0x58(%ebp)
  800541:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800544:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800549:	3d 00 10 20 00       	cmp    $0x201000,%eax
  80054e:	74 14                	je     800564 <_main+0x52c>
  800550:	83 ec 04             	sub    $0x4,%esp
  800553:	68 d4 22 80 00       	push   $0x8022d4
  800558:	6a 52                	push   $0x52
  80055a:	68 81 21 80 00       	push   $0x802181
  80055f:	e8 57 05 00 00       	call   800abb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
  800564:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800567:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  80056d:	83 c0 18             	add    $0x18,%eax
  800570:	8b 00                	mov    (%eax),%eax
  800572:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  800575:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800578:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80057d:	3d 00 20 20 00       	cmp    $0x202000,%eax
  800582:	74 14                	je     800598 <_main+0x560>
  800584:	83 ec 04             	sub    $0x4,%esp
  800587:	68 d4 22 80 00       	push   $0x8022d4
  80058c:	6a 53                	push   $0x53
  80058e:	68 81 21 80 00       	push   $0x802181
  800593:	e8 23 05 00 00       	call   800abb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
  800598:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80059b:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8005a1:	83 c0 24             	add    $0x24,%eax
  8005a4:	8b 00                	mov    (%eax),%eax
  8005a6:	89 45 a0             	mov    %eax,-0x60(%ebp)
  8005a9:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8005ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005b1:	3d 00 30 20 00       	cmp    $0x203000,%eax
  8005b6:	74 14                	je     8005cc <_main+0x594>
  8005b8:	83 ec 04             	sub    $0x4,%esp
  8005bb:	68 d4 22 80 00       	push   $0x8022d4
  8005c0:	6a 54                	push   $0x54
  8005c2:	68 81 21 80 00       	push   $0x802181
  8005c7:	e8 ef 04 00 00       	call   800abb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
  8005cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005cf:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8005d5:	83 c0 30             	add    $0x30,%eax
  8005d8:	8b 00                	mov    (%eax),%eax
  8005da:	89 45 9c             	mov    %eax,-0x64(%ebp)
  8005dd:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8005e0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005e5:	3d 00 40 20 00       	cmp    $0x204000,%eax
  8005ea:	74 14                	je     800600 <_main+0x5c8>
  8005ec:	83 ec 04             	sub    $0x4,%esp
  8005ef:	68 d4 22 80 00       	push   $0x8022d4
  8005f4:	6a 55                	push   $0x55
  8005f6:	68 81 21 80 00       	push   $0x802181
  8005fb:	e8 bb 04 00 00       	call   800abb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
  800600:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800603:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800609:	83 c0 3c             	add    $0x3c,%eax
  80060c:	8b 00                	mov    (%eax),%eax
  80060e:	89 45 98             	mov    %eax,-0x68(%ebp)
  800611:	8b 45 98             	mov    -0x68(%ebp),%eax
  800614:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800619:	3d 00 50 20 00       	cmp    $0x205000,%eax
  80061e:	74 14                	je     800634 <_main+0x5fc>
  800620:	83 ec 04             	sub    $0x4,%esp
  800623:	68 d4 22 80 00       	push   $0x8022d4
  800628:	6a 56                	push   $0x56
  80062a:	68 81 21 80 00       	push   $0x802181
  80062f:	e8 87 04 00 00       	call   800abb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x206000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
  800634:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800637:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  80063d:	83 c0 48             	add    $0x48,%eax
  800640:	8b 00                	mov    (%eax),%eax
  800642:	89 45 94             	mov    %eax,-0x6c(%ebp)
  800645:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800648:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80064d:	3d 00 60 20 00       	cmp    $0x206000,%eax
  800652:	74 14                	je     800668 <_main+0x630>
  800654:	83 ec 04             	sub    $0x4,%esp
  800657:	68 d4 22 80 00       	push   $0x8022d4
  80065c:	6a 57                	push   $0x57
  80065e:	68 81 21 80 00       	push   $0x802181
  800663:	e8 53 04 00 00       	call   800abb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x800000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
  800668:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80066b:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800671:	83 c0 54             	add    $0x54,%eax
  800674:	8b 00                	mov    (%eax),%eax
  800676:	89 45 90             	mov    %eax,-0x70(%ebp)
  800679:	8b 45 90             	mov    -0x70(%ebp),%eax
  80067c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800681:	3d 00 00 80 00       	cmp    $0x800000,%eax
  800686:	74 14                	je     80069c <_main+0x664>
  800688:	83 ec 04             	sub    $0x4,%esp
  80068b:	68 d4 22 80 00       	push   $0x8022d4
  800690:	6a 58                	push   $0x58
  800692:	68 81 21 80 00       	push   $0x802181
  800697:	e8 1f 04 00 00       	call   800abb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x801000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
  80069c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80069f:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8006a5:	83 c0 60             	add    $0x60,%eax
  8006a8:	8b 00                	mov    (%eax),%eax
  8006aa:	89 45 8c             	mov    %eax,-0x74(%ebp)
  8006ad:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8006b0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006b5:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8006ba:	74 14                	je     8006d0 <_main+0x698>
  8006bc:	83 ec 04             	sub    $0x4,%esp
  8006bf:	68 d4 22 80 00       	push   $0x8022d4
  8006c4:	6a 59                	push   $0x59
  8006c6:	68 81 21 80 00       	push   $0x802181
  8006cb:	e8 eb 03 00 00       	call   800abb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x802000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
  8006d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006d3:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8006d9:	83 c0 6c             	add    $0x6c,%eax
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	89 45 88             	mov    %eax,-0x78(%ebp)
  8006e1:	8b 45 88             	mov    -0x78(%ebp),%eax
  8006e4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006e9:	3d 00 20 80 00       	cmp    $0x802000,%eax
  8006ee:	74 14                	je     800704 <_main+0x6cc>
  8006f0:	83 ec 04             	sub    $0x4,%esp
  8006f3:	68 d4 22 80 00       	push   $0x8022d4
  8006f8:	6a 5a                	push   $0x5a
  8006fa:	68 81 21 80 00       	push   $0x802181
  8006ff:	e8 b7 03 00 00       	call   800abb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0x803000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
  800704:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800707:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  80070d:	83 c0 78             	add    $0x78,%eax
  800710:	8b 00                	mov    (%eax),%eax
  800712:	89 45 84             	mov    %eax,-0x7c(%ebp)
  800715:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800718:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80071d:	3d 00 30 80 00       	cmp    $0x803000,%eax
  800722:	74 14                	je     800738 <_main+0x700>
  800724:	83 ec 04             	sub    $0x4,%esp
  800727:	68 d4 22 80 00       	push   $0x8022d4
  80072c:	6a 5b                	push   $0x5b
  80072e:	68 81 21 80 00       	push   $0x802181
  800733:	e8 83 03 00 00       	call   800abb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[11].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
  800738:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80073b:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800741:	05 84 00 00 00       	add    $0x84,%eax
  800746:	8b 00                	mov    (%eax),%eax
  800748:	89 45 80             	mov    %eax,-0x80(%ebp)
  80074b:	8b 45 80             	mov    -0x80(%ebp),%eax
  80074e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800753:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  800758:	74 14                	je     80076e <_main+0x736>
  80075a:	83 ec 04             	sub    $0x4,%esp
  80075d:	68 d4 22 80 00       	push   $0x8022d4
  800762:	6a 5c                	push   $0x5c
  800764:	68 81 21 80 00       	push   $0x802181
  800769:	e8 4d 03 00 00       	call   800abb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[12].virtual_address,PAGE_SIZE) !=  0xedbfd000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
  80076e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800771:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800777:	05 90 00 00 00       	add    $0x90,%eax
  80077c:	8b 00                	mov    (%eax),%eax
  80077e:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  800784:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80078a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80078f:	3d 00 d0 bf ed       	cmp    $0xedbfd000,%eax
  800794:	74 14                	je     8007aa <_main+0x772>
  800796:	83 ec 04             	sub    $0x4,%esp
  800799:	68 d4 22 80 00       	push   $0x8022d4
  80079e:	6a 5d                	push   $0x5d
  8007a0:	68 81 21 80 00       	push   $0x802181
  8007a5:	e8 11 03 00 00       	call   800abb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[13].virtual_address,PAGE_SIZE) !=  0xedbfe000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
  8007aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007ad:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8007b3:	05 9c 00 00 00       	add    $0x9c,%eax
  8007b8:	8b 00                	mov    (%eax),%eax
  8007ba:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  8007c0:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8007c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007cb:	3d 00 e0 bf ed       	cmp    $0xedbfe000,%eax
  8007d0:	74 14                	je     8007e6 <_main+0x7ae>
  8007d2:	83 ec 04             	sub    $0x4,%esp
  8007d5:	68 d4 22 80 00       	push   $0x8022d4
  8007da:	6a 5e                	push   $0x5e
  8007dc:	68 81 21 80 00       	push   $0x802181
  8007e1:	e8 d5 02 00 00       	call   800abb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[14].virtual_address,PAGE_SIZE) !=  0xedffd000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
  8007e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007e9:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8007ef:	05 a8 00 00 00       	add    $0xa8,%eax
  8007f4:	8b 00                	mov    (%eax),%eax
  8007f6:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  8007fc:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800802:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800807:	3d 00 d0 ff ed       	cmp    $0xedffd000,%eax
  80080c:	74 14                	je     800822 <_main+0x7ea>
  80080e:	83 ec 04             	sub    $0x4,%esp
  800811:	68 d4 22 80 00       	push   $0x8022d4
  800816:	6a 5f                	push   $0x5f
  800818:	68 81 21 80 00       	push   $0x802181
  80081d:	e8 99 02 00 00       	call   800abb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[15].virtual_address,PAGE_SIZE) !=  0xedffe000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
  800822:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800825:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  80082b:	05 b4 00 00 00       	add    $0xb4,%eax
  800830:	8b 00                	mov    (%eax),%eax
  800832:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  800838:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80083e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800843:	3d 00 e0 ff ed       	cmp    $0xedffe000,%eax
  800848:	74 14                	je     80085e <_main+0x826>
  80084a:	83 ec 04             	sub    $0x4,%esp
  80084d:	68 d4 22 80 00       	push   $0x8022d4
  800852:	6a 60                	push   $0x60
  800854:	68 81 21 80 00       	push   $0x802181
  800859:	e8 5d 02 00 00       	call   800abb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[16].virtual_address,PAGE_SIZE) !=  0xee3fd000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
  80085e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800861:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800867:	05 c0 00 00 00       	add    $0xc0,%eax
  80086c:	8b 00                	mov    (%eax),%eax
  80086e:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  800874:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  80087a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80087f:	3d 00 d0 3f ee       	cmp    $0xee3fd000,%eax
  800884:	74 14                	je     80089a <_main+0x862>
  800886:	83 ec 04             	sub    $0x4,%esp
  800889:	68 d4 22 80 00       	push   $0x8022d4
  80088e:	6a 61                	push   $0x61
  800890:	68 81 21 80 00       	push   $0x802181
  800895:	e8 21 02 00 00       	call   800abb <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[17].virtual_address,PAGE_SIZE) !=  0xee3fe000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
  80089a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80089d:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8008a3:	05 cc 00 00 00       	add    $0xcc,%eax
  8008a8:	8b 00                	mov    (%eax),%eax
  8008aa:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  8008b0:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  8008b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008bb:	3d 00 e0 3f ee       	cmp    $0xee3fe000,%eax
  8008c0:	74 14                	je     8008d6 <_main+0x89e>
  8008c2:	83 ec 04             	sub    $0x4,%esp
  8008c5:	68 d4 22 80 00       	push   $0x8022d4
  8008ca:	6a 62                	push   $0x62
  8008cc:	68 81 21 80 00       	push   $0x802181
  8008d1:	e8 e5 01 00 00       	call   800abb <_panic>
	}
	cprintf("STEP B passed: WS entries test are correct\n\n\n");
  8008d6:	83 ec 0c             	sub    $0xc,%esp
  8008d9:	68 28 23 80 00       	push   $0x802328
  8008de:	e8 03 03 00 00       	call   800be6 <cprintf>
  8008e3:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking working sets pointer locations...\n");
  8008e6:	83 ec 0c             	sub    $0xc,%esp
  8008e9:	68 58 23 80 00       	push   $0x802358
  8008ee:	e8 f3 02 00 00       	call   800be6 <cprintf>
  8008f3:	83 c4 10             	add    $0x10,%esp
	{
		if(myEnv->page_last_WS_index != 18) panic("wrong PAGE WS pointer location... trace it by printing page WS before & after fault");
  8008f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008f9:	8b 80 d4 02 00 00    	mov    0x2d4(%eax),%eax
  8008ff:	83 f8 12             	cmp    $0x12,%eax
  800902:	74 14                	je     800918 <_main+0x8e0>
  800904:	83 ec 04             	sub    $0x4,%esp
  800907:	68 8c 23 80 00       	push   $0x80238c
  80090c:	6a 68                	push   $0x68
  80090e:	68 81 21 80 00       	push   $0x802181
  800913:	e8 a3 01 00 00       	call   800abb <_panic>

		i=PAGE_SIZE*1024*3;
  800918:	c7 45 f4 00 00 c0 00 	movl   $0xc00000,-0xc(%ebp)
		for(;i<=(PAGE_SIZE*1024*3+PAGE_SIZE);i++)
  80091f:	eb 11                	jmp    800932 <_main+0x8fa>
		{
			arr[i] = -1;
  800921:	8d 95 64 ff ff fe    	lea    -0x100009c(%ebp),%edx
  800927:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80092a:	01 d0                	add    %edx,%eax
  80092c:	c6 00 ff             	movb   $0xff,(%eax)
	cprintf("STEP C: checking working sets pointer locations...\n");
	{
		if(myEnv->page_last_WS_index != 18) panic("wrong PAGE WS pointer location... trace it by printing page WS before & after fault");

		i=PAGE_SIZE*1024*3;
		for(;i<=(PAGE_SIZE*1024*3+PAGE_SIZE);i++)
  80092f:	ff 45 f4             	incl   -0xc(%ebp)
  800932:	81 7d f4 00 10 c0 00 	cmpl   $0xc01000,-0xc(%ebp)
  800939:	7e e6                	jle    800921 <_main+0x8e9>
		{
			arr[i] = -1;
		}

		if( arr[PAGE_SIZE*1024*3] !=  -1)  panic("PLACEMENT of stack page failed");
  80093b:	8a 85 64 ff bf ff    	mov    -0x40009c(%ebp),%al
  800941:	3c ff                	cmp    $0xff,%al
  800943:	74 14                	je     800959 <_main+0x921>
  800945:	83 ec 04             	sub    $0x4,%esp
  800948:	68 0c 22 80 00       	push   $0x80220c
  80094d:	6a 70                	push   $0x70
  80094f:	68 81 21 80 00       	push   $0x802181
  800954:	e8 62 01 00 00       	call   800abb <_panic>
		if( arr[PAGE_SIZE*1024*3 + PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");
  800959:	8a 85 64 0f c0 ff    	mov    -0x3ff09c(%ebp),%al
  80095f:	3c ff                	cmp    $0xff,%al
  800961:	74 14                	je     800977 <_main+0x93f>
  800963:	83 ec 04             	sub    $0x4,%esp
  800966:	68 0c 22 80 00       	push   $0x80220c
  80096b:	6a 71                	push   $0x71
  80096d:	68 81 21 80 00       	push   $0x802181
  800972:	e8 44 01 00 00       	call   800abb <_panic>

		if( ROUNDDOWN(myEnv->__uptr_pws[19].virtual_address,PAGE_SIZE) !=  0xee7fe000)  panic("LAST PAGE WS entry checking failed");
  800977:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80097a:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800980:	05 e4 00 00 00       	add    $0xe4,%eax
  800985:	8b 00                	mov    (%eax),%eax
  800987:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  80098d:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800993:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800998:	3d 00 e0 7f ee       	cmp    $0xee7fe000,%eax
  80099d:	74 14                	je     8009b3 <_main+0x97b>
  80099f:	83 ec 04             	sub    $0x4,%esp
  8009a2:	68 e0 23 80 00       	push   $0x8023e0
  8009a7:	6a 73                	push   $0x73
  8009a9:	68 81 21 80 00       	push   $0x802181
  8009ae:	e8 08 01 00 00       	call   800abb <_panic>

		if(myEnv->page_last_WS_index != 0) panic("wrong PAGE WS pointer location... trace it by printing page WS before & after fault");
  8009b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009b6:	8b 80 d4 02 00 00    	mov    0x2d4(%eax),%eax
  8009bc:	85 c0                	test   %eax,%eax
  8009be:	74 14                	je     8009d4 <_main+0x99c>
  8009c0:	83 ec 04             	sub    $0x4,%esp
  8009c3:	68 8c 23 80 00       	push   $0x80238c
  8009c8:	6a 75                	push   $0x75
  8009ca:	68 81 21 80 00       	push   $0x802181
  8009cf:	e8 e7 00 00 00       	call   800abb <_panic>

	}
	cprintf("STEP C passed: pointers reached zero\n\n\n");
  8009d4:	83 ec 0c             	sub    $0xc,%esp
  8009d7:	68 04 24 80 00       	push   $0x802404
  8009dc:	e8 05 02 00 00       	call   800be6 <cprintf>
  8009e1:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of PAGE PLACEMENT completed successfully!!\n\n\n");
  8009e4:	83 ec 0c             	sub    $0xc,%esp
  8009e7:	68 2c 24 80 00       	push   $0x80242c
  8009ec:	e8 f5 01 00 00       	call   800be6 <cprintf>
  8009f1:	83 c4 10             	add    $0x10,%esp
	return;
  8009f4:	90                   	nop
}
  8009f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009f8:	c9                   	leave  
  8009f9:	c3                   	ret    

008009fa <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a04:	7e 0a                	jle    800a10 <libmain+0x16>
		binaryname = argv[0];
  800a06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a09:	8b 00                	mov    (%eax),%eax
  800a0b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800a10:	83 ec 08             	sub    $0x8,%esp
  800a13:	ff 75 0c             	pushl  0xc(%ebp)
  800a16:	ff 75 08             	pushl  0x8(%ebp)
  800a19:	e8 1a f6 ff ff       	call   800038 <_main>
  800a1e:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  800a21:	e8 bf 0f 00 00       	call   8019e5 <sys_getenvid>
  800a26:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  800a29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a2c:	89 d0                	mov    %edx,%eax
  800a2e:	c1 e0 03             	shl    $0x3,%eax
  800a31:	01 d0                	add    %edx,%eax
  800a33:	01 c0                	add    %eax,%eax
  800a35:	01 d0                	add    %edx,%eax
  800a37:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a3e:	01 d0                	add    %edx,%eax
  800a40:	c1 e0 03             	shl    $0x3,%eax
  800a43:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800a48:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  800a4b:	e8 e3 10 00 00       	call   801b33 <sys_disable_interrupt>
		cprintf("**************************************\n");
  800a50:	83 ec 0c             	sub    $0xc,%esp
  800a53:	68 8c 24 80 00       	push   $0x80248c
  800a58:	e8 89 01 00 00       	call   800be6 <cprintf>
  800a5d:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  800a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a63:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  800a69:	83 ec 08             	sub    $0x8,%esp
  800a6c:	50                   	push   %eax
  800a6d:	68 b4 24 80 00       	push   $0x8024b4
  800a72:	e8 6f 01 00 00       	call   800be6 <cprintf>
  800a77:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800a7a:	83 ec 0c             	sub    $0xc,%esp
  800a7d:	68 8c 24 80 00       	push   $0x80248c
  800a82:	e8 5f 01 00 00       	call   800be6 <cprintf>
  800a87:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800a8a:	e8 be 10 00 00       	call   801b4d <sys_enable_interrupt>

	// exit gracefully
	exit();
  800a8f:	e8 19 00 00 00       	call   800aad <exit>
}
  800a94:	90                   	nop
  800a95:	c9                   	leave  
  800a96:	c3                   	ret    

00800a97 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800a97:	55                   	push   %ebp
  800a98:	89 e5                	mov    %esp,%ebp
  800a9a:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800a9d:	83 ec 0c             	sub    $0xc,%esp
  800aa0:	6a 00                	push   $0x0
  800aa2:	e8 23 0f 00 00       	call   8019ca <sys_env_destroy>
  800aa7:	83 c4 10             	add    $0x10,%esp
}
  800aaa:	90                   	nop
  800aab:	c9                   	leave  
  800aac:	c3                   	ret    

00800aad <exit>:

void
exit(void)
{
  800aad:	55                   	push   %ebp
  800aae:	89 e5                	mov    %esp,%ebp
  800ab0:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800ab3:	e8 46 0f 00 00       	call   8019fe <sys_env_exit>
}
  800ab8:	90                   	nop
  800ab9:	c9                   	leave  
  800aba:	c3                   	ret    

00800abb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ac1:	8d 45 10             	lea    0x10(%ebp),%eax
  800ac4:	83 c0 04             	add    $0x4,%eax
  800ac7:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  800aca:	a1 10 30 80 00       	mov    0x803010,%eax
  800acf:	85 c0                	test   %eax,%eax
  800ad1:	74 16                	je     800ae9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800ad3:	a1 10 30 80 00       	mov    0x803010,%eax
  800ad8:	83 ec 08             	sub    $0x8,%esp
  800adb:	50                   	push   %eax
  800adc:	68 cd 24 80 00       	push   $0x8024cd
  800ae1:	e8 00 01 00 00       	call   800be6 <cprintf>
  800ae6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800ae9:	a1 00 30 80 00       	mov    0x803000,%eax
  800aee:	ff 75 0c             	pushl  0xc(%ebp)
  800af1:	ff 75 08             	pushl  0x8(%ebp)
  800af4:	50                   	push   %eax
  800af5:	68 d2 24 80 00       	push   $0x8024d2
  800afa:	e8 e7 00 00 00       	call   800be6 <cprintf>
  800aff:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800b02:	8b 45 10             	mov    0x10(%ebp),%eax
  800b05:	83 ec 08             	sub    $0x8,%esp
  800b08:	ff 75 f4             	pushl  -0xc(%ebp)
  800b0b:	50                   	push   %eax
  800b0c:	e8 7a 00 00 00       	call   800b8b <vcprintf>
  800b11:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  800b14:	83 ec 0c             	sub    $0xc,%esp
  800b17:	68 ee 24 80 00       	push   $0x8024ee
  800b1c:	e8 c5 00 00 00       	call   800be6 <cprintf>
  800b21:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800b24:	e8 84 ff ff ff       	call   800aad <exit>

	// should not return here
	while (1) ;
  800b29:	eb fe                	jmp    800b29 <_panic+0x6e>

00800b2b <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b34:	8b 00                	mov    (%eax),%eax
  800b36:	8d 48 01             	lea    0x1(%eax),%ecx
  800b39:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3c:	89 0a                	mov    %ecx,(%edx)
  800b3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b41:	88 d1                	mov    %dl,%cl
  800b43:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b46:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4d:	8b 00                	mov    (%eax),%eax
  800b4f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b54:	75 23                	jne    800b79 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  800b56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b59:	8b 00                	mov    (%eax),%eax
  800b5b:	89 c2                	mov    %eax,%edx
  800b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b60:	83 c0 08             	add    $0x8,%eax
  800b63:	83 ec 08             	sub    $0x8,%esp
  800b66:	52                   	push   %edx
  800b67:	50                   	push   %eax
  800b68:	e8 27 0e 00 00       	call   801994 <sys_cputs>
  800b6d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7c:	8b 40 04             	mov    0x4(%eax),%eax
  800b7f:	8d 50 01             	lea    0x1(%eax),%edx
  800b82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b85:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b88:	90                   	nop
  800b89:	c9                   	leave  
  800b8a:	c3                   	ret    

00800b8b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b8b:	55                   	push   %ebp
  800b8c:	89 e5                	mov    %esp,%ebp
  800b8e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b94:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b9b:	00 00 00 
	b.cnt = 0;
  800b9e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800ba5:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800ba8:	ff 75 0c             	pushl  0xc(%ebp)
  800bab:	ff 75 08             	pushl  0x8(%ebp)
  800bae:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bb4:	50                   	push   %eax
  800bb5:	68 2b 0b 80 00       	push   $0x800b2b
  800bba:	e8 fa 01 00 00       	call   800db9 <vprintfmt>
  800bbf:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  800bc2:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800bc8:	83 ec 08             	sub    $0x8,%esp
  800bcb:	50                   	push   %eax
  800bcc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bd2:	83 c0 08             	add    $0x8,%eax
  800bd5:	50                   	push   %eax
  800bd6:	e8 b9 0d 00 00       	call   801994 <sys_cputs>
  800bdb:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  800bde:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800be4:	c9                   	leave  
  800be5:	c3                   	ret    

00800be6 <cprintf>:

int cprintf(const char *fmt, ...) {
  800be6:	55                   	push   %ebp
  800be7:	89 e5                	mov    %esp,%ebp
  800be9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bec:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf5:	83 ec 08             	sub    $0x8,%esp
  800bf8:	ff 75 f4             	pushl  -0xc(%ebp)
  800bfb:	50                   	push   %eax
  800bfc:	e8 8a ff ff ff       	call   800b8b <vcprintf>
  800c01:	83 c4 10             	add    $0x10,%esp
  800c04:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c07:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c0a:	c9                   	leave  
  800c0b:	c3                   	ret    

00800c0c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800c0c:	55                   	push   %ebp
  800c0d:	89 e5                	mov    %esp,%ebp
  800c0f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800c12:	e8 1c 0f 00 00       	call   801b33 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800c17:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	83 ec 08             	sub    $0x8,%esp
  800c23:	ff 75 f4             	pushl  -0xc(%ebp)
  800c26:	50                   	push   %eax
  800c27:	e8 5f ff ff ff       	call   800b8b <vcprintf>
  800c2c:	83 c4 10             	add    $0x10,%esp
  800c2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800c32:	e8 16 0f 00 00       	call   801b4d <sys_enable_interrupt>
	return cnt;
  800c37:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c3a:	c9                   	leave  
  800c3b:	c3                   	ret    

00800c3c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
  800c3f:	53                   	push   %ebx
  800c40:	83 ec 14             	sub    $0x14,%esp
  800c43:	8b 45 10             	mov    0x10(%ebp),%eax
  800c46:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c49:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c4f:	8b 45 18             	mov    0x18(%ebp),%eax
  800c52:	ba 00 00 00 00       	mov    $0x0,%edx
  800c57:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c5a:	77 55                	ja     800cb1 <printnum+0x75>
  800c5c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c5f:	72 05                	jb     800c66 <printnum+0x2a>
  800c61:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c64:	77 4b                	ja     800cb1 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c66:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c69:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c6c:	8b 45 18             	mov    0x18(%ebp),%eax
  800c6f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c74:	52                   	push   %edx
  800c75:	50                   	push   %eax
  800c76:	ff 75 f4             	pushl  -0xc(%ebp)
  800c79:	ff 75 f0             	pushl  -0x10(%ebp)
  800c7c:	e8 4f 12 00 00       	call   801ed0 <__udivdi3>
  800c81:	83 c4 10             	add    $0x10,%esp
  800c84:	83 ec 04             	sub    $0x4,%esp
  800c87:	ff 75 20             	pushl  0x20(%ebp)
  800c8a:	53                   	push   %ebx
  800c8b:	ff 75 18             	pushl  0x18(%ebp)
  800c8e:	52                   	push   %edx
  800c8f:	50                   	push   %eax
  800c90:	ff 75 0c             	pushl  0xc(%ebp)
  800c93:	ff 75 08             	pushl  0x8(%ebp)
  800c96:	e8 a1 ff ff ff       	call   800c3c <printnum>
  800c9b:	83 c4 20             	add    $0x20,%esp
  800c9e:	eb 1a                	jmp    800cba <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ca0:	83 ec 08             	sub    $0x8,%esp
  800ca3:	ff 75 0c             	pushl  0xc(%ebp)
  800ca6:	ff 75 20             	pushl  0x20(%ebp)
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	ff d0                	call   *%eax
  800cae:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800cb1:	ff 4d 1c             	decl   0x1c(%ebp)
  800cb4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800cb8:	7f e6                	jg     800ca0 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800cba:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800cbd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cc8:	53                   	push   %ebx
  800cc9:	51                   	push   %ecx
  800cca:	52                   	push   %edx
  800ccb:	50                   	push   %eax
  800ccc:	e8 0f 13 00 00       	call   801fe0 <__umoddi3>
  800cd1:	83 c4 10             	add    $0x10,%esp
  800cd4:	05 14 27 80 00       	add    $0x802714,%eax
  800cd9:	8a 00                	mov    (%eax),%al
  800cdb:	0f be c0             	movsbl %al,%eax
  800cde:	83 ec 08             	sub    $0x8,%esp
  800ce1:	ff 75 0c             	pushl  0xc(%ebp)
  800ce4:	50                   	push   %eax
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	ff d0                	call   *%eax
  800cea:	83 c4 10             	add    $0x10,%esp
}
  800ced:	90                   	nop
  800cee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cf1:	c9                   	leave  
  800cf2:	c3                   	ret    

00800cf3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cf6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cfa:	7e 1c                	jle    800d18 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	8b 00                	mov    (%eax),%eax
  800d01:	8d 50 08             	lea    0x8(%eax),%edx
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	89 10                	mov    %edx,(%eax)
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	8b 00                	mov    (%eax),%eax
  800d0e:	83 e8 08             	sub    $0x8,%eax
  800d11:	8b 50 04             	mov    0x4(%eax),%edx
  800d14:	8b 00                	mov    (%eax),%eax
  800d16:	eb 40                	jmp    800d58 <getuint+0x65>
	else if (lflag)
  800d18:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d1c:	74 1e                	je     800d3c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8b 00                	mov    (%eax),%eax
  800d23:	8d 50 04             	lea    0x4(%eax),%edx
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	89 10                	mov    %edx,(%eax)
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	8b 00                	mov    (%eax),%eax
  800d30:	83 e8 04             	sub    $0x4,%eax
  800d33:	8b 00                	mov    (%eax),%eax
  800d35:	ba 00 00 00 00       	mov    $0x0,%edx
  800d3a:	eb 1c                	jmp    800d58 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	8b 00                	mov    (%eax),%eax
  800d41:	8d 50 04             	lea    0x4(%eax),%edx
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	89 10                	mov    %edx,(%eax)
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	8b 00                	mov    (%eax),%eax
  800d4e:	83 e8 04             	sub    $0x4,%eax
  800d51:	8b 00                	mov    (%eax),%eax
  800d53:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d58:	5d                   	pop    %ebp
  800d59:	c3                   	ret    

00800d5a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d5a:	55                   	push   %ebp
  800d5b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d5d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d61:	7e 1c                	jle    800d7f <getint+0x25>
		return va_arg(*ap, long long);
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	8b 00                	mov    (%eax),%eax
  800d68:	8d 50 08             	lea    0x8(%eax),%edx
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	89 10                	mov    %edx,(%eax)
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	8b 00                	mov    (%eax),%eax
  800d75:	83 e8 08             	sub    $0x8,%eax
  800d78:	8b 50 04             	mov    0x4(%eax),%edx
  800d7b:	8b 00                	mov    (%eax),%eax
  800d7d:	eb 38                	jmp    800db7 <getint+0x5d>
	else if (lflag)
  800d7f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d83:	74 1a                	je     800d9f <getint+0x45>
		return va_arg(*ap, long);
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
  800d88:	8b 00                	mov    (%eax),%eax
  800d8a:	8d 50 04             	lea    0x4(%eax),%edx
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	89 10                	mov    %edx,(%eax)
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8b 00                	mov    (%eax),%eax
  800d97:	83 e8 04             	sub    $0x4,%eax
  800d9a:	8b 00                	mov    (%eax),%eax
  800d9c:	99                   	cltd   
  800d9d:	eb 18                	jmp    800db7 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800da2:	8b 00                	mov    (%eax),%eax
  800da4:	8d 50 04             	lea    0x4(%eax),%edx
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	89 10                	mov    %edx,(%eax)
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	8b 00                	mov    (%eax),%eax
  800db1:	83 e8 04             	sub    $0x4,%eax
  800db4:	8b 00                	mov    (%eax),%eax
  800db6:	99                   	cltd   
}
  800db7:	5d                   	pop    %ebp
  800db8:	c3                   	ret    

00800db9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800db9:	55                   	push   %ebp
  800dba:	89 e5                	mov    %esp,%ebp
  800dbc:	56                   	push   %esi
  800dbd:	53                   	push   %ebx
  800dbe:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800dc1:	eb 17                	jmp    800dda <vprintfmt+0x21>
			if (ch == '\0')
  800dc3:	85 db                	test   %ebx,%ebx
  800dc5:	0f 84 af 03 00 00    	je     80117a <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800dcb:	83 ec 08             	sub    $0x8,%esp
  800dce:	ff 75 0c             	pushl  0xc(%ebp)
  800dd1:	53                   	push   %ebx
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	ff d0                	call   *%eax
  800dd7:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800dda:	8b 45 10             	mov    0x10(%ebp),%eax
  800ddd:	8d 50 01             	lea    0x1(%eax),%edx
  800de0:	89 55 10             	mov    %edx,0x10(%ebp)
  800de3:	8a 00                	mov    (%eax),%al
  800de5:	0f b6 d8             	movzbl %al,%ebx
  800de8:	83 fb 25             	cmp    $0x25,%ebx
  800deb:	75 d6                	jne    800dc3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ded:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800df1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800df8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800dff:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e06:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e10:	8d 50 01             	lea    0x1(%eax),%edx
  800e13:	89 55 10             	mov    %edx,0x10(%ebp)
  800e16:	8a 00                	mov    (%eax),%al
  800e18:	0f b6 d8             	movzbl %al,%ebx
  800e1b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e1e:	83 f8 55             	cmp    $0x55,%eax
  800e21:	0f 87 2b 03 00 00    	ja     801152 <vprintfmt+0x399>
  800e27:	8b 04 85 38 27 80 00 	mov    0x802738(,%eax,4),%eax
  800e2e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e30:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e34:	eb d7                	jmp    800e0d <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e36:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e3a:	eb d1                	jmp    800e0d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e3c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e43:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e46:	89 d0                	mov    %edx,%eax
  800e48:	c1 e0 02             	shl    $0x2,%eax
  800e4b:	01 d0                	add    %edx,%eax
  800e4d:	01 c0                	add    %eax,%eax
  800e4f:	01 d8                	add    %ebx,%eax
  800e51:	83 e8 30             	sub    $0x30,%eax
  800e54:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e57:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5a:	8a 00                	mov    (%eax),%al
  800e5c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e5f:	83 fb 2f             	cmp    $0x2f,%ebx
  800e62:	7e 3e                	jle    800ea2 <vprintfmt+0xe9>
  800e64:	83 fb 39             	cmp    $0x39,%ebx
  800e67:	7f 39                	jg     800ea2 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e69:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e6c:	eb d5                	jmp    800e43 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e71:	83 c0 04             	add    $0x4,%eax
  800e74:	89 45 14             	mov    %eax,0x14(%ebp)
  800e77:	8b 45 14             	mov    0x14(%ebp),%eax
  800e7a:	83 e8 04             	sub    $0x4,%eax
  800e7d:	8b 00                	mov    (%eax),%eax
  800e7f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e82:	eb 1f                	jmp    800ea3 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e84:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e88:	79 83                	jns    800e0d <vprintfmt+0x54>
				width = 0;
  800e8a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e91:	e9 77 ff ff ff       	jmp    800e0d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e96:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e9d:	e9 6b ff ff ff       	jmp    800e0d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ea2:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ea3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ea7:	0f 89 60 ff ff ff    	jns    800e0d <vprintfmt+0x54>
				width = precision, precision = -1;
  800ead:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800eb0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800eb3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800eba:	e9 4e ff ff ff       	jmp    800e0d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ebf:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ec2:	e9 46 ff ff ff       	jmp    800e0d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ec7:	8b 45 14             	mov    0x14(%ebp),%eax
  800eca:	83 c0 04             	add    $0x4,%eax
  800ecd:	89 45 14             	mov    %eax,0x14(%ebp)
  800ed0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed3:	83 e8 04             	sub    $0x4,%eax
  800ed6:	8b 00                	mov    (%eax),%eax
  800ed8:	83 ec 08             	sub    $0x8,%esp
  800edb:	ff 75 0c             	pushl  0xc(%ebp)
  800ede:	50                   	push   %eax
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee2:	ff d0                	call   *%eax
  800ee4:	83 c4 10             	add    $0x10,%esp
			break;
  800ee7:	e9 89 02 00 00       	jmp    801175 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800eec:	8b 45 14             	mov    0x14(%ebp),%eax
  800eef:	83 c0 04             	add    $0x4,%eax
  800ef2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ef5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef8:	83 e8 04             	sub    $0x4,%eax
  800efb:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800efd:	85 db                	test   %ebx,%ebx
  800eff:	79 02                	jns    800f03 <vprintfmt+0x14a>
				err = -err;
  800f01:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f03:	83 fb 64             	cmp    $0x64,%ebx
  800f06:	7f 0b                	jg     800f13 <vprintfmt+0x15a>
  800f08:	8b 34 9d 80 25 80 00 	mov    0x802580(,%ebx,4),%esi
  800f0f:	85 f6                	test   %esi,%esi
  800f11:	75 19                	jne    800f2c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f13:	53                   	push   %ebx
  800f14:	68 25 27 80 00       	push   $0x802725
  800f19:	ff 75 0c             	pushl  0xc(%ebp)
  800f1c:	ff 75 08             	pushl  0x8(%ebp)
  800f1f:	e8 5e 02 00 00       	call   801182 <printfmt>
  800f24:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f27:	e9 49 02 00 00       	jmp    801175 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f2c:	56                   	push   %esi
  800f2d:	68 2e 27 80 00       	push   $0x80272e
  800f32:	ff 75 0c             	pushl  0xc(%ebp)
  800f35:	ff 75 08             	pushl  0x8(%ebp)
  800f38:	e8 45 02 00 00       	call   801182 <printfmt>
  800f3d:	83 c4 10             	add    $0x10,%esp
			break;
  800f40:	e9 30 02 00 00       	jmp    801175 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f45:	8b 45 14             	mov    0x14(%ebp),%eax
  800f48:	83 c0 04             	add    $0x4,%eax
  800f4b:	89 45 14             	mov    %eax,0x14(%ebp)
  800f4e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f51:	83 e8 04             	sub    $0x4,%eax
  800f54:	8b 30                	mov    (%eax),%esi
  800f56:	85 f6                	test   %esi,%esi
  800f58:	75 05                	jne    800f5f <vprintfmt+0x1a6>
				p = "(null)";
  800f5a:	be 31 27 80 00       	mov    $0x802731,%esi
			if (width > 0 && padc != '-')
  800f5f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f63:	7e 6d                	jle    800fd2 <vprintfmt+0x219>
  800f65:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f69:	74 67                	je     800fd2 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f6e:	83 ec 08             	sub    $0x8,%esp
  800f71:	50                   	push   %eax
  800f72:	56                   	push   %esi
  800f73:	e8 0c 03 00 00       	call   801284 <strnlen>
  800f78:	83 c4 10             	add    $0x10,%esp
  800f7b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f7e:	eb 16                	jmp    800f96 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f80:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f84:	83 ec 08             	sub    $0x8,%esp
  800f87:	ff 75 0c             	pushl  0xc(%ebp)
  800f8a:	50                   	push   %eax
  800f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8e:	ff d0                	call   *%eax
  800f90:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f93:	ff 4d e4             	decl   -0x1c(%ebp)
  800f96:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f9a:	7f e4                	jg     800f80 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f9c:	eb 34                	jmp    800fd2 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f9e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800fa2:	74 1c                	je     800fc0 <vprintfmt+0x207>
  800fa4:	83 fb 1f             	cmp    $0x1f,%ebx
  800fa7:	7e 05                	jle    800fae <vprintfmt+0x1f5>
  800fa9:	83 fb 7e             	cmp    $0x7e,%ebx
  800fac:	7e 12                	jle    800fc0 <vprintfmt+0x207>
					putch('?', putdat);
  800fae:	83 ec 08             	sub    $0x8,%esp
  800fb1:	ff 75 0c             	pushl  0xc(%ebp)
  800fb4:	6a 3f                	push   $0x3f
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	ff d0                	call   *%eax
  800fbb:	83 c4 10             	add    $0x10,%esp
  800fbe:	eb 0f                	jmp    800fcf <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800fc0:	83 ec 08             	sub    $0x8,%esp
  800fc3:	ff 75 0c             	pushl  0xc(%ebp)
  800fc6:	53                   	push   %ebx
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	ff d0                	call   *%eax
  800fcc:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fcf:	ff 4d e4             	decl   -0x1c(%ebp)
  800fd2:	89 f0                	mov    %esi,%eax
  800fd4:	8d 70 01             	lea    0x1(%eax),%esi
  800fd7:	8a 00                	mov    (%eax),%al
  800fd9:	0f be d8             	movsbl %al,%ebx
  800fdc:	85 db                	test   %ebx,%ebx
  800fde:	74 24                	je     801004 <vprintfmt+0x24b>
  800fe0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fe4:	78 b8                	js     800f9e <vprintfmt+0x1e5>
  800fe6:	ff 4d e0             	decl   -0x20(%ebp)
  800fe9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fed:	79 af                	jns    800f9e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fef:	eb 13                	jmp    801004 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ff1:	83 ec 08             	sub    $0x8,%esp
  800ff4:	ff 75 0c             	pushl  0xc(%ebp)
  800ff7:	6a 20                	push   $0x20
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	ff d0                	call   *%eax
  800ffe:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801001:	ff 4d e4             	decl   -0x1c(%ebp)
  801004:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801008:	7f e7                	jg     800ff1 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80100a:	e9 66 01 00 00       	jmp    801175 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80100f:	83 ec 08             	sub    $0x8,%esp
  801012:	ff 75 e8             	pushl  -0x18(%ebp)
  801015:	8d 45 14             	lea    0x14(%ebp),%eax
  801018:	50                   	push   %eax
  801019:	e8 3c fd ff ff       	call   800d5a <getint>
  80101e:	83 c4 10             	add    $0x10,%esp
  801021:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801024:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801027:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80102a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80102d:	85 d2                	test   %edx,%edx
  80102f:	79 23                	jns    801054 <vprintfmt+0x29b>
				putch('-', putdat);
  801031:	83 ec 08             	sub    $0x8,%esp
  801034:	ff 75 0c             	pushl  0xc(%ebp)
  801037:	6a 2d                	push   $0x2d
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	ff d0                	call   *%eax
  80103e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801041:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801044:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801047:	f7 d8                	neg    %eax
  801049:	83 d2 00             	adc    $0x0,%edx
  80104c:	f7 da                	neg    %edx
  80104e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801051:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801054:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80105b:	e9 bc 00 00 00       	jmp    80111c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801060:	83 ec 08             	sub    $0x8,%esp
  801063:	ff 75 e8             	pushl  -0x18(%ebp)
  801066:	8d 45 14             	lea    0x14(%ebp),%eax
  801069:	50                   	push   %eax
  80106a:	e8 84 fc ff ff       	call   800cf3 <getuint>
  80106f:	83 c4 10             	add    $0x10,%esp
  801072:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801075:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801078:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80107f:	e9 98 00 00 00       	jmp    80111c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801084:	83 ec 08             	sub    $0x8,%esp
  801087:	ff 75 0c             	pushl  0xc(%ebp)
  80108a:	6a 58                	push   $0x58
  80108c:	8b 45 08             	mov    0x8(%ebp),%eax
  80108f:	ff d0                	call   *%eax
  801091:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801094:	83 ec 08             	sub    $0x8,%esp
  801097:	ff 75 0c             	pushl  0xc(%ebp)
  80109a:	6a 58                	push   $0x58
  80109c:	8b 45 08             	mov    0x8(%ebp),%eax
  80109f:	ff d0                	call   *%eax
  8010a1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010a4:	83 ec 08             	sub    $0x8,%esp
  8010a7:	ff 75 0c             	pushl  0xc(%ebp)
  8010aa:	6a 58                	push   $0x58
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	ff d0                	call   *%eax
  8010b1:	83 c4 10             	add    $0x10,%esp
			break;
  8010b4:	e9 bc 00 00 00       	jmp    801175 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8010b9:	83 ec 08             	sub    $0x8,%esp
  8010bc:	ff 75 0c             	pushl  0xc(%ebp)
  8010bf:	6a 30                	push   $0x30
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	ff d0                	call   *%eax
  8010c6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8010c9:	83 ec 08             	sub    $0x8,%esp
  8010cc:	ff 75 0c             	pushl  0xc(%ebp)
  8010cf:	6a 78                	push   $0x78
  8010d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d4:	ff d0                	call   *%eax
  8010d6:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8010dc:	83 c0 04             	add    $0x4,%eax
  8010df:	89 45 14             	mov    %eax,0x14(%ebp)
  8010e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8010e5:	83 e8 04             	sub    $0x4,%eax
  8010e8:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010f4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010fb:	eb 1f                	jmp    80111c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010fd:	83 ec 08             	sub    $0x8,%esp
  801100:	ff 75 e8             	pushl  -0x18(%ebp)
  801103:	8d 45 14             	lea    0x14(%ebp),%eax
  801106:	50                   	push   %eax
  801107:	e8 e7 fb ff ff       	call   800cf3 <getuint>
  80110c:	83 c4 10             	add    $0x10,%esp
  80110f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801112:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801115:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80111c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801120:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801123:	83 ec 04             	sub    $0x4,%esp
  801126:	52                   	push   %edx
  801127:	ff 75 e4             	pushl  -0x1c(%ebp)
  80112a:	50                   	push   %eax
  80112b:	ff 75 f4             	pushl  -0xc(%ebp)
  80112e:	ff 75 f0             	pushl  -0x10(%ebp)
  801131:	ff 75 0c             	pushl  0xc(%ebp)
  801134:	ff 75 08             	pushl  0x8(%ebp)
  801137:	e8 00 fb ff ff       	call   800c3c <printnum>
  80113c:	83 c4 20             	add    $0x20,%esp
			break;
  80113f:	eb 34                	jmp    801175 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801141:	83 ec 08             	sub    $0x8,%esp
  801144:	ff 75 0c             	pushl  0xc(%ebp)
  801147:	53                   	push   %ebx
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	ff d0                	call   *%eax
  80114d:	83 c4 10             	add    $0x10,%esp
			break;
  801150:	eb 23                	jmp    801175 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801152:	83 ec 08             	sub    $0x8,%esp
  801155:	ff 75 0c             	pushl  0xc(%ebp)
  801158:	6a 25                	push   $0x25
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	ff d0                	call   *%eax
  80115f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801162:	ff 4d 10             	decl   0x10(%ebp)
  801165:	eb 03                	jmp    80116a <vprintfmt+0x3b1>
  801167:	ff 4d 10             	decl   0x10(%ebp)
  80116a:	8b 45 10             	mov    0x10(%ebp),%eax
  80116d:	48                   	dec    %eax
  80116e:	8a 00                	mov    (%eax),%al
  801170:	3c 25                	cmp    $0x25,%al
  801172:	75 f3                	jne    801167 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801174:	90                   	nop
		}
	}
  801175:	e9 47 fc ff ff       	jmp    800dc1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80117a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80117b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80117e:	5b                   	pop    %ebx
  80117f:	5e                   	pop    %esi
  801180:	5d                   	pop    %ebp
  801181:	c3                   	ret    

00801182 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801182:	55                   	push   %ebp
  801183:	89 e5                	mov    %esp,%ebp
  801185:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801188:	8d 45 10             	lea    0x10(%ebp),%eax
  80118b:	83 c0 04             	add    $0x4,%eax
  80118e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801191:	8b 45 10             	mov    0x10(%ebp),%eax
  801194:	ff 75 f4             	pushl  -0xc(%ebp)
  801197:	50                   	push   %eax
  801198:	ff 75 0c             	pushl  0xc(%ebp)
  80119b:	ff 75 08             	pushl  0x8(%ebp)
  80119e:	e8 16 fc ff ff       	call   800db9 <vprintfmt>
  8011a3:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8011a6:	90                   	nop
  8011a7:	c9                   	leave  
  8011a8:	c3                   	ret    

008011a9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011a9:	55                   	push   %ebp
  8011aa:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8011ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011af:	8b 40 08             	mov    0x8(%eax),%eax
  8011b2:	8d 50 01             	lea    0x1(%eax),%edx
  8011b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b8:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8011bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011be:	8b 10                	mov    (%eax),%edx
  8011c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c3:	8b 40 04             	mov    0x4(%eax),%eax
  8011c6:	39 c2                	cmp    %eax,%edx
  8011c8:	73 12                	jae    8011dc <sprintputch+0x33>
		*b->buf++ = ch;
  8011ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cd:	8b 00                	mov    (%eax),%eax
  8011cf:	8d 48 01             	lea    0x1(%eax),%ecx
  8011d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011d5:	89 0a                	mov    %ecx,(%edx)
  8011d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8011da:	88 10                	mov    %dl,(%eax)
}
  8011dc:	90                   	nop
  8011dd:	5d                   	pop    %ebp
  8011de:	c3                   	ret    

008011df <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011df:	55                   	push   %ebp
  8011e0:	89 e5                	mov    %esp,%ebp
  8011e2:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ee:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	01 d0                	add    %edx,%eax
  8011f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801200:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801204:	74 06                	je     80120c <vsnprintf+0x2d>
  801206:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80120a:	7f 07                	jg     801213 <vsnprintf+0x34>
		return -E_INVAL;
  80120c:	b8 03 00 00 00       	mov    $0x3,%eax
  801211:	eb 20                	jmp    801233 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801213:	ff 75 14             	pushl  0x14(%ebp)
  801216:	ff 75 10             	pushl  0x10(%ebp)
  801219:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80121c:	50                   	push   %eax
  80121d:	68 a9 11 80 00       	push   $0x8011a9
  801222:	e8 92 fb ff ff       	call   800db9 <vprintfmt>
  801227:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80122a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80122d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801230:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801233:	c9                   	leave  
  801234:	c3                   	ret    

00801235 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801235:	55                   	push   %ebp
  801236:	89 e5                	mov    %esp,%ebp
  801238:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80123b:	8d 45 10             	lea    0x10(%ebp),%eax
  80123e:	83 c0 04             	add    $0x4,%eax
  801241:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801244:	8b 45 10             	mov    0x10(%ebp),%eax
  801247:	ff 75 f4             	pushl  -0xc(%ebp)
  80124a:	50                   	push   %eax
  80124b:	ff 75 0c             	pushl  0xc(%ebp)
  80124e:	ff 75 08             	pushl  0x8(%ebp)
  801251:	e8 89 ff ff ff       	call   8011df <vsnprintf>
  801256:	83 c4 10             	add    $0x10,%esp
  801259:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80125c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80125f:	c9                   	leave  
  801260:	c3                   	ret    

00801261 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801261:	55                   	push   %ebp
  801262:	89 e5                	mov    %esp,%ebp
  801264:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801267:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80126e:	eb 06                	jmp    801276 <strlen+0x15>
		n++;
  801270:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801273:	ff 45 08             	incl   0x8(%ebp)
  801276:	8b 45 08             	mov    0x8(%ebp),%eax
  801279:	8a 00                	mov    (%eax),%al
  80127b:	84 c0                	test   %al,%al
  80127d:	75 f1                	jne    801270 <strlen+0xf>
		n++;
	return n;
  80127f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801282:	c9                   	leave  
  801283:	c3                   	ret    

00801284 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801284:	55                   	push   %ebp
  801285:	89 e5                	mov    %esp,%ebp
  801287:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80128a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801291:	eb 09                	jmp    80129c <strnlen+0x18>
		n++;
  801293:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801296:	ff 45 08             	incl   0x8(%ebp)
  801299:	ff 4d 0c             	decl   0xc(%ebp)
  80129c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012a0:	74 09                	je     8012ab <strnlen+0x27>
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	8a 00                	mov    (%eax),%al
  8012a7:	84 c0                	test   %al,%al
  8012a9:	75 e8                	jne    801293 <strnlen+0xf>
		n++;
	return n;
  8012ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012ae:	c9                   	leave  
  8012af:	c3                   	ret    

008012b0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
  8012b3:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8012bc:	90                   	nop
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	8d 50 01             	lea    0x1(%eax),%edx
  8012c3:	89 55 08             	mov    %edx,0x8(%ebp)
  8012c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012cc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012cf:	8a 12                	mov    (%edx),%dl
  8012d1:	88 10                	mov    %dl,(%eax)
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	84 c0                	test   %al,%al
  8012d7:	75 e4                	jne    8012bd <strcpy+0xd>
		/* do nothing */;
	return ret;
  8012d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012dc:	c9                   	leave  
  8012dd:	c3                   	ret    

008012de <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8012de:	55                   	push   %ebp
  8012df:	89 e5                	mov    %esp,%ebp
  8012e1:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8012ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f1:	eb 1f                	jmp    801312 <strncpy+0x34>
		*dst++ = *src;
  8012f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f6:	8d 50 01             	lea    0x1(%eax),%edx
  8012f9:	89 55 08             	mov    %edx,0x8(%ebp)
  8012fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ff:	8a 12                	mov    (%edx),%dl
  801301:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801303:	8b 45 0c             	mov    0xc(%ebp),%eax
  801306:	8a 00                	mov    (%eax),%al
  801308:	84 c0                	test   %al,%al
  80130a:	74 03                	je     80130f <strncpy+0x31>
			src++;
  80130c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80130f:	ff 45 fc             	incl   -0x4(%ebp)
  801312:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801315:	3b 45 10             	cmp    0x10(%ebp),%eax
  801318:	72 d9                	jb     8012f3 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80131a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80131d:	c9                   	leave  
  80131e:	c3                   	ret    

0080131f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80131f:	55                   	push   %ebp
  801320:	89 e5                	mov    %esp,%ebp
  801322:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801325:	8b 45 08             	mov    0x8(%ebp),%eax
  801328:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80132b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80132f:	74 30                	je     801361 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801331:	eb 16                	jmp    801349 <strlcpy+0x2a>
			*dst++ = *src++;
  801333:	8b 45 08             	mov    0x8(%ebp),%eax
  801336:	8d 50 01             	lea    0x1(%eax),%edx
  801339:	89 55 08             	mov    %edx,0x8(%ebp)
  80133c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80133f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801342:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801345:	8a 12                	mov    (%edx),%dl
  801347:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801349:	ff 4d 10             	decl   0x10(%ebp)
  80134c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801350:	74 09                	je     80135b <strlcpy+0x3c>
  801352:	8b 45 0c             	mov    0xc(%ebp),%eax
  801355:	8a 00                	mov    (%eax),%al
  801357:	84 c0                	test   %al,%al
  801359:	75 d8                	jne    801333 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80135b:	8b 45 08             	mov    0x8(%ebp),%eax
  80135e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801361:	8b 55 08             	mov    0x8(%ebp),%edx
  801364:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801367:	29 c2                	sub    %eax,%edx
  801369:	89 d0                	mov    %edx,%eax
}
  80136b:	c9                   	leave  
  80136c:	c3                   	ret    

0080136d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801370:	eb 06                	jmp    801378 <strcmp+0xb>
		p++, q++;
  801372:	ff 45 08             	incl   0x8(%ebp)
  801375:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801378:	8b 45 08             	mov    0x8(%ebp),%eax
  80137b:	8a 00                	mov    (%eax),%al
  80137d:	84 c0                	test   %al,%al
  80137f:	74 0e                	je     80138f <strcmp+0x22>
  801381:	8b 45 08             	mov    0x8(%ebp),%eax
  801384:	8a 10                	mov    (%eax),%dl
  801386:	8b 45 0c             	mov    0xc(%ebp),%eax
  801389:	8a 00                	mov    (%eax),%al
  80138b:	38 c2                	cmp    %al,%dl
  80138d:	74 e3                	je     801372 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80138f:	8b 45 08             	mov    0x8(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	0f b6 d0             	movzbl %al,%edx
  801397:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139a:	8a 00                	mov    (%eax),%al
  80139c:	0f b6 c0             	movzbl %al,%eax
  80139f:	29 c2                	sub    %eax,%edx
  8013a1:	89 d0                	mov    %edx,%eax
}
  8013a3:	5d                   	pop    %ebp
  8013a4:	c3                   	ret    

008013a5 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8013a5:	55                   	push   %ebp
  8013a6:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8013a8:	eb 09                	jmp    8013b3 <strncmp+0xe>
		n--, p++, q++;
  8013aa:	ff 4d 10             	decl   0x10(%ebp)
  8013ad:	ff 45 08             	incl   0x8(%ebp)
  8013b0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8013b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b7:	74 17                	je     8013d0 <strncmp+0x2b>
  8013b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bc:	8a 00                	mov    (%eax),%al
  8013be:	84 c0                	test   %al,%al
  8013c0:	74 0e                	je     8013d0 <strncmp+0x2b>
  8013c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c5:	8a 10                	mov    (%eax),%dl
  8013c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ca:	8a 00                	mov    (%eax),%al
  8013cc:	38 c2                	cmp    %al,%dl
  8013ce:	74 da                	je     8013aa <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8013d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013d4:	75 07                	jne    8013dd <strncmp+0x38>
		return 0;
  8013d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8013db:	eb 14                	jmp    8013f1 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e0:	8a 00                	mov    (%eax),%al
  8013e2:	0f b6 d0             	movzbl %al,%edx
  8013e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e8:	8a 00                	mov    (%eax),%al
  8013ea:	0f b6 c0             	movzbl %al,%eax
  8013ed:	29 c2                	sub    %eax,%edx
  8013ef:	89 d0                	mov    %edx,%eax
}
  8013f1:	5d                   	pop    %ebp
  8013f2:	c3                   	ret    

008013f3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
  8013f6:	83 ec 04             	sub    $0x4,%esp
  8013f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013ff:	eb 12                	jmp    801413 <strchr+0x20>
		if (*s == c)
  801401:	8b 45 08             	mov    0x8(%ebp),%eax
  801404:	8a 00                	mov    (%eax),%al
  801406:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801409:	75 05                	jne    801410 <strchr+0x1d>
			return (char *) s;
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	eb 11                	jmp    801421 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801410:	ff 45 08             	incl   0x8(%ebp)
  801413:	8b 45 08             	mov    0x8(%ebp),%eax
  801416:	8a 00                	mov    (%eax),%al
  801418:	84 c0                	test   %al,%al
  80141a:	75 e5                	jne    801401 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80141c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801421:	c9                   	leave  
  801422:	c3                   	ret    

00801423 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801423:	55                   	push   %ebp
  801424:	89 e5                	mov    %esp,%ebp
  801426:	83 ec 04             	sub    $0x4,%esp
  801429:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80142f:	eb 0d                	jmp    80143e <strfind+0x1b>
		if (*s == c)
  801431:	8b 45 08             	mov    0x8(%ebp),%eax
  801434:	8a 00                	mov    (%eax),%al
  801436:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801439:	74 0e                	je     801449 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80143b:	ff 45 08             	incl   0x8(%ebp)
  80143e:	8b 45 08             	mov    0x8(%ebp),%eax
  801441:	8a 00                	mov    (%eax),%al
  801443:	84 c0                	test   %al,%al
  801445:	75 ea                	jne    801431 <strfind+0xe>
  801447:	eb 01                	jmp    80144a <strfind+0x27>
		if (*s == c)
			break;
  801449:	90                   	nop
	return (char *) s;
  80144a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80144d:	c9                   	leave  
  80144e:	c3                   	ret    

0080144f <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80144f:	55                   	push   %ebp
  801450:	89 e5                	mov    %esp,%ebp
  801452:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801455:	8b 45 08             	mov    0x8(%ebp),%eax
  801458:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80145b:	8b 45 10             	mov    0x10(%ebp),%eax
  80145e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801461:	eb 0e                	jmp    801471 <memset+0x22>
		*p++ = c;
  801463:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801466:	8d 50 01             	lea    0x1(%eax),%edx
  801469:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80146c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80146f:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801471:	ff 4d f8             	decl   -0x8(%ebp)
  801474:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801478:	79 e9                	jns    801463 <memset+0x14>
		*p++ = c;

	return v;
  80147a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80147d:	c9                   	leave  
  80147e:	c3                   	ret    

0080147f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80147f:	55                   	push   %ebp
  801480:	89 e5                	mov    %esp,%ebp
  801482:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801485:	8b 45 0c             	mov    0xc(%ebp),%eax
  801488:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801491:	eb 16                	jmp    8014a9 <memcpy+0x2a>
		*d++ = *s++;
  801493:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801496:	8d 50 01             	lea    0x1(%eax),%edx
  801499:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80149c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80149f:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014a2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014a5:	8a 12                	mov    (%edx),%dl
  8014a7:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8014a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014af:	89 55 10             	mov    %edx,0x10(%ebp)
  8014b2:	85 c0                	test   %eax,%eax
  8014b4:	75 dd                	jne    801493 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8014b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014b9:	c9                   	leave  
  8014ba:	c3                   	ret    

008014bb <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  8014c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8014cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014d3:	73 50                	jae    801525 <memmove+0x6a>
  8014d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014db:	01 d0                	add    %edx,%eax
  8014dd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014e0:	76 43                	jbe    801525 <memmove+0x6a>
		s += n;
  8014e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e5:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8014e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014eb:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8014ee:	eb 10                	jmp    801500 <memmove+0x45>
			*--d = *--s;
  8014f0:	ff 4d f8             	decl   -0x8(%ebp)
  8014f3:	ff 4d fc             	decl   -0x4(%ebp)
  8014f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014f9:	8a 10                	mov    (%eax),%dl
  8014fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014fe:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801500:	8b 45 10             	mov    0x10(%ebp),%eax
  801503:	8d 50 ff             	lea    -0x1(%eax),%edx
  801506:	89 55 10             	mov    %edx,0x10(%ebp)
  801509:	85 c0                	test   %eax,%eax
  80150b:	75 e3                	jne    8014f0 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80150d:	eb 23                	jmp    801532 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80150f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801512:	8d 50 01             	lea    0x1(%eax),%edx
  801515:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801518:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80151b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80151e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801521:	8a 12                	mov    (%edx),%dl
  801523:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801525:	8b 45 10             	mov    0x10(%ebp),%eax
  801528:	8d 50 ff             	lea    -0x1(%eax),%edx
  80152b:	89 55 10             	mov    %edx,0x10(%ebp)
  80152e:	85 c0                	test   %eax,%eax
  801530:	75 dd                	jne    80150f <memmove+0x54>
			*d++ = *s++;

	return dst;
  801532:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801535:	c9                   	leave  
  801536:	c3                   	ret    

00801537 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
  80153a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80153d:	8b 45 08             	mov    0x8(%ebp),%eax
  801540:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801543:	8b 45 0c             	mov    0xc(%ebp),%eax
  801546:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801549:	eb 2a                	jmp    801575 <memcmp+0x3e>
		if (*s1 != *s2)
  80154b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80154e:	8a 10                	mov    (%eax),%dl
  801550:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801553:	8a 00                	mov    (%eax),%al
  801555:	38 c2                	cmp    %al,%dl
  801557:	74 16                	je     80156f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801559:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80155c:	8a 00                	mov    (%eax),%al
  80155e:	0f b6 d0             	movzbl %al,%edx
  801561:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801564:	8a 00                	mov    (%eax),%al
  801566:	0f b6 c0             	movzbl %al,%eax
  801569:	29 c2                	sub    %eax,%edx
  80156b:	89 d0                	mov    %edx,%eax
  80156d:	eb 18                	jmp    801587 <memcmp+0x50>
		s1++, s2++;
  80156f:	ff 45 fc             	incl   -0x4(%ebp)
  801572:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801575:	8b 45 10             	mov    0x10(%ebp),%eax
  801578:	8d 50 ff             	lea    -0x1(%eax),%edx
  80157b:	89 55 10             	mov    %edx,0x10(%ebp)
  80157e:	85 c0                	test   %eax,%eax
  801580:	75 c9                	jne    80154b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801582:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801587:	c9                   	leave  
  801588:	c3                   	ret    

00801589 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
  80158c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80158f:	8b 55 08             	mov    0x8(%ebp),%edx
  801592:	8b 45 10             	mov    0x10(%ebp),%eax
  801595:	01 d0                	add    %edx,%eax
  801597:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80159a:	eb 15                	jmp    8015b1 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	8a 00                	mov    (%eax),%al
  8015a1:	0f b6 d0             	movzbl %al,%edx
  8015a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a7:	0f b6 c0             	movzbl %al,%eax
  8015aa:	39 c2                	cmp    %eax,%edx
  8015ac:	74 0d                	je     8015bb <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015ae:	ff 45 08             	incl   0x8(%ebp)
  8015b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015b7:	72 e3                	jb     80159c <memfind+0x13>
  8015b9:	eb 01                	jmp    8015bc <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8015bb:	90                   	nop
	return (void *) s;
  8015bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015bf:	c9                   	leave  
  8015c0:	c3                   	ret    

008015c1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
  8015c4:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8015c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8015ce:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015d5:	eb 03                	jmp    8015da <strtol+0x19>
		s++;
  8015d7:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015da:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dd:	8a 00                	mov    (%eax),%al
  8015df:	3c 20                	cmp    $0x20,%al
  8015e1:	74 f4                	je     8015d7 <strtol+0x16>
  8015e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e6:	8a 00                	mov    (%eax),%al
  8015e8:	3c 09                	cmp    $0x9,%al
  8015ea:	74 eb                	je     8015d7 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ef:	8a 00                	mov    (%eax),%al
  8015f1:	3c 2b                	cmp    $0x2b,%al
  8015f3:	75 05                	jne    8015fa <strtol+0x39>
		s++;
  8015f5:	ff 45 08             	incl   0x8(%ebp)
  8015f8:	eb 13                	jmp    80160d <strtol+0x4c>
	else if (*s == '-')
  8015fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fd:	8a 00                	mov    (%eax),%al
  8015ff:	3c 2d                	cmp    $0x2d,%al
  801601:	75 0a                	jne    80160d <strtol+0x4c>
		s++, neg = 1;
  801603:	ff 45 08             	incl   0x8(%ebp)
  801606:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80160d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801611:	74 06                	je     801619 <strtol+0x58>
  801613:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801617:	75 20                	jne    801639 <strtol+0x78>
  801619:	8b 45 08             	mov    0x8(%ebp),%eax
  80161c:	8a 00                	mov    (%eax),%al
  80161e:	3c 30                	cmp    $0x30,%al
  801620:	75 17                	jne    801639 <strtol+0x78>
  801622:	8b 45 08             	mov    0x8(%ebp),%eax
  801625:	40                   	inc    %eax
  801626:	8a 00                	mov    (%eax),%al
  801628:	3c 78                	cmp    $0x78,%al
  80162a:	75 0d                	jne    801639 <strtol+0x78>
		s += 2, base = 16;
  80162c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801630:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801637:	eb 28                	jmp    801661 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801639:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80163d:	75 15                	jne    801654 <strtol+0x93>
  80163f:	8b 45 08             	mov    0x8(%ebp),%eax
  801642:	8a 00                	mov    (%eax),%al
  801644:	3c 30                	cmp    $0x30,%al
  801646:	75 0c                	jne    801654 <strtol+0x93>
		s++, base = 8;
  801648:	ff 45 08             	incl   0x8(%ebp)
  80164b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801652:	eb 0d                	jmp    801661 <strtol+0xa0>
	else if (base == 0)
  801654:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801658:	75 07                	jne    801661 <strtol+0xa0>
		base = 10;
  80165a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801661:	8b 45 08             	mov    0x8(%ebp),%eax
  801664:	8a 00                	mov    (%eax),%al
  801666:	3c 2f                	cmp    $0x2f,%al
  801668:	7e 19                	jle    801683 <strtol+0xc2>
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	8a 00                	mov    (%eax),%al
  80166f:	3c 39                	cmp    $0x39,%al
  801671:	7f 10                	jg     801683 <strtol+0xc2>
			dig = *s - '0';
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	8a 00                	mov    (%eax),%al
  801678:	0f be c0             	movsbl %al,%eax
  80167b:	83 e8 30             	sub    $0x30,%eax
  80167e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801681:	eb 42                	jmp    8016c5 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801683:	8b 45 08             	mov    0x8(%ebp),%eax
  801686:	8a 00                	mov    (%eax),%al
  801688:	3c 60                	cmp    $0x60,%al
  80168a:	7e 19                	jle    8016a5 <strtol+0xe4>
  80168c:	8b 45 08             	mov    0x8(%ebp),%eax
  80168f:	8a 00                	mov    (%eax),%al
  801691:	3c 7a                	cmp    $0x7a,%al
  801693:	7f 10                	jg     8016a5 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801695:	8b 45 08             	mov    0x8(%ebp),%eax
  801698:	8a 00                	mov    (%eax),%al
  80169a:	0f be c0             	movsbl %al,%eax
  80169d:	83 e8 57             	sub    $0x57,%eax
  8016a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016a3:	eb 20                	jmp    8016c5 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8016a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a8:	8a 00                	mov    (%eax),%al
  8016aa:	3c 40                	cmp    $0x40,%al
  8016ac:	7e 39                	jle    8016e7 <strtol+0x126>
  8016ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b1:	8a 00                	mov    (%eax),%al
  8016b3:	3c 5a                	cmp    $0x5a,%al
  8016b5:	7f 30                	jg     8016e7 <strtol+0x126>
			dig = *s - 'A' + 10;
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ba:	8a 00                	mov    (%eax),%al
  8016bc:	0f be c0             	movsbl %al,%eax
  8016bf:	83 e8 37             	sub    $0x37,%eax
  8016c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8016c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c8:	3b 45 10             	cmp    0x10(%ebp),%eax
  8016cb:	7d 19                	jge    8016e6 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8016cd:	ff 45 08             	incl   0x8(%ebp)
  8016d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016d3:	0f af 45 10          	imul   0x10(%ebp),%eax
  8016d7:	89 c2                	mov    %eax,%edx
  8016d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016dc:	01 d0                	add    %edx,%eax
  8016de:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8016e1:	e9 7b ff ff ff       	jmp    801661 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016e6:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016eb:	74 08                	je     8016f5 <strtol+0x134>
		*endptr = (char *) s;
  8016ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8016f3:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8016f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016f9:	74 07                	je     801702 <strtol+0x141>
  8016fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016fe:	f7 d8                	neg    %eax
  801700:	eb 03                	jmp    801705 <strtol+0x144>
  801702:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801705:	c9                   	leave  
  801706:	c3                   	ret    

00801707 <ltostr>:

void
ltostr(long value, char *str)
{
  801707:	55                   	push   %ebp
  801708:	89 e5                	mov    %esp,%ebp
  80170a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80170d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801714:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80171b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80171f:	79 13                	jns    801734 <ltostr+0x2d>
	{
		neg = 1;
  801721:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801728:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80172e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801731:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801734:	8b 45 08             	mov    0x8(%ebp),%eax
  801737:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80173c:	99                   	cltd   
  80173d:	f7 f9                	idiv   %ecx
  80173f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801742:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801745:	8d 50 01             	lea    0x1(%eax),%edx
  801748:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80174b:	89 c2                	mov    %eax,%edx
  80174d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801750:	01 d0                	add    %edx,%eax
  801752:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801755:	83 c2 30             	add    $0x30,%edx
  801758:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80175a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80175d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801762:	f7 e9                	imul   %ecx
  801764:	c1 fa 02             	sar    $0x2,%edx
  801767:	89 c8                	mov    %ecx,%eax
  801769:	c1 f8 1f             	sar    $0x1f,%eax
  80176c:	29 c2                	sub    %eax,%edx
  80176e:	89 d0                	mov    %edx,%eax
  801770:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801773:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801776:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80177b:	f7 e9                	imul   %ecx
  80177d:	c1 fa 02             	sar    $0x2,%edx
  801780:	89 c8                	mov    %ecx,%eax
  801782:	c1 f8 1f             	sar    $0x1f,%eax
  801785:	29 c2                	sub    %eax,%edx
  801787:	89 d0                	mov    %edx,%eax
  801789:	c1 e0 02             	shl    $0x2,%eax
  80178c:	01 d0                	add    %edx,%eax
  80178e:	01 c0                	add    %eax,%eax
  801790:	29 c1                	sub    %eax,%ecx
  801792:	89 ca                	mov    %ecx,%edx
  801794:	85 d2                	test   %edx,%edx
  801796:	75 9c                	jne    801734 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801798:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80179f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017a2:	48                   	dec    %eax
  8017a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8017a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017aa:	74 3d                	je     8017e9 <ltostr+0xe2>
		start = 1 ;
  8017ac:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8017b3:	eb 34                	jmp    8017e9 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8017b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bb:	01 d0                	add    %edx,%eax
  8017bd:	8a 00                	mov    (%eax),%al
  8017bf:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c8:	01 c2                	add    %eax,%edx
  8017ca:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d0:	01 c8                	add    %ecx,%eax
  8017d2:	8a 00                	mov    (%eax),%al
  8017d4:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8017d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017dc:	01 c2                	add    %eax,%edx
  8017de:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017e1:	88 02                	mov    %al,(%edx)
		start++ ;
  8017e3:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8017e6:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8017e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017ef:	7c c4                	jl     8017b5 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8017f1:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8017f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f7:	01 d0                	add    %edx,%eax
  8017f9:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8017fc:	90                   	nop
  8017fd:	c9                   	leave  
  8017fe:	c3                   	ret    

008017ff <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
  801802:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801805:	ff 75 08             	pushl  0x8(%ebp)
  801808:	e8 54 fa ff ff       	call   801261 <strlen>
  80180d:	83 c4 04             	add    $0x4,%esp
  801810:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801813:	ff 75 0c             	pushl  0xc(%ebp)
  801816:	e8 46 fa ff ff       	call   801261 <strlen>
  80181b:	83 c4 04             	add    $0x4,%esp
  80181e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801821:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801828:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80182f:	eb 17                	jmp    801848 <strcconcat+0x49>
		final[s] = str1[s] ;
  801831:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801834:	8b 45 10             	mov    0x10(%ebp),%eax
  801837:	01 c2                	add    %eax,%edx
  801839:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80183c:	8b 45 08             	mov    0x8(%ebp),%eax
  80183f:	01 c8                	add    %ecx,%eax
  801841:	8a 00                	mov    (%eax),%al
  801843:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801845:	ff 45 fc             	incl   -0x4(%ebp)
  801848:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80184b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80184e:	7c e1                	jl     801831 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801850:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801857:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80185e:	eb 1f                	jmp    80187f <strcconcat+0x80>
		final[s++] = str2[i] ;
  801860:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801863:	8d 50 01             	lea    0x1(%eax),%edx
  801866:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801869:	89 c2                	mov    %eax,%edx
  80186b:	8b 45 10             	mov    0x10(%ebp),%eax
  80186e:	01 c2                	add    %eax,%edx
  801870:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801873:	8b 45 0c             	mov    0xc(%ebp),%eax
  801876:	01 c8                	add    %ecx,%eax
  801878:	8a 00                	mov    (%eax),%al
  80187a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80187c:	ff 45 f8             	incl   -0x8(%ebp)
  80187f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801882:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801885:	7c d9                	jl     801860 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801887:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80188a:	8b 45 10             	mov    0x10(%ebp),%eax
  80188d:	01 d0                	add    %edx,%eax
  80188f:	c6 00 00             	movb   $0x0,(%eax)
}
  801892:	90                   	nop
  801893:	c9                   	leave  
  801894:	c3                   	ret    

00801895 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801898:	8b 45 14             	mov    0x14(%ebp),%eax
  80189b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8018a4:	8b 00                	mov    (%eax),%eax
  8018a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b0:	01 d0                	add    %edx,%eax
  8018b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018b8:	eb 0c                	jmp    8018c6 <strsplit+0x31>
			*string++ = 0;
  8018ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bd:	8d 50 01             	lea    0x1(%eax),%edx
  8018c0:	89 55 08             	mov    %edx,0x8(%ebp)
  8018c3:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c9:	8a 00                	mov    (%eax),%al
  8018cb:	84 c0                	test   %al,%al
  8018cd:	74 18                	je     8018e7 <strsplit+0x52>
  8018cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d2:	8a 00                	mov    (%eax),%al
  8018d4:	0f be c0             	movsbl %al,%eax
  8018d7:	50                   	push   %eax
  8018d8:	ff 75 0c             	pushl  0xc(%ebp)
  8018db:	e8 13 fb ff ff       	call   8013f3 <strchr>
  8018e0:	83 c4 08             	add    $0x8,%esp
  8018e3:	85 c0                	test   %eax,%eax
  8018e5:	75 d3                	jne    8018ba <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  8018e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ea:	8a 00                	mov    (%eax),%al
  8018ec:	84 c0                	test   %al,%al
  8018ee:	74 5a                	je     80194a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  8018f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f3:	8b 00                	mov    (%eax),%eax
  8018f5:	83 f8 0f             	cmp    $0xf,%eax
  8018f8:	75 07                	jne    801901 <strsplit+0x6c>
		{
			return 0;
  8018fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ff:	eb 66                	jmp    801967 <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801901:	8b 45 14             	mov    0x14(%ebp),%eax
  801904:	8b 00                	mov    (%eax),%eax
  801906:	8d 48 01             	lea    0x1(%eax),%ecx
  801909:	8b 55 14             	mov    0x14(%ebp),%edx
  80190c:	89 0a                	mov    %ecx,(%edx)
  80190e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801915:	8b 45 10             	mov    0x10(%ebp),%eax
  801918:	01 c2                	add    %eax,%edx
  80191a:	8b 45 08             	mov    0x8(%ebp),%eax
  80191d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80191f:	eb 03                	jmp    801924 <strsplit+0x8f>
			string++;
  801921:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801924:	8b 45 08             	mov    0x8(%ebp),%eax
  801927:	8a 00                	mov    (%eax),%al
  801929:	84 c0                	test   %al,%al
  80192b:	74 8b                	je     8018b8 <strsplit+0x23>
  80192d:	8b 45 08             	mov    0x8(%ebp),%eax
  801930:	8a 00                	mov    (%eax),%al
  801932:	0f be c0             	movsbl %al,%eax
  801935:	50                   	push   %eax
  801936:	ff 75 0c             	pushl  0xc(%ebp)
  801939:	e8 b5 fa ff ff       	call   8013f3 <strchr>
  80193e:	83 c4 08             	add    $0x8,%esp
  801941:	85 c0                	test   %eax,%eax
  801943:	74 dc                	je     801921 <strsplit+0x8c>
			string++;
	}
  801945:	e9 6e ff ff ff       	jmp    8018b8 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80194a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80194b:	8b 45 14             	mov    0x14(%ebp),%eax
  80194e:	8b 00                	mov    (%eax),%eax
  801950:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801957:	8b 45 10             	mov    0x10(%ebp),%eax
  80195a:	01 d0                	add    %edx,%eax
  80195c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801962:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
  80196c:	57                   	push   %edi
  80196d:	56                   	push   %esi
  80196e:	53                   	push   %ebx
  80196f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801972:	8b 45 08             	mov    0x8(%ebp),%eax
  801975:	8b 55 0c             	mov    0xc(%ebp),%edx
  801978:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80197b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80197e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801981:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801984:	cd 30                	int    $0x30
  801986:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801989:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80198c:	83 c4 10             	add    $0x10,%esp
  80198f:	5b                   	pop    %ebx
  801990:	5e                   	pop    %esi
  801991:	5f                   	pop    %edi
  801992:	5d                   	pop    %ebp
  801993:	c3                   	ret    

00801994 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  801997:	8b 45 08             	mov    0x8(%ebp),%eax
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	ff 75 0c             	pushl  0xc(%ebp)
  8019a3:	50                   	push   %eax
  8019a4:	6a 00                	push   $0x0
  8019a6:	e8 be ff ff ff       	call   801969 <syscall>
  8019ab:	83 c4 18             	add    $0x18,%esp
}
  8019ae:	90                   	nop
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 01                	push   $0x1
  8019c0:	e8 a4 ff ff ff       	call   801969 <syscall>
  8019c5:	83 c4 18             	add    $0x18,%esp
}
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8019cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	50                   	push   %eax
  8019d9:	6a 03                	push   $0x3
  8019db:	e8 89 ff ff ff       	call   801969 <syscall>
  8019e0:	83 c4 18             	add    $0x18,%esp
}
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 02                	push   $0x2
  8019f4:	e8 70 ff ff ff       	call   801969 <syscall>
  8019f9:	83 c4 18             	add    $0x18,%esp
}
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <sys_env_exit>:

void sys_env_exit(void)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 04                	push   $0x4
  801a0d:	e8 57 ff ff ff       	call   801969 <syscall>
  801a12:	83 c4 18             	add    $0x18,%esp
}
  801a15:	90                   	nop
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	52                   	push   %edx
  801a28:	50                   	push   %eax
  801a29:	6a 05                	push   $0x5
  801a2b:	e8 39 ff ff ff       	call   801969 <syscall>
  801a30:	83 c4 18             	add    $0x18,%esp
}
  801a33:	c9                   	leave  
  801a34:	c3                   	ret    

00801a35 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
  801a38:	56                   	push   %esi
  801a39:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a3a:	8b 75 18             	mov    0x18(%ebp),%esi
  801a3d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a40:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	56                   	push   %esi
  801a4a:	53                   	push   %ebx
  801a4b:	51                   	push   %ecx
  801a4c:	52                   	push   %edx
  801a4d:	50                   	push   %eax
  801a4e:	6a 06                	push   $0x6
  801a50:	e8 14 ff ff ff       	call   801969 <syscall>
  801a55:	83 c4 18             	add    $0x18,%esp
}
  801a58:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a5b:	5b                   	pop    %ebx
  801a5c:	5e                   	pop    %esi
  801a5d:	5d                   	pop    %ebp
  801a5e:	c3                   	ret    

00801a5f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a65:	8b 45 08             	mov    0x8(%ebp),%eax
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	52                   	push   %edx
  801a6f:	50                   	push   %eax
  801a70:	6a 07                	push   $0x7
  801a72:	e8 f2 fe ff ff       	call   801969 <syscall>
  801a77:	83 c4 18             	add    $0x18,%esp
}
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	ff 75 0c             	pushl  0xc(%ebp)
  801a88:	ff 75 08             	pushl  0x8(%ebp)
  801a8b:	6a 08                	push   $0x8
  801a8d:	e8 d7 fe ff ff       	call   801969 <syscall>
  801a92:	83 c4 18             	add    $0x18,%esp
}
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 09                	push   $0x9
  801aa6:	e8 be fe ff ff       	call   801969 <syscall>
  801aab:	83 c4 18             	add    $0x18,%esp
}
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 0a                	push   $0xa
  801abf:	e8 a5 fe ff ff       	call   801969 <syscall>
  801ac4:	83 c4 18             	add    $0x18,%esp
}
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 0b                	push   $0xb
  801ad8:	e8 8c fe ff ff       	call   801969 <syscall>
  801add:	83 c4 18             	add    $0x18,%esp
}
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	ff 75 0c             	pushl  0xc(%ebp)
  801aee:	ff 75 08             	pushl  0x8(%ebp)
  801af1:	6a 0d                	push   $0xd
  801af3:	e8 71 fe ff ff       	call   801969 <syscall>
  801af8:	83 c4 18             	add    $0x18,%esp
	return;
  801afb:	90                   	nop
}
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	ff 75 0c             	pushl  0xc(%ebp)
  801b0a:	ff 75 08             	pushl  0x8(%ebp)
  801b0d:	6a 0e                	push   $0xe
  801b0f:	e8 55 fe ff ff       	call   801969 <syscall>
  801b14:	83 c4 18             	add    $0x18,%esp
	return ;
  801b17:	90                   	nop
}
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 0c                	push   $0xc
  801b29:	e8 3b fe ff ff       	call   801969 <syscall>
  801b2e:	83 c4 18             	add    $0x18,%esp
}
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 10                	push   $0x10
  801b42:	e8 22 fe ff ff       	call   801969 <syscall>
  801b47:	83 c4 18             	add    $0x18,%esp
}
  801b4a:	90                   	nop
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    

00801b4d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 11                	push   $0x11
  801b5c:	e8 08 fe ff ff       	call   801969 <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
}
  801b64:	90                   	nop
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
  801b6a:	83 ec 04             	sub    $0x4,%esp
  801b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b70:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b73:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	50                   	push   %eax
  801b80:	6a 12                	push   $0x12
  801b82:	e8 e2 fd ff ff       	call   801969 <syscall>
  801b87:	83 c4 18             	add    $0x18,%esp
}
  801b8a:	90                   	nop
  801b8b:	c9                   	leave  
  801b8c:	c3                   	ret    

00801b8d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 13                	push   $0x13
  801b9c:	e8 c8 fd ff ff       	call   801969 <syscall>
  801ba1:	83 c4 18             	add    $0x18,%esp
}
  801ba4:	90                   	nop
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801baa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	ff 75 0c             	pushl  0xc(%ebp)
  801bb6:	50                   	push   %eax
  801bb7:	6a 14                	push   $0x14
  801bb9:	e8 ab fd ff ff       	call   801969 <syscall>
  801bbe:	83 c4 18             	add    $0x18,%esp
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  801bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	50                   	push   %eax
  801bd2:	6a 17                	push   $0x17
  801bd4:	e8 90 fd ff ff       	call   801969 <syscall>
  801bd9:	83 c4 18             	add    $0x18,%esp
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  801be1:	8b 45 08             	mov    0x8(%ebp),%eax
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	50                   	push   %eax
  801bed:	6a 15                	push   $0x15
  801bef:	e8 75 fd ff ff       	call   801969 <syscall>
  801bf4:	83 c4 18             	add    $0x18,%esp
}
  801bf7:	90                   	nop
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  801bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	50                   	push   %eax
  801c09:	6a 16                	push   $0x16
  801c0b:	e8 59 fd ff ff       	call   801969 <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
}
  801c13:	90                   	nop
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	83 ec 04             	sub    $0x4,%esp
  801c1c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c1f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  801c22:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c25:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	6a 00                	push   $0x0
  801c2e:	51                   	push   %ecx
  801c2f:	52                   	push   %edx
  801c30:	ff 75 0c             	pushl  0xc(%ebp)
  801c33:	50                   	push   %eax
  801c34:	6a 18                	push   $0x18
  801c36:	e8 2e fd ff ff       	call   801969 <syscall>
  801c3b:	83 c4 18             	add    $0x18,%esp
}
  801c3e:	c9                   	leave  
  801c3f:	c3                   	ret    

00801c40 <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  801c43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	52                   	push   %edx
  801c50:	50                   	push   %eax
  801c51:	6a 19                	push   $0x19
  801c53:	e8 11 fd ff ff       	call   801969 <syscall>
  801c58:	83 c4 18             	add    $0x18,%esp
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  801c60:	8b 45 08             	mov    0x8(%ebp),%eax
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	50                   	push   %eax
  801c6c:	6a 1a                	push   $0x1a
  801c6e:	e8 f6 fc ff ff       	call   801969 <syscall>
  801c73:	83 c4 18             	add    $0x18,%esp
}
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 1b                	push   $0x1b
  801c87:	e8 dd fc ff ff       	call   801969 <syscall>
  801c8c:	83 c4 18             	add    $0x18,%esp
}
  801c8f:	c9                   	leave  
  801c90:	c3                   	ret    

00801c91 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 1c                	push   $0x1c
  801ca0:	e8 c4 fc ff ff       	call   801969 <syscall>
  801ca5:	83 c4 18             	add    $0x18,%esp
}
  801ca8:	c9                   	leave  
  801ca9:	c3                   	ret    

00801caa <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  801caa:	55                   	push   %ebp
  801cab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  801cad:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	ff 75 0c             	pushl  0xc(%ebp)
  801cb9:	50                   	push   %eax
  801cba:	6a 1d                	push   $0x1d
  801cbc:	e8 a8 fc ff ff       	call   801969 <syscall>
  801cc1:	83 c4 18             	add    $0x18,%esp
}
  801cc4:	c9                   	leave  
  801cc5:	c3                   	ret    

00801cc6 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	50                   	push   %eax
  801cd5:	6a 1e                	push   $0x1e
  801cd7:	e8 8d fc ff ff       	call   801969 <syscall>
  801cdc:	83 c4 18             	add    $0x18,%esp
}
  801cdf:	90                   	nop
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	50                   	push   %eax
  801cf1:	6a 1f                	push   $0x1f
  801cf3:	e8 71 fc ff ff       	call   801969 <syscall>
  801cf8:	83 c4 18             	add    $0x18,%esp
}
  801cfb:	90                   	nop
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
  801d01:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d04:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d07:	8d 50 04             	lea    0x4(%eax),%edx
  801d0a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	52                   	push   %edx
  801d14:	50                   	push   %eax
  801d15:	6a 20                	push   $0x20
  801d17:	e8 4d fc ff ff       	call   801969 <syscall>
  801d1c:	83 c4 18             	add    $0x18,%esp
	return result;
  801d1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d22:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d25:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d28:	89 01                	mov    %eax,(%ecx)
  801d2a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d30:	c9                   	leave  
  801d31:	c2 04 00             	ret    $0x4

00801d34 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	ff 75 10             	pushl  0x10(%ebp)
  801d3e:	ff 75 0c             	pushl  0xc(%ebp)
  801d41:	ff 75 08             	pushl  0x8(%ebp)
  801d44:	6a 0f                	push   $0xf
  801d46:	e8 1e fc ff ff       	call   801969 <syscall>
  801d4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4e:	90                   	nop
}
  801d4f:	c9                   	leave  
  801d50:	c3                   	ret    

00801d51 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 21                	push   $0x21
  801d60:	e8 04 fc ff ff       	call   801969 <syscall>
  801d65:	83 c4 18             	add    $0x18,%esp
}
  801d68:	c9                   	leave  
  801d69:	c3                   	ret    

00801d6a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
  801d6d:	83 ec 04             	sub    $0x4,%esp
  801d70:	8b 45 08             	mov    0x8(%ebp),%eax
  801d73:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d76:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	50                   	push   %eax
  801d83:	6a 22                	push   $0x22
  801d85:	e8 df fb ff ff       	call   801969 <syscall>
  801d8a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d8d:	90                   	nop
}
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <rsttst>:
void rsttst()
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 24                	push   $0x24
  801d9f:	e8 c5 fb ff ff       	call   801969 <syscall>
  801da4:	83 c4 18             	add    $0x18,%esp
	return ;
  801da7:	90                   	nop
}
  801da8:	c9                   	leave  
  801da9:	c3                   	ret    

00801daa <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
  801dad:	83 ec 04             	sub    $0x4,%esp
  801db0:	8b 45 14             	mov    0x14(%ebp),%eax
  801db3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801db6:	8b 55 18             	mov    0x18(%ebp),%edx
  801db9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dbd:	52                   	push   %edx
  801dbe:	50                   	push   %eax
  801dbf:	ff 75 10             	pushl  0x10(%ebp)
  801dc2:	ff 75 0c             	pushl  0xc(%ebp)
  801dc5:	ff 75 08             	pushl  0x8(%ebp)
  801dc8:	6a 23                	push   $0x23
  801dca:	e8 9a fb ff ff       	call   801969 <syscall>
  801dcf:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd2:	90                   	nop
}
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    

00801dd5 <chktst>:
void chktst(uint32 n)
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	ff 75 08             	pushl  0x8(%ebp)
  801de3:	6a 25                	push   $0x25
  801de5:	e8 7f fb ff ff       	call   801969 <syscall>
  801dea:	83 c4 18             	add    $0x18,%esp
	return ;
  801ded:	90                   	nop
}
  801dee:	c9                   	leave  
  801def:	c3                   	ret    

00801df0 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
  801df3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 26                	push   $0x26
  801e02:	e8 62 fb ff ff       	call   801969 <syscall>
  801e07:	83 c4 18             	add    $0x18,%esp
  801e0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e0d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e11:	75 07                	jne    801e1a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e13:	b8 01 00 00 00       	mov    $0x1,%eax
  801e18:	eb 05                	jmp    801e1f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
  801e24:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 26                	push   $0x26
  801e33:	e8 31 fb ff ff       	call   801969 <syscall>
  801e38:	83 c4 18             	add    $0x18,%esp
  801e3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e3e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e42:	75 07                	jne    801e4b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e44:	b8 01 00 00 00       	mov    $0x1,%eax
  801e49:	eb 05                	jmp    801e50 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
  801e55:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 26                	push   $0x26
  801e64:	e8 00 fb ff ff       	call   801969 <syscall>
  801e69:	83 c4 18             	add    $0x18,%esp
  801e6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e6f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e73:	75 07                	jne    801e7c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e75:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7a:	eb 05                	jmp    801e81 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e81:	c9                   	leave  
  801e82:	c3                   	ret    

00801e83 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
  801e86:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 26                	push   $0x26
  801e95:	e8 cf fa ff ff       	call   801969 <syscall>
  801e9a:	83 c4 18             	add    $0x18,%esp
  801e9d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ea0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ea4:	75 07                	jne    801ead <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ea6:	b8 01 00 00 00       	mov    $0x1,%eax
  801eab:	eb 05                	jmp    801eb2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ead:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb2:	c9                   	leave  
  801eb3:	c3                   	ret    

00801eb4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801eb4:	55                   	push   %ebp
  801eb5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	ff 75 08             	pushl  0x8(%ebp)
  801ec2:	6a 27                	push   $0x27
  801ec4:	e8 a0 fa ff ff       	call   801969 <syscall>
  801ec9:	83 c4 18             	add    $0x18,%esp
	return ;
  801ecc:	90                   	nop
}
  801ecd:	c9                   	leave  
  801ece:	c3                   	ret    
  801ecf:	90                   	nop

00801ed0 <__udivdi3>:
  801ed0:	55                   	push   %ebp
  801ed1:	57                   	push   %edi
  801ed2:	56                   	push   %esi
  801ed3:	53                   	push   %ebx
  801ed4:	83 ec 1c             	sub    $0x1c,%esp
  801ed7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801edb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801edf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ee3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ee7:	89 ca                	mov    %ecx,%edx
  801ee9:	89 f8                	mov    %edi,%eax
  801eeb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801eef:	85 f6                	test   %esi,%esi
  801ef1:	75 2d                	jne    801f20 <__udivdi3+0x50>
  801ef3:	39 cf                	cmp    %ecx,%edi
  801ef5:	77 65                	ja     801f5c <__udivdi3+0x8c>
  801ef7:	89 fd                	mov    %edi,%ebp
  801ef9:	85 ff                	test   %edi,%edi
  801efb:	75 0b                	jne    801f08 <__udivdi3+0x38>
  801efd:	b8 01 00 00 00       	mov    $0x1,%eax
  801f02:	31 d2                	xor    %edx,%edx
  801f04:	f7 f7                	div    %edi
  801f06:	89 c5                	mov    %eax,%ebp
  801f08:	31 d2                	xor    %edx,%edx
  801f0a:	89 c8                	mov    %ecx,%eax
  801f0c:	f7 f5                	div    %ebp
  801f0e:	89 c1                	mov    %eax,%ecx
  801f10:	89 d8                	mov    %ebx,%eax
  801f12:	f7 f5                	div    %ebp
  801f14:	89 cf                	mov    %ecx,%edi
  801f16:	89 fa                	mov    %edi,%edx
  801f18:	83 c4 1c             	add    $0x1c,%esp
  801f1b:	5b                   	pop    %ebx
  801f1c:	5e                   	pop    %esi
  801f1d:	5f                   	pop    %edi
  801f1e:	5d                   	pop    %ebp
  801f1f:	c3                   	ret    
  801f20:	39 ce                	cmp    %ecx,%esi
  801f22:	77 28                	ja     801f4c <__udivdi3+0x7c>
  801f24:	0f bd fe             	bsr    %esi,%edi
  801f27:	83 f7 1f             	xor    $0x1f,%edi
  801f2a:	75 40                	jne    801f6c <__udivdi3+0x9c>
  801f2c:	39 ce                	cmp    %ecx,%esi
  801f2e:	72 0a                	jb     801f3a <__udivdi3+0x6a>
  801f30:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801f34:	0f 87 9e 00 00 00    	ja     801fd8 <__udivdi3+0x108>
  801f3a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f3f:	89 fa                	mov    %edi,%edx
  801f41:	83 c4 1c             	add    $0x1c,%esp
  801f44:	5b                   	pop    %ebx
  801f45:	5e                   	pop    %esi
  801f46:	5f                   	pop    %edi
  801f47:	5d                   	pop    %ebp
  801f48:	c3                   	ret    
  801f49:	8d 76 00             	lea    0x0(%esi),%esi
  801f4c:	31 ff                	xor    %edi,%edi
  801f4e:	31 c0                	xor    %eax,%eax
  801f50:	89 fa                	mov    %edi,%edx
  801f52:	83 c4 1c             	add    $0x1c,%esp
  801f55:	5b                   	pop    %ebx
  801f56:	5e                   	pop    %esi
  801f57:	5f                   	pop    %edi
  801f58:	5d                   	pop    %ebp
  801f59:	c3                   	ret    
  801f5a:	66 90                	xchg   %ax,%ax
  801f5c:	89 d8                	mov    %ebx,%eax
  801f5e:	f7 f7                	div    %edi
  801f60:	31 ff                	xor    %edi,%edi
  801f62:	89 fa                	mov    %edi,%edx
  801f64:	83 c4 1c             	add    $0x1c,%esp
  801f67:	5b                   	pop    %ebx
  801f68:	5e                   	pop    %esi
  801f69:	5f                   	pop    %edi
  801f6a:	5d                   	pop    %ebp
  801f6b:	c3                   	ret    
  801f6c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801f71:	89 eb                	mov    %ebp,%ebx
  801f73:	29 fb                	sub    %edi,%ebx
  801f75:	89 f9                	mov    %edi,%ecx
  801f77:	d3 e6                	shl    %cl,%esi
  801f79:	89 c5                	mov    %eax,%ebp
  801f7b:	88 d9                	mov    %bl,%cl
  801f7d:	d3 ed                	shr    %cl,%ebp
  801f7f:	89 e9                	mov    %ebp,%ecx
  801f81:	09 f1                	or     %esi,%ecx
  801f83:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801f87:	89 f9                	mov    %edi,%ecx
  801f89:	d3 e0                	shl    %cl,%eax
  801f8b:	89 c5                	mov    %eax,%ebp
  801f8d:	89 d6                	mov    %edx,%esi
  801f8f:	88 d9                	mov    %bl,%cl
  801f91:	d3 ee                	shr    %cl,%esi
  801f93:	89 f9                	mov    %edi,%ecx
  801f95:	d3 e2                	shl    %cl,%edx
  801f97:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f9b:	88 d9                	mov    %bl,%cl
  801f9d:	d3 e8                	shr    %cl,%eax
  801f9f:	09 c2                	or     %eax,%edx
  801fa1:	89 d0                	mov    %edx,%eax
  801fa3:	89 f2                	mov    %esi,%edx
  801fa5:	f7 74 24 0c          	divl   0xc(%esp)
  801fa9:	89 d6                	mov    %edx,%esi
  801fab:	89 c3                	mov    %eax,%ebx
  801fad:	f7 e5                	mul    %ebp
  801faf:	39 d6                	cmp    %edx,%esi
  801fb1:	72 19                	jb     801fcc <__udivdi3+0xfc>
  801fb3:	74 0b                	je     801fc0 <__udivdi3+0xf0>
  801fb5:	89 d8                	mov    %ebx,%eax
  801fb7:	31 ff                	xor    %edi,%edi
  801fb9:	e9 58 ff ff ff       	jmp    801f16 <__udivdi3+0x46>
  801fbe:	66 90                	xchg   %ax,%ax
  801fc0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801fc4:	89 f9                	mov    %edi,%ecx
  801fc6:	d3 e2                	shl    %cl,%edx
  801fc8:	39 c2                	cmp    %eax,%edx
  801fca:	73 e9                	jae    801fb5 <__udivdi3+0xe5>
  801fcc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801fcf:	31 ff                	xor    %edi,%edi
  801fd1:	e9 40 ff ff ff       	jmp    801f16 <__udivdi3+0x46>
  801fd6:	66 90                	xchg   %ax,%ax
  801fd8:	31 c0                	xor    %eax,%eax
  801fda:	e9 37 ff ff ff       	jmp    801f16 <__udivdi3+0x46>
  801fdf:	90                   	nop

00801fe0 <__umoddi3>:
  801fe0:	55                   	push   %ebp
  801fe1:	57                   	push   %edi
  801fe2:	56                   	push   %esi
  801fe3:	53                   	push   %ebx
  801fe4:	83 ec 1c             	sub    $0x1c,%esp
  801fe7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801feb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801fef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ff3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ff7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ffb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fff:	89 f3                	mov    %esi,%ebx
  802001:	89 fa                	mov    %edi,%edx
  802003:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802007:	89 34 24             	mov    %esi,(%esp)
  80200a:	85 c0                	test   %eax,%eax
  80200c:	75 1a                	jne    802028 <__umoddi3+0x48>
  80200e:	39 f7                	cmp    %esi,%edi
  802010:	0f 86 a2 00 00 00    	jbe    8020b8 <__umoddi3+0xd8>
  802016:	89 c8                	mov    %ecx,%eax
  802018:	89 f2                	mov    %esi,%edx
  80201a:	f7 f7                	div    %edi
  80201c:	89 d0                	mov    %edx,%eax
  80201e:	31 d2                	xor    %edx,%edx
  802020:	83 c4 1c             	add    $0x1c,%esp
  802023:	5b                   	pop    %ebx
  802024:	5e                   	pop    %esi
  802025:	5f                   	pop    %edi
  802026:	5d                   	pop    %ebp
  802027:	c3                   	ret    
  802028:	39 f0                	cmp    %esi,%eax
  80202a:	0f 87 ac 00 00 00    	ja     8020dc <__umoddi3+0xfc>
  802030:	0f bd e8             	bsr    %eax,%ebp
  802033:	83 f5 1f             	xor    $0x1f,%ebp
  802036:	0f 84 ac 00 00 00    	je     8020e8 <__umoddi3+0x108>
  80203c:	bf 20 00 00 00       	mov    $0x20,%edi
  802041:	29 ef                	sub    %ebp,%edi
  802043:	89 fe                	mov    %edi,%esi
  802045:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802049:	89 e9                	mov    %ebp,%ecx
  80204b:	d3 e0                	shl    %cl,%eax
  80204d:	89 d7                	mov    %edx,%edi
  80204f:	89 f1                	mov    %esi,%ecx
  802051:	d3 ef                	shr    %cl,%edi
  802053:	09 c7                	or     %eax,%edi
  802055:	89 e9                	mov    %ebp,%ecx
  802057:	d3 e2                	shl    %cl,%edx
  802059:	89 14 24             	mov    %edx,(%esp)
  80205c:	89 d8                	mov    %ebx,%eax
  80205e:	d3 e0                	shl    %cl,%eax
  802060:	89 c2                	mov    %eax,%edx
  802062:	8b 44 24 08          	mov    0x8(%esp),%eax
  802066:	d3 e0                	shl    %cl,%eax
  802068:	89 44 24 04          	mov    %eax,0x4(%esp)
  80206c:	8b 44 24 08          	mov    0x8(%esp),%eax
  802070:	89 f1                	mov    %esi,%ecx
  802072:	d3 e8                	shr    %cl,%eax
  802074:	09 d0                	or     %edx,%eax
  802076:	d3 eb                	shr    %cl,%ebx
  802078:	89 da                	mov    %ebx,%edx
  80207a:	f7 f7                	div    %edi
  80207c:	89 d3                	mov    %edx,%ebx
  80207e:	f7 24 24             	mull   (%esp)
  802081:	89 c6                	mov    %eax,%esi
  802083:	89 d1                	mov    %edx,%ecx
  802085:	39 d3                	cmp    %edx,%ebx
  802087:	0f 82 87 00 00 00    	jb     802114 <__umoddi3+0x134>
  80208d:	0f 84 91 00 00 00    	je     802124 <__umoddi3+0x144>
  802093:	8b 54 24 04          	mov    0x4(%esp),%edx
  802097:	29 f2                	sub    %esi,%edx
  802099:	19 cb                	sbb    %ecx,%ebx
  80209b:	89 d8                	mov    %ebx,%eax
  80209d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8020a1:	d3 e0                	shl    %cl,%eax
  8020a3:	89 e9                	mov    %ebp,%ecx
  8020a5:	d3 ea                	shr    %cl,%edx
  8020a7:	09 d0                	or     %edx,%eax
  8020a9:	89 e9                	mov    %ebp,%ecx
  8020ab:	d3 eb                	shr    %cl,%ebx
  8020ad:	89 da                	mov    %ebx,%edx
  8020af:	83 c4 1c             	add    $0x1c,%esp
  8020b2:	5b                   	pop    %ebx
  8020b3:	5e                   	pop    %esi
  8020b4:	5f                   	pop    %edi
  8020b5:	5d                   	pop    %ebp
  8020b6:	c3                   	ret    
  8020b7:	90                   	nop
  8020b8:	89 fd                	mov    %edi,%ebp
  8020ba:	85 ff                	test   %edi,%edi
  8020bc:	75 0b                	jne    8020c9 <__umoddi3+0xe9>
  8020be:	b8 01 00 00 00       	mov    $0x1,%eax
  8020c3:	31 d2                	xor    %edx,%edx
  8020c5:	f7 f7                	div    %edi
  8020c7:	89 c5                	mov    %eax,%ebp
  8020c9:	89 f0                	mov    %esi,%eax
  8020cb:	31 d2                	xor    %edx,%edx
  8020cd:	f7 f5                	div    %ebp
  8020cf:	89 c8                	mov    %ecx,%eax
  8020d1:	f7 f5                	div    %ebp
  8020d3:	89 d0                	mov    %edx,%eax
  8020d5:	e9 44 ff ff ff       	jmp    80201e <__umoddi3+0x3e>
  8020da:	66 90                	xchg   %ax,%ax
  8020dc:	89 c8                	mov    %ecx,%eax
  8020de:	89 f2                	mov    %esi,%edx
  8020e0:	83 c4 1c             	add    $0x1c,%esp
  8020e3:	5b                   	pop    %ebx
  8020e4:	5e                   	pop    %esi
  8020e5:	5f                   	pop    %edi
  8020e6:	5d                   	pop    %ebp
  8020e7:	c3                   	ret    
  8020e8:	3b 04 24             	cmp    (%esp),%eax
  8020eb:	72 06                	jb     8020f3 <__umoddi3+0x113>
  8020ed:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8020f1:	77 0f                	ja     802102 <__umoddi3+0x122>
  8020f3:	89 f2                	mov    %esi,%edx
  8020f5:	29 f9                	sub    %edi,%ecx
  8020f7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8020fb:	89 14 24             	mov    %edx,(%esp)
  8020fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802102:	8b 44 24 04          	mov    0x4(%esp),%eax
  802106:	8b 14 24             	mov    (%esp),%edx
  802109:	83 c4 1c             	add    $0x1c,%esp
  80210c:	5b                   	pop    %ebx
  80210d:	5e                   	pop    %esi
  80210e:	5f                   	pop    %edi
  80210f:	5d                   	pop    %ebp
  802110:	c3                   	ret    
  802111:	8d 76 00             	lea    0x0(%esi),%esi
  802114:	2b 04 24             	sub    (%esp),%eax
  802117:	19 fa                	sbb    %edi,%edx
  802119:	89 d1                	mov    %edx,%ecx
  80211b:	89 c6                	mov    %eax,%esi
  80211d:	e9 71 ff ff ff       	jmp    802093 <__umoddi3+0xb3>
  802122:	66 90                	xchg   %ax,%ax
  802124:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802128:	72 ea                	jb     802114 <__umoddi3+0x134>
  80212a:	89 d9                	mov    %ebx,%ecx
  80212c:	e9 62 ff ff ff       	jmp    802093 <__umoddi3+0xb3>
