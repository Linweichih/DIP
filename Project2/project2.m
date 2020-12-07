clc;
clear;
close all;
%% read original image 
Im = imread('Bird 2.tif');
[w,h,nChannels] = size(Im);
Im = im2double(Im);

%% Plot of DFT magnitude in Log scale
Im_fft = fft2(Im);  
% fftshift func used to center the low frequency in log scale of magnitude 
Im_fft_shift = fftshift(Im_fft);
% log(1)=0,so in log scale we need to add 1
magnitude = log(1+abs(Im_fft_shift));
figure('Name','Plot of DFT magnitude in Log scale','NumberTitle','off');
% mat2gray scale the image's value to 0-1
result_Im = mat2gray(magnitude);
imshow(result_Im);

%% invert the fourier transform to the original image 
invert_Im = real(ifft2(ifftshift(Im_fft_shift)));
%imshow(invert_Im);

%% Image constructed by DFT coefficients inside the circular region with radius = 30 pixels 
Im_center = [w/2,h/2];
cutoff_radious = 30;
lowpass_filter = zeros(size(Im));
for i = 1 : w
    for j = 1 : h
        if ( (Im_center(1)-i)^2+(Im_center(2)-j)^2 ) < cutoff_radious^2
            lowpass_filter(i,j) = 1;
        end
    end
end
processed_fft = lowpass_filter.*Im_fft_shift;
lpf_processed_Im = real(abs(ifft2(ifftshift(processed_fft))));

figure('Name','Image constructed by DFT in radius = 30','NumberTitle','off');
imshow(lpf_processed_Im);
title('Image constructed by DFT in radius = 30')

%% Image constructed by DFT coefficients outside the circular region with radius = 30 pixels
Im_center = [w/2,h/2];
cutoff_radious = 30;
highpass_filter = zeros(size(Im));
for i = 1 : w
    for j = 1 : h
        if ( (Im_center(1)-i)^2+(Im_center(2)-j)^2 ) >= cutoff_radious^2
            highpass_filter(i,j) = 1;
        end
    end
end
processed_fft = highpass_filter.*Im_fft_shift;
hpf_processed_Im = real(abs(ifft2(ifftshift(processed_fft))));

figure('Name','Image constructed by DFT out of radius = 30','NumberTitle','off');
imshow(hpf_processed_Im);
title('Image constructed by DFT out of radius = 30')

%% Table of top 25 DFT frequencies (u,v) in the left half frequency region 
left_half_mag = magnitude(:,1:w/2);
[len,wide] = size(left_half_mag);
magnitude_data = zeros(len*wide,3);
num = 1;
for i = 1 : len
    for j = 1 : wide
        magnitude_data(num,1) = left_half_mag(i,j);
        magnitude_data(num,2) = i;
        magnitude_data(num,3) = j;
        num = num + 1;
    end
end
% sorted_data = [magnitude, u, v]
sorted_data = sortrows(magnitude_data,1,'descend');
% get top 25 data's table
top_25_data = sorted_data(1:25,:);
