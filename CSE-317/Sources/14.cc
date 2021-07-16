#include <bits/stdc++.h>
using namespace std;

int main(){
      int memory_size[10][2], process_size[10][3];
      int i, j, total_processes = 0, total_memory = 0;
      printf("\nEnter the Total Number of Processes:\t");
      scanf("%d", &total_processes);
      printf("\nEnter the Size of Each Process\n");
      for(int i = 0; i < total_processes; i++){
            printf("Enter Size of Process %d:\t", i + 1);
            scanf("%d", &process_size[i][0]);
            process_size[i][1] = 0;
            process_size[i][2] = i;
      }
      printf("\nEnter Total Memory Blocks:\t");
      scanf("%d", &total_memory);
      printf("\nEnter the Size of Each Block:\n");
      for(i = 0; i < total_processes; i++){
            printf("Enter Size of Block %d:\t", i + 1);
            scanf("%d", &memory_size[i][0]);
            memory_size[i][1] = 0;
      }
      for(i = 0; i < total_processes; i++){
            while(j < total_memory){
                  if(memory_size[j][1] == 0 && process_size[i][0] <=memory_size[j][0]){
                        process_size[i][1] = 1;
                        memory_size[j][1] = 1;
                        printf("\nProcess [%d] Allocated to Memory Block:\t%d", i + 1, j + 1);
                        break;
                  }
                  j++;
            }
      }
      for(i = 0; i < total_memory; i++){
            if(process_size[i][1] == 0){
                  printf("\nProcess [%d] Unallocated\n", i + 1);
            }
      }
      printf("\n");
      return 0;
}
