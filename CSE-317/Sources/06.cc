#include <bits/stdc++.h>
using namespace std;

int main(){
    float process[500],aTime[500],bTime[500],abTime[500],wTime[500],tat_time[500];
    int n = 0,i = 0 ;
    float aw_time = 0, atat_time = 0;
    printf("\nEnter the number of process : ");
    scanf("%d",&n);

    printf("Enter the Arrival time and Burst time.\n\n");
    printf("\tA_Time B_Time\n");
    for(i = 0 ; i < n ; i++){
        process[i]=i+1;
        printf("P%d :\t", i+1);
        scanf("%f\t%f",&aTime[i],&bTime[i]);
    }
    printf("\n\nProcess\tA_Time\tB_Time\n");
    for(i = 0 ; i < n ; i++){
        printf("P[%d]\t%.2f\t%.2f\n",i,aTime[i],bTime[i]);
    }
    wTime[0] = 0;
    tat_time[0] = bTime[0];
    abTime[0] = bTime[0]+aTime[0];
    for( i = 1 ; i < n ; i++){
        abTime[i] = abTime[i-1] + bTime[i];
        tat_time[i] = abTime[i] - aTime[i];
        wTime[i] = tat_time[i] - bTime[i];
    }
    for(i = 0 ; i < n ; i++){
        aw_time = aw_time + wTime[i];
        atat_time = atat_time + tat_time[i];
    }
    printf("\tA_time\tB_time\tC_time\tTat_time  W_time\n");
    for(i = 0 ; i < n ; i++){
        printf("P[%d]\t%.2f\t%0.2f\t%0.2f\t%0.2f\t%0.2f\n",i,aTime[i],bTime[i],abTime[i],tat_time[i],wTime[i]);
    }
    printf("\nAverage waiting time : %0.2f", aw_time/n);
    return 0;
}
