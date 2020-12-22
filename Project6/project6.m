clc;
clear;
close all;
%% read original image 
Im = imread('fruit on tree.tif');
% figure('Name','Original image','NumberTitle','off')
imshow(Im);
[w,h,nChannels] = size(Im);
Im = im2double(Im);
