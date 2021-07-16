#include <bits/stdc++.h>
using namespace std;

const int n = 3, r = 1;

bool Safe(int processes[], int avail[], int maxm[][r], int allot[][r]){
	int need[n][r];
	for(int i=0; i<n; i++)
	for(int j=0; j<r; j++)
		need[i][j] = maxm[i][j] - allot[i][j];
	
	bool finish[n] = {0};
	int safeSeq[n];
	
	int work[r];
	for(int i=0; i<r; i++)
		work[i] = avail[i];
	
	int count = 0;
	while(count < n){
		bool found = false;
		for(int p=0; p<n; p++){
			if (finish[p] == 0){
				int j;
				for(j=0; j<r; j++)
				if(need[p][j] > work[j])
					break;
				
				if(j == r){
					for(int k=0 ; k<r; k++)
					work[k] += allot[p][k];
					
					safeSeq[count++] = p;
					
					finish[p] = 1;
					
					found = true;
				}
			}
		}
	
		if(found == false){
			cout << "ERROR: NOT IN SAFE STATE.";
			return false;
		}
	}

	cout << "SYSTEM IS IN SAFE STATE. \nTHE SAFE SEQUENCE IS : ";
	for(int i=0; i<n; i++)
		cout << safeSeq[i] << " ";

	return true;
}

int main(){
	int processes[n] = {0, 1, 2};
	int avail[r] = {1000};
	int maxm[n][r] = {{5000}, {7000}, {9000}};
	int allot[n][r] = {{4000}, {2000}, {3000}};
	Safe(processes, avail, maxm, allot);	
	return 0;
}
