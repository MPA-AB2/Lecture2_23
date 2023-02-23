%%TASK2
clc; clear all; close all;
I = im2double(imread('image_blurred.png'));
blurred = I;

BW=zeros(size(I));
BWmonitor=imread('BWmonitor.png');
BWstojatavec=imread('BWstojatavec.png');
for i=1:3
    BW_pom=BW(:,:,i);
    BW_pom(BWmonitor==1)=1;
    BW_pom(BWstojatavec==1)=1;
    BW(:,:,i)=BW_pom;
end

%imageSegmenter(I)
%imwrite(BWmonitor,'BWmonitor.png')


LEN = 120;
THETA = 90;
PSF_org = fspecial('motion', LEN, THETA);
% H = fspecial('gaussian',81,60);
% PSF_org=H(:,76);
% PSF_org=PSF_org./sum(PSF_org);
PSF=zeros(477,477);
PSF((239-(LEN/2)):((239-(LEN/2))+LEN), 239)=PSF_org;


figure
imshow(PSF, [])

% 
% noise_mean = 0;
% noise_var = 0.001;
% estimated_nsr = noise_var / var(I(:));
% NUMIT=3;
% V = .0001;
% wnr3 = deconvlucy(I,PSF,NUMIT,sqrt(V));
% %wnr3 = deconvwnr(I, PSF, estimated_nsr);
%num_iterations = 2;
% wnr3 = deconvblind(blurred, PSF, num_iterations);
%psfr = zeros(477);
%[wnr3,psfr] = deconvblind(blurred, PSF, num_iterations);


INITPSF = ones(477);
[wnr3 P] = deconvblind(I,INITPSF,2);
%figure
%imshow(J)
%title('Restored Image')
figure
imshow(P,[])




for i=1:3456
    for i2=1:5184
        if (BW(i,i2)==0)
            wnr3(i,i2,:)=I(i,i2,:);
        end
    end
end

% Display the original, blurred, and deblurred images
subplot(1, 2, 1);
imshow(blurred);
title('Blurred Image');
subplot(1, 2,2);
imshow(wnr3);
title('Deblurred Image');



estimatedPSF=P;
deblurredImage=uint8(wnr3.*255);

save pokus.mat estimatedPSF deblurredImage


[NRMSE_PSF, RMSE_Image, PSNR] = evaluateMotion('pokus.mat')
