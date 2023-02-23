% AB2 Lecture2 - Task 1
clear all, close all,clc

%% loading image and segmented blurred object
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
% LEN = 674;
% THETA = 90;
% PSF = fspecial('motion', LEN, THETA);
PSF = zeros(477);
% PSF(239-40:239+40,239) = fspecial('gaussian',[81,1],30); 
PSF(239-40:239+40,239) = fspecial('motion', 81, 90);
% PSF(238-100:238+100,238) = double(blurredIm(2731:2731+200,3757,1))./sum(double(blurredIm(2731:2731+200,3757,1)));
% PSF(:,238) = 1/477;

% PSF = rot90(PSF);
%% Inverse filtering, Wiener deconvolution, Richardson-Lucy deconvolution, regularized filter deconvolution

% OTF = fft2(PSF,size(blurredIm,1),size(blurredIm,2));
% invOTF = (1+1i)./OTF;
% invMTF = abs(invOTF);
% invMTF(invMTF>1) = 1;
% invOTF = invMTF .* exp(1i*angle(invOTF));
% blurredSpec = fft2(blurredIm);
% reconSpec =blurredSpec.*invOTF;
% reconImI = abs(ifft2(reconSpec));
noiseVar = var(rgb2gray(im2double(blurredIm(1608:1608+100,1242:1242+100,:))),0,'all','omitnan');
totalVar = var(rgb2gray(im2double(blurredIm)),0,'all','omitnan');
nsr = noiseVar/totalVar;
reconImW = deconvwnr(blurredIm, PSF, 0.02);
% reconImL = deconvlucy(blurredIm,PSF);
% reconImR = deconvreg(blurredIm,PSF,noiseVar);
% reconImB = deconvblind(blurredIm,ones(size(PSF)),10,0.01);
% plot results
figure
imshowpair(blurredIm,reconImW,'montage')


%% fuse deblurred and original images
deblurredImage = blurredIm;

deblurredImage(BW) = reconImW(BW);
for i = 1:3
    deblurredImage(:,:,i) = medfilt2(deblurredImage(:,:,i),[15 15]);
end
estimatedPSF = PSF;
save('V:\MPA-AB2\Lecture2_23\LosSegmentatores\TASK1\results.mat',"deblurredImage","estimatedPSF")
%% estimate results
[NRMSE_PSF, RMSE_Image, PSNR] = evaluateMotion('V:\MPA-AB2\Lecture2_23\LosSegmentatores\TASK1\results.mat');
