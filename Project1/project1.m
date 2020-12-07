clc;
clear;
close all;
%% read original image 
Im = imread('Bird feeding 3 low contrast.tif');
[w,h,nChannels] = size(Im);
processed_Im = zeros(size(Im));

%% Figure of intensity transformation function 
table_r_s = zeros(256,2);
min_pro_Im = atan(-128/32);
scale_imag = atan(127/32)- atan(-128/32);
for r = 0:255
    table_r_s(r+1,1) = r; 
    s = atan((r - 128)/32);
    s = s-min_pro_Im;
    s = s / scale_imag;
    s = uint8(s*255);
    table_r_s(r+1,2) = s; 
end
figure;
plot(table_r_s(:,1),table_r_s(:,2))
title('Figure of s = T(r)')
xlabel('r')
ylabel('s')
xlim([0 255])
ylim([0 255])
%% Figure of output image compared to original image
processed_Im(:,:) = (double(Im(:,:))-128)/32;
processed_Im(:,:) = atan(processed_Im(:,:));

processed_Im = processed_Im - min_pro_Im;
processed_Im = processed_Im(:,:)/scale_imag;

result_Im(:,:) = uint8(processed_Im(:,:)*255); 

figure;
subplot(1,2,1);
imshow(Im);
title('Original image');
subplot(1,2,2);
imshow(result_Im);
title('Output image after applying the intensity transformation function');

%% Figure of the origianl and output histograms
figure;
subplot(1,2,1);
ax = gca;
imhist(Im);
ax.YLim = [0 6000];
title('Original image hishogram');
subplot(1,2,2);
ax = gca;
imhist(result_Im)
ax.YLim = [0 10000];
title('Output image hishogram');
