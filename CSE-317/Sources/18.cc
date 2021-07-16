#include <bits/stdc++.h> 
using namespace std; 

bool search(int key, vector <int> frame){ // Page exists in frame?
	for(int i=0; i<frame.size(); i++) 
		if(frame[i] == key) 
			return true; 
	return false; 
} 

// find frame that will not be used in future
int futuree(vector <int> page, vector<int> frame, int n, int index){
	int res = -1, farthest = index; 
	for(int i=0; i<frame.size(); i++){ 
		int j; 
		for(j=index; j<n; j++){ 
			if(frame[i] == page[j]){ 
				if(j>farthest){ 
					farthest=j; 
					res=i; 
				} 
				break; 
			} 
		} 

		if(j==n) 
			return i; 
	} 

	if(res==-1)
	    return 0;
	return res;
} 

void optimal(vector <int> page, int n, int m){ 
	vector <int> frame; 

	int hits = 0; 
	for(int i=0; i<n; i++){ 
		if(search(page[i], frame)){ 
			hits++; 
			continue; 
		} 

		// Page not found in a frame : MISS 

		// If there is space available in frames. 
		if(frame.size() < m) 
			frame.push_back(page[i]); 

		// Find page to be replaced. 
		else { 
			int j = futuree(page, frame, n, i+1); 
			frame[j] = page[i]; 
		} 
	} 
	cout << "Hits : " << hits << endl; 
	cout << "Misses : " << n - hits << endl; 
} 

int main(){ 
      int m, n; // m frames, n pages
      cin >> n >> m;
	vector <int> page(n); 
	for(int i=0; i<n; i++){
	    cin >> page[i];
	} 
	optimal(page, n, m); 
	return 0; 
} 
