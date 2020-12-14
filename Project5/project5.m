clc;
clear;
close all;
%% read original image 
Im = imread('Car On Mountain Road.tif');
% figure('Name','Original image','NumberTitle','off')
% imshow(Im);
[w,h,nChannels] = size(Im);
Im = im2double(Im);

%% Figures of the LoG image 

%% two thresholds: 0% and 4% the maximum gray level of the LoG image 

%% Figure of Hough parameter space 

%% Figures of linked edges alone and overlapped on the original image
