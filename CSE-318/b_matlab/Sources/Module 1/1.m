% First three programs

allMarks = [	24, 44, 36;
			52, 57, 68;
			66, 53, 69;
			85, 40, 86;
			15, 47, 25;
			79, 72, 82	];

mechanics= [36;76;73;72;28;91];
allMarks= [allMarks, mechanics]

AllMarks(:, 4) = 0.5 * allMarks(:, 4);

chetan_marks = allMarks(3,:)
for i = 1:4
	fprintf(chetan_marks(i));
totalmarks = sum(chetan_marks);
fprintf(“%d\n”, totalmarks);

deepak_marks = allMarks(4,1:3);
farah_marks = allMarks(6,1:3);
fprintf(“%d\n”, deepak_marks);
fprintf(“%d\n”, farah_marks);

Average_marks = [];
for i = 1:6
  Average_marks(i)= sum(allMarks(i,:))/4;
end
Average_marks= Average_marks';
fprintf(“%d\n”,Average_marks);

Out_of_10 = [];
for i = 1:6
  for j = 1:4
    if j == 4
      Out_of_10(i,j) = 0.2 * allMarks(i,j);
    else
      Out_of_10(i,j) = 0.1 * allMarks(i,j);
    end    
  end  
end
fprintf(Out_of_10);

% 2. Write a script to calculate factorial of a number. Take Input from user.

N = input(‘Enter the number’);
fprintf("%d\n", factorial(N));

% 3. Find Fibonaaci series using using for loop and while loop.

% Using for loop :

N = input('Enter the position of Fibonaaci series');
fib = [];
fib(1) = 0;
fib(2) = 1;
for I = 3:N
	fib(i) = fib(i-1) + fib(i-2); 
end
fprintf("%d\n",fib(N))

% Using while loop :

N = input('Enter the position of fibonaaci series');
fib = [];
fib(1) = 0;
fib(2) = 1;
i=3;
while i<=N
  fib(i) = fib(i-1)+fib(i-2);
     i = i+1;
end
fprintf("%d\n",fib(N));
