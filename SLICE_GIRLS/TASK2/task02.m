close all;

addpath('../../Lecture2_data/')
addpath('../../')
blurredIm = imread('image_blurred.png');

figure(1);
subplot 131, imshow(blurredIm)

% Create PSF
estimatedPSF = zeros(477);
estimatedPSF(100:377,239) = 1;
estimatedPSF = estimatedPSF ./ sum(estimatedPSF,'all');
subplot 132, imshow(estimatedPSF,[])

% Load mask
mask = logical(rgb2gray(imread('mask2.png')));
mask = cat(3,mask,mask,mask);

% Crop image
croppedImage = imcrop(blurredIm, [1575 430 1300 1700]);

% Deconvolve
[deblurredImage, psfr] = deconvblind(croppedImage, estimatedPSF, 10);
figure(2); 
subplot 121, imshow(croppedImage)
subplot 122, imshow(deblurredImage)
deblurredImage = deconvlucy(blurredIm,psfr,5);
deblurredImage(~mask) = blurredIm(~mask);
deblurredImage = imgaussfilt(deblurredImage);

% Filter noise
imSmall = imresize(deblurredImage, 0.25);
imSmall = imnlmfilt(imSmall, 'DegreeOfSmoothing', 5, 'SearchWindowSize', 9);
% imSmall = medfilt3(imSmall,[5 5 3]);
deblurredImage = imresize(imSmall, 4);

figure(1);
subplot 132, imshow(psfr,[])
subplot 133, imshow(deblurredImage);
estimatedPSF = psfr;

% Save variables
save('output.mat', 'deblurredImage', 'estimatedPSF');

[NRMSE_PSF, RMSE_Image, PSNR] = evaluateMotion('output.mat')

figure;
subplot 121, imshow(blurredIm)
subplot 122, imshow(deblurredImage)

