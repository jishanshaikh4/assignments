% Programs of index 10, 11, and 12.

% 10. Write a MATLAB program to widen a image.

FirstImage = imread('blue.jpeg');
[rows columns] = size(FirstImage);
subplot(2, 1, 1);
imshow(FirstImage);
newWidth = [1,1.5 * columns]
subplot(2, 1, 2);
imshow(FirstImage, 'XData', newWidth);

% 11. Write a MATLAB program to crop an image.

image = imread('blue.jpeg');
subplot(2,1,1);
imshow(image);
[rows,columns]= size(image);
croped_image= imcrop(image,[x1 x2 y1 y2]);
subplot(2,1,2);
imshow(croped_image);

% 12. Write a MATLAB program for elliptical masking in an image. After forming elliptical shape crop the image.

I = imread('blue.jpeg');
subplot(2,1,1);
imshow(I)
J = elliptical_masker(I,40,90,100,350);
subplot(2,1,2);
imshow(J)
function im = elliptical_masker(im,c1,c2,r1,r2);
 	[M,N,K] = size(im);
 	for i1 = 1:M
  	   for i2 = 1:N
    	        if((i1-c1)/r1)^2 + ((i2-c2)/r2)^2 >= 1
     		  	im(i1,i2,:)=0;
     	        end
   	   end
      end
end
