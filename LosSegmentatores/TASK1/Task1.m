% AB2 Lecture2 - Task 1
clear all, close all,clc

%% loading image and segmented blurred object (segmented using Image Segmenter)
blurredIm = imread('image_blurred.png');
load("segmentBlur.mat","BW");

%% showing image and spectra to identify direction of motion
% spectra = fftshift(log(abs(fft2(rgb2gray(blurredIm)))));
% figure(1)
% subplot(2,1,1)
% imshow(blurredIm,[])
% subplot(2,1,2)
% imshow(spectra,[])
%% estimating PSF
PSF = zeros(477);
% PSF(239-40:239+40,239) = fspecial('gaussian',[81,1],40); 
PSF(239-40:239+40,239) = fspecial('motion', 81, 90);
% PSF(238-100:238+100,238) = double(blurredIm(2731:2731+200,3757,1))./sum(double(blurredIm(2731:2731+200,3757,1)));

%%  Wiener deconvolution
noiseVar = var(rgb2gray(im2double(blurredIm(1608:1608+100,1242:1242+100,:))),0,'all','omitnan');
totalVar = var(rgb2gray(im2double(blurredIm)),0,'all','omitnan');
nsr = noiseVar/totalVar;
reconImW = deconvwnr(blurredIm, PSF, nsr);

% plot results
figure
imshowpair(blurredIm,reconImW,'montage')

%% fuse deblurred and original images and postprocess
deblurredImage = blurredIm;

deblurredImage(BW) = reconImW(BW);
for i = 1:3
    deblurredImage(:,:,i) = medfilt2(deblurredImage(:,:,i),[15 15]);
end
estimatedPSF = PSF;
save('V:\MPA-AB2\Lecture2_23\LosSegmentatores\TASK1\results.mat',"deblurredImage","estimatedPSF")
estimatedPSF = uint8(255.*PSF./max(PSF,[],"all"));
imwrite(deblurredImage,'V:\MPA-AB2\Lecture2_23\LosSegmentatores\TASK1\Task1Result.tif')
imwrite(estimatedPSF,'V:\MPA-AB2\Lecture2_23\LosSegmentatores\TASK1\Task1Result.tif','WriteMode','append')

%% estimate results
[NRMSE_PSF, RMSE_Image, PSNR] = evaluateMotion('V:\MPA-AB2\Lecture2_23\LosSegmentatores\TASK1\results.mat');
