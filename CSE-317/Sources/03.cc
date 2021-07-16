// Uniprogramming Implementation in C++
// By: Jishan Shaikh

#include <bits/stdc++.h>
using namespace std;

int main(){
    float ttat=0, tat=0, cpuu=0, iou, tp=0, total=0, average=0, ipuu=0;
    int n;
    cin >> n;
    int p[n][5];
    for(int i=0; i<n; i++){
        tat = 0;
        for(int j=0; j<5; j++){
            cin >> p[i][j];
            ttat = ttat + p[i][j];
            tat = tat + p[i][j];
        }
        cout << "Turn around time of process " << i << " is " << ttat << endl; 
        total += ttat;
    }
    average = total/n;
    cout << "Average turn around time is " << average << endl;
    for(int i=0; i<n; i++){
        cpuu += p[i][0] + p[i][2] + p[i][4];
    }
    cpuu = (cpuu*100)/ttat;
    ipuu = 100 - cpuu;
    cout << "Total CPU utilization is " << cpuu << "%" <<endl;
    cout << "Total I/O utilization is " << ipuu << "%" << endl;
    cout << "Total turn around time is " << ttat << endl;
    cout << "Throughput is " << (n/ttat)*1000 << " processes per second." << endl;
    return 0;
}
