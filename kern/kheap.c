#include <inc/memlayout.h>
#include <kern/kheap.h>
#include <kern/memory_manager.h>

//2016: NOTE: All kernel heap allocations are multiples of PAGE_SIZE (4KB)
#define max_sz (uint32)(KERNEL_HEAP_MAX-KERNEL_HEAP_START)/PAGE_SIZE

unsigned int firstFreeVAInKHeap = (unsigned int)KERNEL_HEAP_START;

struct k_vi_info {

	uint32 size_vi;

	uint32* vi;

};

struct k_vi_info all_kmem[max_sz];
int cnt = 0;
int sz_kmem[max_sz] = { 0 };
int check = 0;

//func to allocate in kernal
void alloc_kmem(uint32 size,uint32 vir)
{

	int i=0;
	for(;i<size;i+=PAGE_SIZE)
	{
		struct Frame_Info* ptr_frame_info;
		 allocate_frame(&ptr_frame_info);
		map_frame(ptr_page_directory, ptr_frame_info,
						(int *) vir, PERM_WRITEABLE & (~PERM_USED));
				ptr_frame_info->va = vir;
				vir +=(unsigned int) PAGE_SIZE;
	}

}


void* kmalloc(unsigned int size)
{//TODO: [PROJECT 2016 - Kernel Dynamic Allocation/Deallocation] kmalloc()
	// Write your code here, remove the panic and write your code
	//panic("kmalloc() is not implemented yet...!!");

	//NOTE: Allocation is continuous increasing virtual address
	//NOTE: All kernel heap allocations are multiples of PAGE_SIZE (4KB)
	//refer to the project documentation for the detailed steps

	size = ROUNDUP(size, PAGE_SIZE);

	if (size == 0 || size > (KERNEL_HEAP_MAX - KERNEL_HEAP_START)||(size >((unsigned int)KERNEL_HEAP_MAX - firstFreeVAInKHeap)&&!check)) {
		return NULL;
	}



	// first we can allocate by " Strategy Continues "
	if (firstFreeVAInKHeap + size <= (uint32) KERNEL_HEAP_MAX && !check) {

		void* ret = (void *) firstFreeVAInKHeap;
		all_kmem[cnt].size_vi = size;
		all_kmem[cnt].vi = (void*) firstFreeVAInKHeap;
		cnt++;

		alloc_kmem(size, firstFreeVAInKHeap);

		int i = 0;

		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
		{

			sz_kmem[(int) ((firstFreeVAInKHeap - (uint32) KERNEL_HEAP_START)
					/ (uint32) PAGE_SIZE)] = 1;

			firstFreeVAInKHeap += (uint32) PAGE_SIZE;
		}

		return ret;

	} else {


	   // second we can allocate by " Strategy NEXTFIT "

		void* temp_end = NULL;

		int check_start = 0;

		// check first that we used " Strategy Continues " before and not do it again and turn to NEXTFIT
		if (!check) {
			firstFreeVAInKHeap = (uint32) KERNEL_HEAP_START;
			check = 1;
			check_start = 1; // to dont use second loop CZ firstFreeVAInKHeap start from USER_HEAP_START
		} else {
			temp_end = (void*) firstFreeVAInKHeap;

		}

		uint32 sz = 0;
		int f = 0;
		uint32 ptr = firstFreeVAInKHeap;
		// check if there are enough size in memory to allocate there
		while (ptr < (uint32) KERNEL_HEAP_MAX) {
			if (sz == size) {
				f = 1;
				break;
			}
			if (sz_kmem[(int) ((ptr - (uint32) KERNEL_HEAP_START)
					/ (uint32) PAGE_SIZE)] == 0) {

				sz += PAGE_SIZE;
				ptr += PAGE_SIZE;
			} else {
				sz = 0;
				ptr += PAGE_SIZE;
				firstFreeVAInKHeap = ptr;
			}

		}

		if (f) {

			void* ret = (void *) firstFreeVAInKHeap;
			all_kmem[cnt].size_vi = size;
			all_kmem[cnt].vi = (void*) firstFreeVAInKHeap;
			cnt++;

			alloc_kmem(size, firstFreeVAInKHeap);

			int i = 0;
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
			{

				sz_kmem[(int) ((firstFreeVAInKHeap - (uint32) KERNEL_HEAP_START)
						/ (uint32) PAGE_SIZE)] = 1;

				firstFreeVAInKHeap += (uint32) PAGE_SIZE;
			}

			return ret;

		} else {

			if (check_start) {

				return NULL;
			}

			/////////////back loop////////////////

			uint32 sz = 0;
			int f = 0;
			uint32 ptr = KERNEL_HEAP_START;
			firstFreeVAInKHeap = KERNEL_HEAP_START;
			while (ptr < (uint32) temp_end) {
				if (sz == size) {
					f = 1;
					break;
				}
				if (sz_kmem[(int) ((ptr - (uint32) KERNEL_HEAP_START)
						/ (uint32) PAGE_SIZE)] == 0) {

					sz += PAGE_SIZE;
					ptr += PAGE_SIZE;
				} else {
					sz = 0;
					ptr += PAGE_SIZE;
					firstFreeVAInKHeap = ptr;
				}

			}

			if (f) {

				void* ret = (void *) firstFreeVAInKHeap;
				all_kmem[cnt].size_vi = size;
				all_kmem[cnt].vi = (void*) firstFreeVAInKHeap;
				cnt++;

				alloc_kmem(size, firstFreeVAInKHeap);

				int i = 0;

				for (; i < size; i += PAGE_SIZE)
				{

					sz_kmem[(int) ((firstFreeVAInKHeap
							- (uint32) KERNEL_HEAP_START) / (uint32) PAGE_SIZE)] =
							1;

					firstFreeVAInKHeap += (uint32) PAGE_SIZE;
				}

				return ret;

			} else {

				return NULL;
			}

		}

	}

}

