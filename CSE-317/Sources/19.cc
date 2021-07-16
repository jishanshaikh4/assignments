#include <bits/stdc++.h>
using namespace std; 

int getLeastRecentlyUsed(vector <int> temp, unordered_set <int> s){
    int n = temp.size();
    for(int i=0; i<n; i++){
        if(s.find(temp[i]) != s.end()){ // found in mm
            return temp[i]; // return first hit in used array ""
        }
    }
    return 0;
}

vector <int> removee(int val, vector <int> temp){
    int n = temp.size();
    vector <int> t;
    for(int i=0; i<n; i++){
        if(temp[i] == val){
            for(int a=0; a<i; a++){
                t.push_back(temp[a]);
            }
            for(int a=i; a<n-1; a++){
                t.push_back(temp[a+1]);
            }
            break;
        }
    }
    return t;
}

int pageFaults(vector <int> pages, int n, int f){
    // set s is main memory, and temp is order of processes used
    unordered_set <int> s; 

    vector <int> temp;
    
    int page_faults = 0; 
    for(int i=0; i<n; i++){ 
        if(s.size() < f){   // If MM is not full yet
            if(s.find(pages[i])==s.end()){
                s.insert(pages[i]); 
                page_faults++; 
                temp.push_back(pages[i]); 
            } 
        } 
        else{   // MM is full
            if(s.find(pages[i]) == s.end()){    // Not found in MM 
                int val = getLeastRecentlyUsed(temp, s);
                temp = removee(val, temp); //remove val from temp
                s.erase(val); 
                s.insert(pages[i]); 
                temp.push_back(pages[i]); 
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
    cout << "\nPage fault percentage: " << float((float)page_faults/(
    return 0; 
} 
