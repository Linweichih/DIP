clc;
clear;
close all;
%% read original image 
Im = imread('fruit on tree.tif');
% figure('Name','Original image','NumberTitle','off')
% imshow(Im);
[w,h,nChannels] = size(Im);
%Im = im2double(Im);

%% extract R component and Plot of the curve of between-class variance depending on all possible threshold values
R_Im = Im(:,:,1);
K = 256;
cts = zeros(K,1);
for i = 1:w
    for j = 1:h
        cts(R_Im(i,j)+1) = cts(R_Im(i,j)+1) + 1;
    end
end
p = cts / sum(cts);
between_class_var = zeros(K,1);
varB = zeros(K,1);
for k = 1:K-1
    P1 = sum(p(1:k));
    P2 = 1 - P1;
    m1 = sum(p(1:k).*(1:k)')/P1;
    m2 = sum(p(k+1:K).*(k+1:K)')/P2;
    between_class_var(k) = P1*P2*(m1-m2)^2;
end
figure('Name','The curve of between-class variance','NumberTitle','off')
axes = plot(between_class_var);
title('The curve of between-class variance')
axis([0 256 0 4500])
legend('between-class variance')

%% Image of patterns extracted by Otsu algorithm (plotted in the same way as the color-slicing example shown below)
index = find(between_class_var == max(between_class_var));
new_filter_R = zeros(size(R_Im));
bw = imbinarize(R_Im,(index-1)/(K-1));
bw = double(bw);
%imshow(bw)
filter_Im = zeros(size(Im));
for i = 1:w
    for j = 1:h
        if bw(i,j) == 1
            filter_Im(i,j,1) = 1;
        else
            filter_Im(i,j,1) = 0.5;
            filter_Im(i,j,2) = 0.5;
            filter_Im(i,j,3) = 0.5;
        end
            
    end
end
figure('Name','Image of patterns extracted by Otsu algorithm','NumberTitle','off')
imshow(filter_Im)
title('Image of patterns extracted by Otsu algorithm')
%% Images of patterns extracted by K-means clustering with different threshold values (plotted in the same way as the colorslicingexample shown below)
threshold = [1,5,10];
for T = threshold
    [L,C] = imsegkmeans(Im,2,'Threshold',T);
    filter_Im = zeros(size(Im));
    for i = 1:w
        for j = 1:h
            if L(i,j) == 2
                filter_Im(i,j,1) = 1;
            else
                filter_Im(i,j,1) = 0.5;
                filter_Im(i,j,2) = 0.5;
                filter_Im(i,j,3) = 0.5;
            end

        end
    end
    figure;
    imshow(filter_Im);
    title('Images of patterns extracted by K-means clustering with threshold value='+string(T))
end