void kfree(void* virtual_address)
{//TODO: [PROJECT 2016 - Kernel Dynamic Allocation/Deallocation] kfree()
	// Write your code here, remove the panic and write your code
	//panic("kfree() is not implemented yet...!!");

	//get the size of the given allocation using its address

	//refer to the project documentation for the detailed steps


	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int i;
	for (i=0; i <cnt; i++) {

		if (all_kmem[i].vi == virtual_address) {

			if (all_kmem[i].size_vi == 0) {
				all_kmem[i].size_vi = 0;
				all_kmem[i].vi = NULL;
				return;
			}

			//virtual_address=all_kmem[i].vi;
			uint32 va = (uint32) virtual_address;
			int j;
			for (j=0; j < all_kmem[i].size_vi; j += PAGE_SIZE) {

				unmap_frame(ptr_page_directory, virtual_address);

				virtual_address += PAGE_SIZE;
				//tlbflush();
			}


			int k = 0;
			// init my array with 0 to make sure this frame is free for me
			for (; k <all_kmem[i].size_vi; k += PAGE_SIZE)
			{
				sz_kmem[(int) ((va - (uint32) KERNEL_HEAP_START)
						/ (uint32) PAGE_SIZE)] = 0;

				va += (uint32) PAGE_SIZE;
			}

			all_kmem[i].vi=NULL;
			all_kmem[i].size_vi=0;
			return;
		}

	}


	//unmap_frame(ptr_page_directory,virtual_address);


	//TODO: [PROJECT 2016 - BONUS1] Implement a Kernel allocation strategy
	// Instead of the continuous allocation/deallocation, implement one of
	// the strategies NEXT FIT, BEST FIT, .. etc

}

unsigned int kheap_virtual_address(unsigned int physical_address)
{//TODO: [PROJECT 2016 - Kernel Dynamic Allocation/Deallocation] kheap_virtual_address()
	// Write your code here, remove the panic and write your code
	//panic("kheap_virtual_address() is not implemented yet...!!");

	//return the virtual address corresponding to given physical_address
	//refer to the project documentation for the detailed steps


	struct Frame_Info* ptr_fram_info;
	ptr_fram_info=to_frame_info(physical_address);
	return ptr_fram_info->va;





	//change this "return" according to your answer
	//return 0;
}

unsigned int kheap_physical_address(unsigned int virtual_address)
{
	//TODO: [PROJECT 2016 - Kernel Dynamic Allocation/Deallocation] kheap_physical_address()
		// Write your code here, remove the panic and write your code
		//panic("kheap_physical_address() is not implemented yet...!!");

		//return the physical address corresponding to given virtual_address
		//refer to the project documentation for the detailed steps
	//////////////

		uint32 *ptr_table = NULL;
		struct Frame_Info* ptr_frame_info = get_frame_info(ptr_page_directory, (void*)virtual_address, &ptr_table);
		if(ptr_frame_info==NULL)
			return 0;
		uint32 physical_address = to_physical_address(ptr_frame_info);

		return physical_address;
		//change this "return" according to your answer


	}
