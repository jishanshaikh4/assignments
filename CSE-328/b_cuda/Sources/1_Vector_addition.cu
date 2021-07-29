// Program for Parallel Vector Addition in CUDA
// For Hadoop-CUDA Lab

#include <stdio.h>
#include <cuda.h>
#include <stdlib.h>
#include <time.h>

#define N 1024         // size of array

__global__ void add(int *a,int *b, int *c) {
	int tid = blockIdx.x *  blockDim.x + threadIdx.x;
        if(tid < N){
          c[tid] = a[tid]+b[tid];
        }
}

int main(int argc, char *argv[])  {
	int T = 10, B = 1;            // threads per block and blocks per grid, taking default values
	int a[N],b[N],c[N];
	int *dev_a, *dev_b, *dev_c;

	printf("Size of array = %d\n", N);
	do {
		printf("Enter number of threads per block: ");
		scanf("%d",&T);
		printf("\nEnter nuumber of blocks per grid: ");
		scanf("%d",&B);
		if (T * B != N) printf("Error T x B != N, try again");
	} while (T * B != N);

	cudaEvent_t start, stop;     // using cuda events to measure time
	float elapsed_time_ms;       // which is applicable for asynchronous code also

	cudaMalloc((void**)&dev_a,N * sizeof(int));
	cudaMalloc((void**)&dev_b,N * sizeof(int));
	cudaMalloc((void**)&dev_c,N * sizeof(int));

	for(int i=0;i<N;i++) {    // load arrays with some numbers
		a[i] = i;
		b[i] = i*1;
	}

	cudaMemcpy(dev_a, a , N*sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_b, b , N*sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_c, c , N*sizeof(int),cudaMemcpyHostToDevice);

	cudaEventCreate( &start );     // instrument code to measure start time
	cudaEventCreate( &stop );
	cudaEventRecord( start, 0 );

	add<<<B,T>>>(dev_a,dev_b,dev_c);

	cudaMemcpy(c,dev_c,N*sizeof(int),cudaMemcpyDeviceToHost);

	cudaEventRecord( stop, 0 );     // instrument code to measue end time
	cudaEventSynchronize( stop );
	cudaEventElapsedTime( &elapsed_time_ms, start, stop );

	for(int i=0;i<N;i++) {
		printf("%d+%d=%d\n",a[i],b[i],c[i]);
	}

	printf("Time to calculate results: %f ms.\n", elapsed_time_ms);  // print out execution time

	// clean up
	cudaFree(dev_a);
	cudaFree(dev_b);
	cudaFree(dev_c);

	cudaEventDestroy(start);
	cudaEventDestroy(stop);

	return 0;
}

