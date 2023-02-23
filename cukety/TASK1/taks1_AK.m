% 23.2.2023
clear all; close all; clc;

%% nacteni obrazku
im = im2double(imread('Lecture2_data\image_blurred.png'));
% figure; imshow(im);
imR = im(:,:,1);
imG = im(:,:,2);
imB = im(:,:,3);

%% PSF
PSF = load('npsf_verze2.mat');
PSF = PSF.npsf;
% PSF = fspecial('motion',21,11);

%% SEGMENTACE
t = load('table.mat'); seg = double(t.table);
h = load('human.mat'); human = double(h.human);
% imshow(table)
% im_t = imfuse(table, im); %fuze obrazu
% imshow(im_t);

%% inverse filter
% hf = fft2(PSF,size(im,1),size(im,2));      
% m_deblur = real(ifft2(fft2(im)./hf));
% imshow(m_deblur)

%% deconvoluce TV
ima=max(im(:));
imi=min(im(:));
ims=std(im(:));
% snr=10*log((ima-imi)./ims); % 13,7201
snr = 10;
outR = deconvtvl2(imR, PSF, snr);
outG = deconvtvl2(imG, PSF, snr);
outB = deconvtvl2(imB, PSF, snr);
deblur = [];
deblur(:,:,1) = outR.f;
deblur(:,:,2) = outG.f;
deblur(:,:,3) = outB.f;
figure(); imshow(deblur)

%% Wiener filter

% Idouble = im2double(im);
% blurred = imfilter(Idouble,PSF,'conv','circular');
% figure; subplot 231; imshow(im); title('Blurred Image')
% 
% wnr1 = deconvwnr(im,PSF);
% subplot 232; imshow(wnr1);  title('Restored Blurred Image')
% 
% wnr2 = deconvwnr(im,PSF);
% subplot 233; imshow(wnr2); title('Restoration of Blurred Noisy Image (NSR = 0)')
% 
% noise_mean = 0;
% noise_var = 0.001;
% signal_var = var(Idouble(:));
% NSR = noise_var / signal_var;
% wnr3 = deconvwnr(im,PSF,NSR);
% subplot 234; imshow(wnr3)
% title('Restoration of Blurred Noisy Image (Estimated NSR)')
% 
% uniform_quantization_var = (1/256)^2 / 12;
% signal_var = var(Idouble(:));
% NSR = uniform_quantization_var / signal_var;
% wnr5 = deconvwnr(im,PSF,NSR);
% subplot 235; imshow(wnr5); title('Restoration of Blurred Quantized Image (Estimated NSR)');

%% Lucy-Richardson method
% J = deconvlucy(im,PSF);
% imshow(J);

%% 
%% filter image
% LEN = 60;    % the length of the motion
% THETA = 82;  % the angle of motion
% PSF = fspecial('motion', LEN, THETA);
% blurred_image = imfilter(im, PSF, 'conv', 'circular');
% 
% % add noise
% noise_mean = 0;      % mean of noise
% noise_var = 0.0002;  % variance of noise
% blurred_noisy_image = imnoise(blurred_image, 'gaussian',...
%     noise_mean, noise_var);
% 
% % deblur image using Wiener filter
% noise_to_signal_ratio = noise_var / var(grey_image(:));
% restored_image = deconvwnr(blurred_noisy_image, PSF,...
%     noise_to_signal_ratio);
% 
% figure;
% imshow(restored_image);

%% fuse
deblurSeg1 = deblur(:,:,1);
deblurSeg2 = deblur(:,:,2);
deblurSeg3 = deblur(:,:,3);
deblurSeg1(seg == 0) = 0;
deblurSeg2(seg == 0) = 0;
deblurSeg3(seg == 0) = 0;
deblurSeg = deblur;
deblurSeg(:,:,1) = deblurSeg1;
deblurSeg(:,:,2) = deblurSeg2;
deblurSeg(:,:,3) = deblurSeg3;
imshow(deblurSeg)

final1 = im(:,:,1);
final2 = im(:,:,2);
final3 = im(:,:,3);
final1(deblurSeg1 ~= 0) = deblurSeg1(deblurSeg1~= 0);
final2(deblurSeg2 ~= 0) = deblurSeg2(deblurSeg2~= 0);
final3(deblurSeg3 ~= 0) = deblurSeg3(deblurSeg3~= 0);
final = im;
final(:,:,1) = final1;
final(:,:,2) = final2;
final(:,:,3) = final3;
imshow(final)

%% evaluace
estimatedPSF = load("npsf_verze2.mat");
estimatedPSF = estimatedPSF.npsf;
deblurredImage = uint8(final*255);
%%


[NRMSE_PSF, RMSE_Image, PSNR] = evaluateMotion("C:\Users\xkadlu02\Desktop\Lecture2_23-cukety\Lecture2_23-cukety\cukety\TASK1\Lecture2_data\vysledky3.mat")

