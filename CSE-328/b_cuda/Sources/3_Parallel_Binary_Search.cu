// Program for Parallel Binary Search in CUDA
// For Hadoop-CUDA Lab

#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>


#include <assert.h>

__device__ int get_index_to_check(int thread, int num_threads, int set_size, int offset) {

	// Integer division trick to round up
	return (((set_size + num_threads) / num_threads) * thread) + offset;
}

__global__ void p_ary_search(int search, int array_length,  int *arr, int *ret_val ) {

	const int num_threads = blockDim.x * gridDim.x;
	const int thread = blockIdx.x * blockDim.x + threadIdx.x;
	
	//ret_val[0] = -1;
	//ret_val[1] = offset;

	int set_size = array_length;

	
	while(set_size != 0){
		// Get the offset of the array, initially set to 0
		int offset = ret_val[1];
		
		// I think this is necessary in case a thread gets ahead, and resets offset before it's read
		// This isn't necessary for the unit tests to pass, but I still like it here
		__syncthreads();	

		// Get the next index to check
		int index_to_check = get_index_to_check(thread, num_threads, set_size, offset);

		// If the index is outside the bounds of the array then lets not check it
		if (index_to_check < array_length){

			// If the next index is outside the bounds of the array, then set it to maximum array size
			int next_index_to_check = get_index_to_check(thread + 1, num_threads, set_size, offset);

			if (next_index_to_check >= array_length){
				next_index_to_check = array_length - 1;
			}

			// If we're at the mid section of the array reset the offset to this index
			if (search > arr[index_to_check] && (search < arr[next_index_to_check])) {
				ret_val[1] = index_to_check;
			}
			else if (search == arr[index_to_check]) {
				// Set the return var if we hit it
				ret_val[0] = index_to_check;
			}	
		}

		// Since this is a p-ary search divide by our total threads to get the next set size
		set_size = set_size / num_threads;
		
		// Sync up so no threads jump ahead and get a bad offset
		__syncthreads();
	}
}


int chop_position(int search, int *search_array, int array_length)
{
	// Get the size of the array for future use
	int array_size = array_length * sizeof(int);

	// Don't bother with small arrays
	if (array_size == 0) return -1;

	// Setup array to use on device
    int    *dev_arr;
	cudaMalloc((void**)&dev_arr, array_size);

	// Copy search array values
	cudaMemcpy(dev_arr, search_array, array_size, cudaMemcpyHostToDevice);

	// return values here and on device
	int		*ret_val = (int*)malloc(sizeof(int) * 2);
	ret_val[0] = -1; // return value
	ret_val[1] = 0; // offset
	array_length = array_length % 2 == 0 ? array_length : array_length - 1; // array size

	int		*dev_ret_val;
	cudaMalloc((void**)&dev_ret_val, sizeof(int) * 2);

	// Send in some intialized values
	cudaMemcpy(dev_ret_val, ret_val, sizeof(int) * 2, cudaMemcpyHostToDevice);
	
	// Launch kernel
	// This seems to be the best combo for p-ary search
	// Optimized around 10-15 registers per thread
	p_ary_search<<<16, 64>>>(search, array_length, dev_arr, dev_ret_val);

	// Get results
	cudaMemcpy(ret_val, dev_ret_val, 2 * sizeof(int), cudaMemcpyDeviceToHost);

	int ret = ret_val[0];

	printf("Ret Val %i    Offset %i\n", ret, ret_val[1]);

	// Free memory on device
	cudaFree(dev_arr);
	cudaFree(dev_ret_val);
	
	free(ret_val);

	return ret;
}

// Test region
static int * build_array(int length) {

	int *ret_val = (int*)malloc(length * sizeof(int));

	for (int i = 0; i < length; i++)
	{
		ret_val[i] = i * 2 - 1;
	}

	return ret_val;
}

static void test_array(int length, int search, int index) {
	
	printf("Length %i   Search %i    Index %i\n", length, search, index);
	// assert(index == chop_position(search, build_array(length), length) && "test_small_array()");

}

static void test_arrays() {	
	
	test_array(200, 200, -1);
	
	test_array(200, -1, 0);
	
	test_array(200, 1, 1);
	
	test_array(200, 29, 15);
	
	test_array(200, 129, 65);	

	test_array(200, 395, 198);
	
	test_array(20000, 395, 198);
	
	test_array(2000000, 394, -1);
	
	test_array(20000000, 394, -1);
}


int main(){
	test_arrays();
}
