clc;
clear;
close all;
%% read original image 
Im = imread('Bird 3 blurred.tif');
[w,h,nChannels] = size(Im);
Im = im2double(Im);

%% Figures of R, G, B, H , S and I component images
HSI = rgb2hsi(Im);
R_component = Im(:,:,1);
G_component = Im(:,:,2);
B_component = Im(:,:,3);
H_component = HSI(:,:,1);
S_component = HSI(:,:,2);
I_component = HSI(:,:,3);
figure('Name','Figures of R, G, B, H , S and I component images','NumberTitle','off');
subplot(2,3,1);
imshow(R_component);
title('R component image')
subplot(2,3,2);
imshow(G_component);
title('G component image')
subplot(2,3,3);
imshow(B_component);
title('B component image')
subplot(2,3,4);
imshow(H_component);
title('H component image')
subplot(2,3,5);
imshow(S_component);
title('S component image')
subplot(2,3,6);
imshow(I_component);
title('I component image')

%% Figures of RGB based (15%) and HSI based (15%) sharpened images and their  difference image (10%)
lap_kernal = [  -1 -1 -1;
                -1 8 -1;
                -1 -1 -1];
% RGB filter filter each channel
Im_RGB_filter_process = Im + cat(3,filter2(lap_kernal,R_component),...
                                    filter2(lap_kernal,G_component),...
                                    filter2(lap_kernal,B_component));
figure('Name','Figures of RGB based and HSI based sharpened images and their difference image','NumberTitle','off');
subplot(1,3,1);
imshow(Im_RGB_filter_process);
title('RGB based sharpened image')
% HSI filter filter Intensity component 
Im_HSI_filter_process = cat(3,filter2(lap_kernal,H_component) + H_component,...
                            filter2(lap_kernal,S_component) + S_component,...
                            filter2(lap_kernal,I_component)+I_component);
Im_HSI_filter_process = hsi2rgb(Im_HSI_filter_process);
subplot(1,3,2);
imshow(Im_HSI_filter_process);
title('HSI based sharpened image')
% difference

%% function of hsi2rgb and rgb2hsi
function HSI = rgb2hsi(rgb)
    R_component = rgb(:,:,1);
    G_component = rgb(:,:,2);
    B_component = rgb(:,:,3);

    %Hue 
    child = 1/2*((R_component-G_component)+(R_component-B_component));
    parent = ((R_component-G_component).^2+((R_component-B_component).*(G_component-B_component))).^0.5;
    theta = acosd(child./(parent+0.0000000001));
    % if B>G ,H = 360 - theta
    theta(B_component>G_component) = 360 - theta(B_component>G_component);
    H_component = theta/360;
    %Saturation
    S_component=1- (3./(sum(rgb,3)+0.0000000001)).*min(rgb,[],3);
    %Intensity
    I_component=sum(rgb,3)./3;
    HSI = cat(3,H_component,S_component,I_component);
end
function rgb = hsi2rgb(hsi)
    H_component = hsi(:,:,1);
    S_component = hsi(:,:,2);
    I_component = hsi(:,:,3);
    H_component = H_component * 360;
    B(H_component<120)=I_component(H_component<120).*(1-S_component(H_component<120));  
    R(H_component<120)=I_component(H_component<120).*(1+((S1(H_component<120).*cosd(H_component(H_component<120)))./cosd(60-H_component(H_component<120))));  
    G(H_component<120)=3.*I_component(H_component<120)-(R(H_component<120)+B(H_component<120)); 
    
    rgb = cat(3,R,G,B);
    
end

