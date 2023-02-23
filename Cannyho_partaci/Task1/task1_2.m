obr = imread('image_blurred.png');
% gray = rgb2gray(obr);
LEN = 10; THETA = 90;
PSF = fspecial('motion', LEN, THETA);
estimatedPSF = zeros(477,477);
estimatedPSF(round(477/2):round(477/2)+LEN,round(477/2)) = PSF;
% PSF2(PSF2>0) = 1;
% estimatedPSF = imrotate(estimatedPSF,-45);

filtered = deconvlucy(obr,estimatedPSF);
%imshow(filtered)
filtered_gauss = imgaussfilt(filtered,4);
filtered_nlm = imnlmfilt(filtered_gauss);

imshow(filtered_nlm)