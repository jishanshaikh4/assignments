#include <bits/stdc++.h> 
using namespace std; 

int pageFaults(vector <int> pages, int n, int f){
	unordered_set <int> s; 

	queue <int> indexes; 

	int page_faults = 0; 
	for(int i=0; i<n; i++){ 
		if(s.size() < f){   // If MM is not full yet
			if(s.find(pages[i])==s.end()){  // Not found in MM
				s.insert(pages[i]); 
				page_faults++; 
				indexes.push(pages[i]); 
			} 
		} 
		else{   // MM is full
			if(s.find(pages[i]) == s.end()){    // Not found in MM 
				int val = indexes.front();  // Get first page
				indexes.pop(); 
				s.erase(val); 
				s.insert(pages[i]); 
				indexes.push(pages[i]); 
				page_faults++; 
			} 
		} 
	} 
	return page_faults; 
} 
 
int main(){ 
    int n, f;
    cin >> n >> f;
    vector <int> pages(n);
    for(int i=0; i<n; i++)
        cin >> pages[i]; 
    int page_faults = pageFaults(pages, n, f);
	cout << "Page faults: " << page_faults;
	cout << "\nPage fault percentage: " << float(page_faults/n*100);
	return 0; 
} 
