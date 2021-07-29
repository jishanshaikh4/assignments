% Program of index 13, and 14.

% 13. Given a matrix M=[1,3,5,2,4,6,7,8,3,9]. Find the elements in the matrix M that are greater than 4 and replace each one with its square root. Use both explict loop and logical indexing.
 
Matrix = [1, 3, 5, 2, 4, 6, 7, 8, 3, 9];
len_M = length(Matrix);
for i = 1:len_M
  if Matrix(i) > 4
    Matrix(i)= sqrt(Matrix(i));
  end
  fprintf("%d, ", Matrix(i));
end
Output- [1, 3, 2.23, 2, 4, 2.44, 2.64, 2.82, 3, 3]

% 14. Solve the following equations using Matlab.
%	X1    	+	 3X2         		= 19
%	4X1	 +	 2X2  	+ 	5X3	= 26
%			7X2	–	 10X3	 = 35

syms x1 x2 x3;
eqn1 = x1 + 3*x2 == 19;
eqn2 = 4*x1 + 2*x2 + 5*x3 == 26;
eqn3 = 7*x2 - 10*x3 == 35;
sol = solve([eqn1,eqn2,eqn3],[x1,x2,x3]);
x1sol = sol.x1;
x2sol = sol.x2;
x3sol = sol.x3;
fprintf("x1= %d, x2= %d, x3= %d\n", x1sol,x2sol,x3sol);
