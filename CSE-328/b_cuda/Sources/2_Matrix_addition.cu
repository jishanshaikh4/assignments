// Program for Matrix Addition in CUDA
// For Hadoop-CUDA Lab

#include <stdio.h>
#include <cuda.h>
#include <stdlib.h>

__global__ void gpu_matrixadd(int *a,int *b, int *c, int N) {

	int col = threadIdx.x + blockDim.x * blockIdx.x; 
	int row = threadIdx.y + blockDim.y * blockIdx.y;

	int index = row * N + col;

      	if(col < N && row < N)
          c[index] = a[index]+b[index];

}

void cpu_matrixadd(int *a,int *b, int *c, int N) {

	int index;
	for(int col=0;col < N; col++) 
		for(int row=0;row < N; row++) {
			index = row * N + col;
           		c[index] = a[index]+b[index];
		}
}

int main(int argc, char *argv[])  {

	char key;

	int i, j; 					// loop counters

	int Grid_Dim_x=1, Grid_Dim_y=1;			//Grid structure values
	int Block_Dim_x=1, Block_Dim_y=1;		//Block structure values

	int noThreads_x, noThreads_y;		// number of threads available in device, each dimension
	int noThreads_block;				// number of threads in a block

	int N = 10;  					// size of array in each dimension
	int *a,*b,*c,*d;
	int *dev_a, *dev_b, *dev_c;
	int size;					// number of bytes in arrays

	cudaEvent_t start, stop;     		// using cuda events to measure time
	float elapsed_time_ms;       		// which is applicable for asynchronous code also

/* --------------------ENTER INPUT PARAMETERS AND DATA -----------------------*/

do {  // loop to repeat complete program

	printf ("Device characteristics -- some limitations (compute capability 1.0)\n");
	printf ("		Maximum number of threads per block = 512\n");
	printf ("		Maximum sizes of x- and y- dimension of thread block = 512\n");
	printf ("		Maximum size of each dimension of grid of thread blocks = 65535\n");
	
	printf("Enter size of array in one dimension (square array), currently %d\n",N);
	scanf("%d",&N);
		
	do {
		printf("\nEnter nuumber of blocks per grid in x dimension), currently %d  : ",Grid_Dim_x);
		scanf("%d",&Grid_Dim_x);

		printf("\nEnter nuumber of blocks per grid in y dimension), currently %d  : ",Grid_Dim_y);
		scanf("%d",&Grid_Dim_y);

		printf("\nEnter nuumber of threads per block in x dimension), currently %d  : ",Block_Dim_x);
		scanf("%d",&Block_Dim_x);

		printf("\nEnter nuumber of threads per block in y dimension), currently %d  : ",Block_Dim_y);
		scanf("%d",&Block_Dim_y);

		noThreads_x = Grid_Dim_x * Block_Dim_x;		// number of threads in x dimension
		noThreads_y = Grid_Dim_y * Block_Dim_y;		// number of threads in y dimension

		noThreads_block = Block_Dim_x * Block_Dim_y;	// number of threads in a block

		if (noThreads_x < N) printf("Error -- number of threads in x dimension less than number of elements in arrays, try again\n");
		else if (noThreads_y < N) printf("Error -- number of threads in y dimension less than number of elements in arrays, try again\n");
		else if (noThreads_block > 512) printf("Error -- too many threads in block, try again\n");
		else printf("Number of threads not used = %d\n", noThreads_x * noThreads_y - N * N);

	} while (noThreads_x < N || noThreads_y < N || noThreads_block > 512);

	dim3 Grid(Grid_Dim_x, Grid_Dim_x);		//Grid structure
	dim3 Block(Block_Dim_x,Block_Dim_y);	//Block structure, threads/block limited by specific device

	size = N * N * sizeof(int);		// number of bytes in total in arrays

	a = (int*) malloc(size);		//this time use dynamically allocated memory for arrays on host
	b = (int*) malloc(size);
	c = (int*) malloc(size);		// results from GPU
	d = (int*) malloc(size);		// results from CPU

	for(i=0;i < N;i++)			// load arrays with some numbers
	for(j=0;j < N;j++) {
		a[i * N + j] = i;
		b[i * N + j] = i;
	}

/* ------------- COMPUTATION DONE ON GPU ----------------------------*/

	cudaMalloc((void**)&dev_a, size);		// allocate memory on device
	cudaMalloc((void**)&dev_b, size);
	cudaMalloc((void**)&dev_c, size);

	cudaMemcpy(dev_a, a , size ,cudaMemcpyHostToDevice);
	cudaMemcpy(dev_b, b , size ,cudaMemcpyHostToDevice);
	cudaMemcpy(dev_c, c , size ,cudaMemcpyHostToDevice);

	cudaEventCreate(&start);     		// instrument code to measure start time
	cudaEventCreate(&stop);

	cudaEventRecord(start, 0);
//	cudaEventSynchronize(start);  	// Needed?

	gpu_matrixadd<<<Grid,Block>>>(dev_a,dev_b,dev_c,N);

	cudaMemcpy(c,dev_c, size ,cudaMemcpyDeviceToHost);

	cudaEventRecord(stop, 0);     	// instrument code to measue end time
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&elapsed_time_ms, start, stop );

//	for(i=0;i < N;i++) 
//	for(j=0;j < N;j++)
//	   printf("%d+%d=%d\n",a[i * N + j],b[i * N + j],c[i * N + j]);

	printf("Time to calculate results on GPU: %f ms.\n", elapsed_time_ms);  // print out execution time

/* ------------- COMPUTATION DONE ON HOST CPU ----------------------------*/

	cudaEventRecord(start, 0);		// use same timing
//	cudaEventSynchronize(start);  	// Needed?

	cpu_matrixadd(a,b,d,N);		// do calculation on host

	cudaEventRecord(stop, 0);     	// instrument code to measue end time
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&elapsed_time_ms, start, stop );

	printf("Time to calculate results on CPU: %f ms.\n", elapsed_time_ms);  // print out execution time

/* ------------------- check device creates correct results -----------------*/

	for(i=0;i < N*N;i++) {
		if (c[i] != d[i]) printf("*********** ERROR in results, CPU and GPU create different answers ********\n");
		break;
	}

	printf("\nEnter c to repeat, return to terminate\n");
	scanf("%c",&key);
	scanf("%c",&key);

} while (key == 'c'); // loop of complete program

/* --------------  clean up  ---------------------------------------*/
	free(a);
	free(b);
	free(c);
	cudaFree(dev_a);
	cudaFree(dev_b);
	cudaFree(dev_c);

	cudaEventDestroy(start);
	cudaEventDestroy(stop);

	return 0;
}



