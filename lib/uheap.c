#include <inc/lib.h>
/*
 * Simple malloc()
 *
 * The address space for the dynamic allocation is
 * from "USER_HEAP_START" to "USER_HEAP_MAX"-1
 * Pages are allocated ON 4KB BOUNDARY
 * On succeed, return void pointer to the allocated space
 * return NULL if
 *	-there's no suitable space for the required allocation
 */

// malloc()
//	This function use both NEXT FIT and BEST FIT strategies to allocate space in heap
//  with the given size and return void pointer to the start of the allocated space
//	To do this, we need to switch to the kernel, allocate the required space
//	in Page File then switch back to the user again.
//
//	We can use sys_allocateMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls allocateMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the allocateMem function is empty, make sure to implement it.
uint32 ptr_uheap = (uint32) USER_HEAP_START;
#define  size_uhmem (uint32)(USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE //  2^20=1G  or  1,048,576 kb=262,144 entry by div 4
struct hmem {
	void* vir;
	uint32 size;

};
int cnt_mem = 0;
int heap_mem[size_uhmem] = { 0 };
struct hmem heap_size[size_uhmem] = { 0 };
int check = 0;

void* malloc(uint32 size) {
	//TODO: [PROJECT 2016 - Dynamic Allocation] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	// Steps:
	//	1) Implement both NEXT FIT and BEST FIT strategies to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	//	 Else,
	//	3) Call sys_allocateMem to invoke the Kernel for allocation
	// 	4) Return pointer containing the virtual address of allocated space,
	//

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyNEXTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	//NEXT FIT
	if (sys_isUHeapPlacementStrategyNEXTFIT()) {
		size = ROUNDUP(size, PAGE_SIZE);

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
			return NULL;
		}
		// first we can allocate by " Strategy Continues "
		if (ptr_uheap + size <= (uint32) USER_HEAP_MAX && !check) {

			void* ret = (void *) ptr_uheap;
			sys_allocateMem(ptr_uheap, size);

			heap_size[cnt_mem].size = size;
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
			cnt_mem++;
			int i = 0;
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
			{

				heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
						/ (uint32) PAGE_SIZE)] = 1;

				ptr_uheap += (uint32) PAGE_SIZE;
			}

			return ret;

		} else {
			// second we can allocate by " Strategy NEXTFIT "
			void* temp_end = NULL;

			int check_start = 0;
			// check first that we used " Strategy Continues " before and not do it again and turn to NEXTFIT
			if (!check) {
				ptr_uheap = (uint32) USER_HEAP_START;
				check = 1;
				check_start = 1;// to dont use second loop CZ ptr_uheap start from USER_HEAP_START
			} else {
				temp_end = (void*) ptr_uheap;

			}

			uint32 sz = 0;
			int f = 0;
			uint32 ptr = ptr_uheap;
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
				if (sz == size) {
					f = 1;
					break;
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
						/ (uint32) PAGE_SIZE)] == 0) {

					sz += PAGE_SIZE;
					ptr += PAGE_SIZE;
				} else {
					sz = 0;
					ptr += PAGE_SIZE;
					ptr_uheap = ptr;
				}

			}

			if (f) {

				void* ret = (void *) ptr_uheap;

				sys_allocateMem(ptr_uheap, size);

				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
				cnt_mem++;
				int i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
				{

					heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
							/ (uint32) PAGE_SIZE)] = 1;

					ptr_uheap += (uint32) PAGE_SIZE;
				}

				return ret;

			} else {

				if (check_start) {

					return NULL;
				}

//////////////back loop////////////////

				uint32 sz = 0;
				int f = 0;
				uint32 ptr = USER_HEAP_START;
				ptr_uheap = USER_HEAP_START;
				while (ptr < (uint32) temp_end) {
					if (sz == size) {
						f = 1;
						break;
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
							/ (uint32) PAGE_SIZE)] == 0) {

						sz += PAGE_SIZE;
						ptr += PAGE_SIZE;
					} else {
						sz = 0;
						ptr += PAGE_SIZE;
						ptr_uheap = ptr;
					}

				}

				if (f) {

					void* ret = (void *) ptr_uheap;

					sys_allocateMem(ptr_uheap, size);

					heap_size[cnt_mem].size = size;
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
					cnt_mem++;
					int i = 0;

					for (; i < size; i += PAGE_SIZE)
					{

						heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
								/ (uint32) PAGE_SIZE)] = 1;

						ptr_uheap += (uint32) PAGE_SIZE;
					}

					return ret;

				} else {

					return NULL;
				}

			}

		}

	}

	else if (sys_isUHeapPlacementStrategyBESTFIT()) {

		size = ROUNDUP(size, PAGE_SIZE);

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
			return NULL;
		}
		uint32 ptr = (uint32) USER_HEAP_START;
		uint32 temp = 0;
		uint32 min_sz = size_uhmem + 1;
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {

			if (heap_mem[i] == 0) {

				count++;
				ptr += PAGE_SIZE;
			} else {
				if (num_p <= count && min_sz > count) {

					min_sz = count;
					temp = ptr;

				}
				count = 0;
				ptr += PAGE_SIZE;
			}

			if (i == size_uhmem - 1) {

				if (num_p <= count && min_sz > count) {

					min_sz = count;
					temp = ptr;
					count = 0;
					ptr += PAGE_SIZE;

				}

			}

		}

		if (num_p > min_sz || temp == 0) {
			return NULL;

		}

		temp = temp - (PAGE_SIZE * min_sz);
		void* ret = (void*) temp;

		sys_allocateMem(temp, size);

		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;

	} else if (sys_isUHeapPlacementStrategyFIRSTFIT()) {

		size = ROUNDUP(size, PAGE_SIZE);

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
			return NULL;
		}

		uint32 ptr = (uint32) USER_HEAP_START;
		uint32 temp = 0;
		uint32 found = 0;
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		for (; i < size_uhmem; i++) {

			if (heap_mem[i] == 0) {

				count++;
				ptr += PAGE_SIZE;
			} else {
				if (num_p <= count) {

					found = 1;

					break;
				}
				count = 0;
				ptr += PAGE_SIZE;
			}

			if (i == size_uhmem - 1) {

				if (num_p <= count) {

					found = 1;

				}

			}

		}

		if (!found) {
			return NULL;

		}

		temp = ptr;
		temp = temp - (PAGE_SIZE * count);
		void* ret = (void*) temp;

		sys_allocateMem(temp, size);

		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;

	}
	else if(sys_isUHeapPlacementStrategyWORSTFIT())
	{
		size = ROUNDUP(size, PAGE_SIZE);

				if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
					return NULL;
				}
				uint32 ptr = (uint32) USER_HEAP_START;
				uint32 temp = 0;
				uint32 max_sz = -1;
				uint32 count = 0;
				int i = 0;
				uint32 num_p = size / PAGE_SIZE;

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {

					if (heap_mem[i] == 0) {

						count++;
						ptr += PAGE_SIZE;
					} else {
						if (num_p <= count && max_sz < count) {

							max_sz = count;
							temp = ptr;

						}
						count = 0;
						ptr += PAGE_SIZE;
					}

					if (i == size_uhmem - 1) {

						if (num_p <= count && max_sz > count) {

							max_sz = count;
							temp = ptr;
							count = 0;
							ptr += PAGE_SIZE;

						}

					}

				}

				if (num_p > max_sz || temp == 0) {
					return NULL;

				}

				temp = temp - (PAGE_SIZE * max_sz);
				void* ret = (void*) temp;

				sys_allocateMem(temp, size);

				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) temp;
				cnt_mem++;
				i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
				{

					heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
							/ (uint32) PAGE_SIZE)] = 1;

					temp += (uint32) PAGE_SIZE;
				}

				//cprintf("\n size = %d.........vir= %d  \n",num_p,((uint32) ret-USER_HEAP_START)/PAGE_SIZE);
				return ret;

	}
