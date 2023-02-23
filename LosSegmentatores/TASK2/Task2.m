clear
clc
% load data
im = imread("image_blurred.png");
deblurredPathName = "C:\Users\Jan Šíma\Desktop\AB2-L2";
load("segmentBlur.mat")


%% Výřez s rozmazanou hranou
v8 = im(2500:3000,3100:3600,:);
% Odhad PSF pro celý obraz
psf = ones(477);
[j8,psf8] = deconvblind(v8,psf,10);

%% Aplikace PSF na celý obraz
[ImOut,psfIM] = deconvblind(im,psf8,5);
imshowpair(im,ImOut,"montage")
% Použití pouze v oblasti masky
imFinal = im;
imFinal(BW==1) = ImOut(BW==1);
% mediánová filtrace
deblurredImage = medfilt3(imFinal,[7 7 3]);
estimatedPSF = psfIM;
save("Result.mat","deblurredImage","estimatedPSF")
estimatedPSF = uint8(255.*psfIM./max(psfIM,[],"all"));
% testovací funkce
[NRMSE_PSF, RMSE_Image, PSNR] = evaluateMotion(fullfile(deblurredPathName,"Result.mat"));
% zapsání do TIFF
imwrite(deblurredImage,fullfile(deblurredPathName,"Tsk2Result.tiff"))
imwrite(estimatedPSF,fullfile(deblurredPathName,"Tsk2Result.tiff"),"WriteMode","append")




