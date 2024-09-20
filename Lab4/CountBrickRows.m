function [IMG, nofr]=CountBrickRows(in)
%
% function [IMG, nofr]=CountBrickRows(in)
%
%% Lab4, Task 2
%% Finds the number of rows of bricks
%
% Finds the number of rows of bricks in a brick wall image, that might be
% rotated. Therefore, in the first step, this function rotates the input
% image to the horizontal level. In he second step, the function finds the
% number of rows of bricks.
%
%% Who has done it
%
% Author: Gustav Andersson, Gusan539
% Co-author: Oskar André, oskan166
% 
%
%% Syntax of the function
%      Input arguments:
%           in: the original input color image of type double scaled between 0 and 1
%          
%      Output arguments:
%           IMG: the output color image, which is the input image rotated
%           to the horizontal level.
%           nofr: the number of rows of bricks in the input image
%
% You MUST NEVER change the first line
%
%% Basic version control (in case you need more than one attempt)
%
% Version: 1
% Date: 8/12-2022
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

%% First step of the task. Rotate the input image to the horizontal level
%
%% Make the input color image grayscale, 
% by choosing its most appropriate channel (according to the instructions)


bgray= in(:,:,3); % Gråskala för bilden, vi valde 3 då den hade mest kontrast

%% Lowpass filter your image
M = 5; %Vi ska göra en 5x5 box kernel
lowpass = (M)/(M^2);

bfilt= imfilter(bgray, lowpass, 'symmetric'); % The filtered version of the grayscale image
    
%% Threshold your image
% to separate the mortar joints from the bricks

Otsu = graythresh(bfilt); %threshhold med otsus algoritm

b_thresh=imbinarize(bfilt,Otsu); % The thresholded image

%% Use Hough transform to find the angle corresponding to the principal lines

[H, teta, ~] = hough(b_thresh, 'Rhoresolution',5, 'Theta', -90:0.5:89.5); %Från prep-uppgiften


[~,t] = find(H==max(H(:)));

teta=teta(t); % The angle corresponding to the principal lines (rows of mortar joints)
    
%% Find the angle of rotation, to rotate the image to the horizontal level
% Make sure that you use right sign in front of the angle (positive for
% counterclockwise and negative for clockwise rotation)

trot =(teta-90*sign(teta)); % Angle of rotation.
    % If the rotation is counreclockwise, trot should be positive, otherwise negative. 

%% Rotate the input image to the horizontal level
% This gives you the first output argument of the function

IMG=imrotate(bgray,trot, 'bicubic', 'crop'); % The rotated image to the horizontal level (the first output argument of this funciton)
% Before continuing to the next step, make sure that your code works
% properly so far. See the instructions.

%% Second step of the task. Find the number of rows of bricks
%
%% Rotate the thresholded image to the horizontal level.
% Use nearest interpolation to make sure that the rotated image will be
% binary

b_rot=imrotate(b_thresh,trot,'nearest','crop');% The rotated thresholded image
% View this image, but remove or comment before submitting the
% file
%imshow(b_rot)
%% Find the number of 1:s in each row (and normalize according to the instructions)

sum_row=sum(b_rot')/size(bgray, 2); %Räknar ut summan, transponerar och normaliserar.

% Display this graph by plot, but remove or comment before submitting the
% file

%% Threshold your result according to the instructions
% This is to define a row of mortar joint
%plot(sum_row);

%Vi använder 0.65 eftersom alla peakar i plot var över 0.6
sum_thresh= imbinarize(sum_row,0.65); % The thresholded version of sum_row

% Display this graph by plot, but remove or comment before submitting the
% file

%% Find the number of rows of bricks
% Calculate how many times the above graph (sum_thresh) goes from 0 to 1 by using the
% first derivative according to the instructions
kernel = [-1,1];

antal = conv(sum_thresh,kernel, 'same');

nofr = sum(antal==1)-1 % The number of rows of the bricks (the seond output argument of this function)

%Subtraherar med 1 pga fogen mellan tegelstenarna 

%% Test your code on three test images
% Use the three given test images, brick1.jpg, brick2.jpg and brick3.jpg
% according to the instructions in the document describing this task.
% Your code is supposed to work properly on all three images.