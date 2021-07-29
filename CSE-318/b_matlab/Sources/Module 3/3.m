% Programs of index numbers 7, 8, and 9.

% 7. Write a program to find sum of all elements of an array that are divisible by 3.

a= [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
sum=0;
for i = 1:15
     if mod(a(i),3)==0
         sum+=a(i);
     end
end
fprintf("Sum is : %d\n", sum)

% 8. Write a program to find an element in an array using for loop and while loop :
% a. Using for loop:

a = [];
n = input(“Enter size: ”);
for i =1:n
      a(i)= input(“Enter %d th number:”,i);
end
b = input("Enter no to search: ");
flag=0;
for i = 1:n
    if a(i)==b
       fprintf("found at index %d\n",i)
       flag=1;
       break;
    end
end
if flag==0
   fprintf("Not Found\n")
end

% b. Using while loop:

a = [];
n = input(“Enter size: ”);
for i =1:n
      a(i)= input(“Enter %d th number:”,i);
end
b = input("Enter no to search: ");
flag=0;
i = 1;
while i <= n
    if a(i)==b
       fprintf("found at index %d\n",i)
       flag=1
       break;
   end
   i += 1;
end
if flag==0
    fprintf("Not Found\n")
end

% 9.  Write a MATLAB program to change the blue color of feathers in the bluebird image to red color.

img = imread('blue.png');
sizee = size(img);
newimg = img;
for i = 1 : sizee(1)
	for j = 1: sizee(2)
	      if(img(i, j, 3) > mean(img(i, j, :)))
                 newimg(i, j, 1) = img(i, j, 3);
                 newimg(i, j, 2:3) = 0;
            end
      end 
end
imwrite(newimg, 'jishan.png', 'png')
