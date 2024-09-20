function [A]=LogTrans(f)

F =fftshift(fft2(f));
A = log(1+abs(F));
A = A/max(A(:));
imshow(A);
