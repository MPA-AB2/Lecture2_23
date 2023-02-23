clc,clear all,close all
%task2 (něco i task1)
img = im2double(imread('image_blurred.png'));
segmented = im2double(imread('OstrihanaZ.png'));
figure
imshow(img,[])
%%
imgR=img(:,:,1);
imgG=img(:,:,2);
imgB=img(:,:,3);

imgR = medfilt2(imgR,[5 5]);
imgG = medfilt2(imgG,[5 5]);
imgB = medfilt2(imgB,[5 5]);

imn = zeros(3456,5184,3);
imn(:,:,1) = imgR;
imn(:,:,2) = imgG;
imn(:,:,3) = imgB;

flt=fspecial('motion',70,0);

[outR,PSFR] = deconvblind(imgR,flt,10);
[outG,PSFG] = deconvblind(imgG,flt,10);
[outB,PSFB] = deconvblind(imgB,flt,10);

[imgR,s]=size(outR);
out=zeros(imgR,s,3);
out(:,:,1)=outR;
out(:,:,2)=outG;
out(:,:,3)=outB;

zel = segmented(1877,4930,:);

imn(segmented == zel)=out(segmented == zel);

figure
imshow(imn)

%%
obrnew = imn*255;
%%

PSF = zeros(477);
PSF(204:274,239) = PSFG';
deblurredImage = uint8(obrnew);
estimatedPSF = PSF;
%figure
%imshow(out,[])


