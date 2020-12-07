clc;
clear;
close all;
%% read original image 
Im = imread('Bird 2 degraded.tif');
% figure('Name','Original image','NumberTitle','off')
% imshow(Im);
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

%% Figure of the Fourier magnitude (frequency response) of degradation model H(u,v)

Im_center = [w/2,h/2];
de_model = zeros(size(Im));
k = 0.001;
for v = 1 : w
    for u = 1 : h
        de_model(u,v) = exp(-1*k*((u-h/2)^2+(v-w/2)^2)^(5/6));
    end
end
de_mag = log(1+abs(de_model));
result_de_Im = mat2gray(de_mag);
figure('Name','Figure of the Fourier magnitude (frequency response) of degradation model','NumberTitle','off');
imshow(result_de_Im);

%% Figures of the output images using different radii (50, 85, 120) of inverse filtering 
inverse_de_model = zeros(size(Im));
for v = 1 : w
    for u = 1 : h          
        inverse_de_model(u,v) = exp(k*((u-h/2)^2+(v-w/2)^2)^(5/6));
    end
end
inverse_de_mag = log(1+abs(inverse_de_model));
result_inv_de_Im = mat2gray(inverse_de_mag);
figure('Name','Figure of the Fourier magnitude (frequency response) of inverse degradation model','NumberTitle','off');
imshow(result_inv_de_Im);

%Butterwurth low pass filter
for cutoff_radious = 50:35:120
    BLPF = zeros(size(Im));
    for v = 1 : w
        for u = 1 : h          
            BLPF(u,v) = 1/(1+(sqrt((Im_center(1)-v)^2+(Im_center(2)-u)^2)/cutoff_radious)^20);
        end
    end
    result_fft = Im_fft_shift.*inverse_de_model.*BLPF;
    inversed_Im = real(ifft2(ifftshift(result_fft)));
    title_text = append('Image inversed in inverse degradation radius = ', int2str(cutoff_radious));
    figure('Name',title_text,'NumberTitle','off');
    imshow(inversed_Im);
    title(title_text)
end