// this is to make malloc is work
	void* ret = NULL;
	size = ROUNDUP(size, PAGE_SIZE);

	if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
		return NULL;
	}

	if (ptr_uheap + size <= (uint32) USER_HEAP_MAX) {

		ret = (void *) ptr_uheap;
		sys_allocateMem(ptr_uheap, size);

		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
		cnt_mem++;
		int i = 0;

		for (; i < size; i += PAGE_SIZE)
		{

			heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
					/ (uint32) PAGE_SIZE)] = 1;

			ptr_uheap += (uint32) PAGE_SIZE;
		}
	}
	return ret;

	//cprintf("\n NONONONONO\n");
	//return NULL;

	//TODO: [PROJECT 2016 - BONUS2] Apply FIRST FIT and WORST FIT policies

//return 0;

}

// free():
//	This function frees the allocation of the given virtual_address
//	To do this, we need to switch to the kernel, free the pages AND "EMPTY" PAGE TABLES
//	from page file and main memory then switch back to the user again.
//
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address) {
	//TODO: [PROJECT 2016 - Dynamic Deallocation] free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
	for (; inx < cnt_mem; inx++) {
		if (heap_size[inx].vir == virtual_address) {

			if (heap_size[inx].size == 0) {
				heap_size[inx].size = 0;
				heap_size[inx].vir = NULL;
				return;

			}

			sys_freeMem((uint32) virtual_address, heap_size[inx].size);

			int i = 0;
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
			{
				heap_mem[(int) (((uint32) va - USER_HEAP_START) / PAGE_SIZE)] =
						0;

				va += PAGE_SIZE;

			}

			heap_size[inx].size = 0;
			heap_size[inx].vir = NULL;
			break;

		}

	}

	//get the size of the given allocation using its address
	//you need to call sys_freeMem()

}

//=================================================================================//
//============================== BONUS FUNCTION ===================================//
//=================================================================================//
// realloc():

//	Attempts to resize the allocated space at "virtual_address" to "new_size" bytes,
//	possibly moving it in the heap.
//	If successful, returns the new virtual_address, in which case the old virtual_address must no longer be accessed.
//	On failure, returns a null pointer, and the old virtual_address remains valid.

//	A call with virtual_address = null is equivalent to malloc().
//	A call with new_size = zero is equivalent to free().

//  Hint: you may need to use the sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size) {
	//TODO: [PROJECT 2016 - BONUS4] realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");

	return 0;
}

