function [olp, ohp]=FilterFreq(f, D0)
%
% function [olp, ohp]=FilterFreq(f, D0)
%
%% Lab3, Task 2
%
%% Performs filtering in the frequency domain
%
% Lowpass and highpass filters the image in the frequency domain by
% a Gaussian filter constructed in the frequency domain
%
%% Who has done it
%
% Author: Oskar André - Oskan166
% Co-author: Gustav Andersson - Gusan539
%
%
%% Syntax of the function
%      Input arguments:
%           f: the original input grayscale image of type double scaled
%               between 0 and 1
%           D0: The cutoff frequency of the Gaussian lowpass filter
%
%      Output arguments:
%           olp: the result after lowpass filtering the input image by
%                the Gaussian lowpass filter
%           ohp: the result after highpass filtering the input image by
%                the Gaussian highpass filter
%
% You MUST NEVER change the first line
%
%% Basic version control (in case you need more than one attempt)
%
% Version: 1
% Date: 2022-12-05
%
% Gives a history of your submission to Lisam.
% Version and date for this function have to be updated before each
% submission to Lisam (in case you need more than one attempt)
%
%% General rules
%
% 1) Don't change the structure of the template by removing %% lines
%
% 2) Document what you are doing using comments
%
% 3) Before submitting make the code readable by using automatic indentation
%       ctrl-a / ctrl-i
%
% 4) Often you must do something else between the given commands in the
%       template
%
%% Here starts your code.
% Write the appropriate MATLAB commands right after each comment below.
%
%% zero pad the input image
% The input image is zero padded to an image of size P x Q, where P = 2M and
% Q = 2N (M x N is the size of the input image). Notice that the input
% image has to be placed at the top-left corner of the zero-padded image.
[M,N] = size(f);
P = 2*M;        %Enligt instruktioner
Q = 2*N;

fp= zeros(P,Q); % PxQ matrix med nollor

fp(1:M, 1:N) = f; % the zero padded image

%% construct the Gaussian lowpass filter transfer function
% If you want, you can write a separate function to construct the Gaussian filter.
% If you do so, don't forget to submit that MATLAB function as well.
%
% The transfer function is supposed to be the same size as the padded image
% that is P x Q
% The cutoff frequency of this filter, D0, is the second input argument of
% this MATLAB function

[X,Y] = meshgrid(0:P-1, 0:Q-1); %skapar två matriser
X = X';   %Transpose
Y = Y';   %Transpose

P2 = floor(P/2);
Q2 = floor(Q/2);

%Gjord enligt slides chap 8, slide 108 & 104
D= sqrt((X-P2).^2+(Y-Q2).^2);

GLPF= exp((-D.^2)/(2*D0.^2)) % the Gaussian lowpass filter transfer function

%% Perform filtering in the frequency domain
% Find the product between the filter transfer function and the Fourier
% transform of the padded image (Notice that the zero frequency is supposed
% to be shifted to the center of the Fourier transform)

F = fftshift(fft2(fp)); %ränkna dft och sen fftshift
% add filter
OLP= GLPF.*F; % The Fourier transform of the lowpass filtered image

%% Find the padded lowpass filtered image
% The zero frequency of OLP should be shifted back to the top left corner of the
% image followed by the inverse Fourier transform. Take the real part of
% the result.

olpf= real(ifft2(ifftshift(OLP))); % The padded lowpass filtered image of size P x Q

%% Find the lowpass filtered image
% Extract the final lowpass filtered image from the padded lowpass filtered
% image

olp= olpf(1:M, 1:N); % The final lowpass filtered image

%% Find the final highpass filtered image
% Read the document for this task
%f(highpass)=f(original)-f(lowpass)
ohp= f-olp;  % The final highpass filtered image

%% Test your code
%
% Test your code on different images (for example Einstein1.jpg,
% Einstein2.jpg or characterTestPattern.tif) using different cutoff
% frequencies and look at the result of lowpass filtering and highpass
% filtering the original image. Ask yourself, what happens if you increase
% the cutoff frequency (the second input argument of your function). Will the
% result be blurrier or less blurry? Test it and see whether or not you are
% correct. Hopefully, you are not surprised by the result, if you are,
% discuss it with your classmates or the teachers.

% lägre cutoff freq ger mer blur (brantare kurva).
