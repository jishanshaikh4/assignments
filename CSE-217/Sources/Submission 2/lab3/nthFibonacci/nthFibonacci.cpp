#include<stdio.h>

int fibo(int);

int main(){
  int num;
  int result;
  printf("Enter the nth number in fibonacci series: ");
  scanf("%d", &num);
  if (num<0){
     printf("Please Enter Positive number!!!\n");
  }
  else{
    result=fibo(num);
    printf("The %d number in fibonacci series is %d\n", num, result);
  }
  return 0;
}

int fibo(int num){
  if (num==0){
    return 0;
   }
  else if(num==1){
    return 1;
   }
  else{
    return(fibo(num - 1)+fibo(num - 2));
   }
}
