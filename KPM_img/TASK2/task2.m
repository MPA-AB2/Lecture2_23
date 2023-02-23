clc,clear all,close all
%task2 (něco i task1)
img = im2double(imread('V:\main\Lecture2_23\Lecture2_data\image_blurred.png'));
figure
imshow(img,[])
%%
imgR=img(:,:,1);
imgG=img(:,:,2);
imgB=img(:,:,3);
flt=fspecial('motion',70,0);

[outR,PSFR] = deconvblind(imgR,flt,10);
[outG,PSFG] = deconvblind(imgG,flt,10);
[outB,PSFB] = deconvblind(imgB,flt,10);

[r,s]=size(outR);
out=zeros(r,s,3);
out(:,:,1)=outR;
out(:,:,2)=outG;
out(:,:,3)=outB;
figure
imshow(out,[])


%%
[outR,PSFR] = deconvblind(imgR,PSFR,10);
[outG,PSFG] = deconvblind(imgG,PSFG,10);
[outB,PSFB] = deconvblind(imgB,PSFB,10);

[r,s]=size(outR);
out=zeros(r,s,3);
out(:,:,1)=outR;
out(:,:,2)=outG;
out(:,:,3)=outB;
figure
imshow(out,[])
%%
tic
outR = deconvlucy(imgR,PSFR,5,0.25);
outG = deconvlucy(imgG,PSFG,5,0.25);
outB = deconvlucy(imgB,PSFB,5,0.25);

out=zeros(r,s,3);
out(:,:,1)=outR;
out(:,:,2)=outG;
out(:,:,3)=outB;
figure
imshow(out,[])
toc
%%
figure
imshow(img)
noise_part=drawrectangle('Position',[800,1000,300,300]);
%%
noise_part=[noise_part.Position(2),noise_part.Position(2)+noise_part.Position(4),noise_part.Position(1),noise_part.Position(1)+noise_part.Position(3)];
noise_part=img(noise_part(1):noise_part(2),noise_part(3):noise_part(4));
V=estimate_noise(noise_part);
outR = deconvreg(imgR,PSFR,V);
outG = deconvreg(imgG,PSFG,V);
outB = deconvreg(imgB,PSFB,V);

out=zeros(r,s,3);
out(:,:,1)=outR;
out(:,:,2)=outG;
out(:,:,3)=outB;
figure
imshow(out,[])
%%
outR = deconvwnr(imgR,PSFR,100);
outG = deconvwnr(imgG,PSFG,100);
outB = deconvwnr(imgB,PSFB,100);

out=zeros(r,s,3);
out(:,:,1)=outR*100;
out(:,:,2)=outG*100;
out(:,:,3)=outB*100;
figure
imshow(out,[])
%%
[outR,PSFR] = deconvblind(outR,PSFR,10);
[outG,PSFG] = deconvblind(outG,PSFG,10);
[outB,PSFB] = deconvblind(outB,PSFB,10);
out=zeros(r,s,3);
out(:,:,1)=outR;
out(:,:,2)=outG;
out(:,:,3)=outB;
figure
imshow(out,[])
%%

[NRMSE_PSF, RMSE_Image, PSNR] = evaluateMotion(deblurredPathName);
