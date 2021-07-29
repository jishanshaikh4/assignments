// Program for Finding Maximum element in CUDA using Reduction technique
// For Hadoop-CUDA Lab
// NOTE: THIS PROGRAM USES SOME DEPRECATED FUNCTIONS; HENCE THE WARNINGS!

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <cuda.h>

// Thread block size
#define BLOCK_SIZE 512

//  Size of Array
#define SOA 8192

// Allocates an array with random integer entries.
void randomInit(int* data, int size)
{
	for (int i = 0; i < size; ++i)
		data[i] = rand_r();
}

__global__ void ReductionMax2(int *input, int *results, int n)    //take thread divergence into account
{	
	extern __shared__ int sdata[]; 
	unsigned int i = blockIdx.x * blockDim.x + threadIdx.x;
	unsigned int tx = threadIdx.x; 
	 //load input into __shared__ memory 
	int x = INT_MIN; 
	if(i < n) 
		x = input[i]; 
	sdata[tx] = x; 
	__syncthreads();

	// block-wide reduction
	for(unsigned int offset = blockDim.x>>1; offset > 0; offset >>= 1)
	{
		__syncthreads();
		if(tx < offset)
	    {
			if(sdata[tx + offset] > sdata[tx])
				sdata[tx] = sdata[tx + offset];
		}

	}

		// finally, thread 0 writes the result 
	if(threadIdx.x == 0) 
	{ 
		// the result is per-block 
		results[blockIdx.x] = sdata[0]; 
	} 
}


// get global max element via per-block reductions 
	int main() 
	{ 
		int num_blocks = SOA / BLOCK_SIZE;
		
		//allocate host memory for array a
		unsigned int mem_size_a = sizeof(int) * SOA;
		int* h_a = (int*)malloc(mem_size_a);
		
		//initialize host memory
		randomInit(h_a,SOA);

		//allocate device memory
		int* d_a;
		cudaMalloc((void**) &d_a, mem_size_a);

		//copy host memory to device
		cudaMemcpy(d_a, h_a, mem_size_a, cudaMemcpyHostToDevice);

		//allocate device memory for temporary results
		unsigned int mem_size_b = sizeof(int) * SOA;
		int* d_b;
		cudaMalloc((void**) &d_b, mem_size_b);
		
		//allocate device memory for final result
		unsigned int mem_size_c = sizeof(int) * num_blocks;
		int* d_c;
		cudaMalloc((void**) &d_c, mem_size_c);	

		//setup execution parameters
		dim3 block(1,BLOCK_SIZE);
		dim3 grid(4,4);

		//execute the kernel
		//first reduce per-block partial maxs
		ReductionMax2<<<grid, block>>>(d_a,d_b,SOA);
		
		//then reduce partial maxs to a final max
		ReductionMax2<<<grid, block>>>(d_b,d_c,num_blocks);

       	// allocate host memory for the result
		int* h_c = (int*)malloc(mem_size_c);

		//copy final result from device to host
		cudaMemcpy(h_c, d_c, mem_size_c, cudaMemcpyDeviceToHost);

		//clean up memory
		free(h_a);
		free(h_c);
		cudaFree(d_a);
		cudaFree(d_b);
		cudaFree(d_c);

		cudaThreadExit();

}
