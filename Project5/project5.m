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
LoG_kernal = fspecial('log', 25, 4);
LoG_Im = imfilter(Im, LoG_kernal);
% LoG_Im = mat2gray(LoG_Im);
figure('Name','Figures of the LoG image','NumberTitle','off');
imshow(mat2gray(LoG_Im));
%% two thresholds: 0% and 4% the maximum gray level of the LoG image 
max_log = max(LoG_Im,[],'all');
LoG_0_Im = zeros(size(Im));
LoG_0_Im(LoG_Im > 0) = 1;
LoG_4_Im = zeros(size(Im));
LoG_4_Im(LoG_Im > (0.04*max_log)) = 1;
BW_edge = edge(LoG_4_Im,'Canny');
%% Figure of Hough parameter space 
[H,Theta,Rho] = hough(BW_edge);
figure
imshow(H,[],'XData',Theta,'YData',Rho,'InitialMagnification','fit');
xlabel('\theta')
ylabel('\rho');
axis on, axis normal,hold on;
%% Figures of linked edges alone and overlapped on the original image
P  = houghpeaks(H,2);
x = Theta(P(:,2)); 
y = Rho(P(:,1));
plot(x,y,'s','color','r');
% lines = houghlines(BW_edge,Theta,Rho,P,'MinLength',10);
% figure, imshow(LoG_4_Im), hold on
% max_len = 0;
% for k = 1:length(lines)
%  xy = [lines(k).point1; lines(k).point2];
%  plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','r');
% end

