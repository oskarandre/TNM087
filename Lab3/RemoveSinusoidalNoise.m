function out=RemoveSinusoidalNoise(in,D0)
%
% function out=RemoveSinusoidalNoise(in,D0)
%
%% Lab3, Task 3
%
%% Removes the most dominant sinusoidal noise
%
% Removes the most dominant sinusoidal noise by applying a Butterworth
% Notch Reject filter in the frequency domain
%
%% Who has done it
%
% Author: Oskar André, oskan166
% Co-author: Gustav Andersson, Gusan539
% the other member of the group
%
%% Syntax of the function
%      Input arguments:
%           in: the original input grayscale image (which is corrupted by
%           sinusoidal noises) of type double scaled between 0 and 1.
%           D0: The bandreject width of the Notch filter being constructed
%
%      Output argument:
%           out: the output image where the most dominant sinusoidal noise
%           is eliminated from the input image
%
% You MUST NEVER change the first line
%
%% Basic version control (in case you need more than one attempt)
%
% Version: 1
% Date: 5/12-2022
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
%% Localize the most dominant sinusoidal noise
% The peaks of sinusoidal noises come in pair. You are supposed to find
% the most dominant pair. Actually, it is enough if you locate one of these two.
% In the Notch filter, however, you will create notches at both of them.
% Read the pdf document related to this task for help.


F = fftshift(fft2(in));% the Fourier transform of the image followed by fftshift

F2 = abs(F); % The spectrum/magnitude of F
    
% Set the pixel values at the center and a neighborhood around it in F2 to a small number (for example 0)
% and find the position of one of the dominant peaks.

[P,Q] = size(in);

midRow = floor((P/2)+1);
midCol = floor((Q/2)+1);

F2((midRow-1:midRow+1),(midCol-1:midCol+1)) = 0;

[~,I] = max(F2(:));

[rPos, cPos] = ind2sub(size(F2),I);

r = rPos; % the row number of one the two dominant peaks
c= cPos; % the column number of the same peak as above
    
%% Construct Notch filter
%
%% Find uk and vk to construct the Butterworth bandreject filter
% Use the position of one of the peaks to find uk and vk, which indicate the
% position of the found maximum relative the center of the spectrum.
%
% In the lecture notes for Chapter 5, you can find more explanation on what uk
% and vk are
%

uk= r - midRow; % uk and vk are the positions of the peaks relative the center of the spectrum
vk= c - midCol; %
    

%% Construct the Butterworth Bandreject Notch filter
% If you want, you can write a separate function to construct the Notch filter.
% If you do so, don't forget to submit that MATLAB function as well.
%
% You have already created Gaussian filter transfer functions in Task2 of this lab.
% It is done similarly. In the lecture notes for Chapter 5, you can find
% good examples on how to create such a filter transfer function

n=2; % as specified in the task, the order should be 2

%From lecture 7, page 29
[X, Y] = meshgrid(0:P-1, 0:Q-1);
X = X'; 
Y = Y';
Dk = sqrt((X-floor(P/2)-uk).^2 +(Y-floor(Q/2)-vk).^2);
D_k = sqrt((X-floor(P/2)+uk).^2 +(Y-floor(Q/2)+vk).^2);

H=(1./(1+(D0./Dk).^n)).*(1./(1+(D0./D_k).^n)); % The filter transfer function of the Notch bandreject filter
    
%% Create the output image
% Apply the Notch filter on the input image in the frequency domain, and go
% back to the spatial domain to obtain the output image

%filtering applies.
result = F.*H;


out= real(ifft2(ifftshift(result))); % the final output image, where the most dominant sinusoidal noise is eliminated

imshow(in)
figure
imshow(out)
%% Test your code
% Test your code using at least five different test images as specified in
% the pdf document for this task
%
%% Answer this question:
% For image Einstein_sinus_1, What is the smallest D0 that removes the noise almost completely?
%   vid D0= 13 är det nästan helt borta. Man kan säkert komma undan med 11
%   för ett otränat öga.