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
n = 7;
sigma = 4;
LoG_kernal = fspecial('log', n,sigma);
LoG_Im = filter2(LoG_kernal,Im);

figure('Name','Figures of the LoG image ','NumberTitle','off');
imshow(mat2gray(LoG_Im));

%% two thresholds: 0% and 4% the maximum gray level of the LoG image
max_log = max(LoG_Im,[],'all');
LoG_0_Im = edge(LoG_Im,'zerocross',0);
LoG_4_Im = edge(LoG_Im,'zerocross',0.04*max_log);
figure('Name','0% the maximum gray level of the LoG image','NumberTitle','off');
imshow(LoG_0_Im);
figure('Name','4% the maximum gray level of the LoG image','NumberTitle','off');
imshow(LoG_4_Im);

%% Figure of Hough parameter space 
[H,Theta,Rho] = hough(LoG_4_Im,'Theta',-90:1:89);
figure
imshow(H,[],'XData',Theta,'YData',Rho,'InitialMagnification','fit');
xlabel('\theta')
ylabel('\rho');
axis on, axis normal,hold on;
%% Figures of linked edges alone and overlapped on the original image
P = houghpeaks(H,2000,'Threshold',0.00001*max(H(:)));
x = Theta(P(:,2)); 
y = Rho(P(:,1));
% plot(x,y,'s','color','r');
lines = houghlines(LoG_4_Im,Theta,Rho,P,'FillGap',3,'MinLength',6);
figure,imshow(LoG_Im), hold on
for k = 1:length(lines)
 xy = [lines(k).point1; lines(k).point2];
 plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','r');
end
figure, imshow(Im), hold on
for k = 1:length(lines)
 xy = [lines(k).point1; lines(k).point2];
 plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','r');
end

