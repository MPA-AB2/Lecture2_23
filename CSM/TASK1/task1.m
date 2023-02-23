%% MPA-AB2 Lecture2_23_TASK1 Main Script
% Radek Chmela, David Sidlo, Jakub Muller
close all, clear all, clc

% Loading blurred image 
load('maskedImage.mat')
img = maskedImage;

img2 = imread("image_blurred.png");

% montage(img)
% figure(1)
% imshow(img)
%% PSF kernel estimation

PSF2 = zeros(477,477);
kernel = fspecial('motion',15,0);
PSF2((round(477/2))-length(kernel)/2:(round(477/2)-1)+ ...
    length(kernel)/2,round(477/2)-1) = kernel';

% Pseudoinverse filtration
% PSFfft = (1+1i)./(fft2(PSF2,size(img,1),size(img,2)));
PSFfft = (1+1i)./(fft2(PSF2,size(img,1),size(img,2))); % here we could add Wiener Correct Factor 

% Amplitude spectrum of PSF (blurring system)
PSFfftA = abs(PSFfft);
% Amplitude spectrum of PSF (blurring system)
PSFfftP = angle(PSFfft);
for j = 1:size(PSFfftA,1)
    for k = 1:size(PSFfftA,2)
        if PSFfftA(j,k) >= 10
        PSFfftA(j,k) = 10;
        end
    end
end


PSFfft2 = PSFfftA.*exp(1i*PSFfftP);
% imshow(abs(PSFfft2),[])

imgfft = zeros(size(img));

for c = 1:size(img,3)
    imgfft(:,:,c) = fft2(img(:,:,c),size(PSFfft2,1),size(PSFfft2,2));
end

% imgfft(:,:,1) = fft2(img(:,:,3),size(PSFfft2,1),size(PSFfft2,2));


    resImgfft = imgfft.*PSFfft2;

    padarray(resImgfft,[476 476],0,'post');

% Back to spatial domain

resImg = real(ifft2(resImgfft));
resImg = circshift(resImg,[476/2 476/2]);
% imshow(resImg,[])


% Noise filtration

resImg(:,:,1) = imgaussfilt(resImg(:,:,1),10);

resImg(:,:,2) = imgaussfilt(resImg(:,:,2),10);

resImg(:,:,3) = imgaussfilt(resImg(:,:,3),10);

% Substraction of unfiltered segmented image

imgTmp = im2double(img2)-img;
imshow(imgTmp,[])

% Addition of filtered segmented image

imgFinal = uint8((resImg+(imgTmp))*255);
imshow(imgFinal,[])
%% d
figure(3)
subplot(211)
imshow(imgFinal)
subplot(212)
imshow(img)

%% Saving variables for evaluation
estimatedPSF = PSF2;
deblurredImage = imgFinal;
% save("deblurredData2.mat","deblurredImage","estimatedPSF");

%% Evaluation

[NRMSE_PSF, RMSE_Image, PSNR] = evaluateMotion('deblurredData2.mat')






