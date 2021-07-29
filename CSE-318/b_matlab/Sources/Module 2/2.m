% Programs from index 4, 5, and 6

% Program number 4

N = input('input n:');
X = input('input x:');
sum_series = Series(N,X);
fprintf("Sum of series is: %d\n", sum_series);

function [Sum]= Series(N,X)
  	Sum= 1
 	for i= 1:N
  	    Sum += (1/i)*(X^i);
  	end
end

% Program number 5

a = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
b = [];
for i = 1:15
    if mod(a(i),2)==0
        b(i) = 1;
    else 
        b(i) = 0;
    end
end
fprintf("%d ",b);
fprintf("\n");

% Program number 6

N = input("Enter the number: ");
a =['zero';'one';'two';'three';'four';'five';'six';'seven';'eight';'nine'];
if(N>=0 && N<=9)
   fprintf("Number is: ");
   fprintf(a(N+1, 1:end));
   fprintf("\n");
else
  fprintf("Enter value between 0 and 9");
end
